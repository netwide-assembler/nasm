/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2024 The NASM Authors - All Rights Reserved
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
 * disp8.h   header file for disp8.c
 */

#ifndef NASM_DISP8_H
#define NASM_DISP8_H

#include "nasm.h"

/*
 * Find shift value for compressed displacement (disp8 << shift)
 */
static inline unsigned int get_disp8_shift(const insn *ins)
{
    bool evex_b;
    unsigned int  evex_w;
    unsigned int  vectlen;
    enum ttypes   tuple = ins->evex_tuple;

    if (likely(!tuple))
        return 0;

    evex_b  = !!(ins->evex & EVEX_B);
    evex_w  = !!(ins->evex & EVEX_W);
    /* XXX: consider RC/SAE here?! */
    vectlen = getfield(EVEX_LL, ins->evex);

    switch (tuple) {
        /* Full, half vector unless broadcast */
    case FV:
        return evex_b ? 2 + evex_w : vectlen + 4;
    case HV:
        return evex_b ? 2 + evex_w : vectlen + 3;

        /* Full vector length */
    case FVM:
        return vectlen + 4;

        /* Fixed tuple lengths */
    case T1S8:
        return 0;
    case T1S16:
        return 1;
    case T1F32:
        return 2;
    case T1F64:
        return 3;
    case M128:
        return 4;

        /* One scalar */
    case T1S:
        return 2 + evex_w;

        /* 2, 4, 8 32/64-bit elements */
    case T2:
        return 3 + evex_w;
    case T4:
        return 4 + evex_w;
    case T8:
        return 5 + evex_w;

        /* Half, quarter, eigth mem */
    case HVM:
        return vectlen + 3;
    case QVM:
        return vectlen + 2;
    case OVM:
        return vectlen + 1;

        /* MOVDDUP */
    case DUP:
        return vectlen + 3;

    default:
        return 0;
    }
}

#endif  /* NASM_DISP8_H */
