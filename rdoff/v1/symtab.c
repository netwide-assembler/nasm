/* symtab.c	Routines to maintain and manipulate a symbol table
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */
#include <stdio.h>
#include <stdlib.h>

#include "symtab.h"

/* TODO: Implement a hash table, not this stupid implementation which
   is too slow to be of practical use */

/* Private data types */

typedef struct tagSymtab {
  symtabEnt		ent;
  struct tagSymtab	* next;
} symtabList;

typedef symtabList *	_symtab;

void *symtabNew(void)
{
  void *p = malloc(sizeof(_symtab));
  if (p == NULL) {
    fprintf(stderr,"symtab: out of memory\n");
    exit(3);
  }
  *(_symtab *)p = NULL;

  return p;
}

void symtabDone(void *symtab)
{
  /* DO SOMETHING HERE! */
}

void symtabInsert(void *symtab,symtabEnt *ent)
{
  symtabList	*l = malloc(sizeof(symtabList));

  if (l == NULL) {
    fprintf(stderr,"symtab: out of memory\n");
    exit(3);
  }

  l->ent = *ent;
  l->next = *(_symtab *)symtab;
  *(_symtab *)symtab = l;
}

symtabEnt *symtabFind(void *symtab,char *name)
{
  symtabList	*l = *(_symtab *)symtab;

  while (l) {
    if (!strcmp(l->ent.name,name)) {
      return &(l->ent);
    }
    l = l->next;
  }  
  return NULL;
}

void symtabDump(void *symtab,FILE *of)
{
  symtabList	*l = *(_symtab *)symtab;

  while(l) {
    fprintf(of,"%32s %s:%08lx (%ld)\n",l->ent.name,
	    l->ent.segment ? "data" : "code" ,
	    l->ent.offset, l->ent.flags);
    l = l->next;
  }
}

