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
 * hashtbl.c
 *
 * Efficient dictionary hash table class.
 */

#include "compiler.h"

#include <inttypes.h>
#include <string.h>
#include "nasm.h"
#include "hashtbl.h"

#define HASH_MAX_LOAD		2 /* Higher = more memory-efficient, slower */

static struct hash_tbl_node *alloc_table(size_t newsize)
{
    size_t bytes = newsize*sizeof(struct hash_tbl_node);
    struct hash_tbl_node *newtbl = nasm_zalloc(bytes);

    return newtbl;
}

void hash_init(struct hash_table *head, size_t size)
{
    head->table    = alloc_table(size);
    head->load     = 0;
    head->size     = size;
    head->max_load = size*(HASH_MAX_LOAD-1)/HASH_MAX_LOAD;
}

/*
 * Find an entry in a hash table.
 *
 * On failure, if "insert" is non-NULL, store data in that structure
 * which can be used to insert that node using hash_add().
 *
 * WARNING: this data is only valid until the very next call of
 * hash_add(); it cannot be "saved" to a later date.
 *
 * On success, return a pointer to the "data" element of the hash
 * structure.
 */
void **hash_find(struct hash_table *head, const char *key,
		struct hash_insert *insert)
{
    struct hash_tbl_node *np;
    uint64_t hash = crc64(CRC64_INIT, key);
    struct hash_tbl_node *tbl = head->table;
    size_t mask = head->size-1;
    size_t pos  = hash & mask;
    size_t inc  = ((hash >> 32) & mask) | 1;	/* Always odd */

    while ((np = &tbl[pos])->key) {
	if (hash == np->hash && !strcmp(key, np->key))
	    return &np->data;
	pos = (pos+inc) & mask;
    }

    /* Not found.  Store info for insert if requested. */
    if (insert) {
	insert->head  = head;
	insert->hash  = hash;
	insert->where = np;
    }
    return NULL;
}

/*
 * Same as hash_find, but for case-insensitive hashing.
 */
void **hash_findi(struct hash_table *head, const char *key,
		  struct hash_insert *insert)
{
    struct hash_tbl_node *np;
    uint64_t hash = crc64i(CRC64_INIT, key);
    struct hash_tbl_node *tbl = head->table;
    size_t mask = head->size-1;
    size_t pos  = hash & mask;
    size_t inc  = ((hash >> 32) & mask) | 1;	/* Always odd */

    while ((np = &tbl[pos])->key) {
	if (hash == np->hash && !nasm_stricmp(key, np->key))
	    return &np->data;
	pos = (pos+inc) & mask;
    }

    /* Not found.  Store info for insert if requested. */
    if (insert) {
	insert->head  = head;
	insert->hash  = hash;
	insert->where = np;
    }
    return NULL;
}

/*
 * Insert node.  Return a pointer to the "data" element of the newly
 * created hash node.
 */
void **hash_add(struct hash_insert *insert, const char *key, void *data)
{
    struct hash_table *head  = insert->head;
    struct hash_tbl_node *np = insert->where;

    /* Insert node.  We can always do this, even if we need to
       rebalance immediately after. */
    np->hash = insert->hash;
    np->key  = key;
    np->data = data;

    if (++head->load > head->max_load) {
	/* Need to expand the table */
	size_t newsize = head->size << 1;
	struct hash_tbl_node *newtbl = alloc_table(newsize);
	size_t mask = newsize-1;

	if (head->table) {
	    struct hash_tbl_node *op, *xp;
	    size_t i;

	    /* Rebalance all the entries */
	    for (i = 0, op = head->table; i < head->size; i++, op++) {
		if (op->key) {
		    size_t pos = op->hash & mask;
		    size_t inc = ((op->hash >> 32) & mask) | 1;

		    while ((xp = &newtbl[pos])->key)
			pos = (pos+inc) & mask;

		    *xp = *op;
		    if (op == np)
			np = xp;
		}
	    }
	    nasm_free(head->table);
	}

	head->table    = newtbl;
	head->size     = newsize;
	head->max_load = newsize*(HASH_MAX_LOAD-1)/HASH_MAX_LOAD;
    }

    return &np->data;
}

/*
 * Iterate over all members of a hash set.  For the first call,
 * iterator should be initialized to NULL.  Returns the data pointer,
 * or NULL on failure.
 */
void *hash_iterate(const struct hash_table *head,
		   struct hash_tbl_node **iterator,
		   const char **key)
{
    struct hash_tbl_node *np = *iterator;
    struct hash_tbl_node *ep = head->table + head->size;

    if (!np) {
	np = head->table;
	if (!np)
	    return NULL;	/* Uninitialized table */
    }

    while (np < ep) {
	if (np->key) {
	    *iterator = np+1;
	    if (key)
		*key = np->key;
	    return np->data;
	}
	np++;
    }

    *iterator = NULL;
    if (key)
	*key = NULL;
    return NULL;
}

/*
 * Free the hash itself.  Doesn't free the data elements; use
 * hash_iterate() to do that first, if needed.
 */
void hash_free(struct hash_table *head)
{
    void *p = head->table;
    head->table = NULL;
    nasm_free(p);
}
