/* preproc.h  header file for preproc.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_PREPROC_H
#define NASM_PREPROC_H

void pp_include_path (char *);
void pp_pre_include (char *);
void pp_pre_define (char *);
void pp_pre_undefine (char *);
void pp_extra_stdmac (char **);

extern Preproc nasmpp;

#endif
