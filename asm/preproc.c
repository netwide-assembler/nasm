/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2019 The NASM Authors - All Rights Reserved
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

#include "nctype.h"

#include "nasm.h"
#include "nasmlib.h"
#include "error.h"
#include "preproc.h"
#include "hashtbl.h"
#include "quote.h"
#include "stdscan.h"
#include "eval.h"
#include "tokens.h"
#include "tables.h"
#include "listing.h"

typedef struct SMacro SMacro;
typedef struct MMacro MMacro;
typedef struct MMacroInvocation MMacroInvocation;
typedef struct Context Context;
typedef struct Token Token;
typedef struct Blocks Blocks;
typedef struct Line Line;
typedef struct Include Include;
typedef struct Cond Cond;

/*
 * Note on the storage of both SMacro and MMacros: the hash table
 * indexes them case-insensitively, and we then have to go through a
 * linked list of potential case aliases (and, for MMacros, parameter
 * ranges); this is to preserve the matching semantics of the earlier
 * code.  If the number of case aliases for a specific macro is a
 * performance issue, you may want to reconsider your coding style.
 */

/*
 * Function call tp obtain the expansion of an smacro
 */
typedef Token *(*ExpandSMacro)(const SMacro *s, Token **params, int nparams);

/*
 * Store the definition of a single-line macro.
 */
enum sparmflags {
    SPARM_EVAL    = 1,      /* Evaluate as a numeric expression (=) */
    SPARM_STR     = 2,      /* Convert to quoted string ($) */
    SPARM_NOSTRIP = 4,      /* Don't strip braces (!) */
    SPARM_GREEDY  = 8       /* Greedy final parameter (+) */
};

struct smac_param {
    char *name;
    int namelen;
    enum sparmflags flags;
};

struct SMacro {
    SMacro *next;               /* MUST BE FIRST - see free_smacro() */
    char *name;
    Token *expansion;
    ExpandSMacro expand;
    intorptr expandpvt;
    struct smac_param *params;
    int nparam;
    bool greedy;
    bool casesense;
    bool in_progress;
    bool alias;                 /* This is an alias macro */
};

/*
 * Store the definition of a multi-line macro. This is also used to
 * store the interiors of `%rep...%endrep' blocks, which are
 * effectively self-re-invoking multi-line macros which simply
 * don't have a name or bother to appear in the hash tables. %rep
 * blocks are signified by having a NULL `name' field.
 *
 * In a MMacro describing a `%rep' block, the `in_progress' field
 * isn't merely boolean, but gives the number of repeats left to
 * run.
 *
 * The `next' field is used for storing MMacros in hash tables; the
 * `next_active' field is for stacking them on istk entries.
 *
 * When a MMacro is being expanded, `params', `iline', `nparam',
 * `paramlen', `rotate' and `unique' are local to the invocation.
 */

/*
 * Expansion stack. Note that .mmac can point back to the macro itself,
 * whereas .mstk cannot.
 */
struct mstk {
    MMacro *mstk;               /* Any expansion, real macro or not */
    MMacro *mmac;               /* Highest level actual mmacro */
};

struct MMacro {
    MMacro *next;
#if 0
    MMacroInvocation *prev;     /* previous invocation */
#endif
    char *name;
    int nparam_min, nparam_max;
    bool casesense;
    bool plus;                  /* is the last parameter greedy? */
    bool nolist;                /* is this macro listing-inhibited? */
    bool capture_label;         /* macro definition has %00; capture label */
    int32_t in_progress;        /* is this macro currently being expanded? */
    int32_t max_depth;          /* maximum number of recursive expansions allowed */
    Token *dlist;               /* All defaults as one list */
    Token **defaults;           /* Parameter default pointers */
    int ndefs;                  /* number of default parameters */
    Line *expansion;

    struct mstk mstk;           /* Macro expansion stack */
    struct mstk dstk;           /* Macro definitions stack */
    Token **params;             /* actual parameters */
    Token *iline;               /* invocation line */
    unsigned int nparam, rotate;
    char *iname;                /* name invoked as */
    int *paramlen;
    uint64_t unique;
    int lineno;                 /* Current line number on expansion */
    uint64_t condcnt;           /* number of if blocks... */

    const char *fname;		/* File where defined */
    int32_t xline;		/* First line in macro */
};


/* Store the definition of a multi-line macro, as defined in a
 * previous recursive macro expansion.
 */
#if 0

struct MMacroInvocation {
    MMacroInvocation *prev;     /* previous invocation */
    Token **params;             /* actual parameters */
    Token *iline;               /* invocation line */
    unsigned int nparam, rotate;
    int *paramlen;
    uint64_t unique;
    uint64_t condcnt;
};

#endif

/*
 * The context stack is composed of a linked list of these.
 */
struct Context {
    Context *next;
    char *name;
    struct hash_table localmac;
    uint64_t number;
    unsigned int depth;
};

/*
 * This is the internal form which we break input lines up into.
 * Typically stored in linked lists.
 *
 * Note that `type' serves a double meaning: TOK_SMAC_START_PARAMS is
 * not necessarily used as-is, but is also used to encode the number
 * and expansion type of substituted parameter. So in the definition
 *
 *     %define a(x,=y) ( (x) & ~(y) )
 *
 * the token representing `x' will have its type changed to
 * tok_smac_param(0) but the one representing `y' will be
 * tok_smac_param(1); see the accessor functions below.
 *
 * TOK_INTERNAL_STRING is a dirty hack: it's a single string token
 * which doesn't need quotes around it. Used in the pre-include
 * mechanism as an alternative to trying to find a sensible type of
 * quote to use on the filename we were passed.
 */
enum pp_token_type {
    TOK_NONE = 0, TOK_WHITESPACE, TOK_COMMENT, TOK_ID,
    TOK_PREPROC_ID, TOK_STRING,
    TOK_NUMBER, TOK_FLOAT, TOK_OTHER,
    TOK_INTERNAL_STRING,
    TOK_PREPROC_Q, TOK_PREPROC_QQ,
    TOK_PASTE,              /* %+ */
    TOK_INDIRECT,           /* %[...] */
    TOK_SMAC_START_PARAMS,  /* MUST BE LAST IN THE LIST!!! */
    TOK_MAX = INT_MAX       /* Keep compiler from reducing the range */
};

static inline enum pp_token_type tok_smac_param(int param)
{
    return TOK_SMAC_START_PARAMS + param;
}
static int smac_nparam(enum pp_token_type toktype)
{
    return toktype - TOK_SMAC_START_PARAMS;
}
static bool is_smac_param(enum pp_token_type toktype)
{
    return toktype >= TOK_SMAC_START_PARAMS;
}

#define PP_CONCAT_MASK(x) (1 << (x))
#define PP_CONCAT_MATCH(t, mask) (PP_CONCAT_MASK((t)->type) & mask)

struct tokseq_match {
    int mask_head;
    int mask_tail;
};

struct Token {
    Token *next;
    char *text;
    size_t len;
    enum pp_token_type type;
};

/*
 * Multi-line macro definitions are stored as a linked list of
 * these, which is essentially a container to allow several linked
 * lists of Tokens.
 *
 * Note that in this module, linked lists are treated as stacks
 * wherever possible. For this reason, Lines are _pushed_ on to the
 * `expansion' field in MMacro structures, so that the linked list,
 * if walked, would give the macro lines in reverse order; this
 * means that we can walk the list when expanding a macro, and thus
 * push the lines on to the `expansion' field in _istk_ in reverse
 * order (so that when popped back off they are in the right
 * order). It may seem cockeyed, and it relies on my design having
 * an even number of steps in, but it works...
 *
 * Some of these structures, rather than being actual lines, are
 * markers delimiting the end of the expansion of a given macro.
 * This is for use in the cycle-tracking and %rep-handling code.
 * Such structures have `finishes' non-NULL, and `first' NULL. All
 * others have `finishes' NULL, but `first' may still be NULL if
 * the line is blank.
 */
struct Line {
    Line *next;
    MMacro *finishes;
    Token *first;
};

/*
 * To handle an arbitrary level of file inclusion, we maintain a
 * stack (ie linked list) of these things.
 */
struct Include {
    Include *next;
    FILE *fp;
    Cond *conds;
    Line *expansion;
    const char *fname;
    struct mstk mstk;
    int lineno, lineinc;
    bool nolist;
};

/*
 * File real name hash, so we don't have to re-search the include
 * path for every pass (and potentially more than that if a file
 * is used more than once.)
 */
struct hash_table FileHash;

/*
 * Counters to trap on insane macro recursion or processing.
 * Note: for smacros these count *down*, for mmacros they count *up*.
 */
struct deadman {
    int64_t total;              /* Total number of macros/tokens */
    int64_t levels;             /* Descent depth across all macros */
    bool triggered;             /* Already triggered, no need for error msg */
};

static struct deadman smacro_deadman, mmacro_deadman;

/*
 * Conditional assembly: we maintain a separate stack of these for
 * each level of file inclusion. (The only reason we keep the
 * stacks separate is to ensure that a stray `%endif' in a file
 * included from within the true branch of a `%if' won't terminate
 * it and cause confusion: instead, rightly, it'll cause an error.)
 */
enum cond_state {
    /*
     * These states are for use just after %if or %elif: IF_TRUE
     * means the condition has evaluated to truth so we are
     * currently emitting, whereas IF_FALSE means we are not
     * currently emitting but will start doing so if a %else comes
     * up. In these states, all directives are admissible: %elif,
     * %else and %endif. (And of course %if.)
     */
    COND_IF_TRUE, COND_IF_FALSE,
    /*
     * These states come up after a %else: ELSE_TRUE means we're
     * emitting, and ELSE_FALSE means we're not. In ELSE_* states,
     * any %elif or %else will cause an error.
     */
    COND_ELSE_TRUE, COND_ELSE_FALSE,
    /*
     * These states mean that we're not emitting now, and also that
     * nothing until %endif will be emitted at all. COND_DONE is
     * used when we've had our moment of emission
     * and have now started seeing %elifs. COND_NEVER is used when
     * the condition construct in question is contained within a
     * non-emitting branch of a larger condition construct,
     * or if there is an error.
     */
    COND_DONE, COND_NEVER
};
struct Cond {
    Cond *next;
    enum cond_state state;
};
#define emitting(x) ( (x) == COND_IF_TRUE || (x) == COND_ELSE_TRUE )

/*
 * These defines are used as the possible return values for do_directive
 */
#define NO_DIRECTIVE_FOUND  0
#define DIRECTIVE_FOUND     1

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

/*
 * Directive names.
 */
/* If this is a an IF, ELIF, ELSE or ENDIF keyword */
static int is_condition(enum preproc_token arg)
{
    return PP_IS_COND(arg) || (arg == PP_ELSE) || (arg == PP_ENDIF);
}

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
static const char *StackPointer = "ebp";
static int ArgOffset = 8;
static int LocalOffset = 0;

static Context *cstk;
static Include *istk;
static const struct strlist *ipath_list;

static struct strlist *deplist;

static uint64_t unique;     /* unique identifier numbers */

static Line *predef = NULL;
static bool do_predef;
static enum preproc_mode pp_mode;

/*
 * The current set of multi-line macros we have defined.
 */
static struct hash_table mmacros;

/*
 * The current set of single-line macros we have defined.
 */
static struct hash_table smacros;

/*
 * The multi-line macro we are currently defining, or the %rep
 * block we are currently reading, if any.
 */
static MMacro *defining;

static uint64_t nested_mac_count;
static uint64_t nested_rep_count;

/*
 * The number of macro parameters to allocate space for at a time.
 */
#define PARAM_DELTA 16

/*
 * The standard macro set: defined in macros.c in a set of arrays.
 * This gives our position in any macro set, while we are processing it.
 * The stdmacset is an array of such macro sets.
 */
static macros_t *stdmacpos;
static macros_t **stdmacnext;
static macros_t *stdmacros[8];
static macros_t *extrastdmac;

/*
 * Map of which %use packages have been loaded
 */
static bool *use_loaded;

/*
 * Tokens are allocated in blocks to improve speed
 */
#define TOKEN_BLOCKSIZE 4096
static Token *freeTokens = NULL;
struct Blocks {
    Blocks *next;
    void *chunk;
};

static Blocks blocks = { NULL, NULL };

/*
 * Forward declarations.
 */
static void pp_add_stdmac(macros_t *macros);
static Token *expand_mmac_params(Token * tline);
static Token *expand_smacro(Token * tline);
static Token *expand_id(Token * tline);
static Context *get_ctx(const char *name, const char **namep);
static Token *make_tok_num(int64_t val);
static Token *make_tok_qstr(const char *str);
static void pp_verror(errflags severity, const char *fmt, va_list ap);
static vefunc real_verror;
static void *new_Block(size_t size);
static void delete_Blocks(void);
static Token *new_Token(Token * next, enum pp_token_type type,
                        const char *text, size_t txtlen);
static Token *dup_Token(Token *next, const Token *src);
static Token *delete_Token(Token * t);

/*
 * Macros for safe checking of token pointers, avoid *(NULL)
 */
#define tok_type_(x,t)  ((x) && (x)->type == (t))
#define skip_white_(x)  if (tok_type_((x), TOK_WHITESPACE)) (x)=(x)->next
#define tok_is_(x,v)    (tok_type_((x), TOK_OTHER) && !strcmp((x)->text,(v)))
#define tok_isnt_(x,v)  ((x) && ((x)->type!=TOK_OTHER || strcmp((x)->text,(v))))

/*
 * In-place reverse a list of tokens.
 */
static Token *reverse_tokens(Token *t)
{
    Token *prev = NULL;
    Token *next;

    while (t) {
        next = t->next;
        t->next = prev;
        prev = t;
        t = next;
    }

    return prev;
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
 * Free an array of linked lists of tokens
 */
static void free_tlist_array(Token **array, size_t nlists)
{
    Token **listp = array;

    while (nlists--)
        free_tlist(*listp++);

    nasm_free(array);
}

/*
 * Duplicate a linked list of tokens.
 */
static Token *dup_tlist(const Token *list, Token ***tailp)
{
    Token *newlist = NULL;
    Token **tailpp = &newlist;
    const Token *t;

    list_for_each(t, list) {
        Token *nt;
        *tailpp = nt = dup_Token(NULL, t);
        tailpp = &nt->next;
    }

    if (tailp) {
        **tailp = newlist;
        *tailp = tailpp;
    }

    return newlist;
}

/*
 * Duplicate a linked list of tokens with a maximum count
 */
static Token *dup_tlistn(const Token *list, size_t cnt, Token ***tailp)
{
    Token *newlist = NULL;
    Token **tailpp = &newlist;
    const Token *t;

    list_for_each(t, list) {
        Token *nt;
        if (!cnt--)
            break;
        *tailpp = nt = dup_Token(NULL, t);
        tailpp = &nt->next;
    }

    if (tailp) {
        **tailp = newlist;
        *tailp = tailpp;
    }

    return newlist;
}

/*
 * Duplicate a linked list of tokens in reverse order
 */
static Token *dup_tlist_reverse(const Token *list, Token *tail)
{
    const Token *t;

    list_for_each(t, list)
        tail = dup_Token(tail, t);

    return tail;
}

/*
 * Free an MMacro
 */
static void free_mmacro(MMacro * m)
{
    nasm_free(m->name);
    free_tlist(m->dlist);
    nasm_free(m->defaults);
    free_llist(m->expansion);
    nasm_free(m);
}

/*
 * Clear or free an SMacro
 */
static void free_smacro_members(SMacro *s)
{
    if (s->params) {
        int i;
        for (i = 0; s->nparam; i++)
            nasm_free(s->params[i].name);
        nasm_free(s->params);
    }
    nasm_free(s->name);
    free_tlist(s->expansion);
}

static void clear_smacro(SMacro *s)
{
    free_smacro_members(s);
    /* Wipe everything except the next pointer */
    memset(&s->next + 1, 0, sizeof *s - sizeof s->next);
}

/*
 * Free an SMacro
 */
static void free_smacro(SMacro *s)
{
    free_smacro_members(s);
    nasm_free(s);
}

/*
 * Free all currently defined macros, and free the hash tables
 */
static void free_smacro_table(struct hash_table *smt)
{
    struct hash_iterator it;
    const struct hash_node *np;

    hash_for_each(smt, it, np) {
        SMacro *tmp;
        SMacro *s = np->data;
        nasm_free((void *)np->key);
        list_for_each_safe(s, tmp, s)
            free_smacro(s);
    }
    hash_free(smt);
}

static void free_mmacro_table(struct hash_table *mmt)
{
    struct hash_iterator it;
    const struct hash_node *np;

    hash_for_each(mmt, it, np) {
        MMacro *tmp;
        MMacro *m = np->data;
        nasm_free((void *)np->key);
        list_for_each_safe(m, tmp, m)
            free_mmacro(m);
    }
    hash_free(mmt);
}

static void free_macros(void)
{
    free_smacro_table(&smacros);
    free_mmacro_table(&mmacros);
}

/*
 * Initialize the hash tables
 */
static void init_macros(void)
{
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
    size_t l = strlen(str) + 1;

    r = hash_findib(hash, str, l, &hi);
    if (r)
        return r;

    strx = nasm_malloc(l);  /* Use a more efficient allocator here? */
    memcpy(strx, str, l);
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
 * read line from standart macros set,
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

    /*
     * 32-126 is ASCII, 127 is end of line, 128-31 are directives
     * (allowed to wrap around) corresponding to PP_* tokens 0-159.
     */
    while ((c = *p++) != 127) {
        uint8_t ndir = c - 128;
        if (ndir < 256-96)
            len += pp_directives_len[ndir] + 1;
        else
            len++;
    }

    line = nasm_malloc(len + 1);
    q = line;

    while ((c = *stdmacpos++) != 127) {
        uint8_t ndir = c - 128;
        if (ndir < 256-96) {
            memcpy(q, pp_directives[ndir], pp_directives_len[ndir]);
            q += pp_directives_len[ndir];
            *q++ = ' ';
        } else {
            *q++ = c;
        }
    }
    stdmacpos = p;
    *q = '\0';

    if (*stdmacpos == 127) {
        /* This was the last of this particular macro set */
        stdmacpos = NULL;
        if (*stdmacnext) {
            stdmacpos = *stdmacnext++;
        } else if (do_predef) {
            Line *pd, *l;

            /*
             * Nasty hack: here we push the contents of
             * `predef' on to the top-level expansion stack,
             * since this is the most convenient way to
             * implement the pre-include and pre-define
             * features.
             */
            list_for_each(pd, predef) {
                nasm_new(l);
                l->next     = istk->expansion;
                l->first    = dup_tlist(pd->first, NULL);
                l->finishes = NULL;

                istk->expansion = l;
            }
            do_predef = false;
        }
    }

    return line;
}

/*
 * Read a line from a file. Return NULL on end of file.
 */
static char *line_from_file(FILE *f)
{
    int c;
    unsigned int size, next;
    const unsigned int delta = 512;
    const unsigned int pad = 8;
    unsigned int nr_cont = 0;
    bool cont = false;
    char *buffer, *p;
    int32_t lineno;

    size = delta;
    p = buffer = nasm_malloc(size);

    do {
        c = fgetc(f);

        switch (c) {
        case EOF:
            if (p == buffer) {
                nasm_free(buffer);
                return NULL;
            }
            c = 0;
            break;

        case '\r':
            next = fgetc(f);
            if (next != '\n')
                ungetc(next, f);
            if (cont) {
                cont = false;
                continue;
            }
            c = 0;
            break;

        case '\n':
            if (cont) {
                cont = false;
                continue;
            }
            c = 0;
            break;

        case 032:               /* ^Z = legacy MS-DOS end of file mark */
            c = 0;
            break;

        case '\\':
            next = fgetc(f);
            ungetc(next, f);
            if (next == '\r' || next == '\n') {
                cont = true;
                nr_cont++;
                continue;
            }
            break;
        }

        if (p >= (buffer + size - pad)) {
            buffer = nasm_realloc(buffer, size + delta);
            p = buffer + size - pad;
            size += delta;
        }

        *p++ = c;
    } while (c);

    lineno = src_get_linnum() + istk->lineinc +
        (nr_cont * istk->lineinc);
    src_set_linnum(lineno);

    return buffer;
}

/*
 * Common read routine regardless of source
 */
static char *read_line(void)
{
    char *line;
    FILE *f = istk->fp;

    if (f)
        line = line_from_file(f);
    else
        line = line_from_stdmac();

    if (!line)
        return NULL;

   if (!istk->nolist)
       lfmt->line(LIST_READ, src_get_linnum(), line);

    return line;
}

/*
 * Tokenize a line of text. This is a very simple process since we
 * don't need to parse the value out of e.g. numeric tokens: we
 * simply split one string into many.
 */
static Token *tokenize(char *line)
{
    char c;
    enum pp_token_type type;
    Token *list = NULL;
    Token *t, **tail = &list;

    while (*line) {
        char *p = line;
        char *ep = NULL;      /* End of token, for trimming the end */

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
                while (*p) {
                    if (*p == '}')
                        break;
                    p[-1] = *p;
                    p++;
                }
                if (*p != '}')
                    nasm_warn(WARN_OTHER, "unterminated %%{ construct");
                ep = &p[-1];
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
                        p = nasm_skip_string(p - 1);
                        if (*p)
                            p++;
                        break;
                    default:
                        break;
                    }
                }
                p--;
                ep = p;
                if (*p)
                    p++;
                if (lvl)
                    nasm_nonfatalf(ERR_PASS1, "unterminated %%[ construct");
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
                if (nasm_isidchar(*p)) {
                    do {
                        p++;
                    }
                    while (nasm_isidchar(*p));
                } else if (nasm_isquote(*p)) {
                    p = nasm_skip_string(p);
                    if (*p)
                        p++;
                    else
                        nasm_nonfatalf(ERR_PASS1, "unterminated %%! string");
                } else {
                    /* %! without string or identifier */
                    type = TOK_OTHER; /* Legacy behavior... */
                }
            } else if (nasm_isidchar(*p) ||
                       ((*p == '!' || *p == '%' || *p == '$') &&
                        nasm_isidchar(p[1]))) {
                do {
                    p++;
                }
                while (nasm_isidchar(*p));
                type = TOK_PREPROC_ID;
            } else {
                type = TOK_OTHER;
                if (*p == '%')
                    p++;
            }
        } else if (nasm_isidstart(*p) || (*p == '$' && nasm_isidstart(p[1]))) {
            type = TOK_ID;
            p++;
            while (*p && nasm_isidchar(*p))
                p++;
        } else if (nasm_isquote(*p)) {
            /*
             * A string token.
             */
            type = TOK_STRING;
            p = nasm_skip_string(p);

            if (*p) {
                p++;
            } else {
                nasm_warn(WARN_OTHER, "unterminated string");
                /* Handling unterminated strings by UNV */
                /* type = -1; */
            }
        } else if (p[0] == '$' && p[1] == '$') {
            type = TOK_OTHER;   /* TOKEN_BASE */
            p += 2;
        } else if (nasm_isnumstart(*p)) {
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
                } else if (nasm_isnumchar(c))
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
            if (!ep)
                ep = p;
            *tail = t = new_Token(NULL, type, line, ep - line);
            tail = &t->next;
        }
        line = p;
    }
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
        if (b->chunk)
            nasm_free(b->chunk);
        a = b;
        b = b->next;
        if (a != &blocks)
            nasm_free(a);
    }
    memset(&blocks, 0, sizeof(blocks));
}

/*
 *  this function creates a new Token and passes a pointer to it
 *  back to the caller.  It sets the type, text, and next pointer elements.
 */
static Token *new_Token(Token * next, enum pp_token_type type,
                        const char *text, size_t txtlen)
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
    t->type = type;
    if (type == TOK_WHITESPACE || !text) {
        t->len  = 0;
        t->text = NULL;
    } else {
        if (txtlen == 0 && text[0])
            txtlen = strlen(text);
        t->len = txtlen;
        t->text = nasm_malloc(txtlen+1);
        memcpy(t->text, text, txtlen);
        t->text[txtlen] = '\0';
    }
    return t;
}

static Token *dup_Token(Token *next, const Token *src)
{
    return new_Token(next, src->type, src->text, src->len);
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
    int len = 0;

    list_for_each(t, tlist) {
        if (t->type == TOK_PREPROC_ID && t->text &&
            t->text[0] == '%' && t->text[1] == '!') {
            char *v;
            char *q = t->text;

            v = t->text + 2;
            if (nasm_isquote(*v))
                 nasm_unquote_cstr(v, NULL);

            if (v) {
                char *p = getenv(v);
                if (!p) {
                    /*!
                     *!environment [on] nonexistent environment variable
                     *!  warns if a nonexistent environment variable
                     *!  is accessed using the \c{%!} preprocessor
                     *!  construct (see \k{getenv}.)  Such environment
                     *!  variables are treated as empty (with this
                     *!  warning issued) starting in NASM 2.15;
                     *!  earlier versions of NASM would treat this as
                     *!  an error.
                     */
                    nasm_warn(WARN_ENVIRONMENT, "nonexistent environment variable `%s'", v);
                    p = "";
                }
                t->text = nasm_strdup(p);
                t->len = nasm_last_string_len();
		nasm_free(q);
            }
        }

        /* Expand local macros here and not during preprocessing */
        if (expand_locals &&
            t->type == TOK_PREPROC_ID && t->text &&
            t->text[0] == '%' && t->text[1] == '$') {
            const char *q;
            char *p;
            Context *ctx = get_ctx(t->text, &q);
            if (ctx) {
                p = nasm_asprintf("..@%"PRIu64".%s", ctx->number, q);
                t->len = nasm_last_string_len();
                nasm_free(t->text);
                t->text = p;
            }
        }
        if (t->text) {
            if (debug_level(2)) {
                unsigned long t_len = t->len;
                unsigned long s_len = strlen(t->text);
                if (t_len != s_len) {
                    nasm_panic("assertion failed: token \"%s\" type %u len %lu has t->len %lu\n",
                               t->text, t->type, s_len, t_len);
                    t->len = s_len;
                }
            }
            len += t->len;
        } else if (t->type == TOK_WHITESPACE) {
            len++;
        }
    }

    p = line = nasm_malloc(len + 1);

    list_for_each(t, tlist) {
        if (t->text) {
            memcpy(p, t->text, t->len);
            p += t->len;
        } else if (t->type == TOK_WHITESPACE) {
            *p++ = ' ';
        }
    }
    *p = '\0';

    return line;
}

/*
 * A scanner, suitable for use by the expression evaluator, which
 * operates on a line of Tokens. Expects a pointer to a pointer to
 * the first token in the line to be passed in as its private_data
 * field.
 *
 * FIX: This really needs to be unified with stdscan.
 */
struct ppscan {
    Token *tptr;
    int ntokens;
};

static int ppscan(void *private_data, struct tokenval *tokval)
{
    struct ppscan *pps = private_data;
    Token *tline;
    char ourcopy[MAX_KEYWORD+1], *p, *r, *s;

    do {
	if (pps->ntokens && (tline = pps->tptr)) {
	    pps->ntokens--;
	    pps->tptr = tline->next;
	} else {
	    pps->tptr = NULL;
	    pps->ntokens = 0;
	    return tokval->t_type = TOKEN_EOS;
	}
    } while (tline->type == TOK_WHITESPACE || tline->type == TOK_COMMENT);

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
        nasm_nonfatal("`%s': context stack is empty", name);
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
        nasm_nonfatal("`%s': context stack is only"
                      " %d level%s deep", name, i, (i == 1 ? "" : "s"));
        return NULL;
    }

    if (namep)
        *namep = name;

    return ctx;
}

/*
 * Open an include file. This routine must always return a valid
 * file pointer if it returns - it's responsible for throwing an
 * ERR_FATAL and bombing out completely if not. It should also try
 * the include path one by one until it finds the file or reaches
 * the end of the path.
 *
 * Note: for INC_PROBE the function returns NULL at all times;
 * instead look for the
 */
enum incopen_mode {
    INC_NEEDED,                 /* File must exist */
    INC_OPTIONAL,               /* Missing is OK */
    INC_PROBE                   /* Only an existence probe */
};

/* This is conducts a full pathname search */
static FILE *inc_fopen_search(const char *file, char **slpath,
                              enum incopen_mode omode, enum file_flags fmode)
{
    const struct strlist_entry *ip = strlist_head(ipath_list);
    FILE *fp;
    const char *prefix = "";
    char *sp;
    bool found;

    while (1) {
        sp = nasm_catfile(prefix, file);
        if (omode == INC_PROBE) {
            fp = NULL;
            found = nasm_file_exists(sp);
        } else {
            fp = nasm_open_read(sp, fmode);
            found = (fp != NULL);
        }
        if (found) {
            *slpath = sp;
            return fp;
        }

        nasm_free(sp);

        if (!ip) {
            *slpath = NULL;
            return NULL;
        }

        prefix = ip->str;
        ip = ip->next;
    }
}

/*
 * Open a file, or test for the presence of one (depending on omode),
 * considering the include path.
 */
static FILE *inc_fopen(const char *file,
                       struct strlist *dhead,
                       const char **found_path,
                       enum incopen_mode omode,
                       enum file_flags fmode)
{
    struct hash_insert hi;
    void **hp;
    char *path;
    FILE *fp = NULL;

    hp = hash_find(&FileHash, file, &hi);
    if (hp) {
        path = *hp;
        if (path || omode != INC_NEEDED) {
            strlist_add(dhead, path ? path : file);
        }
    } else {
        /* Need to do the actual path search */
        fp = inc_fopen_search(file, &path, omode, fmode);

        /* Positive or negative result */
        hash_add(&hi, nasm_strdup(file), path);

        /*
         * Add file to dependency path.
         */
        if (path || omode != INC_NEEDED)
            strlist_add(dhead, file);
    }

    if (!path) {
        if (omode == INC_NEEDED)
            nasm_fatal("unable to open include file `%s'", file);
    } else {
        if (!fp && omode != INC_PROBE)
            fp = nasm_open_read(path, fmode);
    }

    if (found_path)
        *found_path = path;

    return fp;
}

/*
 * Opens an include or input file. Public version, for use by modules
 * that get a file:lineno pair and need to look at the file again
 * (e.g. the CodeView debug backend). Returns NULL on failure.
 */
FILE *pp_input_fopen(const char *filename, enum file_flags mode)
{
    return inc_fopen(filename, NULL, NULL, INC_OPTIONAL, mode);
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
            (nparam <= 0 || m->nparam == 0 || nparam == m->nparam ||
             (m->greedy && nparam > m->nparam))) {
            if (defn) {
                *defn = (nparam == m->nparam || nparam == -1) ? m : NULL;
            }
            return true;
        }
        m = m->next;
    }

    return false;
}

/* param should be a natural number [0; INT_MAX] */
static int read_param_count(const char *str)
{
    int result;
    bool err;

    result = readnum(str, &err);
    if (result < 0 || result > INT_MAX) {
        result = 0;
        nasm_nonfatal("parameter count `%s' is out of bounds [%d; %d]",
                      str, 0, INT_MAX);
    } else if (err)
        nasm_nonfatal("unable to parse parameter count `%s'", str);
    return result;
}

/*
 * Count and mark off the parameters in a multi-line macro call.
 * This is called both from within the multi-line macro expansion
 * code, and also to mark off the default parameters when provided
 * in a %macro definition line.
 *
 * Note that we need space in the params array for parameter 0 being
 * a possible captured label as well as the final NULL.
 */
static void count_mmac_params(Token * t, int *nparamp, Token ***paramsp)
{
    int paramsize, brace;
    int nparam = 0;
    Token **params;

    paramsize = PARAM_DELTA;
    params = nasm_malloc(paramsize * sizeof(*params));
    params[0] = NULL;

    while (t) {
        /* 2 slots for captured label and NULL */
        if (nparam+2 >= paramsize) {
            paramsize += PARAM_DELTA;
            params = nasm_realloc(params, sizeof(*params) * paramsize);
        }
        skip_white_(t);
        brace = 0;
        if (tok_is_(t, "{"))
            brace++;
        params[++nparam] = t;
        if (brace) {
            while (brace && (t = t->next) != NULL) {
                if (tok_is_(t, "{"))
                    brace++;
                else if (tok_is_(t, "}"))
                    brace--;
            }

            if (t) {
                /*
                 * Now we've found the closing brace, look further
                 * for the comma.
                 */
                t = t->next;
                skip_white_(t);
                if (tok_isnt_(t, ",")) {
                    nasm_nonfatal("braces do not enclose all of macro parameter");
                    while (tok_isnt_(t, ","))
                        t = t->next;
                }
            }
        } else {
            while (tok_isnt_(t, ","))
                t = t->next;
        }
        if (t) {                /* got a comma/brace */
            t = t->next;        /* eat the comma */
        }
    }

    params[nparam+1] = NULL;
    *paramsp = params;
    *nparamp = nparam;
}

/*
 * Determine whether one of the various `if' conditions is true or
 * not.
 *
 * We must free the tline we get passed.
 */
static enum cond_state if_condition(Token * tline, enum preproc_token ct)
{
    bool j;
    Token *t, *tt, *origline;
    struct ppscan pps;
    struct tokenval tokval;
    expr *evalresult;
    enum pp_token_type needtype;
    char *p;
    const char *dname = pp_directives[ct];
    bool casesense = true;

    origline = tline;

    switch (PP_COND(ct)) {
    case PP_IFCTX:
        j = false;              /* have we matched yet? */
        while (true) {
            skip_white_(tline);
            if (!tline)
                break;
            if (tline->type != TOK_ID) {
                nasm_nonfatal("`%s' expects context identifiers",
                              dname);
                goto fail;
            }
            if (cstk && cstk->name && !nasm_stricmp(tline->text, cstk->name))
                j = true;
            tline = tline->next;
        }
        break;

    case PP_IFDEF:
        j = false;              /* have we matched yet? */
        while (tline) {
            skip_white_(tline);
            if (!tline || (tline->type != TOK_ID &&
                           (tline->type != TOK_PREPROC_ID ||
                            tline->text[1] != '$'))) {
                nasm_nonfatal("`%s' expects macro identifiers",
                              dname);
                goto fail;
            }
            if (smacro_defined(NULL, tline->text, 0, NULL, true))
                j = true;
            tline = tline->next;
        }
        break;

    case PP_IFENV:
        tline = expand_smacro(tline);
        j = false;              /* have we matched yet? */
        while (tline) {
            skip_white_(tline);
            if (!tline || (tline->type != TOK_ID &&
                           tline->type != TOK_STRING &&
                           (tline->type != TOK_PREPROC_ID ||
                            tline->text[1] != '!'))) {
                nasm_nonfatal("`%s' expects environment variable names",
                              dname);
                goto fail;
            }
            p = tline->text;
            if (tline->type == TOK_PREPROC_ID)
                p += 2;         /* Skip leading %! */
            if (nasm_isquote(*p))
                nasm_unquote_cstr(p, NULL);
            if (getenv(p))
                j = true;
            tline = tline->next;
        }
        break;

    case PP_IFIDNI:
        casesense = false;
        /* fall through */
    case PP_IFIDN:
        tline = expand_smacro(tline);
        t = tt = tline;
        while (tok_isnt_(tt, ","))
            tt = tt->next;
        if (!tt) {
            nasm_nonfatal("`%s' expects two comma-separated arguments",
                          dname);
            goto fail;
        }
        tt = tt->next;
        j = true;               /* assume equality unless proved not */
        while ((t->type != TOK_OTHER || strcmp(t->text, ",")) && tt) {
            if (tt->type == TOK_OTHER && !strcmp(tt->text, ",")) {
                nasm_nonfatal("`%s': more than one comma on line",
                              dname);
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
                if (mmemcmp(t->text, tt->text, l1, casesense)) {
                    j = false;
                    break;
                }
            } else if (mstrcmp(tt->text, t->text, casesense) != 0) {
                j = false;      /* found mismatching tokens */
                break;
            }

            t = t->next;
            tt = tt->next;
        }
        if ((t->type != TOK_OTHER || strcmp(t->text, ",")) || tt)
            j = false;          /* trailing gunk on one end or other */
        break;

    case PP_IFMACRO:
    {
        bool found = false;
        MMacro searching, *mmac;

        skip_white_(tline);
        tline = expand_id(tline);
        if (!tok_type_(tline, TOK_ID)) {
            nasm_nonfatal("`%s' expects a macro name", dname);
            goto fail;
        }
        nasm_zero(searching);
        searching.name = nasm_strdup(tline->text);
        searching.casesense = true;
        searching.nparam_min = 0;
        searching.nparam_max = INT_MAX;
        tline = expand_smacro(tline->next);
        skip_white_(tline);
        if (!tline) {
        } else if (!tok_type_(tline, TOK_NUMBER)) {
            nasm_nonfatal("`%s' expects a parameter count or nothing",
                          dname);
        } else {
            searching.nparam_min = searching.nparam_max =
                read_param_count(tline->text);
        }
        if (tline && tok_is_(tline->next, "-")) {
            tline = tline->next->next;
            if (tok_is_(tline, "*"))
                searching.nparam_max = INT_MAX;
            else if (!tok_type_(tline, TOK_NUMBER))
                nasm_nonfatal("`%s' expects a parameter count after `-'",
                              dname);
            else {
                searching.nparam_max = read_param_count(tline->text);
                if (searching.nparam_min > searching.nparam_max) {
                    nasm_nonfatal("minimum parameter count exceeds maximum");
                    searching.nparam_max = searching.nparam_min;
                }
            }
        }
        if (tline && tok_is_(tline->next, "+")) {
            tline = tline->next;
            searching.plus = true;
        }
        mmac = (MMacro *) hash_findix(&mmacros, searching.name);
        while (mmac) {
            if (!strcmp(mmac->name, searching.name) &&
                (mmac->nparam_min <= searching.nparam_max
                 || searching.plus)
                && (searching.nparam_min <= mmac->nparam_max
                    || mmac->plus)) {
                found = true;
                break;
            }
            mmac = mmac->next;
        }
        if (tline && tline->next)
            nasm_warn(WARN_OTHER, "trailing garbage after %%ifmacro ignored");
        nasm_free(searching.name);
        j = found;
        break;
    }

    case PP_IFID:
        needtype = TOK_ID;
        goto iftype;
    case PP_IFNUM:
        needtype = TOK_NUMBER;
        goto iftype;
    case PP_IFSTR:
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

    case PP_IFTOKEN:
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

    case PP_IFEMPTY:
        t = tline = expand_smacro(tline);
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        j = !t;                 /* Should be empty */
        break;

    case PP_IF:
        pps.tptr = tline = expand_smacro(tline);
	pps.ntokens = -1;
        tokval.t_type = TOKEN_INVALID;
        evalresult = evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
        if (!evalresult)
            return -1;
        if (tokval.t_type)
            nasm_warn(WARN_OTHER, "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            nasm_nonfatal("non-constant value given to `%s'",
                          dname);
            goto fail;
        }
        j = reloc_value(evalresult) != 0;
        break;

    default:
        nasm_nonfatal("unknown preprocessor directive `%s'", dname);
        goto fail;
    }

    free_tlist(origline);
    return (j ^ PP_COND_NEGATIVE(ct)) ? COND_IF_TRUE : COND_IF_FALSE;

fail:
    free_tlist(origline);
    return COND_NEVER;
}

/*
 * Default smacro expansion routine: just returns a copy of the
 * expansion list.
 */
static Token *
smacro_expand_default(const SMacro *s, Token **params, int nparams)
{
    (void)params;
    (void)nparams;

    return dup_tlist(s->expansion, NULL);
}

/*
 * Emit a macro defintion or undef to the listing file, if
 * desired. This is similar to detoken(), but it handles the reverse
 * expansion list, does not expand %! or local variable tokens, and
 * does some special handling for macro parameters.
 */
static void
list_smacro_def(enum preproc_token op, const Context *ctx, const SMacro *m)
{
    Token *t;
    size_t namelen, size;
    char *def, *p;
    char *context_prefix = NULL;
    size_t context_len;

    namelen = strlen(m->name);
    size = namelen + 2;  /* Include room for space after name + NUL */

    if (ctx) {
        int context_depth = cstk->depth - ctx->depth + 1;
        context_prefix =
            nasm_asprintf("[%s::%"PRIu64"] %%%-*s",
                          ctx->name ? ctx->name : "",
                          ctx->number, context_depth, "");

        context_len = nasm_last_string_len();
        memset(context_prefix + context_len - context_depth,
               '$', context_depth);
        size += context_len;
    }

    if (m->nparam) {
        /*
         * Space for ( and either , or ) around each
         * parameter, plus up to 4 flags.
         */
        int i;

        size += 1 + 4 * m->nparam;
        for (i = 0; i < m->nparam; i++) {
            size += m->params[i].namelen;
        }
    }

    def = nasm_malloc(size);
    p = def+size;
    *--p = '\0';

    list_for_each(t, m->expansion) {
        if (!t->text) {
            *--p = ' ';
        } else {
            p -= t->len;
            memcpy(p, t->text, t->len);
        }
    }

    *--p = ' ';

    if (m->nparam) {
        int i;

        *--p = ')';
        for (i = m->nparam-1; i >= 0; i--) {
            enum sparmflags flags = m->params[i].flags;
            if (flags & SPARM_GREEDY)
                *--p = '+';
            if (m->params[i].name) {
                p -= m->params[i].namelen;
                memcpy(p, m->params[i].name, m->params[i].namelen);
            }
            if (flags & SPARM_NOSTRIP)
                *--p = '!';
            if (flags & SPARM_STR)
                *--p = '&';
            if (flags & SPARM_EVAL)
                *--p = '=';
            *--p = ',';
        }
        *p = '(';               /* First parameter starts with ( not , */
    }

    p -= namelen;
    memcpy(p, m->name, namelen);

    if (context_prefix) {
        p -= context_len;
        memcpy(p, context_prefix, context_len);
        nasm_free(context_prefix);
    }

    nasm_listmsg("%s %s", pp_directives[op], p);
    nasm_free(def);
}

/*
 * Parse smacro arguments, return argument count. If the tmpl argument
 * is set, set the nparam, greedy and params field in the template.
 * **tpp is updated to point to the first token after the
 * prototype after any whitespace and *tpp to the pointer to it, if
 * advanced.
 *
 * The text values from any argument tokens are "stolen" and the
 * corresponding text fields set to NULL.
 */
static int parse_smacro_template(Token ***tpp, SMacro *tmpl)
{
    int nparam = 0;
    enum sparmflags flags;
    struct smac_param *params = NULL;
    bool err, done, greedy;
    Token **tn = *tpp;
    Token *t = *tn;
    Token *name;

    while (t && t->type == TOK_WHITESPACE) {
        tn = &t->next;
        t = t->next;
    }
    if (!tok_is_(t, "("))
        goto finish;

    if (tmpl) {
        Token *tx = t;
        Token **txpp = &tx;
        int sparam;

        /* Count parameters first */
        sparam = parse_smacro_template(&txpp, NULL);
        if (!sparam)
            goto finish;        /* No parameters, we're done */
        nasm_newn(params, sparam);
    }

    name = NULL;
    flags = 0;
    err = done = greedy = false;

    while (!done) {
        if (!t || !t->type) {
            nasm_nonfatal("parameter identifier expected");
            break;
        }

        tn = &t->next;
        t = t->next;

        switch (t->type) {
        case TOK_ID:
            if (name)
                goto bad;
            name = t;
            break;

        case TOK_OTHER:
            if (t->text[1])
                goto bad;
            switch (t->text[0]) {
            case '=':
                flags |= SPARM_EVAL;
                break;
            case '&':
                flags |= SPARM_STR;
                break;
            case '!':
                flags |= SPARM_NOSTRIP;
                break;
            case '+':
                flags |= SPARM_GREEDY;
                greedy = true;
                break;
            case ',':
                if (greedy)
                    nasm_nonfatal("greedy parameter must be last");
                /* fall through */
            case ')':
                if (params) {
                    if (name) {
                        params[nparam].name    = name->text;
                        params[nparam].namelen = name->len;
                        name->text = NULL;
                    }
                    params[nparam].flags = flags;
                    nparam++;
                }
                name = NULL;
                flags = 0;
                done = t->text[1] == ')';
                break;
            default:
                goto bad;
            }
            break;

        case TOK_WHITESPACE:
            break;

        default:
        bad:
            if (!err) {
                nasm_nonfatal("garbage `%s' in macro parameter list", t->text);
                err = true;
            }
            break;
        }
    }

    if (!done)
        nasm_nonfatal("`)' expected to terminate macro template");

finish:
    while (t && t->type == TOK_WHITESPACE) {
        tn = &t->next;
        t = t->next;
    }
    *tpp = tn;
    if (tmpl) {
        tmpl->nparam = nparam;
        tmpl->greedy = greedy;
        tmpl->params = params;
    }
    return nparam;
}

/*
 * Common code for defining an smacro. The tmpl argument, if not NULL,
 * contains any macro parameters that aren't explicit arguments;
 * those are the more uncommon macro variants.
 */
static SMacro *define_smacro(const char *mname, bool casesense,
                             Token *expansion, SMacro *tmpl)
{
    SMacro *smac, **smhead;
    struct hash_table *smtbl;
    Context *ctx;
    bool defining_alias = false;
    unsigned int nparam = 0;

    if (tmpl) {
        defining_alias = tmpl->alias;
        nparam = tmpl->nparam;
    }

    while (1) {
        ctx = get_ctx(mname, &mname);

        if (!smacro_defined(ctx, mname, nparam, &smac, casesense)) {
            /* Create a new macro */
            smtbl  = ctx ? &ctx->localmac : &smacros;
            smhead = (SMacro **) hash_findi_add(smtbl, mname);
            nasm_new(smac);
            smac->next = *smhead;
            *smhead = smac;
            break;
        } else if (!smac) {
            nasm_warn(WARN_OTHER, "single-line macro `%s' defined both with and"
                       " without parameters", mname);
            /*
             * Some instances of the old code considered this a failure,
             * some others didn't.  What is the right thing to do here?
             */
            goto fail;
        } else if (!smac->alias || defining_alias) {
            /*
             * We're redefining, so we have to take over an
             * existing SMacro structure. This means freeing
             * what was already in it, but not the structure itself.
             */
            clear_smacro(smac);
            break;
        } else if (smac->in_progress) {
            nasm_nonfatal("macro alias loop");
            goto fail;
        } else {
            /* It is an alias macro; follow the alias link */
            SMacro *s;

            smac->in_progress = true;
            s = define_smacro(smac->expansion->text, casesense,
                              expansion, tmpl);
            smac->in_progress = false;
            return s;
        }
    }

    smac->name      = nasm_strdup(mname);
    smac->casesense = casesense;
    smac->expansion = expansion;
    smac->expand    = smacro_expand_default;
    if (tmpl) {
        smac->nparam     = tmpl->nparam;
        smac->params     = tmpl->params;
        smac->alias      = tmpl->alias;
        smac->greedy     = tmpl->greedy;
        if (tmpl->expand)
            smac->expand = tmpl->expand;
    }
    if (list_option('m')) {
        static const enum preproc_token op[2][2] = {
            { PP_DEFINE,   PP_IDEFINE },
            { PP_DEFALIAS, PP_IDEFALIAS }
        };
        list_smacro_def(op[!!smac->alias][casesense], ctx, smac);
    }
    return smac;

fail:
    free_tlist(expansion);
    if (tmpl)
        free_smacro_members(tmpl);
    return NULL;
}

/*
 * Undefine an smacro
 */
static void undef_smacro(const char *mname, bool undefalias)
{
    SMacro **smhead, *s, **sp;
    struct hash_table *smtbl;
    Context *ctx;

    ctx = get_ctx(mname, &mname);
    smtbl = ctx ? &ctx->localmac : &smacros;
    smhead = (SMacro **)hash_findi(smtbl, mname, NULL);

    if (smhead) {
        /*
         * We now have a macro name... go hunt for it.
         */
        sp = smhead;
        while ((s = *sp) != NULL) {
            if (!mstrcmp(s->name, mname, s->casesense)) {
                if (s->alias && !undefalias) {
                    if (s->in_progress) {
                        nasm_nonfatal("macro alias loop");
                    } else {
                        s->in_progress = true;
                        undef_smacro(s->expansion->text, false);
                        s->in_progress = false;
                    }
                } else {
                    if (list_option('m'))
                        list_smacro_def(s->alias ? PP_UNDEFALIAS : PP_UNDEF,
                                        ctx, s);
                    *sp = s->next;
                    free_smacro(s);
                }
            } else {
                sp = &s->next;
            }
        }
    }
}

/*
 * Parse a mmacro specification.
 */
static bool parse_mmacro_spec(Token *tline, MMacro *def, const char *directive)
{
    tline = tline->next;
    skip_white_(tline);
    tline = expand_id(tline);
    if (!tok_type_(tline, TOK_ID)) {
        nasm_nonfatal("`%s' expects a macro name", directive);
        return false;
    }

#if 0
    def->prev = NULL;
#endif
    def->name = nasm_strdup(tline->text);
    def->plus = false;
    def->nolist = false;
    def->nparam_min = 0;
    def->nparam_max = 0;

    tline = expand_smacro(tline->next);
    skip_white_(tline);
    if (!tok_type_(tline, TOK_NUMBER))
        nasm_nonfatal("`%s' expects a parameter count", directive);
    else
        def->nparam_min = def->nparam_max = read_param_count(tline->text);
    if (tline && tok_is_(tline->next, "-")) {
        tline = tline->next->next;
        if (tok_is_(tline, "*")) {
            def->nparam_max = INT_MAX;
        } else if (!tok_type_(tline, TOK_NUMBER)) {
            nasm_nonfatal("`%s' expects a parameter count after `-'", directive);
        } else {
            def->nparam_max = read_param_count(tline->text);
            if (def->nparam_min > def->nparam_max) {
                nasm_nonfatal("minimum parameter count exceeds maximum");
                def->nparam_max = def->nparam_min;
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
        def->nolist = !list_option('f') || istk->nolist;
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
    def->expansion = NULL;

    if (def->defaults && def->ndefs > def->nparam_max - def->nparam_min &&
        !def->plus) {
        /*
         *!macro-defaults [on] macros with more default than optional parameters
         *!  warns when a macro has more default parameters than optional parameters.
         *!  See \k{mlmacdef} for why might want to disable this warning.
         */
        nasm_warn(WARN_MACRO_DEFAULTS,
                   "too many default macro parameters in macro `%s'", def->name);
    }

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
    return str ? sizes[bsii(str, size_names, ARRAY_SIZE(size_names))+1] : 0;
}

/*
 * Process a preprocessor %pragma directive.  Currently there are none.
 * Gets passed the token list starting with the "preproc" token from
 * "%pragma preproc".
 */
static void do_pragma_preproc(Token *tline)
{
    /* Skip to the real stuff */
    tline = tline->next;
    skip_white_(tline);
    if (!tline)
        return;

    (void)tline;                /* Nothing else to do at present */
}

static bool is_macro_id(const Token *t)
{
    return t && (t->type == TOK_ID ||
                 (t->type == TOK_PREPROC_ID && t->text[1] == '$'));
}

static char *get_id(Token **tp, const char *dname, const char *err)
{
    char *id;
    Token *t = *tp;

    t = t->next;                /* Skip directive */
    skip_white_(t);
    t = expand_id(t);

    if (!is_macro_id(t)) {
        nasm_nonfatal("`%s' expects a %s", dname,
                      err ? err : "macro identifier");
        return NULL;
    }

    id = t->text;
    skip_white_(t);
    *tp = t;
    return id;
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
 * @param output if this directive generated output
 * @return DIRECTIVE_FOUND or NO_DIRECTIVE_FOUND
 *
 */
static int do_directive(Token *tline, Token **output)
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
    const char *found_path;
    const char *mname;
    struct ppscan pps;
    Include *inc;
    Context *ctx;
    Cond *cond;
    MMacro *mmac, **mmhead;
    Token *t = NULL, *tt, *macro_start, *last, *origline;
    Line *l;
    struct tokenval tokval;
    expr *evalresult;
    int64_t count;
    size_t len;
    errflags severity;
    const char *dname;          /* Name of directive, for messages */

    *output = NULL;             /* No output generated */
    origline = tline;

    skip_white_(tline);
    if (!tline || !tok_type_(tline, TOK_PREPROC_ID) ||
        (tline->text[0] && (tline->text[1] == '%' ||
			    tline->text[1] == '$' ||
			    tline->text[1] == '!')))
        return NO_DIRECTIVE_FOUND;

    dname = tline->text;
    i = pp_token_hash(tline->text);

    casesense = true;
    if (PP_HAS_CASE(i) & PP_INSENSITIVE(i)) {
        casesense = false;
        i--;
    }

    /*
     * If we're in a non-emitting branch of a condition construct,
     * or walking to the end of an already terminated %rep block,
     * we should ignore all directives except for condition
     * directives.
     */
    if (((istk->conds && !emitting(istk->conds->state)) ||
         (istk->mstk.mstk && !istk->mstk.mstk->in_progress)) &&
        !is_condition(i)) {
        return NO_DIRECTIVE_FOUND;
    }

    /*
     * If we're defining a macro or reading a %rep block, we should
     * ignore all directives except for %macro/%imacro (which nest),
     * %endm/%endmacro, and (only if we're in a %rep block) %endrep.
     * If we're in a %rep block, another %rep nests, so should be let through.
     */
    if (defining && i != PP_MACRO && i != PP_RMACRO &&
        i != PP_ENDMACRO && i != PP_ENDM &&
        (defining->name || (i != PP_ENDREP && i != PP_REP))) {
        return NO_DIRECTIVE_FOUND;
    }

    if (defining) {
        if (i == PP_MACRO || i == PP_RMACRO) {
            nested_mac_count++;
            return NO_DIRECTIVE_FOUND;
        } else if (nested_mac_count > 0) {
            if (i == PP_ENDMACRO) {
                nested_mac_count--;
                return NO_DIRECTIVE_FOUND;
            }
        }
        if (!defining->name) {
            if (i == PP_REP) {
                nested_rep_count++;
                return NO_DIRECTIVE_FOUND;
            } else if (nested_rep_count > 0) {
                if (i == PP_ENDREP) {
                    nested_rep_count--;
                    return NO_DIRECTIVE_FOUND;
                }
            }
        }
    }

    switch (i) {
    default:
        nasm_nonfatal("unknown preprocessor directive `%s'", dname);
        return NO_DIRECTIVE_FOUND;      /* didn't get it */

    case PP_PRAGMA:
        /*
         * %pragma namespace options...
         *
         * The namespace "preproc" is reserved for the preprocessor;
         * all other namespaces generate a [pragma] assembly directive.
         *
         * Invalid %pragmas are ignored and may have different
         * meaning in future versions of NASM.
         */
        t = tline;
        tline = tline->next;
        t->next = NULL;
        tline = expand_smacro(tline);
        while (tok_type_(tline, TOK_WHITESPACE)) {
            t = tline;
            tline = tline->next;
            delete_Token(t);
        }
        if (tok_type_(tline, TOK_ID)) {
            if (!nasm_stricmp(tline->text, "preproc")) {
                /* Preprocessor pragma */
                do_pragma_preproc(tline);
                free_tlist(tline);
            } else {
                /* Build the assembler directive */

                /* Append bracket to the end of the output */
                for (t = tline; t->next; t = t->next)
                    ;
                t->next = new_Token(NULL, TOK_OTHER, "]", 1);

                /* Prepend "[pragma " */
                t = new_Token(tline, TOK_WHITESPACE, NULL, 0);
                t = new_Token(t, TOK_ID, "pragma", 6);
                t = new_Token(t, TOK_OTHER, "[", 1);
                tline = t;
                *output = tline;
            }
        }
        break;

    case PP_STACKSIZE:
        /* Directive to tell NASM what the default stack size is. The
         * default is for a 16-bit stack, and this can be overriden with
         * %stacksize large.
         */
        tline = tline->next;
        if (tline && tline->type == TOK_WHITESPACE)
            tline = tline->next;
        if (!tline || tline->type != TOK_ID) {
            nasm_nonfatal("`%s' missing size parameter", dname);
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
            nasm_nonfatal("`%s' invalid size type", dname);
        }
        break;

    case PP_ARG:
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
                nasm_nonfatal("`%s' missing argument parameter", dname);
                goto done;
            }
            arg = tline->text;

            /* Find the argument size type */
            tline = tline->next;
            if (!tline || tline->type != TOK_OTHER
                || tline->text[0] != ':') {
                nasm_nonfatal("syntax error processing `%s' directive", dname);
                goto done;
            }
            tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                nasm_nonfatal("`%s' missing size type parameter", dname);
                goto done;
            }

            /* Allow macro expansion of type parameter */
            tt = tokenize(tline->text);
            tt = expand_smacro(tt);
            size = parse_size(tt->text);
            if (!size) {
                nasm_nonfatal("invalid size type for `%s' missing directive", dname);
                free_tlist(tt);
                goto done;
            }
            free_tlist(tt);

            /* Round up to even stack slots */
            size = ALIGN(size, StackSize);

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s+%d)",
                     arg, StackPointer, offset);
            do_directive(tokenize(directive), output);
            offset += size;

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        } while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        ArgOffset = offset;
        break;

    case PP_LOCAL:
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
                nasm_nonfatal("`%s' missing argument parameter", dname);
                goto done;
            }
            local = tline->text;

            /* Find the argument size type */
            tline = tline->next;
            if (!tline || tline->type != TOK_OTHER
                || tline->text[0] != ':') {
                nasm_nonfatal("syntax error processing `%s' directive", dname);
                goto done;
            }
            tline = tline->next;
            if (!tline || tline->type != TOK_ID) {
                nasm_nonfatal("`%s' missing size type parameter", dname);
                goto done;
            }

            /* Allow macro expansion of type parameter */
            tt = tokenize(tline->text);
            tt = expand_smacro(tt);
            size = parse_size(tt->text);
            if (!size) {
                nasm_nonfatal("invalid size type for `%s' missing directive", dname);
                free_tlist(tt);
                goto done;
            }
            free_tlist(tt);

            /* Round up to even stack slots */
            size = ALIGN(size, StackSize);

            offset += size;     /* Negative offset, increment before */

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s-%d)",
                     local, StackPointer, offset);
            do_directive(tokenize(directive), output);

            /* Now define the assign to setup the enter_c macro correctly */
            snprintf(directive, sizeof(directive),
                     "%%assign %%$localsize %%$localsize+%d", size);
            do_directive(tokenize(directive), output);

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        } while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        LocalOffset = offset;
        break;

    case PP_CLEAR:
        if (tline->next)
            nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored", dname);
        free_macros();
        init_macros();
        break;

    case PP_DEPEND:
        t = tline->next = expand_smacro(tline->next);
        skip_white_(t);
        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            nasm_nonfatal("`%s' expects a file name", dname);
            goto done;
        }
        if (t->next)
            nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored", dname);
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote_cstr(p, NULL);
        strlist_add(deplist, p);
        goto done;

    case PP_INCLUDE:
        t = tline->next = expand_smacro(tline->next);
        skip_white_(t);

        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            nasm_nonfatal("`%s' expects a file name", dname);
            goto done;
        }
        if (t->next)
            nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored", dname);
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote_cstr(p, NULL);
        nasm_new(inc);
        inc->next = istk;
        found_path = NULL;
        inc->fp = inc_fopen(p, deplist, &found_path,
                            (pp_mode == PP_DEPS)
                            ? INC_OPTIONAL : INC_NEEDED, NF_TEXT);
        if (!inc->fp) {
            /* -MG given but file not found */
            nasm_free(inc);
        } else {
            inc->fname = src_set_fname(found_path ? found_path : p);
            inc->lineno = src_set_linnum(0);
            inc->lineinc = 1;
            inc->nolist = istk->nolist;
            istk = inc;
            lfmt->uplevel(LIST_INCLUDE, 0);
        }
        break;

    case PP_USE:
    {
        const struct use_package *pkg;

        if (!(mname = get_id(&tline, dname, "package name")))
            goto done;
        if (tline->next)
            nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored", dname);
        if (tline->type == TOK_STRING)
            nasm_unquote_cstr(tline->text, NULL);
        pkg = nasm_find_use_package(tline->text);
        if (!pkg) {
            nasm_nonfatal("unknown `%s' package: %s", dname, tline->text);
        } else if (!use_loaded[pkg->index]) {
            /*
             * Not already included, go ahead and include it.
             * Treat it as an include file for the purpose of
             * producing a listing.
             */
            use_loaded[pkg->index] = true;
            stdmacpos = pkg->macros;
            nasm_new(inc);
            inc->next = istk;
            inc->fname = src_set_fname(NULL);
            inc->lineno = src_set_linnum(0);
            inc->nolist = !list_option('b') || istk->nolist;
            istk = inc;
            lfmt->uplevel(LIST_INCLUDE, 0);
        }
        break;
    }
    case PP_PUSH:
    case PP_REPL:
    case PP_POP:
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (tline) {
            if (!tok_type_(tline, TOK_ID)) {
                nasm_nonfatal("`%s' expects a context identifier",
                              pp_directives[i]);
                goto done;
            }
            if (tline->next)
                nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored",
                           pp_directives[i]);
            p = nasm_strdup(tline->text);
        } else {
            p = NULL; /* Anonymous */
        }

        if (i == PP_PUSH) {
            nasm_new(ctx);
            ctx->depth = cstk ? cstk->depth + 1 : 1;
            ctx->next = cstk;
            ctx->name = p;
            ctx->number = unique++;
            cstk = ctx;
        } else {
            /* %pop or %repl */
            if (!cstk) {
                nasm_nonfatal("`%s': context stack is empty",
                              pp_directives[i]);
            } else if (i == PP_POP) {
                if (p && (!cstk->name || nasm_stricmp(p, cstk->name)))
                    nasm_nonfatal("`%s' in wrong context: %s, "
                               "expected %s",
                               dname, cstk->name ? cstk->name : "anonymous", p);
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
        break;
    case PP_FATAL:
        severity = ERR_FATAL;
        goto issue_error;
    case PP_ERROR:
        severity = ERR_NONFATAL|ERR_PASS2;
        goto issue_error;
    case PP_WARNING:
        /*!
         *!user [on] %warning directives
         *!  controls output of \c{%warning} directives (see \k{pperror}).
         */
        severity = ERR_WARNING|WARN_USER|ERR_PASS2;
        goto issue_error;

issue_error:
    {
        /* Only error out if this is the final pass */
        tline->next = expand_smacro(tline->next);
        tline = tline->next;
        skip_white_(tline);
        t = tline ? tline->next : NULL;
        skip_white_(t);
        if (tok_type_(tline, TOK_STRING) && !t) {
            /* The line contains only a quoted string */
            p = tline->text;
            nasm_unquote(p, NULL); /* Ignore NUL character truncation */
            nasm_error(severity, "%s",  p);
        } else {
            /* Not a quoted string, or more than a quoted string */
            p = detoken(tline, false);
            nasm_error(severity, "%s",  p);
            nasm_free(p);
        }
        break;
    }

    CASE_PP_IF:
        if (istk->conds && !emitting(istk->conds->state))
            j = COND_NEVER;
        else {
            j = if_condition(tline->next, i);
            tline->next = NULL; /* it got freed */
        }
        cond = nasm_malloc(sizeof(Cond));
        cond->next = istk->conds;
        cond->state = j;
        istk->conds = cond;
        if(istk->mstk.mstk)
            istk->mstk.mstk->condcnt++;
        break;

    CASE_PP_ELIF:
        if (!istk->conds)
            nasm_fatal("`%s': no matching `%%if'", dname);
        switch(istk->conds->state) {
        case COND_IF_TRUE:
            istk->conds->state = COND_DONE;
            break;

        case COND_DONE:
        case COND_NEVER:
            break;

        case COND_ELSE_TRUE:
        case COND_ELSE_FALSE:
            nasm_warn(WARN_OTHER|ERR_PP_PRECOND,
                       "`%%elif' after `%%else' ignored");
            istk->conds->state = COND_NEVER;
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
            istk->conds->state = j;
            break;
        }
        break;

    case PP_ELSE:
        if (tline->next)
            nasm_warn(WARN_OTHER|ERR_PP_PRECOND,
                       "trailing garbage after `%%else' ignored");
        if (!istk->conds)
	    nasm_fatal("`%%else: no matching `%%if'");
        switch(istk->conds->state) {
        case COND_IF_TRUE:
        case COND_DONE:
            istk->conds->state = COND_ELSE_FALSE;
            break;

        case COND_NEVER:
            break;

        case COND_IF_FALSE:
            istk->conds->state = COND_ELSE_TRUE;
            break;

        case COND_ELSE_TRUE:
        case COND_ELSE_FALSE:
            nasm_warn(WARN_OTHER|ERR_PP_PRECOND,
                       "`%%else' after `%%else' ignored.");
            istk->conds->state = COND_NEVER;
            break;
        }
        break;

    case PP_ENDIF:
        if (tline->next)
            nasm_warn(WARN_OTHER|ERR_PP_PRECOND,
                       "trailing garbage after `%%endif' ignored");
        if (!istk->conds)
            nasm_fatal("`%%endif': no matching `%%if'");
        cond = istk->conds;
        istk->conds = cond->next;
        nasm_free(cond);
        if(istk->mstk.mstk)
            istk->mstk.mstk->condcnt--;
        break;

    case PP_RMACRO:
    case PP_MACRO:
        nasm_assert(!defining);
        nasm_new(defining);
        defining->casesense = casesense;
        defining->dstk.mmac = defining;
        if (i == PP_RMACRO)
            defining->max_depth = nasm_limit[LIMIT_MACRO_LEVELS];
        if (!parse_mmacro_spec(tline, defining, dname)) {
            nasm_free(defining);
            goto done;
        }

	src_get(&defining->xline, &defining->fname);

        mmac = (MMacro *) hash_findix(&mmacros, defining->name);
        while (mmac) {
            if (!strcmp(mmac->name, defining->name) &&
                (mmac->nparam_min <= defining->nparam_max
                 || defining->plus)
                && (defining->nparam_min <= mmac->nparam_max
                    || mmac->plus)) {
                nasm_warn(WARN_OTHER, "redefining multi-line macro `%s'",
                           defining->name);
                break;
            }
            mmac = mmac->next;
        }
        break;

    case PP_ENDM:
    case PP_ENDMACRO:
        if (!(defining && defining->name)) {
            nasm_nonfatal("`%s': not defining a macro", tline->text);
            goto done;
        }
        mmhead = (MMacro **) hash_findi_add(&mmacros, defining->name);
        defining->next = *mmhead;
        *mmhead = defining;
        defining = NULL;
        break;

    case PP_EXITMACRO:
        /*
         * We must search along istk->expansion until we hit a
         * macro-end marker for a macro with a name. Then we
         * bypass all lines between exitmacro and endmacro.
         */
        list_for_each(l, istk->expansion)
            if (l->finishes && l->finishes->name)
                break;

        if (l) {
            /*
             * Remove all conditional entries relative to this
             * macro invocation. (safe to do in this context)
             */
            for ( ; l->finishes->condcnt > 0; l->finishes->condcnt --) {
                cond = istk->conds;
                istk->conds = cond->next;
                nasm_free(cond);
            }
            istk->expansion = l;
        } else {
            nasm_nonfatal("`%%exitmacro' not within `%%macro' block");
        }
        break;

    case PP_UNIMACRO:
        casesense = false;
        /* fall through */
    case PP_UNMACRO:
    {
        MMacro **mmac_p;
        MMacro spec;

        nasm_zero(spec);
        spec.casesense = casesense;
        if (!parse_mmacro_spec(tline, &spec, dname)) {
            goto done;
        }
        mmac_p = (MMacro **) hash_findi(&mmacros, spec.name, NULL);
        while (mmac_p && *mmac_p) {
            mmac = *mmac_p;
            if (mmac->casesense == spec.casesense &&
                !mstrcmp(mmac->name, spec.name, spec.casesense) &&
                mmac->nparam_min == spec.nparam_min &&
                mmac->nparam_max == spec.nparam_max &&
                mmac->plus == spec.plus) {
                *mmac_p = mmac->next;
                free_mmacro(mmac);
            } else {
                mmac_p = &mmac->next;
            }
        }
        free_tlist(spec.dlist);
        break;
    }

    case PP_ROTATE:
        if (tline->next && tline->next->type == TOK_WHITESPACE)
            tline = tline->next;
        if (!tline->next) {
            free_tlist(origline);
            nasm_nonfatal("`%%rotate' missing rotate count");
            return DIRECTIVE_FOUND;
        }
        t = expand_smacro(tline->next);
        tline->next = NULL;
        pps.tptr = tline = t;
	pps.ntokens = -1;
        tokval.t_type = TOKEN_INVALID;
        evalresult =
            evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
        free_tlist(tline);
        if (!evalresult)
            return DIRECTIVE_FOUND;
        if (tokval.t_type)
            nasm_warn(WARN_OTHER, "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            nasm_nonfatal("non-constant value given to `%%rotate'");
            return DIRECTIVE_FOUND;
        }
        mmac = istk->mstk.mmac;
        if (!mmac) {
            nasm_nonfatal("`%%rotate' invoked outside a macro call");
        } else if (mmac->nparam == 0) {
            nasm_nonfatal("`%%rotate' invoked within macro without parameters");
        } else {
            int rotate = mmac->rotate + reloc_value(evalresult);

            rotate %= (int)mmac->nparam;
            if (rotate < 0)
                rotate += mmac->nparam;

            mmac->rotate = rotate;
        }
        break;

    case PP_REP:
    {
        MMacro *tmp_defining;

        nolist = false;
        do {
            tline = tline->next;
        } while (tok_type_(tline, TOK_WHITESPACE));

        if (tok_type_(tline, TOK_ID) &&
            nasm_stricmp(tline->text, ".nolist") == 0) {
            nolist = !list_option('f') || istk->nolist;
            do {
                tline = tline->next;
            } while (tok_type_(tline, TOK_WHITESPACE));
        }

        if (tline) {
            pps.tptr = expand_smacro(tline);
	    pps.ntokens = -1;
            tokval.t_type = TOKEN_INVALID;
            /* XXX: really critical?! */
            evalresult =
                evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
            if (!evalresult)
                goto done;
            if (tokval.t_type)
                nasm_warn(WARN_OTHER, "trailing garbage after expression ignored");
            if (!is_simple(evalresult)) {
                nasm_nonfatal("non-constant value given to `%%rep'");
                goto done;
            }
            count = reloc_value(evalresult);
            if (count > nasm_limit[LIMIT_REP]) {
                nasm_nonfatal("`%%rep' count %"PRId64" exceeds limit (currently %"PRId64")",
                              count, nasm_limit[LIMIT_REP]);
                count = 0;
            } else if (count < 0) {
                /*!
                 *!negative-rep [on] regative %rep count
                 *!  warns about negative counts given to the \c{%rep}
                 *!  preprocessor directive.
                 */
                nasm_warn(ERR_PASS2|WARN_NEGATIVE_REP,
                           "negative `%%rep' count: %"PRId64, count);
                count = 0;
            } else {
                count++;
            }
        } else {
            nasm_nonfatal("`%%rep' expects a repeat count");
            count = 0;
        }
        tmp_defining = defining;
        nasm_new(defining);
        defining->nolist = nolist;
        defining->in_progress = count;
        defining->mstk = istk->mstk;
        defining->dstk.mstk = tmp_defining;
        defining->dstk.mmac = tmp_defining ? tmp_defining->dstk.mmac : NULL;
	src_get(&defining->xline, &defining->fname);
        break;
    }

    case PP_ENDREP:
        if (!defining || defining->name) {
            nasm_nonfatal("`%%endrep': no matching `%%rep'");
            goto done;
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
        nasm_new(l);
        l->next = istk->expansion;
        l->finishes = defining;
        l->first = NULL;
        istk->expansion = l;

        istk->mstk.mstk = defining;

        lfmt->uplevel(defining->nolist ? LIST_MACRO_NOLIST : LIST_MACRO, 0);
        defining = defining->dstk.mstk;
        break;

    case PP_EXITREP:
        /*
         * We must search along istk->expansion until we hit a
         * macro-end marker for a macro with no name. Then we set
         * its `in_progress' flag to 0.
         */
        list_for_each(l, istk->expansion)
            if (l->finishes && !l->finishes->name)
                break;

        if (l)
            l->finishes->in_progress = 1;
        else
            nasm_nonfatal("`%%exitrep' not within `%%rep' block");
        break;

    case PP_DEFINE:
    case PP_XDEFINE:
    case PP_DEFALIAS:
    {
        SMacro tmpl;
        Token **lastp;

        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        nasm_zero(tmpl);
        lastp = &tline->next;
        nparam = parse_smacro_template(&lastp, &tmpl);
        tline = *lastp;
        *lastp = NULL;

        if (unlikely(i == PP_DEFALIAS)) {
            macro_start = tline;
            if (!is_macro_id(macro_start)) {
                nasm_nonfatal("`%s' expects a macro identifier to alias",
                              dname);
                goto done;
            }
            tt = macro_start->next;
            macro_start->next = NULL;
            tline = tline->next;
            skip_white_(tline);
            if (tline && tline->type) {
                nasm_warn(WARN_OTHER,
                          "trailing garbage after aliasing identifier ignored");
            }
            free_tlist(tt);
            tmpl.alias = true;
        } else {
            /* Expand the macro definition now for %xdefine and %ixdefine */
            if (i == PP_XDEFINE)
                tline = expand_smacro(tline);

            /* Reverse expansion list and mark parameter tokens */
            macro_start = NULL;
            t = tline;
            while (t) {
                if (t->type == TOK_ID) {
                    for (i = 0; i < nparam; i++) {
                        if ((size_t)tmpl.params[i].namelen == t->len &&
                            !memcmp(t->text, tmpl.params[i].name, t->len)) {
                            t->type = tok_smac_param(i);
                            break;
                        }
                    }
                }
                tt = t->next;
                t->next = macro_start;
                macro_start = t;
                t = tt;
            }
        }

        /*
         * Good. We now have a macro name, a parameter count, and a
         * token list (in reverse order) for an expansion. We ought
         * to be OK just to create an SMacro, store it, and let
         * free_tlist have the rest of the line (which we have
         * carefully re-terminated after chopping off the expansion
         * from the end).
         */
        define_smacro(mname, casesense, macro_start, &tmpl);
        break;
    }

    case PP_UNDEF:
    case PP_UNDEFALIAS:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;
        if (tline->next)
            nasm_warn(WARN_OTHER, "trailing garbage after macro name ignored");

        undef_smacro(mname, i == PP_UNDEFALIAS);
        break;

    case PP_DEFSTR:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        while (tok_type_(tline, TOK_WHITESPACE))
            tline = delete_Token(tline);

        p = detoken(tline, false);
        macro_start = make_tok_qstr(p);
        nasm_free(p);

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a string token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        break;

    case PP_DEFTOK:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            nasm_nonfatal("`%s' requires string as second parameter", dname);
            free_tlist(tline);
            goto done;
        }

        /*
         * Convert the string to a token stream.  Note that smacros
         * are stored with the token stream reversed, so we have to
         * reverse the output of tokenize().
         */
        nasm_unquote_cstr(t->text, NULL);
        macro_start = reverse_tokens(tokenize(t->text));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        free_tlist(tline);
        break;

    case PP_PATHSEARCH:
    {
        const char *found_path;

        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        if (!t || (t->type != TOK_STRING &&
                   t->type != TOK_INTERNAL_STRING)) {
            nasm_nonfatal("`%s' expects a file name", dname);
            free_tlist(tline);
            goto done;
        }
        if (t->next)
            nasm_warn(WARN_OTHER, "trailing garbage after `%s' ignored", dname);
        p = t->text;
        if (t->type != TOK_INTERNAL_STRING)
            nasm_unquote(p, NULL);

        inc_fopen(p, NULL, &found_path, INC_PROBE, NF_BINARY);
        if (!found_path)
            found_path = p;
	macro_start = make_tok_qstr(found_path);

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a string token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        free_tlist(tline);
        break;
    }

    case PP_STRLEN:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            nasm_nonfatal("`%s' requires string as second parameter", dname);
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = make_tok_num(nasm_unquote(t->text, NULL));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_STRCAT:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        len = 0;
        list_for_each(t, tline) {
            switch (t->type) {
            case TOK_WHITESPACE:
                break;
            case TOK_STRING:
                len += t->len = nasm_unquote(t->text, NULL);
                break;
            case TOK_OTHER:
                if (!strcmp(t->text, ",")) /* permit comma separators */
                    break;
                /* else fall through */
            default:
                nasm_nonfatal("non-string passed to `%s': %s", dname, t->text);
                free_tlist(tline);
                goto done;
            }
        }

        p = pp = nasm_malloc(len);
        list_for_each(t, tline) {
            if (t->type == TOK_STRING) {
                memcpy(p, t->text, t->len);
                p += t->len;
            }
        }

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        macro_start = make_tok_qstr(pp);
        nasm_free(pp);
        define_smacro(mname, casesense, macro_start, NULL);
        free_tlist(tline);
        break;

    case PP_SUBSTR:
    {
        int64_t start, count;
        size_t len;

        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        if (tline) /* skip expanded id */
            t = tline->next;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        /* t should now point to the string */
        if (!tok_type_(t, TOK_STRING)) {
            nasm_nonfatal("`%s' requires string as second parameter", dname);
            free_tlist(tline);
            goto done;
        }

        pps.tptr = t->next;
	pps.ntokens = -1;
        tokval.t_type = TOKEN_INVALID;
        evalresult = evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
        if (!evalresult) {
            free_tlist(tline);
            goto done;
        } else if (!is_simple(evalresult)) {
            nasm_nonfatal("non-constant value given to `%s'", dname);
            free_tlist(tline);
            goto done;
        }
        start = evalresult->value - 1;

        while (tok_type_(pps.tptr, TOK_WHITESPACE))
            pps.tptr = pps.tptr->next;
        if (!pps.tptr) {
            count = 1;  /* Backwards compatibility: one character */
        } else {
            tokval.t_type = TOKEN_INVALID;
            evalresult = evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
            if (!evalresult) {
                free_tlist(tline);
                goto done;
            } else if (!is_simple(evalresult)) {
                nasm_nonfatal("non-constant value given to `%s'", dname);
                free_tlist(tline);
                goto done;
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

	macro_start = new_Token(NULL, TOK_STRING, NULL, 0);
        macro_start->len = count;
        macro_start->text = nasm_quote((start < 0) ? "" : t->text + start,
                                       &macro_start->len);

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        free_tlist(tline);
        break;
    }

    case PP_ASSIGN:
        if (!(mname = get_id(&tline, dname, NULL)))
            goto done;

        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        pps.tptr = tline;
	pps.ntokens = -1;
        tokval.t_type = TOKEN_INVALID;
        evalresult = evaluate(ppscan, &pps, &tokval, NULL, true, NULL);
        free_tlist(tline);
        if (!evalresult)
            goto done;

        if (tokval.t_type)
            nasm_warn(WARN_OTHER, "trailing garbage after expression ignored");

        if (!is_simple(evalresult)) {
            nasm_nonfatal("non-constant value given to `%s'", dname);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
	}

	macro_start = make_tok_num(reloc_value(evalresult));

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
        define_smacro(mname, casesense, macro_start, NULL);
        break;

    case PP_LINE:
        /*
         * Syntax is `%line nnn[+mmm] [filename]'
         */
        if (unlikely(pp_noline))
            goto done;

        tline = tline->next;
        skip_white_(tline);
        if (!tok_type_(tline, TOK_NUMBER)) {
            nasm_nonfatal("`%s' expects line number", dname);
            goto done;
        }
        k = readnum(tline->text, &err);
        m = 1;
        tline = tline->next;
        if (tok_is_(tline, "+")) {
            tline = tline->next;
            if (!tok_type_(tline, TOK_NUMBER)) {
                nasm_nonfatal("`%s' expects line increment", dname);
                goto done;
            }
            m = readnum(tline->text, &err);
            tline = tline->next;
        }
        skip_white_(tline);
        src_set_linnum(k);
        istk->lineinc = m;
        if (tline) {
            char *fname = detoken(tline, false);
            src_set_fname(fname);
            nasm_free(fname);
        }
        break;
    }

done:
        free_tlist(origline);
        return DIRECTIVE_FOUND;
}

/*
 * Ensure that a macro parameter contains a condition code and
 * nothing else. Return the condition code index if so, or -1
 * otherwise.
 */
static int find_cc(Token * t)
{
    Token *tt;

    if (!t)
        return -1;              /* Probably a %+ without a space */

    skip_white_(t);
    if (!t)
        return -1;
    if (t->type != TOK_ID)
        return -1;
    tt = t->next;
    skip_white_(tt);
    if (tt && (tt->type != TOK_OTHER || strcmp(tt->text, ",")))
        return -1;

    return bsii(t->text, (const char **)conditions,  ARRAY_SIZE(conditions));
}

/*
 * This routines walks over tokens strem and handles tokens
 * pasting, if @handle_explicit passed then explicit pasting
 * term is handled, otherwise -- implicit pastings only.
 * The @m array can contain a series of token types which are
 * executed as separate passes.
 */
static bool paste_tokens(Token **head, const struct tokseq_match *m,
                         size_t mnum, bool handle_explicit)
{
    Token *tok, *next, **prev_next, **prev_nonspace;
    bool pasted = false;
    char *buf, *p;
    size_t len, i;

    /*
     * The last token before pasting. We need it
     * to be able to connect new handled tokens.
     * In other words if there were a tokens stream
     *
     * A -> B -> C -> D
     *
     * and we've joined tokens B and C, the resulting
     * stream should be
     *
     * A -> BC -> D
     */
    tok = *head;
    prev_next = NULL;

    if (!tok_type_(tok, TOK_WHITESPACE) && !tok_type_(tok, TOK_PASTE))
        prev_nonspace = head;
    else
        prev_nonspace = NULL;

    while (tok && (next = tok->next)) {

        switch (tok->type) {
        case TOK_WHITESPACE:
            /* Zap redundant whitespaces */
            while (tok_type_(next, TOK_WHITESPACE))
                next = delete_Token(next);
            tok->next = next;
            break;

        case TOK_PASTE:
            /* Explicit pasting */
            if (!handle_explicit)
                break;
            next = delete_Token(tok);

            while (tok_type_(next, TOK_WHITESPACE))
                next = delete_Token(next);

            if (!pasted)
                pasted = true;

            /* Left pasting token is start of line */
            if (!prev_nonspace)
                nasm_fatal("No lvalue found on pasting");

            /*
             * No ending token, this might happen in two
             * cases
             *
             *  1) There indeed no right token at all
             *  2) There is a bare "%define ID" statement,
             *     and @ID does expand to whitespace.
             *
             * So technically we need to do a grammar analysis
             * in another stage of parsing, but for now lets don't
             * change the behaviour people used to. Simply allow
             * whitespace after paste token.
             */
            if (!next) {
                /*
                 * Zap ending space tokens and that's all.
                 */
                tok = (*prev_nonspace)->next;
                while (tok_type_(tok, TOK_WHITESPACE))
                    tok = delete_Token(tok);
                tok = *prev_nonspace;
                tok->next = NULL;
                break;
            }

            tok = *prev_nonspace;
            while (tok_type_(tok, TOK_WHITESPACE))
                tok = delete_Token(tok);
            len  = strlen(tok->text);
            len += strlen(next->text);

            p = buf = nasm_malloc(len + 1);
            strcpy(p, tok->text);
            p = strchr(p, '\0');
            strcpy(p, next->text);

            delete_Token(tok);

            tok = tokenize(buf);
            nasm_free(buf);

            *prev_nonspace = tok;
            while (tok && tok->next)
                tok = tok->next;

            tok->next = delete_Token(next);

            /* Restart from pasted tokens head */
            tok = *prev_nonspace;
            break;

        default:
            /* implicit pasting */
            for (i = 0; i < mnum; i++) {
                if (!(PP_CONCAT_MATCH(tok, m[i].mask_head)))
                    continue;

                len = 0;
                while (next && PP_CONCAT_MATCH(next, m[i].mask_tail)) {
                    len += strlen(next->text);
                    next = next->next;
                }

                /* No match or no text to process */
                if (tok == next || len == 0)
                    break;

                len += strlen(tok->text);
                p = buf = nasm_malloc(len + 1);

                strcpy(p, tok->text);
                p = strchr(p, '\0');
                tok = delete_Token(tok);

                while (tok != next) {
                    if (PP_CONCAT_MATCH(tok, m[i].mask_tail)) {
                        strcpy(p, tok->text);
                        p = strchr(p, '\0');
                    }
                    tok = delete_Token(tok);
                }

                tok = tokenize(buf);
                nasm_free(buf);

                if (prev_next)
                    *prev_next = tok;
                else
                    *head = tok;

                /*
                 * Connect pasted into original stream,
                 * ie A -> new-tokens -> B
                 */
                while (tok && tok->next)
                    tok = tok->next;
                tok->next = next;

                if (!pasted)
                    pasted = true;

                /* Restart from pasted tokens head */
                tok = prev_next ? *prev_next : *head;
            }

            break;
        }

        prev_next = &tok->next;

        if (tok->next &&
            !tok_type_(tok->next, TOK_WHITESPACE) &&
            !tok_type_(tok->next, TOK_PASTE))
            prev_nonspace = prev_next;

        tok = tok->next;
    }

    return pasted;
}

/*
 * Computes the proper rotation of mmacro parameters
 */
static int mmac_rotate(const MMacro *mac, unsigned int n)
{
    if (--n < mac->nparam)
        n = (n + mac->rotate) % mac->nparam;

    return n+1;
}

/*
 * expands to a list of tokens from %{x:y}
 */
static Token *expand_mmac_params_range(MMacro *mac, Token *tline, Token ***last)
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
    if ((fst > (int)mac->nparam || fst < (-(int)mac->nparam)) ||
        (lst > (int)mac->nparam || lst < (-(int)mac->nparam)))
        goto err;

    fst = fst < 0 ? fst + (int)mac->nparam + 1: fst;
    lst = lst < 0 ? lst + (int)mac->nparam + 1: lst;

    /* count from zero */
    fst--, lst--;

    /*
     * It will be at least one token. Note we
     * need to scan params until separator, otherwise
     * only first token will be passed.
     */
    j = (fst + mac->rotate) % mac->nparam;
    tm = mac->params[j+1];
    if (!tm)
        goto err;
    head = dup_Token(NULL, tm);
    tt = &head->next, tm = tm->next;
    while (tok_isnt_(tm, ",")) {
        t = dup_Token(NULL, tm);
        *tt = t, tt = &t->next, tm = tm->next;
    }

    if (fst < lst) {
        for (i = fst + 1; i <= lst; i++) {
            t = new_Token(NULL, TOK_OTHER, ",", 0);
            *tt = t, tt = &t->next;
            j = (i + mac->rotate) % mac->nparam;
            tm = mac->params[j+1];
            while (tok_isnt_(tm, ",")) {
                t = dup_Token(NULL, tm);
                *tt = t, tt = &t->next, tm = tm->next;
            }
        }
    } else {
        for (i = fst - 1; i >= lst; i--) {
            t = new_Token(NULL, TOK_OTHER, ",", 0);
            *tt = t, tt = &t->next;
            j = (i + mac->rotate) % mac->nparam;
            tm = mac->params[j+1];
            while (tok_isnt_(tm, ",")) {
                t = dup_Token(NULL, tm);
                *tt = t, tt = &t->next, tm = tm->next;
            }
        }
    }

    *last = tt;
    return head;

err:
    nasm_nonfatal("`%%{%s}': macro parameters out of range",
          &tline->text[1]);
    return NULL;
}

/*
 * Expand MMacro-local things: parameter references (%0, %n, %+n,
 * %-n) and MMacro-local identifiers (%%foo) as well as
 * macro indirection (%[...]) and range (%{..:..}).
 */
static Token *expand_mmac_params(Token * tline)
{
    Token **tail, *thead;
    bool changed = false;
    MMacro *mac = istk->mstk.mmac;

    tail = &thead;
    thead = NULL;

    while (tline) {
        bool change;
        Token *t = tline;
        char *text = t->text;
        int type = t->type;

        tline = tline->next;
        t->next = NULL;

        switch (type) {
        case TOK_PREPROC_ID:
        {
            Token *tt = NULL;

            change = false;

            if (!text || !text[0])
                break;
            if (!(nasm_isdigit(text[1]) || text[1] == '%' ||
                  ((text[1] == '+' || text[1] == '-') && text[2])))
                break;

            change = true;

            if (!mac) {
                nasm_nonfatal("`%s': not in a macro call", text);
                text = NULL;
                break;
            }

            if (strchr(text, ':')) {
                /*
                 * seems we have a parameters range here
                 */
                Token *head, **last;
                head = expand_mmac_params_range(mac, t, &last);
                if (head) {
                    *tail = head;
                    *last = tline;
                    text = NULL;
                }
                break;
            }

            switch (text[1]) {
                /*
                 * We have to make a substitution of one of the
                 * forms %1, %-1, %+1, %%foo, %0, %00.
                 */
            case '0':
                if (!text[2]) {
                    type = TOK_NUMBER;
                    text = nasm_asprintf("%d", mac->nparam);
                    break;
                }
                if (text[2] != '0' || text[3])
                    goto invalid;
                /* a possible captured label == mac->params[0] */
                /* fall through */
            default:
            {
                unsigned long n;
                char *ep;

                n = strtoul(text + 1, &ep, 10);
                if (unlikely(*ep))
                    goto invalid;

                if (n <= mac->nparam) {
                    n = mmac_rotate(mac, n);
                    dup_tlistn(mac->params[n], mac->paramlen[n], &tail);
                }
                text = NULL;
                break;
            }
            case '%':
                type = TOK_ID;
                text = nasm_asprintf("..@%"PRIu64".%s", mac->unique, text+2);
                break;
            case '-':
            case '+':
            {
                int cc;
                unsigned long n;
                char *ep;

                text = NULL;

                n = strtoul(t->text + 2, &ep, 10);
                if (unlikely(*ep))
                    goto invalid;

                if (n && n < mac->nparam) {
                    n = mmac_rotate(mac, n);
                    tt = mac->params[n];
                }
                cc = find_cc(tt);
                if (cc == -1) {
                    nasm_nonfatal("macro parameter `%s' is not a condition code",
                                  text);
                    text = NULL;
                    break;
                }

                type = TOK_ID;
                if (text[1] == '-') {
                    int ncc = inverse_ccs[cc];
                    if (unlikely(ncc == -1)) {
                        nasm_nonfatal("condition code `%s' is not invertible",
                                      conditions[cc]);
                        break;
                    }
                    cc = ncc;
                }
                text = nasm_strdup(conditions[cc]);
                break;
            }

            invalid:
                nasm_nonfatal("invalid macro parameter: `%s'", text);
                text = NULL;
                break;
            }
            break;
        }

        case TOK_PREPROC_Q:
            if (mac) {
                type = TOK_ID;
                text = nasm_strdup(mac->iname);
                change = true;
            }
            break;

        case TOK_PREPROC_QQ:
            if (mac) {
                type = TOK_ID;
                text = nasm_strdup(mac->name);
                change = true;
            }
            break;

        case TOK_INDIRECT:
        {
            Token *tt;

            tt = tokenize(t->text);
            tt = expand_mmac_params(tt);
            tt = expand_smacro(tt);
            /* Why dup_tlist() here? We should own tt... */
            dup_tlist(tt, &tail);
            text = NULL;
            change = true;
            break;
        }

        default:
            change = false;
            break;
        }

        if (change) {
            if (!text) {
                delete_Token(t);
            } else {
                *tail = t;
                tail = &t->next;
                nasm_free(t->text);
                t->len = strlen(text);
                t->type = type;
                t->text = text;
            }
            changed = true;
        } else {
            *tail = t;
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

    return thead;
}

static Token *expand_smacro_noreset(Token * tline);

/*
 * Expand *one* single-line macro instance. If the first token is not
 * a macro at all, it is simply copied to the output and the pointer
 * advanced.  tpp should be a pointer to a pointer (usually the next
 * pointer of the previous token) to the first token. **tpp is updated
 * to point to the last token of the expansion, and *tpp updated to
 * point to the next pointer of the first token of the expansion.
 *
 * If the expansion is empty, *tpp will be unchanged but **tpp will
 * be advanced past the macro call.
 *
 * Return the macro expanded, or NULL if no expansion took place.
 */
static SMacro *expand_one_smacro(Token ***tpp)
{
    Token **params = NULL;
    const char *mname;
    Token *tline  = **tpp;
    Token *mstart = **tpp;
    SMacro *head, *m;
    int i;
    Token *t, *tup, *ttail;
    int nparam = 0;

    if (!tline)
        return false;           /* Empty line, nothing to do */

    mname = tline->text;

    smacro_deadman.total--;
    smacro_deadman.levels--;

    if (unlikely(smacro_deadman.total < 0 || smacro_deadman.levels < 0)) {
        if (unlikely(!smacro_deadman.triggered)) {
            nasm_nonfatal("interminable macro recursion");
            smacro_deadman.triggered = true;
        }
        goto not_a_macro;
    } else if (tline->type == TOK_ID) {
        head = (SMacro *)hash_findix(&smacros, mname);
    } else if (tline->type == TOK_PREPROC_ID) {
        Context *ctx = get_ctx(mname, &mname);
        head = ctx ? (SMacro *)hash_findix(&ctx->localmac, mname) : NULL;
    } else {
        goto not_a_macro;
    }

    /*
     * We've hit an identifier of some sort. First check whether the
     * identifier is a single-line macro at all, then think about
     * checking for parameters if necessary.
     */
    list_for_each(m, head) {
        if (!mstrcmp(m->name, mname, m->casesense))
            break;
    }

    if (!m) {
        goto not_a_macro;
    }

    /* Parse parameters, if applicable */

    params = NULL;
    nparam = 0;

    if (m->nparam == 0) {
        /*
         * Simple case: the macro is parameterless.
         * Nothing to parse; the expansion code will
         * drop the macro name token.
         */
    } else {
        /*
         * Complicated case: at least one macro with this name
         * exists and takes parameters. We must find the
         * parameters in the call, count them, find the SMacro
         * that corresponds to that form of the macro call, and
         * substitute for the parameters when we expand. What a
         * pain.
         */
        Token *t;
        int paren, brackets;

        tline = tline->next;
        skip_white_(tline);
        if (!tok_is_(tline, "(")) {
            /*
             * This macro wasn't called with parameters: ignore
             * the call. (Behaviour borrowed from gnu cpp.)
             */
            goto not_a_macro;
        }

        paren = 1;
        nparam = 1;
        t = tline;              /* tline points to leading ( */

        while (paren) {
            t = t->next;

            if (!t) {
                nasm_nonfatal("macro call expects terminating `)'");
                goto not_a_macro;
            }

            if (tline->type != TOK_OTHER || tline->len != 1)
                continue;

            switch (tline->text[0]) {
            case ',':
                if (!brackets)
                    nparam++;
                break;

            case '{':
                brackets++;
                break;

            case '}':
                if (brackets > 0)
                    brackets--;
                break;

            case '(':
                if (!brackets)
                    paren++;
                break;

            case ')':
                if (!brackets)
                    paren--;
                break;

            default:
                break;          /* Normal token */
            }
        }

        /*
         * Look for a macro matching in both name and parameter count.
         * We already know any matches cannot be anywhere before the
         * current position of "m", so there is no reason to
         * backtrack.
         */
        while (1) {
            if (!m) {
                /*!
                 *!macro-params-single [on] single-line macro calls with wrong parameter count
                 *!  warns about \i{single-line macros} being invoked
                 *!  with the wrong number of parameters.
                 */
                nasm_warn(WARN_MACRO_PARAMS_SINGLE,
                    "single-line macro `%s' exists, "
                    "but not taking %d parameter%s",
                    mname, nparam, (nparam == 1) ? "" : "s");
                goto not_a_macro;
            }

            if (!mstrcmp(m->name, mname, m->casesense)) {
                if (m->nparam == nparam)
                    break;      /* It's good */
                if (m->greedy && m->nparam < nparam)
                    break;      /* Also good */
            }
            m = m->next;
        }
    }

    if (m->in_progress)
        goto not_a_macro;

    /* Expand the macro */
    m->in_progress = true;

    nparam = m->nparam;         /* If greedy, some parameters might be joint */

    if (nparam) {
        /* Extract parameters */
        Token **phead, **pep;
        int white = 0;
        int brackets = 0;
        int paren;
        bool bracketed = false;
        bool bad_bracket = false;
        enum sparmflags flags;

        nparam = m->nparam;

        paren = 1;
        nasm_newn(params, nparam);
        i = 0;
        flags = m->params[i].flags;
        phead = pep = &params[i];
        *pep = NULL;

        while (paren) {
            bool skip;
            char ch;

            tline = tline->next;

            if (!tline)
                nasm_nonfatal("macro call expects terminating `)'");

            ch = 0;
            skip = false;


            switch (tline->type) {
            case TOK_OTHER:
                if (tline->len == 1)
                    ch = tline->text[0];
                break;

            case TOK_WHITESPACE:
                if (!(flags & SPARM_NOSTRIP)) {
                    if (brackets || *phead)
                        white++;    /* Keep interior whitespace */
                    skip = true;
                }
                break;

            default:
                break;
            }

            switch (ch) {
            case ',':
                if (!brackets && !(flags & SPARM_GREEDY)) {
                    i++;
                    nasm_assert(i < nparam);
                    phead = pep = &params[i];
                    *pep = NULL;
                    bracketed = false;
                    skip = true;
                    flags = m->params[i].flags;
                }
                break;

            case '{':
                if (!bracketed) {
                    bracketed = !*phead && !(flags & SPARM_NOSTRIP);
                    skip = bracketed;
                }
                brackets++;
                break;

            case '}':
                if (brackets > 0) {
                    if (!--brackets)
                        skip = bracketed;
                }
                break;

            case '(':
                if (!brackets)
                    paren++;
                break;

            case ')':
                if (!brackets) {
                    paren--;
                    if (!paren) {
                        skip = true;
                        i++;    /* Found last argument */
                    }
                }
                break;

            default:
                break;          /* Normal token */
            }

            if (!skip) {
                Token *t;

                bad_bracket |= bracketed && !brackets;

                if (white) {
                    *pep = t = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
                    pep = &t->next;
                    white = 0;
                }
                *pep = t = dup_Token(NULL, tline);
                pep = &t->next;
                white = 0;
            }
        }

        nasm_assert(i == nparam);

        /*
         * Possible further processing of parameters. Note that the
         * ordering matters here.
         */
        for (i = 0; i < nparam; i++) {
            enum sparmflags flags = m->params[i].flags;

            if (flags & SPARM_EVAL) {
                /* Evaluate this parameter as a number */
                struct ppscan pps;
                struct tokenval tokval;
                expr *evalresult;
                Token *eval_param;

                pps.tptr = eval_param = expand_smacro_noreset(params[i]);
                pps.ntokens = -1;
                tokval.t_type = TOKEN_INVALID;
                evalresult = evaluate(ppscan, &pps, &tokval, NULL, true, NULL);

                free_tlist(eval_param);
                params[i] = NULL;

                if (!evalresult) {
                    /* Nothing meaningful to do */
                } else if (tokval.t_type) {
                    nasm_nonfatal("invalid expression in parameter %d of macro `%s'", i, m->name);
                } else if (!is_simple(evalresult)) {
                    nasm_nonfatal("non-constant expression in parameter %d of macro `%s'", i, m->name);
                } else {
                    params[i] = make_tok_num(reloc_value(evalresult));
                }
            }

            if (flags & SPARM_STR) {
                /* Convert expansion to a quoted string */
                char *arg;
                Token *qs;

                qs = expand_smacro_noreset(params[i]);
                arg = detoken(qs, false);
                free_tlist(qs);
                params[i] = make_tok_qstr(arg);
                nasm_free(arg);
            }
        }
    }

    t = tline;
    tline = tline->next;    /* Remove the macro call from the input */
    t->next = NULL;

    /* Note: we own the expansion this returns. */
    t = m->expand(m, params, nparam);

    tup = NULL;
    ttail = NULL;     /* Pointer to the last token of the expansion */
    while (t) {
        enum pp_token_type type = t->type;
        Token *tnext = t->next;
        Token **tp;

        switch (type) {
        case TOK_PREPROC_Q:
        case TOK_PREPROC_QQ:
            t->type = TOK_ID;
            nasm_free(t->text);
            t->text = nasm_strdup(type == TOK_PREPROC_QQ ? m->name : mname);
            t->len = nasm_last_string_len();
            t->next = tline;
            break;

        case TOK_ID:
        case TOK_PREPROC_ID:
            /*
             * Chain this into the target line *before* expanding,
             * that way we pick up any arguments to the new macro call,
             * if applicable.
             */
            t->next = tline;
            tp = &t;
            expand_one_smacro(&tp);
            if (t == tline)
                t = NULL;       /* Null expansion */
            break;

        default:
            if (is_smac_param(t->type)) {
                int param = smac_nparam(t->type);
                nasm_assert(!tup && param < nparam);
                delete_Token(t);
                t = NULL;
                tup = tnext;
                tnext = dup_tlist_reverse(params[param], NULL);
            } else {
                t->next = tline;
            }
        }

        if (t) {
            tline = t;
            if (!ttail)
                ttail = t;
        }

        if (tnext) {
            t = tnext;
        } else {
            t = tup;
            tup = NULL;
        }
    }

    **tpp = tline;
    if (ttail)
        *tpp = &ttail->next;

    m->in_progress = false;

    /* Don't do this until after expansion or we will clobber mname */
    free_tlist(mstart);
    goto done;

    /*
     * No macro expansion needed; roll back to mstart (if necessary)
     * and then advance to the next input token. Note that this is
     * by far the common case!
     */
not_a_macro:
    *tpp = &mstart->next;
    m = NULL;
done:
    smacro_deadman.levels++;
    if (unlikely(params))
        free_tlist_array(params, nparam);
    return m;
}

/*
 * Expand all single-line macro calls made in the given line.
 * Return the expanded version of the line. The original is deemed
 * to be destroyed in the process. (In reality we'll just move
 * Tokens from input to output a lot of the time, rather than
 * actually bothering to destroy and replicate.)
 */
static Token *expand_smacro(Token *tline)
{
    smacro_deadman.total  = nasm_limit[LIMIT_MACRO_TOKENS];
    smacro_deadman.levels = nasm_limit[LIMIT_MACRO_LEVELS];
    smacro_deadman.triggered = false;
    return expand_smacro_noreset(tline);
}

static Token *expand_smacro_noreset(Token * tline)
{
    Token *t, **tail, *thead;
    Token *org_tline = tline;
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
        nasm_free(org_tline->text);
        org_tline->text = NULL;
    }


    /*
     * Pretend that we always end up doing expansion on the first pass;
     * that way %+ get processed. However, if we process %+ before the
     * first pass, we end up with things like MACRO %+ TAIL trying to
     * look up the macro "MACROTAIL", which we don't want.
     */
    expanded = true;
    thead = tline;
    while (true) {
        static const struct tokseq_match tmatch[] = {
            {
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_PREPROC_ID),     /* head */
                PP_CONCAT_MASK(TOK_ID)          |
                PP_CONCAT_MASK(TOK_PREPROC_ID)  |
                PP_CONCAT_MASK(TOK_NUMBER)          /* tail */
            }
        };

        tail = &thead;
        while ((t = *tail))     /* main token loop */
            expanded |= !!expand_one_smacro(&tail);

        if (!expanded) {
            tline = thead;
            break;              /* Done! */
        }

        /*
         * Now scan the entire line and look for successive TOK_IDs
         * that resulted after expansion (they can't be produced by
         * tokenize()). The successive TOK_IDs should be concatenated.
         * Also we look for %+ tokens and concatenate the tokens
         * before and after them (without white spaces in between).
         */
        paste_tokens(&thead, tmatch, ARRAY_SIZE(tmatch), true);

        expanded = false;
    }

    if (org_tline) {
        if (thead) {
            *org_tline = *thead;
            /* since we just gave text to org_line, don't free it */
            thead->text = NULL;
            delete_Token(thead);
        } else {
            /*
             * The expression expanded to empty line;
             * we can't return NULL because of the "trick" above.
             * Just set the line to a single WHITESPACE token.
             */
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
           (cur->next->type == TOK_ID ||
            cur->next->type == TOK_PREPROC_ID
            || cur->next->type == TOK_NUMBER))
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
 * call, and return the MMacro structure called if so. Doesn't have
 * to check for an initial label - that's taken care of in
 * expand_mmacro - but must check numbers of parameters. Guaranteed
 * to be called with tline->type == TOK_ID, so the putative macro
 * name is easy to find.
 */
static MMacro *is_mmacro(Token * tline, int *nparamp, Token ***params_array)
{
    MMacro *head, *m;
    Token **params;
    int nparam;

    head = (MMacro *) hash_findix(&mmacros, tline->text);

    /*
     * Efficiency: first we see if any macro exists with the given
     * name. If not, we can return NULL immediately. _Then_ we
     * count the parameters, and then we look further along the
     * list if necessary to find the proper MMacro.
     */
    list_for_each(m, head)
        if (!mstrcmp(m->name, tline->text, m->casesense))
            break;
    if (!m)
        return NULL;

    /*
     * OK, we have a potential macro. Count and demarcate the
     * parameters.
     */
    count_mmac_params(tline->next, &nparam, &params);

    /*
     * So we know how many parameters we've got. Find the MMacro
     * structure that handles this number.
     */
    while (m) {
        if (m->nparam_min <= nparam
            && (m->plus || nparam <= m->nparam_max)) {
            /*
             * This one is right. Just check if cycle removal
             * prohibits us using it before we actually celebrate...
             */
            if (m->in_progress > m->max_depth) {
                if (m->max_depth > 0) {
                    nasm_warn(WARN_OTHER, "reached maximum recursion depth of %i",
                              m->max_depth);
                }
                nasm_free(params);
                return NULL;
            }
            /*
             * It's right, and we can use it. Add its default
             * parameters to the end of our list if necessary.
             */
            if (m->defaults && nparam < m->nparam_min + m->ndefs) {
                params =
                    nasm_realloc(params, sizeof(*params) *
                                 (m->nparam_min + m->ndefs + 2));
                while (nparam < m->nparam_min + m->ndefs) {
                    nparam++;
                    params[nparam] = m->defaults[nparam - m->nparam_min];
                }
            }
            /*
             * If we've gone over the maximum parameter count (and
             * we're in Plus mode), ignore parameters beyond
             * nparam_max.
             */
            if (m->plus && nparam > m->nparam_max)
                nparam = m->nparam_max;

            /* Done! */
            *params_array = params;
            *nparamp = nparam;
            return m;
        }
        /*
         * This one wasn't right: look for the next one with the
         * same name.
         */
        list_for_each(m, m->next)
            if (!mstrcmp(m->name, tline->text, m->casesense))
                break;
    }

    /*
     * After all that, we didn't find one with the right number of
     * parameters. Issue a warning, and fail to expand the macro.
     *!
     *!macro-params-multi [on] multi-line macro calls with wrong parameter count
     *!  warns about \i{multi-line macros} being invoked
     *!  with the wrong number of parameters. See \k{mlmacover} for an
     *!  example of why you might want to disable this warning.
     */
    nasm_warn(WARN_MACRO_PARAMS_MULTI,
               "multi-line macro `%s' exists, but not taking %d parameter%s",
              tline->text, nparam, (nparam == 1) ? "" : "s");
    nasm_free(params);
    return NULL;
}


#if 0

/*
 * Save MMacro invocation specific fields in
 * preparation for a recursive macro expansion
 */
static void push_mmacro(MMacro *m)
{
    MMacroInvocation *i;

    i = nasm_malloc(sizeof(MMacroInvocation));
    i->prev = m->prev;
    i->params = m->params;
    i->iline = m->iline;
    i->nparam = m->nparam;
    i->rotate = m->rotate;
    i->paramlen = m->paramlen;
    i->unique = m->unique;
    i->condcnt = m->condcnt;
    m->prev = i;
}


/*
 * Restore MMacro invocation specific fields that were
 * saved during a previous recursive macro expansion
 */
static void pop_mmacro(MMacro *m)
{
    MMacroInvocation *i;

    if (m->prev) {
        i = m->prev;
        m->prev = i->prev;
        m->params = i->params;
        m->iline = i->iline;
        m->nparam = i->nparam;
        m->rotate = i->rotate;
        m->paramlen = i->paramlen;
        m->unique = i->unique;
        m->condcnt = i->condcnt;
        nasm_free(i);
    }
}

#endif

/*
 * Expand the multi-line macro call made by the given line, if
 * there is one to be expanded. If there is, push the expansion on
 * istk->expansion and return 1. Otherwise return 0.
 */
static int expand_mmacro(Token * tline)
{
    Token *startline = tline;
    Token *label = NULL;
    bool dont_prepend = false;
    Token **params, *t, *tt;
    MMacro *m;
    Line *l, *ll;
    int i, *paramlen;
    const char *mname;
    int nparam = 0;

    t = tline;
    skip_white_(t);
    /*    if (!tok_type_(t, TOK_ID))  Lino 02/25/02 */
    if (!tok_type_(t, TOK_ID) && !tok_type_(t, TOK_PREPROC_ID))
        return 0;
    m = is_mmacro(t, &nparam, &params);
    if (m) {
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
            dont_prepend = true;
            last = t, t = t->next;
            if (tok_type_(t, TOK_WHITESPACE))
                last = t, t = t->next;
        }
        if (!tok_type_(t, TOK_ID) || !(m = is_mmacro(t, &nparam, &params)))
            return 0;
        last->next = NULL;
        mname = t->text;
        tline = t;
    }

    if (unlikely(mmacro_deadman.total >= nasm_limit[LIMIT_MMACROS] ||
                 mmacro_deadman.levels >= nasm_limit[LIMIT_MACRO_LEVELS])) {
        if (!mmacro_deadman.triggered) {
            nasm_nonfatal("interminable multiline macro recursion");
            mmacro_deadman.triggered = true;
        }
        return 0;
    }

    mmacro_deadman.total++;
    mmacro_deadman.levels++;

    /*
     * Fix up the parameters: this involves stripping leading and
     * trailing whitespace, then stripping braces if they are
     * present.
     */
    nasm_newn(paramlen, nparam+1);

    for (i = 1; (t = params[i]); i++) {
        int brace = 0;
        int comma = !m->plus || i < nparam;

        skip_white_(t);
        if (tok_is_(t, "{"))
            t = t->next, brace++, comma = false;
        params[i] = t;
        while (t) {
            if (comma && t->type == TOK_OTHER && !strcmp(t->text, ","))
                break;          /* ... because we have hit a comma */
            if (comma && t->type == TOK_WHITESPACE
                && tok_is_(t->next, ","))
                break;          /* ... or a space then a comma */
            if (brace && t->type == TOK_OTHER) {
                if (t->text[0] == '{')
                    brace++;            /* ... or a nested opening brace */
                else if (t->text[0] == '}')
                    if (!--brace)
                        break;          /* ... or a brace */
            }
            t = t->next;
            paramlen[i]++;
        }
        if (brace)
            nasm_nonfatal("macro params should be enclosed in braces");
    }

    /*
     * OK, we have a MMacro structure together with a set of
     * parameters. We must now go through the expansion and push
     * copies of each Line on to istk->expansion. Substitution of
     * parameter tokens and macro-local tokens doesn't get done
     * until the single-line macro substitution process; this is
     * because delaying them allows us to change the semantics
     * later through %rotate and give the right semantics for
     * nested mmacros.
     *
     * First, push an end marker on to istk->expansion, mark this
     * macro as in progress, and set up its invocation-specific
     * variables.
     */
    nasm_new(ll);
    ll->next = istk->expansion;
    ll->finishes = m;
    istk->expansion = ll;

    /*
     * Save the previous MMacro expansion in the case of
     * macro recursion
     */
#if 0
    if (m->max_depth && m->in_progress)
        push_mmacro(m);
#endif

    m->in_progress ++;
    m->params = params;
    m->iline = tline;
    m->iname = nasm_strdup(mname);
    m->nparam = nparam;
    m->rotate = 0;
    m->paramlen = paramlen;
    m->unique = unique++;
    m->lineno = 0;
    m->condcnt = 0;

    m->mstk = istk->mstk;
    istk->mstk.mstk = istk->mstk.mmac = m;

    list_for_each(l, m->expansion) {
        nasm_new(ll);
        ll->next = istk->expansion;
        istk->expansion = ll;
        ll->first = dup_tlist(l->first, NULL);
    }

    /*
     * If we had a label, and this macro definition does not include
     * a %00, push it on as the first line of, ot
     * the macro expansion.
     */
    if (label) {
        /*
         * We had a label. If this macro contains an %00 parameter,
         * save the value as a special parameter (which is what it
         * is), otherwise push it as the first line of the macro
         * expansion.
         */
        if (m->capture_label) {
            params[0] = dup_Token(NULL, label);
            paramlen[0] = 1;
            free_tlist(startline);
       } else {
            nasm_new(ll);
            ll->finishes = NULL;
            ll->next = istk->expansion;
            istk->expansion = ll;
            ll->first = startline;
            if (!dont_prepend) {
                while (label->next)
                    label = label->next;
                label->next = tt = new_Token(NULL, TOK_OTHER, ":", 0);
            }
        }
    }

    lfmt->uplevel(m->nolist ? LIST_MACRO_NOLIST : LIST_MACRO, 0);

    return 1;
}

/*
 * This function adds macro names to error messages, and suppresses
 * them if necessary.
 */
static void pp_verror(errflags severity, const char *fmt, va_list arg)
{
    /*
     * If we're in a dead branch of IF or something like it, ignore the error.
     * However, because %else etc are evaluated in the state context
     * of the previous branch, errors might get lost:
     *   %if 0 ... %else trailing garbage ... %endif
     * So %else etc should set the ERR_PP_PRECOND flag.
     */
    if ((severity & ERR_MASK) < ERR_FATAL &&
	istk && istk->conds &&
	((severity & ERR_PP_PRECOND) ?
	 istk->conds->state == COND_NEVER :
	 !emitting(istk->conds->state)))
	return;

    /* This doesn't make sense with the macro stack unwinding */
    if (0) {
        int32_t delta = 0;

        /* get %macro name */
        if (!(severity & ERR_NOFILE) && istk && istk->mstk.mmac) {
            MMacro *mmac = istk->mstk.mmac;
            char *buf;

            nasm_set_verror(real_verror);
            buf = nasm_vasprintf(fmt, arg);
            nasm_error(severity, "(%s:%"PRId32") %s",
                       mmac->name, mmac->lineno - delta, buf);
            nasm_set_verror(pp_verror);
            nasm_free(buf);
            return;
        }
    }
    real_verror(severity, fmt, arg);
}

static Token *
stdmac_file(const SMacro *s, Token **params, int nparams)
{
    (void)s;
    (void)params;
    (void)nparams;

    return make_tok_qstr(src_get_fname());
}

static Token *
stdmac_line(const SMacro *s, Token **params, int nparams)
{
    (void)s;
    (void)params;
    (void)nparams;

    return make_tok_num(src_get_linnum());
}

static Token *
stdmac_bits(const SMacro *s, Token **params, int nparams)
{
    (void)s;
    (void)params;
    (void)nparams;

    return make_tok_num(globalbits);
}

static Token *
stdmac_ptr(const SMacro *s, Token **params, int nparams)
{
    const Token *t;
    static const Token ptr_word  = { NULL, "word", 4, TOK_ID };
    static const Token ptr_dword = { NULL, "dword", 5, TOK_ID };
    static const Token ptr_qword = { NULL, "qword", 5, TOK_ID };

    (void)s;
    (void)params;
    (void)nparams;

    switch (globalbits) {
    case 16:
        t = &ptr_word;
        break;
    case 32:
        t = &ptr_dword;
        break;
    case 64:
        t = &ptr_qword;
        break;
    default:
        panic();
    }

    return dup_Token(NULL, t);
}

/* Add magic standard macros */
struct magic_macros {
    const char *name;
    int nparam;
    ExpandSMacro func;
};
static const struct magic_macros magic_macros[] =
{
    { "__FILE__", 0, stdmac_file },
    { "__LINE__", 0, stdmac_line },
    { "__BITS__", 0, stdmac_bits },
    { "__PTR__",  0, stdmac_ptr },
    { NULL, 0, NULL }
};

static void pp_add_magic_stdmac(void)
{
    const struct magic_macros *m;
    SMacro tmpl;

    nasm_zero(tmpl);

    for (m = magic_macros; m->name; m++) {
        tmpl.nparam = m->nparam;
        tmpl.expand = m->func;
        define_smacro(m->name, true, NULL, &tmpl);
    }
}

static void
pp_reset(const char *file, enum preproc_mode mode, struct strlist *dep_list)
{
    int apass;
    struct Include *inc;

    cstk = NULL;
    defining = NULL;
    nested_mac_count = 0;
    nested_rep_count = 0;
    init_macros();
    unique = 0;
    deplist = dep_list;
    pp_mode = mode;

    if (!use_loaded)
        use_loaded = nasm_malloc(use_package_count * sizeof(bool));
    memset(use_loaded, 0, use_package_count * sizeof(bool));

    /* First set up the top level input file */
    nasm_new(istk);
    istk->fp = nasm_open_read(file, NF_TEXT);
    src_set(0, file);
    istk->lineinc = 1;
    if (!istk->fp)
	nasm_fatalf(ERR_NOFILE, "unable to open input file `%s'", file);

    strlist_add(deplist, file);

    /*
     * Set up the stdmac packages as a virtual include file,
     * indicated by a null file pointer.
     */
    nasm_new(inc);
    inc->next = istk;
    inc->fname = src_set_fname(NULL);
    inc->nolist = !list_option('b');
    istk = inc;
    lfmt->uplevel(LIST_INCLUDE, 0);

    pp_add_magic_stdmac();

    if (tasm_compatible_mode)
        pp_add_stdmac(nasm_stdmac_tasm);

    pp_add_stdmac(nasm_stdmac_nasm);
    pp_add_stdmac(nasm_stdmac_version);

    if (extrastdmac)
        pp_add_stdmac(extrastdmac);

    stdmacpos  = stdmacros[0];
    stdmacnext = &stdmacros[1];

    do_predef = true;

    /*
     * Define the __PASS__ macro.  This is defined here unlike all the
     * other builtins, because it is special -- it varies between
     * passes -- but there is really no particular reason to make it
     * magic.
     *
     * 0 = dependencies only
     * 1 = preparatory passes
     * 2 = final pass
     * 3 = preproces only
     */
    switch (mode) {
    case PP_NORMAL:
        apass = pass_final() ? 2 : 1;
        break;
    case PP_DEPS:
        apass = 0;
        break;
    case PP_PREPROC:
        apass = 3;
        break;
    default:
        panic();
    }

    define_smacro("__PASS__", true, make_tok_num(apass), NULL);
}

static void pp_init(void)
{
}

/*
 * Get a line of tokens. If we popped the macro expansion/include stack,
 * we return a pointer to the dummy token tok_pop; at that point if
 * istk is NULL then we have reached end of input;
 */
static Token tok_pop;           /* Dummy token placeholder */

static Token *pp_tokline(void)
{
    while (true) {
        Line *l = istk->expansion;
        Token *tline = NULL;
        Token *dtline;

        /*
         * Fetch a tokenized line, either from the macro-expansion
         * buffer or from the input file.
         */
        tline = NULL;
        while (l && l->finishes) {
            MMacro *fm = l->finishes;

            if (!fm->name && fm->in_progress > 1) {
                /*
                 * This is a macro-end marker for a macro with no
                 * name, which means it's not really a macro at all
                 * but a %rep block, and the `in_progress' field is
                 * more than 1, meaning that we still need to
                 * repeat. (1 means the natural last repetition; 0
                 * means termination by %exitrep.) We have
                 * therefore expanded up to the %endrep, and must
                 * push the whole block on to the expansion buffer
                 * again. We don't bother to remove the macro-end
                 * marker: we'd only have to generate another one
                 * if we did.
                 */
                fm->in_progress--;
                list_for_each(l, fm->expansion) {
                    Token *t, *tt, **tail;
                    Line *ll;

                    nasm_new(ll);
                    ll->next = istk->expansion;
                    tail = &ll->first;

                    list_for_each(t, l->first) {
                        if (t->text || t->type == TOK_WHITESPACE) {
                            tt = *tail = dup_Token(NULL, t);
                            tail = &tt->next;
                        }
                    }
                    istk->expansion = ll;
                }
                break;
            } else {
                MMacro *m = istk->mstk.mstk;

                /*
                 * Check whether a `%rep' was started and not ended
                 * within this macro expansion. This can happen and
                 * should be detected. It's a fatal error because
                 * I'm too confused to work out how to recover
                 * sensibly from it.
                 */
                if (defining) {
                    if (defining->name)
                        nasm_panic("defining with name in expansion");
                    else if (m->name)
                        nasm_fatal("`%%rep' without `%%endrep' within"
				   " expansion of macro `%s'", m->name);
                }

                /*
                 * FIXME:  investigate the relationship at this point between
                 * istk->mstk.mstk and fm
                 */
                istk->mstk = m->mstk;
                if (m->name) {
                    /*
                     * This was a real macro call, not a %rep, and
                     * therefore the parameter information needs to
                     * be freed and the iteration count/nesting
                     * depth adjusted.
                     */

                    if (!--mmacro_deadman.levels) {
                        /*
                         * If all mmacro processing done,
                         * clear all counters and the deadman
                         * message trigger.
                         */
                        nasm_zero(mmacro_deadman); /* Clear all counters */
                    }

#if 0
                    if (m->prev) {
                        pop_mmacro(m);
                        fm->in_progress --;
                    } else
#endif
                    {
                        nasm_free(m->params);
                        free_tlist(m->iline);
                        nasm_free(m->paramlen);
                        fm->in_progress = 0;
                    }
                }

                /*
                 * FIXME It is incorrect to always free_mmacro here.
                 * It leads to usage-after-free.
                 *
                 * https://bugzilla.nasm.us/show_bug.cgi?id=3392414
                 */
#if 0
                else
                    free_mmacro(m);
#endif
            }
            istk->expansion = l->next;
            nasm_free(l);
            lfmt->downlevel(LIST_MACRO);
            return &tok_pop;
        }

        do {                    /* until we get a line we can use */
            char *line;

            if (istk->expansion) {      /* from a macro expansion */
                Line *l = istk->expansion;
                int32_t lineno;

                if (istk->mstk.mstk) {
                    istk->mstk.mstk->lineno++;
                    if (istk->mstk.mstk->fname)
                        lineno = istk->mstk.mstk->lineno +
                            istk->mstk.mstk->xline;
                    else
                        lineno = 0; /* Defined at init time or builtin */
                } else {
                    lineno = src_get_linnum();
                }

                tline = l->first;
                istk->expansion = l->next;
                nasm_free(l);

                line = detoken(tline, false);
                if (!istk->nolist)
                    lfmt->line(LIST_MACRO, lineno, line);
                nasm_free(line);
            } else if ((line = read_line())) {
                line = prepreproc(line);
                tline = tokenize(line);
                nasm_free(line);
            } else {
                /*
                 * The current file has ended; work down the istk
                 */
                Include *i = istk;
                if (i->fp)
                    fclose(i->fp);
                if (i->conds) {
                    /* nasm_error can't be conditionally suppressed */
                    nasm_fatal("expected `%%endif' before end of file");
                }
                /* only set line and file name if there's a next node */
                if (i->next)
                    src_set(i->lineno, i->fname);
                istk = i->next;
                lfmt->downlevel(LIST_INCLUDE);
                nasm_free(i);
                return &tok_pop;
            }
        } while (0);

        /*
         * We must expand MMacro parameters and MMacro-local labels
         * _before_ we plunge into directive processing, to cope
         * with things like `%define something %1' such as STRUC
         * uses. Unless we're _defining_ a MMacro, in which case
         * those tokens should be left alone to go into the
         * definition; and unless we're in a non-emitting
         * condition, in which case we don't want to meddle with
         * anything.
         */
        if (!defining && !(istk->conds && !emitting(istk->conds->state))
            && !(istk->mstk.mstk && !istk->mstk.mstk->in_progress)) {
            tline = expand_mmac_params(tline);
        }

        /*
         * Check the line to see if it's a preprocessor directive.
         */
        if (do_directive(tline, &dtline) == DIRECTIVE_FOUND) {
            if (dtline)
                return dtline;
        } else if (defining) {
            /*
             * We're defining a multi-line macro. We emit nothing
             * at all, and just
             * shove the tokenized line on to the macro definition.
             */
            MMacro *mmac = defining->dstk.mmac;

            Line *l = nasm_malloc(sizeof(Line));
            l->next = defining->expansion;
            l->first = tline;
            l->finishes = NULL;
            defining->expansion = l;

            /*
             * Remember if this mmacro expansion contains %00:
             * if it does, we will have to handle leading labels
             * specially.
             */
            if (mmac) {
                const Token *t;
                list_for_each(t, tline) {
                    if (t->type == TOK_PREPROC_ID && !strcmp(t->text, "%00"))
                        mmac->capture_label = true;
                }
            }
        } else if (istk->conds && !emitting(istk->conds->state)) {
            /*
             * We're in a non-emitting branch of a condition block.
             * Emit nothing at all, not even a blank line: when we
             * emerge from the condition we'll give a line-number
             * directive so we keep our place correctly.
             */
            free_tlist(tline);
        } else if (istk->mstk.mstk && !istk->mstk.mstk->in_progress) {
            /*
             * We're in a %rep block which has been terminated, so
             * we're walking through to the %endrep without
             * emitting anything. Emit nothing at all, not even a
             * blank line: when we emerge from the %rep block we'll
             * give a line-number directive so we keep our place
             * correctly.
             */
            free_tlist(tline);
        } else {
            tline = expand_smacro(tline);
            if (!expand_mmacro(tline))
                return tline;
        }
    }
}

static char *pp_getline(void)
{
    char *line = NULL;
    Token *tline;

    real_verror = nasm_set_verror(pp_verror);

    while (true) {
        tline = pp_tokline();
        if (tline == &tok_pop) {
            /*
             * We popped the macro/include stack. If istk is empty,
             * we are at end of input, otherwise just loop back.
             */
            if (!istk)
                break;
        } else {
            /*
             * De-tokenize the line and emit it.
             */
            line = detoken(tline, true);
            free_tlist(tline);
            break;
        }
    }

    if (list_option('e') && istk && !istk->nolist && line && line[0]) {
        char *buf = nasm_strcat(" ;;; ", line);
        lfmt->line(LIST_MACRO, -1, buf);
        nasm_free(buf);
    }

    nasm_set_verror(real_verror);
    return line;
}

static void pp_cleanup_pass(void)
{
    real_verror = nasm_set_verror(pp_verror);

    if (defining) {
        if (defining->name) {
            nasm_nonfatal("end of file while still defining macro `%s'",
                          defining->name);
        } else {
            nasm_nonfatal("end of file while still in %%rep");
        }

        free_mmacro(defining);
        defining = NULL;
    }

    nasm_set_verror(real_verror);

    while (cstk)
        ctx_pop();
    free_macros();
    while (istk) {
        Include *i = istk;
        istk = istk->next;
        fclose(i->fp);
        nasm_free(i);
    }
    while (cstk)
        ctx_pop();
    src_set_fname(NULL);
}

static void pp_cleanup_session(void)
{
    nasm_free(use_loaded);
    free_llist(predef);
    predef = NULL;
    delete_Blocks();
    freeTokens = NULL;
    ipath_list = NULL;
}

static void pp_include_path(struct strlist *list)
{
    ipath_list = list;
}

static void pp_pre_include(char *fname)
{
    Token *inc, *space, *name;
    Line *l;

    name = new_Token(NULL, TOK_INTERNAL_STRING, fname, 0);
    space = new_Token(name, TOK_WHITESPACE, NULL, 0);
    inc = new_Token(space, TOK_PREPROC_ID, "%include", 0);

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = inc;
    l->finishes = NULL;
    predef = l;
}

static void pp_pre_define(char *definition)
{
    Token *def, *space;
    Line *l;
    char *equals;

    real_verror = nasm_set_verror(pp_verror);

    equals = strchr(definition, '=');
    space = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
    def = new_Token(space, TOK_PREPROC_ID, "%define", 0);
    if (equals)
        *equals = ' ';
    space->next = tokenize(definition);
    if (equals)
        *equals = '=';

    if (space->next->type != TOK_PREPROC_ID &&
        space->next->type != TOK_ID)
        nasm_warn(WARN_OTHER, "pre-defining non ID `%s\'\n", definition);

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = NULL;
    predef = l;

    nasm_set_verror(real_verror);
}

static void pp_pre_undefine(char *definition)
{
    Token *def, *space;
    Line *l;

    space = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
    def = new_Token(space, TOK_PREPROC_ID, "%undef", 0);
    space->next = tokenize(definition);

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = NULL;
    predef = l;
}

/* Insert an early preprocessor command that doesn't need special handling */
static void pp_pre_command(const char *what, char *string)
{
    char *cmd;
    Token *def, *space;
    Line *l;

    def = tokenize(string);
    if (what) {
        cmd = nasm_strcat(what[0] == '%' ? "" : "%", what);
        space = new_Token(def, TOK_WHITESPACE, NULL, 0);
        def = new_Token(space, TOK_PREPROC_ID, cmd, 0);
    }

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = NULL;
    predef = l;
}

static void pp_add_stdmac(macros_t *macros)
{
    macros_t **mp;

    /* Find the end of the list and avoid duplicates */
    for (mp = stdmacros; *mp; mp++) {
        if (*mp == macros)
            return;             /* Nothing to do */
    }

    nasm_assert(mp < &stdmacros[ARRAY_SIZE(stdmacros)-1]);

    *mp = macros;
}

static void pp_extra_stdmac(macros_t *macros)
{
        extrastdmac = macros;
}

static Token *make_tok_num(int64_t val)
{
    char numbuf[32];
    int len = snprintf(numbuf, sizeof(numbuf), "%"PRId64"", val);
    return new_Token(NULL, TOK_NUMBER, numbuf, len);
}

static Token *make_tok_qstr(const char *str)
{
    Token *t = new_Token(NULL, TOK_STRING, NULL, 0);
    t->text = nasm_quote_cstr(str, &t->len);
    return t;
}

static void pp_list_one_macro(MMacro *m, errflags severity)
{
    if (!m)
	return;

    /* We need to print the mstk.mmac list in reverse order */
    pp_list_one_macro(m->mstk.mmac, severity);

    if (m->name && !m->nolist) {
	src_set(m->xline + m->lineno, m->fname);
	nasm_error(severity, "... from macro `%s' defined", m->name);
    }
}

static void pp_error_list_macros(errflags severity)
{
    struct src_location saved;

    severity |= ERR_PP_LISTMACRO | ERR_NO_SEVERITY | ERR_HERE;
    saved = src_where();

    if (istk)
        pp_list_one_macro(istk->mstk.mmac, severity);

    src_update(saved);
}

const struct preproc_ops nasmpp = {
    pp_init,
    pp_reset,
    pp_getline,
    pp_cleanup_pass,
    pp_cleanup_session,
    pp_extra_stdmac,
    pp_pre_define,
    pp_pre_undefine,
    pp_pre_include,
    pp_pre_command,
    pp_include_path,
    pp_error_list_macros,
};
