/* sync.c   the Netwide Disassembler synchronisation processing module
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <inttypes.h>

#include "nasmlib.h"
#include "sync.h"

#define SYNC_MAX 4096           /* max # of sync points (initial) */

/*
 * This lot manages the current set of sync points by means of a
 * heap (priority queue) structure.
 */

static struct Sync {
    uint32_t pos;
    uint32_t length;
} *synx;
static int max_synx, nsynx;

void init_sync(void)
{
    max_synx = SYNC_MAX-1;
    synx = nasm_malloc(SYNC_MAX * sizeof(*synx));
    nsynx = 0;
}

void add_sync(uint32_t pos, uint32_t length)
{
    int i;

    if (nsynx >= max_synx) {
	max_synx = (max_synx << 1)+1;
	synx = nasm_realloc(synx, (max_synx+1) * sizeof(*synx));
    }

    nsynx++;
    synx[nsynx].pos = pos;
    synx[nsynx].length = length;

    for (i = nsynx; i > 1; i /= 2) {
        if (synx[i / 2].pos > synx[i].pos) {
            struct Sync t;
            t = synx[i / 2];    /* structure copy */
            synx[i / 2] = synx[i];      /* structure copy again */
            synx[i] = t;        /* another structure copy */
        }
    }
}

uint32_t next_sync(uint32_t position, uint32_t *length)
{
    while (nsynx > 0 && synx[1].pos + synx[1].length <= position) {
        int i, j;
        struct Sync t;
        t = synx[nsynx];        /* structure copy */
        synx[nsynx] = synx[1];  /* structure copy */
        synx[1] = t;            /* ditto */

        nsynx--;

        i = 1;
        while (i * 2 <= nsynx) {
            j = i * 2;
            if (synx[j].pos < synx[i].pos &&
                (j + 1 > nsynx || synx[j + 1].pos > synx[j].pos)) {
                t = synx[j];    /* structure copy */
                synx[j] = synx[i];      /* lots of these... */
                synx[i] = t;    /* ...aren't there? */
                i = j;
            } else if (j + 1 <= nsynx && synx[j + 1].pos < synx[i].pos) {
                t = synx[j + 1];        /* structure copy */
                synx[j + 1] = synx[i];  /* structure <yawn> copy */
                synx[i] = t;    /* structure copy <zzzz....> */
                i = j + 1;
            } else
                break;
        }
    }

    if (nsynx > 0) {
        if (length)
            *length = synx[1].length;
        return synx[1].pos;
    } else {
        if (length)
            *length = 0L;
        return UINT32_MAX;
    }
}
