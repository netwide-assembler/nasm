/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2017 The NASM Authors - All Rights Reserved
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
 * mempool.h - pool of constant, deduplicated strings
 */

#ifndef NASM_MEMPOOL_H
#define NASM_MEMPOOL_H

#include "compiler.h"

#include <stdarg.h>
#include <string.h>

struct mempool_storage;
struct mempool {
    struct mempool_storage *sshead, *sstail;
    size_t totalbytes;
};
/* A single-member array which can decay to a pointer for simplicity */
typedef struct mempool mempool[1];

char *mempool_add(struct mempool *pool, const char *str);
char *mempool_cat(struct mempool *pool, const char *str1, const char *str2);
char *mempool_cat3(struct mempool *pool, const char *str1,
                         const char *str2, const char *str3);
char *mempool_vprintf(struct mempool *pool, const char *fmt, va_list va);
char *mempool_printf(struct mempool *pool, const char *fmt, ...);

void *mempool_alloc(struct mempool *pool, size_t bytes);
void mempool_free(struct mempool *pool);
void mempool_reclaim(void);

#endif /* NASM_STRPOOL_H */
