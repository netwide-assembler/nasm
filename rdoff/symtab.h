/* symtab.h	Header file for symbol table manipulation routines
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

typedef struct {
    char *name;
    int segment;
    long offset;
    long flags;
} symtabEnt;

void *symtabNew(void);
void symtabDone(void *symtab);
void symtabInsert(void *symtab, symtabEnt * ent);
symtabEnt *symtabFind(void *symtab, const char *name);
void symtabDump(void *symtab, FILE * of);
