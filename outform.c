/* outform.c	manages a list of output formats, and associates
 * 		them with their relevant drivers. Also has a
 * 		routine to find the correct driver given a name
 * 		for it
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <string.h>
#include "outform.h"

static struct ofmt *drivers[MAX_OUTPUT_FORMATS];
static int ndrivers = 0;

struct ofmt *ofmt_find(char *name)     /* find driver */
{
    int i;

    for (i=0; i<ndrivers; i++)
	if (!strcmp(name,drivers[i]->shortname))
	    return drivers[i];

    return NULL;
}

void ofmt_list(struct ofmt *deffmt, FILE *fp)
{
    int i;
    for (i=0; i<ndrivers; i++)
	fprintf(fp, "  %c %-7s%s\n",
		drivers[i] == deffmt ? '*' : ' ',
		drivers[i]->shortname,
		drivers[i]->fullname);
}

void ofmt_register (struct ofmt *info) {
    drivers[ndrivers++] = info;
}
