/* outrdf.c	output routines for the Netwide Assembler to produce
 *		RDOFF format object files (which are intended mainly
 *		for use in proprietary projects, as the code to load and
 *		execute them is very simple). They will also be used
 *		for device drivers and possibly some executable files
 *		in the MOSCOW operating system. See Rdoff.txt for
 *		details.
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
#include <assert.h>

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"

/* VERBOSE_WARNINGS: define this to add some extra warnings... */
#define VERBOSE_WARNINGS     

#ifdef OF_RDF

typedef short int16;	/* not sure if this will be required to be altered
			   at all... best to typedef it just in case */

static const char *RDOFFId = "RDOFF1";	/* written to start of RDOFF files */

/* the records that can be found in the RDOFF header */

/* Note that whenever a segment is referred to in the RDOFF file, its number
 * is always half of the segment number that NASM uses to refer to it; this
 * is because NASM only allocates even numbered segments, so as to not
 * waste any of the 16 bits of segment number written to the file - this
 * allows up to 65533 external labels to be defined; otherwise it would be
 * 32764. */

struct RelocRec {
  char	type;		/* must be 1 */
  char	segment;	/* only 0 for code, or 1 for data supported,
			 * but add 64 for relative refs (ie do not require
			 * reloc @ loadtime, only linkage) */
  long	offset;		/* from start of segment in which reference is loc'd */
  char	length;		/* 1 2 or 4 bytes */
  int16	refseg;		/* segment to which reference refers to */
};

struct ImportRec {
  char 	type;		/* must be 2 */
  int16	segment;	/* segment number allocated to the label for reloc
			 * records - label is assumed to be at offset zero
			 * in this segment, so linker must fix up with offset
			 * of segment and of offset within segment */
  char	label[33];	/* zero terminated... should be written to file until
			 * the zero, but not after it - max len = 32 chars */
};

struct ExportRec {
  char	type;		/* must be 3 */
  char	segment;	/* segment referred to (0/1) */
  long	offset;		/* offset within segment */
  char	label[33];	/* zero terminated as above. max len = 32 chars */
};

struct DLLRec {
  char	type;		/* must be 4 */
  char	libname[128];	/* name of library to link with at load time */
};

struct BSSRec {
  char	type;		/* must be 5 */
  long	amount;		/* number of bytes BSS to reserve */
};

/* code for managing buffers needed to seperate code and data into individual
 * sections until they are ready to be written to the file.
 * We'd better hope that it all fits in memory else we're buggered... */

#define BUF_BLOCK_LEN 4088		/* selected to match page size (4096)
                                         * on 80x86 machines for efficiency */

typedef struct memorybuffer {
  int length;
  char buffer[BUF_BLOCK_LEN];
  struct memorybuffer *next;
} memorybuffer;

static memorybuffer * newmembuf(void){
  memorybuffer * t;

  t = nasm_malloc(sizeof(memorybuffer));

  t->length = 0;
  t->next = NULL;
  return t;
}

static void membufwrite(memorybuffer *b, void *data, int bytes) {
  int16 w;
  long l;

  if (b->next) { 	/* memory buffer full - use next buffer */
    membufwrite(b->next,data,bytes);
    return;
  }
  if ((bytes < 0 && b->length - bytes > BUF_BLOCK_LEN)
      || (bytes > 0 && b->length + bytes > BUF_BLOCK_LEN)) {

    /* buffer full and no next allocated... allocate and initialise next
     * buffer */

    b->next = newmembuf();
    membufwrite(b->next,data,bytes);
    return;
  }

  switch(bytes) {
  case -4:		/* convert to little-endian */
    l = * (long *) data ;
    b->buffer[b->length++] = l & 0xFF;
    l >>= 8 ;
    b->buffer[b->length++] = l & 0xFF;
    l >>= 8 ;
    b->buffer[b->length++] = l & 0xFF;
    l >>= 8 ;
    b->buffer[b->length++] = l & 0xFF;
    break;

  case -2:
    w = * (int16 *) data ;
    b->buffer[b->length++] = w & 0xFF;
    w >>= 8 ;
    b->buffer[b->length++] = w & 0xFF;
    break;

  default:
    while(bytes--) {
      b->buffer[b->length++] = *(* (unsigned char **) &data);

      (* (unsigned char **) &data)++ ;
    }
    break;
  }
}

static void membufdump(memorybuffer *b,FILE *fp)
{
  if (!b) return;

  fwrite (b->buffer, 1, b->length, fp);

  membufdump(b->next,fp);
}

static int membuflength(memorybuffer *b)
{
  if (!b) return 0;
  return b->length + membuflength(b->next);
}

static void freemembuf(memorybuffer *b)
{
  if (!b) return;
  freemembuf(b->next);
  nasm_free(b);
}

/***********************************************************************
 * Actual code to deal with RDOFF ouput format begins here...
 */

/* global variables set during the initialisation phase */

static memorybuffer *seg[2];	/* seg 0 = code, seg 1 = data */
static memorybuffer *header;	/* relocation/import/export records */

static FILE *ofile;

static efunc error;

static int segtext,segdata,segbss;
static long bsslength;

static void rdf_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval)
{
  ofile = fp;
  error = errfunc;
  seg[0] = newmembuf();
  seg[1] = newmembuf();
  header = newmembuf();
  segtext = seg_alloc();
  segdata = seg_alloc();
  segbss = seg_alloc();
  if (segtext != 0 || segdata != 2 || segbss != 4)
    error(ERR_PANIC,"rdf segment numbers not allocated as expected (%d,%d,%d)",
	  segtext,segdata,segbss);
  bsslength=0;
}

static long rdf_section_names(char *name, int pass, int *bits)
{
  /*
   * Default is 32 bits.
   */
  if (!name)
    *bits = 32;

  if (!name) return 0;
  if (!strcmp(name, ".text"))		return 0;
  else if (!strcmp(name, ".data"))	return 2;
  else if (!strcmp(name, ".bss"))	return 4;
  else
    return NO_SEG;
}

static void write_reloc_rec(struct RelocRec *r)
{
  if (r->refseg != NO_SEG && (r->refseg & 1))
    error (ERR_NONFATAL, "RDF format does not support segment base"
	   " references");

  r->refseg >>= 1;    /* adjust segment nos to RDF rather than NASM */

  membufwrite(header,&r->type,1);
  membufwrite(header,&r->segment,1);
  membufwrite(header,&r->offset,-4);
  membufwrite(header,&r->length,1);
  membufwrite(header,&r->refseg,-2);	/* 9 bytes written */
}

static void write_export_rec(struct ExportRec *r)
{
  r->segment >>= 1;

  membufwrite(header,&r->type,1);
  membufwrite(header,&r->segment,1);
  membufwrite(header,&r->offset,-4);
  membufwrite(header,r->label,strlen(r->label) + 1);
}

static void write_import_rec(struct ImportRec *r)
{
  r->segment >>= 1;

  membufwrite(header,&r->type,1);
  membufwrite(header,&r->segment,-2);
  membufwrite(header,r->label,strlen(r->label) + 1);
}

static void write_bss_rec(struct BSSRec *r)
{
    membufwrite(header,&r->type,1);
    membufwrite(header,&r->amount,-4);
}

static void write_dll_rec(struct DLLRec *r)
{
    membufwrite(header,&r->type,1);
    membufwrite(header,r->libname,strlen(r->libname) + 1);
}

static void rdf_deflabel(char *name, long segment, long offset,
			 int is_global, char *special)
{
  struct ExportRec r;
  struct ImportRec ri;
#ifdef VERBOSE_WARNINGS
  static int warned_common = 0;
#endif

  if (special)
    error (ERR_NONFATAL, "RDOFF format does not support any"
	   " special symbol types");

  if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
    error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
    return;
  }

  if (is_global == 2) {
#ifdef VERBOSE_WARNINGS
    if (!warned_common) {
      error(ERR_WARNING,"common declarations not supported: using extern");
      warned_common = 1;
    }
#endif
    is_global = 1;
  }

  if (segment > 4) {   /* EXTERN declaration */
    ri.type = 2;
    ri.segment = segment;
    strncpy(ri.label,name,32);
    ri.label[32] = 0;
    write_import_rec(&ri);
  } else if (is_global) {
    r.type = 3;
    r.segment = segment;
    r.offset = offset;
    strncpy(r.label,name,32);
    r.label[32] = 0;
    write_export_rec(&r);
  }
}

static void rdf_out (long segto, void *data, unsigned long type,
		     long segment, long wrt)
{
  long bytes = type & OUT_SIZMASK;
  struct RelocRec rr;
  unsigned char databuf[4],*pd;

  if (segto == NO_SEG) {
      if ((type & OUT_TYPMASK) != OUT_RESERVE)
	  error (ERR_NONFATAL, "attempt to assemble code in ABSOLUTE space");
      return;
  }

  segto >>= 1;    /* convert NASM segment no to RDF number */

  if (segto != 0 && segto != 1 && segto != 2) {
    error(ERR_NONFATAL,"specified segment not supported by rdf output format");
    return;
  }

  if (wrt != NO_SEG) {
    wrt = NO_SEG;		       /* continue to do _something_ */
    error (ERR_NONFATAL, "WRT not supported by rdf output format");
  }

  type &= OUT_TYPMASK;

  if (segto == 2 && type != OUT_RESERVE)
  {
      error(ERR_NONFATAL, "BSS segments may not be initialised");

      /* just reserve the space for now... */

      if (type == OUT_REL2ADR)
	bytes = 2;
      else
	bytes = 4;
      type = OUT_RESERVE;
  }

  if (type == OUT_RESERVE) {
      if (segto == 2)		/* BSS segment space reserverd */
	  bsslength += bytes;
      else
	while (bytes --)
	    membufwrite(seg[segto],databuf,1);
  }
  else if (type == OUT_RAWDATA) {
      if (segment != NO_SEG)
	  error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
      membufwrite(seg[segto],data,bytes);
  }
  else if (type == OUT_ADDRESS) {

    /* if segment == NO_SEG then we are writing an address of an
       object within the same segment - do not produce reloc rec. */

    if (segment != NO_SEG)
    {

	/* it's an address, so we must write a relocation record */

	rr.type = 1;		/* type signature */
	rr.segment = segto;		/* segment we're currently in */
	rr.offset = membuflength(seg[segto]);	/* current offset */
	rr.length = bytes;		/* length of reference */
	rr.refseg = segment;	/* segment referred to */
	write_reloc_rec(&rr);
    }

    pd = databuf;	/* convert address to little-endian */
    if (bytes == 2)
      WRITESHORT (pd, *(long *)data);
    else
      WRITELONG (pd, *(long *)data);

    membufwrite(seg[segto],databuf,bytes);

  }
  else if (type == OUT_REL2ADR)
  {
    if (segment == segto)
      error(ERR_PANIC, "intra-segment OUT_REL2ADR");
    if (segment != NO_SEG && segment % 2) {
      error(ERR_NONFATAL, "rdf format does not support segment base refs");
    }

    rr.type = 1;		/* type signature */
    rr.segment = segto+64;	/* segment we're currently in + rel flag */
    rr.offset = membuflength(seg[segto]);	/* current offset */
    rr.length = 2;		/* length of reference */
    rr.refseg = segment;	/* segment referred to */
    write_reloc_rec(&rr);

    /* work out what to put in the code: offset of the end of this operand,
     * subtracted from any data specified, so that loader can just add
     * address of imported symbol onto it to get address relative to end of
     * instruction: import_address + data(offset) - end_of_instrn */

    rr.offset = *(long *)data -(rr.offset + bytes);

    membufwrite(seg[segto],&rr.offset,-2);
  }
  else if (type == OUT_REL4ADR)
  {
    if (segment == segto)
      error(ERR_PANIC, "intra-segment OUT_REL4ADR");
    if (segment != NO_SEG && segment % 2) {
      error(ERR_NONFATAL, "rdf format does not support segment base refs");
    }

    rr.type = 1;		/* type signature */
    rr.segment = segto+64;	/* segment we're currently in + rel tag */
    rr.offset = membuflength(seg[segto]);	/* current offset */
    rr.length = 4;		/* length of reference */
    rr.refseg = segment;	/* segment referred to */
    write_reloc_rec(&rr);

    rr.offset = *(long *)data -(rr.offset + bytes);
    membufwrite(seg[segto],&rr.offset,-4);
  }
}

static void rdf_cleanup (int debuginfo) {
  long		l;
  unsigned char b[4],*d;
  struct BSSRec	bs;

    (void) debuginfo;


  /* should write imported & exported symbol declarations to header here */

  /* generate the output file... */
  fwrite(RDOFFId,6,1,ofile);	/* file type magic number */

  if (bsslength != 0)		/* reserve BSS */
  {
      bs.type = 5;
      bs.amount = bsslength;
      write_bss_rec(&bs);
  }

  l = membuflength(header);d=b;
  WRITELONG(d,l);

  fwrite(b,4,1,ofile);		/* write length of header */
  membufdump(header,ofile);	/* dump header */

  l = membuflength(seg[0]);d=b;	/* code segment */
  WRITELONG(d,l);

  fwrite(b,4,1,ofile);
  membufdump(seg[0],ofile);

  l = membuflength(seg[1]);d=b;	/* data segment */
  WRITELONG(d,l);

  fwrite(b,4,1,ofile);
  membufdump(seg[1],ofile);

  freemembuf(header);
  freemembuf(seg[0]);
  freemembuf(seg[1]);
  fclose(ofile);
}

static long rdf_segbase (long segment) {
    return segment;
}

static int rdf_directive (char *directive, char *value, int pass) {
    struct DLLRec r;
    
    if (! strcmp(directive, "library")) {
	if (pass == 1) {
	    r.type = 4;
	    strcpy(r.libname, value);
	    write_dll_rec(&r);
	}
	return 1;
    }

    return 0;
}

static void rdf_filename (char *inname, char *outname, efunc error) {
  standard_extension(inname,outname,".rdf",error);
}

static char *rdf_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%imacro library 1+.nolist",
    "[library %1]",
    "%endmacro",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static int rdf_set_info(enum geninfo type, char **val)
{
    return 0;
}

struct ofmt of_rdf = {
  "Relocatable Dynamic Object File Format v1.1",
#ifdef OF_RDF2
  "oldrdf",
#else
  "rdf",
#endif
  NULL,
  null_debug_arr,
  &null_debug_form,
  rdf_stdmac,
  rdf_init,
  rdf_set_info,
  rdf_out,
  rdf_deflabel,
  rdf_section_names,
  rdf_segbase,
  rdf_directive,
  rdf_filename,
  rdf_cleanup
};

#endif /* OF_RDF */
