#ifndef NASM_RBTREE_H
#define NASM_RBTREE_H

#include "compiler.h"
#include <inttypes.h>

struct rbtree {
    uint64_t key;
    void *data;
    struct rbtree *left, *right;
    bool red;
};

struct rbtree *rb_insert(struct rbtree *, uint64_t, void *);
const struct rbtree *rb_search(const struct rbtree *, uint64_t);
void rb_free(struct rbtree *);

#endif /* NASM_RBTREE_H */
