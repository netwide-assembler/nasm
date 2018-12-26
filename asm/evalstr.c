/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2018 The NASM Authors - All Rights Reserved
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
 * Wrapper routine for evaluation
 *
 * Useful in directives etc. where we have a string and want a number
 * or possibly a relocatable expression.
 */

#include "compiler.h"
#include "nasm.h"
#include "stdscan.h"
#include "eval.h"
#include "evalstr.h"

/*
 * Evaluate a simple value from a string. A segment and/or WRT MAY be
 * permitted, but if NULL is passed into the respective pointers, then
 * that is an error.
 */
static int stdscan_save(void *pvt, struct tokenval *tv)
{
    char **strptr = pvt;

    *strptr = stdscan_get();
    return stdscan(NULL, tv);
}

int64_t evaluate_str(char **str, bool crit, int32_t *segment, int32_t *wrt)
{
    struct tokenval tokval;
    expr *e;
    int32_t seg;

    stdscan_reset();
    stdscan_set(*str);

    tokval.t_type = TOKEN_INVALID;
    e = evaluate(stdscan_save, str, &tokval, NULL, crit, NULL);
    *str = nasm_skip_spaces(*str);

    if (segment)
        *segment = NO_SEG;

    if (is_unknown(e) && !crit)
        return 0;

    if (!is_reloc(e)) {
        nasm_nonfatal("invalid expression");
        return 0;
    }

    seg = reloc_seg(e);
    if (*segment) {
        *segment = seg;
    } else if (seg != NO_SEG) {
        nasm_nonfatal("expression cannot contain a segment reference");
    }

    seg = reloc_wrt(e);
    if (*wrt) {
        *wrt = seg;
    } else if (seg != NO_SEG) {
        nasm_nonfatal("expression cannot contain WRT");
    }

    return reloc_value(e);
}

/*
 * Evaluate a size expression: a pure integer, but size specifiers like
 * BYTE are treated like integer constants.
 */
static int stdscan_save_size(void *pvt, struct tokenval *tv)
{
    char **strptr = pvt;
    int t;

    *strptr = stdscan_get();
    t = stdscan(NULL, tv);

    if (t == TOKEN_SIZE) {
        /* Treat size specifiers as integer constants */
        tv->t_type = t = TOKEN_NUM;
        tv->t_integer = tv->t_inttwo; /* Contains the size equivalent */
    }

    return t;
}

int64_t evaluate_size(char **str, bool crit)
{
    struct tokenval tokval;
    expr *e;

    stdscan_reset();
    stdscan_set(*str);

    tokval.t_type = TOKEN_INVALID;
    e = evaluate(stdscan_save_size, str, &tokval, NULL, crit, NULL);
    *str = nasm_skip_spaces(*str);

    if (is_unknown(e) && !crit)
        return 0;

    if (!is_reloc(e) || reloc_seg(e) != NO_SEG || reloc_wrt(e) != NO_SEG) {
        nasm_nonfatal("invalid size expression");
        return 0;
    }

    return reloc_value(e);
}
