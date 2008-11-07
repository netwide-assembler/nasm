#ifndef NASM_RBTREE_H
#define NASM_RBTREE_H

#include "compiler.h"
#include <inttypes.h>

/* This structure should be embedded in a larger data structure;
   the final output from rb_search() can then be converted back
   to the larger data structure via container_of(). */
struct rbtree {
    uint64_t key;
    struct rbtree *left, *right;
    bool red;
};

struct rbtree *rb_insert(struct rbtree *, struct rbtree *);
struct rbtree *rb_search(struct rbtree *, uint64_t);

#endif /* NASM_RBTREE_H */
