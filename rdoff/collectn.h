/*
 * collectn.h - header file for 'collection' abstract data type.
 *
 * This file is public domain, and does not come under the NASM license.
 * It, along with 'collectn.c' implements what is basically a variable
 * length array (of pointers).
 */

#ifndef _COLLECTN_H
#define _COLLECTN_H

typedef struct tagCollection {
    void *p[32];                /* array of pointers to objects */

    struct tagCollection *next;
} Collection;

void collection_init(Collection * c);
void **colln(Collection * c, int index);
void collection_reset(Collection * c);

#endif
