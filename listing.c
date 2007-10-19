/* listing.c    listing file generator for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 2/vii/97 by Simon Tatham
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "listing.h"

#define LIST_MAX_LEN 216        /* something sensible */
#define LIST_INDENT  40
#define LIST_HEXBIT  18

typedef struct MacroInhibit MacroInhibit;

static struct MacroInhibit {
    MacroInhibit *next;
    int level;
    int inhibiting;
} *mistack;

static char xdigit[] = "0123456789ABCDEF";

#define HEX(a,b) (*(a)=xdigit[((b)>>4)&15],(a)[1]=xdigit[(b)&15]);

static char listline[LIST_MAX_LEN];
static int listlinep;

static char listdata[2 * LIST_INDENT];  /* we need less than that actually */
static int32_t listoffset;

static int32_t listlineno;

static int32_t listp;

static int suppress;            /* for INCBIN & TIMES special cases */

static int listlevel, listlevel_e;

static FILE *listfp;

static void list_emit(void)
{
    if (!listlinep && !listdata[0])
        return;

    fprintf(listfp, "%6"PRId32" ", ++listlineno);

    if (listdata[0])
        fprintf(listfp, "%08"PRIX32" %-*s", listoffset, LIST_HEXBIT + 1,
                listdata);
    else
        fprintf(listfp, "%*s", LIST_HEXBIT + 10, "");

    if (listlevel_e)
        fprintf(listfp, "%s<%d>", (listlevel < 10 ? " " : ""),
                listlevel_e);
    else if (listlinep)
        fprintf(listfp, "    ");

    if (listlinep)
        fprintf(listfp, " %s", listline);

    fputc('\n', listfp);
    listlinep = false;
    listdata[0] = '\0';
}

static void list_init(char *fname, efunc error)
{
    listfp = fopen(fname, "w");
    if (!listfp) {
        error(ERR_NONFATAL, "unable to open listing file `%s'", fname);
        return;
    }

    *listline = '\0';
    listlineno = 0;
    listp = true;
    listlevel = 0;
    suppress = 0;
    mistack = nasm_malloc(sizeof(MacroInhibit));
    mistack->next = NULL;
    mistack->level = 0;
    mistack->inhibiting = true;
}

static void list_cleanup(void)
{
    if (!listp)
        return;

    while (mistack) {
        MacroInhibit *temp = mistack;
        mistack = temp->next;
        nasm_free(temp);
    }

    list_emit();
    fclose(listfp);
}

static void list_out(int32_t offset, char *str)
{
    if (strlen(listdata) + strlen(str) > LIST_HEXBIT) {
        strcat(listdata, "-");
        list_emit();
    }
    if (!listdata[0])
        listoffset = offset;
    strcat(listdata, str);
}

static void list_output(int32_t offset, const void *data, uint32_t type)
{
    uint32_t typ, size;

    if (!listp || suppress || user_nolist)      /* fbk - 9/2/00 */
        return;

    typ = type & OUT_TYPMASK;
    size = type & OUT_SIZMASK;


    if (typ == OUT_RAWDATA) {
        uint8_t const *p = data;
        char q[3];
        while (size--) {
            HEX(q, *p);
            q[2] = '\0';
            list_out(offset++, q);
            p++;
        }
    } else if (typ == OUT_ADDRESS) {
        uint64_t d = *(int64_t *)data;
        char q[20];
        uint8_t p[8], *r = p;
        if (size == 4) {
            q[0] = '[';
            q[9] = ']';
            q[10] = '\0';
            WRITELONG(r, d);
            HEX(q + 1, p[0]);
            HEX(q + 3, p[1]);
            HEX(q + 5, p[2]);
            HEX(q + 7, p[3]);
            list_out(offset, q);
        } else if (size == 8) {
            q[0] = '[';
            q[17] = ']';
            q[18] = '\0';
            WRITEDLONG(r, d);
            HEX(q + 1,  p[0]);
            HEX(q + 3,  p[1]);
            HEX(q + 5,  p[2]);
            HEX(q + 7,  p[3]);
            HEX(q + 9,  p[4]);
            HEX(q + 11, p[5]);
            HEX(q + 13, p[6]);
            HEX(q + 15, p[7]);
            list_out(offset, q);
        } else {
            q[0] = '[';
            q[5] = ']';
            q[6] = '\0';
            WRITESHORT(r, d);
            HEX(q + 1, p[0]);
            HEX(q + 3, p[1]);
            list_out(offset, q);
        }
    } else if (typ == OUT_REL2ADR) {
        uint32_t d = *(int32_t *)data;
        char q[11];
        uint8_t p[4], *r = p;
        q[0] = '(';
        q[5] = ')';
        q[6] = '\0';
        WRITESHORT(r, d);
        HEX(q + 1, p[0]);
        HEX(q + 3, p[1]);
        list_out(offset, q);
    } else if (typ == OUT_REL4ADR) {
        uint32_t d = *(int32_t *)data;
        char q[11];
        uint8_t p[4], *r = p;
        q[0] = '(';
        q[9] = ')';
        q[10] = '\0';
        WRITELONG(r, d);
        HEX(q + 1, p[0]);
        HEX(q + 3, p[1]);
        HEX(q + 5, p[2]);
        HEX(q + 7, p[3]);
        list_out(offset, q);
    } else if (typ == OUT_RESERVE) {
        char q[20];
        snprintf(q, sizeof(q), "<res %08"PRIX32">", size);
        list_out(offset, q);
    }
}

static void list_line(int type, char *line)
{
    if (!listp)
        return;
    if (user_nolist) {          /* fbk - 9/2/00 */
        listlineno++;
        return;
    }

    if (mistack && mistack->inhibiting) {
        if (type == LIST_MACRO)
            return;
        else {                  /* pop the m i stack */
            MacroInhibit *temp = mistack;
            mistack = temp->next;
            nasm_free(temp);
        }
    }
    list_emit();
    listlinep = true;
    strncpy(listline, line, LIST_MAX_LEN - 1);
    listline[LIST_MAX_LEN - 1] = '\0';
    listlevel_e = listlevel;
}

static void list_uplevel(int type)
{
    if (!listp)
        return;
    if (type == LIST_INCBIN || type == LIST_TIMES) {
        suppress |= (type == LIST_INCBIN ? 1 : 2);
        list_out(listoffset, type == LIST_INCBIN ? "<incbin>" : "<rept>");
        return;
    }

    listlevel++;

    if (mistack && mistack->inhibiting && type == LIST_INCLUDE) {
        MacroInhibit *temp = nasm_malloc(sizeof(MacroInhibit));
        temp->next = mistack;
        temp->level = listlevel;
        temp->inhibiting = false;
        mistack = temp;
    } else if (type == LIST_MACRO_NOLIST) {
        MacroInhibit *temp = nasm_malloc(sizeof(MacroInhibit));
        temp->next = mistack;
        temp->level = listlevel;
        temp->inhibiting = true;
        mistack = temp;
    }
}

static void list_downlevel(int type)
{
    if (!listp)
        return;

    if (type == LIST_INCBIN || type == LIST_TIMES) {
        suppress &= ~(type == LIST_INCBIN ? 1 : 2);
        return;
    }

    listlevel--;
    while (mistack && mistack->level > listlevel) {
        MacroInhibit *temp = mistack;
        mistack = temp->next;
        nasm_free(temp);
    }
}

ListGen nasmlist = {
    list_init,
    list_cleanup,
    list_output,
    list_line,
    list_uplevel,
    list_downlevel
};
