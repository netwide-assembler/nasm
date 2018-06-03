/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2018 The NASM Authors - All Rights Reserved
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

#include "nasm.h"
#include "nasmlib.h"
#include "error.h"
#include "hashtbl.h"
#include "labels.h"
#include "mempool.h"

/*
 * A dot-local label is one that begins with exactly one period. Things
 * that begin with _two_ periods are NASM-specific things.
 *
 * If TASM compatibility is enabled, a local label can also begin with
 * @@.
 */
static bool islocal(const char *l)
{
    if (tasm_compatible_mode) {
        if (l[0] == '@' && l[1] == '@')
            return true;
    }

    return (l[0] == '.' && l[1] != '.');
}

/*
 * Return true if this falls into NASM's '..' namespace
 */
static bool ismagic(const char *l)
{
    return l[0] == '.' && l[1] == '.' && l[2] != '@';
}

#define LABEL_BLOCK     128     /* no. of labels/block */
#define LBLK_SIZE       (LABEL_BLOCK * sizeof(union label))

#define END_LIST        -3      /* don't clash with NO_SEG! */
#define END_BLOCK       -2
#define BOGUS_VALUE     -4

#define PERMTS_SIZE     16384   /* size of text blocks */
#if (PERMTS_SIZE < IDLEN_MAX)
 #error "IPERMTS_SIZE must be greater than or equal to IDLEN_MAX"
#endif

/* string values for enum label_type */
static const char * const types[] =
{"local", "global", "static", "extern", "common", "special",
 "output format special"};

struct label {                   /* actual label structures */
    int32_t segment;
    int64_t offset;
    char *label, *mangled, *special;
    enum label_type type, mangled_type;
    bool defined;
};

struct permts {                 /* permanent text storage */
    struct permts *next;        /* for the linked list */
    unsigned int size, usage;   /* size and used space in ... */
    char data[PERMTS_SIZE];     /* ... the data block itself */
};
#define PERMTS_HEADER offsetof(struct permts, data)

uint64_t global_offset_changed;		/* counter for global offset changes */

static struct hash_table ltab;          /* labels hash table */

static const char *mangle_label_name(struct label *lptr);

static const char *prevlabel;

static bool initialized = false;

static mempool mempool_labels;

/*
 * Emit a symdef to the output and the debug format backends.
 */
static void out_symdef(struct label *lptr)
{
    int backend_type;

    /* Backend-defined special segments are passed to symdef immediately */
    if (pass0 == 2) {
        /* Emit special fixups for globals and commons */
        switch (lptr->type) {
        case LBL_GLOBAL:
        case LBL_COMMON:
        case LBL_EXTERN:
            if (lptr->special)
                ofmt->symdef(lptr->label, 0, 0, 3, lptr->special);
            break;
        default:
            break;
        }
        return;
    }

    if (pass0 != 1 && lptr->type != LBL_BACKEND)
        return;

    /* Clean up this hack... */
    switch(lptr->type) {
    case LBL_GLOBAL:
        backend_type = 1;
        break;
    case LBL_COMMON:
        backend_type = 2;
        break;
    default:
        backend_type = 0;
        break;
    }

    /* Might be necessary for a backend symbol */
    mangle_label_name(lptr);

    ofmt->symdef(lptr->mangled, lptr->segment,
                 lptr->offset, backend_type,
                 lptr->special);

    /*
     * NASM special symbols are not passed to the debug format; none
     * of the current backends want to see them.
     */
    if (lptr->type == LBL_SPECIAL || lptr->type == LBL_BACKEND)
        return;

    dfmt->debug_deflabel(lptr->mangled, lptr->segment,
                         lptr->offset, backend_type,
                         lptr->special);
}

/*
 * Internal routine: finds the `struct label' corresponding to the
 * given label name. Creates a new one, if it isn't found, and if
 * `create' is true.
 */
static struct label *find_label(const char *label, bool create, bool *created)
{
    struct label *lptr, **lpp;
    struct hash_insert ip;

    if (islocal(label))
        label = mempool_cat(mempool_line, prevlabel, label);

    lpp = (struct label **) hash_find(&ltab, label, &ip);
    lptr = lpp ? *lpp : NULL;

    if (lptr || !create) {
        if (created)
            *created = false;
        return lptr;
    }

    mempool_new(mempool_labels, lptr);
    if (created)
        *created = true;

    nasm_zero(*lptr);
    lptr->label = perm_copy(label);
    hash_add(&ip, lptr->label, lptr);
    return lptr;
}

bool lookup_label(const char *label, int32_t *segment, int64_t *offset)
{
    struct label *lptr;

    if (!initialized)
        return false;

    lptr = find_label(label, false, NULL);
    if (lptr && lptr->defined) {
        *segment = lptr->segment;
        *offset = lptr->offset;
        return true;
    }

    return false;
}

bool is_extern(const char *label)
{
    struct label *lptr;

    if (!initialized)
        return false;

    lptr = find_label(label, false, NULL);
    return lptr && lptr->type == LBL_EXTERN;
}

static const char *mangle_strings[] = {"", "", "", ""};
static bool mangle_string_set[ARRAY_SIZE(mangle_strings)];

/*
 * Set a prefix or suffix
 */
void set_label_mangle(enum mangle_index which, const char *what)
{
    if (mangle_string_set[which])
        return;                 /* Once set, do not change */

    mangle_strings[which] = perm_copy(what);
    mangle_string_set[which] = true;
}

/*
 * Format a label name with appropriate prefixes and suffixes
 */
static const char *mangle_label_name(struct label *lptr)
{
    const char *prefix;
    const char *suffix;

    if (likely(lptr->mangled &&
               lptr->mangled_type == lptr->type))
        return lptr->mangled; /* Already mangled */

    switch (lptr->type) {
    case LBL_GLOBAL:
    case LBL_STATIC:
    case LBL_EXTERN:
        prefix = mangle_strings[LM_GPREFIX];
        suffix = mangle_strings[LM_GSUFFIX];
        break;
    case LBL_BACKEND:
    case LBL_SPECIAL:
        prefix = suffix = "";
        break;
    default:
        prefix = mangle_strings[LM_LPREFIX];
        suffix = mangle_strings[LM_LSUFFIX];
        break;
    }

    lptr->mangled_type = lptr->type;

    if (!(*prefix) && !(*suffix))
        lptr->mangled = lptr->label;
    else
        lptr->mangled = perm_copy3(prefix, lptr->label, suffix);

    return lptr->mangled;
}

static void
handle_herelabel(const struct label *lptr, int32_t *segment, int64_t *offset)
{
    int32_t oldseg;

    if (likely(!ofmt->herelabel))
        return;

    if (unlikely(location.segment == NO_SEG))
        return;

    oldseg = *segment;

    if (oldseg == location.segment && *offset == location.offset) {
        /* This label is defined at this location */
        int32_t newseg;

        nasm_assert(lptr->mangled);
        newseg = ofmt->herelabel(lptr->mangled, lptr->type, oldseg);
        if (likely(newseg == oldseg))
            return;

        *segment = newseg;
        *offset  = switch_segment(newseg);
    }
}

static bool declare_label_lptr(struct label *lptr,
                               enum label_type type, const char *special)
{
    if (special && !special[0])
        special = NULL;

    if (lptr->type == type ||
        (pass0 == 0 && lptr->type == LBL_LOCAL)) {
        lptr->type = type;
        if (special) {
            if (!lptr->special)
                lptr->special = perm_copy(special);
            else if (nasm_stricmp(lptr->special, special))
                nasm_error(ERR_NONFATAL,
                           "symbol `%s' has inconsistent attributes `%s' and `%s'",
                           lptr->label, lptr->special, special);
        }
        return true;
    }

    /* EXTERN can be replaced with GLOBAL or COMMON */
    if (lptr->type == LBL_EXTERN &&
        (type == LBL_GLOBAL || type == LBL_COMMON)) {
        lptr->type = type;
        /* Override special unconditionally */
        if (special)
            lptr->special = perm_copy(special);
        return true;
    }

    /* GLOBAL or COMMON ignore subsequent EXTERN */
    if ((lptr->type == LBL_GLOBAL || lptr->type == LBL_COMMON) &&
        type == LBL_EXTERN) {
        if (!lptr->special)
            lptr->special = perm_copy(special);
        return true;
    }

    nasm_error(ERR_NONFATAL, "symbol `%s' declared both as %s and %s",
               lptr->label, types[lptr->type], types[type]);

    return false;
}

bool declare_label(const char *label, enum label_type type, const char *special)
{
    struct label *lptr;
    bool created;

    lptr = find_label(label, true, &created);
    return declare_label_lptr(lptr, type, special);
}

/*
 * The "normal" argument decides if we should update the local segment
 * base name or not.
 */
void define_label(const char *label, int32_t segment,
                  int64_t offset, bool normal)
{
    struct label *lptr;
    bool created, changed;

    /*
     * Phase errors here can be one of two types: a new label appears,
     * or the offset changes. Increment global_offset_changed when that
     * happens, to tell the assembler core to make another pass.
     */
    lptr = find_label(label, true, &created);

    if (pass0 > 1) {
        if (created)
	    nasm_error(ERR_WARNING, "label `%s' defined on pass two", label);
    }

    if (lptr->defined || lptr->type == LBL_BACKEND) {
        /* We have seen this on at least one previous pass */
        mangle_label_name(lptr);
        handle_herelabel(lptr, &segment, &offset);
    }

    if (ismagic(label) && lptr->type == LBL_LOCAL)
        lptr->type = LBL_SPECIAL;
    
    if (!islocal(label) && normal) {
        prevlabel = lptr->label;
    }

    changed = !lptr->defined || lptr->segment != segment ||
        lptr->offset != offset;
    global_offset_changed += changed;

    /*
     * This probably should be ERR_NONFATAL, but not quite yet.  As a
     * special case, LBL_SPECIAL symbols are allowed to be changed
     * even during the last pass.
     */
    if (changed && pass0 == 2 && lptr->type != LBL_SPECIAL)
        nasm_error(ERR_WARNING, "label `%s' changed during code generation",
                   lptr->label);

    lptr->segment = segment;
    lptr->offset  = offset;
    lptr->defined = true;

    out_symdef(lptr);
}

/*
 * Define a special backend label
 */
void backend_label(const char *label, int32_t segment, int64_t offset)
{
    if (!declare_label(label, LBL_BACKEND, NULL))
        return;

    define_label(label, segment, offset, false);
}

int init_labels(void)
{
    hash_init(&ltab, HASH_LARGE);
    prevlabel = "";

    initialized = true;

    return 0;
}

void cleanup_labels(void)
{
    initialized = false;

    hash_free(&ltab);
    mempool_free(mempool_labels);
}

const char *local_scope(const char *label)
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
