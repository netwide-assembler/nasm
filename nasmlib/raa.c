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

#include "nasmlib.h"
#include "raa.h"

/*
 * Routines to manage a dynamic random access array of int64_ts which
 * may grow in size to be more than the largest single malloc'able
 * chunk.
 */

#define RAA_BLKSHIFT	15      /* 2**this many longs allocated at once */
#define RAA_BLKSIZE	(1 << RAA_BLKSHIFT)
#define RAA_LAYERSHIFT	15      /* 2**this many _pointers_ allocated */
#define RAA_LAYERSIZE	(1 << RAA_LAYERSHIFT)

typedef union RAA_UNION RAA_UNION;
typedef struct RAA_LEAF RAA_LEAF;
typedef struct RAA_BRANCH RAA_BRANCH;

struct real_raa {
    /*
     * Number of layers below this one to get to the real data. 0
     * means this structure is a leaf, holding RAA_BLKSIZE real
     * data items; 1 and above mean it's a branch, holding
     * RAA_LAYERSIZE pointers to the next level branch or leaf
     * structures.
     */
    int layers;

    /*
     * Number of real data items spanned by one position in the
     * `data' array at this level. This number is 0 trivially, for
     * a leaf (level 0): for a level 1 branch it should be
     * RAA_BLKSHIFT, and for a level 2 branch it's
     * RAA_LAYERSHIFT+RAA_BLKSHIFT.
     */
    int shift;

    union RAA_UNION {
        struct RAA_LEAF {
            union intorptr data[RAA_BLKSIZE];
        } l;
        struct RAA_BRANCH {
            struct real_raa *data[RAA_LAYERSIZE];
        } b;
    } u;
};

struct RAA {
    struct real_raa raa;
};
struct RAAPTR {
    struct real_raa raa;
};

#define LEAFSIZ (sizeof(struct real_raa)-sizeof(RAA_UNION)+sizeof(RAA_LEAF))
#define BRANCHSIZ (sizeof(struct real_raa)-sizeof(RAA_UNION)+sizeof(RAA_BRANCH))

#define LAYERSHIFT(r) ( (r)->layers==0 ? RAA_BLKSHIFT : RAA_LAYERSHIFT )

static struct real_raa *raa_init_layer(int layers)
{
    struct real_raa *r;

    if (layers == 0) {
        r = nasm_zalloc(LEAFSIZ);
        r->shift = 0;
    } else {
        r = nasm_zalloc(BRANCHSIZ);
        r->layers = layers;
        r->shift = (RAA_BLKSHIFT - RAA_LAYERSHIFT) + layers * RAA_LAYERSHIFT;
    }
    return r;
}

struct real_raa *real_raa_init(void)
{
    return raa_init_layer(0);
}

void real_raa_free(struct real_raa *r)
{
    if (r->layers) {
        struct real_raa **p;
        for (p = r->u.b.data; p - r->u.b.data < RAA_LAYERSIZE; p++)
            if (*p)
                real_raa_free(*p);
    }
    nasm_free(r);
}

static const union intorptr *real_raa_read(struct real_raa *r, int32_t posn)
{
    if ((uint32_t) posn >= (UINT32_C(1) << (r->shift + LAYERSHIFT(r))))
        return NULL;            /* Beyond the end */
    while (r->layers > 0) {
        int32_t l = posn >> r->shift;
        posn &= (UINT32_C(1) << r->shift) - 1;
        r = r->u.b.data[l];
        if (!r)
            return NULL;        /* Not present */
    }
    return &r->u.l.data[posn];
}

int64_t raa_read(struct RAA *r, int32_t pos)
{
    const union intorptr *ip;

    ip = real_raa_read((struct real_raa *)r, pos);
    return ip ? ip->i : 0;
}

void *raa_read_ptr(struct RAAPTR *r, int32_t pos)
{
    const union intorptr *ip;

    ip = real_raa_read((struct real_raa *)r, pos);
    return ip ? ip->p : NULL;
}


struct real_raa *
real_raa_write(struct real_raa *r, int32_t posn, union intorptr value)
{
    struct real_raa *result;

    nasm_assert(posn >= 0);

    while ((UINT32_C(1) << (r->shift + LAYERSHIFT(r))) <= (uint32_t) posn) {
        /*
         * Must add a layer.
         */
        struct real_raa *s;

        s = nasm_zalloc(BRANCHSIZ);
        s->layers = r->layers + 1;
        s->shift = LAYERSHIFT(r) + r->shift;
        s->u.b.data[0] = r;
        r = s;
    }

    result = r;

    while (r->layers > 0) {
        struct real_raa **s;
        int32_t l = posn >> r->shift;
        posn &= (UINT32_C(1) << r->shift) - 1;
        s = &r->u.b.data[l];
        if (!*s)
            *s = raa_init_layer(r->layers - 1);
        r = *s;
    }

    r->u.l.data[posn] = value;

    return result;
}
