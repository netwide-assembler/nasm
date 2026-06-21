/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 2025 The NASM Authors - All Rights Reserved */

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

static void *do_uncompress_zdata(const struct zdata *zdata)
{
    z_stream zs;
    void *buf = nasm_malloc(zdata->dsize);

    nasm_zero(zs);
    zs.next_in   = (void *)zdata->zdata;
    zs.avail_in  = zdata->zsize;
    zs.next_out  = buf;
    zs.avail_out = zdata->dsize;
    zs.zalloc    = nasm_z_alloc;
    zs.zfree     = nasm_z_free;

    if (inflateInit2(&zs, 15) != Z_OK)
        panic();

    if (inflate(&zs, Z_FINISH) != Z_STREAM_END)
        panic();

    inflateEnd(&zs);
    return buf;
}

void *uncompress_zdata(const struct zdata *zdata)
{
    if (zdata->zsize == zdata->dsize)
        return nasm_memdup(zdata->zdata, zdata->dsize);
    else
        return do_uncompress_zdata(zdata);
}

const void *get_zdata(const struct zdata *zdata, void **buf)
{
    if (zdata->zsize == zdata->dsize) {
        *buf = NULL;
        return zdata->zdata;
    } else {
        return *buf = do_uncompress_zdata(zdata);
    }
}
