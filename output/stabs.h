/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2010 The NASM Authors - All Rights Reserved
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

#ifndef STABS_H_
#define STABS_H_

#include <ctype.h>
#include <inttypes.h>

#include "compiler.h"
#include "nasmlib.h"
#include "nasm.h"

/* offsets */
enum stab_offsets {
    STAB_strdxoff   = 0,
    STAB_typeoff    = 4,
    STAB_otheroff   = 5,
    STAB_descoff    = 6,
    STAB_valoff     = 8,
    STAB_stabsize   = 12,
};

/* stab/non-stab types */
enum stab_types {
    N_UNDF      = 0x00,
    N_ABS       = 0x02,
    N_ABS_EXT   = 0x03,
    N_TEXT      = 0x04,
    N_TEXT_EXT  = 0x05,
    N_DATA      = 0x06,
    N_DATA_EXT  = 0x07,
    N_BSS       = 0x08,
    N_BSS_EXT   = 0x09,
    N_FN_SEQ    = 0x0c,
    N_INDR      = 0x0a,
    N_COMM      = 0x12,
    N_SETA      = 0x14,
    N_SETA_EXT  = 0x15,
    N_SETT      = 0x16,
    N_SETT_EXT  = 0x17,
    N_SETD      = 0x18,
    N_SETD_EXT  = 0x19,
    N_SETB      = 0x1a,
    N_SETB_EXT  = 0x1b,
    N_SETV      = 0x1c,
    N_SETV_EXT  = 0x1d,
    N_WARNING   = 0x1e,
    N_FN        = 0x1f,
    N_GSYM      = 0x20,
    N_FNAME     = 0x22,
    N_FUN       = 0x24,
    N_STSYM     = 0x26,
    N_LCSYM     = 0x28,
    N_MAIN      = 0x2a,
    N_ROSYM     = 0x2c,
    N_BNSYM     = 0x2e,
    N_PC        = 0x30,
    N_NSYMS     = 0x32,
    N_NOMAP     = 0x34,
    N_OBJ       = 0x38,
    N_OPT       = 0x3c,
    N_RSYM      = 0x40,
    N_M2C       = 0x42,
    N_SLINE     = 0x44,
    N_DSLINE    = 0x46,
    N_BSLINE    = 0x48,
    N_BROWS     = 0x48,
    N_DEFD      = 0x4a,
    N_FLINE     = 0x4c,
    N_ENSYM     = 0x4e,
    N_EHDECL    = 0x50,
    N_MOD2      = 0x50,
    N_CATCH     = 0x54,
    N_SSYM      = 0x60,
    N_ENDM      = 0x62,
    N_SO        = 0x64, /* ID for main source file */
    N_OSO       = 0x66,
    N_ALIAS     = 0x6c,
    N_LSYM      = 0x80,
    N_BINCL     = 0x82,
    N_SOL       = 0x84, /* ID for sub-source file */
    N_PSYM      = 0xa0,
    N_EINCL     = 0xa2,
    N_ENTRY     = 0xa4,
    N_LBRAC     = 0xc0,
    N_EXCL      = 0xc2,
    N_SCOPE     = 0xc4,
    N_PATCH     = 0xd0,
    N_RBRAC     = 0xe0,
    N_BCOMM     = 0xe2,
    N_ECOMM     = 0xe4,
    N_ECOML     = 0xe8,
    N_WITH      = 0xea,
    N_NBTEXT    = 0xf0,
    N_NBDATA    = 0xf2,
    N_NBBSS     = 0xf4,
    N_NBSTS     = 0xf6,
    N_NBLCS     = 0xf8,
    N_LENG      = 0xfe,
};

enum stab_source_file {
    N_SO_AS         = 0x01,
    N_SO_C          = 0x02,
    N_SO_ANSI_C     = 0x03,
    N_SO_CC         = 0x04,
    N_SO_FORTRAN    = 0x05,
    N_SO_PASCAL     = 0x06,
    N_SO_FORTRAN90  = 0x07,
    N_SO_OBJC       = 0x32,
    N_SO_OBJCPLUS   = 0x33,
};

#endif /* STABS_H_ */
