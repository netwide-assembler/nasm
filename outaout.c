/* outaout.c	output routines for the Netwide Assembler to produce
 *		Linux a.out object files
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

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"

#ifdef OF_AOUT

struct Reloc {
    struct Reloc *next;
    long address;		       /* relative to _start_ of section */
    long symbol;		       /* symbol number or -ve section id */
    int bytes;			       /* 2 or 4 */
    int relative;		       /* TRUE or FALSE */
};

struct Symbol {
    long strpos;		       /* string table position of name */
    int type;			       /* symbol type - see flags below */
    long value;			       /* address, or COMMON variable size */
};

/*
 * Section IDs - used in Reloc.symbol when negative, and in
 * Symbol.type when positive.
 */
#define SECT_ABS 2		       /* absolute value */
#define SECT_TEXT 4		       /* text section */
#define SECT_DATA 6		       /* data section */
#define SECT_BSS 8		       /* bss section */
#define SECT_MASK 0xE		       /* mask out any of the above */

/*
 * Another flag used in Symbol.type.
 */
#define SYM_GLOBAL 1		       /* it's a global symbol */

/*
 * Bit more explanation of symbol types: SECT_xxx denotes a local
 * symbol. SECT_xxx|SYM_GLOBAL denotes a global symbol, defined in
 * this module. Just SYM_GLOBAL, with zero value, denotes an
 * external symbol referenced in this module. And just SYM_GLOBAL,
 * but with a non-zero value, declares a C `common' variable, of
 * size `value'.
 */

struct Section {
    struct SAA *data;
    unsigned long len, size, nrelocs;
    long index;
    struct Reloc *head, **tail;
};

static struct Section stext, sdata;
static unsigned long bsslen;
static long bssindex;

static struct SAA *syms;
static unsigned long nsyms;

static struct RAA *bsym;

static struct SAA *strs;
static unsigned long strslen;

static FILE *aoutfp;
static efunc error;

static void aout_write(void);
static void aout_write_relocs(struct Reloc *);
static void aout_write_syms(void);
static void aout_sect_write(struct Section *, unsigned char *, unsigned long);
static void aout_pad_sections(void);
static void aout_fixup_relocs(struct Section *);

static void aout_init(FILE *fp, efunc errfunc, ldfunc ldef) {
    aoutfp = fp;
    error = errfunc;
    (void) ldef;		       /* placate optimisers */
    stext.data = saa_init(1L); stext.head = NULL; stext.tail = &stext.head;
    sdata.data = saa_init(1L); sdata.head = NULL; sdata.tail = &sdata.head;
    stext.len = stext.size = sdata.len = sdata.size = bsslen = 0;
    stext.nrelocs = sdata.nrelocs = 0;
    stext.index = seg_alloc();
    sdata.index = seg_alloc();
    bssindex = seg_alloc();
    syms = saa_init((long)sizeof(struct Symbol));
    nsyms = 0;
    bsym = raa_init();
    strs = saa_init(1L);
    strslen = 0;
}

static void aout_cleanup(void) {
    struct Reloc *r;

    aout_pad_sections();
    aout_fixup_relocs(&stext);
    aout_fixup_relocs(&sdata);
    aout_write();
    fclose (aoutfp);
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
    saa_free (strs);
}

static long aout_section_names (char *name, int pass, int *bits) {
    /*
     * Default to 32 bits.
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

static void aout_deflabel (char *name, long segment, long offset,
			   int is_global) {
    int pos = strslen+4;
    struct Symbol *sym;

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
	return;
    }

    saa_wbytes (strs, name, (long)(1+strlen(name)));
    strslen += 1+strlen(name);

    sym = saa_wstruct (syms);

    sym->strpos = pos;
    sym->type = is_global ? SYM_GLOBAL : 0;
    if (segment == NO_SEG)
	sym->type |= SECT_ABS;
    else if (segment == stext.index)
	sym->type |= SECT_TEXT;
    else if (segment == sdata.index)
	sym->type |= SECT_DATA;
    else if (segment == bssindex)
	sym->type |= SECT_BSS;
    else
	sym->type = SYM_GLOBAL;
    if (is_global == 2)
	sym->value = offset;
    else
	sym->value = (sym->type == SYM_GLOBAL ? 0 : offset);

    /*
     * define the references from external-symbol segment numbers
     * to these symbol records.
     */
    if (segment != NO_SEG && segment != stext.index &&
	segment != sdata.index && segment != bssindex)
	bsym = raa_write (bsym, segment, nsyms);

    nsyms++;
}

static void aout_add_reloc (struct Section *sect, long segment,
			    int relative, int bytes) {
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = (segment == NO_SEG ? -SECT_ABS :
		 segment == stext.index ? -SECT_TEXT :
		 segment == sdata.index ? -SECT_DATA :
		 segment == bssindex ? -SECT_BSS :
		 raa_read(bsym, segment));
    r->relative = relative;
    r->bytes = bytes;

    sect->nrelocs++;
}

static void aout_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) {
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    unsigned char mydata[4], *p;

    if (wrt != NO_SEG) {
	wrt = NO_SEG;		       /* continue to do _something_ */
	error (ERR_NONFATAL, "WRT not supported by a.out output format");
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
	    aout_sect_write (s, NULL, realbytes);
	} else
	    bsslen += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	aout_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "a.out format does not support"
		      " segment base references");
	    } else
		aout_add_reloc (s, segment, FALSE, realbytes);
	}
	p = mydata;
	if (realbytes == 2)
	    WRITESHORT (p, *(long *)data);
	else
	    WRITELONG (p, *(long *)data);
	aout_sect_write (s, mydata, realbytes);
    } else if (type == OUT_REL2ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL2ADR");
	if (segment != NO_SEG && segment % 2) {
	    error(ERR_NONFATAL, "a.out format does not support"
		  " segment base references");
	} else
	    aout_add_reloc (s, segment, TRUE, 2);
	p = mydata;
	WRITESHORT (p, *(long*)data-(realbytes + s->len));
	aout_sect_write (s, mydata, 2L);
    } else if (type == OUT_REL4ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL4ADR");
	if (segment != NO_SEG && segment % 2) {
	    error(ERR_NONFATAL, "a.out format does not support"
		  " segment base references");
	} else
	    aout_add_reloc (s, segment, TRUE, 4);
	p = mydata;
	WRITELONG (p, *(long*)data-(realbytes + s->len));
	aout_sect_write (s, mydata, 4L);
    }
}

static void aout_pad_sections(void) {
    static unsigned char pad[] = { 0x90, 0x90, 0x90, 0x90 };
    /*
     * Pad each of the text and data sections with NOPs until their
     * length is a multiple of four. (NOP == 0x90.) Also increase
     * the length of the BSS section similarly.
     */
    aout_sect_write (&stext, pad, (-stext.len) & 3);
    aout_sect_write (&sdata, pad, (-sdata.len) & 3);
    bsslen = (bsslen + 3) & ~3;
}

/*
 * a.out files have the curious property that all references to
 * things in the data or bss sections are done by addresses which
 * are actually relative to the start of the _text_ section, in the
 * _file_. (No relation to what happens after linking. No idea why
 * this should be so. It's very strange.) So we have to go through
 * the relocation table, _after_ the final size of each section is
 * known, and fix up the relocations pointed to.
 */
static void aout_fixup_relocs(struct Section *sect) {
    struct Reloc *r;

    saa_rewind (sect->data);
    for (r = sect->head; r; r = r->next) {
	unsigned char *p, *q, blk[4];
	long l;

	saa_fread (sect->data, r->address, blk, (long)r->bytes);
	p = q = blk;
	l = *p++;
	l += ((long)*p++) << 8;
	if (r->bytes == 4) {
	    l += ((long)*p++) << 16;
	    l += ((long)*p++) << 24;
	}
	if (r->symbol == -SECT_DATA)
	    l += stext.len;
	else if (r->symbol == -SECT_BSS)
	    l += stext.len + sdata.len;
	if (r->bytes == 4)
	    WRITELONG(q, l);
	else
	    WRITESHORT(q, l);
	saa_fwrite (sect->data, r->address, blk, (long)r->bytes);
    }
}

static void aout_write(void) {
    /*
     * Emit the a.out header.
     */
    fwritelong (0x640107L, aoutfp);    /* OMAGIC, M_386, no flags */
    fwritelong (stext.len, aoutfp);
    fwritelong (sdata.len, aoutfp);
    fwritelong (bsslen, aoutfp);
    fwritelong (nsyms * 12, aoutfp);   /* length of symbol table */
    fwritelong (0L, aoutfp);	       /* object files have no entry point */
    fwritelong (stext.nrelocs * 8, aoutfp);   /* size of text relocs */
    fwritelong (sdata.nrelocs * 8, aoutfp);   /* size of data relocs */

    /*
     * Write out the code section and the data section.
     */
    saa_fpwrite (stext.data, aoutfp);
    saa_fpwrite (sdata.data, aoutfp);

    /*
     * Write out the relocations.
     */
    aout_write_relocs (stext.head);
    aout_write_relocs (sdata.head);

    /*
     * Write the symbol table.
     */
    aout_write_syms ();

    /*
     * And the string table.
     */
    fwritelong (strslen+4, aoutfp);    /* length includes length count */
    saa_fpwrite (strs, aoutfp);
}

static void aout_write_relocs (struct Reloc *r) {
    while (r) {
	unsigned long word2;

	fwritelong (r->address, aoutfp);

	if (r->symbol >= 0)
	    word2 = r->symbol | 0x8000000L;
	else
	    word2 = -r->symbol;
	if (r->relative)
	    word2 |= 0x1000000L;
	word2 |= (r->bytes == 2 ? 0x2000000L : 0x4000000L);
	fwritelong (word2, aoutfp);

	r = r->next;
    }
}

static void aout_write_syms (void) {
    int i;

    saa_rewind (syms);
    for (i=0; i<nsyms; i++) {
	struct Symbol *sym = saa_rstruct(syms);
	fwritelong (sym->strpos, aoutfp);
	fwritelong ((long)sym->type, aoutfp);
	/*
	 * Fix up the symbol value now we know the final section
	 * sizes.
	 */
	if ((sym->type & SECT_MASK) == SECT_DATA)
	    sym->value += stext.len;
	if ((sym->type & SECT_MASK) == SECT_BSS)
	    sym->value += stext.len + sdata.len;
	fwritelong (sym->value, aoutfp);
    }
}

static void aout_sect_write (struct Section *sect,
			     unsigned char *data, unsigned long len) {
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static long aout_segbase (long segment) {
    return segment;
}

static int aout_directive (char *directive, char *value, int pass) {
    return 0;
}

static void aout_filename (char *inname, char *outname, efunc error) {
    standard_extension (inname, outname, ".o", error);
}

struct ofmt of_aout = {
    "GNU a.out (i386) object files (e.g. Linux)",
    "aout",
    aout_init,
    aout_out,
    aout_deflabel,
    aout_section_names,
    aout_segbase,
    aout_directive,
    aout_filename,
    aout_cleanup
};

#endif /* OF_AOUT */
