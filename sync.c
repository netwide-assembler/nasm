/* sync.c   the Netwide Disassembler synchronisation processing module
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <limits.h>

#include "sync.h"

#define SYNC_MAX 4096		       /* max # of sync points */

static struct Sync {
    unsigned long pos;
    unsigned long length;
} synx[SYNC_MAX];
static int nsynx;

void init_sync(void) {
    nsynx = 0;
}

void add_sync(unsigned long pos, unsigned long length) {
    int i;

    if (nsynx == SYNC_MAX)
	return;			       /* can't do anything - overflow */

    nsynx++;
    synx[nsynx].pos = pos;
    synx[nsynx].length = length;

    for (i = nsynx; i > 1; i /= 2) {
	if (synx[i/2].pos > synx[i].pos) {
	    struct Sync t;
	    t = synx[i/2];	       /* structure copy */
	    synx[i/2] = synx[i];       /* structure copy again */
	    synx[i] = t;	       /* another structure copy */
	}
    }
}

unsigned long next_sync(unsigned long position, unsigned long *length) {
    while (nsynx > 0 && synx[1].pos + synx[1].length <= position) {
	int i, j;
	struct Sync t;
	t = synx[nsynx];	       /* structure copy */
	synx[nsynx] = synx[1];	       /* structure copy */
	synx[1] = t;		       /* ditto */

	nsynx--;

        i = 1;
	while (i*2 <= nsynx) {
	    j = i*2;
	    if (synx[j].pos < synx[i].pos &&
		(j+1 > nsynx || synx[j+1].pos > synx[j].pos)) {
		t = synx[j];	       /* structure copy */
		synx[j] = synx[i];     /* lots of these... */
		synx[i] = t;	       /* ...aren't there? */
		i = j;
	    } else if (j+1 <= nsynx && synx[j+1].pos < synx[i].pos) {
		t = synx[j+1];	       /* structure copy */
		synx[j+1] = synx[i];   /* structure <yawn> copy */
		synx[i] = t;	       /* structure copy <zzzz....> */
		i = j+1;
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
	return ULONG_MAX;
    }
}
