/*
 * rbtree.c
 *
 * Simple implementation of a left-leaning red-black tree with 64-bit
 * integer keys.  The search operation will return the highest node <=
 * the key; only search and insert are supported, but additional
 * standard llrbtree operations can be coded up at will.
 *
 * See http://www.cs.princeton.edu/~rs/talks/LLRB/RedBlack.pdf for
 * information about left-leaning red-black trees.
 */

#include "rbtree.h"

const struct rbtree *rb_search(const struct rbtree *tree, uint64_t key)
{
    const struct rbtree *best = NULL;

    while (tree) {
	if (tree->key == key)
	    return tree;
	else if (tree->key > key)
	    tree = tree->left;
	else {
	    best = tree;
	    tree = tree->right;
	}
    }
    return best;
}

static bool is_red(struct rbtree *h)
{
    return h && h->red;
}

static struct rbtree *rotate_left(struct rbtree *h)
{
    struct rbtree *x = h->right;
    h->right = x->left;
    x->left = h;
    x->red = x->left->red;
    x->left->red = true;
    return x;
}

static struct rbtree *rotate_right(struct rbtree *h)
{
    struct rbtree *x = h->left;
    h->left = x->right;
    x->right = h;
    x->red = x->right->red;
    x->right->red = true;
    return x;
}

static void color_flip(struct rbtree *h)
{
    h->red = !h->red;
    h->left->red = !h->left->red;
    h->right->red = !h->right->red;
}

struct rbtree *rb_insert(struct rbtree *tree, struct rbtree *node)
{
    if (!tree) {
	node->red = true;
	return node;
    }

    if (is_red(tree->left) && is_red(tree->right))
	color_flip(tree);

    if (node->key < tree->key)
	tree->left = rb_insert(tree->left, node);
    else
	tree->right = rb_insert(tree->right, node);

    if (is_red(tree->right))
	tree = rotate_left(tree);

    if (is_red(tree->left) && is_red(tree->left->left))
	tree = rotate_right(tree);

    return tree;
}
