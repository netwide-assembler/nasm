/* outas86.c	output routines for the Netwide Assembler to produce
 *		Linux as86 (bin86-0.3) object files
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

#ifdef OF_AS86

struct Piece {
    struct Piece *next;
    int type;			       /* 0 = absolute, 1 = seg, 2 = sym */
    long offset;		       /* relative offset */
    int number;			       /* symbol/segment number (4=bss) */
    long bytes;			       /* size of reloc or of absolute data */
    int relative;		       /* TRUE or FALSE */
};

struct Symbol {
    long strpos;		       /* string table position of name */
    int flags;			       /* symbol flags */
    int segment;		       /* 4=bss at this point */
    long value;			       /* address, or COMMON variable size */
};

/*
 * Section IDs - used in Piece.number and Symbol.segment.
 */
#define SECT_TEXT 0		       /* text section */
#define SECT_DATA 3		       /* data section */
#define SECT_BSS 4		       /* bss section */

/*
 * Flags used in Symbol.flags.
 */
#define SYM_ENTRY (1<<8)
#define SYM_EXPORT (1<<7)
#define SYM_IMPORT (1<<6)
#define SYM_ABSOLUTE (1<<4)

struct Section {
    struct SAA *data;
    unsigned long datalen, size, len;
    long index;
    struct Piece *head, *last, **tail;
};

static char as86_module[FILENAME_MAX];

static struct Section stext, sdata;
static unsigned long bsslen;
static long bssindex;

static struct SAA *syms;
static unsigned long nsyms;

static struct RAA *bsym;

static struct SAA *strs;
static unsigned long strslen;

static int as86_reloc_size;

static FILE *as86fp;
static efunc error;

static void as86_write(void);
static void as86_write_section (struct Section *, int);
static int as86_add_string (char *name);
static void as86_sect_write(struct Section *, unsigned char *, unsigned long);

static void as86_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    as86fp = fp;
    error = errfunc;
    (void) ldef;		       /* placate optimisers */
    stext.data = saa_init(1L); stext.datalen = 0L;
    stext.head = stext.last = NULL;
    stext.tail = &stext.head;
    sdata.data = saa_init(1L); sdata.datalen = 0L;
    sdata.head = sdata.last = NULL;
    sdata.tail = &sdata.head;
    bsslen =
	stext.len = stext.datalen = stext.size =
	sdata.len = sdata.datalen = sdata.size = 0;
    stext.index = seg_alloc();
    sdata.index = seg_alloc();
    bssindex = seg_alloc();
    syms = saa_init((long)sizeof(struct Symbol));
    nsyms = 0;
    bsym = raa_init();
    strs = saa_init(1L);
    strslen = 0;

    as86_add_string (as86_module);
}

static void as86_cleanup(int debuginfo) 
{
    struct Piece *p;

    (void) debuginfo;

    as86_write();
    fclose (as86fp);
    saa_free (stext.data);
    while (stext.head) {
	p = stext.head;
	stext.head = stext.head->next;
	nasm_free (p);
    }
    saa_free (sdata.data);
    while (sdata.head) {
	p = sdata.head;
	sdata.head = sdata.head->next;
	nasm_free (p);
    }
    saa_free (syms);
    raa_free (bsym);
    saa_free (strs);
}

static long as86_section_names (char *name, int pass, int *bits) 
{
    /*
     * Default is 16 bits.
     */
    if (!name)
	*bits = 16;

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

static int as86_add_string (char *name) 
{
    int pos = strslen;
    int length = strlen(name);

    saa_wbytes (strs, name, (long)(length+1));
    strslen += 1+length;

    return pos;
}

static void as86_deflabel (char *name, long segment, long offset,
			   int is_global, char *special) 
{
    struct Symbol *sym;

    if (special)
	error (ERR_NONFATAL, "as86 format does not support any"
	       " special symbol types");

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
	return;
    }

    sym = saa_wstruct (syms);

    sym->strpos = as86_add_string (name);
    sym->flags = 0;
    if (segment == NO_SEG)
	sym->flags |= SYM_ABSOLUTE, sym->segment = 0;
    else if (segment == stext.index)
	sym->segment = SECT_TEXT;
    else if (segment == sdata.index)
	sym->segment = SECT_DATA;
    else if (segment == bssindex)
	sym->segment = SECT_BSS;
    else {
	sym->flags |= SYM_IMPORT;
	sym->segment = 15;
    }

    if (is_global == 2)
	sym->segment = 3;       /* already have IMPORT */

    if (is_global && !(sym->flags & SYM_IMPORT))
	sym->flags |= SYM_EXPORT;

    sym->value = offset;

    /*
     * define the references from external-symbol segment numbers
     * to these symbol records.
     */
    if (segment != NO_SEG && segment != stext.index &&
	segment != sdata.index && segment != bssindex)
	bsym = raa_write (bsym, segment, nsyms);

    nsyms++;
}

static void as86_add_piece (struct Section *sect, int type, long offset,
			    long segment, long bytes, int relative) 
{
    struct Piece *p;

    sect->len += bytes;

    if (type == 0 && sect->last && sect->last->type == 0) {
	sect->last->bytes += bytes;
	return;
    }

    p = sect->last = *sect->tail = nasm_malloc(sizeof(struct Piece));
    sect->tail = &p->next;
    p->next = NULL;

    p->type = type;
    p->offset = offset;
    p->bytes = bytes;
    p->relative = relative;

    if (type == 1 && segment == stext.index)
	p->number = SECT_TEXT;
    else if (type == 1 && segment == sdata.index)
	p->number = SECT_DATA;
    else if (type == 1 && segment == bssindex)
	p->number = SECT_BSS;
    else if (type == 1)
	p->number = raa_read (bsym, segment), p->type = 2;
}

static void as86_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) 
{
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    long offset;
    unsigned char mydata[4], *p;

    if (wrt != NO_SEG) {
	wrt = NO_SEG;		       /* continue to do _something_ */
	error (ERR_NONFATAL, "WRT not supported by as86 output format");
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
	    as86_sect_write (s, NULL, realbytes);
	    as86_add_piece (s, 0, 0L, 0L, realbytes, 0);
	} else
	    bsslen += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	as86_sect_write (s, data, realbytes);
	as86_add_piece (s, 0, 0L, 0L, realbytes, 0);
    } else if (type == OUT_ADDRESS) {
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "as86 format does not support"
		      " segment base references");
	    } else{
		offset = * (long *) data;
		as86_add_piece (s, 1, offset, segment, realbytes, 0);
	    }
	} else {
	    p = mydata;
	    WRITELONG (p, * (long *) data);
	    as86_sect_write (s, data, realbytes);
	    as86_add_piece (s, 0, 0L, 0L, realbytes, 0);
	}
    } else if (type == OUT_REL2ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL2ADR");
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "as86 format does not support"
		      " segment base references");
	    } else {
		offset = * (long *) data;
		as86_add_piece (s, 1, offset-realbytes+2, segment, 2L, 1);
	    }
	}
    } else if (type == OUT_REL4ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL4ADR");
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "as86 format does not support"
		      " segment base references");
	    } else {
		offset = * (long *) data;
		as86_add_piece (s, 1, offset-realbytes+4, segment, 4L, 1);
	    }
	}
    }
}

static void as86_write(void) 
{
    int i;
    long symlen, seglen, segsize;

    /*
     * First, go through the symbol records working out how big
     * each will be. Also fix up BSS references at this time, and
     * set the flags words up completely.
     */
    symlen = 0;
    saa_rewind (syms);
    for (i = 0; i < nsyms; i++) {
	struct Symbol *sym = saa_rstruct (syms);
	if (sym->segment == SECT_BSS)
	    sym->segment = SECT_DATA, sym->value += sdata.len;
	sym->flags |= sym->segment;
	if (sym->value == 0)
	    sym->flags |= 0 << 14, symlen += 4;
	else if (sym->value >= 0 && sym->value <= 255)
	    sym->flags |= 1 << 14, symlen += 5;
	else if (sym->value >= 0 && sym->value <= 65535L)
	    sym->flags |= 2 << 14, symlen += 6;
	else
	    sym->flags |= 3 << 14, symlen += 8;
    }

    /*
     * Now do the same for the segments, and get the segment size
     * descriptor word at the same time.
     */
    seglen = segsize = 0;
    if ((unsigned long) stext.len > 65535L)
	segsize |= 0x03000000L, seglen += 4;
    else
	segsize |= 0x02000000L, seglen += 2;
    if ((unsigned long) sdata.len > 65535L)
	segsize |= 0xC0000000L, seglen += 4;
    else
	segsize |= 0x80000000L, seglen += 2;

    /*
     * Emit the as86 header.
     */
    fwritelong (0x000186A3L, as86fp);
    fputc (0x2A, as86fp);
    fwritelong (27+symlen+seglen+strslen, as86fp);   /* header length */
    fwritelong (stext.len+sdata.len, as86fp);
    fwriteshort (strslen, as86fp);
    fwriteshort (0, as86fp);	       /* class = revision = 0 */
    fwritelong (0x55555555L, as86fp);   /* segment max sizes: always this */
    fwritelong (segsize, as86fp);      /* segment size descriptors */
    if (segsize & 0x01000000L)
	fwritelong (stext.len, as86fp);
    else
	fwriteshort (stext.len, as86fp);
    if (segsize & 0x40000000L)
	fwritelong (sdata.len, as86fp);
    else
	fwriteshort (sdata.len, as86fp);
    fwriteshort (nsyms, as86fp);

    /*
     * Write the symbol table.
     */
    saa_rewind (syms);
    for (i = 0; i < nsyms; i++) {
	struct Symbol *sym = saa_rstruct (syms);
	fwriteshort (sym->strpos, as86fp);
	fwriteshort (sym->flags, as86fp);
	switch (sym->flags & (3<<14)) {
	  case 0<<14: break;
	  case 1<<14: fputc (sym->value, as86fp); break;
	  case 2<<14: fwriteshort (sym->value, as86fp); break;
	  case 3<<14: fwritelong (sym->value, as86fp); break;
	}
    }

    /*
     * Write out the string table.
     */
    saa_fpwrite (strs, as86fp);

    /*
     * Write the program text.
     */
    as86_reloc_size = -1;
    as86_write_section (&stext, SECT_TEXT);
    as86_write_section (&sdata, SECT_DATA);
    fputc (0, as86fp);		       /* termination */
}

static void as86_set_rsize (int size) 
{
    if (as86_reloc_size != size) {
	switch (as86_reloc_size = size) {
	  case 1: fputc (0x01, as86fp); break;
	  case 2: fputc (0x02, as86fp); break;
	  case 4: fputc (0x03, as86fp); break;
	  default: error (ERR_PANIC, "bizarre relocation size %d", size);
	}
    }
}

static void as86_write_section (struct Section *sect, int index) 
{
    struct Piece *p;
    unsigned long s;
    long length;

    fputc (0x20+index, as86fp);	       /* select the right section */

    saa_rewind (sect->data);

    for (p = sect->head; p; p = p->next)
	switch (p->type) {
	  case 0:
	    /*
	     * Absolute data. Emit it in chunks of at most 64
	     * bytes.
	     */
	    length = p->bytes;
	    do {
		char buf[64];
		long tmplen = (length > 64 ? 64 : length);
		fputc (0x40 | (tmplen & 0x3F), as86fp);
		saa_rnbytes (sect->data, buf, tmplen);
		fwrite (buf, 1, tmplen, as86fp);
		length -= tmplen;
	    } while (length > 0);
	    break;
	  case 1:
	    /*
	     * A segment-type relocation. First fix up the BSS.
	     */
	    if (p->number == SECT_BSS)
		p->number = SECT_DATA, p->offset += sdata.len;
	    as86_set_rsize (p->bytes);
	    fputc (0x80 | (p->relative ? 0x20 : 0) | p->number, as86fp);
	    if (as86_reloc_size == 2)
		fwriteshort (p->offset, as86fp);
	    else
		fwritelong (p->offset, as86fp);
	    break;
	  case 2:
	    /*
	     * A symbol-type relocation.
	     */
	    as86_set_rsize (p->bytes);
	    s = p->offset;
	    if (s > 65535L)
		s = 3;
	    else if (s > 255)
		s = 2;
	    else if (s > 0)
		s = 1;
	    else
		s = 0;
	    fputc (0xC0 |
		   (p->relative ? 0x20 : 0) |
		   (p->number > 255 ? 0x04 : 0) | s, as86fp);
	    if (p->number > 255)
		fwriteshort (p->number, as86fp);
	    else
		fputc (p->number, as86fp);
	    switch ((int)s) {
	      case 0: break;
	      case 1: fputc (p->offset, as86fp); break;
	      case 2: fwriteshort (p->offset, as86fp); break;
	      case 3: fwritelong (p->offset, as86fp); break;
	    }
	    break;
	}
}

static void as86_sect_write (struct Section *sect,
			     unsigned char *data, unsigned long len) 
{
    saa_wbytes (sect->data, data, len);
    sect->datalen += len;
}

static long as86_segbase (long segment) 
{
    return segment;
}

static int as86_directive (char *directive, char *value, int pass) 
{
    return 0;
}

static void as86_filename (char *inname, char *outname, efunc error) 
{
    char *p;

    if ( (p = strrchr (inname, '.')) != NULL) {
	strncpy (as86_module, inname, p-inname);
	as86_module[p-inname] = '\0';
    } else
	strcpy (as86_module, inname);

    standard_extension (inname, outname, ".o", error);
}

static char *as86_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static int as86_set_info(enum geninfo type, char **val)
{
    return 0;
}
void as86_linenumber (char *name, long segment, long offset, int is_main,
                    int lineno)
{
}
struct ofmt of_as86 = {
    "Linux as86 (bin86 version 0.3) object files",
    "as86",
    NULL,
    null_debug_arr,
    &null_debug_form,
    as86_stdmac,
    as86_init,
    as86_set_info,
    as86_out,
    as86_deflabel, 
    as86_section_names,
    as86_segbase,
    as86_directive,
    as86_filename,
    as86_cleanup
};

#endif /* OF_AS86 */
