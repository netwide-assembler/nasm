/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
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
 * sync.c   the Netwide Disassembler synchronisation processing module
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
        return 0;
    }
}
