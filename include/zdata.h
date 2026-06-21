/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

/*
 * zdata.h - compressed data functions
 */

#ifndef NASM_ZDATA_H
#define NASM_ZDATA_H 1

struct zdata {
    unsigned int dsize, zsize;
    const void *zdata;
};

/*
 * Always uncompress zdata; if the data is uncompressed, return a copy of
 * it in a new buffer.
 */
void *uncompress_zdata(const struct zdata *);

/*
 * Uncompress zdata only if it actually compressed; otherwise return
 * a pointer to the stored uncompressed data. *buf is set to the buffer
 * address if it was nasm_malloc'd, otherwise NULL (this pointer can be
 * safely passed to nasm_free() or nasm_delete().)
 */
const void *get_zdata(const struct zdata *, void **buf);

#endif /* NASM_ZDATA_H */
