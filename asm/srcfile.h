/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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
 * These functions are used to keep track of the source code file and name.
 */
#ifndef ASM_SRCFILE_H
#define ASM_SRCFILE_H

#include "compiler.h"

struct src_location {
    const char *filename;
    int32_t lineno;
};
extern struct src_location _src_here;

void src_init(void);
void src_free(void);
const char *src_set_fname(const char *newname);
static inline const char *src_get_fname(void)
{
    return _src_here.filename;
}
static inline int32_t src_set_linnum(int32_t newline)
{
    int32_t oldline = _src_here.lineno;
    _src_here.lineno = newline;
    return oldline;
}
static inline int32_t src_get_linnum(void)
{
    return _src_here.lineno;
}
/* Can be used when there is no need for the old information */
void src_set(int32_t line, const char *filename);

/*
 * src_get gets both the source file name and line.
 * It is also used if you maintain private status about the source location
 * It return 0 if the information was the same as the last time you
 * checked, -2 if the name changed and (new-old) if just the line changed.
 *
 * xname must point to a filename string previously returned from any
 * function of this subsystem or be NULL; another string value will
 * not work.
 */
static inline int32_t src_get(int32_t *xline, const char **xname)
{
    const char *xn = *xname;
    int32_t xl = *xline;

    *xline = _src_here.lineno;
    *xname = _src_here.filename;

    /* The return value is expected to be optimized out almost everywhere */
    if (!xn || xn != _src_here.filename)
        return -2;
    else
        return _src_here.lineno - xl;
}

/*
 * Returns and sets/returns the current information as a structure.
 */
static inline struct src_location src_where(void)
{
    return _src_here;
}
struct src_location src_update(struct src_location);

#endif /* ASM_SRCFILE_H */
