/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2017 The NASM Authors - All Rights Reserved
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
 * Parse and handle [pragma] directives.  The preprocessor handles
 * %pragma preproc directives separately, all other namespaces are
 * simply converted to [pragma].
 */

#include "compiler.h"

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>

#include "nasm.h"
#include "nasmlib.h"
#include "assemble.h"
#include "error.h"

/*
 * Handle [pragma] directives.  [pragma] is generally produced by
 * the %pragma preprocessor directive, which simply passes on any
 * string that it finds *except* %pragma preproc.  The idea is
 * that pragmas are of the form:
 *
 * %pragma <facility> <opname> [<options>...]
 *
 * ... where "facility" can be either a generic facility or a backend
 * name.
 *
 * The following names are currently reserved for global facilities;
 * so far none of these have any defined pragmas at all:
 *
 * preproc	- preprocessor
 * asm		- assembler
 * list		- listing generator
 * file		- generic file handling
 * input	- input file handling
 * output	- backend-independent output handling
 * debug	- backend-independent debug handling
 * ignore	- dummy pragma (can be used to "comment out")
 *
 * This function should generally not error out if it doesn't understand
 * what a pragma is for, for unknown arguments, etc; the whole point of
 * a pragma is that future releases might add new ones that should be
 * ignored rather than be an error.  Erroring out is acceptable for
 * known pragmas suffering from parsing errors and so on.
 *
 * Adding default-suppressed warnings would, however, be a good idea
 * at some point.
 */
static struct pragma_facility global_pragmas[] =
{
    { "preproc",	NULL }, /* This shouldn't happen... */
    { "asm",		NULL },
    { "list",		NULL },
    { "file",		NULL },
    { "input",		NULL },
    { "output",		NULL },
    { "debug",		NULL },
    { "ignore",		NULL },
    { NULL, NULL }
};

/*
 * Search a pragma list for a known pragma facility and if so, invoke
 * the handler.  Return true if processing is complete.
 * The "default name", if set, matches the final NULL entry (used
 * for backends, so multiple backends can share the same list under
 * some circumstances.)
 */
static bool search_pragma_list(const struct pragma_facility *list,
                               const char *default_name,
			       struct pragma *pragma)
{
    const struct pragma_facility *pf;
    enum directive_result rv;

    if (!list)
	return false;

    for (pf = list; pf->name; pf++) {
        if (!nasm_stricmp(pragma->facility_name, pf->name))
            goto found_it;
    }

    if (default_name && !nasm_stricmp(pragma->facility_name, default_name))
        goto found_it;

    return false;

found_it:
    pragma->facility = pf;

    /* If the handler is NULL all pragmas are unknown... */
    if (pf->handler)
        rv = pf->handler(pragma);
    else
        rv = DIRR_UNKNOWN;

    switch (rv) {
    case DIRR_UNKNOWN:
        switch (pragma->opcode) {
        case D_none:
            nasm_error(ERR_WARNING|ERR_PASS2|ERR_WARN_BAD_PRAGMA,
                       "empty %%pragma %s", pragma->facility_name);
            break;
        default:
            nasm_error(ERR_WARNING|ERR_PASS2|ERR_WARN_UNKNOWN_PRAGMA,
                       "unknown %%pragma %s %s",
                       pragma->facility_name, pragma->opname);
            break;
        }
        break;

    case DIRR_OK:
    case DIRR_ERROR:
        break;                  /* Nothing to do */

    case DIRR_BADPARAM:
        /*
         * This one is an error.  Don't use it if forward compatibility
         * would be compromised, as opposed to an inherent error.
         */
        nasm_error(ERR_NONFATAL, "bad argument to %%pragma %s %s",
                   pragma->facility_name, pragma->opname);
        break;

    default:
        panic();
    }
    return true;
}

void process_pragma(char *str)
{
    struct pragma pragma;
    char *p;

    nasm_zero(pragma);

    pragma.facility_name = nasm_get_word(str, &p);
    if (!pragma.facility_name) {
	nasm_error(ERR_WARNING|ERR_PASS2|ERR_WARN_BAD_PRAGMA,
		   "empty pragma directive");
        return;                 /* Empty pragma */
    }

    /*
     * The facility "ignore" means just that; don't even complain of
     * the absence of an operation.
     */
    if (!nasm_stricmp(pragma.facility_name, "ignore"))
        return;

    pragma.opname = nasm_get_word(p, &p);
    if (!pragma.opname)
        pragma.opcode = D_none;
    else
        pragma.opcode = directive_find(pragma.opname);

    pragma.tail = nasm_skip_spaces(p);

    /* Look for a global pragma namespace */
    if (search_pragma_list(global_pragmas, NULL, &pragma))
	return;

    /* Look to see if it is an output backend pragma */
    if (search_pragma_list(ofmt->pragmas, ofmt->shortname, &pragma))
	return;

    /* Look to see if it is a debug format pragma */
    if (search_pragma_list(dfmt->pragmas, dfmt->shortname, &pragma))
	return;

    /*
     * Note: it would be nice to warn for an unknown namespace,
     * but in order to do so we need to walk *ALL* the backends
     * in order to make sure we aren't dealing with a pragma that
     * is for another backend.  On the other hand, that could
     * also be a warning with a separate warning flag.
     *
     * Leave this for the future, however, the warning classes are
     * already defined for future compatibility.
     */
}
