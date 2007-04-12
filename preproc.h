/* preproc.h  header file for preproc.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_PREPROC_H
#define NASM_PREPROC_H

void pp_include_path(int8_t *);
int8_t **pp_get_include_path_ptr(int8_t **pPrevPath);
void pp_pre_include(int8_t *);
void pp_pre_define(int8_t *);
void pp_pre_undefine(int8_t *);
void pp_runtime(int8_t *);
void pp_extra_stdmac(const int8_t **);

extern Preproc nasmpp;

#endif
