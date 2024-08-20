/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2017 The NASM Authors - All Rights Reserved
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
bool is_simple(const expr *vect)
{
    while (vect->type && !vect->value)
        vect++;
    if (!vect->type)
        return true;
    if (vect->type != EXPR_SIMPLE)
        return false;
    do {
        vect++;
    } while (vect->type && !vect->value);
    if (vect->type && vect->type < EXPR_SEGBASE + SEG_ABS)
        return false;
    return true;
}

/*
 * Return true if the argument is a simple scalar, _NOT_ a far-
 * absolute.
 */
bool is_really_simple(const expr *vect)
{
    while (vect->type && !vect->value)
        vect++;
    if (!vect->type)
        return true;
    if (vect->type != EXPR_SIMPLE)
        return false;
    do {
        vect++;
    } while (vect->type && !vect->value);
    if (vect->type)
        return false;
    return true;
}

/*
 * Classify an expression based on its components
 */
enum expr_classes expr_class(const expr *vect)
{
    enum expr_classes class = EC_ZERO;

    for (; vect->type; vect++) {
        if (!vect->value) {
            /* Value-0 term */
        } else if (vect->type < EXPR_UNKNOWN) {
            if ((class & EC_REGISTER) || vect->value != 1)
                class |= EC_REGEXPR;
            else
                class |= EC_REGISTER;
        } else if (vect->type == EXPR_UNKNOWN) {
            class |= EC_UNKNOWN;
        } else if (vect->type == EXPR_SIMPLE) {
            /* Pure number term */
            class |= EC_CONST;
        } else if (vect->type == EXPR_WRT) {
            class |= EC_WRT;
        } else if (vect->type < EXPR_SEGBASE) {
            class |= EC_COMPLEX;
        } else if (vect->type >= EXPR_SEGBASE + SEG_ABS) {
            /* It is an absolute segment */
            if (class & (EC_SEG|EC_SEGABS))
                class |= EC_COMPLEX;
            class |= EC_SEGABS;
        } else {
            /* It is a segment */
            if (vect->value == 1) {
                if (class & (EC_SEG|EC_SEGABS))
                    class |= EC_COMPLEX;
                class |= EC_SEG;
            } else if (vect->value == -1) {
                /* can only subtract current segment, and only once */
                if (vect->type != location.segment + EXPR_SEGBASE ||
                    (class & EC_SELFREL))
                    class |= EC_COMPLEX;
                class |= EC_SELFREL;
            } else {
                /* Non-simple segment arithmetic */
                class |= EC_COMPLEX;
            }
        }
    }

    return class;
}

/*
 * Return true if the argument is relocatable (i.e. a simple
 * scalar, plus at most one segment-base, possibly a subtraction
 * of the current segment base, plus possibly a WRT).
 */
bool is_reloc(const expr *vect)
{
    return !(expr_class(vect) & ~EC_RELOC);
}

/*
 * Return true if the argument contains an `unknown' part.
 */
bool is_unknown(const expr *vect)
{
    return !!(expr_class(vect) & EC_UNKNOWN);
}

/*
 * Return true if the argument contains nothing but an `unknown'
 * part.
 */
bool is_just_unknown(const expr *vect)
{
    return expr_class(vect) == EC_UNKNOWN;
}

/*
 * Return the scalar part of a relocatable vector. (Including
 * simple scalar vectors - those qualify as relocatable.)
 */
int64_t reloc_value(const expr *vect)
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
int32_t reloc_seg(const expr *vect)
{
    for (; vect->type; vect++) {
        if (vect->type >= EXPR_SEGBASE && vect->value == 1)
            return vect->type - EXPR_SEGBASE;
    }

    return NO_SEG;
}

/*
 * Return the WRT segment number of a relocatable vector, or NO_SEG
 * if no WRT part is present.
 */
int32_t reloc_wrt(const expr *vect)
{
    while (vect->type && vect->type < EXPR_WRT)
        vect++;
    if (vect->type == EXPR_WRT) {
        return vect->value;
    } else
        return NO_SEG;
}

/*
 * Return true if this expression contains a subtraction of the location
 */
bool is_self_relative(const expr *vect)
{
    return !!(expr_class(vect) & EC_SELFREL);
}
