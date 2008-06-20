#ifndef NASM_RAA_H
#define NASM_RAA_H 1

#include "compiler.h"

/*
 * Routines to manage a dynamic random access array of int64_ts which
 * may grow in size to be more than the largest single malloc'able
 * chunk.
 */

#define RAA_BLKSHIFT	15      /* 2**this many longs allocated at once */
#define RAA_BLKSIZE	(1 << RAA_BLKSHIFT)
#define RAA_LAYERSHIFT	15      /* 2**this many _pointers_ allocated */
#define RAA_LAYERSIZE	(1 << RAA_LAYERSHIFT)

typedef struct RAA RAA;
typedef union RAA_UNION RAA_UNION;
typedef struct RAA_LEAF RAA_LEAF;
typedef struct RAA_BRANCH RAA_BRANCH;

struct RAA {
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
            int64_t data[RAA_BLKSIZE];
        } l;
        struct RAA_BRANCH {
            struct RAA *data[RAA_LAYERSIZE];
        } b;
    } u;
};

struct RAA *raa_init(void);
void raa_free(struct RAA *);
int64_t raa_read(struct RAA *, int32_t);
struct RAA *raa_write(struct RAA *r, int32_t posn, int64_t value);

#endif                          /* NASM_RAA_H */
