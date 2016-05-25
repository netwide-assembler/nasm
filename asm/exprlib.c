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
 * exprlib.c
 *
 * Library routines to manipulate expression data types.
 */

#include "nasm.h"

/*
 * Return true if the argument is a simple scalar. (Or a far-
 * absolute, which counts.)
 */
int is_simple(expr * vect)
{
    while (vect->type && !vect->value)
        vect++;
    if (!vect->type)
        return 1;
    if (vect->type != EXPR_SIMPLE)
        return 0;
    do {
        vect++;
    } while (vect->type && !vect->value);
    if (vect->type && vect->type < EXPR_SEGBASE + SEG_ABS)
        return 0;
    return 1;
}

/*
 * Return true if the argument is a simple scalar, _NOT_ a far-
 * absolute.
 */
int is_really_simple(expr * vect)
{
    while (vect->type && !vect->value)
        vect++;
    if (!vect->type)
        return 1;
    if (vect->type != EXPR_SIMPLE)
        return 0;
    do {
        vect++;
    } while (vect->type && !vect->value);
    if (vect->type)
        return 0;
    return 1;
}

/*
 * Return true if the argument is relocatable (i.e. a simple
 * scalar, plus at most one segment-base, plus possibly a WRT).
 */
int is_reloc(expr * vect)
{
    while (vect->type && !vect->value)  /* skip initial value-0 terms */
        vect++;
    if (!vect->type)            /* trivially return true if nothing */
        return 1;               /* is present apart from value-0s */
    if (vect->type < EXPR_SIMPLE)       /* false if a register is present */
        return 0;
    if (vect->type == EXPR_SIMPLE) {    /* skip over a pure number term... */
        do {
            vect++;
        } while (vect->type && !vect->value);
        if (!vect->type)        /* ...returning true if that's all */
            return 1;
    }
    if (vect->type == EXPR_WRT) {       /* skip over a WRT term... */
        do {
            vect++;
        } while (vect->type && !vect->value);
        if (!vect->type)        /* ...returning true if that's all */
            return 1;
    }
    if (vect->value != 0 && vect->value != 1)
        return 0;               /* segment base multiplier non-unity */
    do {                        /* skip over _one_ seg-base term... */
        vect++;
    } while (vect->type && !vect->value);
    if (!vect->type)            /* ...returning true if that's all */
        return 1;
    return 0;                   /* And return false if there's more */
}

/*
 * Return true if the argument contains an `unknown' part.
 */
int is_unknown(expr * vect)
{
    while (vect->type && vect->type < EXPR_UNKNOWN)
        vect++;
    return (vect->type == EXPR_UNKNOWN);
}

/*
 * Return true if the argument contains nothing but an `unknown'
 * part.
 */
int is_just_unknown(expr * vect)
{
    while (vect->type && !vect->value)
        vect++;
    return (vect->type == EXPR_UNKNOWN);
}

/*
 * Return the scalar part of a relocatable vector. (Including
 * simple scalar vectors - those qualify as relocatable.)
 */
int64_t reloc_value(expr * vect)
{
    while (vect->type && !vect->value)
        vect++;
    if (!vect->type)
        return 0;
    if (vect->type == EXPR_SIMPLE)
        return vect->value;
    else
        return 0;
}

/*
 * Return the segment number of a relocatable vector, or NO_SEG for
 * simple scalars.
 */
int32_t reloc_seg(expr * vect)
{
    while (vect->type && (vect->type == EXPR_WRT || !vect->value))
        vect++;
    if (vect->type == EXPR_SIMPLE) {
        do {
            vect++;
        } while (vect->type && (vect->type == EXPR_WRT || !vect->value));
    }
    if (!vect->type)
        return NO_SEG;
    else
        return vect->type - EXPR_SEGBASE;
}

/*
 * Return the WRT segment number of a relocatable vector, or NO_SEG
 * if no WRT part is present.
 */
int32_t reloc_wrt(expr * vect)
{
    while (vect->type && vect->type < EXPR_WRT)
        vect++;
    if (vect->type == EXPR_WRT) {
        return vect->value;
    } else
        return NO_SEG;
}
