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
 * mempool.c
 *
 * Maintain a set of memory allocations which can be allocated quickly
 * and then cleaned up all at once at the end of processing. This aims
 * to minimize allocation and deallocation overhead, and doesn't worry
 * too much about returning memory to the operating system.
 *
 * XXX: nasm_malloc() and friends could call mempool_reclaim() on
 * allocation failure.
 *
 */

#include "compiler.h"
#include <string.h>
#include <stdlib.h>

#include "mempool.h"
#include "nasmlib.h"
#include "ilog2.h"

#define MAX(x,y) ((x) > (y) ? (x) : (y))
#define MIN(x,y) ((x) < (y) ? (x) : (y))

/*
 * Make a best guess at what the maximum alignment we may need might be
 */
#ifdef HAVE_STDALIGN_H
# include <stdalign.h>
#endif
#if !defined(HAVE_ALIGNOF) && defined(HAVE__ALIGNOF)
# define HAVE_ALIGNOF 1
# define alignof(x) _Alignof(x)
#endif
#ifdef __BIGGEST_ALIGNMENT__    /* gcc at least provides this */
# define SYS_ALIGNMENT __BIGGEST_ALIGNMENT__
#elif defined(HAVE_ALIGNOF)
# ifdef HAVE_MAX_ALIGN_T
#  define SYS_ALIGNMENT alignof(max_align_t)
# else
   /* Best guess for what we may actually need */
#  define SYS_ALIGNMENT MAX(alignof(void *), alignof(uint64_t))
# endif
#else
# define SYS_ALIGNMENT sizeof(void *)
#endif

/* Always align to a multiple of uint64_t even if not required by the system */
#define MY_ALIGNMENT MAX(SYS_ALIGNMENT, sizeof(uint64_t)) /* Chaotic good? */

#define ALLOC_ALIGN(x) (((size_t)(x) + MY_ALIGNMENT - 1) & \
                        ~((size_t)MY_ALIGNMENT - 1))

/*
 * Sizes of allocation blocks. We default to ALLOC_START, but allocate
 * larger blocks if we think it might be motivated due to the size of
 * the pool. We won't allocate more than ALLOC_MAX in a single allocation,
 * unless we know we need a single block larger than that.
 */
#define KBYTES(x)    ((size_t)1024 * (x))
#define ALLOC_MAX    KBYTES(1024)
#define ALLOC_START  KBYTES(16)
#define ALLOC_MIN    KBYTES(1)  /* Smaller than this, just give up */

/* Storage block header */
struct mempool_storage {
    struct mempool_storage *next;
    size_t idx, nbytes;
};

/* Free list of unreclaimed storage buffers */
static struct mempool_storage *ssfree;

/*
 * This moves all the contents of a particular string pool to the free
 * list, but doesn't return any storage to the operating system.
 */
void mempool_free(struct mempool *sp)
{
    struct mempool_storage *head;

    head = sp->sshead;
    if (unlikely(!head))
        return;                 /* Pool is already empty */

    sp->sstail->next = ssfree;
    ssfree = head;
    sp->sshead = sp->sstail = NULL;
    sp->totalbytes = 0;

#ifdef DEBUG_MEMPOOL
    /* Allow leak detectors to do their job */
    mempool_reclaim();
#endif
}

/*
 * This returns the content of the free list to the operating system
 */
void mempool_reclaim(void)
{
    struct mempool_storage *s;

    list_for_each(s, ssfree)
        nasm_free(s);
    ssfree = NULL;
}

static struct mempool_storage *mempool_more(struct mempool *sp, size_t l)
{
    struct mempool_storage *sps, **ssp;
    size_t n;
    size_t nmin;
    const size_t header = ALLOC_ALIGN(sizeof(struct mempool_storage));

    sps = sp->sstail;
    ssp = sps ? &sps->next : &sp->sshead;

    l += header;
    nmin = ALLOC_ALIGN(MAX(l, ALLOC_MIN));

    /* Is the top block on the free list which is big enough for us? */
    if (likely(ssfree && ssfree->nbytes >= nmin)) {
        sps = ssfree;
        ssfree = sps->next;
        goto have_sps;
    }

    n = sps ? sp->totalbytes : ALLOC_START;
    n = MIN(n, ALLOC_MAX);
    n = MAX(n, nmin);
    n = ((size_t)2) << ilog2_64(n-1); /* Round up to a power of 2 */

    while (n > nmin) {
        /*
         * Use malloc() rather than nasm_malloc() here as we
         * allow fallback to smaller allocation blocks
         */
        sps = malloc(n);
        if (likely(sps)) {
            sps->nbytes = n;
            goto have_sps;
        }
        n >>= 1;
    }
    /* Last ditch attempt; this time we die on allocation failure */
    sps = nasm_malloc(nmin);
    sps->nbytes = nmin;

have_sps:
    *ssp = sp->sstail = sps;
    if (!sp->sshead)
        sp->sshead = sp->sstail;
    sps->next = NULL;
    sps->idx = header;
    sp->totalbytes += sps->nbytes;
    return sps;
}

static inline void *
mempool_get_aligned(struct mempool *sp, size_t l, const size_t align)
{
    struct mempool_storage *sps;
    char *p;
    size_t idx;

    sps = sp->sstail;
    idx = (sps->idx + align - 1) & ~(align - 1);
    if (unlikely(l > sps->nbytes - idx)) {
        sps = mempool_more(sp, l);
        idx = sps->idx;
    }
    p = (char *)sps + idx;
    sps->idx = idx+l;
    return p;
}

static inline char *mempool_get(struct mempool *sp, size_t l)
{
    return mempool_get_aligned(sp, l, 1);
}

void *mempool_alloc(struct mempool *sp, size_t l)
{
    return mempool_get_aligned(sp, l, MY_ALIGNMENT);
}

char *mempool_add(struct mempool *sp, const char *str)
{
    char *p;
    size_t l = strlen(str) + 1;

    p = mempool_get(sp, l);
    memcpy(p, str, l);

    return p;
}

char *mempool_cat(struct mempool *sp, const char *str1, const char *str2)
{
    char *p;
    size_t l1 = strlen(str1);
    size_t l2 = strlen(str2) + 1;
    size_t l = l1 + l2;

    p = mempool_get(sp, l);
    memcpy(p, str1, l1);
    memcpy(p + l1, str2, l2);

    return p;
}

char *mempool_cat3(struct mempool *sp, const char *str1,
                   const char *str2, const char *str3)
{
    char *p;
    size_t l1 = strlen(str1);
    size_t l2 = strlen(str2);
    size_t l3 = strlen(str3) + 1;
    size_t l = l1 + l2;

    p = mempool_get(sp, l);
    memcpy(p, str1, l1);
    memcpy(p + l1, str2, l2);
    memcpy(p + l1 + l2, str3, l3);

    return p;
}

char *mempool_vprintf(struct mempool *sp, const char *fmt, va_list va)
{
    struct mempool_storage *sps = sp->sstail;
    va_list va0;
    size_t n, nfree;
    char *p;

    /* Try to write directly into the remaining buffer, if we can do so */
    if (sps) {
        p = (char *)sps + sps->idx;
        nfree = sps->nbytes - sps->idx;
    } else {
        p = NULL;
        nfree = 0;
    }

    va_copy(va0, va);
    n = vsnprintf(p, nfree, fmt, va0) + 1;
    va_end(va0);

    if (likely(n <= nfree)) {
        sps->idx += n;
        return p;
    }

    /* Otherwise we have to get more storage and try again */
    sps = mempool_more(sp, n);
    p = (char *)sps + sps->idx;
    nfree = sps->nbytes - sps->idx;
    n = vsnprintf(p, nfree, fmt, va) + 1;
    sps->idx += n;
    nasm_assert(n <= nfree);

    return p;
}

char *mempool_printf(struct mempool *sp, const char *fmt, ...)
{
    va_list va;
    char *p;

    va_start(va, fmt);
    p = mempool_vprintf(sp, fmt, va);
    va_end(va);

    return p;
}
