/* outcoff.c	output routines for the Netwide Assembler to produce
 *		COFF object files (for DJGPP and Win32)
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"

#if defined(OF_COFF) || defined(OF_WIN32)

/*
 * Notes on COFF:
 *
 * (0) When I say `standard COFF' below, I mean `COFF as output and
 * used by DJGPP'. I assume DJGPP gets it right.
 *
 * (1) Win32 appears to interpret the term `relative relocation'
 * differently from standard COFF. Standard COFF understands a
 * relative relocation to mean that during relocation you add the
 * address of the symbol you're referencing, and subtract the base
 * address of the section you're in. Win32 COFF, by contrast, seems
 * to add the address of the symbol and then subtract the address
 * of THE BYTE AFTER THE RELOCATED DWORD. Hence the two formats are
 * subtly incompatible.
 *
 * (2) Win32 doesn't bother putting any flags in the header flags
 * field (at offset 0x12 into the file).
 *
 * (3) Win32 puts some weird flags into the section header table.
 * It uses flags 0x80000000 (writable), 0x40000000 (readable) and
 * 0x20000000 (executable) in the expected combinations, which
 * standard COFF doesn't seem to bother with, but it also does
 * something else strange: it also flags code sections as
 * 0x00500000 and data/bss as 0x00300000. Even Microsoft's
 * documentation doesn't explain what these things mean. I just go
 * ahead and use them anyway - it seems to work.
 *
 * (4) Both standard COFF and Win32 COFF seem to use the DWORD
 * field directly after the section name in the section header
 * table for something strange: they store what the address of the
 * section start point _would_ be, if you laid all the sections end
 * to end starting at zero. Dunno why. Microsoft's documentation
 * lists this field as "Virtual Size of Section", which doesn't
 * seem to fit at all. In fact, Win32 even includes non-linked
 * sections such as .drectve in this calculation. Not that I can be
 * bothered with those things anyway.
 *
 * (5) Standard COFF does something very strange to common
 * variables: the relocation point for a common variable is as far
 * _before_ the variable as its size stretches out _after_ it. So
 * we must fix up common variable references. Win32 seems to be
 * sensible on this one.
 */

/* Flag which version of COFF we are currently outputting. */
static int win32;

struct Reloc {
    struct Reloc *next;
    long address;		       /* relative to _start_ of section */
    long symbol;		       /* symbol number */
    int relative;		       /* TRUE or FALSE */
};

struct Symbol {
    char name[9];
    long strpos;		       /* string table position of name */
    int section;		       /* section number where it's defined
					* - in COFF codes, not NASM codes */
    int is_global;		       /* is it a global symbol or not? */
    long value;			       /* address, or COMMON variable size */
};

static FILE *coffp;
static efunc error;
static char coff_infile[FILENAME_MAX];

struct Section {
    struct SAA *data;
    unsigned long len;
    int nrelocs;
    long index;
    struct Reloc *head, **tail;
};

static struct Section stext, sdata;
static unsigned long bsslen;
static long bssindex;

static struct SAA *syms;
static unsigned long nsyms;

static struct RAA *bsym, *symval;

static struct SAA *strs;
static unsigned long strslen;

/*
 * The symbol table contains a double entry for the file name, a
 * double entry for each of the three sections, and an absolute
 * symbol referencing address zero, followed by the _real_ symbols.
 * That's nine extra symbols.
 */
#define SYM_INITIAL 9

/*
 * Symbol table indices we can relocate relative to.
 */
#define SYM_ABS_SEG 8
#define SYM_TEXT_SEG 2
#define SYM_DATA_SEG 4
#define SYM_BSS_SEG 6

/*
 * The section header table ends at this offset: 0x14 for the
 * header, plus 0x28 for each of three sections.
 */
#define COFF_HDRS_END 0x8c

static void coff_gen_init(FILE *, efunc);
static void coff_sect_write (struct Section *, unsigned char *,
			     unsigned long);
static void coff_write (void);
static void coff_section_header (char *, long, long, long, long, int, long);
static void coff_write_relocs (struct Section *);
static void coff_write_symbols (void);

static void coff_win32_init(FILE *fp, efunc errfunc, ldfunc ldef) {
    win32 = TRUE;
    (void) ldef;		       /* placate optimisers */
    coff_gen_init(fp, errfunc);
}

static void coff_std_init(FILE *fp, efunc errfunc, ldfunc ldef) {
    win32 = FALSE;
    (void) ldef;		       /* placate optimisers */
    coff_gen_init(fp, errfunc);
}

static void coff_gen_init(FILE *fp, efunc errfunc) {
    coffp = fp;
    error = errfunc;
    stext.data = saa_init(1L); stext.head = NULL; stext.tail = &stext.head;
    sdata.data = saa_init(1L); sdata.head = NULL; sdata.tail = &sdata.head;
    stext.len = sdata.len = bsslen = 0;
    stext.nrelocs = sdata.nrelocs = 0;
    stext.index = seg_alloc();
    sdata.index = seg_alloc();
    bssindex = seg_alloc();
    syms = saa_init((long)sizeof(struct Symbol));
    nsyms = 0;
    bsym = raa_init();
    symval = raa_init();
    strs = saa_init(1L);
    strslen = 0;
}

static void coff_cleanup(void) {
    struct Reloc *r;

    coff_write();
    fclose (coffp);
    saa_free (stext.data);
    while (stext.head) {
	r = stext.head;
	stext.head = stext.head->next;
	nasm_free (r);
    }
    saa_free (sdata.data);
    while (sdata.head) {
	r = sdata.head;
	sdata.head = sdata.head->next;
	nasm_free (r);
    }
    saa_free (syms);
    raa_free (bsym);
    raa_free (symval);
    saa_free (strs);
}

static long coff_section_names (char *name, int pass, int *bits) {
    /*
     * Default is 32 bits.
     */
    if (!name)
	*bits = 32;

    if (!name)
	return stext.index;

    if (!strcmp(name, ".text"))
	return stext.index;
    else if (!strcmp(name, ".data"))
	return sdata.index;
    else if (!strcmp(name, ".bss"))
	return bssindex;
    else
	return NO_SEG;
}

static void coff_deflabel (char *name, long segment, long offset,
			   int is_global) {
    int pos = strslen+4;
    struct Symbol *sym;

    if (name[0] == '.' && name[1] == '.') {
	return;
    }

    if (strlen(name) > 8) {
	saa_wbytes (strs, name, (long)(1+strlen(name)));
	strslen += 1+strlen(name);
    } else
	pos = -1;

    sym = saa_wstruct (syms);

    sym->strpos = pos;
    if (pos == -1)
	strcpy (sym->name, name);
    sym->is_global = !!is_global;
    if (segment == NO_SEG)
	sym->section = -1;      /* absolute symbol */
    else if (segment == stext.index)
	sym->section = 1;       /* .text */
    else if (segment == sdata.index)
	sym->section = 2;       /* .data */
    else if (segment == bssindex)
	sym->section = 3;       /* .bss */
    else {
	sym->section = 0;       /* undefined */
	sym->is_global = TRUE;
    }
    if (is_global == 2)
	sym->value = offset;
    else
	sym->value = (sym->section == 0 ? 0 : offset);

    /*
     * define the references from external-symbol segment numbers
     * to these symbol records.
     */
    if (segment != NO_SEG && segment != stext.index &&
	segment != sdata.index && segment != bssindex)
	bsym = raa_write (bsym, segment, nsyms);

    if (segment != NO_SEG)
	symval = raa_write (symval, segment, sym->section ? 0 : sym->value);

    nsyms++;
}

static long coff_add_reloc (struct Section *sect, long segment,
			    int relative) {
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = (segment == NO_SEG ? SYM_ABS_SEG :
		 segment == stext.index ? SYM_TEXT_SEG :
		 segment == sdata.index ? SYM_DATA_SEG :
		 segment == bssindex ? SYM_BSS_SEG :
		 raa_read (bsym, segment) + SYM_INITIAL);
    r->relative = relative;

    sect->nrelocs++;

    /*
     * Return the fixup for standard COFF common variables.
     */
    if (r->symbol >= SYM_INITIAL && !win32)
	return raa_read (symval, segment);
    else
	return 0;
}

static void coff_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) {
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    unsigned char mydata[4], *p;

    if (wrt != NO_SEG) {
	wrt = NO_SEG;		       /* continue to do _something_ */
	error (ERR_NONFATAL, "WRT not supported by COFF output formats");
    }

    type &= OUT_TYPMASK;

    /*
     * handle absolute-assembly (structure definitions)
     */
    if (segto == NO_SEG) {
	if (type != OUT_RESERVE)
	    error (ERR_NONFATAL, "attempt to assemble code in [ABSOLUTE]"
		   " space");
	return;
    }

    if (segto == stext.index)
	s = &stext;
    else if (segto == sdata.index)
	s = &sdata;
    else if (segto == bssindex)
	s = NULL;
    else {
	error(ERR_WARNING, "attempt to assemble code in"
	      " segment %d: defaulting to `.text'", segto);
	s = &stext;
    }

    if (!s && type != OUT_RESERVE) {
	error(ERR_WARNING, "attempt to initialise memory in the"
	      " BSS section: ignored");
	if (type == OUT_REL2ADR)
	    realbytes = 2;
	else if (type == OUT_REL4ADR)
	    realbytes = 4;
	bsslen += realbytes;
	return;
    }

    if (type == OUT_RESERVE) {
	if (s) {
	    error(ERR_WARNING, "uninitialised space declared in"
		  " %s section: zeroing",
		  (segto == stext.index ? "code" : "data"));
	    coff_sect_write (s, NULL, realbytes);
	} else
	    bsslen += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	coff_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	if (realbytes == 2 && (segment != NO_SEG || wrt != NO_SEG))
	    error(ERR_NONFATAL, "COFF format does not support 16-bit"
		  " relocations");
	else {
	    long fix = 0;
	    if (segment != NO_SEG || wrt != NO_SEG) {
		if (wrt != NO_SEG) {
		    error(ERR_NONFATAL, "COFF format does not support"
			  " WRT types");
		} else if (segment % 2) {
		    error(ERR_NONFATAL, "COFF format does not support"
			  " segment base references");
		} else
		    fix = coff_add_reloc (s, segment, FALSE);
	    }
	    p = mydata;
	    WRITELONG (p, *(long *)data + fix);
	    coff_sect_write (s, mydata, realbytes);
	}
    } else if (type == OUT_REL2ADR) {
	error(ERR_NONFATAL, "COFF format does not support 16-bit"
	      " relocations");
    } else if (type == OUT_REL4ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL4ADR");
	else if (segment == NO_SEG && win32)
	    error(ERR_NONFATAL, "Win32 COFF does not correctly support"
		  " relative references to absolute addresses");
	else {
	    long fix = 0;
	    if (segment != NO_SEG && segment % 2) {
		error(ERR_NONFATAL, "COFF format does not support"
		      " segment base references");
	    } else
		fix = coff_add_reloc (s, segment, TRUE);
	    p = mydata;
	    if (win32) {
		WRITELONG (p, *(long*)data + 4 - realbytes + fix);
	    } else {
		WRITELONG (p, *(long*)data-(realbytes + s->len) + fix);
	    }
	    coff_sect_write (s, mydata, 4L);
	}
    }
}

static void coff_sect_write (struct Section *sect,
			     unsigned char *data, unsigned long len) {
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static int coff_directives (char *directive, char *value, int pass) {
    return 0;
}

static void coff_write (void) {
    long textpos, textrelpos, datapos, datarelpos, sympos;

    /*
     * Work out how big the file will get.
     */
    textpos = COFF_HDRS_END;
    textrelpos = textpos + stext.len;
    datapos = textrelpos + stext.nrelocs * 10;
    datarelpos = datapos + sdata.len;
    sympos = datarelpos + sdata.nrelocs * 10;

    /*
     * Output the COFF header.
     */
    fwriteshort (0x14C, coffp);	       /* MACHINE_i386 */
    fwriteshort (3, coffp);	       /* number of sections */
    fwritelong (time(NULL), coffp);    /* time stamp */
    fwritelong (sympos, coffp);
    fwritelong (nsyms + SYM_INITIAL, coffp);
    fwriteshort (0, coffp);	       /* no optional header */
    /* Flags: 32-bit, no line numbers. Win32 doesn't even bother with them. */
    fwriteshort (win32 ? 0 : 0x104, coffp);

    /*
     * Output the section headers.
     */

    coff_section_header (".text", 0L, stext.len, textpos,
			 textrelpos, stext.nrelocs,
			 (win32 ? 0x60500020L : 0x20L));
    coff_section_header (".data", stext.len, sdata.len, datapos,
			 datarelpos, sdata.nrelocs,
			 (win32 ? 0xC0300040L : 0x40L));
    coff_section_header (".bss", stext.len+sdata.len, bsslen, 0L, 0L, 0,
			 (win32 ? 0xC0300080L : 0x80L));

    /*
     * Output the text section, and its relocations.
     */
    saa_fpwrite (stext.data, coffp);
    coff_write_relocs (&stext);

    /*
     * Output the data section, and its relocations.
     */
    saa_fpwrite (sdata.data, coffp);
    coff_write_relocs (&sdata);

    /*
     * Output the symbol and string tables.
     */
    coff_write_symbols();
    fwritelong (strslen+4, coffp);     /* length includes length count */
    saa_fpwrite (strs, coffp);
}

static void coff_section_header (char *name, long vsize,
				 long datalen, long datapos,
				 long relpos, int nrelocs, long flags) {
    char padname[8];

    memset (padname, 0, 8);
    strncpy (padname, name, 8);
    fwrite (padname, 8, 1, coffp);
    fwritelong (vsize, coffp);
    fwritelong (0L, coffp);	       /* RVA/offset - we ignore */
    fwritelong (datalen, coffp);
    fwritelong (datapos, coffp);
    fwritelong (relpos, coffp);
    fwritelong (0L, coffp);	       /* no line numbers - we don't do 'em */
    fwriteshort (nrelocs, coffp);
    fwriteshort (0, coffp);	       /* again, no line numbers */
    fwritelong (flags, coffp);
}

static void coff_write_relocs (struct Section *s) {
    struct Reloc *r;

    for (r = s->head; r; r = r->next) {
	fwritelong (r->address, coffp);
	fwritelong (r->symbol, coffp);
	/*
	 * Strange: Microsoft's COFF documentation says 0x03 for an
	 * absolute relocation, but both Visual C++ and DJGPP agree
	 * that in fact it's 0x06. I'll use 0x06 until someone
	 * argues.
	 */
	fwriteshort (r->relative ? 0x14 : 0x06, coffp);
    }
}

static void coff_symbol (char *name, long strpos, long value,
			 int section, int type, int aux) {
    char padname[8];

    if (name) {
	memset (padname, 0, 8);
	strncpy (padname, name, 8);
	fwrite (padname, 8, 1, coffp);
    } else {
	fwritelong (0L, coffp);
	fwritelong (strpos, coffp);
    }
    fwritelong (value, coffp);
    fwriteshort (section, coffp);
    fwriteshort (0, coffp);
    fputc (type, coffp);
    fputc (aux, coffp);
}

static void coff_write_symbols (void) {
    char filename[18];
    int i;

    /*
     * The `.file' record, and the file name auxiliary record.
     */
    coff_symbol (".file", 0L, 0L, -2, 0x67, 1);
    memset (filename, 0, 18);
    strncpy (filename, coff_infile, 18);
    fwrite (filename, 18, 1, coffp);

    /*
     * The section records, with their auxiliaries.
     */
    memset (filename, 0, 18);	       /* useful zeroed buffer */

    coff_symbol (".text", 0L, 0L, 1, 3, 1);
    fwritelong (stext.len, coffp);
    fwriteshort (stext.nrelocs, coffp);
    fwrite (filename, 12, 1, coffp);
    coff_symbol (".data", 0L, 0L, 2, 3, 1);
    fwritelong (sdata.len, coffp);
    fwriteshort (sdata.nrelocs, coffp);
    fwrite (filename, 12, 1, coffp);
    coff_symbol (".bss", 0L, 0L, 3, 3, 1);
    fwritelong (bsslen, coffp);
    fwrite (filename, 14, 1, coffp);

    /*
     * The absolute symbol, for relative-to-absolute relocations.
     */
    coff_symbol (".absolut", 0L, 0L, -1, 3, 0);

    /*
     * The real symbols.
     */
    saa_rewind (syms);
    for (i=0; i<nsyms; i++) {
	struct Symbol *sym = saa_rstruct (syms);
	coff_symbol (sym->strpos == -1 ? sym->name : NULL,
		     sym->strpos, sym->value, sym->section,
		     sym->is_global ? 2 : 3, 0);
    }
}

static long coff_segbase (long segment) {
    return segment;
}

static void coff_std_filename (char *inname, char *outname, efunc error) {
    strcpy(coff_infile, inname);
    standard_extension (inname, outname, ".o", error);
}

static void coff_win32_filename (char *inname, char *outname, efunc error) {
    strcpy(coff_infile, inname);
    standard_extension (inname, outname, ".obj", error);
}

#endif /* defined(OF_COFF) || defined(OF_WIN32) */

#ifdef OF_COFF

struct ofmt of_coff = {
    "COFF (i386) object files (e.g. DJGPP for DOS)",
    "coff",
    coff_std_init,
    coff_out,
    coff_deflabel,
    coff_section_names,
    coff_segbase,
    coff_directives,
    coff_std_filename,
    coff_cleanup
};

#endif

#ifdef OF_WIN32

struct ofmt of_win32 = {
    "Microsoft Win32 (i386) object files",
    "win32",
    coff_win32_init,
    coff_out,
    coff_deflabel,
    coff_section_names,
    coff_segbase,
    coff_directives,
    coff_win32_filename,
    coff_cleanup
};

#endif
