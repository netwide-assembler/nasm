/* symtab.c     Routines to maintain and manipulate a symbol table
 *
 *   These routines donated to the NASM effort by Graeme Defty.
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symtab.h"
#include "hash.h"

#define SYMTABSIZE 64
#define slotnum(x) (hash((x)) % SYMTABSIZE)

/* ------------------------------------- */
/* Private data types */

typedef struct tagSymtabNode {
    struct tagSymtabNode *next;
    symtabEnt ent;
} symtabNode;

typedef symtabNode *(symtabTab[SYMTABSIZE]);

typedef symtabTab *symtab;

/* ------------------------------------- */
void *symtabNew(void)
{
    symtab mytab;

    mytab = (symtabTab *) calloc(SYMTABSIZE, sizeof(symtabNode *));
    if (mytab == NULL) {
        fprintf(stderr, "symtab: out of memory\n");
        exit(3);
    }

    return mytab;
}

/* ------------------------------------- */
void symtabDone(void *stab)
{
    symtab mytab = (symtab) stab;
    int i;
    symtabNode *this, *next;

    for (i = 0; i < SYMTABSIZE; ++i) {

        for (this = (*mytab)[i]; this; this = next) {
            next = this->next;
            free(this);
        }

    }
    free(*mytab);
}

/* ------------------------------------- */
void symtabInsert(void *stab, symtabEnt * ent)
{
    symtab mytab = (symtab) stab;
    symtabNode *node;
    int slot;

    node = malloc(sizeof(symtabNode));
    if (node == NULL) {
        fprintf(stderr, "symtab: out of memory\n");
        exit(3);
    }

    slot = slotnum(ent->name);

    node->ent = *ent;
    node->next = (*mytab)[slot];
    (*mytab)[slot] = node;
}

/* ------------------------------------- */
symtabEnt *symtabFind(void *stab, const char *name)
{
    symtab mytab = (symtab) stab;
    int slot = slotnum(name);
    symtabNode *node = (*mytab)[slot];

    while (node) {
        if (!strcmp(node->ent.name, name)) {
            return &(node->ent);
        }
        node = node->next;
    }

    return NULL;
}

/* ------------------------------------- */
void symtabDump(void *stab, FILE * of)
{
    symtab mytab = (symtab) stab;
    int i;
    char *SegNames[3] = { "code", "data", "bss" };

    fprintf(of, "Symbol table is ...\n");
    for (i = 0; i < SYMTABSIZE; ++i) {
        symtabNode *l = (symtabNode *) (*mytab)[i];

        if (l) {
            fprintf(of, " ... slot %d ...\n", i);
        }
        while (l) {
            if ((l->ent.segment) == -1) {
                fprintf(of, "%-32s Unresolved reference\n", l->ent.name);
            } else {
                fprintf(of, "%-32s %s:%08"PRIx32" (%"PRId32")\n", l->ent.name,
                        SegNames[l->ent.segment],
                        l->ent.offset, l->ent.flags);
            }
            l = l->next;
        }
    }
    fprintf(of, "........... end of Symbol table.\n");
}
