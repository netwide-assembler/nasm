/*
 * hashtbl.h
 *
 * Efficient dictionary hash table class.
 */

#ifndef NASM_HASHTBL_H
#define NASM_HASHTBL_H

#include <inttypes.h>
#include <stddef.h>
#include "nasmlib.h"

struct hash_tbl_node {
    uint64_t hash;
    const char *key;
    void *data;
};

struct hash_table {
    struct hash_tbl_node *table;
    size_t load;
    size_t size;
    size_t max_load;
};

struct hash_insert {
    uint64_t hash;
    struct hash_table *head;
    struct hash_tbl_node *where;
};

uint64_t crc64(uint64_t crc, const char *string);
uint64_t crc64i(uint64_t crc, const char *string);
#define CRC64_INIT UINT64_C(0xffffffffffffffff)

/* Some reasonable initial sizes... */
#define HASH_SMALL	4
#define HASH_MEDIUM	16
#define HASH_LARGE	256

void hash_init(struct hash_table *head, size_t size);
void **hash_find(struct hash_table *head, const char *string,
		struct hash_insert *insert);
void **hash_findi(struct hash_table *head, const char *string,
		struct hash_insert *insert);
void **hash_add(struct hash_insert *insert, const char *string, void *data);
void *hash_iterate(const struct hash_table *head,
		   struct hash_tbl_node **iterator,
		   const char **key);
void hash_free(struct hash_table *head);

#endif /* NASM_HASHTBL_H */
