/* rdfload.h	RDOFF Object File loader library header file
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * See the file 'rdfload.c' for special license information for this
 * file.
 */

#ifndef RDOFF_RDFLOAD_H
#define RDOFF_RDFLOAD_H 1

#define RDOFF_UTILS

#include "rdoff.h"

typedef struct RDFModuleStruct {
    rdffile f;                  /* file structure */
    uint8_t *t, *d, *b;   /* text, data, and bss segments */
    int32_t textrel;
    int32_t datarel;
    int32_t bssrel;
    void *symtab;
} rdfmodule;

rdfmodule *rdfload(const char *filename);
int rdf_relocate(rdfmodule * m);

#endif
