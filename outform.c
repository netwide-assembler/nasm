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

#define BUILD_DRIVERS_ARRAY
#include "outform.h"

static int ndrivers = 0;

struct ofmt *ofmt_find(char *name)     /* find driver */
{
    int i;

    for (i=0; i<ndrivers; i++)
	if (!strcmp(name,drivers[i]->shortname))
	    return drivers[i];

    return NULL;
}
struct dfmt *dfmt_find(struct ofmt *ofmt, char *name)     /* find driver */
{
    struct dfmt **dfmt = ofmt->debug_formats;
    while (*dfmt) {
	if (!strcmp(name, (*dfmt)->shortname))
		return (*dfmt);
	dfmt++;
    }
    return NULL;
}

void ofmt_list(struct ofmt *deffmt, FILE *fp)
{
    int i;
    for (i=0; i<ndrivers; i++)
	fprintf(fp, "  %c %-10s%s\n",
		drivers[i] == deffmt ? '*' : ' ',
		drivers[i]->shortname,
		drivers[i]->fullname);
}
void dfmt_list(struct ofmt *ofmt, FILE *fp)
{
    struct dfmt ** drivers = ofmt->debug_formats;
    while (*drivers) {
	fprintf(fp, "  %c %-10s%s\n",
		drivers[0] == ofmt->current_dfmt ? '*' : ' ',
		drivers[0]->shortname,
		drivers[0]->fullname);
	drivers++;
    }
}
struct ofmt *ofmt_register (efunc error) {
    for (ndrivers=0; drivers[ndrivers] != NULL; ndrivers++);

    if (ndrivers==0)
    {
        error(ERR_PANIC | ERR_NOFILE,
	      "No output drivers given at compile time");
    }

    return (&OF_DEFAULT);
}
