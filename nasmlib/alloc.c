/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2019 The NASM Authors - All Rights Reserved */

/*
 * nasmlib.c	library routines for the Netwide Assembler
 */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"
#include "alloc.h"

/*
 * Lookaside allocator lists to avoid expensive heap operations.
 *
 * The heap can be very slow on Windows, try enable this to speed up
 * assembling of large files.
 *
 * The principle is that we don't give memory back to the heap, but keep the
 * allocations on various list according to their sizes.  When a new allocation
 * request comes along, we check the corresponding list and return anything
 * chained there before asking the heap.
 *
 * The current implemenation is extremely simple and does not have any
 * safeguards against wasting loads of heap or what to do if we run out
 * of memory.
 */
#if defined(_MSC_VER)
# define USE_LOOKASIDE_ALLOC
#endif
#ifdef USE_LOOKASIDE_ALLOC

/*# define LOOKASIDE_STATS*/

/** Header that precedes every allocation. */
struct lookaside_hdr
{
    struct lookaside_hdr *next;
    size_t size;
};
# define LOOKASIDE_CACHE_HDR_NEXT_IN_USE ((struct lookaside_hdr *)(intptr_t)0xbeeff00d)
# define LOOKASIDE_CACHE_HDR_NEXT_FREED  ((struct lookaside_hdr *)(intptr_t)0xdeadbeef)

/** Number of allocation lists. */
# define LOOKASIDE_NUM_LISTS    256
/** The lookaside lists - One list for one size range. */
static struct lookaside_list {
    struct lookaside_hdr *head; /* chain of free (unused) allocations. */
# ifdef LOOKASIDE_STATS
    size_t nfree;
    size_t ntotal; /* number of alloc calls. */
# endif
} lookaside_lists[LOOKASIDE_NUM_LISTS];

# ifdef LOOKASIDE_STATS
static size_t lookaside_too_large = 0;
static size_t lookaside_too_large_total_bytes = 0;
# endif

static size_t lookaside_round_size(size_t size)
{
    if (size < 256)
        return size ? (size + 15) & ~(size_t)15 : 16;
    /* [16..] - by 64. */
    return (size + 63) & ~(size_t)63;
}

static size_t lookaside_index_to_size(size_t idx)
{
    if (idx < 16)
        return (idx + 1) * 16;
    return (idx - 16) * 64 + 256;
}

static size_t lookaside_size_to_index(size_t size)
{
    /* [0..15] - by 16. */
    if (size < 256)
        return size ? ((size + 15) / 16) - 1 : 0;
    /* [16..] - by 64. */
    return ((size + 63) / 64) + 16 - 256 / 64;
}

# ifdef DEBUG
static bool lookaside_sanity_checked = false;

/* Does sanitiy checking of the three above functions.*/
static void lookaside_santiy_check(void)
{
    size_t size;
    for (size = 0; size < 32678; size++) {
        size_t const size_rounded  = lookaside_round_size(size);
        size_t const idx           = lookaside_size_to_index(size);
        size_t const size_form_idx = lookaside_index_to_size(idx);
        nasm_assert(size_rounded == size_form_idx && size <= size_rounded);
    }
    for (size = 0; size <= 32; size++) {
        size_t const idx = lookaside_size_to_index(size);
        nasm_assert(idx == (size > 16));
    }
    lookaside_sanity_checked = true;
}
#endif /* DEBUG*/

static void *lookaside_alloc(size_t size)
{
    struct lookaside_hdr *hdr;
    size_t idx = lookaside_size_to_index(size);
# ifdef DEBUG
    if (!lookaside_sanity_checked)
        lookaside_sanity_check();
# endif

    if (idx < LOOKASIDE_NUM_LISTS) {
        hdr = lookaside_lists[idx].head;
        if (hdr) {
            size = lookaside_index_to_size(idx);
            nasm_assert(hdr->size == size);
# ifdef LOOKASIDE_STATS
            lookaside_lists[idx].nfree--;
            lookaside_lists[idx].ntotal++;
# endif
            lookaside_lists[idx].head = hdr->next;
            hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
            return hdr + 1;
        }
    }
# ifdef LOOKASIDE_STATS
    else {
        lookaside_too_large++;
        lookaside_too_large_total_bytes += size;
    }
# endif

    size = lookaside_index_to_size(idx);
    hdr = malloc(sizeof(*hdr) + size);
    if (hdr) {
        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
        hdr->size = size;
        return hdr + 1;
    }

    nasm_critical("out of memory!");
    return NULL;
}

static void *lookaside_zalloc(size_t size)
{
    struct lookaside_hdr *hdr;
    size_t idx = lookaside_size_to_index(size);
# ifdef DEBUG
    if (!lookaside_sanity_checked)
        lookaside_sanity_check();
# endif

    if (idx < LOOKASIDE_NUM_LISTS) {
        hdr = lookaside_lists[idx].head;
        if (hdr) {
            size = lookaside_index_to_size(idx);
            nasm_assert(hdr->size == size);
# ifdef LOOKASIDE_STATS
            lookaside_lists[idx].nfree--;
            lookaside_lists[idx].ntotal++;
# endif
            lookaside_lists[idx].head = hdr->next;
            hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
            return memset(hdr + 1, 0, size);
        }
    }
# ifdef LOOKASIDE_STATS
    else {
        lookaside_too_large++;
        lookaside_too_large_total_bytes +=size;
    }
# endif

    size = lookaside_index_to_size(idx);
    hdr = calloc(sizeof(*hdr) + size, 1);
    if (hdr) {
        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_IN_USE;
        hdr->size = size;
        return hdr + 1;
    }

    nasm_critical("out of memory!");
    return NULL;
}

static void lookaside_free(void *user)
{
    struct lookaside_hdr * const hdr = (struct lookaside_hdr *)user - 1;
    size_t idx;
    nasm_assert(hdr->next == LOOKASIDE_CACHE_HDR_NEXT_IN_USE);
    nasm_assert(!(hdr->size & 15));
    idx = lookaside_size_to_index(hdr->size);
    if (idx < LOOKASIDE_NUM_LISTS) {
        hdr->next = lookaside_lists[idx].head;
        lookaside_lists[idx].head = hdr;
# ifdef LOOKASIDE_STATS
        lookaside_lists[idx].nfree++;
# endif
    } else {
        hdr->next = LOOKASIDE_CACHE_HDR_NEXT_FREED;
        free(hdr);
    }
}
#endif /* USE_LOOKASIDE_ALLOC */

void lookaside_allocator_cleanup(void)
{
#ifdef USE_LOOKASIDE_ALLOC
    size_t idx;
# ifdef LOOKASIDE_STATS
    size_t cur_user_byte     = 0;
    size_t cur_nheaders      = 0;
    size_t total_user_bytes  = 0;
    size_t total_nallocs     = 0;
    fprintf(stderr, "allocation stats:\n");
    for (idx = 0; idx < LOOKASIDE_NUM_LISTS; idx++) {
        if (lookaside_lists[idx].ntotal != 0) {
            size_t const size = lookaside_index_to_size(idx);
            total_user_bytes  += lookaside_lists[idx].ntotal * size;
            total_nallocs     += lookaside_lists[idx].ntotal;
            cur_user_byte     += lookaside_lists[idx].nfree * size;
            cur_nheaders      += lookaside_lists[idx].nfree;
            fprintf(stderr, " #%zu - %zu bytes - nfree=%zu ntotal=%zu (%zu)\n",
                    idx, size, lookaside_lists[idx].nfree, lookaside_lists[idx].ntotal,
                    lookaside_lists[idx].ntotal * size);
        }
    }
    fprintf(stderr, " total: free: %zu bytes in %zu units; total: %zu bytes in %zu alloc calls\n",
            cur_user_byte, cur_nheaders, total_user_bytes, total_nallocs);
    fprintf(stderr, " %zu allocations were too large (%zu bytes)\n",
            lookaside_too_large, lookaside_too_large_total_bytes);
#endif
    for (idx = 0; idx < LOOKASIDE_NUM_LISTS; idx++) {
        struct lookaside_hdr *cur = lookaside_lists[idx].head;
        while (cur) {
            struct lookaside_hdr *next = cur->next;
            free(cur);
            cur = next;
        }
        lookaside_lists[idx].head = NULL;
    }
#endif /* USE_LOOKASIDE_ALLOC */
}


size_t _nasm_last_string_size;

fatal_func nasm_alloc_failed(void)
{
    nasm_critical("out of memory!");
}

void *nasm_malloc(size_t size)
{
#ifdef USE_LOOKASIDE_ALLOC
    return lookaside_alloc(size);
#else
    void *p;

again:
    p = malloc(size);

    if (unlikely(!p)) {
        if (!size) {
            size = 1;
            goto again;
        }
        nasm_alloc_failed();
    }
    return p;
#endif
}

void *nasm_calloc(size_t nelem, size_t size)
{
#ifdef USE_LOOKASIDE_ALLOC
    return lookaside_zalloc(nelem * size); /** @todo overflow check */
#else
    void *p;

again:
    p = calloc(nelem, size);

    if (unlikely(!p)) {
        if (!nelem || !size) {
            nelem = size = 1;
            goto again;
        }
        nasm_alloc_failed();
    }

    return p;
#endif
}

void *nasm_zalloc(size_t size)
{
#ifdef USE_LOOKASIDE_ALLOC
    return lookaside_zalloc(size);
#else
    return nasm_calloc(size, 1);
#endif
}

/*
 * Unlike the system realloc, we do *not* allow size == 0 to be
 * the equivalent to free(); we guarantee returning a non-NULL pointer.
 *
 * The check for calling malloc() is theoretically redundant, but be
 * paranoid about the system library...
 */
void *nasm_realloc(void *q, size_t size)
{
#ifdef USE_LOOKASIDE_ALLOC
    if (q) {
        struct lookaside_hdr *hdr = (struct lookaside_hdr *)q - 1;
        nasm_assert(hdr->next == LOOKASIDE_CACHE_HDR_NEXT_IN_USE);
        nasm_assert(!(hdr->size & 15));
        size = lookaside_round_size(size);
        if (hdr->size == size)
            return hdr + 1;
        hdr = (struct lookaside_hdr *)realloc(hdr, sizeof(*hdr) + size);
        if (!hdr)
            nasm_critical("out of memory!");
        hdr->size = size;
        return hdr + 1;
    }
    return lookaside_alloc(size);

#else
    if (unlikely(!size))
        size = 1;
    q = q ? realloc(q, size) : malloc(size);
    return validate_ptr(q);
#endif
}

void nasm_free(void *q)
{
    if (q)
#ifdef USE_LOOKASIDE_ALLOC
        lookaside_free(q);
#else
        free(q);
#endif
}

char *nasm_strdup(const char *s)
{
    char *p;
    const size_t size = strlen(s) + 1;

    _nasm_last_string_size = size;
    p = nasm_malloc(size);
    return memcpy(p, s, size);
}

char *nasm_strndup(const char *s, size_t len)
{
    char *p;

    len = strnlen(s, len);
    _nasm_last_string_size = len + 1;
    p = nasm_malloc(len+1);
    p[len] = '\0';
    return memcpy(p, s, len);
}

char *nasm_strcat(const char *one, const char *two)
{
    char *rslt;
    const size_t l1 = strlen(one);
    const size_t s2 = strlen(two) + 1;

    _nasm_last_string_size = l1 + s2;
    rslt = nasm_malloc(l1 + s2);
    memcpy(rslt, one, l1);
    memcpy(rslt + l1, two, s2);
    return rslt;
}

char *nasm_strcatn(const char *str1, ...)
{
    va_list ap;
    char *rslt;                 /* Output buffer */
    size_t s;                   /* Total buffer size */
    size_t n;                   /* Number of arguments */
    size_t *ltbl;               /* Table of lengths */
    size_t l, *lp;              /* Length for current argument */
    const char *p;              /* Currently examined argument */
    char *q;                    /* Output pointer */

    n = 0;                      /* No strings encountered yet */
    p = str1;
    va_start(ap, str1);
    while (p) {
        n++;
        p = va_arg(ap, const char *);
    }
    va_end(ap);

    ltbl = nasm_malloc(n * sizeof(size_t));

    s = 1;                      /* Space for final NULL */
    p = str1;
    lp = ltbl;
    va_start(ap, str1);
    while (p) {
        *lp++ = l = strlen(p);
        s += l;
        p = va_arg(ap, const char *);
    }
    va_end(ap);

    _nasm_last_string_size = s;

    q = rslt = nasm_malloc(s);

    p = str1;
    lp = ltbl;
    va_start(ap, str1);
    while (p) {
        l = *lp++;
        memcpy(q, p, l);
        q += l;
        p = va_arg(ap, const char *);
    }
    va_end(ap);
    *q = '\0';

    nasm_free(ltbl);

    return rslt;
}
