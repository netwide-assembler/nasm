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
 * OF_UNIX                -- ensure that 'aout', 'aoutb', 'coff', 'elf32' 'elf64' are in.
 * OF_OTHERS              -- ensure that 'bin', 'as86' & 'rdf' are in.
 * OF_ALL                 -- ensure that all formats are included.
 *                           note that this doesn't include 'dbg', which is
 *                           only really useful if you're doing development
 *                           work on NASM. Define OF_DBG if you want this.
 *
 * OF_DEFAULT=of_name     -- ensure that 'name' is the default format.
 *
 * eg: -DOF_UNIX -DOF_ELF32 -DOF_DEFAULT=of_elf32 would be a suitable config
 * for an average linux system.
 *
 * Default config = -DOF_ALL -DOF_DEFAULT=of_bin
 *
 * You probably only want to set these options while compiling 'nasm.c'. */

#ifndef NASM_OUTFORM_H
#define NASM_OUTFORM_H

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
 * bin,obj,elf32,elf64,aout,aoutb,coff,win32,as86,rdf2,macho */

/* process options... */

#ifndef OF_ONLY
#ifndef OF_ALL
#define OF_ALL                  /* default is to have all formats */
#endif
#endif

#ifdef OF_ALL                   /* set all formats on... */
#ifndef OF_BIN
#define OF_BIN
#endif
#ifndef OF_OBJ
#define OF_OBJ
#endif
#ifndef OF_ELF32
#define OF_ELF32
#endif
#ifndef OF_ELF64
#define OF_ELF64
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
#ifndef OF_WIN64
#define OF_WIN64
#endif
#ifndef OF_AS86
#define OF_AS86
#endif
#ifndef OF_RDF2
#define OF_RDF2
#endif
#ifndef OF_IEEE
#define OF_IEEE
#endif
#ifndef OF_MACHO
#define OF_MACHO
#endif
#endif                          /* OF_ALL */

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
#ifndef OF_WIN64
#define OF_WIN64
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
#ifndef OF_ELF32
#define OF_ELF32
#endif
#ifndef OF_ELF64
#define OF_ELF64
#endif
#endif

#ifdef OF_OTHERS
#ifndef OF_BIN
#define OF_BIN
#endif
#ifndef OF_AS86
#define OF_AS86
#endif
#ifndef OF_RDF2
#define OF_RDF2
#endif
#ifndef OF_IEEE
#define OF_IEEE
#endif
#ifndef OF_MACHO
#define OF_MACHO
#endif
#endif

/* finally... override any format specifically specified to be off */
#ifdef OF_NO_BIN
#undef OF_BIN
#endif
#ifdef OF_NO_OBJ
#undef OF_OBJ
#endif
#ifdef OF_NO_ELF32
#undef OF_ELF32
#endif
#ifdef OF_NO_ELF64
#undef OF_ELF64
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
#ifdef OF_NO_WIN64
#undef OF_WIN64
#endif
#ifdef OF_NO_AS86
#undef OF_AS86
#endif
#ifdef OF_NO_RDF2
#undef OF_RDF
#endif
#ifdef OF_NO_IEEE
#undef OF_IEEE
#endif
#ifdef OF_NO_MACHO
#undef OF_MACHO
#endif

#ifndef OF_DEFAULT
#define OF_DEFAULT of_bin
#endif

#ifdef BUILD_DRIVERS_ARRAY      /* only if included from outform.c */

/* pull in the externs for the different formats, then make the *drivers
 * array based on the above defines */

extern struct ofmt of_bin;
extern struct ofmt of_aout;
extern struct ofmt of_aoutb;
extern struct ofmt of_coff;
extern struct ofmt of_elf32;
extern struct ofmt of_elf;
extern struct ofmt of_elf64;
extern struct ofmt of_as86;
extern struct ofmt of_obj;
extern struct ofmt of_win32;
extern struct ofmt of_win64;
extern struct ofmt of_rdf2;
extern struct ofmt of_ieee;
extern struct ofmt of_macho;
extern struct ofmt of_dbg;

struct ofmt *drivers[] = {
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
#ifdef OF_ELF32
    &of_elf32,
    &of_elf,
#endif
#ifdef OF_ELF64
    &of_elf64,
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
#ifdef OF_WIN64
    &of_win64,
#endif
#ifdef OF_RDF2
    &of_rdf2,
#endif
#ifdef OF_IEEE
    &of_ieee,
#endif
#ifdef OF_MACHO
    &of_macho,
#endif
#ifdef OF_DBG
    &of_dbg,
#endif

    NULL
};

#endif                          /* BUILD_DRIVERS_ARRAY */

struct ofmt *ofmt_find(char *);
struct dfmt *dfmt_find(struct ofmt *, char *);
void ofmt_list(struct ofmt *, FILE *);
void dfmt_list(struct ofmt *ofmt, FILE * fp);
struct ofmt *ofmt_register(efunc error);

#endif                          /* NASM_OUTFORM_H */
