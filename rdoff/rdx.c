/* rdx.c	RDOFF Object File loader program
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

/* note: most of the actual work of this program is done by the modules
   "rdfload.c", which loads and relocates the object file, and by "rdoff.c",
   which contains general purpose routines to manipulate RDOFF object
   files. You can use these files in your own program to load RDOFF objects
   and execute the code in them in a similar way to what is shown here. */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>

#include "rdfload.h"
#include "symtab.h"

typedef int (*main_fn) (int, char **);  /* Main function prototype */

int main(int argc, char **argv)
{
    rdfmodule *m;
    main_fn code;
    symtabEnt *s;

    if (argc < 2) {
        puts("usage: rdx <rdoff-executable> [params]\n");
        exit(255);
    }

    m = rdfload(argv[1]);

    if (!m) {
        rdfperror("rdx", argv[1]);
        exit(255);
    }

    rdf_relocate(m);            /* in this instance, the default relocation
                                   values will work fine, but they may need changing
                                   in other cases... */

    s = symtabFind(m->symtab, "_main");
    if (!s) {
        fprintf(stderr, "rdx: could not find symbol '_main' in '%s'\n",
                argv[1]);
        exit(255);
    }

    code = (main_fn) s->offset;

    argv++, argc--;             /* remove 'rdx' from command line */

    return code(argc, argv);    /* execute */
}
