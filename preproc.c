/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2011 The NASM Authors - All Rights Reserved
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
 * preproc.c   macro preprocessor for the Netwide Assembler
 */

/* Typical flow of text through preproc
 *
 * pp_getline gets tokenized lines, either
 *
 *   from a macro expansion
 *
 * or
 *   {
 *   read_line  gets raw text from stdmacpos, or predef, or current input file
 *   tokenize   converts to tokens
 *   }
 *
 * expand_mmac_params is used to expand %1 etc., unless a macro is being
 * defined or a false conditional is being processed
 * (%0, %1, %+1, %-1, %%foo
 *
 * do_directive checks for directives
 *
 * expand_smacro is used to expand single line macros
 *
 * expand_mmacro is used to expand multi-line macros
 *
 * detoken is used to convert the line back to text
 */

#include "compiler.h"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "preproc.h"
#include "hashtbl.h"
#include "quote.h"
#include "stdscan.h"
#include "eval.h"
#include "tokens.h"
#include "tables.h"

typedef struct SMacro SMacro;
typedef struct ExpDef ExpDef;
typedef struct ExpInv ExpInv;
typedef struct Context Context;
typedef struct Token Token;
typedef struct Blocks Blocks;
typedef struct Line Line;
typedef struct Include Include;
typedef struct Cond Cond;
typedef struct IncPath IncPath;

/*
 * Note on the storage of both SMacro and MMacros: the hash table
 * indexes them case-insensitively, and we then have to go through a
 * linked list of potential case aliases (and, for MMacros, parameter
 * ranges); this is to preserve the matching semantics of the earlier
 * code.  If the number of case aliases for a specific macro is a
 * performance issue, you may want to reconsider your coding style.
 */

/*
 * Store the definition of a single-line macro.
 */
struct SMacro {
    SMacro          *next;
    char            *name;
    Token           *expansion;
    unsigned int    nparam;
    bool            casesense;
    bool            in_progress;
};

/*
 * The context stack is composed of a linked list of these.
 */
struct Context {
    Context             *next;
    char                *name;
    struct hash_table   localmac;
    uint32_t            number;
};

/*
 * This is the internal form which we break input lines up into.
 * Typically stored in linked lists.
 *
 * Note that `type' serves a double meaning: TOK_SMAC_PARAM is not
 * necessarily used as-is, but is intended to denote the number of
 * the substituted parameter. So in the definition
 *
 *     %define a(x,y) ( (x) & ~(y) )
 *
 * the token representing `x' will have its type changed to
 * TOK_SMAC_PARAM, but the one representing `y' will be
 * TOK_SMAC_PARAM+1.
 *
 * TOK_INTERNAL_STRING is a dirty hack: it's a single string token
 * which doesn't need quotes around it. Used in the pre-include
 * mechanism as an alternative to trying to find a sensible type of
 * quote to use on the filename we were passed.
 */
enum pp_token_type {
    TOK_NONE = 0,
    TOK_WHITESPACE,
    TOK_COMMENT,
    TOK_ID,
    TOK_PREPROC_ID,
    TOK_STRING,
    TOK_NUMBER,
    TOK_FLOAT,
    TOK_SMAC_END,
    TOK_OTHER,
    TOK_INTERNAL_STRING,
    TOK_PREPROC_Q,
    TOK_PREPROC_QQ,
    TOK_PASTE,              /* %+ */
    TOK_INDIRECT,           /* %[...] */
    TOK_SMAC_PARAM,         /* MUST BE LAST IN THE LIST!!! */
    TOK_MAX = INT_MAX       /* Keep compiler from reducing the range */
};

#define PP_CONCAT_MASK(x) (1 << (x))

struct tokseq_match {
    int mask_head;
    int mask_tail;
};

struct Token {
    Token               *next;
    char                *text;
    union {
        SMacro  *mac;           /* associated macro for TOK_SMAC_END */
        size_t  len;            /* scratch length field */
    } a;                        /* Auxiliary data */
    enum pp_token_type  type;
};

/*
 * Expansion definitions are stored as a linked list of
 * these, which is essentially a container to allow several linked
 * lists of Tokens.
 *
 * Note that in this module, linked lists are treated as stacks
 * wherever possible. For this reason, Lines are _pushed_ on to the
 * `last' field in ExpDef structures, so that the linked list,
 * if walked, would emit the expansion lines in the proper order.
 */
struct Line {
    Line    *next;
    Token   *first;
};

/*
 * Expansion Types
 */
enum pp_exp_type {
    EXP_NONE = 0,
    EXP_PREDEF,
    EXP_MMACRO,
    EXP_REP,
    EXP_IF,
    EXP_WHILE,
    EXP_COMMENT,
    EXP_FINAL,
    EXP_MAX = INT_MAX       /* Keep compiler from reducing the range */
};

/*
 * Store the definition of an expansion, in which is any
 * preprocessor directive that has an ending pair.
 *
 * This design allows for arbitrary expansion/recursion depth,
 * upto the DEADMAN_LIMIT.
 *
 * The `next' field is used for storing ExpDef in hash tables; the
 * `prev' field is for the global `expansions` linked-list.
 */
struct ExpDef {
    ExpDef              *prev;          /* previous definition */
    ExpDef              *next;          /* next in hash table */
    enum pp_exp_type    type;           /* expansion type */
    char                *name;          /* definition name */
    int                 nparam_min;
    int                 nparam_max;
    bool                casesense;
    bool                plus;           /* is the last parameter greedy? */
    bool                nolist;         /* is this expansion listing-inhibited? */
    Token               *dlist;         /* all defaults as one list */
    Token               **defaults;     /* parameter default pointers */
    int                 ndefs;          /* number of default parameters */

    int                 prepend;        /* label prepend state */
    Line                *label;
    Line                *line;
    Line                *last;
    int                 linecount;      /* number of lines within expansion */

    int64_t             def_depth;      /* current number of definition pairs deep */
    int64_t             cur_depth;      /* current number of expansions */
    int64_t             max_depth;      /* maximum number of expansions allowed */

    int                 state;          /* condition state */
    bool                ignoring;       /* ignoring definition lines */
};

/*
 * Store the invocation of an expansion.
 *
 * The `prev' field is for the `istk->expansion` linked-list.
 *
 * When an expansion is being expanded, `params', `iline', `nparam',
 * `paramlen', `rotate' and `unique' are local to the invocation.
 */
struct ExpInv {
    ExpInv              *prev;          /* previous invocation */
    ExpDef              *def;           /* pointer to expansion definition */
    char                *name;          /* invocation name */
    Line                *label;         /* pointer to label */
    char                *label_text;    /* pointer to label text */
    Line                *current;       /* pointer to current line in invocation */

    Token               **params;       /* actual parameters */
    Token               *iline;         /* invocation line */
    int                 *paramlen;
    unsigned int        nparam;
    unsigned int        rotate;

    uint64_t            unique;
    int                 lineno;         /* current line number in expansion */
    int                 linnum;         /* line number at invocation */
    int                 relno;          /* relative line number at invocation */
    enum pp_exp_type    type;           /* expansion type */
    bool                emitting;
};

/*
 * To handle an arbitrary level of file inclusion, we maintain a
 * stack (ie linked list) of these things.
 */
struct Include {
    Include     *next;
    FILE        *fp;
    Cond        *conds;
    ExpInv      *expansion;
    char        *fname;
    int         lineno;
    int         lineinc;
    int         mmac_depth;
};

/*
 * Include search path. This is simply a list of strings which get
 * prepended, in turn, to the name of an include file, in an
 * attempt to find the file if it's not in the current directory.
 */
struct IncPath {
    IncPath     *next;
    char        *path;
};

/*
 * Conditional assembly: we maintain a separate stack of these for
 * each level of file inclusion. (The only reason we keep the
 * stacks separate is to ensure that a stray `%endif' in a file
 * included from within the true branch of a `%if' won't terminate
 * it and cause confusion: instead, rightly, it'll cause an error.)
 */
enum {
    /*
     * These states are for use just after %if or %elif: IF_TRUE
     * means the condition has evaluated to truth so we are
     * currently emitting, whereas IF_FALSE means we are not
     * currently emitting but will start doing so if a %else comes
     * up. In these states, all directives are admissible: %elif,
     * %else and %endif. (And of course %if.)
     */
    COND_IF_TRUE,
    COND_IF_FALSE,
    /*
     * These states come up after a %else: ELSE_TRUE means we're
     * emitting, and ELSE_FALSE means we're not. In ELSE_* states,
     * any %elif or %else will cause an error.
     */
    COND_ELSE_TRUE,
    COND_ELSE_FALSE,
    /*
     * These states mean that we're not emitting now, and also that
     * nothing until %endif will be emitted at all. COND_DONE is
     * used when we've had our moment of emission
     * and have now started seeing %elifs. COND_NEVER is used when
     * the condition construct in question is contained within a
     * non-emitting branch of a larger condition construct,
     * or if there is an error.
     */
    COND_DONE,
    COND_NEVER
};

/*
 * These defines are used as the possible return values for do_directive
 */
#define NO_DIRECTIVE_FOUND  0
#define DIRECTIVE_FOUND     1

/*
 * This define sets the upper limit for smacro and expansions
 */
#define DEADMAN_LIMIT (1 << 20)

/* max reps */
#define REP_LIMIT ((INT64_C(1) << 62))

/*
 * Condition codes. Note that we use c_ prefix not C_ because C_ is
 * used in nasm.h for the "real" condition codes. At _this_ level,
 * we treat CXZ and ECXZ as condition codes, albeit non-invertible
 * ones, so we need a different enum...
 */
static const char * const conditions[] = {
    "a", "ae", "b", "be", "c", "cxz", "e", "ecxz", "g", "ge", "l", "le",
    "na", "nae", "nb", "nbe", "nc", "ne", "ng", "nge", "nl", "nle", "no",
    "np", "ns", "nz", "o", "p", "pe", "po", "rcxz", "s", "z"
};
enum pp_conds {
    c_A, c_AE, c_B, c_BE, c_C, c_CXZ, c_E, c_ECXZ, c_G, c_GE, c_L, c_LE,
    c_NA, c_NAE, c_NB, c_NBE, c_NC, c_NE, c_NG, c_NGE, c_NL, c_NLE, c_NO,
    c_NP, c_NS, c_NZ, c_O, c_P, c_PE, c_PO, c_RCXZ, c_S, c_Z,
    c_none = -1
};
static const enum pp_conds inverse_ccs[] = {
    c_NA, c_NAE, c_NB, c_NBE, c_NC, -1, c_NE, -1, c_NG, c_NGE, c_NL, c_NLE,
    c_A, c_AE, c_B, c_BE, c_C, c_E, c_G, c_GE, c_L, c_LE, c_O, c_P, c_S,
    c_Z, c_NO, c_NP, c_PO, c_PE, -1, c_NS, c_NZ
};

/* For TASM compatibility we need to be able to recognise TASM compatible
 * conditional compilation directives. Using the NASM pre-processor does
 * not work, so we look for them specifically from the following list and
 * then jam in the equivalent NASM directive into the input stream.
 */

enum {
    TM_ARG, TM_ELIF, TM_ELSE, TM_ENDIF, TM_IF, TM_IFDEF, TM_IFDIFI,
    TM_IFNDEF, TM_INCLUDE, TM_LOCAL
};

static const char * const tasm_directives[] = {
    "arg", "elif", "else", "endif", "if", "ifdef", "ifdifi",
    "ifndef", "include", "local"
};

static int StackSize = 4;
static char *StackPointer = "ebp";
static int ArgOffset = 8;
static int LocalOffset = 0;

static Context *cstk;
static Include *istk;
static IncPath *ipath;

static int pass;            /* HACK: pass 0 = generate dependencies only */
static StrList **dephead, **deptail; /* Dependency list */

static uint64_t unique;     /* unique identifier numbers */

static Line *predef;
static bool do_predef;

static ListGen *list;

/*
 * The current set of expansion definitions we have defined.
 */
static struct hash_table expdefs;

/*
 * The current set of single-line macros we have defined.
 */
static struct hash_table smacros;

/*
 * Linked List of all active expansion definitions
 */
struct ExpDef *expansions;

/*
 * The expansion we are currently defining
 */
static ExpDef *defining;

static uint64_t nested_mac_count;
static uint64_t nested_rep_count;

/*
 * Linked-list of lines to preprocess, prior to cleanup
 */
static Line *finals;
static bool in_final = false;

/*
 * The number of macro parameters to allocate space for at a time.
 */
#define PARAM_DELTA 16

/*
 * The standard macro set: defined in macros.c in the array nasm_stdmac.
 * This gives our position in the macro set, when we're processing it.
 */
static macros_t *stdmacpos;

/*
 * The extra standard macros that come from the object format, if
 * any.
 */
static macros_t *extrastdmac;
static bool any_extrastdmac;

/*
 * Tokens are allocated in blocks to improve speed
 */
#define TOKEN_BLOCKSIZE 4096
static Token *freeTokens;
struct Blocks {
    Blocks *next;
    void *chunk;
};

static Blocks blocks;

/*
 * Forward declarations.
 */
static Token *expand_mmac_params(Token * tline);
static Token *expand_smacro(Token * tline);
static Token *expand_id(Token * tline);
static Context *get_ctx(const char *name, const char **namep);
static void make_tok_num(Token * tok, int64_t val);
static void error(int severity, const char *fmt, ...);
static void error_precond(int severity, const char *fmt, ...);
static void *new_Block(size_t size);
static void delete_Blocks(void);
static Token *new_Token(Token * next, enum pp_token_type type,
                        const char *text, int txtlen);
static Token *copy_Token(Token * tline);
static Token *delete_Token(Token * t);
static Line *new_Line(void);
static ExpDef *new_ExpDef(int exp_type);
static ExpInv *new_ExpInv(int exp_type, ExpDef *ed);

/*
 * Macros for safe checking of token pointers, avoid *(NULL)
 */
#define tok_type_(x,t)  ((x) && (x)->type == (t))
#define skip_white_(x)  if (tok_type_((x), TOK_WHITESPACE)) (x)=(x)->next
#define tok_is_(x,v)    (tok_type_((x), TOK_OTHER) && !strcmp((x)->text,(v)))
#define tok_isnt_(x,v)  ((x) && ((x)->type!=TOK_OTHER || strcmp((x)->text,(v))))

/*
 * A few helpers for single macros
 */

/* We might be not smacro parameter at all */
static bool is_smacro_param(Token *t)
{
    return t->type >= TOK_SMAC_PARAM;
}

/* smacro parameters are counted in a special way */
static int smacro_get_param_idx(Token *t)
{
    return t->type - TOK_SMAC_PARAM;
}

/* encode smacro parameter index */
static int smacro_set_param_idx(Token *t, unsigned int index)
{
    return t->type = TOK_SMAC_PARAM + index;
}

#ifdef NASM_TRACE

#define stringify(x)  #x

#define nasm_trace(msg, ...)    printf("(%s:%d): " msg "\n", __func__, __LINE__, ##__VA_ARGS__)
#define nasm_dump_token(t)      nasm_raw_dump_token(t, __FILE__, __LINE__, __func__);
#define nasm_dump_stream(t)     nasm_raw_dump_stream(t, __FILE__, __LINE__, __func__);

/* FIXME: we really need some compound type here instead of inplace code */
static const char *nasm_get_tok_type_str(enum pp_token_type type)
{
#define SWITCH_TOK_NAME(type)       \
    case (type):                    \
        return stringify(type)

    switch (type) {
    SWITCH_TOK_NAME(TOK_NONE);
    SWITCH_TOK_NAME(TOK_WHITESPACE);
    SWITCH_TOK_NAME(TOK_COMMENT);
    SWITCH_TOK_NAME(TOK_ID);
    SWITCH_TOK_NAME(TOK_PREPROC_ID);
    SWITCH_TOK_NAME(TOK_STRING);
    SWITCH_TOK_NAME(TOK_NUMBER);
    SWITCH_TOK_NAME(TOK_FLOAT);
    SWITCH_TOK_NAME(TOK_SMAC_END);
    SWITCH_TOK_NAME(TOK_OTHER);
    SWITCH_TOK_NAME(TOK_INTERNAL_STRING);
    SWITCH_TOK_NAME(TOK_PREPROC_Q);
    SWITCH_TOK_NAME(TOK_PREPROC_QQ);
    SWITCH_TOK_NAME(TOK_PASTE);
    SWITCH_TOK_NAME(TOK_INDIRECT);
    SWITCH_TOK_NAME(TOK_SMAC_PARAM);
    SWITCH_TOK_NAME(TOK_MAX);
    }

    return NULL;
}

static void nasm_raw_dump_token(Token *token, const char *file, int line, const char *func)
{
    printf("---[%s (%s:%d): %p]---\n", func, file, line, (void *)token);
    if (token) {
        Token *t;
        list_for_each(t, token) {
            if (t->text)
                printf("'%s'(%s) ", t->text,
                       nasm_get_tok_type_str(t->type));
        }
        printf("\n\n");
    }
}

static void nasm_raw_dump_stream(Token *token, const char *file, int line, const char *func)
{
    printf("---[%s (%s:%d): %p]---\n", func, file, line, (void *)token);
    if (token) {
        Token *t;
        list_for_each(t, token)
            printf("%s", t->text ? t->text : " ");
        printf("\n\n");
    }
}

#else
#define nasm_trace(msg, ...)
#define nasm_dump_token(t)
#define nasm_dump_stream(t)
#endif

/*
 * nasm_unquote with error if the string contains NUL characters.
 * If the string contains NUL characters, issue an error and return
 * the C len, i.e. truncate at the NUL.
 */
static size_t nasm_unquote_cstr(char *qstr, enum preproc_token directive)
{
    size_t len = nasm_unquote(qstr, NULL);
    size_t clen = strlen(qstr);

    if (len != clen)
        error(ERR_NONFATAL, "NUL character in `%s' directive",
              pp_directives[directive]);

    return clen;
}

/*
 * In-place reverse a list of tokens.
 */
static Token *reverse_tokens(Token *t)
{
    Token *prev, *next;

    list_reverse(t, prev, next);

    return t;
}

/*
 * Handle TASM specific directives, which do not contain a % in
 * front of them. We do it here because I could not find any other
 * place to do it for the moment, and it is a hack (ideally it would
 * be nice to be able to use the NASM pre-processor to do it).
 */
static char *check_tasm_directive(char *line)
{
    int32_t i, j, k, m, len;
    char *p, *q, *oldline, oldchar;

    p = nasm_skip_spaces(line);

    /* Binary search for the directive name */
    i = -1;
    j = ARRAY_SIZE(tasm_directives);
    q = nasm_skip_word(p);
    len = q - p;
    if (len) {
        oldchar = p[len];
        p[len] = 0;
        while (j - i > 1) {
            k = (j + i) / 2;
            m = nasm_stricmp(p, tasm_directives[k]);
            if (m == 0) {
                /* We have found a directive, so jam a % in front of it
                 * so that NASM will then recognise it as one if it's own.
                 */
                p[len] = oldchar;
                len = strlen(p);
                oldline = line;
                line = nasm_malloc(len + 2);
                line[0] = '%';
                if (k == TM_IFDIFI) {
                    /*
                     * NASM does not recognise IFDIFI, so we convert
                     * it to %if 0. This is not used in NASM
                     * compatible code, but does need to parse for the
                     * TASM macro package.
                     */
                    strcpy(line + 1, "if 0");
                } else {
                    memcpy(line + 1, p, len + 1);
                }
                nasm_free(oldline);
                return line;
            } else if (m < 0) {
                j = k;
            } else
                i = k;
        }
        p[len] = oldchar;
    }
    return line;
}

/*
 * The pre-preprocessing stage... This function translates line
 * number indications as they emerge from GNU cpp (`# lineno "file"
 * flags') into NASM preprocessor line number indications (`%line
 * lineno file').
 */
static char *prepreproc(char *line)
{
    int lineno, fnlen;
    char *fname, *oldline;

    if (line[0] == '#' && line[1] == ' ') {
        oldline = line;
        fname = oldline + 2;
        lineno = atoi(fname);
        fname += strspn(fname, "0123456789 ");
        if (*fname == '"')
            fname++;
        fnlen = strcspn(fname, "\"");
        line = nasm_malloc(20 + fnlen);
        snprintf(line, 20 + fnlen, "%%line %d %.*s", lineno, fnlen, fname);
        nasm_free(oldline);
    }
    if (tasm_compatible_mode)
        return check_tasm_directive(line);
    return line;
}

/*
 * Free a linked list of tokens.
 */
static void free_tlist(Token * list)
{
    while (list)
        list = delete_Token(list);
}

/*
 * Free a linked list of lines.
 */
static void free_llist(Line * list)
{
    Line *l, *tmp;
    list_for_each_safe(l, tmp, list) {
        free_tlist(l->first);
        nasm_free(l);
    }
}

/*
 * Free an ExpDef
 */
static void free_expdef(ExpDef * ed)
{
    nasm_free(ed->name);
    free_tlist(ed->dlist);
    nasm_free(ed->defaults);
    free_llist(ed->line);
    nasm_free(ed);
}

/*
 * Free an ExpInv
 */
static void free_expinv(ExpInv * ei)
{
    nasm_free(ei->name);
    nasm_free(ei->label_text);
    nasm_free(ei);
}

/*
 * Free all currently defined macros, and free the hash tables
 */
static void free_smacro_table(struct hash_table *smt)
{
    SMacro *s, *tmp;
    const char *key;
    struct hash_tbl_node *it = NULL;

    while ((s = hash_iterate(smt, &it, &key)) != NULL) {
        nasm_free((void *)key);
        list_for_each_safe(s, tmp, s) {
            nasm_free(s->name);
            free_tlist(s->expansion);
            nasm_free(s);
        }
    }
    hash_free(smt);
}

static void free_expdef_table(struct hash_table *edt)
{
    ExpDef *ed, *tmp;
    const char *key;
    struct hash_tbl_node *it = NULL;

    it = NULL;
    while ((ed = hash_iterate(edt, &it, &key)) != NULL) {
        nasm_free((void *)key);
        list_for_each_safe(ed ,tmp, ed)
            free_expdef(ed);
    }
    hash_free(edt);
}

static void free_macros(void)
{
    free_smacro_table(&smacros);
    free_expdef_table(&expdefs);
}

/*
 * Initialize the hash tables
 */
static void init_macros(void)
{
    hash_init(&smacros, HASH_LARGE);
    hash_init(&expdefs, HASH_LARGE);
}

/*
 * Pop the context stack.
 */
static void ctx_pop(void)
{
    Context *c = cstk;

    cstk = cstk->next;
    free_smacro_table(&c->localmac);
    nasm_free(c->name);
    nasm_free(c);
}

/*
 * Search for a key in the hash index; adding it if necessary
 * (in which case we initialize the data pointer to NULL.)
 */
static void **
hash_findi_add(struct hash_table *hash, const char *str)
{
    struct hash_insert hi;
    void **r;
    char *strx;

    r = hash_findi(hash, str, &hi);
    if (r)
        return r;

    strx = nasm_strdup(str);    /* Use a more efficient allocator here? */
    return hash_add(&hi, strx, NULL);
}

/*
 * Like hash_findi, but returns the data element rather than a pointer
 * to it.  Used only when not adding a new element, hence no third
 * argument.
 */
static void *
hash_findix(struct hash_table *hash, const char *str)
{
    void **p;

    p = hash_findi(hash, str, NULL);
    return p ? *p : NULL;
}

/*
 * read line from standard macros set,
 * if there no more left -- return NULL
 */
static char *line_from_stdmac(void)
{
    unsigned char c;
    const unsigned char *p = stdmacpos;
    char *line, *q;
    size_t len = 0;

    if (!stdmacpos)
        return NULL;

    while ((c = *p++)) {
        if (c >= 0x80)
            len += pp_directives_len[c - 0x80] + 1;
        else
            len++;
    }

    line = nasm_malloc(len + 1);
    q = line;
    while ((c = *stdmacpos++)) {
        if (c >= 0x80) {
            memcpy(q, pp_directives[c - 0x80], pp_directives_len[c - 0x80]);
            q += pp_directives_len[c - 0x80];
            *q++ = ' ';
        } else {
            *q++ = c;
        }
    }
    stdmacpos = p;
    *q = '\0';

    if (!*stdmacpos) {
        /* This was the last of the standard macro chain... */
        stdmacpos = NULL;
        if (any_extrastdmac) {
            stdmacpos = extrastdmac;
            any_extrastdmac = false;
        } else if (do_predef) {
            ExpInv *ei;
            Line *pd, *l;
            Token *head, **tail, *t;

            /*
             * Nasty hack: here we push the contents of
             * `predef' on to the top-level expansion stack,
             * since this is the most convenient way to
             * implement the pre-include and pre-define
             * features.
             */
            list_for_each(pd, predef) {
                head = NULL;
                tail = &head;
                list_for_each(t, pd->first) {
                    *tail = new_Token(NULL, t->type, t->text, 0);
                    tail = &(*tail)->next;
                }

                l = new_Line();
                l->first = head;
                ei = new_ExpInv(EXP_PREDEF, NULL);
                ei->current = l;
                ei->emitting = true;
                ei->prev = istk->expansion;
                istk->expansion = ei;
            }
            do_predef = false;
        }
    }

    return line;
}

#define BUF_DELTA 512
/*
 * Read a line from the top file in istk, handling multiple CR/LFs
 * at the end of the line read, and handling spurious ^Zs. Will
 * return lines from the standard macro set if this has not already
 * been done.
 */
static char *read_line(void)
{
    char *buffer, *p, *q;
    int bufsize, continued_count;

    /*
     * standart macros set (predefined) goes first
     */
    p = line_from_stdmac();
    if (p)
        return p;

    /*
     * regular read from a file
     */
    bufsize = BUF_DELTA;
    buffer = nasm_malloc(BUF_DELTA);
    p = buffer;
    continued_count = 0;
    while (1) {
        q = fgets(p, bufsize - (p - buffer), istk->fp);
        if (!q)
            break;
        p += strlen(p);
        if (p > buffer && p[-1] == '\n') {
            /*
             * Convert backslash-CRLF line continuation sequences into
             * nothing at all (for DOS and Windows)
             */
            if (((p - 2) > buffer) && (p[-3] == '\\') && (p[-2] == '\r')) {
                p -= 3;
                *p = 0;
                continued_count++;
            }
            /*
             * Also convert backslash-LF line continuation sequences into
             * nothing at all (for Unix)
             */
            else if (((p - 1) > buffer) && (p[-2] == '\\')) {
                p -= 2;
                *p = 0;
                continued_count++;
            } else {
                break;
            }
        }
        if (p - buffer > bufsize - 10) {
            int32_t offset = p - buffer;
            bufsize += BUF_DELTA;
            buffer = nasm_realloc(buffer, bufsize);
            p = buffer + offset;        /* prevent stale-pointer problems */
        }
    }

    if (!q && p == buffer) {
        nasm_free(buffer);
        return NULL;
    }

    src_set_linnum(src_get_linnum() + istk->lineinc +
                   (continued_count * istk->lineinc));

    /*
     * Play safe: remove CRs as well as LFs, if any of either are
     * present at the end of the line.
     */
    while (--p >= buffer && (*p == '\n' || *p == '\r'))
        *p = '\0';

    /*
     * Handle spurious ^Z, which may be inserted into source files
     * by some file transfer utilities.
     */
    buffer[strcspn(buffer, "\032")] = '\0';

    list->line(LIST_READ, buffer);

    return buffer;
}

/*
 * Tokenize a line of text. This is a very simple process since we
 * don't need to parse the value out of e.g. numeric tokens: we
 * simply split one string into many.
 */
static Token *tokenize(char *line)
{
    char c, *p = line;
    enum pp_token_type type;
    Token *list = NULL;
    Token *t, **tail = &list;
    bool verbose = true;

    nasm_trace("Tokenize for '%s'", line);

    if ((defining != NULL) && (defining->ignoring == true)) {
        verbose = false;
    }

    while (*line) {
        p = line;
        if (*p == '%') {
            p++;
            if (*p == '+' && !nasm_isdigit(p[1])) {
                p++;
                type = TOK_PASTE;
            } else if (nasm_isdigit(*p) ||
                       ((*p == '-' || *p == '+') && nasm_isdigit(p[1]))) {
                do {
                    p++;
                }
                while (nasm_isdigit(*p));
                type = TOK_PREPROC_ID;
            } else if (*p == '{') {
                p++;
                while (*p && *p != '}') {
                    p[-1] = *p;
                    p++;
                }
                p[-1] = '\0';
                if (*p)
                    p++;
                type = TOK_PREPROC_ID;
            } else if (*p == '[') {
                int lvl = 1;
                line += 2;      /* Skip the leading %[ */
                p++;
                while (lvl && (c = *p++)) {
                    switch (c) {
                    case ']':
                        lvl--;
                        break;
                    case '%':
                        if (*p == '[')
                            lvl++;
                        break;
                    case '\'':
                    case '\"':
                    case '`':
                        p = nasm_skip_string(p - 1) + 1;
                        break;
                    default:
                        break;
                    }
                }
                p--;
                if (*p)
                    *p++ = '\0';
                if (lvl && verbose)
                    error(ERR_NONFATAL, "unterminated %[ construct");
                type = TOK_INDIRECT;
            } else if (*p == '?') {
                type = TOK_PREPROC_Q; /* %? */
                p++;
                if (*p == '?') {
                    type = TOK_PREPROC_QQ; /* %?? */
                    p++;
                }
            } else if (*p == '!') {
                type = TOK_PREPROC_ID;
                p++;
                if (isidchar(*p)) {
                    do {
                        p++;
                    } while (isidchar(*p));
                } else if (*p == '\'' || *p == '\"' || *p == '`') {
                    p = nasm_skip_string(p);
                    if (*p)
                        p++;
                    else if(verbose)
                        error(ERR_NONFATAL|ERR_PASS1, "unterminated %! string");
                } else {
                    /* %! without string or identifier */
                    type = TOK_OTHER; /* Legacy behavior... */
                }
            } else if (isidchar(*p) ||
                       ((*p == '!' || *p == '%' || *p == '$') &&
                        isidchar(p[1]))) {
                do {
                    p++;
                }
                while (isidchar(*p));
                type = TOK_PREPROC_ID;
            } else {
                type = TOK_OTHER;
                if (*p == '%')
                    p++;
            }
        } else if (isidstart(*p) || (*p == '$' && isidstart(p[1]))) {
            type = TOK_ID;
            p++;
            while (*p && isidchar(*p))
                p++;
        } else if (*p == '\'' || *p == '"' || *p == '`') {
            /*
             * A string token.
             */
            type = TOK_STRING;
            p = nasm_skip_string(p);

            if (*p) {
                p++;
            } else if(verbose) {
                error(ERR_WARNING|ERR_PASS1, "unterminated string");
                /* Handling unterminated strings by UNV */
                /* type = -1; */
            }
        } else if (p[0] == '$' && p[1] == '$') {
            type = TOK_OTHER;   /* TOKEN_BASE */
            p += 2;
        } else if (isnumstart(*p)) {
            bool is_hex = false;
            bool is_float = false;
            bool has_e = false;
            char c, *r;

            /*
             * A numeric token.
             */

            if (*p == '$') {
                p++;
                is_hex = true;
            }

            for (;;) {
                c = *p++;

                if (!is_hex && (c == 'e' || c == 'E')) {
                    has_e = true;
                    if (*p == '+' || *p == '-') {
                        /*
                         * e can only be followed by +/- if it is either a
                         * prefixed hex number or a floating-point number
                         */
                        p++;
                        is_float = true;
                    }
                } else if (c == 'H' || c == 'h' || c == 'X' || c == 'x') {
                    is_hex = true;
                } else if (c == 'P' || c == 'p') {
                    is_float = true;
                    if (*p == '+' || *p == '-')
                        p++;
                } else if (isnumchar(c) || c == '_')
                    ; /* just advance */
                else if (c == '.') {
                    /*
                     * we need to deal with consequences of the legacy
                     * parser, like "1.nolist" being two tokens
                     * (TOK_NUMBER, TOK_ID) here; at least give it
                     * a shot for now.  In the future, we probably need
                     * a flex-based scanner with proper pattern matching
                     * to do it as well as it can be done.  Nothing in
                     * the world is going to help the person who wants
                     * 0x123.p16 interpreted as two tokens, though.
                     */
                    r = p;
                    while (*r == '_')
                        r++;

                    if (nasm_isdigit(*r) || (is_hex && nasm_isxdigit(*r)) ||
                        (!is_hex && (*r == 'e' || *r == 'E')) ||
                        (*r == 'p' || *r == 'P')) {
                        p = r;
                        is_float = true;
                    } else
                        break;  /* Terminate the token */
                } else
                    break;
            }
            p--;        /* Point to first character beyond number */

            if (p == line+1 && *line == '$') {
                type = TOK_OTHER; /* TOKEN_HERE */
            } else {
                if (has_e && !is_hex) {
                    /* 1e13 is floating-point, but 1e13h is not */
                    is_float = true;
                }

                type = is_float ? TOK_FLOAT : TOK_NUMBER;
            }
        } else if (nasm_isspace(*p)) {
            type = TOK_WHITESPACE;
            p = nasm_skip_spaces(p);
            /*
             * Whitespace just before end-of-line is discarded by
             * pretending it's a comment; whitespace just before a
             * comment gets lumped into the comment.
             */
            if (!*p || *p == ';') {
                type = TOK_COMMENT;
                while (*p)
                    p++;
            }
        } else if (*p == ';') {
            type = TOK_COMMENT;
            while (*p)
                p++;
        } else {
            /*
             * Anything else is an operator of some kind. We check
             * for all the double-character operators (>>, <<, //,
             * %%, <=, >=, ==, !=, <>, &&, ||, ^^), but anything
             * else is a single-character operator.
             */
            type = TOK_OTHER;
            if ((p[0] == '>' && p[1] == '>') ||
                (p[0] == '<' && p[1] == '<') ||
                (p[0] == '/' && p[1] == '/') ||
                (p[0] == '<' && p[1] == '=') ||
                (p[0] == '>' && p[1] == '=') ||
                (p[0] == '=' && p[1] == '=') ||
                (p[0] == '!' && p[1] == '=') ||
                (p[0] == '<' && p[1] == '>') ||
                (p[0] == '&' && p[1] == '&') ||
                (p[0] == '|' && p[1] == '|') ||
                (p[0] == '^' && p[1] == '^')) {
                p++;
            }
            p++;
        }

        /* Handling unterminated string by UNV */
        /*if (type == -1)
          {
          *tail = t = new_Token(NULL, TOK_STRING, line, p-line+1);
          t->text[p-line] = *line;
          tail = &t->next;
          }
          else */
        if (type != TOK_COMMENT) {
            *tail = t = new_Token(NULL, type, line, p - line);
            tail = &t->next;
        }
        line = p;
    }

    nasm_dump_token(list);

    return list;
}

/*
 * this function allocates a new managed block of memory and
 * returns a pointer to the block.  The managed blocks are
 * deleted only all at once by the delete_Blocks function.
 */
static void *new_Block(size_t size)
{
    Blocks *b = &blocks;

    /* first, get to the end of the linked list */
    while (b->next)
        b = b->next;

    /* now allocate the requested chunk */
    b->chunk = nasm_malloc(size);

    /* now allocate a new block for the next request */
    b->next = nasm_zalloc(sizeof(Blocks));

    return b->chunk;
}

/*
 * this function deletes all managed blocks of memory
 */
static void delete_Blocks(void)
{
    Blocks *a, *b = &blocks;

    /*
     * keep in mind that the first block, pointed to by blocks
     * is a static and not dynamically allocated, so we don't
     * free it.
     */
    while (b) {
        nasm_free(b->chunk);
        a = b;
        b = b->next;
        if (a != &blocks)
            nasm_free(a);
    }
}

/*
 *  this function creates a new Token and passes a pointer to it
 *  back to the caller.  It sets the type and text elements, and
 *  also the a.mac and next elements to NULL.
 */
static Token *new_Token(Token * next, enum pp_token_type type,
                        const char *text, int txtlen)
{
    Token *t;
    int i;

    if (!freeTokens) {
        freeTokens = (Token *) new_Block(TOKEN_BLOCKSIZE * sizeof(Token));
        for (i = 0; i < TOKEN_BLOCKSIZE - 1; i++)
            freeTokens[i].next = &freeTokens[i + 1];
        freeTokens[i].next = NULL;
    }
    t = freeTokens;
    freeTokens = t->next;
    t->next = next;
    t->a.mac = NULL;
    t->type = type;
    if (type == TOK_WHITESPACE || !text) {
        t->text = NULL;
    } else {
        if (txtlen == 0)
            txtlen = strlen(text);
        t->text = nasm_malloc(txtlen+1);
        memcpy(t->text, text, txtlen);
        t->text[txtlen] = '\0';
    }
    return t;
}

static Token *copy_Token(Token * tline)
{
    Token *t, *tt, *first = NULL, *prev = NULL;
    int i;
    for (tt = tline; tt != NULL; tt = tt->next) {
        if (!freeTokens) {
            freeTokens = (Token *) new_Block(TOKEN_BLOCKSIZE * sizeof(Token));
            for (i = 0; i < TOKEN_BLOCKSIZE - 1; i++)
                freeTokens[i].next = &freeTokens[i + 1];
            freeTokens[i].next = NULL;
        }
        t = freeTokens;
        freeTokens = t->next;
        t->next = NULL;
        t->text = tt->text ? nasm_strdup(tt->text) : NULL;
        t->a.mac = tt->a.mac;
        t->a.len = tt->a.len;
        t->type = tt->type;
        if (prev != NULL) {
            prev->next = t;
        } else {
            first = t;
        }
        prev = t;
    }
    return first;
}

static Token *delete_Token(Token * t)
{
    Token *next = t->next;
    nasm_free(t->text);
    t->next = freeTokens;
    freeTokens = t;
    return next;
}

/*
 * Convert a line of tokens back into text.
 * If expand_locals is not zero, identifiers of the form "%$*xxx"
 * will be transformed into ..@ctxnum.xxx
 */
static char *detoken(Token * tlist, bool expand_locals)
{
    Token *t;
    char *line, *p;
    const char *q;
    int len = 0;

    list_for_each(t, tlist) {
        if (t->type == TOK_PREPROC_ID && t->text[1] == '!') {
            char *v;
            char *q = t->text;

            v = t->text + 2;
            if (*v == '\'' || *v == '\"' || *v == '`') {
                size_t len = nasm_unquote(v, NULL);
                size_t clen = strlen(v);

                if (len != clen) {
                    error(ERR_NONFATAL | ERR_PASS1,
                          "NUL character in %! string");
                    v = NULL;
                }
            }

            if (v) {
                char *p = getenv(v);
                if (!p) {
                    error(ERR_NONFATAL | ERR_PASS1,
                          "nonexistent environment variable `%s'", v);
                    p = "";
                }
                t->text = nasm_strdup(p);
            }
            nasm_free(q);
        }

        /* Expand local macros here and not during preprocessing */
        if (expand_locals &&
            t->type == TOK_PREPROC_ID && t->text &&
            t->text[0] == '%' && t->text[1] == '$') {
            const char *q;
            char *p;
            Context *ctx = get_ctx(t->text, &q);
            if (ctx) {
                char buffer[40];
                snprintf(buffer, sizeof(buffer), "..@%"PRIu32".", ctx->number);
                p = nasm_strcat(buffer, q);
                nasm_free(t->text);
                t->text = p;
            }
        }

        /* Expand %? and %?? directives */
        if ((istk->expansion != NULL) &&
            ((t->type == TOK_PREPROC_Q) ||
             (t->type == TOK_PREPROC_QQ))) {
            ExpInv *ei;
            for (ei = istk->expansion; ei != NULL; ei = ei->prev){
                if (ei->type == EXP_MMACRO) {
                    nasm_free(t->text);
                    if (t->type == TOK_PREPROC_Q) {
                        t->text = nasm_strdup(ei->name);
                    } else {
                        t->text = nasm_strdup(ei->def->name);
                    }
                    break;
                }
            }
        }

        if (t->type == TOK_WHITESPACE)
            len++;
        else if (t->text)
            len += strlen(t->text);
    }

    p = line = nasm_malloc(len + 1);

    list_for_each(t, tlist) {
        if (t->type == TOK_WHITESPACE) {
            *p++ = ' ';
        } else if (t->text) {
            q = t->text;
            while (*q)
                *p++ = *q++;
        }
    }
    *p = '\0';

    return line;
}

/*
 * Initialize a new Line
 */
static inline Line *new_Line(void)
{
    return (Line *)nasm_zalloc(sizeof(Line));
}


/*
 * Initialize a new Expansion Definition
 */
static ExpDef *new_ExpDef(int exp_type)
{
    ExpDef *ed      = (ExpDef*)nasm_zalloc(sizeof(ExpDef));
    ed->type        = exp_type;
    ed->casesense   = true;
    ed->state       = COND_NEVER;

    return ed;
}


/*
 * Initialize a new Expansion Instance
 */
static ExpInv *new_ExpInv(int exp_type, ExpDef *ed)
{
    ExpInv *ei  = (ExpInv*)nasm_zalloc(sizeof(ExpInv));
    ei->type    = exp_type;
    ei->def     = ed;
    ei->unique  = ++unique;

    if ((istk->mmac_depth < 1) &&
        (istk->expansion == NULL) &&
        (ed != NULL) &&
        (ed->type != EXP_MMACRO) &&
        (ed->type != EXP_REP) &&
        (ed->type != EXP_WHILE)) {
        ei->linnum = src_get_linnum();
        src_set_linnum(ei->linnum - ed->linecount - 1);
    } else {
        ei->linnum = -1;
    }
    if ((istk->expansion == NULL) ||
        (ei->type == EXP_MMACRO)) {
        ei->relno = 0;
    } else {
        ei->relno = istk->expansion->lineno;
        if (ed != NULL) {
            ei->relno -= (ed->linecount + 1);
        }
    }
    return ei;
}

/*
 * A scanner, suitable for use by the expression evaluator, which
 * operates on a line of Tokens. Expects a pointer to a pointer to
 * the first token in the line to be passed in as its private_data
 * field.
 *
 * FIX: This really needs to be unified with stdscan.
 */
static int ppscan(void *private_data, struct tokenval *tokval)
{
    Token **tlineptr = private_data;
    Token *tline;
    char ourcopy[MAX_KEYWORD+1], *p, *r, *s;

    do {
        tline = *tlineptr;
        *tlineptr = tline ? tline->next : NULL;
    } while (tline && (tline->type == TOK_WHITESPACE ||
                       tline->type == TOK_COMMENT));

    if (!tline)
        return tokval->t_type = TOKEN_EOS;

    tokval->t_charptr = tline->text;

    if (tline->text[0] == '$' && !tline->text[1])
        return tokval->t_type = TOKEN_HERE;
    if (tline->text[0] == '$' && tline->text[1] == '$' && !tline->text[2])
        return tokval->t_type = TOKEN_BASE;

    if (tline->type == TOK_ID) {
        p = tokval->t_charptr = tline->text;
        if (p[0] == '$') {
            tokval->t_charptr++;
            return tokval->t_type = TOKEN_ID;
        }

        for (r = p, s = ourcopy; *r; r++) {
            if (r >= p+MAX_KEYWORD)
                return tokval->t_type = TOKEN_ID; /* Not a keyword */
            *s++ = nasm_tolower(*r);
        }
        *s = '\0';
        /* right, so we have an identifier sitting in temp storage. now,
         * is it actually a register or instruction name, or what? */
        return nasm_token_hash(ourcopy, tokval);
    }

    if (tline->type == TOK_NUMBER) {
        bool rn_error;
        tokval->t_integer = readnum(tline->text, &rn_error);
        tokval->t_charptr = tline->text;
        if (rn_error)
            return tokval->t_type = TOKEN_ERRNUM;
        else
            return tokval->t_type = TOKEN_NUM;
    }

    if (tline->type == TOK_FLOAT) {
        return tokval->t_type = TOKEN_FLOAT;
    }

    if (tline->type == TOK_STRING) {
        char bq, *ep;

        bq = tline->text[0];
        tokval->t_charptr = tline->text;
        tokval->t_inttwo = nasm_unquote(tline->text, &ep);

        if (ep[0] != bq || ep[1] != '\0')
            return tokval->t_type = TOKEN_ERRSTR;
        else
            return tokval->t_type = TOKEN_STR;
    }

    if (tline->type == TOK_OTHER) {
        if (!strcmp(tline->text, "<<"))
            return tokval->t_type = TOKEN_SHL;
        if (!strcmp(tline->text, ">>"))
            return tokval->t_type = TOKEN_SHR;
        if (!strcmp(tline->text, "//"))
            return tokval->t_type = TOKEN_SDIV;
        if (!strcmp(tline->text, "%%"))
            return tokval->t_type = TOKEN_SMOD;
        if (!strcmp(tline->text, "=="))
            return tokval->t_type = TOKEN_EQ;
        if (!strcmp(tline->text, "<>"))
            return tokval->t_type = TOKEN_NE;
        if (!strcmp(tline->text, "!="))
            return tokval->t_type = TOKEN_NE;
        if (!strcmp(tline->text, "<="))
            return tokval->t_type = TOKEN_LE;
        if (!strcmp(tline->text, ">="))
            return tokval->t_type = TOKEN_GE;
        if (!strcmp(tline->text, "&&"))
            return tokval->t_type = TOKEN_DBL_AND;
        if (!strcmp(tline->text, "^^"))
            return tokval->t_type = TOKEN_DBL_XOR;
        if (!strcmp(tline->text, "||"))
            return tokval->t_type = TOKEN_DBL_OR;
    }

    /*
     * We have no other options: just return the first character of
     * the token text.
     */
    return tokval->t_type = tline->text[0];
}

/*
 * Compare a string to the name of an existing macro; this is a
 * simple wrapper which calls either strcmp or nasm_stricmp
 * depending on the value of the `casesense' parameter.
 */
static int mstrcmp(const char *p, const char *q, bool casesense)
{
    return casesense ? strcmp(p, q) : nasm_stricmp(p, q);
}

/*
 * Compare a string to the name of an existing macro; this is a
 * simple wrapper which calls either strcmp or nasm_stricmp
 * depending on the value of the `casesense' parameter.
 */
static int mmemcmp(const char *p, const char *q, size_t l, bool casesense)
{
    return casesense ? memcmp(p, q, l) : nasm_memicmp(p, q, l);
}

/*
 * Return the Context structure associated with a %$ token. Return
 * NULL, having _already_ reported an error condition, if the
 * context stack isn't deep enough for the supplied number of $
 * signs.
 *
 * If "namep" is non-NULL, set it to the pointer to the macro name
 * tail, i.e. the part beyond %$...
 */
static Context *get_ctx(const char *name, const char **namep)
{
    Context *ctx;
    int i;

    if (namep)
        *namep = name;

    if (!name || name[0] != '%' || name[1] != '$')
        return NULL;

    if (!cstk) {
        error(ERR_NONFATAL, "`%s': context stack is empty", name);
        return NULL;
    }

    name += 2;
    ctx = cstk;
    i = 0;
    while (ctx && *name == '$') {
        name++;
        i++;
        ctx = ctx->next;
    }

    if (!ctx) {
        error(ERR_NONFATAL, "`%s': context stack is only"
              " %d level%s deep", name, i, (i == 1 ? "" : "s"));
        return NULL;
    }

    if (namep)
        *namep = name;

    return ctx;
}

/*
 * Check to see if a file is already in a string list
 */
static bool in_list(const StrList *list, const char *str)
{
    while (list) {
        if (!strcmp(list->str, str))
            return true;
        list = list->next;
    }
    return false;
}

/*
 * Open an include file. This routine must always return a valid
 * file pointer if it returns - it's responsible for throwing an
 * ERR_FATAL and bombing out completely if not. It should also try
 * the include path one by one until it finds the file or reaches
 * the end of the path.
 */
static FILE *inc_fopen(const char *file, StrList **dhead, StrList ***dtail,
                       bool missing_ok)
{
    FILE *fp;
    char *prefix = "";
    IncPath *ip = ipath;
    int len = strlen(file);
    size_t prefix_len = 0;
    StrList *sl;

    while (1) {
        sl = nasm_malloc(prefix_len+len+1+sizeof sl->next);
        sl->next = NULL;
        memcpy(sl->str, prefix, prefix_len);
        memcpy(sl->str+prefix_len, file, len+1);
        fp = fopen(sl->str, "r");
        if (fp && dhead && !in_list(*dhead, sl->str)) {
            **dtail = sl;
            *dtail = &sl->next;
        } else {
            nasm_free(sl);
        }
        if (fp)
            return fp;
        if (!ip) {
            if (!missing_ok)
                break;
            prefix = NULL;
        } else {
            prefix = ip->path;
            ip = ip->next;
        }
        if (prefix) {
            prefix_len = strlen(prefix);
        } else {
            /* -MG given and file not found */
            if (dhead && !in_list(*dhead, file)) {
                sl = nasm_malloc(len+1+sizeof sl->next);
                sl->next = NULL;
                strcpy(sl->str, file);
                **dtail = sl;
                *dtail = &sl->next;
            }
            return NULL;
        }
    }

    error(ERR_FATAL, "unable to open include file `%s'", file);
    return NULL;
}

/*
 * Determine if we should warn on defining a single-line macro of
 * name `name', with `nparam' parameters. If nparam is 0 or -1, will
 * return true if _any_ single-line macro of that name is defined.
 * Otherwise, will return true if a single-line macro with either
 * `nparam' or no parameters is defined.
 *
 * If a macro with precisely the right number of parameters is
 * defined, or nparam is -1, the address of the definition structure
 * will be returned in `defn'; otherwise NULL will be returned. If `defn'
 * is NULL, no action will be taken regarding its contents, and no
 * error will occur.
 *
 * Note that this is also called with nparam zero to resolve
 * `ifdef'.
 *
 * If you already know which context macro belongs to, you can pass
 * the context pointer as first parameter; if you won't but name begins
 * with %$ the context will be automatically computed. If all_contexts
 * is true, macro will be searched in outer contexts as well.
 */
static bool
smacro_defined(Context * ctx, const char *name, int nparam, SMacro ** defn,
               bool nocase)
{
    struct hash_table *smtbl;
    SMacro *m;

    if (ctx) {
        smtbl = &ctx->localmac;
    } else if (name[0] == '%' && name[1] == '$') {
        if (cstk)
            ctx = get_ctx(name, &name);
        if (!ctx)
            return false;       /* got to return _something_ */
        smtbl = &ctx->localmac;
    } else {
        smtbl = &smacros;
    }
    m = (SMacro *) hash_findix(smtbl, name);

    while (m) {
        if (!mstrcmp(m->name, name, m->casesense && nocase) &&
            (nparam <= 0 || m->nparam == 0 || nparam == (int) m->nparam)) {
            if (defn) {
                if (nparam == (int) m->nparam || nparam == -1)
                    *defn = m;
                else
                    *defn = NULL;
            }
            return true;
        }
        m = m->next;
    }

    return false;
}

/*
 * Count and mark off the parameters in a multi-line macro call.
 * This is called both from within the multi-line macro expansion
 * code, and also to mark off the default parameters when provided
 * in a %macro definition line.
 */
static void count_mmac_params(Token * t, int *nparam, Token *** params)
{
    int paramsize, brace;

    *nparam = paramsize = 0;
    *params = NULL;
    while (t) {
        /* +1: we need space for the final NULL */
        if (*nparam+1 >= paramsize) {
            paramsize += PARAM_DELTA;
            *params = nasm_realloc(*params, sizeof(**params) * paramsize);
        }
        skip_white_(t);
        brace = false;
        if (tok_is_(t, "{"))
            brace = true;
        (*params)[(*nparam)++] = t;
        while (tok_isnt_(t, brace ? "}" : ","))
            t = t->next;
        if (t) {                /* got a comma/brace */
            t = t->next;
            if (brace) {
                /*
                 * Now we've found the closing brace, look further
                 * for the comma.
                 */
                skip_white_(t);
                if (tok_isnt_(t, ",")) {
                    error(ERR_NONFATAL,
                          "braces do not enclose all of macro parameter");
                    while (tok_isnt_(t, ","))
                        t = t->next;
                }
                if (t)
                    t = t->next;        /* eat the comma */
            }
        }
    }
}

/*
 * Determine whether one of the various `if' conditions is true or
 * not.
 *
 * We must free the tline we get passed.
 */
static bool if_condition(Token * tline, enum preproc_token ct)
{
    enum pp_conditional i = PP_COND(ct);
    bool j;
    Token *t, *tt, **tptr, *origline;
    struct tokenval tokval;
    expr *evalresult;
    enum pp_token_type needtype;
    char *p;

    origline = tline;

    switch (i) {
    case PPC_IFCTX:
        j = false;              /* have we matched yet? */
        while (true) {
            skip_white_(tline);
            if (!tline)
                break;
            if (tline->type != TOK_ID) {
                error(ERR_NONFATAL,
                      "`%s' expects context identifiers", pp_directives[ct]);
                free_tlist(origline);
                return -1;
            }
            if (cstk && cstk->name && !nasm_stricmp(tline->text, cstk->name))
                j = true;
            tline = tline->next;
        }
        break;

    case PPC_IFDEF:
        j = false;              /* have we matched yet? */
        skip_white_(tline);
        do {
            if (!tline || (tline->type != TOK_ID &&
                           (tline->type != TOK_PREPROC_ID ||
                            tline->text[1] != '$'))) {
                error(ERR_NONFATAL,
                      "`%s' expects macro identifiers", pp_directives[ct]);
                goto fail;
            }
            if (smacro_defined(NULL, tline->text, 0, NULL, true))
                j = true;
            tline = tline->next;
            skip_white_(tline);
        } while (tline);
        break;

    case PPC_IFENV:
        tline = expand_smacro(tline);
        j = false;              /* have we matched yet? */
        skip_white_(tline);
        do {
            if (!tline || (tline->type != TOK_ID &&
                           tline->type != TOK_STRING &&
                           (tline->type != TOK_PREPROC_ID ||
                            tline->text[1] != '!'))) {
                error(ERR_NONFATAL,
                      "`%s' expects environment variable names",
                      pp_directives[ct]);
                goto fail;
            }
            p = tline->text;
            if (tline->type == TOK_PREPROC_ID)
                p += 2;         /* Skip leading %! */
            if (*p == '\'' || *p == '\"' || *p == '`')
                nasm_unquote_cstr(p, ct);
            if (getenv(p))
                j = true;
            tline = tline->next;
            skip_white_(tline);
        } while (tline);
        break;

    case PPC_IFIDN:
    case PPC_IFIDNI:
        tline = expand_smacro(tline);
        t = tt = tline;
        while (tok_isnt_(tt, ","))
            tt = tt->next;
        if (!tt) {
            error(ERR_NONFATAL,
                  "`%s' expects two comma-separated arguments",
                  pp_directives[ct]);
            goto fail;
        }
        tt = tt->next;
        j = true;               /* assume equality unless proved not */
        while ((t->type != TOK_OTHER || strcmp(t->text, ",")) && tt) {
            if (tt->type == TOK_OTHER && !strcmp(tt->text, ",")) {
                error(ERR_NONFATAL, "`%s': more than one comma on line",
                      pp_directives[ct]);
                goto fail;
            }
            if (t->type == TOK_WHITESPACE) {
                t = t->next;
                continue;
            }
            if (tt->type == TOK_WHITESPACE) {
                tt = tt->next;
                continue;
            }
            if (tt->type != t->type) {
                j = false;      /* found mismatching tokens */
                break;
            }
            /* When comparing strings, need to unquote them first */
            if (t->type == TOK_STRING) {
                size_t l1 = nasm_unquote(t->text, NULL);
                size_t l2 = nasm_unquote(tt->text, NULL);

                if (l1 != l2) {
                    j = false;
                    break;
                }
                if (mmemcmp(t->text, tt->text, l1, i == PPC_IFIDN)) {
                    j = false;
                    break;
                }
            } else if (mstrcmp(tt->text, t->text, i == PPC_IFIDN) != 0) {
                j = false;      /* found mismatching tokens */
                break;
            }

            t = t->next;
            tt = tt->next;
        }
        if ((t->type != TOK_OTHER || strcmp(t->text, ",")) || tt)
            j = false;          /* trailing gunk on one end or other */
        break;

    case PPC_IFMACRO:
    {
        bool found = false;
        ExpDef searching, *ed;

        skip_white_(tline);
        tline = expand_id(tline);
        if (!tok_type_(tline, TOK_ID)) {
            error(ERR_NONFATAL,
                  "`%s' expects a macro name", pp_directives[ct]);
            goto fail;
        }
        memset(&searching, 0, sizeof(searching));
        searching.name = nasm_strdup(tline->text);
        searching.casesense = true;
        searching.nparam_max = INT_MAX;
        tline = expand_smacro(tline->next);
        skip_white_(tline);
        if (!tline) {
        } else if (!tok_type_(tline, TOK_NUMBER)) {
            error(ERR_NONFATAL,
                  "`%s' expects a parameter count or nothing",
                  pp_directives[ct]);
        } else {
            searching.nparam_min = searching.nparam_max =
                readnum(tline->text, &j);
            if (j)
                error(ERR_NONFATAL,
                      "unable to parse parameter count `%s'",
                      tline->text);
        }
        if (tline && tok_is_(tline->next, "-")) {
            tline = tline->next->next;
            if (tok_is_(tline, "*"))
                searching.nparam_max = INT_MAX;
            else if (!tok_type_(tline, TOK_NUMBER))
                error(ERR_NONFATAL,
                      "`%s' expects a parameter count after `-'",
                      pp_directives[ct]);
            else {
                searching.nparam_max = readnum(tline->text, &j);
                if (j)
                    error(ERR_NONFATAL,
                          "unable to parse parameter count `%s'",
                          tline->text);
                if (searching.nparam_min > searching.nparam_max)
                    error(ERR_NONFATAL,
                          "minimum parameter count exceeds maximum");
            }
        }
        if (tline && tok_is_(tline->next, "+")) {
            tline = tline->next;
            searching.plus = true;
        }
        ed = (ExpDef *) hash_findix(&expdefs, searching.name);
        while (ed != NULL) {
            if (!strcmp(ed->name, searching.name)                           &&
                (ed->nparam_min <= searching.nparam_max || searching.plus)  &&
                (searching.nparam_min <= ed->nparam_max || ed->plus)) {
                found = true;
                break;
            }
            ed = ed->next;
        }
        if (tline && tline->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after %%ifmacro ignored");
        nasm_free(searching.name);
        j = found;
        break;
    }

    case PPC_IFID:
        needtype = TOK_ID;
        goto iftype;
    case PPC_IFNUM:
        needtype = TOK_NUMBER;
        goto iftype;
    case PPC_IFSTR:
        needtype = TOK_STRING;
        goto iftype;

iftype:
        t = tline = expand_smacro(tline);

        while (tok_type_(t, TOK_WHITESPACE) ||
               (needtype == TOK_NUMBER &&
                tok_type_(t, TOK_OTHER) &&
                (t->text[0] == '-' || t->text[0] == '+') &&
                !t->text[1]))
            t = t->next;

        j = tok_type_(t, needtype);
        break;

    case PPC_IFTOKEN:
        t = tline = expand_smacro(tline);
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        j = false;
        if (t) {
            t = t->next;        /* Skip the actual token */
            while (tok_type_(t, TOK_WHITESPACE))
                t = t->next;
            j = !t;             /* Should be nothing left */
        }
        break;

    case PPC_IFEMPTY:
        t = tline = expand_smacro(tline);
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        j = !t;                 /* Should be empty */
        break;

    case PPC_IF:
        t = tline = expand_smacro(tline);
        tptr = &t;
        tokval.t_type = TOKEN_INVALID;
        evalresult = evaluate(ppscan, tptr, &tokval,
                              NULL, pass | CRITICAL, error, NULL);
        if (!evalresult)
            return -1;
        if (tokval.t_type)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL,
                  "non-constant value given to `%s'", pp_directives[ct]);
            goto fail;
        }
        j = reloc_value(evalresult) != 0;
        break;

    default:
        error(ERR_FATAL,
              "preprocessor directive `%s' not yet implemented",
              pp_directives[ct]);
        goto fail;
    }

    free_tlist(origline);
    return j ^ PP_NEGATIVE(ct);

fail:
    free_tlist(origline);
    return -1;
}

/*
 * Common code for defining an smacro
 */
static bool define_smacro(Context *ctx, const char *mname, bool casesense,
                          int nparam, Token *expansion)
{
    SMacro *smac, **smhead;
    struct hash_table *smtbl;

    if (smacro_defined(ctx, mname, nparam, &smac, casesense)) {
        if (!smac) {
            error(ERR_WARNING|ERR_PASS1,
                  "single-line macro `%s' defined both with and"
                  " without parameters", mname);
            /*
             * Some instances of the old code considered this a failure,
             * some others didn't.  What is the right thing to do here?
             */
            free_tlist(expansion);
            return false;       /* Failure */
        } else {
            /*
             * We're redefining, so we have to take over an
             * existing SMacro structure. This means freeing
             * what was already in it.
             */
            nasm_free(smac->name);
            free_tlist(smac->expansion);
        }
    } else {
        smtbl  = ctx ? &ctx->localmac : &smacros;
        smhead = (SMacro **) hash_findi_add(smtbl, mname);
        smac = nasm_zalloc(sizeof(SMacro));
        smac->next = *smhead;
        *smhead = smac;
    }
    smac->name = nasm_strdup(mname);
    smac->casesense = casesense;
    smac->nparam = nparam;
    smac->expansion = expansion;
    smac->in_progress = false;
    return true;                /* Success */
}

/*
 * Undefine an smacro
 */
static void undef_smacro(Context *ctx, const char *mname)
{
    SMacro **smhead, *s, **sp;
    struct hash_table *smtbl;

    smtbl = ctx ? &ctx->localmac : &smacros;
    smhead = (SMacro **)hash_findi(smtbl, mname, NULL);

    if (smhead) {
        /*
         * We now have a macro name... go hunt for it.
         */
        sp = smhead;
        while ((s = *sp) != NULL) {
            if (!mstrcmp(s->name, mname, s->casesense)) {
                *sp = s->next;
                nasm_free(s->name);
                free_tlist(s->expansion);
                nasm_free(s);
            } else {
                sp = &s->next;
            }
        }
    }
}

/*
 * Parse a mmacro specification.
 */
static bool parse_mmacro_spec(Token *tline, ExpDef *def, const char *directive)
{
    bool err;

    tline = tline->next;
    skip_white_(tline);
    tline = expand_id(tline);
    if (!tok_type_(tline, TOK_ID)) {
        error(ERR_NONFATAL, "`%s' expects a macro name", directive);
        return false;
    }

    def->name = nasm_strdup(tline->text);
    def->plus = false;
    def->nolist = false;
//    def->in_progress = 0;
//    def->rep_nest = NULL;
    def->nparam_min = 0;
    def->nparam_max = 0;

    tline = expand_smacro(tline->next);
    skip_white_(tline);
    if (!tok_type_(tline, TOK_NUMBER)) {
        error(ERR_NONFATAL, "`%s' expects a parameter count", directive);
    } else {
        def->nparam_min = def->nparam_max =
            readnum(tline->text, &err);
        if (err)
            error(ERR_NONFATAL,
                  "unable to parse parameter count `%s'", tline->text);
    }
    if (tline && tok_is_(tline->next, "-")) {
        tline = tline->next->next;
        if (tok_is_(tline, "*")) {
            def->nparam_max = INT_MAX;
        } else if (!tok_type_(tline, TOK_NUMBER)) {
            error(ERR_NONFATAL,
                  "`%s' expects a parameter count after `-'", directive);
        } else {
            def->nparam_max = readnum(tline->text, &err);
            if (err) {
                error(ERR_NONFATAL, "unable to parse parameter count `%s'",
                      tline->text);
            }
            if (def->nparam_min > def->nparam_max) {
                error(ERR_NONFATAL, "minimum parameter count exceeds maximum");
            }
        }
    }
    if (tline && tok_is_(tline->next, "+")) {
        tline = tline->next;
        def->plus = true;
    }
    if (tline && tok_type_(tline->next, TOK_ID) &&
        !nasm_stricmp(tline->next->text, ".nolist")) {
        tline = tline->next;
        def->nolist = true;
    }

    /*
     * Handle default parameters.
     */
    if (tline && tline->next) {
        def->dlist = tline->next;
        tline->next = NULL;
        count_mmac_params(def->dlist, &def->ndefs, &def->defaults);
    } else {
        def->dlist = NULL;
        def->defaults = NULL;
    }
    def->line = NULL;

    if (def->defaults && def->ndefs > def->nparam_max - def->nparam_min &&
        !def->plus)
        error(ERR_WARNING|ERR_PASS1|ERR_WARN_MDP,
              "too many default macro parameters");

    return true;
}


/*
 * Decode a size directive
 */
static int parse_size(const char *str) {
    static const char *size_names[] =
        { "byte", "dword", "oword", "qword", "tword", "word", "yword" };
    static const int sizes[] =
        { 0, 1, 4, 16, 8, 10, 2, 32 };

    return sizes[bsii(str, size_names, ARRAY_SIZE(size_names))+1];
}

/**
 * find and process preprocessor directive in passed line
 * Find out if a line contains a preprocessor directive, and deal
 * with it if so.
 *
 * If a directive _is_ found, it is the responsibility of this routine
 * (and not the caller) to free_tlist() the line.
 *
 * @param tline a pointer to the current tokeninzed line linked list
 * @return DIRECTIVE_FOUND or NO_DIRECTIVE_FOUND
 *
 */
static int do_directive(Token * tline)
{
    enum preproc_token i;
    int j;
    bool err;
    int nparam;
    bool nolist;
    bool casesense;
    int k, m;
    int offset;
    char *p, *pp;
    const char *mname;
    Include *inc;
    Context *ctx;
    Line *l;
    Token *t, *tt, *param_start, *macro_start, *last, **tptr, *origline;
    struct tokenval tokval;
    expr *evalresult;
    ExpDef *ed, *eed, **edhead;
    ExpInv *ei, *eei;
    int64_t count;
    size_t len;
    int severity;

    origline = tline;

    skip_white_(tline);
    if (!tline || !tok_type_(tline, TOK_PREPROC_ID) ||
        (tline->text[1] == '%' || tline->text[1] == '$'
         || tline->text[1] == '!'))
        return NO_DIRECTIVE_FOUND;

    i = pp_token_hash(tline->text);

    switch (i) {
    case PP_INVALID:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        error(ERR_NONFATAL, "unknown preprocessor directive `%s'",
              tline->text);
        return NO_DIRECTIVE_FOUND;      /* didn't get it */

    case PP_STACKSIZE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /* Directive to tell NASM what the default stack size is. The
         * default is for a 16-bit stack, and this can be overriden with
         * %stacksize large.
         */
        tline = tline->next;
        if (tline && tline->type == TOK_WHITESPACE)
            tline = tline->next;
        if (!tline || tline->type != TOK_ID) {
            error(ERR_NONFATAL, "`%%stacksize' missing size parameter");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        if (nasm_stricmp(tline->text, "flat") == 0) {
            /* All subsequent ARG directives are for a 32-bit stack */
            StackSize = 4;
            StackPointer = "ebp";
            ArgOffset = 8;
            LocalOffset = 0;
        } else if (nasm_stricmp(tline->text, "flat64") == 0) {
            /* All subsequent ARG directives are for a 64-bit stack */
            StackSize = 8;
            StackPointer = "rbp";
            ArgOffset = 16;
            LocalOffset = 0;
        } else if (nasm_stricmp(tline->text, "large") == 0) {
            /* All subsequent ARG directives are for a 16-bit stack,
             * far function call.
             */
            StackSize = 2;
            StackPointer = "bp";
            ArgOffset = 4;
            LocalOffset = 0;
        } else if (nasm_stricmp(tline->text, "small") == 0) {
            /* All subsequent ARG directives are for a 16-bit stack,
             * far function call. We don't support near functions.
             */
            StackSize = 2;
            StackPointer = "bp";
            ArgOffset = 6;
            LocalOffset = 0;
        } else {
            error(ERR_NONFATAL, "`%%stacksize' invalid size type");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ARG:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /* TASM like ARG directive to define arguments to functions, in
         * the following form:
         *
         *      ARG arg1:WORD, arg2:DWORD, arg4:QWORD
         */
        offset = ArgOffset;
        do {
            char *arg, directive[256];
            int size = StackSize;

            /* Find the argument name */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                error(ERR_NONFATAL, "`%%arg' missing argument parameter");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            arg = tline->text;

            /* Find the argument size type */
            tline = tline->next;
            if (!tline || tline->type != TOK_OTHER
                || tline->text[0] != ':') {
                error(ERR_NONFATAL,
                      "Syntax error processing `%%arg' directive");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                error(ERR_NONFATAL, "`%%arg' missing size type parameter");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }

            /* Allow macro expansion of type parameter */
            tt = tokenize(tline->text);
            tt = expand_smacro(tt);
            size = parse_size(tt->text);
            if (!size) {
                error(ERR_NONFATAL,
                      "Invalid size type for `%%arg' missing directive");
                free_tlist(tt);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            free_tlist(tt);

            /* Round up to even stack slots */
            size = ALIGN(size, StackSize);

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s+%d)",
                     arg, StackPointer, offset);
            do_directive(tokenize(directive));
            offset += size;

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        } while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        ArgOffset = offset;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_LOCAL:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /* TASM like LOCAL directive to define local variables for a
         * function, in the following form:
         *
         *      LOCAL local1:WORD, local2:DWORD, local4:QWORD = LocalSize
         *
         * The '= LocalSize' at the end is ignored by NASM, but is
         * required by TASM to define the local parameter size (and used
         * by the TASM macro package).
         */
        offset = LocalOffset;
        do {
            char *local, directive[256];
            int size = StackSize;

            /* Find the argument name */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                error(ERR_NONFATAL,
                      "`%%local' missing argument parameter");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            local = tline->text;

            /* Find the argument size type */
            tline = tline->next;
            if (!tline || tline->type != TOK_OTHER
                || tline->text[0] != ':') {
                error(ERR_NONFATAL,
                      "Syntax error processing `%%local' directive");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                error(ERR_NONFATAL,
                      "`%%local' missing size type parameter");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }

            /* Allow macro expansion of type parameter */
            tt = tokenize(tline->text);
            tt = expand_smacro(tt);
            size = parse_size(tt->text);
            if (!size) {
                error(ERR_NONFATAL,
                      "Invalid size type for `%%local' missing directive");
                free_tlist(tt);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            free_tlist(tt);

            /* Round up to even stack slots */
            size = ALIGN(size, StackSize);

            offset += size;     /* Negative offset, increment before */

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s-%d)",
                     local, StackPointer, offset);
            do_directive(tokenize(directive));

            /* Now define the assign to setup the enter_c macro correctly */
            snprintf(directive, sizeof(directive),
                     "%%assign %%$localsize %%$localsize+%d", size);
            do_directive(tokenize(directive));

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        } while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        LocalOffset = offset;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_CLEAR:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        if (tline->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after `%%clear' ignored");
        free_macros();
        init_macros();
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_DEPEND:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        t = tline->next = expand_smacro(tline->next);
        skip_white_(t);
        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            error(ERR_NONFATAL, "`%%depend' expects a file name");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (t->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after `%%depend' ignored");
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote_cstr(p, i);
        if (dephead && !in_list(*dephead, p)) {
            StrList *sl = nasm_malloc(strlen(p)+1+sizeof sl->next);
            sl->next = NULL;
            strcpy(sl->str, p);
            *deptail = sl;
            deptail = &sl->next;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_INCLUDE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        t = tline->next = expand_smacro(tline->next);
        skip_white_(t);

        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            error(ERR_NONFATAL, "`%%include' expects a file name");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (t->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after `%%include' ignored");
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote_cstr(p, i);
        inc = nasm_zalloc(sizeof(Include));
        inc->next = istk;
        inc->fp = inc_fopen(p, dephead, &deptail, pass == 0);
        if (!inc->fp) {
            /* -MG given but file not found */
            nasm_free(inc);
        } else {
            inc->fname = src_set_fname(nasm_strdup(p));
            inc->lineno = src_set_linnum(0);
            inc->lineinc = 1;
            inc->expansion = NULL;
            istk = inc;
            list->uplevel(LIST_INCLUDE);
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_USE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
    {
        static macros_t *use_pkg;
        const char *pkg_macro = NULL;

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);

        if (!tline || (tline->type != TOK_STRING &&
                       tline->type != TOK_INTERNAL_STRING &&
                       tline->type != TOK_ID)) {
            error(ERR_NONFATAL, "`%%use' expects a package name");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (tline->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after `%%use' ignored");
        if (tline->type == TOK_STRING)
            nasm_unquote_cstr(tline->text, i);
        use_pkg = nasm_stdmac_find_package(tline->text);
        if (!use_pkg)
            error(ERR_NONFATAL, "unknown `%%use' package: %s", tline->text);
        else
            pkg_macro = (char *)use_pkg + 1; /* The first string will be <%define>__USE_*__ */
        if (use_pkg && ! smacro_defined(NULL, pkg_macro, 0, NULL, true)) {
            /* Not already included, go ahead and include it */
            stdmacpos = use_pkg;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;
    }
    case PP_PUSH:
    case PP_REPL:
    case PP_POP:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (tline) {
            if (!tok_type_(tline, TOK_ID)) {
                error(ERR_NONFATAL, "`%s' expects a context identifier",
                      pp_directives[i]);
                free_tlist(origline);
                return DIRECTIVE_FOUND;     /* but we did _something_ */
            }
            if (tline->next)
                error(ERR_WARNING|ERR_PASS1,
                      "trailing garbage after `%s' ignored",
                      pp_directives[i]);
            p = nasm_strdup(tline->text);
        } else {
            p = NULL; /* Anonymous */
        }

        if (i == PP_PUSH) {
            ctx = nasm_zalloc(sizeof(Context));
            ctx->next = cstk;
            hash_init(&ctx->localmac, HASH_SMALL);
            ctx->name = p;
            ctx->number = unique++;
            cstk = ctx;
        } else {
            /* %pop or %repl */
            if (!cstk) {
                error(ERR_NONFATAL, "`%s': context stack is empty",
                      pp_directives[i]);
            } else if (i == PP_POP) {
                if (p && (!cstk->name || nasm_stricmp(p, cstk->name)))
                    error(ERR_NONFATAL, "`%%pop' in wrong context: %s, "
                          "expected %s",
                          cstk->name ? cstk->name : "anonymous", p);
                else
                    ctx_pop();
            } else {
                /* i == PP_REPL */
                nasm_free(cstk->name);
                cstk->name = p;
                p = NULL;
            }
            nasm_free(p);
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;
    case PP_FATAL:
        severity = ERR_FATAL;
        goto issue_error;
    case PP_ERROR:
        severity = ERR_NONFATAL;
        goto issue_error;
    case PP_WARNING:
        severity = ERR_WARNING|ERR_WARN_USER;
        goto issue_error;

issue_error:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
    {
        /* Only error out if this is the final pass */
        if (pass != 2 && i != PP_FATAL)
            return DIRECTIVE_FOUND;

        tline->next = expand_smacro(tline->next);
        tline = tline->next;
        skip_white_(tline);
        t = tline ? tline->next : NULL;
        skip_white_(t);
        if (tok_type_(tline, TOK_STRING) && !t) {
            /* The line contains only a quoted string */
            p = tline->text;
            nasm_unquote(p, NULL); /* Ignore NUL character truncation */
            error(severity, "%s",  p);
        } else {
            /* Not a quoted string, or more than a quoted string */
            p = detoken(tline, false);
            error(severity, "%s",  p);
            nasm_free(p);
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;
    }

    CASE_PP_IF:
        if (defining != NULL) {
            if (defining->type == EXP_IF) {
                defining->def_depth ++;
            }
            return NO_DIRECTIVE_FOUND;
        }
        if ((istk->expansion != NULL) &&
            (istk->expansion->emitting == false)) {
            j = COND_NEVER;
        } else {
            j = if_condition(tline->next, i);
            tline->next = NULL; /* it got freed */
            j = (((j < 0) ? COND_NEVER : j) ? COND_IF_TRUE : COND_IF_FALSE);
        }
        ed = new_ExpDef(EXP_IF);
        ed->state = j;
        ed->ignoring = ((ed->state == COND_IF_TRUE) ? false : true);
        ed->prev = defining;
        defining = ed;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    CASE_PP_ELIF:
        if (defining != NULL) {
            if ((defining->type != EXP_IF) || (defining->def_depth > 0)) {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if ((defining == NULL) || (defining->type != EXP_IF)) {
            error(ERR_FATAL, "`%s': no matching `%%if'", pp_directives[i]);
        }
        switch (defining->state) {
        case COND_IF_TRUE:
            defining->state = COND_DONE;
            defining->ignoring = true;
            break;

        case COND_DONE:
        case COND_NEVER:
            defining->ignoring = true;
            break;

        case COND_ELSE_TRUE:
        case COND_ELSE_FALSE:
            error_precond(ERR_WARNING|ERR_PASS1,
                          "`%%elif' after `%%else' ignored");
            defining->state = COND_NEVER;
            defining->ignoring = true;
            break;

        case COND_IF_FALSE:
            /*
             * IMPORTANT: In the case of %if, we will already have
             * called expand_mmac_params(); however, if we're
             * processing an %elif we must have been in a
             * non-emitting mode, which would have inhibited
             * the normal invocation of expand_mmac_params().
             * Therefore, we have to do it explicitly here.
             */
            j = if_condition(expand_mmac_params(tline->next), i);
            tline->next = NULL; /* it got freed */
            defining->state =
                j < 0 ? COND_NEVER : j ? COND_IF_TRUE : COND_IF_FALSE;
            defining->ignoring = ((defining->state == COND_IF_TRUE) ? false : true);
            break;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ELSE:
        if (defining != NULL) {
            if ((defining->type != EXP_IF) || (defining->def_depth > 0)) {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if (tline->next)
            error_precond(ERR_WARNING|ERR_PASS1,
                          "trailing garbage after `%%else' ignored");
        if ((defining == NULL) || (defining->type != EXP_IF)) {
            error(ERR_FATAL, "`%s': no matching `%%if'", pp_directives[i]);
        }
        switch (defining->state) {
        case COND_IF_TRUE:
        case COND_DONE:
            defining->state = COND_ELSE_FALSE;
            defining->ignoring = true;
            break;

        case COND_NEVER:
            defining->ignoring = true;
            break;

        case COND_IF_FALSE:
            defining->state = COND_ELSE_TRUE;
            defining->ignoring = false;
            break;

        case COND_ELSE_TRUE:
        case COND_ELSE_FALSE:
            error_precond(ERR_WARNING|ERR_PASS1,
                          "`%%else' after `%%else' ignored.");
            defining->state = COND_NEVER;
            defining->ignoring = true;
            break;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDIF:
        if (defining != NULL) {
            if (defining->type == EXP_IF) {
                if (defining->def_depth > 0) {
                    defining->def_depth --;
                    return NO_DIRECTIVE_FOUND;
                }
            } else {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if (tline->next)
            error_precond(ERR_WARNING|ERR_PASS1,
                          "trailing garbage after `%%endif' ignored");
        if ((defining == NULL) || (defining->type != EXP_IF)) {
            error(ERR_NONFATAL, "`%%endif': no matching `%%if'");
            return DIRECTIVE_FOUND;
        }
        ed = defining;
        defining = ed->prev;
        ed->prev = expansions;
        expansions = ed;
        ei = new_ExpInv(EXP_IF, ed);
        ei->current = ed->line;
        ei->emitting = true;
        ei->prev = istk->expansion;
        istk->expansion = ei;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_RMACRO:
    case PP_IRMACRO:
    case PP_MACRO:
    case PP_IMACRO:
        if (defining != NULL) {
            if (defining->type == EXP_MMACRO) {
                defining->def_depth ++;
            }
            return NO_DIRECTIVE_FOUND;
        }
        ed = new_ExpDef(EXP_MMACRO);
        ed->max_depth =
            (i == PP_RMACRO) || (i == PP_IRMACRO) ? DEADMAN_LIMIT : 0;
        ed->casesense = (i == PP_MACRO) || (i == PP_RMACRO);
        if (!parse_mmacro_spec(tline, ed, pp_directives[i])) {
            nasm_free(ed);
            ed = NULL;
            return DIRECTIVE_FOUND;
        }
        ed->def_depth = 0;
        ed->cur_depth = 0;
        ed->max_depth = (ed->max_depth + 1);
        ed->ignoring = false;
        ed->prev = defining;
        defining = ed;

        eed = (ExpDef *) hash_findix(&expdefs, ed->name);
        while (eed) {
            if (!strcmp(eed->name, ed->name)                    &&
                (eed->nparam_min <= ed->nparam_max || ed->plus) &&
                (ed->nparam_min <= eed->nparam_max || eed->plus)) {
                    error(ERR_WARNING|ERR_PASS1,
                          "redefining multi-line macro `%s'", ed->name);
                    return DIRECTIVE_FOUND;
            }
            eed = eed->next;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDM:
    case PP_ENDMACRO:
        if (defining != NULL) {
            if (defining->type == EXP_MMACRO) {
                if (defining->def_depth > 0) {
                    defining->def_depth --;
                    return NO_DIRECTIVE_FOUND;
                }
            } else {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if (!(defining) || (defining->type != EXP_MMACRO)) {
            error(ERR_NONFATAL, "`%s': not defining a macro", tline->text);
            return DIRECTIVE_FOUND;
        }
        edhead = (ExpDef **) hash_findi_add(&expdefs, defining->name);
        defining->next = *edhead;
        *edhead = defining;
        ed = defining;
        defining = ed->prev;
        ed->prev = expansions;
        expansions = ed;
        ed = NULL;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_EXITMACRO:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /*
         * We must search along istk->expansion until we hit a
         * macro invocation. Then we disable the emitting state(s)
         * between exitmacro and endmacro.
         */
        for (ei = istk->expansion; ei != NULL; ei = ei->prev) {
            if(ei->type == EXP_MMACRO) {
                break;
            }
        }

        if (ei != NULL) {
            /*
             * Set all invocations leading back to the macro
             * invocation to a non-emitting state.
             */
            for (eei = istk->expansion; eei != ei; eei = eei->prev) {
                eei->emitting = false;
            }
            eei->emitting = false;
        } else {
            error(ERR_NONFATAL, "`%%exitmacro' not within `%%macro' block");
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_UNMACRO:
    case PP_UNIMACRO:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
    {
        ExpDef **ed_p;
        ExpDef spec;

        spec.casesense = (i == PP_UNMACRO);
        if (!parse_mmacro_spec(tline, &spec, pp_directives[i])) {
            return DIRECTIVE_FOUND;
        }
        ed_p = (ExpDef **) hash_findi(&expdefs, spec.name, NULL);
        while (ed_p && *ed_p) {
            ed = *ed_p;
            if (ed->casesense == spec.casesense &&
                !mstrcmp(ed->name, spec.name, spec.casesense) &&
                ed->nparam_min == spec.nparam_min &&
                ed->nparam_max == spec.nparam_max &&
                ed->plus == spec.plus) {
                if (ed->cur_depth > 0) {
                    error(ERR_NONFATAL, "`%s' ignored on active macro",
                          pp_directives[i]);
                    break;
                } else {
                    *ed_p = ed->next;
                    free_expdef(ed);
                }
            } else {
                ed_p = &ed->next;
            }
        }
        free_tlist(origline);
        free_tlist(spec.dlist);
        return DIRECTIVE_FOUND;
    }

    case PP_ROTATE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        if (tline->next && tline->next->type == TOK_WHITESPACE)
            tline = tline->next;
        if (!tline->next) {
            free_tlist(origline);
            error(ERR_NONFATAL, "`%%rotate' missing rotate count");
            return DIRECTIVE_FOUND;
        }
        t = expand_smacro(tline->next);
        tline->next = NULL;
        free_tlist(origline);
        tline = t;
        tptr = &t;
        tokval.t_type = TOKEN_INVALID;
        evalresult =
            evaluate(ppscan, tptr, &tokval, NULL, pass, error, NULL);
        free_tlist(tline);
        if (!evalresult)
            return DIRECTIVE_FOUND;
        if (tokval.t_type)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL, "non-constant value given to `%%rotate'");
            return DIRECTIVE_FOUND;
        }
        for (ei = istk->expansion; ei != NULL; ei = ei->prev) {
            if (ei->type == EXP_MMACRO) {
                break;
            }
        }
        if (ei == NULL) {
            error(ERR_NONFATAL, "`%%rotate' invoked outside a macro call");
        } else if (ei->nparam == 0) {
            error(ERR_NONFATAL,
                  "`%%rotate' invoked within macro without parameters");
        } else {
            int rotate = ei->rotate + reloc_value(evalresult);

            rotate %= (int)ei->nparam;
            if (rotate < 0)
                rotate += ei->nparam;
            ei->rotate = rotate;
        }
        return DIRECTIVE_FOUND;

    case PP_REP:
        if (defining != NULL) {
            if (defining->type == EXP_REP) {
                defining->def_depth ++;
            }
            return NO_DIRECTIVE_FOUND;
        }
        nolist = false;
        do {
            tline = tline->next;
        } while (tok_type_(tline, TOK_WHITESPACE));

        if (tok_type_(tline, TOK_ID) &&
            nasm_stricmp(tline->text, ".nolist") == 0) {
            nolist = true;
            do {
                tline = tline->next;
            } while (tok_type_(tline, TOK_WHITESPACE));
        }

        if (tline) {
            t = expand_smacro(tline);
            tptr = &t;
            tokval.t_type = TOKEN_INVALID;
            evalresult =
                evaluate(ppscan, tptr, &tokval, NULL, pass, error, NULL);
            if (!evalresult) {
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            if (tokval.t_type)
                error(ERR_WARNING|ERR_PASS1,
                      "trailing garbage after expression ignored");
            if (!is_simple(evalresult)) {
                error(ERR_NONFATAL, "non-constant value given to `%%rep'");
                return DIRECTIVE_FOUND;
            }
            count = reloc_value(evalresult);
            if (count >= REP_LIMIT) {
                error(ERR_NONFATAL, "`%%rep' value exceeds limit");
                count = 0;
            } else
                count++;
        } else {
            error(ERR_NONFATAL, "`%%rep' expects a repeat count");
            count = 0;
        }
        free_tlist(origline);
        ed = new_ExpDef(EXP_REP);
        ed->nolist = nolist;
        ed->def_depth = 0;
        ed->cur_depth = 1;
        ed->max_depth = (count - 1);
        ed->ignoring = false;
        ed->prev = defining;
        defining = ed;
        return DIRECTIVE_FOUND;

    case PP_ENDREP:
        if (defining != NULL) {
            if (defining->type == EXP_REP) {
                if (defining->def_depth > 0) {
                    defining->def_depth --;
                    return NO_DIRECTIVE_FOUND;
                }
            } else {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if ((defining == NULL) || (defining->type != EXP_REP)) {
            error(ERR_NONFATAL, "`%%endrep': no matching `%%rep'");
            return DIRECTIVE_FOUND;
        }

        /*
         * Now we have a "macro" defined - although it has no name
         * and we won't be entering it in the hash tables - we must
         * push a macro-end marker for it on to istk->expansion.
         * After that, it will take care of propagating itself (a
         * macro-end marker line for a macro which is really a %rep
         * block will cause the macro to be re-expanded, complete
         * with another macro-end marker to ensure the process
         * continues) until the whole expansion is forcibly removed
         * from istk->expansion by a %exitrep.
         */
        ed = defining;
        defining = ed->prev;
        ed->prev = expansions;
        expansions = ed;
        ei = new_ExpInv(EXP_REP, ed);
        ei->current = ed->line;
        ei->emitting = ((ed->max_depth > 0) ? true : false);
        list->uplevel(ed->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);
        ei->prev = istk->expansion;
        istk->expansion = ei;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_EXITREP:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /*
         * We must search along istk->expansion until we hit a
         * rep invocation. Then we disable the emitting state(s)
         * between exitrep and endrep.
         */
        for (ei = istk->expansion; ei != NULL; ei = ei->prev) {
            if (ei->type == EXP_REP) {
                break;
            }
        }

        if (ei != NULL) {
            /*
             * Set all invocations leading back to the rep
             * invocation to a non-emitting state.
             */
            for (eei = istk->expansion; eei != ei; eei = eei->prev) {
                eei->emitting = false;
            }
            eei->emitting = false;
            eei->current = NULL;
            eei->def->cur_depth = eei->def->max_depth;
        } else {
            error(ERR_NONFATAL, "`%%exitrep' not within `%%rep' block");
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_XDEFINE:
    case PP_IXDEFINE:
    case PP_DEFINE:
    case PP_IDEFINE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = (i == PP_DEFINE || i == PP_XDEFINE);

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL, "`%s' expects a macro identifier",
                  pp_directives[i]);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        ctx = get_ctx(tline->text, &mname);
        last = tline;
        param_start = tline = tline->next;
        nparam = 0;

        /* Expand the macro definition now for %xdefine and %ixdefine */
        if ((i == PP_XDEFINE) || (i == PP_IXDEFINE))
            tline = expand_smacro(tline);

        if (tok_is_(tline, "(")) {
            /*
             * This macro has parameters.
             */

            tline = tline->next;
            while (1) {
                skip_white_(tline);
                if (!tline) {
                    error(ERR_NONFATAL, "parameter identifier expected");
                    free_tlist(origline);
                    return DIRECTIVE_FOUND;
                }
                if (tline->type != TOK_ID) {
                    error(ERR_NONFATAL,
                          "`%s': parameter identifier expected",
                          tline->text);
                    free_tlist(origline);
                    return DIRECTIVE_FOUND;
                }

                smacro_set_param_idx(tline, nparam);
                nparam++;

                tline = tline->next;
                skip_white_(tline);
                if (tok_is_(tline, ",")) {
                    tline = tline->next;
                } else {
                    if (!tok_is_(tline, ")")) {
                        error(ERR_NONFATAL,
                              "`)' expected to terminate macro template");
                        free_tlist(origline);
                        return DIRECTIVE_FOUND;
                    }
                    break;
                }
            }
            last = tline;
            tline = tline->next;
        }
        if (tok_type_(tline, TOK_WHITESPACE))
            last = tline, tline = tline->next;
        macro_start = NULL;
        last->next = NULL;
        t = tline;
        while (t) {
            if (t->type == TOK_ID) {
                list_for_each(tt, param_start)
                    if (is_smacro_param(tt) &&
                        !strcmp(tt->text, t->text))
                        t->type = tt->type;
            }
            tt = t->next;
            t->next = macro_start;
            macro_start = t;
            t = tt;
        }
        /*
         * Good. We now have a macro name, a parameter count, and a
         * token list (in reverse order) for an expansion. We ought
         * to be OK just to create an SMacro, store it, and let
         * free_tlist have the rest of the line (which we have
         * carefully re-terminated after chopping off the expansion
         * from the end).
         */
        define_smacro(ctx, mname, casesense, nparam, macro_start);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_UNDEF:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL, "`%%undef' expects a macro identifier");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        if (tline->next) {
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after macro name ignored");
        }

        /* Find the context that symbol belongs to */
        ctx = get_ctx(tline->text, &mname);
        undef_smacro(ctx, mname);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_DEFSTR:
    case PP_IDEFSTR:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = (i == PP_DEFSTR);

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL, "`%s' expects a macro identifier",
                  pp_directives[i]);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        while (tok_type_(tline, TOK_WHITESPACE))
            tline = delete_Token(tline);

        p = detoken(tline, false);
        macro_start = nasm_zalloc(sizeof(*macro_start));
        macro_start->text = nasm_quote(p, strlen(p));
        macro_start->type = TOK_STRING;
        nasm_free(p);

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a string token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_DEFTOK:
    case PP_IDEFTOK:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = (i == PP_DEFTOK);

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%s' expects a macro identifier as first parameter",
                  pp_directives[i]);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            error(ERR_NONFATAL,
                  "`%s` requires string as second parameter",
                  pp_directives[i]);
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        /*
         * Convert the string to a token stream.  Note that smacros
         * are stored with the token stream reversed, so we have to
         * reverse the output of tokenize().
         */
        nasm_unquote_cstr(t->text, i);
        macro_start = reverse_tokens(tokenize(t->text));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_PATHSEARCH:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
    {
        FILE *fp;
        StrList *xsl = NULL;
        StrList **xst = &xsl;

        casesense = true;

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%%pathsearch' expects a macro identifier as first parameter");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            error(ERR_NONFATAL, "`%%pathsearch' expects a file name");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (t->next)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after `%%pathsearch' ignored");
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote(p, NULL);

        fp = inc_fopen(p, &xsl, &xst, true);
        if (fp) {
            p = xsl->str;
            fclose(fp);         /* Don't actually care about the file */
        }
        macro_start = nasm_zalloc(sizeof(*macro_start));
        macro_start->text = nasm_quote(p, strlen(p));
        macro_start->type = TOK_STRING;
        nasm_free(xsl);

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a string token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;
    }

    case PP_STRLEN:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = true;

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%%strlen' expects a macro identifier as first parameter");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            error(ERR_NONFATAL,
                  "`%%strlen` requires string as second parameter");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = nasm_zalloc(sizeof(*macro_start));
        make_tok_num(macro_start, nasm_unquote(t->text, NULL));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_STRCAT:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = true;

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%%strcat' expects a macro identifier as first parameter");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        len = 0;
        list_for_each(t, tline) {
            switch (t->type) {
            case TOK_WHITESPACE:
                break;
            case TOK_STRING:
                len += t->a.len = nasm_unquote(t->text, NULL);
                break;
            case TOK_OTHER:
                if (!strcmp(t->text, ",")) /* permit comma separators */
                    break;
                /* else fall through */
            default:
                error(ERR_NONFATAL,
                      "non-string passed to `%%strcat' (%d)", t->type);
                free_tlist(tline);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
        }

        p = pp = nasm_malloc(len);
        list_for_each(t, tline) {
            if (t->type == TOK_STRING) {
                memcpy(p, t->text, t->a.len);
                p += t->a.len;
            }
        }

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        macro_start = new_Token(NULL, TOK_STRING, NULL, 0);
        macro_start->text = nasm_quote(pp, len);
        nasm_free(pp);
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_SUBSTR:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
    {
        int64_t start, count;
        size_t len;

        casesense = true;

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%%substr' expects a macro identifier as first parameter");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        if (tline) /* skip expanded id */
            t = tline->next;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            error(ERR_NONFATAL,
                  "`%%substr` requires string as second parameter");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        tt = t->next;
        tptr = &tt;
        tokval.t_type = TOKEN_INVALID;
        evalresult = evaluate(ppscan, tptr, &tokval, NULL,
                              pass, error, NULL);
        if (!evalresult) {
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        } else if (!is_simple(evalresult)) {
            error(ERR_NONFATAL, "non-constant value given to `%%substr`");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        start = evalresult->value - 1;

        while (tok_type_(tt, TOK_WHITESPACE))
            tt = tt->next;
        if (!tt) {
            count = 1;             /* Backwards compatibility: one character */
        } else {
            tokval.t_type = TOKEN_INVALID;
            evalresult = evaluate(ppscan, tptr, &tokval, NULL,
                                  pass, error, NULL);
            if (!evalresult) {
                free_tlist(tline);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            } else if (!is_simple(evalresult)) {
                error(ERR_NONFATAL, "non-constant value given to `%%substr`");
                free_tlist(tline);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            count = evalresult->value;
        }

        len = nasm_unquote(t->text, NULL);
        /* make start and count being in range */
        if (start < 0)
            start = 0;
        if (count < 0)
            count = len + count + 1 - start;
        if (start + count > (int64_t)len)
            count = len - start;
        if (!len || count < 0 || start >=(int64_t)len)
            start = -1, count = 0; /* empty string */

        macro_start = nasm_zalloc(sizeof(*macro_start));
        macro_start->text = nasm_quote((start < 0) ? "" : t->text + start, count);
        macro_start->type = TOK_STRING;

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;
    }

    case PP_ASSIGN:
    case PP_IASSIGN:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        casesense = (i == PP_ASSIGN);

        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tline || (tline->type != TOK_ID &&
                       (tline->type != TOK_PREPROC_ID ||
                        tline->text[1] != '$'))) {
            error(ERR_NONFATAL,
                  "`%%%sassign' expects a macro identifier",
                  (i == PP_IASSIGN ? "i" : ""));
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        ctx = get_ctx(tline->text, &mname);
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        tptr = &t;
        tokval.t_type = TOKEN_INVALID;
        evalresult =
            evaluate(ppscan, tptr, &tokval, NULL, pass, error, NULL);
        free_tlist(tline);
        if (!evalresult) {
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        if (tokval.t_type)
            error(ERR_WARNING|ERR_PASS1,
                  "trailing garbage after expression ignored");

        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL,
                  "non-constant value given to `%%%sassign'",
                  (i == PP_IASSIGN ? "i" : ""));
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = nasm_zalloc(sizeof(*macro_start));
        make_tok_num(macro_start, reloc_value(evalresult));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_LINE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /*
         * Syntax is `%line nnn[+mmm] [filename]'
         */
        tline = tline->next;
        skip_white_(tline);
        if (!tok_type_(tline, TOK_NUMBER)) {
            error(ERR_NONFATAL, "`%%line' expects line number");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        k = readnum(tline->text, &err);
        m = 1;
        tline = tline->next;
        if (tok_is_(tline, "+")) {
            tline = tline->next;
            if (!tok_type_(tline, TOK_NUMBER)) {
                error(ERR_NONFATAL, "`%%line' expects line increment");
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            m = readnum(tline->text, &err);
            tline = tline->next;
        }
        skip_white_(tline);
        src_set_linnum(k);
        istk->lineinc = m;
        if (tline) {
            nasm_free(src_set_fname(detoken(tline, false)));
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_WHILE:
        if (defining != NULL) {
            if (defining->type == EXP_WHILE) {
                defining->def_depth ++;
            }
            return NO_DIRECTIVE_FOUND;
        }
        l = NULL;
        if ((istk->expansion != NULL) &&
             (istk->expansion->emitting == false)) {
            j = COND_NEVER;
        } else {
            l = new_Line();
            l->first = copy_Token(tline->next);
            j = if_condition(tline->next, i);
            tline->next = NULL; /* it got freed */
            j = (((j < 0) ? COND_NEVER : j) ? COND_IF_TRUE : COND_IF_FALSE);
        }
        ed = new_ExpDef(EXP_WHILE);
        ed->state = j;
        ed->cur_depth = 1;
        ed->max_depth = DEADMAN_LIMIT;
        ed->ignoring = ((ed->state == COND_IF_TRUE) ? false : true);
        if (ed->ignoring == false) {
            ed->line = l;
            ed->last = l;
        } else if (l != NULL) {
            delete_Token(l->first);
            nasm_free(l);
            l = NULL;
        }
        ed->prev = defining;
        defining = ed;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDWHILE:
        if (defining != NULL) {
            if (defining->type == EXP_WHILE) {
                if (defining->def_depth > 0) {
                    defining->def_depth --;
                    return NO_DIRECTIVE_FOUND;
                }
            } else {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if (tline->next != NULL) {
            error_precond(ERR_WARNING|ERR_PASS1,
                          "trailing garbage after `%%endwhile' ignored");
        }
        if ((defining == NULL) || (defining->type != EXP_WHILE)) {
            error(ERR_NONFATAL, "`%%endwhile': no matching `%%while'");
            return DIRECTIVE_FOUND;
        }
        ed = defining;
        defining = ed->prev;
        if (ed->ignoring == false) {
            ed->prev = expansions;
            expansions = ed;
            ei = new_ExpInv(EXP_WHILE, ed);
            ei->current = ed->line->next;
            ei->emitting = true;
            ei->prev = istk->expansion;
            istk->expansion = ei;
        } else {
            nasm_free(ed);
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_EXITWHILE:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        /*
         * We must search along istk->expansion until we hit a
         * while invocation. Then we disable the emitting state(s)
         * between exitwhile and endwhile.
         */
        for (ei = istk->expansion; ei != NULL; ei = ei->prev) {
            if (ei->type == EXP_WHILE) {
                break;
            }
        }

        if (ei != NULL) {
            /*
             * Set all invocations leading back to the while
             * invocation to a non-emitting state.
             */
            for (eei = istk->expansion; eei != ei; eei = eei->prev) {
                eei->emitting = false;
            }
            eei->emitting = false;
            eei->current = NULL;
            eei->def->cur_depth = eei->def->max_depth;
        } else {
            error(ERR_NONFATAL, "`%%exitwhile' not within `%%while' block");
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_COMMENT:
        if (defining != NULL) {
            if (defining->type == EXP_COMMENT) {
                defining->def_depth ++;
            }
        return NO_DIRECTIVE_FOUND;
        }
        ed = new_ExpDef(EXP_COMMENT);
        ed->ignoring = true;
        ed->prev = defining;
        defining = ed;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDCOMMENT:
        if (defining != NULL) {
            if (defining->type == EXP_COMMENT) {
                if (defining->def_depth > 0) {
                    defining->def_depth --;
                    return NO_DIRECTIVE_FOUND;
                }
            } else {
                return NO_DIRECTIVE_FOUND;
            }
        }
        if ((defining == NULL) || (defining->type != EXP_COMMENT)) {
            error(ERR_NONFATAL, "`%%endcomment': no matching `%%comment'");
            return DIRECTIVE_FOUND;
        }
        ed = defining;
        defining = ed->prev;
        nasm_free(ed);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_FINAL:
        if (defining != NULL) return NO_DIRECTIVE_FOUND;
        if (in_final != false) {
            error(ERR_FATAL, "`%%final' cannot be used recursively");
        }
        tline = tline->next;
        skip_white_(tline);
        if (tline == NULL) {
            error(ERR_NONFATAL, "`%%final' expects at least one parameter");
        } else {
            l = new_Line();
            l->first = copy_Token(tline);
            l->next = finals;
            finals = l;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    default:
        error(ERR_FATAL,
              "preprocessor directive `%s' not yet implemented",
              pp_directives[i]);
        return DIRECTIVE_FOUND;
    }
}

/*
 * Ensure that a macro parameter contains a condition code and
 * nothing else. Return the condition code index if so, or -1
 * otherwise.
 */
static int find_cc(Token * t)
{
    Token *tt;
    int i, j, k, m;

    if (!t)
        return -1;              /* Probably a %+ without a space */

    skip_white_(t);
    if (t->type != TOK_ID)
        return -1;
    tt = t->next;
    skip_white_(tt);
    if (tt && (tt->type != TOK_OTHER || strcmp(tt->text, ",")))
        return -1;

    i = -1;
    j = ARRAY_SIZE(conditions);
    while (j - i > 1) {
        k = (j + i) / 2;
        m = nasm_stricmp(t->text, conditions[k]);
        if (m == 0) {
            i = k;
            j = -2;
            break;
        } else if (m < 0) {
            j = k;
        } else
            i = k;
    }
    if (j != -2)
        return -1;
    return i;
}

static bool paste_tokens(Token **head, const struct tokseq_match *m,
                         int mnum, bool handle_paste_tokens)
{
    Token **tail, *t, *tt;
    Token **paste_head;
    bool did_paste = false;
    char *tmp;
    int i;

    nasm_dump_stream(*head);
    nasm_dump_token(*head);

    /* Now handle token pasting... */
    paste_head = NULL;
    tail = head;
    while ((t = *tail) && (tt = t->next)) {
        switch (t->type) {
        case TOK_WHITESPACE:
            if (tt->type == TOK_WHITESPACE) {
                /* Zap adjacent whitespace tokens */
                t->next = delete_Token(tt);
            } else {
                /* Do not advance paste_head here */
                tail = &t->next;
            }
            break;
        case TOK_PASTE:         /* %+ */
            if (handle_paste_tokens) {
                /* Zap %+ and whitespace tokens to the right */
                while (t && (t->type == TOK_WHITESPACE ||
                             t->type == TOK_PASTE))
                    t = *tail = delete_Token(t);
                if (!t) { /* Dangling %+ term */
                    if (paste_head)
                        (*paste_head)->next = NULL;
                    else
                        *head = NULL;
                    return did_paste;
                }
                tail = paste_head;
                t = *tail;
                tt = t->next;
                while (tok_type_(tt, TOK_WHITESPACE))
                    tt = t->next = delete_Token(tt);
                if (tt) {
                    tmp = nasm_strcat(t->text, tt->text);
                    delete_Token(t);
                    tt = delete_Token(tt);
                    t = *tail = tokenize(tmp);
                    nasm_free(tmp);
                    while (t->next) {
                        tail = &t->next;
                        t = t->next;
                    }
                    t->next = tt; /* Attach the remaining token chain */
                    did_paste = true;
                }
                paste_head = tail;
                tail = &t->next;
                break;
            }
            /* else fall through */
        default:
            /*
             * Concatenation of tokens might look nontrivial
             * but in real it's pretty simple -- the caller
             * prepares the masks of token types to be concatenated
             * and we simply find matched sequences and slip
             * them together
             */
            for (i = 0; i < mnum; i++) {
                if (PP_CONCAT_MASK(t->type) & m[i].mask_head) {
                    size_t len = 0;
                    char *tmp, *p;

                    while (tt && (PP_CONCAT_MASK(tt->type) & m[i].mask_tail)) {
                         len += strlen(tt->text);
                         tt = tt->next;
                    }

                    nasm_dump_token(tt);

                    /*
                     * Now tt points to the first token after
                     * the potential paste area...
                     */
                    if (tt != t->next) {
                        /* We have at least two tokens... */
                        len += strlen(t->text);
                        p = tmp = nasm_malloc(len+1);
                        while (t != tt) {
                            strcpy(p, t->text);
                            p = strchr(p, '\0');
                            t = delete_Token(t);
                        }
                        t = *tail = tokenize(tmp);
                        nasm_free(tmp);
                        while (t->next) {
                            tail = &t->next;
                            t = t->next;
                        }
                        t->next = tt;   /* Attach the remaining token chain */
                        did_paste = true;
                    }
                    paste_head = tail;
                    tail = &t->next;
                    break;
                }
            }
            if (i >= mnum) {    /* no match */
                tail = &t->next;
                if (!tok_type_(t->next, TOK_WHITESPACE))
                    paste_head = tail;
            }
            break;
        }
    }
    return did_paste;
}

/*
 * expands to a list of tokens from %{x:y}
 */
static Token *expand_mmac_params_range(ExpInv *ei, Token *tline, Token ***last)
{
    Token *t = tline, **tt, *tm, *head;
    char *pos;
    int fst, lst, j, i;

    pos = strchr(tline->text, ':');
    nasm_assert(pos);

    lst = atoi(pos + 1);
    fst = atoi(tline->text + 1);

    /*
     * only macros params are accounted so
     * if someone passes %0 -- we reject such
     * value(s)
     */
    if (lst == 0 || fst == 0)
        goto err;

    /* the values should be sane */
    if ((fst > (int)ei->nparam || fst < (-(int)ei->nparam)) ||
        (lst > (int)ei->nparam || lst < (-(int)ei->nparam)))
        goto err;

    fst = fst < 0 ? fst + (int)ei->nparam + 1: fst;
    lst = lst < 0 ? lst + (int)ei->nparam + 1: lst;

    /* counted from zero */
    fst--, lst--;

    /*
     * it will be at least one token
     */
    tm = ei->params[(fst + ei->rotate) % ei->nparam];
    t = new_Token(NULL, tm->type, tm->text, 0);
    head = t, tt = &t->next;
    if (fst < lst) {
        for (i = fst + 1; i <= lst; i++) {
            t = new_Token(NULL, TOK_OTHER, ",", 0);
            *tt = t, tt = &t->next;
            j = (i + ei->rotate) % ei->nparam;
            tm = ei->params[j];
            t = new_Token(NULL, tm->type, tm->text, 0);
            *tt = t, tt = &t->next;
        }
    } else {
        for (i = fst - 1; i >= lst; i--) {
            t = new_Token(NULL, TOK_OTHER, ",", 0);
            *tt = t, tt = &t->next;
            j = (i + ei->rotate) % ei->nparam;
            tm = ei->params[j];
            t = new_Token(NULL, tm->type, tm->text, 0);
            *tt = t, tt = &t->next;
        }
    }

    *last = tt;
    return head;

err:
    error(ERR_NONFATAL, "`%%{%s}': macro parameters out of range",
          &tline->text[1]);
    return tline;
}

/*
 * Expand MMacro-local things: parameter references (%0, %n, %+n,
 * %-n) and MMacro-local identifiers (%%foo) as well as
 * macro indirection (%[...]) and range (%{..:..}).
 */
static Token *expand_mmac_params(Token * tline)
{
    Token *t, *tt, **tail, *thead;
    bool changed = false;
    char *pos;

    tail = &thead;
    thead = NULL;

    nasm_dump_stream(tline);

    while (tline) {
        if (tline->type == TOK_PREPROC_ID &&
            (((tline->text[1] == '+' || tline->text[1] == '-') && tline->text[2])   ||
              (tline->text[1] >= '0' && tline->text[1] <= '9')                      ||
               tline->text[1] == '%')) {
            char *text = NULL;
            int type = 0, cc;   /* type = 0 to placate optimisers */
            char tmpbuf[30];
            unsigned int n;
            int i;
            ExpInv *ei;

            t = tline;
            tline = tline->next;

            for (ei = istk->expansion; ei != NULL; ei = ei->prev) {
                if (ei->type == EXP_MMACRO) {
                    break;
                }
            }
            if (ei == NULL) {
                error(ERR_NONFATAL, "`%s': not in a macro call", t->text);
            } else {
                pos = strchr(t->text, ':');
                if (!pos) {
                    switch (t->text[1]) {
                        /*
                         * We have to make a substitution of one of the
                         * forms %1, %-1, %+1, %%foo, %0.
                         */
                    case '0':
                        if ((strlen(t->text) > 2) && (t->text[2] == '0')) {
                            type = TOK_ID;
                            text = nasm_strdup(ei->label_text);
                        } else {
                            type = TOK_NUMBER;
                            snprintf(tmpbuf, sizeof(tmpbuf), "%d", ei->nparam);
                            text = nasm_strdup(tmpbuf);
                        }
                        break;
                    case '%':
                        type = TOK_ID;
                        snprintf(tmpbuf, sizeof(tmpbuf), "..@%"PRIu64".",
                                 ei->unique);
                        text = nasm_strcat(tmpbuf, t->text + 2);
                        break;
                    case '-':
                        n = atoi(t->text + 2) - 1;
                        if (n >= ei->nparam)
                            tt = NULL;
                        else {
                            if (ei->nparam > 1)
                                n = (n + ei->rotate) % ei->nparam;
                            tt = ei->params[n];
                        }
                        cc = find_cc(tt);
                        if (cc == -1) {
                            error(ERR_NONFATAL,
                                  "macro parameter %d is not a condition code",
                                  n + 1);
                            text = NULL;
                        } else {
                            type = TOK_ID;
                            if (inverse_ccs[cc] == -1) {
                                error(ERR_NONFATAL,
                                      "condition code `%s' is not invertible",
                                      conditions[cc]);
                                text = NULL;
                            } else
                                text = nasm_strdup(conditions[inverse_ccs[cc]]);
                        }
                        break;
                    case '+':
                        n = atoi(t->text + 2) - 1;
                        if (n >= ei->nparam)
                            tt = NULL;
                        else {
                            if (ei->nparam > 1)
                                n = (n + ei->rotate) % ei->nparam;
                            tt = ei->params[n];
                        }
                        cc = find_cc(tt);
                        if (cc == -1) {
                            error(ERR_NONFATAL,
                                  "macro parameter %d is not a condition code",
                                  n + 1);
                            text = NULL;
                        } else {
                            type = TOK_ID;
                            text = nasm_strdup(conditions[cc]);
                        }
                        break;
                    default:
                        n = atoi(t->text + 1) - 1;
                        if (n >= ei->nparam)
                            tt = NULL;
                        else {
                            if (ei->nparam > 1)
                                n = (n + ei->rotate) % ei->nparam;
                            tt = ei->params[n];
                        }
                        if (tt) {
                            for (i = 0; i < ei->paramlen[n]; i++) {
                                *tail = new_Token(NULL, tt->type, tt->text, 0);
                                tail = &(*tail)->next;
                                tt = tt->next;
                            }
                        }
                        text = NULL;        /* we've done it here */
                        break;
                    }
                } else {
                    /*
                     * seems we have a parameters range here
                     */
                    Token *head, **last;
                    head = expand_mmac_params_range(ei, t, &last);
                    if (head != t) {
                        *tail = head;
                        *last = tline;
                        tline = head;
                        text = NULL;
                    }
                }
            }
            if (!text) {
                delete_Token(t);
            } else {
                *tail = t;
                tail = &t->next;
                t->type = type;
                nasm_free(t->text);
                t->text = text;
                t->a.mac = NULL;
            }
            changed = true;
            continue;
        } else if (tline->type == TOK_INDIRECT) {
            t = tline;
            tline = tline->next;
            tt = tokenize(t->text);
            tt = expand_mmac_params(tt);
            tt = expand_smacro(tt);
            *tail = tt;
            while (tt) {
                tt->a.mac = NULL; /* Necessary? */
                tail = &tt->next;
                tt = tt->next;
            }
            delete_Token(t);
            changed = true;
        } else {
            t = *tail = tline;
            tline = tline->next;
            t->a.mac = NULL;
            tail = &t->next;
        }
    }
    *tail = NULL;

    if (changed) {
        const struct tokseq_match t[] = {
            {
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_FLOAT),          /* head */
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_NUMBER)      |
                PP_CONCAT_MASK(TOK_FLOAT)       |
                PP_CONCAT_MASK(TOK_OTHER)           /* tail */
            },
            {
                PP_CONCAT_MASK(TOK_NUMBER),         /* head */
                PP_CONCAT_MASK(TOK_NUMBER)          /* tail */
            }
        };
        paste_tokens(&thead, t, ARRAY_SIZE(t), false);
    }

    nasm_dump_token(thead);

    return thead;
}

/*
 * Expand all single-line macro calls made in the given line.
 * Return the expanded version of the line. The original is deemed
 * to be destroyed in the process. (In reality we'll just move
 * Tokens from input to output a lot of the time, rather than
 * actually bothering to destroy and replicate.)
 */

static Token *expand_smacro(Token * tline)
{
    Token *t, *tt, *mstart, **tail, *thead;
    SMacro *head = NULL, *m;
    Token **params;
    int *paramsize;
    unsigned int nparam, sparam;
    int brackets;
    Token *org_tline = tline;
    Context *ctx;
    const char *mname;
    int deadman = DEADMAN_LIMIT;
    bool expanded;

    /*
     * Trick: we should avoid changing the start token pointer since it can
     * be contained in "next" field of other token. Because of this
     * we allocate a copy of first token and work with it; at the end of
     * routine we copy it back
     */
    if (org_tline) {
        tline = new_Token(org_tline->next, org_tline->type,
                          org_tline->text, 0);
        tline->a.mac = org_tline->a.mac;
        nasm_free(org_tline->text);
        org_tline->text = NULL;
    }

    expanded = true;            /* Always expand %+ at least once */

again:
    thead = NULL;
    tail = &thead;

    while (tline) {             /* main token loop */
        if (!--deadman) {
            error(ERR_NONFATAL, "interminable macro recursion");
            goto err;
        }

        if ((mname = tline->text)) {
            /* if this token is a local macro, look in local context */
            if (tline->type == TOK_ID) {
                head = (SMacro *)hash_findix(&smacros, mname);
            } else if (tline->type == TOK_PREPROC_ID) {
                ctx = get_ctx(mname, &mname);
                head = ctx ? (SMacro *)hash_findix(&ctx->localmac, mname) : NULL;
            } else
                head = NULL;

            /*
             * We've hit an identifier. As in is_mmacro below, we first
             * check whether the identifier is a single-line macro at
             * all, then think about checking for parameters if
             * necessary.
             */
            list_for_each(m, head) {
                if (!mstrcmp(m->name, mname, m->casesense))
                    break;
            }
            if (m) {
                mstart = tline;
                params = NULL;
                paramsize = NULL;
                if (m->nparam == 0) {
                    /*
                     * Simple case: the macro is parameterless. Discard the
                     * one token that the macro call took, and push the
                     * expansion back on the to-do stack.
                     */
                    if (!m->expansion) {
                        if (!strcmp("__FILE__", m->name)) {
                            int32_t num = 0;
                            char *file = NULL;
                            src_get(&num, &file);
                            tline->text = nasm_quote(file, strlen(file));
                            tline->type = TOK_STRING;
                            nasm_free(file);
                            continue;
                        }
                        if (!strcmp("__LINE__", m->name)) {
                            nasm_free(tline->text);
                            make_tok_num(tline, src_get_linnum());
                            continue;
                        }
                        if (!strcmp("__BITS__", m->name)) {
                            nasm_free(tline->text);
                            make_tok_num(tline, globalbits);
                            continue;
                        }
                        tline = delete_Token(tline);
                        continue;
                    }
                } else {
                    /*
                     * Complicated case: at least one macro with this name
                     * exists and takes parameters. We must find the
                     * parameters in the call, count them, find the SMacro
                     * that corresponds to that form of the macro call, and
                     * substitute for the parameters when we expand. What a
                     * pain.
                     */
                    /*tline = tline->next;
                      skip_white_(tline); */
                    do {
                        t = tline->next;
                        while (tok_type_(t, TOK_SMAC_END)) {
                            t->a.mac->in_progress = false;
                            t->text = NULL;
                            t = tline->next = delete_Token(t);
                        }
                        tline = t;
                    } while (tok_type_(tline, TOK_WHITESPACE));
                    if (!tok_is_(tline, "(")) {
                        /*
                         * This macro wasn't called with parameters: ignore
                         * the call. (Behaviour borrowed from gnu cpp.)
                         */
                        tline = mstart;
                        m = NULL;
                    } else {
                        int paren = 0;
                        int white = 0;
                        brackets = 0;
                        nparam = 0;
                        sparam = PARAM_DELTA;
                        params = nasm_malloc(sparam * sizeof(Token *));
                        params[0] = tline->next;
                        paramsize = nasm_malloc(sparam * sizeof(int));
                        paramsize[0] = 0;
                        while (true) {  /* parameter loop */
                            /*
                             * For some unusual expansions
                             * which concatenates function call
                             */
                            t = tline->next;
                            while (tok_type_(t, TOK_SMAC_END)) {
                                t->a.mac->in_progress = false;
                                t->text = NULL;
                                t = tline->next = delete_Token(t);
                            }
                            tline = t;

                            if (!tline) {
                                error(ERR_NONFATAL,
                                      "macro call expects terminating `)'");
                                break;
                            }
                            if (tline->type == TOK_WHITESPACE
                                && brackets <= 0) {
                                if (paramsize[nparam])
                                    white++;
                                else
                                    params[nparam] = tline->next;
                                continue;       /* parameter loop */
                            }
                            if (tline->type == TOK_OTHER
                                && tline->text[1] == 0) {
                                char ch = tline->text[0];
                                if (ch == ',' && !paren && brackets <= 0) {
                                    if (++nparam >= sparam) {
                                        sparam += PARAM_DELTA;
                                        params = nasm_realloc(params,
                                                        sparam * sizeof(Token *));
                                        paramsize = nasm_realloc(paramsize,
                                                        sparam * sizeof(int));
                                    }
                                    params[nparam] = tline->next;
                                    paramsize[nparam] = 0;
                                    white = 0;
                                    continue;   /* parameter loop */
                                }
                                if (ch == '{' &&
                                    (brackets > 0 || (brackets == 0 &&
                                                      !paramsize[nparam])))
                                {
                                    if (!(brackets++)) {
                                        params[nparam] = tline->next;
                                        continue;       /* parameter loop */
                                    }
                                }
                                if (ch == '}' && brackets > 0)
                                    if (--brackets == 0) {
                                        brackets = -1;
                                        continue;       /* parameter loop */
                                    }
                                if (ch == '(' && !brackets)
                                    paren++;
                                if (ch == ')' && brackets <= 0)
                                    if (--paren < 0)
                                        break;
                            }
                            if (brackets < 0) {
                                brackets = 0;
                                error(ERR_NONFATAL, "braces do not "
                                      "enclose all of macro parameter");
                            }
                            paramsize[nparam] += white + 1;
                            white = 0;
                        }       /* parameter loop */
                        nparam++;
                        while (m && (m->nparam != nparam ||
                                     mstrcmp(m->name, mname,
                                             m->casesense)))
                            m = m->next;
                        if (!m)
                            error(ERR_WARNING|ERR_PASS1|ERR_WARN_MNP,
                                  "macro `%s' exists, "
                                  "but not taking %d parameters",
                                  mstart->text, nparam);
                    }
                }
                if (m && m->in_progress)
                    m = NULL;
                if (!m) {       /* in progess or didn't find '(' or wrong nparam */
                    /*
                     * Design question: should we handle !tline, which
                     * indicates missing ')' here, or expand those
                     * macros anyway, which requires the (t) test a few
                     * lines down?
                     */
                    nasm_free(params);
                    nasm_free(paramsize);
                    tline = mstart;
                } else {
                    /*
                     * Expand the macro: we are placed on the last token of the
                     * call, so that we can easily split the call from the
                     * following tokens. We also start by pushing an SMAC_END
                     * token for the cycle removal.
                     */
                    t = tline;
                    if (t) {
                        tline = t->next;
                        t->next = NULL;
                    }
                    tt = new_Token(tline, TOK_SMAC_END, NULL, 0);
                    tt->a.mac = m;
                    m->in_progress = true;
                    tline = tt;
                    list_for_each(t, m->expansion) {
                        if (is_smacro_param(t)) {
                            Token *pcopy = tline, **ptail = &pcopy;
                            Token *ttt;
                            int i, idx;

                            idx = smacro_get_param_idx(t);
                            ttt = params[idx];

                            /*
                             * We need smacro paramters appended.
                             */
                            for (i = paramsize[idx]; i > 0; i--) {
                                *ptail = new_Token(tline, ttt->type, ttt->text, 0);
                                ptail = &(*ptail)->next;
                                ttt = ttt->next;
                            }

                            tline = pcopy;
                        } else if (t->type == TOK_PREPROC_Q) {
                            tt = new_Token(tline, TOK_ID, mname, 0);
                            tline = tt;
                        } else if (t->type == TOK_PREPROC_QQ) {
                            tt = new_Token(tline, TOK_ID, m->name, 0);
                            tline = tt;
                        } else {
                            tt = new_Token(tline, t->type, t->text, 0);
                            tline = tt;
                        }
                    }

                    /*
                     * Having done that, get rid of the macro call, and clean
                     * up the parameters.
                     */
                    nasm_free(params);
                    nasm_free(paramsize);
                    free_tlist(mstart);
                    expanded = true;
                    continue;   /* main token loop */
                }
            }
        }

        if (tline->type == TOK_SMAC_END) {
            tline->a.mac->in_progress = false;
            tline = delete_Token(tline);
        } else {
            t = *tail = tline;
            tline = tline->next;
            t->a.mac = NULL;
            t->next = NULL;
            tail = &t->next;
        }
    }

    /*
     * Now scan the entire line and look for successive TOK_IDs that resulted
     * after expansion (they can't be produced by tokenize()). The successive
     * TOK_IDs should be concatenated.
     * Also we look for %+ tokens and concatenate the tokens before and after
     * them (without white spaces in between).
     */
    if (expanded) {
        const struct tokseq_match t[] = {
            {
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_PREPROC_ID),     /* head */
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_PREPROC_ID)  |
                PP_CONCAT_MASK(TOK_NUMBER)          /* tail */
            }
        };
        if (paste_tokens(&thead, t, ARRAY_SIZE(t), true)) {
            /*
             * If we concatenated something, *and* we had previously expanded
             * an actual macro, scan the lines again for macros...
             */
            tline = thead;
            expanded = false;
            goto again;
        }
    }

err:
    if (org_tline) {
        if (thead) {
            *org_tline = *thead;
            /* since we just gave text to org_line, don't free it */
            thead->text = NULL;
            delete_Token(thead);
        } else {
            /* the expression expanded to empty line;
               we can't return NULL for some reasons
               we just set the line to a single WHITESPACE token. */
            memset(org_tline, 0, sizeof(*org_tline));
            org_tline->text = NULL;
            org_tline->type = TOK_WHITESPACE;
        }
        thead = org_tline;
    }

    return thead;
}

/*
 * Similar to expand_smacro but used exclusively with macro identifiers
 * right before they are fetched in. The reason is that there can be
 * identifiers consisting of several subparts. We consider that if there
 * are more than one element forming the name, user wants a expansion,
 * otherwise it will be left as-is. Example:
 *
 *      %define %$abc cde
 *
 * the identifier %$abc will be left as-is so that the handler for %define
 * will suck it and define the corresponding value. Other case:
 *
 *      %define _%$abc cde
 *
 * In this case user wants name to be expanded *before* %define starts
 * working, so we'll expand %$abc into something (if it has a value;
 * otherwise it will be left as-is) then concatenate all successive
 * PP_IDs into one.
 */
static Token *expand_id(Token * tline)
{
    Token *cur, *oldnext = NULL;

    if (!tline || !tline->next)
        return tline;

    cur = tline;
    while (cur->next &&
           (cur->next->type == TOK_ID           ||
            cur->next->type == TOK_PREPROC_ID   ||
            cur->next->type == TOK_NUMBER))
        cur = cur->next;

    /* If identifier consists of just one token, don't expand */
    if (cur == tline)
        return tline;

    if (cur) {
        oldnext = cur->next;    /* Detach the tail past identifier */
        cur->next = NULL;       /* so that expand_smacro stops here */
    }

    tline = expand_smacro(tline);

    if (cur) {
        /* expand_smacro possibly changhed tline; re-scan for EOL */
        cur = tline;
        while (cur && cur->next)
            cur = cur->next;
        if (cur)
            cur->next = oldnext;
    }

    return tline;
}

/*
 * Determine whether the given line constitutes a multi-line macro
 * call, and return the ExpDef structure called if so. Doesn't have
 * to check for an initial label - that's taken care of in
 * expand_mmacro - but must check numbers of parameters. Guaranteed
 * to be called with tline->type == TOK_ID, so the putative macro
 * name is easy to find.
 */
static ExpDef *is_mmacro(Token * tline, Token *** params_array)
{
    ExpDef *head, *ed;
    Token **params;
    int nparam;

    head = (ExpDef *) hash_findix(&expdefs, tline->text);

    /*
     * Efficiency: first we see if any macro exists with the given
     * name. If not, we can return NULL immediately. _Then_ we
     * count the parameters, and then we look further along the
     * list if necessary to find the proper ExpDef.
     */
    list_for_each(ed, head) {
        if (!mstrcmp(ed->name, tline->text, ed->casesense))
            break;
    }
    if (!ed)
        return NULL;

    /*
     * OK, we have a potential macro. Count and demarcate the
     * parameters.
     */
    count_mmac_params(tline->next, &nparam, &params);

    /*
     * So we know how many parameters we've got. Find the ExpDef
     * structure that handles this number.
     */
    while (ed) {
        if (ed->nparam_min <= nparam
            && (ed->plus || nparam <= ed->nparam_max)) {
            /*
             * It's right, and we can use it. Add its default
             * parameters to the end of our list if necessary.
             */
            if (ed->defaults && nparam < ed->nparam_min + ed->ndefs) {
                params =
                    nasm_realloc(params,
                                 ((ed->nparam_min + ed->ndefs +
                                   1) * sizeof(*params)));
                while (nparam < ed->nparam_min + ed->ndefs) {
                    params[nparam] = ed->defaults[nparam - ed->nparam_min];
                    nparam++;
                }
            }
            /*
             * If we've gone over the maximum parameter count (and
             * we're in Plus mode), ignore parameters beyond
             * nparam_max.
             */
            if (ed->plus && nparam > ed->nparam_max)
                nparam = ed->nparam_max;
            /*
             * Then terminate the parameter list, and leave.
             */
            if (!params) {      /* need this special case */
                params = nasm_malloc(sizeof(*params));
                nparam = 0;
            }
            params[nparam] = NULL;
            *params_array = params;
            return ed;
        }
        /*
         * This one wasn't right: look for the next one with the
         * same name.
         */
        list_for_each(ed, ed->next) {
            if (!mstrcmp(ed->name, tline->text, ed->casesense))
                break;
        }
    }

    /*
     * After all that, we didn't find one with the right number of
     * parameters. Issue a warning, and fail to expand the macro.
     */
    error(ERR_WARNING|ERR_PASS1|ERR_WARN_MNP,
          "macro `%s' exists, but not taking %d parameters",
          tline->text, nparam);
    nasm_free(params);
    return NULL;
}

/*
 * Expand the multi-line macro call made by the given line, if
 * there is one to be expanded. If there is, push the expansion on
 * istk->expansion and return true. Otherwise return false.
 */
static bool expand_mmacro(Token * tline)
{
    Token *label = NULL;
    int dont_prepend = 0;
    Token **params, *t;
    Line *l = NULL;
    ExpDef *ed;
    ExpInv *ei;
    int i, nparam, *paramlen;
    const char *mname;

    t = tline;
    skip_white_(t);
    /*    if (!tok_type_(t, TOK_ID))  Lino 02/25/02 */
    if (!tok_type_(t, TOK_ID) && !tok_type_(t, TOK_PREPROC_ID))
        return false;
    ed = is_mmacro(t, &params);
    if (ed != NULL) {
        mname = t->text;
    } else {
        Token *last;
        /*
         * We have an id which isn't a macro call. We'll assume
         * it might be a label; we'll also check to see if a
         * colon follows it. Then, if there's another id after
         * that lot, we'll check it again for macro-hood.
         */
        label = last = t;
        t = t->next;
        if (tok_type_(t, TOK_WHITESPACE))
            last = t, t = t->next;
        if (tok_is_(t, ":")) {
            dont_prepend = 1;
            last = t, t = t->next;
            if (tok_type_(t, TOK_WHITESPACE))
                last = t, t = t->next;
        }
        if (!tok_type_(t, TOK_ID) || !(ed = is_mmacro(t, &params)))
            return false;
        last->next = NULL;
        mname = t->text;
        tline = t;
    }

    /*
     * Fix up the parameters: this involves stripping leading and
     * trailing whitespace, then stripping braces if they are
     * present.
     */
    for (nparam = 0; params[nparam]; nparam++)
        ;
    paramlen = nparam ? nasm_malloc(nparam * sizeof(*paramlen)) : NULL;

    for (i = 0; params[i]; i++) {
        int brace = false;
        int comma = (!ed->plus || i < nparam - 1);

        t = params[i];
        skip_white_(t);
        if (tok_is_(t, "{"))
            t = t->next, brace = true, comma = false;
        params[i] = t;
        paramlen[i] = 0;
        while (t) {
            if (comma && t->type == TOK_OTHER && !strcmp(t->text, ","))
                break;          /* ... because we have hit a comma */
            if (comma && t->type == TOK_WHITESPACE
                && tok_is_(t->next, ","))
                break;          /* ... or a space then a comma */
            if (brace && t->type == TOK_OTHER && !strcmp(t->text, "}"))
                break;          /* ... or a brace */
            t = t->next;
            paramlen[i]++;
        }
    }

    if (ed->cur_depth >= ed->max_depth) {
        if (ed->max_depth > 1) {
            error(ERR_WARNING,
                  "reached maximum macro recursion depth of %i for %s",
                  ed->max_depth,ed->name);
        }
        return false;
    } else {
        ed->cur_depth ++;
    }

    /*
     * OK, we have found a ExpDef structure representing a
     * previously defined mmacro. Create an expansion invocation
     * and point it back to the expansion definition. Substitution of
     * parameter tokens and macro-local tokens doesn't get done
     * until the single-line macro substitution process; this is
     * because delaying them allows us to change the semantics
     * later through %rotate.
     */
    ei = new_ExpInv(EXP_MMACRO, ed);
    ei->name = nasm_strdup(mname);
    //ei->label = label;
    //ei->label_text = detoken(label, false);
    ei->current = ed->line;
    ei->emitting = true;
    //ei->iline = tline;
    ei->params = params;
    ei->nparam = nparam;
    ei->rotate = 0;
    ei->paramlen = paramlen;
    ei->lineno = 0;

    ei->prev = istk->expansion;
    istk->expansion = ei;

    /*
     * Special case: detect %00 on first invocation; if found,
     * avoid emitting any labels that precede the mmacro call.
     * ed->prepend is set to -1 when %00 is detected, else 1.
     */
    if (ed->prepend == 0) {
        for (l = ed->line; l != NULL; l = l->next) {
            for (t = l->first; t != NULL; t = t->next) {
                if ((t->type == TOK_PREPROC_ID) &&
                    (strlen(t->text) == 3) &&
                    (t->text[1] == '0') && (t->text[2] == '0')) {
                    dont_prepend = -1;
                    break;
                }
            }
            if (dont_prepend < 0)
                break;
        }
        ed->prepend = ((dont_prepend < 0) ? -1 : 1);
    }

    /*
     * If we had a label, push it on as the first line of
     * the macro expansion.
     */
    if (label != NULL) {
        if (ed->prepend < 0) {
            ei->label_text = detoken(label, false);
        } else {
            if (dont_prepend == 0) {
                t = label;
                while (t->next != NULL) {
                    t = t->next;
                }
                t->next = new_Token(NULL, TOK_OTHER, ":", 0);
            }
            l = new_Line();
            l->first = copy_Token(label);
            l->next = ei->current;
            ei->current = l;
        }
    }

    list->uplevel(ed->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);

    istk->mmac_depth++;
    return true;
}

/* The function that actually does the error reporting */
static void verror(int severity, const char *fmt, va_list arg)
{
    char buff[1024];

    vsnprintf(buff, sizeof(buff), fmt, arg);

    if (istk && istk->mmac_depth > 0) {
        ExpInv *ei = istk->expansion;
        int lineno = ei->lineno;
        while (ei) {
            if (ei->type == EXP_MMACRO)
                break;
            lineno += ei->relno;
            ei = ei->prev;
        }
        nasm_error(severity, "(%s:%d) %s", ei->def->name,
                   lineno, buff);
    } else {
        nasm_error(severity, "%s", buff);
    }
}

/*
 * Since preprocessor always operate only on the line that didn't
 * arrived yet, we should always use ERR_OFFBY1.
 */
static void error(int severity, const char *fmt, ...)
{
    va_list arg;
    va_start(arg, fmt);
    verror(severity, fmt, arg);
    va_end(arg);
}

/*
 * Because %else etc are evaluated in the state context
 * of the previous branch, errors might get lost with error():
 *   %if 0 ... %else trailing garbage ... %endif
 * So %else etc should report errors with this function.
 */
static void error_precond(int severity, const char *fmt, ...)
{
    va_list arg;

    /* Only ignore the error if it's really in a dead branch */
    if ((istk != NULL) &&
        (istk->expansion != NULL) &&
        (istk->expansion->type == EXP_IF) &&
        (istk->expansion->def->state == COND_NEVER))
        return;

    va_start(arg, fmt);
    verror(severity, fmt, arg);
    va_end(arg);
}

static void
pp_reset(char *file, int apass, ListGen * listgen, StrList **deplist)
{
    Token *t;

    cstk = NULL;
    istk = nasm_zalloc(sizeof(Include));
    istk->fp = fopen(file, "r");
    src_set_fname(nasm_strdup(file));
    src_set_linnum(0);
    istk->lineinc = 1;
    if (!istk->fp)
        error(ERR_FATAL|ERR_NOFILE, "unable to open input file `%s'",
              file);
    defining = NULL;
    finals = NULL;
    in_final = false;
    nested_mac_count = 0;
    nested_rep_count = 0;
    init_macros();
    unique = 0;
    if (tasm_compatible_mode)
        stdmacpos = nasm_stdmac;
    else
        stdmacpos = nasm_stdmac_after_tasm;
    any_extrastdmac = extrastdmac && *extrastdmac;
    do_predef = true;
    list = listgen;

    /*
     * 0 for dependencies, 1 for preparatory passes, 2 for final pass.
     * The caller, however, will also pass in 3 for preprocess-only so
     * we can set __PASS__ accordingly.
     */
    pass = apass > 2 ? 2 : apass;

    dephead = deptail = deplist;
    if (deplist) {
        StrList *sl = nasm_malloc(strlen(file)+1+sizeof sl->next);
        sl->next = NULL;
        strcpy(sl->str, file);
        *deptail = sl;
        deptail = &sl->next;
    }

    /*
     * Define the __PASS__ macro.  This is defined here unlike
     * all the other builtins, because it is special -- it varies between
     * passes.
     */
    t = nasm_zalloc(sizeof(*t));
    make_tok_num(t, apass);
    define_smacro(NULL, "__PASS__", true, 0, t);
}

static char *pp_getline(void)
{
    char *line;
    Token *tline;
    ExpDef *ed;
    ExpInv *ei;
    Line *l;
    int j;

    while (1) {
        /*
         * Fetch a tokenized line, either from the expansion
         * buffer or from the input file.
         */
        tline = NULL;

        while (1) {             /* until we get a line we can use */
            /*
             * Fetch a tokenized line from the expansion buffer
             */
            if (istk->expansion != NULL) {
                ei = istk->expansion;
                if (ei->current != NULL) {
                    if (ei->emitting == false) {
                        ei->current = NULL;
                        continue;
                    }
                    l = ei->current;
                    ei->current = l->next;
                    ei->lineno++;
                    tline = copy_Token(l->first);
                    if (((ei->type == EXP_REP) ||
                         (ei->type == EXP_MMACRO) ||
                         (ei->type == EXP_WHILE))
                        && (ei->def->nolist == false)) {
                        char *p = detoken(tline, false);
                        list->line(LIST_MACRO, p);
                        nasm_free(p);
                    }
                    if (ei->linnum > -1) {
                        src_set_linnum(src_get_linnum() + 1);
                    }
                    break;
                } else if ((ei->type == EXP_REP) &&
                           (ei->def->cur_depth < ei->def->max_depth)) {
                    ei->def->cur_depth ++;
                    ei->current = ei->def->line;
                    ei->lineno = 0;
                    continue;
                } else if ((ei->type == EXP_WHILE) &&
                           (ei->def->cur_depth < ei->def->max_depth)) {
                    ei->current = ei->def->line;
                    ei->lineno = 0;
                    tline = copy_Token(ei->current->first);
                    j = if_condition(tline, PP_WHILE);
                    tline = NULL;
                    j = (((j < 0) ? COND_NEVER : j) ? COND_IF_TRUE : COND_IF_FALSE);
                    if (j == COND_IF_TRUE) {
                        ei->current = ei->current->next;
                        ei->def->cur_depth ++;
                    } else {
                        ei->emitting = false;
                        ei->current = NULL;
                        ei->def->cur_depth = ei->def->max_depth;
                    }
                    continue;
                } else {
                    istk->expansion = ei->prev;
                    ed = ei->def;
                    if (ed != NULL) {
                        if ((ei->emitting == true) &&
                            (ed->max_depth == DEADMAN_LIMIT) &&
                            (ed->cur_depth == DEADMAN_LIMIT)
                           ) {
                            error(ERR_FATAL, "runaway expansion detected, aborting");
                        }
                        if (ed->cur_depth > 0) {
                            ed->cur_depth --;
                        } else if (ed->type != EXP_MMACRO) {
                            expansions = ed->prev;
                            free_expdef(ed);
                        }
                        if ((ei->type == EXP_REP) ||
                            (ei->type == EXP_MMACRO) ||
                            (ei->type == EXP_WHILE)) {
                            list->downlevel(LIST_MACRO);
                            if (ei->type == EXP_MMACRO) {
                                istk->mmac_depth--;
                            }
                        }
                    }
                    if (ei->linnum > -1) {
                        src_set_linnum(ei->linnum);
                    }
                    free_expinv(ei);
                    continue;
                }
            }

            /*
             * Read in line from input and tokenize
             */
            line = read_line();
            if (line) {         /* from the current input file */
                line = prepreproc(line);
                tline = tokenize(line);
                nasm_free(line);
                break;
            }

            /*
             * The current file has ended; work down the istk
             */
            {
                Include *i = istk;
                fclose(i->fp);
                if (i->expansion != NULL) {
                    error(ERR_FATAL,
                          "end of file while still in an expansion");
                }
                /* only set line and file name if there's a next node */
                if (i->next) {
                    src_set_linnum(i->lineno);
                    nasm_free(src_set_fname(nasm_strdup(i->fname)));
                }
                if ((i->next == NULL) && (finals != NULL)) {
                    in_final = true;
                    ei = new_ExpInv(EXP_FINAL, NULL);
                    ei->emitting = true;
                    ei->current = finals;
                    istk->expansion = ei;
                    finals = NULL;
                    continue;
                }
                istk = i->next;
                list->downlevel(LIST_INCLUDE);
                nasm_free(i);
                if (istk == NULL) {
                    if (finals != NULL)
                        in_final = true;
                    else
                        return NULL;
                }
                continue;
            }
        }

        if (defining == NULL)
            tline = expand_mmac_params(tline);

        /*
         * Check the line to see if it's a preprocessor directive.
         */
        if (do_directive(tline) == DIRECTIVE_FOUND) {
            continue;
        } else if (defining != NULL) {
            /*
             * We're defining an expansion. We emit nothing at all,
             * and just shove the tokenized line on to the definition.
             */
            if (defining->ignoring == false) {
                Line *l = new_Line();
                l->first = tline;
                if (defining->line == NULL) {
                    defining->line = l;
                    defining->last = l;
                } else {
                    defining->last->next = l;
                    defining->last = l;
                }
            } else {
                free_tlist(tline);
            }
            defining->linecount++;
            continue;
        } else if ((istk->expansion != NULL) &&
                   (istk->expansion->emitting != true)) {
            /*
             * We're in a non-emitting branch of an expansion.
             * Emit nothing at all, not even a blank line: when we
             * emerge from the expansion we'll give a line-number
             * directive so we keep our place correctly.
             */
            free_tlist(tline);
            continue;
        } else {
            tline = expand_smacro(tline);
            if (expand_mmacro(tline) != true) {
                /*
                 * De-tokenize the line again, and emit it.
                 */
                line = detoken(tline, true);
                free_tlist(tline);
                break;
            } else {
                continue;
            }
        }
    }
    return line;
}

static void pp_cleanup(int pass)
{
    if (defining != NULL) {
        error(ERR_NONFATAL, "end of file while still defining an expansion");
        while (defining != NULL) {
            ExpDef *ed = defining;
            defining = ed->prev;
            free_expdef(ed);
        }
        defining = NULL;
    }
    while (cstk != NULL)
        ctx_pop();
    free_macros();
    while (istk != NULL) {
        Include *i = istk;
        istk = istk->next;
        fclose(i->fp);
        nasm_free(i->fname);
        while (i->expansion != NULL) {
            ExpInv *ei = i->expansion;
            i->expansion = ei->prev;
            free_expinv(ei);
        }
        nasm_free(i);
    }
    while (cstk)
        ctx_pop();
    nasm_free(src_set_fname(NULL));
    if (pass == 0) {
        IncPath *i;
        free_llist(predef);
        delete_Blocks();
        while ((i = ipath)) {
            ipath = i->next;
            nasm_free(i->path);
            nasm_free(i);
        }
    }
}

void pp_include_path(char *path)
{
    IncPath *i = nasm_zalloc(sizeof(IncPath));

    if (path)
        i->path = nasm_strdup(path);

    if (ipath) {
        IncPath *j = ipath;
        while (j->next)
            j = j->next;
        j->next = i;
    } else {
        ipath = i;
    }
}

void pp_pre_include(char *fname)
{
    Token *inc, *space, *name;
    Line *l;

    name = new_Token(NULL, TOK_INTERNAL_STRING, fname, 0);
    space = new_Token(name, TOK_WHITESPACE, NULL, 0);
    inc = new_Token(space, TOK_PREPROC_ID, "%include", 0);

    l = new_Line();
    l->next = predef;
    l->first = inc;
    predef = l;
}

void pp_pre_define(char *definition)
{
    Token *def, *space;
    Line *l;
    char *equals;

    equals = strchr(definition, '=');
    space = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
    def = new_Token(space, TOK_PREPROC_ID, "%define", 0);
    if (equals)
        *equals = ' ';
    space->next = tokenize(definition);
    if (equals)
        *equals = '=';

    l = new_Line();
    l->next = predef;
    l->first = def;
    predef = l;
}

void pp_pre_undefine(char *definition)
{
    Token *def, *space;
    Line *l;

    space = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
    def = new_Token(space, TOK_PREPROC_ID, "%undef", 0);
    space->next = tokenize(definition);

    l = new_Line();
    l->next = predef;
    l->first = def;
    predef = l;
}

/*
 * This function is used to assist with "runtime" preprocessor
 * directives, e.g. pp_runtime("%define __BITS__ 64");
 *
 * ERRORS ARE IGNORED HERE, SO MAKE COMPLETELY SURE THAT YOU
 * PASS A VALID STRING TO THIS FUNCTION!!!!!
 */

void pp_runtime(char *definition)
{
    Token *def;

    def = tokenize(definition);
    if (do_directive(def) == NO_DIRECTIVE_FOUND)
        free_tlist(def);

}

void pp_extra_stdmac(macros_t *macros)
{
    extrastdmac = macros;
}

static void make_tok_num(Token * tok, int64_t val)
{
    char numbuf[20];
    snprintf(numbuf, sizeof(numbuf), "%"PRId64"", val);
    tok->text = nasm_strdup(numbuf);
    tok->type = TOK_NUMBER;
}

struct preproc_ops nasmpp = {
    pp_reset,
    pp_getline,
    pp_cleanup
};
