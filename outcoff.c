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
 * (3) Win32 uses some extra flags into the section header table:
 * it defines flags 0x80000000 (writable), 0x40000000 (readable)
 * and 0x20000000 (executable), and uses them in the expected
 * combinations. It also defines 0x00100000 through 0x00700000 for
 * section alignments of 1 through 64 bytes.
 *
 * (4) Both standard COFF and Win32 COFF seem to use the DWORD
 * field directly after the section name in the section header
 * table for something strange: they store what the address of the
 * section start point _would_ be, if you laid all the sections end
 * to end starting at zero. Dunno why. Microsoft's documentation
 * lists this field as "Virtual Size of Section", which doesn't
 * seem to fit at all. In fact, Win32 even includes non-linked
 * sections such as .drectve in this calculation.
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
    enum {
	SECT_SYMBOLS,
	ABS_SYMBOL,
	REAL_SYMBOLS
    } symbase;			       /* relocation for symbol number :) */
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
    unsigned long flags;	       /* section flags */
    char name[9];
    long pos, relpos;
};

#define TEXT_FLAGS (win32 ? 0x60500020L : 0x20L)
#define DATA_FLAGS (win32 ? 0xC0300040L : 0x40L)
#define BSS_FLAGS (win32 ? 0xC0300080L : 0x80L)
#define INFO_FLAGS 0x00100A00L

#define SECT_DELTA 32
static struct Section **sects;
static int nsects, sectlen;

static struct SAA *syms;
static unsigned long nsyms;

static long def_seg;

static int initsym;

static struct RAA *bsym, *symval;

static struct SAA *strs;
static unsigned long strslen;

static void coff_gen_init(FILE *, efunc);
static void coff_sect_write (struct Section *, unsigned char *,
			     unsigned long);
static void coff_write (void);
static void coff_section_header (char *, long, long, long, long, int, long);
static void coff_write_relocs (struct Section *);
static void coff_write_symbols (void);

static void coff_win32_init(FILE *fp,  efunc errfunc,
			    ldfunc ldef, evalfunc eval) 
{
    win32 = TRUE;
    (void) ldef;		       /* placate optimisers */
    coff_gen_init(fp, errfunc);
}

static void coff_std_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    win32 = FALSE;
    (void) ldef;		       /* placate optimisers */
    coff_gen_init(fp, errfunc);
}

static void coff_gen_init(FILE *fp, efunc errfunc) 
{

    coffp = fp;
    error = errfunc;
    sects = NULL;
    nsects = sectlen = 0;
    syms = saa_init((long)sizeof(struct Symbol));
    nsyms = 0;
    bsym = raa_init();
    symval = raa_init();
    strs = saa_init(1L);
    strslen = 0;
    def_seg = seg_alloc();
}

static void coff_cleanup(int debuginfo) 
{
    struct Reloc *r;
    int i;

    (void) debuginfo;

    coff_write();
    fclose (coffp);
    for (i=0; i<nsects; i++) {
	if (sects[i]->data)
	    saa_free (sects[i]->data);
	while (sects[i]->head) {
	    r = sects[i]->head;
	    sects[i]->head = sects[i]->head->next;
	    nasm_free (r);
	}
	nasm_free (sects[i]);
    }
    nasm_free (sects);
    saa_free (syms);
    raa_free (bsym);
    raa_free (symval);
    saa_free (strs);
}

static int coff_make_section (char *name, unsigned long flags) 
{
    struct Section *s;

    s = nasm_malloc (sizeof(*s));

    if (flags != BSS_FLAGS)
	s->data = saa_init (1L);
    else
	s->data = NULL;
    s->head = NULL;
    s->tail = &s->head;
    s->len = 0;
    s->nrelocs = 0;
    if (!strcmp(name, ".text"))
	s->index = def_seg;
    else
	s->index = seg_alloc();
    strncpy (s->name, name, 8);
    s->name[8] = '\0';
    s->flags = flags;

    if (nsects >= sectlen)
	sects = nasm_realloc (sects, (sectlen += SECT_DELTA)*sizeof(*sects));
    sects[nsects++] = s;

    return nsects-1;
}

static long coff_section_names (char *name, int pass, int *bits) 
{
    char *p;
    unsigned long flags, align_and = ~0L, align_or = 0L;
    int i;

    /*
     * Default is 32 bits.
     */
    if (!name)
	*bits = 32;

    if (!name)
	return def_seg;

    p = name;
    while (*p && !isspace(*p)) p++;
    if (*p) *p++ = '\0';
    if (strlen(name) > 8) {
	error (ERR_WARNING, "COFF section names limited to 8 characters:"
	       " truncating");
	name[8] = '\0';
    }
    flags = 0;

    while (*p && isspace(*p)) p++;
    while (*p) {
	char *q = p;
	while (*p && !isspace(*p)) p++;
	if (*p) *p++ = '\0';
	while (*p && isspace(*p)) p++;

	if (!nasm_stricmp(q, "code") || !nasm_stricmp(q, "text")) {
	    flags = TEXT_FLAGS;
	} else if (!nasm_stricmp(q, "data")) {
	    flags = DATA_FLAGS;
	} else if (!nasm_stricmp(q, "bss")) {
	    flags = BSS_FLAGS;
	} else if (!nasm_stricmp(q, "info")) {
	    if (win32)
		flags = INFO_FLAGS;
	    else {
		flags = DATA_FLAGS;    /* gotta do something */
		error (ERR_NONFATAL, "standard COFF does not support"
		       " informational sections");
	    }
	} else if (!nasm_strnicmp(q,"align=",6)) {
	    if (!win32)
		error (ERR_NONFATAL, "standard COFF does not support"
		       " section alignment specification");
	    else {
		if (q[6+strspn(q+6,"0123456789")])
		    error(ERR_NONFATAL, "argument to `align' is not numeric");
		else {
		    unsigned int align = atoi(q+6);
		    if (!align || ((align-1) & align))
			error(ERR_NONFATAL, "argument to `align' is not a"
			      " power of two");
		    else if (align > 64)
			error(ERR_NONFATAL, "Win32 cannot align sections"
			      " to better than 64-byte boundaries");
		    else {
			align_and = ~0x00F00000L;
			align_or = (align == 1 ? 0x00100000L :
				    align == 2 ? 0x00200000L :
				    align == 4 ? 0x00300000L :
				    align == 8 ? 0x00400000L :
				    align == 16 ? 0x00500000L :
				    align == 32 ? 0x00600000L : 0x00700000L);
		    }
		}
	    }
	}
    }

    for (i=0; i<nsects; i++)
	if (!strcmp(name, sects[i]->name))
	    break;
    if (i == nsects) {
	if (!flags) {
	    if (!strcmp(name, ".data"))
		flags = DATA_FLAGS;
	    else if (!strcmp(name, ".bss"))
		flags = BSS_FLAGS;
	    else
		flags = TEXT_FLAGS;
	}
	i = coff_make_section (name, flags);
	if (flags)
	    sects[i]->flags = flags;
	sects[i]->flags &= align_and;
	sects[i]->flags |= align_or;
    } else if (pass == 1) {
	if (flags)
	    error (ERR_WARNING, "section attributes ignored on"
		   " redeclaration of section `%s'", name);
    }

    return sects[i]->index;
}

static void coff_deflabel (char *name, long segment, long offset,
			   int is_global, char *special) 
{
    int pos = strslen+4;
    struct Symbol *sym;

    if (special)
	error (ERR_NONFATAL, "binary format does not support any"
	       " special symbol types");

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
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
    else {
	int i;
	sym->section = 0;
	for (i=0; i<nsects; i++)
	    if (segment == sects[i]->index) {
		sym->section = i+1;
		break;
	    }
	if (!sym->section)
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
    if (sym->section == 0)
	bsym = raa_write (bsym, segment, nsyms);

    if (segment != NO_SEG)
	symval = raa_write (symval, segment, sym->section ? 0 : sym->value);

    nsyms++;
}

static long coff_add_reloc (struct Section *sect, long segment,
			    int relative) 
{
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    if (segment == NO_SEG)
	r->symbol = 0, r->symbase = ABS_SYMBOL;
    else {
	int i;
	r->symbase = REAL_SYMBOLS;
	for (i=0; i<nsects; i++)
	    if (segment == sects[i]->index) {
		r->symbol = i*2;
		r->symbase = SECT_SYMBOLS;
		break;
	    }
	if (r->symbase == REAL_SYMBOLS)
	    r->symbol = raa_read (bsym, segment);
    }
    r->relative = relative;

    sect->nrelocs++;

    /*
     * Return the fixup for standard COFF common variables.
     */
    if (r->symbase == REAL_SYMBOLS && !win32)
	return raa_read (symval, segment);
    else
	return 0;
}

static void coff_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) 
{
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    unsigned char mydata[4], *p;
    int i;

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

    s = NULL;
    for (i=0; i<nsects; i++)
	if (segto == sects[i]->index) {
	    s = sects[i];
	    break;
	}
    if (!s) {
	int tempint;		       /* ignored */
	if (segto != coff_section_names (".text", 2, &tempint))
	    error (ERR_PANIC, "strange segment conditions in COFF driver");
	else
	    s = sects[nsects-1];
    }

    if (!s->data && type != OUT_RESERVE) {
	error(ERR_WARNING, "attempt to initialise memory in"
	      " BSS section `%s': ignored", s->name);
	if (type == OUT_REL2ADR)
	    realbytes = 2;
	else if (type == OUT_REL4ADR)
	    realbytes = 4;
	s->len += realbytes;
	return;
    }

    if (type == OUT_RESERVE) {
	if (s->data) {
	    error(ERR_WARNING, "uninitialised space declared in"
		  " non-BSS section `%s': zeroing", s->name);
	    coff_sect_write (s, NULL, realbytes);
	} else
	    s->len += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	coff_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	if (realbytes != 4 && (segment != NO_SEG || wrt != NO_SEG))
	    error(ERR_NONFATAL, "COFF format does not support non-32-bit"
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
			     unsigned char *data, unsigned long len) 
{
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static int coff_directives (char *directive, char *value, int pass) 
{
    return 0;
}

static void coff_write (void) 
{
    long pos, sympos, vsize;
    int i;

    /*
     * Work out how big the file will get. Calculate the start of
     * the `real' symbols at the same time.
     */
    pos = 0x14 + 0x28 * nsects;
    initsym = 3;		       /* two for the file, one absolute */
    for (i=0; i<nsects; i++) {
	if (sects[i]->data) {
	    sects[i]->pos = pos;
	    pos += sects[i]->len;
	    sects[i]->relpos = pos;
	    pos += 10 * sects[i]->nrelocs;
	} else
	    sects[i]->pos = sects[i]->relpos = 0L;
	initsym += 2;		       /* two for each section */
    }
    sympos = pos;

    /*
     * Output the COFF header.
     */
    fwriteshort (0x14C, coffp);	       /* MACHINE_i386 */
    fwriteshort (nsects, coffp);       /* number of sections */
    fwritelong (time(NULL), coffp);    /* time stamp */
    fwritelong (sympos, coffp);
    fwritelong (nsyms + initsym, coffp);
    fwriteshort (0, coffp);	       /* no optional header */
    /* Flags: 32-bit, no line numbers. Win32 doesn't even bother with them. */
    fwriteshort (win32 ? 0 : 0x104, coffp);

    /*
     * Output the section headers.
     */
    vsize = 0L;
    for (i=0; i<nsects; i++) {
	coff_section_header (sects[i]->name, vsize, sects[i]->len,
			     sects[i]->pos, sects[i]->relpos,
			     sects[i]->nrelocs, sects[i]->flags);
	vsize += sects[i]->len;
    }

    /*
     * Output the sections and their relocations.
     */
    for (i=0; i<nsects; i++)
	if (sects[i]->data) {
	    saa_fpwrite (sects[i]->data, coffp);
	    coff_write_relocs (sects[i]);
	}

    /*
     * Output the symbol and string tables.
     */
    coff_write_symbols();
    fwritelong (strslen+4, coffp);     /* length includes length count */
    saa_fpwrite (strs, coffp);
}

static void coff_section_header (char *name, long vsize,
				 long datalen, long datapos,
				 long relpos, int nrelocs, long flags) 
{
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

static void coff_write_relocs (struct Section *s) 
{
    struct Reloc *r;

    for (r = s->head; r; r = r->next) {
	fwritelong (r->address, coffp);
	fwritelong (r->symbol + (r->symbase == REAL_SYMBOLS ? initsym :
				 r->symbase == ABS_SYMBOL ? initsym-1 :
				 r->symbase == SECT_SYMBOLS ? 2 : 0), coffp);
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
			 int section, int type, int aux) 
{
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

static void coff_write_symbols (void) 
{
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

    for (i=0; i<nsects; i++) {
	coff_symbol (sects[i]->name, 0L, 0L, i+1, 3, 1);
	fwritelong (sects[i]->len, coffp);
	fwriteshort (sects[i]->nrelocs, coffp);
	fwrite (filename, 12, 1, coffp);
    }

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

static long coff_segbase (long segment) 
{
    return segment;
}

static void coff_std_filename (char *inname, char *outname, efunc error) 
{
    strcpy(coff_infile, inname);
    standard_extension (inname, outname, ".o", error);
}

static void coff_win32_filename (char *inname, char *outname, efunc error) 
{
    strcpy(coff_infile, inname);
    standard_extension (inname, outname, ".obj", error);
}

static char *coff_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static int coff_set_info(enum geninfo type, char **val)
{
    return 0;
}
#endif /* defined(OF_COFF) || defined(OF_WIN32) */

#ifdef OF_COFF

struct ofmt of_coff = {
    "COFF (i386) object files (e.g. DJGPP for DOS)",
    "coff",
    NULL,
    null_debug_arr,
    &null_debug_form,
    coff_stdmac,
    coff_std_init,
    coff_set_info,
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
    NULL,
    null_debug_arr,
    &null_debug_form,
    coff_stdmac,
    coff_win32_init,
    coff_set_info,
    coff_out,
    coff_deflabel,
    coff_section_names,
    coff_segbase,
    coff_directives,
    coff_win32_filename,
    coff_cleanup
};

#endif
