/* outdbg.c	output routines for the Netwide Assembler to produce
 *		a debugging trace
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

#ifdef OF_DBG

FILE *dbgf;
efunc dbgef;

int segcode,segdata,segbss;

static void dbg_init(FILE *fp, efunc errfunc, ldfunc ldef)
{
  dbgf = fp;
  dbgef = errfunc;
  (void) ldef;
  segcode = seg_alloc();
  segdata = seg_alloc();
  segbss = seg_alloc();
  fprintf(fp,"NASM Output format debug dump - code=%d,data=%d,bss=%d\n",
	  segcode,segdata,segbss);
}

static void dbg_cleanup(void)
{
  fclose(dbgf);
}

static long dbg_section_names (char *name, int pass, int *bits)
{
    /*
     * We must have an initial default: let's make it 16.
     */
    if (!name)
	*bits = 16;

    if (!name)
	return 0;

    if (!strcmp(name, ".text"))
	return segcode;
    else if (!strcmp(name, ".data"))
	return segdata;
    else if (!strcmp(name, ".bss"))
	return segbss;
    else
	return NO_SEG;
}

static void dbg_deflabel (char *name, long segment, long offset,
			   int is_global) {
    fprintf(dbgf,"deflabel %s := %08lx:%08lx %s (%d)\n",name,segment,offset,
	    is_global ? "global" : "local", is_global);
}

static void dbg_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) {
  long realbytes = type & OUT_SIZMASK;
  long ldata;
  int id;

  type &= OUT_TYPMASK;

  fprintf(dbgf,"out to %lx, len = %ld: ",segto,realbytes);

  switch(type) {
  case OUT_RESERVE:
    fprintf(dbgf,"reserved.\n"); break;
  case OUT_RAWDATA:
    fprintf(dbgf,"raw data = ");
    while (realbytes--) {
      id = *(unsigned char *)data;
      data = (char *)data + 1;
      fprintf(dbgf,"%02x ",id);
    }
    fprintf(dbgf,"\n"); break;
  case OUT_ADDRESS:
    ldata = 0; /* placate gcc */
    if (realbytes == 1)
      ldata = *((char *)data);
    else if (realbytes == 2)
      ldata = *((short *)data);
    else if (realbytes == 4)
      ldata = *((long *)data);
    fprintf(dbgf,"addr %08lx (seg %08lx, wrt %08lx)\n",ldata,
	    segment,wrt);break;
  case OUT_REL2ADR:
    fprintf(dbgf,"rel2adr %04x (seg %08lx)\n",(int)*(short *)data,segment);
    break;
  case OUT_REL4ADR:
    fprintf(dbgf,"rel4adr %08lx (seg %08lx)\n",*(long *)data,segment);
    break;
  default:
    fprintf(dbgf,"unknown\n");
    break;
  }
}

static long dbg_segbase(long segment) {
  return segment;
}

static int dbg_directive (char *directive, char *value, int pass) {
  return 0;
}

static void dbg_filename (char *inname, char *outname, efunc error) {
    standard_extension (inname, outname, ".dbg", error);
}

struct ofmt of_dbg = {
    "Trace of all info passed to output stage",
    "dbg",
    dbg_init,
    dbg_out,
    dbg_deflabel,
    dbg_section_names,
    dbg_segbase,
    dbg_directive,
    dbg_filename,
    dbg_cleanup
};

#endif /* OF_DBG */
