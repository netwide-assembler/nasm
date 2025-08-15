/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2025 The NASM Authors - All Rights Reserved
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
 * This needs to be in a separate file because zlib.h conflicts
 * with opflags.h.
 */
#include "compiler.h"
#include "zlib.h"
#include "macros.h"
#include "nasmlib.h"
#include "error.h"

/*
 * read line from standard macros set,
 * if there no more left -- return NULL
 */
static void *nasm_z_alloc(void *opaque, unsigned int items, unsigned int size)
{
    (void)opaque;
    return nasm_calloc(items, size);
}

static void nasm_z_free(void *opaque, void *ptr)
{
    (void)opaque;
    nasm_free(ptr);
}

char *uncompress_stdmac(const macros_t *sm)
{
    z_stream zs;
    void *buf = nasm_malloc(sm->dsize);

    nasm_zero(zs);
    zs.next_in   = (void *)sm->zdata;
    zs.avail_in  = sm->zsize;
    zs.next_out  = buf;
    zs.avail_out = sm->dsize;
    zs.zalloc    = nasm_z_alloc;
    zs.zfree     = nasm_z_free;

    if (inflateInit2(&zs, 0) != Z_OK)
        panic();

    if (inflate(&zs, Z_FINISH) != Z_STREAM_END)
        panic();

    inflateEnd(&zs);
    return buf;
}
