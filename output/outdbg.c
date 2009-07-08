/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
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
 * outdbg.c	output routines for the Netwide Assembler to produce
 *		a debugging trace
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "output/outform.h"

#ifdef OF_DBG

struct Section {
    struct Section *next;
    int32_t number;
    char *name;
} *dbgsect;

FILE *dbgf;
efunc dbgef;

struct ofmt of_dbg;
static void dbg_init(FILE * fp, efunc errfunc, ldfunc ldef, evalfunc eval)
{
    (void)eval;

    dbgf = fp;
    dbgef = errfunc;
    dbgsect = NULL;
    (void)ldef;
    fprintf(fp, "NASM Output format debug dump\n");
}

static void dbg_cleanup(int debuginfo)
{
    (void)debuginfo;
    of_dbg.current_dfmt->cleanup();
    while (dbgsect) {
        struct Section *tmp = dbgsect;
        dbgsect = dbgsect->next;
        nasm_free(tmp->name);
        nasm_free(tmp);
    }
    fclose(dbgf);
}

static int32_t dbg_section_names(char *name, int pass, int *bits)
{
    int seg;

    /*
     * We must have an initial default: let's make it 16.
     */
    if (!name)
        *bits = 16;

    if (!name)
        fprintf(dbgf, "section_name on init: returning %d\n",
                seg = seg_alloc());
    else {
        int n = strcspn(name, " \t");
        char *sname = nasm_strndup(name, n);
        struct Section *s;

        seg = NO_SEG;
        for (s = dbgsect; s; s = s->next)
            if (!strcmp(s->name, sname))
                seg = s->number;

        if (seg == NO_SEG) {
            s = nasm_malloc(sizeof(*s));
            s->name = sname;
            s->number = seg = seg_alloc();
            s->next = dbgsect;
            dbgsect = s;
            fprintf(dbgf, "section_name %s (pass %d): returning %d\n",
                    name, pass, seg);
        }
    }
    return seg;
}

static void dbg_deflabel(char *name, int32_t segment, int64_t offset,
                         int is_global, char *special)
{
    fprintf(dbgf, "deflabel %s := %08"PRIx32":%016"PRIx64" %s (%d)%s%s\n",
            name, segment, offset,
            is_global == 2 ? "common" : is_global ? "global" : "local",
            is_global, special ? ": " : "", special);
}

static void dbg_out(int32_t segto, const void *data,
		    enum out_type type, uint64_t size,
                    int32_t segment, int32_t wrt)
{
    int32_t ldata;
    int id;

    fprintf(dbgf, "out to %"PRIx32", len = %"PRIu64": ", segto, size);

    switch (type) {
    case OUT_RESERVE:
        fprintf(dbgf, "reserved.\n");
        break;
    case OUT_RAWDATA:
        fprintf(dbgf, "raw data = ");
        while (size--) {
            id = *(uint8_t *)data;
            data = (char *)data + 1;
            fprintf(dbgf, "%02x ", id);
        }
        fprintf(dbgf, "\n");
        break;
    case OUT_ADDRESS:
	ldata = *(int64_t *)data;
        fprintf(dbgf, "addr %08"PRIx32" (seg %08"PRIx32", wrt %08"PRIx32")\n", ldata,
                segment, wrt);
        break;
    case OUT_REL2ADR:
        fprintf(dbgf, "rel2adr %04"PRIx16" (seg %08"PRIx32")\n",
		(uint16_t)*(int64_t *)data, segment);
        break;
    case OUT_REL4ADR:
        fprintf(dbgf, "rel4adr %08"PRIx32" (seg %08"PRIx32")\n",
		(uint32_t)*(int64_t *)data,
                segment);
        break;
    case OUT_REL8ADR:
        fprintf(dbgf, "rel8adr %016"PRIx64" (seg %08"PRIx32")\n",
		(uint64_t)*(int64_t *)data, segment);
        break;
    default:
        fprintf(dbgf, "unknown\n");
        break;
    }
}

static int32_t dbg_segbase(int32_t segment)
{
    return segment;
}

static int dbg_directive(char *directive, char *value, int pass)
{
    fprintf(dbgf, "directive [%s] value [%s] (pass %d)\n",
            directive, value, pass);
    return 1;
}

static void dbg_filename(char *inname, char *outname, efunc error)
{
    standard_extension(inname, outname, ".dbg", error);
}

static int dbg_set_info(enum geninfo type, char **val)
{
    (void)type;
    (void)val;
    return 0;
}

char *types[] = {
    "unknown", "label", "byte", "word", "dword", "float", "qword", "tbyte"
};
void dbgdbg_init(struct ofmt *of, void *id, FILE * fp, efunc error)
{
    (void)of;
    (void)id;
    (void)fp;
    (void)error;
    fprintf(fp, "   With debug info\n");
}
static void dbgdbg_cleanup(void)
{
}

static void dbgdbg_linnum(const char *lnfname, int32_t lineno, int32_t segto)
{
    fprintf(dbgf, "dbglinenum %s(%"PRId32") := %08"PRIx32"\n",
	    lnfname, lineno, segto);
}
static void dbgdbg_deflabel(char *name, int32_t segment,
                            int64_t offset, int is_global, char *special)
{
    fprintf(dbgf, "dbglabel %s := %08"PRIx32":%016"PRIx64" %s (%d)%s%s\n",
            name,
            segment, offset,
            is_global == 2 ? "common" : is_global ? "global" : "local",
            is_global, special ? ": " : "", special);
}
static void dbgdbg_define(const char *type, const char *params)
{
    fprintf(dbgf, "dbgdirective [%s] value [%s]\n", type, params);
}
static void dbgdbg_output(int output_type, void *param)
{
    (void)output_type;
    (void)param;
}
static void dbgdbg_typevalue(int32_t type)
{
    fprintf(dbgf, "new type: %s(%"PRIX32")\n",
            types[TYM_TYPE(type) >> 3], TYM_ELEMENTS(type));
}
static struct dfmt debug_debug_form = {
    "Trace of all info passed to debug stage",
    "debug",
    dbgdbg_init,
    dbgdbg_linnum,
    dbgdbg_deflabel,
    dbgdbg_define,
    dbgdbg_typevalue,
    dbgdbg_output,
    dbgdbg_cleanup,
};

static struct dfmt *debug_debug_arr[3] = {
    &debug_debug_form,
    &null_debug_form,
    NULL
};

struct ofmt of_dbg = {
    "Trace of all info passed to output stage",
    "dbg",
    OFMT_TEXT,
    debug_debug_arr,
    &debug_debug_form,
    NULL,
    dbg_init,
    dbg_set_info,
    dbg_out,
    dbg_deflabel,
    dbg_section_names,
    dbg_segbase,
    dbg_directive,
    dbg_filename,
    dbg_cleanup
};

#endif                          /* OF_DBG */
