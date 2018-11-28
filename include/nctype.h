/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2018 The NASM Authors - All Rights Reserved
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
 * ctype-like functions specific to NASM
 */
#ifndef NASM_NCTYPE_H
#define NASM_NCTYPE_H

#include "compiler.h"

void nasm_ctype_init(void);

extern unsigned char nasm_tolower_tab[256];
static inline char nasm_tolower(char x)
{
    return nasm_tolower_tab[(unsigned char)x];
}

/*
 * NASM ctype table
 */
enum nasm_ctype {
    NCT_CTRL       = 0x001,
    NCT_SPACE      = 0x002,
    NCT_ASCII      = 0x004,
    NCT_LOWER      = 0x008,     /* isalpha(x) && tolower(x) == x */
    NCT_UPPER      = 0x010,     /* isalpha(x) && tolower(x) != x */
    NCT_DIGIT      = 0x020,
    NCT_HEX        = 0x040,
    NCT_ID         = 0x080,
    NCT_IDSTART    = 0x100,
    NCT_MINUS      = 0x200,     /* - */
    NCT_DOLLAR     = 0x400,     /* $ */
    NCT_UNDER      = 0x800      /* _ */
};

extern uint16_t nasm_ctype_tab[256];
static inline bool nasm_ctype(unsigned char x, enum nasm_ctype mask)
{
    return (nasm_ctype_tab[x] & mask) != 0;
}

static inline bool nasm_isspace(char x)
{
    return nasm_ctype(x, NCT_SPACE);
}

static inline bool nasm_isalpha(char x)
{
    return nasm_ctype(x, NCT_LOWER|NCT_UPPER);
}

static inline bool nasm_isdigit(char x)
{
    return nasm_ctype(x, NCT_DIGIT);
}
static inline bool nasm_isalnum(char x)
{
    return nasm_ctype(x, NCT_LOWER|NCT_UPPER|NCT_DIGIT);
}
static inline bool nasm_isxdigit(char x)
{
    return nasm_ctype(x, NCT_HEX);
}
static inline bool nasm_isidstart(char x)
{
    return nasm_ctype(x, NCT_IDSTART);
}
static inline bool nasm_isidchar(char x)
{
    return nasm_ctype(x, NCT_ID);
}
static inline bool nasm_isbrcchar(char x)
{
    return nasm_ctype(x, NCT_ID|NCT_MINUS);
}
static inline bool nasm_isnumstart(char x)
{
    return nasm_ctype(x, NCT_DIGIT|NCT_DOLLAR);
}
static inline bool nasm_isnumchar(char x)
{
    return nasm_ctype(x, NCT_DIGIT|NCT_LOWER|NCT_UPPER|NCT_UNDER);
}

/* TASM-compatible mode requires ? to be an identifier character */
static inline void nasm_ctype_tasm_mode(void)
{
    nasm_ctype_tab['?'] |= NCT_ID|NCT_IDSTART;
}

#endif /* NASM_NCTYPE_H */
