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
 * labels.c  label handling for the Netwide Assembler
 */

#include "compiler.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "hashtbl.h"

/*
 * A local label is one that begins with exactly one period. Things
 * that begin with _two_ periods are NASM-specific things.
 *
 * If TASM compatibility is enabled, a local label can also begin with
 * @@, so @@local is a TASM compatible local label. Note that we only
 * check for the first @ symbol, although TASM requires both.
 */
#define islocal(l)                                                      \
        (tasm_compatible_mode ?                                         \
                (((l)[0] == '.' || (l)[0] == '@') && (l)[1] != '.') :   \
                ((l)[0] == '.' && (l)[1] != '.'))
#define islocalchar(c)                                                  \
        (tasm_compatible_mode ?                                         \
                ((c) == '.' || (c) == '@') :                            \
                ((c) == '.'))

#define LABEL_BLOCK     128     /* no. of labels/block */
#define LBLK_SIZE       (LABEL_BLOCK * sizeof(union label))

#define END_LIST        -3      /* don't clash with NO_SEG! */
#define END_BLOCK       -2
#define BOGUS_VALUE     -4

#define PERMTS_SIZE     16384   /* size of text blocks */
#if (PERMTS_SIZE < IDLEN_MAX)
 #error "IPERMTS_SIZE must be greater than or equal to IDLEN_MAX"
#endif

/* values for label.defn.is_global */
#define DEFINED_BIT     1
#define GLOBAL_BIT      2
#define EXTERN_BIT      4
#define COMMON_BIT      8

#define NOT_DEFINED_YET         0
#define TYPE_MASK               3
#define LOCAL_SYMBOL            (DEFINED_BIT)
#define GLOBAL_PLACEHOLDER      (GLOBAL_BIT)
#define GLOBAL_SYMBOL           (DEFINED_BIT | GLOBAL_BIT)

union label {                   /* actual label structures */
    struct {
        int32_t segment;
        int64_t offset;
        char *label, *special;
        int is_global, is_norm;
    } defn;
    struct {
        int32_t movingon;
        int64_t dummy;
        union label *next;
    } admin;
};

struct permts {                 /* permanent text storage */
    struct permts *next;        /* for the linked list */
    int size, usage;            /* size and used space in ... */
    char data[PERMTS_SIZE];     /* ... the data block itself */
};

extern int64_t global_offset_changed;   /* defined in nasm.c */

static struct hash_table ltab;          /* labels hash table */
static union label *ldata;              /* all label data blocks */
static union label *lfree;              /* labels free block */
static struct permts *perm_head;        /* start of perm. text storage */
static struct permts *perm_tail;        /* end of perm. text storage */

static void init_block(union label *blk);
static char *perm_copy(const char *string);

static char *prevlabel;

static bool initialized = false;

char lprefix[PREFIX_MAX] = { 0 };
char lpostfix[PREFIX_MAX] = { 0 };

/*
 * Internal routine: finds the `union label' corresponding to the
 * given label name. Creates a new one, if it isn't found, and if
 * `create' is true.
 */
static union label *find_label(char *label, int create)
{
    char *prev;
    int prevlen, len;
    union label *lptr, **lpp;
    char label_str[IDLEN_MAX];
    struct hash_insert ip;

    if (islocal(label)) {
        prev = prevlabel;
        prevlen = strlen(prev);
        len = strlen(label);
        if (prevlen + len >= IDLEN_MAX) {
            nasm_error(ERR_NONFATAL, "identifier length exceed %i bytes",
                       IDLEN_MAX);
            return NULL;
        }
        memcpy(label_str, prev, prevlen);
        memcpy(label_str+prevlen, label, len+1);
        label = label_str;
    } else {
        prev = "";
        prevlen = 0;
    }

    lpp = (union label **) hash_find(&ltab, label, &ip);
    lptr = lpp ? *lpp : NULL;

    if (lptr || !create)
        return lptr;

    /* Create a new label... */
    if (lfree->admin.movingon == END_BLOCK) {
        /*
         * must allocate a new block
         */
        lfree->admin.next = (union label *)nasm_malloc(LBLK_SIZE);
        lfree = lfree->admin.next;
        init_block(lfree);
    }

    lfree->admin.movingon = BOGUS_VALUE;
    lfree->defn.label = perm_copy(label);
    lfree->defn.special = NULL;
    lfree->defn.is_global = NOT_DEFINED_YET;

    hash_add(&ip, lfree->defn.label, lfree);
    return lfree++;
}

bool lookup_label(char *label, int32_t *segment, int64_t *offset)
{
    union label *lptr;

    if (!initialized)
        return false;

    lptr = find_label(label, 0);
    if (lptr && (lptr->defn.is_global & DEFINED_BIT)) {
        *segment = lptr->defn.segment;
        *offset = lptr->defn.offset;
        return true;
    }

    return false;
}

bool is_extern(char *label)
{
    union label *lptr;

    if (!initialized)
        return false;

    lptr = find_label(label, 0);
    return (lptr && (lptr->defn.is_global & EXTERN_BIT));
}

void redefine_label(char *label, int32_t segment, int64_t offset, char *special,
                    bool is_norm, bool isextrn)
{
    union label *lptr;
    int exi;

    /* This routine possibly ought to check for phase errors.  Most assemblers
     * check for phase errors at this point.  I don't know whether phase errors
     * are even possible, nor whether they are checked somewhere else
     */

    (void)special;              /* Don't warn that this parameter is unused */
    (void)is_norm;              /* Don't warn that this parameter is unused */
    (void)isextrn;              /* Don't warn that this parameter is unused */

#ifdef DEBUG
#if DEBUG < 3
    if (!strncmp(label, "debugdump", 9))
#endif
        nasm_error(ERR_DEBUG, "redefine_label (%s, %"PRIx32", %"PRIx64", %s, %d, %d)",
              label, segment, offset, special, is_norm, isextrn);
#endif

    lptr = find_label(label, 1);
    if (!lptr)
        nasm_error(ERR_PANIC, "can't find label `%s' on pass two", label);

    if (!islocal(label)) {
        if (!islocalchar(*label) && lptr->defn.is_norm)
            prevlabel = lptr->defn.label;
    }

    if (lptr->defn.offset != offset)
        global_offset_changed++;

    lptr->defn.offset = offset;
    lptr->defn.segment = segment;

    if (pass0 == 1) {
        exi = !!(lptr->defn.is_global & GLOBAL_BIT);
        if (exi) {
            char *xsymbol;
            int slen;
            slen = strlen(lprefix);
            slen += strlen(lptr->defn.label);
            slen += strlen(lpostfix);
            slen++;             /* room for that null char */
            xsymbol = nasm_malloc(slen);
            snprintf(xsymbol, slen, "%s%s%s", lprefix, lptr->defn.label,
                     lpostfix);

            ofmt->symdef(xsymbol, segment, offset, exi,
                         special ? special : lptr->defn.special);
            ofmt->current_dfmt->debug_deflabel(xsymbol, segment, offset, exi,
                                               special ? special : lptr->defn.special);
/**	nasm_free(xsymbol);  ! outobj.c stores the pointer; ouch!!! **/
        } else {
            if ((lptr->defn.is_global & (GLOBAL_BIT | EXTERN_BIT)) != EXTERN_BIT) {
                ofmt->symdef(lptr->defn.label, segment, offset, exi,
                             special ? special : lptr->defn.special);
                ofmt->current_dfmt->debug_deflabel(label, segment, offset, exi,
                                                   special ? special : lptr->defn.special);
            }
        }
    }   /* if (pass0 == 1) */
}

void define_label(char *label, int32_t segment, int64_t offset, char *special,
                  bool is_norm, bool isextrn)
{
    union label *lptr;
    int exi;

#ifdef DEBUG
#if DEBUG<3
    if (!strncmp(label, "debugdump", 9))
#endif
        nasm_error(ERR_DEBUG, "define_label (%s, %"PRIx32", %"PRIx64", %s, %d, %d)",
              label, segment, offset, special, is_norm, isextrn);
#endif
    lptr = find_label(label, 1);
    if (!lptr)
        return;
    if (lptr->defn.is_global & DEFINED_BIT) {
        nasm_error(ERR_NONFATAL, "symbol `%s' redefined", label);
        return;
    }
    lptr->defn.is_global |= DEFINED_BIT;
    if (isextrn)
        lptr->defn.is_global |= EXTERN_BIT;

    if (!islocalchar(label[0]) && is_norm) {
        /* not local, but not special either */
        prevlabel = lptr->defn.label;
    } else if (islocal(label) && !*prevlabel) {
        nasm_error(ERR_NONFATAL, "attempt to define a local label before any"
              " non-local labels");
    }

    lptr->defn.segment = segment;
    lptr->defn.offset = offset;
    lptr->defn.is_norm = (!islocalchar(label[0]) && is_norm);

    if (pass0 == 1 || (!is_norm && !isextrn && (segment > 0) && (segment & 1))) {
        exi = !!(lptr->defn.is_global & GLOBAL_BIT);
        if (exi) {
            char *xsymbol;
            int slen;
            slen = strlen(lprefix);
            slen += strlen(lptr->defn.label);
            slen += strlen(lpostfix);
            slen++;             /* room for that null char */
            xsymbol = nasm_malloc(slen);
            snprintf(xsymbol, slen, "%s%s%s", lprefix, lptr->defn.label,
                     lpostfix);

            ofmt->symdef(xsymbol, segment, offset, exi,
                         special ? special : lptr->defn.special);
            ofmt->current_dfmt->debug_deflabel(xsymbol, segment, offset, exi,
                                               special ? special : lptr->defn.special);
/**	nasm_free(xsymbol);  ! outobj.c stores the pointer; ouch!!! **/
        } else {
            if ((lptr->defn.is_global & (GLOBAL_BIT | EXTERN_BIT)) != EXTERN_BIT) {
                ofmt->symdef(lptr->defn.label, segment, offset, exi,
                             special ? special : lptr->defn.special);
                ofmt->current_dfmt->debug_deflabel(label, segment, offset, exi,
                                                   special ? special : lptr->defn.special);
            }
        }
    }   /* if (pass0 == 1) */
}

void define_common(char *label, int32_t segment, int32_t size, char *special)
{
    union label *lptr;

    lptr = find_label(label, 1);
    if (!lptr)
        return;
    if ((lptr->defn.is_global & DEFINED_BIT) &&
        (passn == 1 || !(lptr->defn.is_global & COMMON_BIT))) {
            nasm_error(ERR_NONFATAL, "symbol `%s' redefined", label);
            return;
    }
    lptr->defn.is_global |= DEFINED_BIT|COMMON_BIT;

    if (!islocalchar(label[0])) {
        prevlabel = lptr->defn.label;
    } else {
        nasm_error(ERR_NONFATAL, "attempt to define a local label as a "
              "common variable");
        return;
    }

    lptr->defn.segment = segment;
    lptr->defn.offset = 0;

    if (pass0 == 0)
        return;

    ofmt->symdef(lptr->defn.label, segment, size, 2,
                 special ? special : lptr->defn.special);
    ofmt->current_dfmt->debug_deflabel(lptr->defn.label, segment, size, 2,
                                       special ? special : lptr->defn.special);
}

void declare_as_global(char *label, char *special)
{
    union label *lptr;

    if (islocal(label)) {
        nasm_error(ERR_NONFATAL, "attempt to declare local symbol `%s' as"
              " global", label);
        return;
    }
    lptr = find_label(label, 1);
    if (!lptr)
        return;
    switch (lptr->defn.is_global & TYPE_MASK) {
    case NOT_DEFINED_YET:
        lptr->defn.is_global = GLOBAL_PLACEHOLDER;
        lptr->defn.special = special ? perm_copy(special) : NULL;
        break;
    case GLOBAL_PLACEHOLDER:   /* already done: silently ignore */
    case GLOBAL_SYMBOL:
        break;
    case LOCAL_SYMBOL:
        if (!(lptr->defn.is_global & EXTERN_BIT)) {
            nasm_error(ERR_WARNING, "symbol `%s': GLOBAL directive "
                  "after symbol definition is an experimental feature", label);
            lptr->defn.is_global = GLOBAL_SYMBOL;
        }
        break;
    }
}

int init_labels(void)
{
    hash_init(&ltab, HASH_LARGE);

    ldata = lfree = (union label *)nasm_malloc(LBLK_SIZE);
    init_block(lfree);

    perm_head = perm_tail =
        (struct permts *)nasm_malloc(sizeof(struct permts));

    perm_head->next = NULL;
    perm_head->size = PERMTS_SIZE;
    perm_head->usage = 0;

    prevlabel = "";

    initialized = true;

    return 0;
}

void cleanup_labels(void)
{
    union label *lptr, *lhold;

    initialized = false;

    hash_free(&ltab);

    lptr = lhold = ldata;
    while (lptr) {
        lptr = &lptr[LABEL_BLOCK-1];
        lptr = lptr->admin.next;
        nasm_free(lhold);
        lhold = lptr;
    }

    while (perm_head) {
        perm_tail = perm_head;
        perm_head = perm_head->next;
        nasm_free(perm_tail);
    }
}

static void init_block(union label *blk)
{
    int j;

    for (j = 0; j < LABEL_BLOCK - 1; j++)
        blk[j].admin.movingon = END_LIST;
    blk[LABEL_BLOCK - 1].admin.movingon = END_BLOCK;
    blk[LABEL_BLOCK - 1].admin.next = NULL;
}

static char *perm_copy(const char *string)
{
    char *p;
    int len = strlen(string)+1;

    nasm_assert(len <= PERMTS_SIZE);

    if (perm_tail->size - perm_tail->usage < len) {
        perm_tail->next =
            (struct permts *)nasm_malloc(sizeof(struct permts));
        perm_tail = perm_tail->next;
        perm_tail->next = NULL;
        perm_tail->size = PERMTS_SIZE;
        perm_tail->usage = 0;
    }
    p = perm_tail->data + perm_tail->usage;
    memcpy(p, string, len);
    perm_tail->usage += len;

    return p;
}

char *local_scope(char *label)
{
   return islocal(label) ? prevlabel : "";
}

/*
 * Notes regarding bug involving redefinition of external segments.
 *
 * Up to and including v0.97, the following code didn't work. From 0.97
 * developers release 2 onwards, it will generate an error.
 *
 * EXTERN extlabel
 * newlabel EQU extlabel + 1
 *
 * The results of allowing this code through are that two import records
 * are generated, one for 'extlabel' and one for 'newlabel'.
 *
 * The reason for this is an inadequacy in the defined interface between
 * the label manager and the output formats. The problem lies in how the
 * output format driver tells that a label is an external label for which
 * a label import record must be produced. Most (all except bin?) produce
 * the record if the segment number of the label is not one of the internal
 * segments that the output driver is producing.
 *
 * A simple fix to this would be to make the output formats keep track of
 * which symbols they've produced import records for, and make them not
 * produce import records for segments that are already defined.
 *
 * The best way, which is slightly harder but reduces duplication of code
 * and should therefore make the entire system smaller and more stable is
 * to change the interface between assembler, define_label(), and
 * the output module. The changes that are needed are:
 *
 * The semantics of the 'isextern' flag passed to define_label() need
 * examining. This information may or may not tell us what we need to
 * know (ie should we be generating an import record at this point for this
 * label). If these aren't the semantics, the semantics should be changed
 * to this.
 *
 * The output module interface needs changing, so that the `isextern' flag
 * is passed to the module, so that it can be easily tested for.
 */
