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
 * srcfile.c - keep track of the current position in the input stream
 */

#include "compiler.h"


#include "nasmlib.h"
#include "hashtbl.h"
#include "srcfile.h"

struct src_location _src_here;

static struct hash_table filename_hash;

void src_init(void)
{
}

void src_free(void)
{
    hash_free_all(&filename_hash, false);
}

/*
 * Set the current filename, returning the old one.  The input
 * filename is duplicated if needed.
 */
const char *src_set_fname(const char *newname)
{
    struct hash_insert hi;
    const char *oldname;
    void **dp;

    if (newname) {
        dp = hash_find(&filename_hash, newname, &hi);
        if (dp) {
            newname = (const char *)(*dp);
        } else {
            newname = nasm_strdup(newname);
            hash_add(&hi, newname, (void *)newname);
        }
    }

    oldname = _src_here.filename;
    _src_here.filename = newname;
    return oldname;
}

void src_set(int32_t line, const char *fname)
{
    src_set_fname(fname);
    src_set_linnum(line);
}

struct src_location src_update(struct src_location whence)
{
    struct src_location oldhere = _src_here;

    src_set_fname(whence.filename);
    src_set_linnum(whence.lineno);

    return oldhere;
}
