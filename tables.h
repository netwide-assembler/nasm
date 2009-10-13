/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *     
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

/*
 * tables.h
 *
 * Declarations for auto-generated tables
 */

#ifndef NASM_TABLES_H
#define NASM_TABLES_H

#include "compiler.h"
#include <inttypes.h>
#include "insnsi.h"		/* For enum opcode */
#include "opflags.h"		/* For opflags_t */

/* --- From standard.mac via macros.pl: --- */

/* macros.c */
extern const unsigned char nasm_stdmac[];
extern const unsigned char * const nasm_stdmac_after_tasm;
const unsigned char *nasm_stdmac_find_package(const char *);

/* --- From insns.dat via insns.pl: --- */

/* insnsn.c */
extern const char * const nasm_insn_names[];

/* --- From regs.dat via regs.pl: --- */

/* regs.c */
extern const char * const nasm_reg_names[];
/* regflags.c */
extern const opflags_t nasm_reg_flags[];
/* regvals.c */
extern const int nasm_regvals[];

#endif /* NASM_TABLES_H */
