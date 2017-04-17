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
 * outdbg.c	output routines for the Netwide Assembler to produce
 *		a debugging trace
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"
#include "outlib.h"
#include "insns.h"

#ifdef OF_DBG

struct Section {
    struct Section *next;
    int32_t number;
    char *name;
} *dbgsect;

static unsigned long dbg_max_data_dump = 128;

const struct ofmt of_dbg;
static void dbg_init(void)
{
    dbgsect = NULL;
    fprintf(ofile, "NASM Output format debug dump\n");
}

static void dbg_cleanup(void)
{
    dfmt->cleanup();
    while (dbgsect) {
        struct Section *tmp = dbgsect;
        dbgsect = dbgsect->next;
        nasm_free(tmp->name);
        nasm_free(tmp);
    }
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
        fprintf(ofile, "section_name on init: returning %d\n",
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
            fprintf(ofile, "section_name %s (pass %d): returning %d\n",
                    name, pass, seg);
        }
    }
    return seg;
}

static void dbg_deflabel(char *name, int32_t segment, int64_t offset,
                         int is_global, char *special)
{
    fprintf(ofile, "deflabel %s := %08"PRIx32":%016"PRIx64" %s (%d)%s%s\n",
            name, segment, offset,
            is_global == 2 ? "common" : is_global ? "global" : "local",
            is_global, special ? ": " : "", special);
}

static const char *out_type(enum out_type type)
{
    static const char *out_types[] = {
        "rawdata",
        "reserve",
        "address",
        "reladdr",
        "segment"
    };
    static char invalid_buf[64];

    if (type >= sizeof(out_types)/sizeof(out_types[0])) {
        sprintf(invalid_buf, "[invalid type %d]", type);
        return invalid_buf;
    }

    return out_types[type];
}

static const char *out_sign(enum out_sign sign)
{
    static const char *out_signs[] = {
        "wrap",
        "signed",
        "unsigned"
    };
    static char invalid_buf[64];

    if (sign >= sizeof(out_signs)/sizeof(out_signs[0])) {
        sprintf(invalid_buf, "[invalid sign %d]", sign);
        return invalid_buf;
    }

    return out_signs[sign];
}

static void dbg_out(const struct out_data *data)
{
    fprintf(ofile,
            "out to %"PRIx32":%"PRIx64" %s %s bits %d insoffs %d/%d "
            "size %"PRIu64,
            data->segment, data->offset,
            out_type(data->type), out_sign(data->sign),
            data->bits, data->insoffs, data->inslen, data->size);
    if (data->itemp) {
        fprintf(ofile, " ins %s(%d)",
                nasm_insn_names[data->itemp->opcode], data->itemp->operands);
    } else {
        fprintf(ofile, " no ins (plain data)");
    }

    if (data->type == OUT_ADDRESS || data->type == OUT_RELADDR ||
        data->type == OUT_SEGMENT) {
        fprintf(ofile, " target %"PRIx32":%"PRIx64,
                data->tsegment, data->toffset);
        if (data->twrt != NO_SEG)
            fprintf(ofile, " wrt %"PRIx32, data->twrt);
    }
    if (data->type == OUT_RELADDR)
        fprintf(ofile, " relbase %"PRId64, data->relbase);

    putc('\n', ofile);

    if (data->type == OUT_RAWDATA) {
        if ((size_t)data->size != data->size) {
            fprintf(ofile, "  data: <error: impossible size>\n");
        } else if (!data->data) {
            fprintf(ofile, "  data: <error: null pointer>\n");
        } else if (dbg_max_data_dump != -1UL &&
                   data->size > dbg_max_data_dump) {
            fprintf(ofile, "  data: <%"PRIu64" bytes>\n", data->size);
        } else {
            size_t i, j;
            const uint8_t *bytes = data->data;
            for (i = 0; i < data->size; i += 16) {
                fprintf(ofile, "  data:");
                for (j = 0; j < 16; j++) {
                    if (i+j >= data->size)
                        fprintf(ofile, "   ");
                    else
                        fprintf(ofile, "%c%02x",
                                (j == 8) ? '-' : ' ', bytes[i+j]);
                }
                fprintf(ofile,"    ");
                for (j = 0; j < 16; j++) {
                    if (i+j >= data->size) {
                        putc(' ', ofile);
                    } else {
                        if (bytes[i+j] >= 32 && bytes[i+j] <= 126)
                            putc(bytes[i+j], ofile);
                        else
                            putc('.', ofile);
                    }
                }
                putc('\n', ofile);
            }
        }
    }

    /* This is probably the only place were we'll call this this way... */
    nasm_do_legacy_output(data);
}

static void dbg_legacy_out(int32_t segto, const void *data,
                           enum out_type type, uint64_t size,
                           int32_t segment, int32_t wrt)
{
    int32_t ldata;

    if (type == OUT_ADDRESS)
        fprintf(ofile, "  legacy: out to %"PRIx32", len = %d: ",
                segto, (int)abs((int)size));
    else
        fprintf(ofile, "  legacy: out to %"PRIx32", len = %"PRIu64": ",
                segto, size);

    switch (type) {
    case OUT_RESERVE:
        fprintf(ofile, "reserved.\n");
        break;
    case OUT_RAWDATA:
        fprintf(ofile, "rawdata\n"); /* Already have a data dump */
        break;
    case OUT_ADDRESS:
	ldata = *(int64_t *)data;
        fprintf(ofile, "addr %08"PRIx32" (seg %08"PRIx32", wrt %08"PRIx32")\n",
                ldata, segment, wrt);
        break;
    case OUT_REL1ADR:
        fprintf(ofile, "rel1adr %02"PRIx8" (seg %08"PRIx32")\n",
		(uint8_t)*(int64_t *)data, segment);
        break;
    case OUT_REL2ADR:
        fprintf(ofile, "rel2adr %04"PRIx16" (seg %08"PRIx32")\n",
		(uint16_t)*(int64_t *)data, segment);
        break;
    case OUT_REL4ADR:
        fprintf(ofile, "rel4adr %08"PRIx32" (seg %08"PRIx32")\n",
		(uint32_t)*(int64_t *)data,
                segment);
        break;
    case OUT_REL8ADR:
        fprintf(ofile, "rel8adr %016"PRIx64" (seg %08"PRIx32")\n",
		(uint64_t)*(int64_t *)data, segment);
        break;
    default:
        fprintf(ofile, "unknown\n");
        break;
    }
}

static void dbg_sectalign(int32_t seg, unsigned int value)
{
    fprintf(ofile, "set alignment (%d) for segment (%u)\n",
            seg, value);
}

static int32_t dbg_segbase(int32_t segment)
{
    return segment;
}

static enum directive_result
dbg_directive(enum directive directive, char *value, int pass)
{
    fprintf(ofile, "directive [%s] value [%s] (pass %d)\n",
            directive_dname(directive), value, pass);
    return DIRR_OK;
}

static enum directive_result
dbg_pragma(const struct pragma *pragma);

static const struct pragma_facility dbg_pragma_list[] = {
    { NULL, dbg_pragma }
};

static enum directive_result
dbg_pragma(const struct pragma *pragma)
{
    fprintf(ofile, "pragma %s(%s) %s[%s] %s\n",
            pragma->facility_name,
            pragma->facility->name ? pragma->facility->name : "<default>",
            pragma->opname, directive_dname(pragma->opcode),
            pragma->tail);

    if (pragma->facility == &dbg_pragma_list[0] &&
        pragma->opcode == D_MAXDUMP) {
        if (!nasm_stricmp(pragma->tail, "unlimited")) {
            dbg_max_data_dump = -1UL;
        } else {
            char *ep;
            unsigned long arg;

            errno = 0;
            arg = strtoul(pragma->tail, &ep, 0);
            if (errno || *nasm_skip_spaces(ep)) {
                nasm_error(ERR_WARNING | ERR_WARN_BAD_PRAGMA | ERR_PASS2,
                           "invalid %%pragma dbg maxdump argument");
                return DIRR_ERROR;
            } else {
                dbg_max_data_dump = arg;
            }
        }
    }

    return DIRR_OK;
}

static void dbg_filename(char *inname, char *outname)
{
    standard_extension(inname, outname, ".dbg");
}

static const char * const types[] = {
    "unknown", "label", "byte", "word", "dword", "float", "qword", "tbyte"
};
static void dbgdbg_init(void)
{
    fprintf(ofile, "   With debug info\n");
}
static void dbgdbg_cleanup(void)
{
}

static void dbgdbg_linnum(const char *lnfname, int32_t lineno, int32_t segto)
{
    fprintf(ofile, "dbglinenum %s(%"PRId32") segment %"PRIx32"\n",
	    lnfname, lineno, segto);
}
static void dbgdbg_deflabel(char *name, int32_t segment,
                            int64_t offset, int is_global, char *special)
{
    fprintf(ofile, "dbglabel %s := %08"PRIx32":%016"PRIx64" %s (%d)%s%s\n",
            name,
            segment, offset,
            is_global == 2 ? "common" : is_global ? "global" : "local",
            is_global, special ? ": " : "", special);
}
static void dbgdbg_define(const char *type, const char *params)
{
    fprintf(ofile, "dbgdirective [%s] value [%s]\n", type, params);
}
static void dbgdbg_output(int output_type, void *param)
{
    (void)output_type;
    (void)param;
}
static void dbgdbg_typevalue(int32_t type)
{
    fprintf(ofile, "new type: %s(%"PRIX32")\n",
            types[TYM_TYPE(type) >> 3], TYM_ELEMENTS(type));
}

static const struct pragma_facility dbgdbg_pragma_list[] = {
    { "dbgdbg", dbg_pragma },
    { NULL, dbg_pragma }        /* Won't trigger, "debug" is a reserved ns */
};

static const struct dfmt debug_debug_form = {
    "Trace of all info passed to debug stage",
    "debug",
    dbgdbg_init,
    dbgdbg_linnum,
    dbgdbg_deflabel,
    dbgdbg_define,
    dbgdbg_typevalue,
    dbgdbg_output,
    dbgdbg_cleanup,
    dbgdbg_pragma_list
};

static const struct dfmt * const debug_debug_arr[3] = {
    &debug_debug_form,
    &null_debug_form,
    NULL
};

const struct ofmt of_dbg = {
    "Trace of all info passed to output stage",
    "dbg",
    OFMT_TEXT,
    64,
    debug_debug_arr,
    &debug_debug_form,
    NULL,
    dbg_init,
    dbg_out,
    dbg_legacy_out,
    dbg_deflabel,
    dbg_section_names,
    dbg_sectalign,
    dbg_segbase,
    dbg_directive,
    dbg_filename,
    dbg_cleanup,
    dbg_pragma_list
};

#endif                          /* OF_DBG */
