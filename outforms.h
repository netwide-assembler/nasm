/* outform.h	header file for binding output format drivers to the
 *              remainder of the code in the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

/*
 * This header file allows configuration of which output formats
 * get compiled into the NASM binary. You can configure by defining
 * various preprocessor symbols beginning with "OF_", either on the
 * compiler command line or at the top of this file.
 *
 * OF_ONLY                -- only include specified object formats
 * OF_name                -- ensure that output format 'name' is included
 * OF_NO_name             -- remove output format 'name'
 * OF_DOS                 -- ensure that 'obj', 'bin' & 'win32' are included.
 * OF_UNIX                -- ensure that 'aout', 'aoutb', 'coff', 'elf' are in.
 * OF_OTHERS              -- ensure that 'bin', 'as86' & 'rdf' are in.
 * OF_ALL                 -- ensure that all formats are included.
 *
 * OF_DEFAULT=of_name     -- ensure that 'name' is the default format.
 *
 * eg: -DOF_UNIX -DOF_ELF -DOF_DEFAULT=of_elf would be a suitable config
 * for an average linux system.
 *
 * Default config = -DOF_ALL -DOF_DEFAULT=of_bin
 *
 * You probably only want to set these options while compiling 'nasm.c'. */

#ifndef NASM_OUTFORMS_H
#define NASM_OUTFORMS_H

#include "nasm.h"

/* -------------- USER MODIFIABLE PART ---------------- */

/*
 * Insert #defines here in accordance with the configuration
 * instructions above.
 *
 * E.g.
 *
 * #define OF_ONLY
 * #define OF_OBJ
 * #define OF_BIN
 *
 * for a 16-bit DOS assembler with no extraneous formats.
 */

/* ------------ END USER MODIFIABLE PART -------------- */

/* ====configurable info begins here==== */
/* formats configurable:
 * bin,obj,elf,aout,aoutb,coff,win32,as86,rdf */

/* process options... */

#ifndef OF_ONLY
#ifndef OF_ALL
#define OF_ALL      /* default is to have all formats */
#endif
#endif

#ifdef OF_ALL      /* set all formats on... */
#ifndef OF_BIN
#define OF_BIN
#endif
#ifndef OF_OBJ
#define OF_OBJ
#endif
#ifndef OF_ELF
#define OF_ELF
#endif
#ifndef OF_COFF
#define OF_COFF
#endif
#ifndef OF_AOUT
#define OF_AOUT
#endif
#ifndef OF_AOUTB
#define OF_AOUTB
#endif
#ifndef OF_WIN32
#define OF_WIN32
#endif
#ifndef OF_AS86
#define OF_AS86
#endif
#ifndef OF_RDF
#define OF_RDF
#endif
#endif /* OF_ALL */

/* turn on groups of formats specified.... */
#ifdef OF_DOS
#ifndef OF_OBJ
#define OF_OBJ
#endif
#ifndef OF_BIN
#define OF_BIN
#endif
#ifndef OF_WIN32
#define OF_WIN32
#endif
#endif

#ifdef OF_UNIX
#ifndef OF_AOUT
#define OF_AOUT
#endif
#ifndef OF_AOUTB
#define OF_AOUTB
#endif
#ifndef OF_COFF
#define OF_COFF
#endif
#ifndef OF_ELF
#define OF_ELF
#endif
#endif

#ifdef OF_OTHERS
#ifndef OF_BIN
#define OF_BIN
#endif
#ifndef OF_AS86
#define OF_AS86
#endif
#ifndef OF_RDF
#define OF_RDF
#endif
#endif

/* finally... override any format specifically specifed to be off */
#ifdef OF_NO_BIN
#undef OF_BIN
#endif
#ifdef OF_NO_OBJ
#undef OF_OBJ
#endif
#ifdef OF_NO_ELF
#undef OF_ELF
#endif
#ifdef OF_NO_AOUT
#undef OF_AOUT
#endif
#ifdef OF_NO_AOUTB
#undef OF_AOUTB
#endif
#ifdef OF_NO_COFF
#undef OF_COFF
#endif
#ifdef OF_NO_WIN32
#undef OF_WIN32
#endif
#ifdef OF_NO_AS86
#undef OF_AS86
#endif
#ifdef OF_NO_RDF
#undef OF_RDF
#endif

#ifndef OF_DEFAULT
#define OF_DEFAULT of_bin
#endif

#ifdef BUILD_DRIVERS_ARRAY	       /* only if included from outform.c */

/* pull in the externs for the different formats, then make the *drivers
 * array based on the above defines */

extern struct ofmt of_bin;
extern struct ofmt of_aout;
extern struct ofmt of_aoutb;
extern struct ofmt of_coff;
extern struct ofmt of_elf;
extern struct ofmt of_as86;
extern struct ofmt of_obj;
extern struct ofmt of_win32;
extern struct ofmt of_rdf;
extern struct ofmt of_dbg;

struct ofmt *drivers[]={
#ifdef OF_BIN
    &of_bin,
#endif
#ifdef OF_AOUT
    &of_aout,
#endif
#ifdef OF_AOUTB
    &of_aoutb,
#endif
#ifdef OF_COFF
    &of_coff,
#endif
#ifdef OF_ELF
    &of_elf,
#endif
#ifdef OF_AS86
    &of_as86,
#endif
#ifdef OF_OBJ
    &of_obj,
#endif
#ifdef OF_WIN32
    &of_win32,
#endif
#ifdef OF_RDF
    &of_rdf,
#endif
#ifdef OF_DBG
    &of_dbg,
#endif

   NULL
};

#endif  /* BUILD_DRIVERS_ARRAY */

#endif  /* NASM_OUTFORMS_H */
