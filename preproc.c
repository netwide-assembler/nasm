/* preproc.c   macro preprocessor for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 18/iii/97 by Simon Tatham
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
#include "stdscan.h"
#include "tokens.h"

typedef struct SMacro SMacro;
typedef struct MMacro MMacro;
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
    SMacro *next;
    char *name;
    bool casesense;
    bool in_progress;
    unsigned int nparam;
    Token *expansion;
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
struct MMacro {
    MMacro *next;
    char *name;
    int nparam_min, nparam_max;
    bool casesense;
    bool plus;                   /* is the last parameter greedy? */
    bool nolist;                 /* is this macro listing-inhibited? */
    int64_t in_progress;
    Token *dlist;               /* All defaults as one list */
    Token **defaults;           /* Parameter default pointers */
    int ndefs;                  /* number of default parameters */
    Line *expansion;

    MMacro *next_active;
    MMacro *rep_nest;           /* used for nesting %rep */
    Token **params;             /* actual parameters */
    Token *iline;               /* invocation line */
    unsigned int nparam, rotate;
    int *paramlen;
    uint64_t unique;
    int lineno;                 /* Current line number on expansion */
};

/*
 * The context stack is composed of a linked list of these.
 */
struct Context {
    Context *next;
    SMacro *localmac;
    char *name;
    uint32_t number;
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
    TOK_NONE = 0, TOK_WHITESPACE, TOK_COMMENT, TOK_ID,
    TOK_PREPROC_ID, TOK_STRING,
    TOK_NUMBER, TOK_FLOAT, TOK_SMAC_END, TOK_OTHER, TOK_SMAC_PARAM,
    TOK_INTERNAL_STRING
};

struct Token {
    Token *next;
    char *text;
    SMacro *mac;                /* associated macro for TOK_SMAC_END */
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
    char *fname;
    int lineno, lineinc;
    MMacro *mstk;               /* stack of active macros/reps */
};

/*
 * Include search path. This is simply a list of strings which get
 * prepended, in turn, to the name of an include file, in an
 * attempt to find the file if it's not in the current directory.
 */
struct IncPath {
    IncPath *next;
    char *path;
};

/*
 * Conditional assembly: we maintain a separate stack of these for
 * each level of file inclusion. (The only reason we keep the
 * stacks separate is to ensure that a stray `%endif' in a file
 * included from within the true branch of a `%if' won't terminate
 * it and cause confusion: instead, rightly, it'll cause an error.)
 */
struct Cond {
    Cond *next;
    int state;
};
enum {
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
     * This state means that we're not emitting now, and also that
     * nothing until %endif will be emitted at all. It's for use in
     * two circumstances: (i) when we've had our moment of emission
     * and have now started seeing %elifs, and (ii) when the
     * condition construct in question is contained within a
     * non-emitting branch of a larger condition construct.
     */
    COND_NEVER
};
#define emitting(x) ( (x) == COND_IF_TRUE || (x) == COND_ELSE_TRUE )

/*
 * These defines are used as the possible return values for do_directive
 */
#define NO_DIRECTIVE_FOUND  0
#define DIRECTIVE_FOUND	    1

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

#ifndef MAX
#       define MAX(a,b) ( ((a) > (b)) ? (a) : (b))
#endif

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
static int LocalOffset = 4;

static Context *cstk;
static Include *istk;
static IncPath *ipath = NULL;

static efunc _error;            /* Pointer to client-provided error reporting function */
static evalfunc evaluate;

static int pass;                /* HACK: pass 0 = generate dependencies only */

static uint64_t unique;    /* unique identifier numbers */

static Line *predef = NULL;

static ListGen *list;

/*
 * The current set of multi-line macros we have defined.
 */
static struct hash_table *mmacros;

/*
 * The current set of single-line macros we have defined.
 */
static struct hash_table *smacros;

/*
 * The multi-line macro we are currently defining, or the %rep
 * block we are currently reading, if any.
 */
static MMacro *defining;

/*
 * The number of macro parameters to allocate space for at a time.
 */
#define PARAM_DELTA 16

/*
 * The standard macro set: defined as `static char *stdmac[]'. Also
 * gives our position in the macro set, when we're processing it.
 */
#include "macros.c"
static const char **stdmacpos;

/*
 * The extra standard macros that come from the object format, if
 * any.
 */
static const char **extrastdmac = NULL;
bool any_extrastdmac;

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
static Token *expand_mmac_params(Token * tline);
static Token *expand_smacro(Token * tline);
static Token *expand_id(Token * tline);
static Context *get_ctx(char *name, bool all_contexts);
static void make_tok_num(Token * tok, int64_t val);
static void error(int severity, const char *fmt, ...);
static void *new_Block(size_t size);
static void delete_Blocks(void);
static Token *new_Token(Token * next, enum pp_token_type type, char *text, int txtlen);
static Token *delete_Token(Token * t);

/*
 * Macros for safe checking of token pointers, avoid *(NULL)
 */
#define tok_type_(x,t) ((x) && (x)->type == (t))
#define skip_white_(x) if (tok_type_((x), TOK_WHITESPACE)) (x)=(x)->next
#define tok_is_(x,v) (tok_type_((x), TOK_OTHER) && !strcmp((x)->text,(v)))
#define tok_isnt_(x,v) ((x) && ((x)->type!=TOK_OTHER || strcmp((x)->text,(v))))

/* Handle TASM specific directives, which do not contain a % in
 * front of them. We do it here because I could not find any other
 * place to do it for the moment, and it is a hack (ideally it would
 * be nice to be able to use the NASM pre-processor to do it).
 */
static char *check_tasm_directive(char *line)
{
    int32_t i, j, k, m, len;
    char *p = line, *oldline, oldchar;

    /* Skip whitespace */
    while (isspace(*p) && *p != 0)
        p++;

    /* Binary search for the directive name */
    i = -1;
    j = elements(tasm_directives);
    len = 0;
    while (!isspace(p[len]) && p[len] != 0)
        len++;
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
                    /* NASM does not recognise IFDIFI, so we convert it to
                     * %ifdef BOGUS. This is not used in NASM comaptible
                     * code, but does need to parse for the TASM macro
                     * package.
                     */
                    strcpy(line + 1, "ifdef BOGUS");
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
    while (list) {
        list = delete_Token(list);
    }
}

/*
 * Free a linked list of lines.
 */
static void free_llist(Line * list)
{
    Line *l;
    while (list) {
        l = list;
        list = list->next;
        free_tlist(l->first);
        nasm_free(l);
    }
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
 * Free all currently defined macros, and free the hash tables
 */
static void free_macros(void)
{
    struct hash_tbl_node *it;
    const char *key;
    SMacro *s;
    MMacro *m;

    it = NULL;
    while ((s = hash_iterate(smacros, &it, &key)) != NULL) {
	nasm_free((void *)key);
	while (s) {
	    SMacro *ns = s->next;
	    nasm_free(s->name);
	    free_tlist(s->expansion);
	    nasm_free(s);
	    s = ns;
	}
    }
    hash_free(smacros);

    it = NULL;
    while ((m = hash_iterate(mmacros, &it, &key)) != NULL) {
	nasm_free((void *)key);
	while (m) {
	    MMacro *nm = m->next;
	    free_mmacro(m);
	    m = nm;
	}
    }
    hash_free(mmacros);
}

/*
 * Initialize the hash tables
 */
static void init_macros(void)
{
    smacros = hash_init();
    mmacros = hash_init();
}

/*
 * Pop the context stack.
 */
static void ctx_pop(void)
{
    Context *c = cstk;
    SMacro *smac, *s;

    cstk = cstk->next;
    smac = c->localmac;
    while (smac) {
        s = smac;
        smac = smac->next;
        nasm_free(s->name);
        free_tlist(s->expansion);
        nasm_free(s);
    }
    nasm_free(c->name);
    nasm_free(c);
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

    if (stdmacpos) {
        if (*stdmacpos) {
            char *ret = nasm_strdup(*stdmacpos++);
            if (!*stdmacpos && any_extrastdmac) {
                stdmacpos = extrastdmac;
                any_extrastdmac = false;
                return ret;
            }
            /*
             * Nasty hack: here we push the contents of `predef' on
             * to the top-level expansion stack, since this is the
             * most convenient way to implement the pre-include and
             * pre-define features.
             */
            if (!*stdmacpos) {
                Line *pd, *l;
                Token *head, **tail, *t;

                for (pd = predef; pd; pd = pd->next) {
                    head = NULL;
                    tail = &head;
                    for (t = pd->first; t; t = t->next) {
                        *tail = new_Token(NULL, t->type, t->text, 0);
                        tail = &(*tail)->next;
                    }
                    l = nasm_malloc(sizeof(Line));
                    l->next = istk->expansion;
                    l->first = head;
                    l->finishes = false;
                    istk->expansion = l;
                }
            }
            return ret;
        } else {
            stdmacpos = NULL;
        }
    }

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
            /* Convert backslash-CRLF line continuation sequences into
               nothing at all (for DOS and Windows) */
            if (((p - 2) > buffer) && (p[-3] == '\\') && (p[-2] == '\r')) {
                p -= 3;
                *p = 0;
                continued_count++;
            }
            /* Also convert backslash-LF line continuation sequences into
               nothing at all (for Unix) */
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
    char *p = line;
    enum pp_token_type type;
    Token *list = NULL;
    Token *t, **tail = &list;

    while (*line) {
        p = line;
        if (*p == '%') {
            p++;
            if (isdigit(*p) ||
                ((*p == '-' || *p == '+') && isdigit(p[1])) ||
                ((*p == '+') && (isspace(p[1]) || !p[1]))) {
                do {
                    p++;
                }
                while (isdigit(*p));
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
        } else if (*p == '\'' || *p == '"') {
            /*
             * A string token.
             */
            char c = *p;
            p++;
            type = TOK_STRING;
            while (*p && *p != c)
                p++;

            if (*p) {
                p++;
            } else {
                error(ERR_WARNING, "unterminated string");
                /* Handling unterminated strings by UNV */
                /* type = -1; */
            }
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
			/* e can only be followed by +/- if it is either a
			   prefixed hex number or a floating-point number */
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
		    /* we need to deal with consequences of the legacy
		       parser, like "1.nolist" being two tokens
		       (TOK_NUMBER, TOK_ID) here; at least give it
		       a shot for now.  In the future, we probably need
		       a flex-based scanner with proper pattern matching
		       to do it as well as it can be done.  Nothing in
		       the world is going to help the person who wants
		       0x123.p16 interpreted as two tokens, though. */
		    r = p;
		    while (*r == '_')
			r++;

		    if (isdigit(*r) || (is_hex && isxdigit(*r)) ||
			(!is_hex && (*r == 'e' || *r == 'E')) ||
			(*r == 'p' || *r == 'P')) {
			p = r;
			is_float = true;
		    } else
			break;	/* Terminate the token */
		} else
		    break;
	    }
	    p--;	/* Point to first character beyond number */

	    if (has_e && !is_hex) {
		/* 1e13 is floating-point, but 1e13h is not */
		is_float = true;
	    }

	    type = is_float ? TOK_FLOAT : TOK_NUMBER;
        } else if (isspace(*p)) {
            type = TOK_WHITESPACE;
            p++;
            while (*p && isspace(*p))
                p++;
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
    b->next = nasm_malloc(sizeof(Blocks));
    /* and initialize the contents of the new block */
    b->next->next = NULL;
    b->next->chunk = NULL;
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
}

/*
 *  this function creates a new Token and passes a pointer to it
 *  back to the caller.  It sets the type and text elements, and
 *  also the mac and next elements to NULL.
 */
static Token *new_Token(Token * next, enum pp_token_type type, char *text, int txtlen)
{
    Token *t;
    int i;

    if (freeTokens == NULL) {
        freeTokens = (Token *) new_Block(TOKEN_BLOCKSIZE * sizeof(Token));
        for (i = 0; i < TOKEN_BLOCKSIZE - 1; i++)
            freeTokens[i].next = &freeTokens[i + 1];
        freeTokens[i].next = NULL;
    }
    t = freeTokens;
    freeTokens = t->next;
    t->next = next;
    t->mac = NULL;
    t->type = type;
    if (type == TOK_WHITESPACE || text == NULL) {
        t->text = NULL;
    } else {
        if (txtlen == 0)
            txtlen = strlen(text);
        t->text = nasm_malloc(1 + txtlen);
        strncpy(t->text, text, txtlen);
        t->text[txtlen] = '\0';
    }
    return t;
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
static char *detoken(Token * tlist, int expand_locals)
{
    Token *t;
    int len;
    char *line, *p;

    len = 0;
    for (t = tlist; t; t = t->next) {
        if (t->type == TOK_PREPROC_ID && t->text[1] == '!') {
            char *p = getenv(t->text + 2);
            nasm_free(t->text);
            if (p)
                t->text = nasm_strdup(p);
            else
                t->text = NULL;
        }
        /* Expand local macros here and not during preprocessing */
        if (expand_locals &&
            t->type == TOK_PREPROC_ID && t->text &&
            t->text[0] == '%' && t->text[1] == '$') {
            Context *ctx = get_ctx(t->text, false);
            if (ctx) {
                char buffer[40];
                char *p, *q = t->text + 2;

                q += strspn(q, "$");
                snprintf(buffer, sizeof(buffer), "..@%"PRIu32".", ctx->number);
                p = nasm_strcat(buffer, q);
                nasm_free(t->text);
                t->text = p;
            }
        }
        if (t->type == TOK_WHITESPACE) {
            len++;
        } else if (t->text) {
            len += strlen(t->text);
        }
    }
    p = line = nasm_malloc(len + 1);
    for (t = tlist; t; t = t->next) {
        if (t->type == TOK_WHITESPACE) {
            *p = ' ';
            p++;
            *p = '\0';
        } else if (t->text) {
            strcpy(p, t->text);
            p += strlen(p);
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
static int ppscan(void *private_data, struct tokenval *tokval)
{
    Token **tlineptr = private_data;
    Token *tline;
    char ourcopy[MAX_KEYWORD+1], *p, *r, *s;

    do {
        tline = *tlineptr;
        *tlineptr = tline ? tline->next : NULL;
    }
    while (tline && (tline->type == TOK_WHITESPACE ||
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
	    if (r > p+MAX_KEYWORD)
		return tokval->t_type = TOKEN_ID; /* Not a keyword */
            *s++ = tolower(*r);
	}
        *s = '\0';
        /* right, so we have an identifier sitting in temp storage. now,
         * is it actually a register or instruction name, or what? */
	return nasm_token_hash(ourcopy, tokval);
    }

    if (tline->type == TOK_NUMBER) {
	bool rn_error;
	tokval->t_integer = readnum(tline->text, &rn_error);
	if (rn_error)
	    return tokval->t_type = TOKEN_ERRNUM;   /* some malformation occurred */
	tokval->t_charptr = tline->text;
	return tokval->t_type = TOKEN_NUM;
    }

    if (tline->type == TOK_FLOAT) {
	return tokval->t_type = TOKEN_FLOAT;
    }

    if (tline->type == TOK_STRING) {
	bool rn_warn;
        char q, *r;
        int l;

        r = tline->text;
        q = *r++;
        l = strlen(r);

        if (l == 0 || r[l - 1] != q)
            return tokval->t_type = TOKEN_ERRNUM;
        tokval->t_integer = readstrnum(r, l - 1, &rn_warn);
        if (rn_warn)
            error(ERR_WARNING | ERR_PASS1, "character constant too long");
        tokval->t_charptr = NULL;
        return tokval->t_type = TOKEN_NUM;
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
 * Return the Context structure associated with a %$ token. Return
 * NULL, having _already_ reported an error condition, if the
 * context stack isn't deep enough for the supplied number of $
 * signs.
 * If all_contexts == true, contexts that enclose current are
 * also scanned for such smacro, until it is found; if not -
 * only the context that directly results from the number of $'s
 * in variable's name.
 */
static Context *get_ctx(char *name, bool all_contexts)
{
    Context *ctx;
    SMacro *m;
    int i;

    if (!name || name[0] != '%' || name[1] != '$')
        return NULL;

    if (!cstk) {
        error(ERR_NONFATAL, "`%s': context stack is empty", name);
        return NULL;
    }

    for (i = strspn(name + 2, "$"), ctx = cstk; (i > 0) && ctx; i--) {
        ctx = ctx->next;
/*        i--;  Lino - 02/25/02 */
    }
    if (!ctx) {
        error(ERR_NONFATAL, "`%s': context stack is only"
              " %d level%s deep", name, i - 1, (i == 2 ? "" : "s"));
        return NULL;
    }
    if (!all_contexts)
        return ctx;

    do {
        /* Search for this smacro in found context */
        m = ctx->localmac;
        while (m) {
            if (!mstrcmp(m->name, name, m->casesense))
                return ctx;
            m = m->next;
        }
        ctx = ctx->next;
    }
    while (ctx);
    return NULL;
}

/*
 * Open an include file. This routine must always return a valid
 * file pointer if it returns - it's responsible for throwing an
 * ERR_FATAL and bombing out completely if not. It should also try
 * the include path one by one until it finds the file or reaches
 * the end of the path.
 */
static FILE *inc_fopen(char *file)
{
    FILE *fp;
    char *prefix = "", *combine;
    IncPath *ip = ipath;
    static int namelen = 0;
    int len = strlen(file);

    while (1) {
        combine = nasm_malloc(strlen(prefix) + len + 1);
        strcpy(combine, prefix);
        strcat(combine, file);
        fp = fopen(combine, "r");
        if (pass == 0 && fp) {
            namelen += strlen(combine) + 1;
            if (namelen > 62) {
                printf(" \\\n  ");
                namelen = 2;
            }
            printf(" %s", combine);
        }
        nasm_free(combine);
        if (fp)
            return fp;
        if (!ip)
            break;
        prefix = ip->path;
        ip = ip->next;

	if (!prefix) {
		/* -MG given and file not found */
		if (pass == 0) {
			namelen += strlen(file) + 1;
			if (namelen > 62) {
				printf(" \\\n  ");
				namelen = 2;
			}
			printf(" %s", file);
		}
	    return NULL;
	}
    }

    error(ERR_FATAL, "unable to open include file `%s'", file);
    return NULL;                /* never reached - placate compilers */
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

    strx = nasm_strdup(str);	/* Use a more efficient allocator here? */
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
smacro_defined(Context * ctx, char *name, int nparam, SMacro ** defn,
               bool nocase)
{
    SMacro *m;

    if (ctx) {
        m = ctx->localmac;
    } else if (name[0] == '%' && name[1] == '$') {
	if (cstk)
            ctx = get_ctx(name, false);
        if (!ctx)
            return false;       /* got to return _something_ */
        m = ctx->localmac;
    } else {
	m = (SMacro *) hash_findix(smacros, name);
    }

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
        if (*nparam >= paramsize) {
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

    origline = tline;

    switch (i) {
    case PPC_IFCTX:
        j = false;              /* have we matched yet? */
        while (cstk && tline) {
            skip_white_(tline);
            if (!tline || tline->type != TOK_ID) {
                error(ERR_NONFATAL,
                      "`%s' expects context identifiers", pp_directives[ct]);
                free_tlist(origline);
                return -1;
            }
            if (!nasm_stricmp(tline->text, cstk->name))
                j = true;
            tline = tline->next;
        }
	break;

    case PPC_IFDEF:
        j = false;              /* have we matched yet? */
        while (tline) {
            skip_white_(tline);
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
        }
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
            /* Unify surrounding quotes for strings */
            if (t->type == TOK_STRING) {
                tt->text[0] = t->text[0];
                tt->text[strlen(tt->text) - 1] = t->text[0];
            }
            if (mstrcmp(tt->text, t->text, i == PPC_IFIDN) != 0) {
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
            MMacro searching, *mmac;

            tline = tline->next;
            skip_white_(tline);
            tline = expand_id(tline);
            if (!tok_type_(tline, TOK_ID)) {
                error(ERR_NONFATAL,
                      "`%s' expects a macro name", pp_directives[ct]);
		goto fail;
            }
            searching.name = nasm_strdup(tline->text);
            searching.casesense = true;
            searching.plus = false;
            searching.nolist = false;
            searching.in_progress = 0;
            searching.rep_nest = NULL;
            searching.nparam_min = 0;
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
            mmac = (MMacro *) hash_findix(mmacros, searching.name);
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
        tline = expand_smacro(tline);
        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        j = false;              /* placate optimiser */
        if (t)
	    j = t->type == needtype;
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
            error(ERR_WARNING,
                  "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL,
                  "non-constant value given to `%s'", pp_directives[ct]);
	    goto fail;
        }
        j = reloc_value(evalresult) != 0;
        return j;

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
 * Expand macros in a string. Used in %error and %include directives.
 * First tokenize the string, apply "expand_smacro" and then de-tokenize back.
 * The returned variable should ALWAYS be freed after usage.
 */
void expand_macros_in_string(char **p)
{
    Token *line = tokenize(*p);
    line = expand_smacro(line);
    *p = detoken(line, false);
}

/*
 * Common code for defining an smacro
 */
static bool define_smacro(Context *ctx, char *mname, bool casesense,
			  int nparam, Token *expansion)
{
    SMacro *smac, **smhead;

    if (smacro_defined(ctx, mname, nparam, &smac, casesense)) {
	if (!smac) {
	    error(ERR_WARNING,
		  "single-line macro `%s' defined both with and"
		  " without parameters", mname);

	    /* Some instances of the old code considered this a failure,
	       some others didn't.  What is the right thing to do here? */
	    free_tlist(expansion);
	    return false;	/* Failure */
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
	if (!ctx)
	    smhead = (SMacro **) hash_findi_add(smacros, mname);
	else
	    smhead = &ctx->localmac;

	smac = nasm_malloc(sizeof(SMacro));
	smac->next = *smhead;
	*smhead = smac;
    }
    smac->name = nasm_strdup(mname);
    smac->casesense = casesense;
    smac->nparam = nparam;
    smac->expansion = expansion;
    smac->in_progress = false;
    return true;		/* Success */
}

/*
 * Undefine an smacro
 */
static void undef_smacro(Context *ctx, const char *mname)
{
    SMacro **smhead, *s, **sp;

    if (!ctx)
	smhead = (SMacro **) hash_findi(smacros, mname, NULL);
    else
	smhead = &ctx->localmac;

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
    char *p, *mname;
    Include *inc;
    Context *ctx;
    Cond *cond;
    MMacro *mmac, **mmhead;
    Token *t, *tt, *param_start, *macro_start, *last, **tptr, *origline;
    Line *l;
    struct tokenval tokval;
    expr *evalresult;
    MMacro *tmp_defining;       /* Used when manipulating rep_nest */
    int64_t count;

    origline = tline;

    skip_white_(tline);
    if (!tok_type_(tline, TOK_PREPROC_ID) ||
        (tline->text[1] == '%' || tline->text[1] == '$'
         || tline->text[1] == '!'))
        return NO_DIRECTIVE_FOUND;

    i = pp_token_hash(tline->text);

    /*
     * If we're in a non-emitting branch of a condition construct,
     * or walking to the end of an already terminated %rep block,
     * we should ignore all directives except for condition
     * directives.
     */
    if (((istk->conds && !emitting(istk->conds->state)) ||
         (istk->mstk && !istk->mstk->in_progress)) && !is_condition(i)) {
        return NO_DIRECTIVE_FOUND;
    }

    /*
     * If we're defining a macro or reading a %rep block, we should
     * ignore all directives except for %macro/%imacro (which
     * generate an error), %endm/%endmacro, and (only if we're in a
     * %rep block) %endrep. If we're in a %rep block, another %rep
     * causes an error, so should be let through.
     */
    if (defining && i != PP_MACRO && i != PP_IMACRO &&
        i != PP_ENDMACRO && i != PP_ENDM &&
        (defining->name || (i != PP_ENDREP && i != PP_REP))) {
        return NO_DIRECTIVE_FOUND;
    }

    switch (i) {
    case PP_INVALID:
        error(ERR_NONFATAL, "unknown preprocessor directive `%s'",
              tline->text);
        return NO_DIRECTIVE_FOUND;      /* didn't get it */

    case PP_STACKSIZE:
        /* Directive to tell NASM what the default stack size is. The
         * default is for a 16-bit stack, and this can be overriden with
         * %stacksize large.
         * the following form:
         *
         *      ARG arg1:WORD, arg2:DWORD, arg4:QWORD
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
            LocalOffset = 4;
        } else if (nasm_stricmp(tline->text, "large") == 0) {
            /* All subsequent ARG directives are for a 16-bit stack,
             * far function call.
             */
            StackSize = 2;
            StackPointer = "bp";
            ArgOffset = 4;
            LocalOffset = 2;
        } else if (nasm_stricmp(tline->text, "small") == 0) {
            /* All subsequent ARG directives are for a 16-bit stack,
             * far function call. We don't support near functions.
             */
            StackSize = 2;
            StackPointer = "bp";
            ArgOffset = 6;
            LocalOffset = 2;
        } else {
            error(ERR_NONFATAL, "`%%stacksize' invalid size type");
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        free_tlist(origline);
        return DIRECTIVE_FOUND;

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
            if (nasm_stricmp(tt->text, "byte") == 0) {
                size = MAX(StackSize, 1);
            } else if (nasm_stricmp(tt->text, "word") == 0) {
                size = MAX(StackSize, 2);
            } else if (nasm_stricmp(tt->text, "dword") == 0) {
                size = MAX(StackSize, 4);
            } else if (nasm_stricmp(tt->text, "qword") == 0) {
                size = MAX(StackSize, 8);
            } else if (nasm_stricmp(tt->text, "tword") == 0) {
                size = MAX(StackSize, 10);
            } else {
                error(ERR_NONFATAL,
                      "Invalid size type for `%%arg' missing directive");
                free_tlist(tt);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            free_tlist(tt);

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s+%d)",
                     arg, StackPointer, offset);
            do_directive(tokenize(directive));
            offset += size;

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        }
        while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        free_tlist(origline);
        return DIRECTIVE_FOUND;

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
            if (nasm_stricmp(tt->text, "byte") == 0) {
                size = MAX(StackSize, 1);
            } else if (nasm_stricmp(tt->text, "word") == 0) {
                size = MAX(StackSize, 2);
            } else if (nasm_stricmp(tt->text, "dword") == 0) {
                size = MAX(StackSize, 4);
            } else if (nasm_stricmp(tt->text, "qword") == 0) {
                size = MAX(StackSize, 8);
            } else if (nasm_stricmp(tt->text, "tword") == 0) {
                size = MAX(StackSize, 10);
            } else {
                error(ERR_NONFATAL,
                      "Invalid size type for `%%local' missing directive");
                free_tlist(tt);
                free_tlist(origline);
                return DIRECTIVE_FOUND;
            }
            free_tlist(tt);

            /* Now define the macro for the argument */
            snprintf(directive, sizeof(directive), "%%define %s (%s-%d)",
                     local, StackPointer, offset);
            do_directive(tokenize(directive));
            offset += size;

            /* Now define the assign to setup the enter_c macro correctly */
            snprintf(directive, sizeof(directive),
                     "%%assign %%$localsize %%$localsize+%d", size);
            do_directive(tokenize(directive));

            /* Move to the next argument in the list */
            tline = tline->next;
            if (tline && tline->type == TOK_WHITESPACE)
                tline = tline->next;
        }
        while (tline && tline->type == TOK_OTHER && tline->text[0] == ',');
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_CLEAR:
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%clear' ignored");
	free_macros();
	init_macros();
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_INCLUDE:
        tline = tline->next;
        skip_white_(tline);
        if (!tline || (tline->type != TOK_STRING &&
                       tline->type != TOK_INTERNAL_STRING)) {
            error(ERR_NONFATAL, "`%%include' expects a file name");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (tline->next)
            error(ERR_WARNING,
                  "trailing garbage after `%%include' ignored");
        if (tline->type != TOK_INTERNAL_STRING) {
            p = tline->text + 1;        /* point past the quote to the name */
            p[strlen(p) - 1] = '\0';    /* remove the trailing quote */
        } else
            p = tline->text;    /* internal_string is easier */
        expand_macros_in_string(&p);
        inc = nasm_malloc(sizeof(Include));
        inc->next = istk;
        inc->conds = NULL;
        inc->fp = inc_fopen(p);
	if (!inc->fp && pass == 0) {
	    /* -MG given but file not found */
	    nasm_free(inc);
	} else {
	    inc->fname = src_set_fname(p);
	    inc->lineno = src_set_linnum(0);
	    inc->lineinc = 1;
	    inc->expansion = NULL;
	    inc->mstk = NULL;
	    istk = inc;
	    list->uplevel(LIST_INCLUDE);
	}
	free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_PUSH:
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tok_type_(tline, TOK_ID)) {
            error(ERR_NONFATAL, "`%%push' expects a context identifier");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%push' ignored");
        ctx = nasm_malloc(sizeof(Context));
        ctx->next = cstk;
        ctx->localmac = NULL;
        ctx->name = nasm_strdup(tline->text);
        ctx->number = unique++;
        cstk = ctx;
        free_tlist(origline);
        break;

    case PP_REPL:
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tok_type_(tline, TOK_ID)) {
            error(ERR_NONFATAL, "`%%repl' expects a context identifier");
            free_tlist(origline);
            return DIRECTIVE_FOUND;     /* but we did _something_ */
        }
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%repl' ignored");
        if (!cstk)
            error(ERR_NONFATAL, "`%%repl': context stack is empty");
        else {
            nasm_free(cstk->name);
            cstk->name = nasm_strdup(tline->text);
        }
        free_tlist(origline);
        break;

    case PP_POP:
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%pop' ignored");
        if (!cstk)
            error(ERR_NONFATAL, "`%%pop': context stack is already empty");
        else
            ctx_pop();
        free_tlist(origline);
        break;

    case PP_ERROR:
        tline->next = expand_smacro(tline->next);
        tline = tline->next;
        skip_white_(tline);
        if (tok_type_(tline, TOK_STRING)) {
            p = tline->text + 1;        /* point past the quote to the name */
            p[strlen(p) - 1] = '\0';    /* remove the trailing quote */
            expand_macros_in_string(&p);
            error(ERR_NONFATAL, "%s", p);
            nasm_free(p);
        } else {
            p = detoken(tline, false);
            error(ERR_WARNING, "%s", p);
            nasm_free(p);
        }
        free_tlist(origline);
        break;

    CASE_PP_IF:
        if (istk->conds && !emitting(istk->conds->state))
            j = COND_NEVER;
        else {
            j = if_condition(tline->next, i);
            tline->next = NULL; /* it got freed */
            free_tlist(origline);
            j = j < 0 ? COND_NEVER : j ? COND_IF_TRUE : COND_IF_FALSE;
        }
        cond = nasm_malloc(sizeof(Cond));
        cond->next = istk->conds;
        cond->state = j;
        istk->conds = cond;
        return DIRECTIVE_FOUND;

    CASE_PP_ELIF:
        if (!istk->conds)
            error(ERR_FATAL, "`%s': no matching `%%if'", pp_directives[i]);
        if (emitting(istk->conds->state)
            || istk->conds->state == COND_NEVER)
            istk->conds->state = COND_NEVER;
        else {
            /*
             * IMPORTANT: In the case of %if, we will already have
             * called expand_mmac_params(); however, if we're
             * processing an %elif we must have been in a
             * non-emitting mode, which would have inhibited
             * the normal invocation of expand_mmac_params().  Therefore,
             * we have to do it explicitly here.
             */
            j = if_condition(expand_mmac_params(tline->next), i);
            tline->next = NULL; /* it got freed */
            free_tlist(origline);
            istk->conds->state =
                j < 0 ? COND_NEVER : j ? COND_IF_TRUE : COND_IF_FALSE;
        }
        return DIRECTIVE_FOUND;

    case PP_ELSE:
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%else' ignored");
        if (!istk->conds)
            error(ERR_FATAL, "`%%else': no matching `%%if'");
        if (emitting(istk->conds->state)
            || istk->conds->state == COND_NEVER)
            istk->conds->state = COND_ELSE_FALSE;
        else
            istk->conds->state = COND_ELSE_TRUE;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDIF:
        if (tline->next)
            error(ERR_WARNING, "trailing garbage after `%%endif' ignored");
        if (!istk->conds)
            error(ERR_FATAL, "`%%endif': no matching `%%if'");
        cond = istk->conds;
        istk->conds = cond->next;
        nasm_free(cond);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_MACRO:
    case PP_IMACRO:
        if (defining)
            error(ERR_FATAL,
                  "`%%%smacro': already defining a macro",
                  (i == PP_IMACRO ? "i" : ""));
        tline = tline->next;
        skip_white_(tline);
        tline = expand_id(tline);
        if (!tok_type_(tline, TOK_ID)) {
            error(ERR_NONFATAL,
                  "`%%%smacro' expects a macro name",
                  (i == PP_IMACRO ? "i" : ""));
            return DIRECTIVE_FOUND;
        }
        defining = nasm_malloc(sizeof(MMacro));
        defining->name = nasm_strdup(tline->text);
        defining->casesense = (i == PP_MACRO);
        defining->plus = false;
        defining->nolist = false;
        defining->in_progress = 0;
        defining->rep_nest = NULL;
        tline = expand_smacro(tline->next);
        skip_white_(tline);
        if (!tok_type_(tline, TOK_NUMBER)) {
            error(ERR_NONFATAL,
                  "`%%%smacro' expects a parameter count",
                  (i == PP_IMACRO ? "i" : ""));
            defining->nparam_min = defining->nparam_max = 0;
        } else {
            defining->nparam_min = defining->nparam_max =
                readnum(tline->text, &err);
            if (err)
                error(ERR_NONFATAL,
                      "unable to parse parameter count `%s'", tline->text);
        }
        if (tline && tok_is_(tline->next, "-")) {
            tline = tline->next->next;
            if (tok_is_(tline, "*"))
                defining->nparam_max = INT_MAX;
            else if (!tok_type_(tline, TOK_NUMBER))
                error(ERR_NONFATAL,
                      "`%%%smacro' expects a parameter count after `-'",
                      (i == PP_IMACRO ? "i" : ""));
            else {
                defining->nparam_max = readnum(tline->text, &err);
                if (err)
                    error(ERR_NONFATAL,
                          "unable to parse parameter count `%s'",
                          tline->text);
                if (defining->nparam_min > defining->nparam_max)
                    error(ERR_NONFATAL,
                          "minimum parameter count exceeds maximum");
            }
        }
        if (tline && tok_is_(tline->next, "+")) {
            tline = tline->next;
            defining->plus = true;
        }
        if (tline && tok_type_(tline->next, TOK_ID) &&
            !nasm_stricmp(tline->next->text, ".nolist")) {
            tline = tline->next;
            defining->nolist = true;
        }
        mmac = (MMacro *) hash_findix(mmacros, defining->name);
        while (mmac) {
            if (!strcmp(mmac->name, defining->name) &&
                (mmac->nparam_min <= defining->nparam_max
                 || defining->plus)
                && (defining->nparam_min <= mmac->nparam_max
                    || mmac->plus)) {
                error(ERR_WARNING,
                      "redefining multi-line macro `%s'", defining->name);
                break;
            }
            mmac = mmac->next;
        }
        /*
         * Handle default parameters.
         */
        if (tline && tline->next) {
            defining->dlist = tline->next;
            tline->next = NULL;
            count_mmac_params(defining->dlist, &defining->ndefs,
                              &defining->defaults);
        } else {
            defining->dlist = NULL;
            defining->defaults = NULL;
        }
        defining->expansion = NULL;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ENDM:
    case PP_ENDMACRO:
        if (!defining) {
            error(ERR_NONFATAL, "`%s': not defining a macro", tline->text);
            return DIRECTIVE_FOUND;
        }
	mmhead = (MMacro **) hash_findi_add(mmacros, defining->name);
        defining->next = *mmhead;
	*mmhead = defining;
        defining = NULL;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ROTATE:
        if (tline->next && tline->next->type == TOK_WHITESPACE)
            tline = tline->next;
        if (tline->next == NULL) {
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
            error(ERR_WARNING,
                  "trailing garbage after expression ignored");
        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL, "non-constant value given to `%%rotate'");
            return DIRECTIVE_FOUND;
        }
        mmac = istk->mstk;
        while (mmac && !mmac->name)     /* avoid mistaking %reps for macros */
            mmac = mmac->next_active;
        if (!mmac) {
            error(ERR_NONFATAL, "`%%rotate' invoked outside a macro call");
        } else if (mmac->nparam == 0) {
            error(ERR_NONFATAL,
                  "`%%rotate' invoked within macro without parameters");
        } else {
	    int rotate = mmac->rotate + reloc_value(evalresult);

	    rotate %= (int)mmac->nparam;
	    if (rotate < 0)
		rotate += mmac->nparam;

	    mmac->rotate = rotate;
        }
        return DIRECTIVE_FOUND;

    case PP_REP:
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
                error(ERR_WARNING,
                      "trailing garbage after expression ignored");
            if (!is_simple(evalresult)) {
                error(ERR_NONFATAL, "non-constant value given to `%%rep'");
                return DIRECTIVE_FOUND;
            }
            count = reloc_value(evalresult) + 1;
        } else {
            error(ERR_NONFATAL, "`%%rep' expects a repeat count");
            count = 0;
        }
        free_tlist(origline);

        tmp_defining = defining;
        defining = nasm_malloc(sizeof(MMacro));
        defining->name = NULL;  /* flags this macro as a %rep block */
        defining->casesense = false;
        defining->plus = false;
        defining->nolist = nolist;
        defining->in_progress = count;
        defining->nparam_min = defining->nparam_max = 0;
        defining->defaults = NULL;
        defining->dlist = NULL;
        defining->expansion = NULL;
        defining->next_active = istk->mstk;
        defining->rep_nest = tmp_defining;
        return DIRECTIVE_FOUND;

    case PP_ENDREP:
        if (!defining || defining->name) {
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
        l = nasm_malloc(sizeof(Line));
        l->next = istk->expansion;
        l->finishes = defining;
        l->first = NULL;
        istk->expansion = l;

        istk->mstk = defining;

        list->uplevel(defining->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);
        tmp_defining = defining;
        defining = defining->rep_nest;
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_EXITREP:
        /*
         * We must search along istk->expansion until we hit a
         * macro-end marker for a macro with no name. Then we set
         * its `in_progress' flag to 0.
         */
        for (l = istk->expansion; l; l = l->next)
            if (l->finishes && !l->finishes->name)
                break;

        if (l)
            l->finishes->in_progress = 0;
        else
            error(ERR_NONFATAL, "`%%exitrep' not within `%%rep' block");
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_XDEFINE:
    case PP_IXDEFINE:
    case PP_DEFINE:
    case PP_IDEFINE:
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

        ctx = get_ctx(tline->text, false);

        mname = tline->text;
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
                tline->type = TOK_SMAC_PARAM + nparam++;
                tline = tline->next;
                skip_white_(tline);
                if (tok_is_(tline, ",")) {
                    tline = tline->next;
                    continue;
                }
                if (!tok_is_(tline, ")")) {
                    error(ERR_NONFATAL,
                          "`)' expected to terminate macro template");
                    free_tlist(origline);
                    return DIRECTIVE_FOUND;
                }
                break;
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
                for (tt = param_start; tt; tt = tt->next)
                    if (tt->type >= TOK_SMAC_PARAM &&
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
            error(ERR_WARNING,
                  "trailing garbage after macro name ignored");
        }

        /* Find the context that symbol belongs to */
        ctx = get_ctx(tline->text, false);
	undef_smacro(ctx, tline->text);
	free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_STRLEN:
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
        ctx = get_ctx(tline->text, false);

        mname = tline->text;
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;
        /* t should now point to the string */
        if (t->type != TOK_STRING) {
            error(ERR_NONFATAL,
                  "`%%strlen` requires string as second parameter");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = nasm_malloc(sizeof(*macro_start));
        macro_start->next = NULL;
        make_tok_num(macro_start, strlen(t->text) - 2);
        macro_start->mac = NULL;

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
	define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_SUBSTR:
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
        ctx = get_ctx(tline->text, false);

        mname = tline->text;
        last = tline;
        tline = expand_smacro(tline->next);
        last->next = NULL;

        t = tline->next;
        while (tok_type_(t, TOK_WHITESPACE))
            t = t->next;

        /* t should now point to the string */
        if (t->type != TOK_STRING) {
            error(ERR_NONFATAL,
                  "`%%substr` requires string as second parameter");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        tt = t->next;
        tptr = &tt;
        tokval.t_type = TOKEN_INVALID;
        evalresult =
            evaluate(ppscan, tptr, &tokval, NULL, pass, error, NULL);
        if (!evalresult) {
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }
        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL, "non-constant value given to `%%substr`");
            free_tlist(tline);
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = nasm_malloc(sizeof(*macro_start));
        macro_start->next = NULL;
        macro_start->text = nasm_strdup("'''");
        if (evalresult->value > 0
            && evalresult->value < (int) strlen(t->text) - 1) {
            macro_start->text[1] = t->text[evalresult->value];
        } else {
            macro_start->text[2] = '\0';
        }
        macro_start->type = TOK_STRING;
        macro_start->mac = NULL;

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
	define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(tline);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_ASSIGN:
    case PP_IASSIGN:
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
        ctx = get_ctx(tline->text, false);

        mname = tline->text;
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
            error(ERR_WARNING,
                  "trailing garbage after expression ignored");

        if (!is_simple(evalresult)) {
            error(ERR_NONFATAL,
                  "non-constant value given to `%%%sassign'",
                  (i == PP_IASSIGN ? "i" : ""));
            free_tlist(origline);
            return DIRECTIVE_FOUND;
        }

        macro_start = nasm_malloc(sizeof(*macro_start));
        macro_start->next = NULL;
        make_tok_num(macro_start, reloc_value(evalresult));
        macro_start->mac = NULL;

        /*
         * We now have a macro name, an implicit parameter count of
         * zero, and a numeric token to use as an expansion. Create
         * and store an SMacro.
         */
	define_smacro(ctx, mname, casesense, 0, macro_start);
        free_tlist(origline);
        return DIRECTIVE_FOUND;

    case PP_LINE:
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

    default:
        error(ERR_FATAL,
              "preprocessor directive `%s' not yet implemented",
              pp_directives[i]);
        break;
    }
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
    int i, j, k, m;

    if (!t)
	    return -1;		/* Probably a %+ without a space */

    skip_white_(t);
    if (t->type != TOK_ID)
        return -1;
    tt = t->next;
    skip_white_(tt);
    if (tt && (tt->type != TOK_OTHER || strcmp(tt->text, ",")))
        return -1;

    i = -1;
    j = elements(conditions);
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

/*
 * Expand MMacro-local things: parameter references (%0, %n, %+n,
 * %-n) and MMacro-local identifiers (%%foo).
 */
static Token *expand_mmac_params(Token * tline)
{
    Token *t, *tt, **tail, *thead;

    tail = &thead;
    thead = NULL;

    while (tline) {
        if (tline->type == TOK_PREPROC_ID &&
            (((tline->text[1] == '+' || tline->text[1] == '-')
              && tline->text[2]) || tline->text[1] == '%'
             || (tline->text[1] >= '0' && tline->text[1] <= '9'))) {
            char *text = NULL;
            int type = 0, cc;   /* type = 0 to placate optimisers */
            char tmpbuf[30];
            unsigned int n;
	    int i;
            MMacro *mac;

            t = tline;
            tline = tline->next;

            mac = istk->mstk;
            while (mac && !mac->name)   /* avoid mistaking %reps for macros */
                mac = mac->next_active;
            if (!mac)
                error(ERR_NONFATAL, "`%s': not in a macro call", t->text);
            else
                switch (t->text[1]) {
                    /*
                     * We have to make a substitution of one of the
                     * forms %1, %-1, %+1, %%foo, %0.
                     */
                case '0':
                    type = TOK_NUMBER;
                    snprintf(tmpbuf, sizeof(tmpbuf), "%d", mac->nparam);
                    text = nasm_strdup(tmpbuf);
                    break;
                case '%':
                    type = TOK_ID;
                    snprintf(tmpbuf, sizeof(tmpbuf), "..@%"PRIu64".",
                             mac->unique);
                    text = nasm_strcat(tmpbuf, t->text + 2);
                    break;
                case '-':
                    n = atoi(t->text + 2) - 1;
                    if (n >= mac->nparam)
                        tt = NULL;
                    else {
                        if (mac->nparam > 1)
                            n = (n + mac->rotate) % mac->nparam;
                        tt = mac->params[n];
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
                            text =
                                nasm_strdup(conditions[inverse_ccs[cc]]);
                    }
                    break;
                case '+':
                    n = atoi(t->text + 2) - 1;
                    if (n >= mac->nparam)
                        tt = NULL;
                    else {
                        if (mac->nparam > 1)
                            n = (n + mac->rotate) % mac->nparam;
                        tt = mac->params[n];
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
                    if (n >= mac->nparam)
                        tt = NULL;
                    else {
                        if (mac->nparam > 1)
                            n = (n + mac->rotate) % mac->nparam;
                        tt = mac->params[n];
                    }
                    if (tt) {
                        for (i = 0; i < mac->paramlen[n]; i++) {
                            *tail = new_Token(NULL, tt->type, tt->text, 0);
                            tail = &(*tail)->next;
                            tt = tt->next;
                        }
                    }
                    text = NULL;        /* we've done it here */
                    break;
                }
            if (!text) {
                delete_Token(t);
            } else {
                *tail = t;
                tail = &t->next;
                t->type = type;
                nasm_free(t->text);
                t->text = text;
                t->mac = NULL;
            }
            continue;
        } else {
            t = *tail = tline;
            tline = tline->next;
            t->mac = NULL;
            tail = &t->next;
        }
    }
    *tail = NULL;
    t = thead;
    for (; t && (tt = t->next) != NULL; t = t->next)
        switch (t->type) {
        case TOK_WHITESPACE:
            if (tt->type == TOK_WHITESPACE) {
                t->next = delete_Token(tt);
            }
            break;
        case TOK_ID:
            if (tt->type == TOK_ID || tt->type == TOK_NUMBER) {
                char *tmp = nasm_strcat(t->text, tt->text);
                nasm_free(t->text);
                t->text = tmp;
                t->next = delete_Token(tt);
            }
            break;
        case TOK_NUMBER:
            if (tt->type == TOK_NUMBER) {
                char *tmp = nasm_strcat(t->text, tt->text);
                nasm_free(t->text);
                t->text = tmp;
                t->next = delete_Token(tt);
            }
            break;
	default:
	    break;
        }

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
    int brackets, rescan;
    Token *org_tline = tline;
    Context *ctx;
    char *mname;

    /*
     * Trick: we should avoid changing the start token pointer since it can
     * be contained in "next" field of other token. Because of this
     * we allocate a copy of first token and work with it; at the end of
     * routine we copy it back
     */
    if (org_tline) {
        tline =
            new_Token(org_tline->next, org_tline->type, org_tline->text,
                      0);
        tline->mac = org_tline->mac;
        nasm_free(org_tline->text);
        org_tline->text = NULL;
    }

  again:
    tail = &thead;
    thead = NULL;

    while (tline) {             /* main token loop */
        if ((mname = tline->text)) {
            /* if this token is a local macro, look in local context */
            if (tline->type == TOK_ID || tline->type == TOK_PREPROC_ID)
                ctx = get_ctx(mname, true);
            else
                ctx = NULL;
            if (!ctx) {
		head = (SMacro *) hash_findix(smacros, mname);
	    } else {
                head = ctx->localmac;
	    }
            /*
             * We've hit an identifier. As in is_mmacro below, we first
             * check whether the identifier is a single-line macro at
             * all, then think about checking for parameters if
             * necessary.
             */
	    for (m = head; m; m = m->next)
		if (!mstrcmp(m->name, mname, m->casesense))
		    break;
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
			    src_get(&num, &(tline->text));
			    nasm_quote(&(tline->text));
			    tline->type = TOK_STRING;
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
                            t->mac->in_progress = false;
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
                                t->mac->in_progress = false;
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
                                                              sparam *
                                                              sizeof(Token
                                                                     *));
                                        paramsize =
                                            nasm_realloc(paramsize,
                                                         sparam *
                                                         sizeof(int));
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
                            error(ERR_WARNING | ERR_WARN_MNP,
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
                    tt->mac = m;
                    m->in_progress = true;
                    tline = tt;
                    for (t = m->expansion; t; t = t->next) {
                        if (t->type >= TOK_SMAC_PARAM) {
                            Token *pcopy = tline, **ptail = &pcopy;
                            Token *ttt, *pt;
                            int i;

                            ttt = params[t->type - TOK_SMAC_PARAM];
                            for (i = paramsize[t->type - TOK_SMAC_PARAM];
                                 --i >= 0;) {
                                pt = *ptail =
                                    new_Token(tline, ttt->type, ttt->text,
                                              0);
                                ptail = &pt->next;
                                ttt = ttt->next;
                            }
                            tline = pcopy;
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
                    continue;   /* main token loop */
                }
            }
        }

        if (tline->type == TOK_SMAC_END) {
            tline->mac->in_progress = false;
            tline = delete_Token(tline);
        } else {
            t = *tail = tline;
            tline = tline->next;
            t->mac = NULL;
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
    t = thead;
    rescan = 0;
    while (t) {
        while (t && t->type != TOK_ID && t->type != TOK_PREPROC_ID)
            t = t->next;
        if (!t || !t->next)
            break;
        if (t->next->type == TOK_ID ||
            t->next->type == TOK_PREPROC_ID ||
            t->next->type == TOK_NUMBER) {
            char *p = nasm_strcat(t->text, t->next->text);
            nasm_free(t->text);
            t->next = delete_Token(t->next);
            t->text = p;
            rescan = 1;
        } else if (t->next->type == TOK_WHITESPACE && t->next->next &&
                   t->next->next->type == TOK_PREPROC_ID &&
                   strcmp(t->next->next->text, "%+") == 0) {
            /* free the next whitespace, the %+ token and next whitespace */
            int i;
            for (i = 1; i <= 3; i++) {
                if (!t->next
                    || (i != 2 && t->next->type != TOK_WHITESPACE))
                    break;
                t->next = delete_Token(t->next);
            }                   /* endfor */
        } else
            t = t->next;
    }
    /* If we concatenaded something, re-scan the line for macros */
    if (rescan) {
        tline = thead;
        goto again;
    }

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
 *	%define %$abc cde
 *
 * the identifier %$abc will be left as-is so that the handler for %define
 * will suck it and define the corresponding value. Other case:
 *
 *	%define _%$abc cde
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
static MMacro *is_mmacro(Token * tline, Token *** params_array)
{
    MMacro *head, *m;
    Token **params;
    int nparam;

    head = (MMacro *) hash_findix(mmacros, tline->text);

    /*
     * Efficiency: first we see if any macro exists with the given
     * name. If not, we can return NULL immediately. _Then_ we
     * count the parameters, and then we look further along the
     * list if necessary to find the proper MMacro.
     */
    for (m = head; m; m = m->next)
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
            if (m->in_progress) {
#if 0
                error(ERR_NONFATAL,
                      "self-reference in multi-line macro `%s'", m->name);
#endif
                nasm_free(params);
                return NULL;
            }
            /*
             * It's right, and we can use it. Add its default
             * parameters to the end of our list if necessary.
             */
            if (m->defaults && nparam < m->nparam_min + m->ndefs) {
                params =
                    nasm_realloc(params,
                                 ((m->nparam_min + m->ndefs +
                                   1) * sizeof(*params)));
                while (nparam < m->nparam_min + m->ndefs) {
                    params[nparam] = m->defaults[nparam - m->nparam_min];
                    nparam++;
                }
            }
            /*
             * If we've gone over the maximum parameter count (and
             * we're in Plus mode), ignore parameters beyond
             * nparam_max.
             */
            if (m->plus && nparam > m->nparam_max)
                nparam = m->nparam_max;
            /*
             * Then terminate the parameter list, and leave.
             */
            if (!params) {      /* need this special case */
                params = nasm_malloc(sizeof(*params));
                nparam = 0;
            }
            params[nparam] = NULL;
            *params_array = params;
            return m;
        }
        /*
         * This one wasn't right: look for the next one with the
         * same name.
         */
        for (m = m->next; m; m = m->next)
            if (!mstrcmp(m->name, tline->text, m->casesense))
                break;
    }

    /*
     * After all that, we didn't find one with the right number of
     * parameters. Issue a warning, and fail to expand the macro.
     */
    error(ERR_WARNING | ERR_WARN_MNP,
          "macro `%s' exists, but not taking %d parameters",
          tline->text, nparam);
    nasm_free(params);
    return NULL;
}

/*
 * Expand the multi-line macro call made by the given line, if
 * there is one to be expanded. If there is, push the expansion on
 * istk->expansion and return 1. Otherwise return 0.
 */
static int expand_mmacro(Token * tline)
{
    Token *startline = tline;
    Token *label = NULL;
    int dont_prepend = 0;
    Token **params, *t, *tt;
    MMacro *m;
    Line *l, *ll;
    int i, nparam, *paramlen;

    t = tline;
    skip_white_(t);
/*    if (!tok_type_(t, TOK_ID))  Lino 02/25/02 */
    if (!tok_type_(t, TOK_ID) && !tok_type_(t, TOK_PREPROC_ID))
        return 0;
    m = is_mmacro(t, &params);
    if (!m) {
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
        if (!tok_type_(t, TOK_ID) || (m = is_mmacro(t, &params)) == NULL)
            return 0;
        last->next = NULL;
        tline = t;
    }

    /*
     * Fix up the parameters: this involves stripping leading and
     * trailing whitespace, then stripping braces if they are
     * present.
     */
    for (nparam = 0; params[nparam]; nparam++) ;
    paramlen = nparam ? nasm_malloc(nparam * sizeof(*paramlen)) : NULL;

    for (i = 0; params[i]; i++) {
        int brace = false;
        int comma = (!m->plus || i < nparam - 1);

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

    /*
     * OK, we have a MMacro structure together with a set of
     * parameters. We must now go through the expansion and push
     * copies of each Line on to istk->expansion. Substitution of
     * parameter tokens and macro-local tokens doesn't get done
     * until the single-line macro substitution process; this is
     * because delaying them allows us to change the semantics
     * later through %rotate.
     *
     * First, push an end marker on to istk->expansion, mark this
     * macro as in progress, and set up its invocation-specific
     * variables.
     */
    ll = nasm_malloc(sizeof(Line));
    ll->next = istk->expansion;
    ll->finishes = m;
    ll->first = NULL;
    istk->expansion = ll;

    m->in_progress = true;
    m->params = params;
    m->iline = tline;
    m->nparam = nparam;
    m->rotate = 0;
    m->paramlen = paramlen;
    m->unique = unique++;
    m->lineno = 0;

    m->next_active = istk->mstk;
    istk->mstk = m;

    for (l = m->expansion; l; l = l->next) {
        Token **tail;

        ll = nasm_malloc(sizeof(Line));
        ll->finishes = NULL;
        ll->next = istk->expansion;
        istk->expansion = ll;
        tail = &ll->first;

        for (t = l->first; t; t = t->next) {
            Token *x = t;
            if (t->type == TOK_PREPROC_ID &&
                t->text[1] == '0' && t->text[2] == '0') {
                dont_prepend = -1;
                x = label;
                if (!x)
                    continue;
            }
            tt = *tail = new_Token(NULL, x->type, x->text, 0);
            tail = &tt->next;
        }
        *tail = NULL;
    }

    /*
     * If we had a label, push it on as the first line of
     * the macro expansion.
     */
    if (label) {
        if (dont_prepend < 0)
            free_tlist(startline);
        else {
            ll = nasm_malloc(sizeof(Line));
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

    list->uplevel(m->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);

    return 1;
}

/*
 * Since preprocessor always operate only on the line that didn't
 * arrived yet, we should always use ERR_OFFBY1. Also since user
 * won't want to see same error twice (preprocessing is done once
 * per pass) we will want to show errors only during pass one.
 */
static void error(int severity, const char *fmt, ...)
{
    va_list arg;
    char buff[1024];

    /* If we're in a dead branch of IF or something like it, ignore the error */
    if (istk && istk->conds && !emitting(istk->conds->state))
        return;

    va_start(arg, fmt);
    vsnprintf(buff, sizeof(buff), fmt, arg);
    va_end(arg);

    if (istk && istk->mstk && istk->mstk->name)
        _error(severity | ERR_PASS1, "(%s:%d) %s", istk->mstk->name,
               istk->mstk->lineno, buff);
    else
        _error(severity | ERR_PASS1, "%s", buff);
}

static void
pp_reset(char *file, int apass, efunc errfunc, evalfunc eval,
         ListGen * listgen)
{
    _error = errfunc;
    cstk = NULL;
    istk = nasm_malloc(sizeof(Include));
    istk->next = NULL;
    istk->conds = NULL;
    istk->expansion = NULL;
    istk->mstk = NULL;
    istk->fp = fopen(file, "r");
    istk->fname = NULL;
    src_set_fname(nasm_strdup(file));
    src_set_linnum(0);
    istk->lineinc = 1;
    if (!istk->fp)
        error(ERR_FATAL | ERR_NOFILE, "unable to open input file `%s'",
              file);
    defining = NULL;
    init_macros();
    unique = 0;
    if (tasm_compatible_mode) {
        stdmacpos = stdmac;
    } else {
        stdmacpos = &stdmac[TASM_MACRO_COUNT];
    }
    any_extrastdmac = (extrastdmac != NULL);
    list = listgen;
    evaluate = eval;
    pass = apass;
}

static char *pp_getline(void)
{
    char *line;
    Token *tline;

    while (1) {
        /*
         * Fetch a tokenized line, either from the macro-expansion
         * buffer or from the input file.
         */
        tline = NULL;
        while (istk->expansion && istk->expansion->finishes) {
            Line *l = istk->expansion;
            if (!l->finishes->name && l->finishes->in_progress > 1) {
                Line *ll;

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
                l->finishes->in_progress--;
                for (l = l->finishes->expansion; l; l = l->next) {
                    Token *t, *tt, **tail;

                    ll = nasm_malloc(sizeof(Line));
                    ll->next = istk->expansion;
                    ll->finishes = NULL;
                    ll->first = NULL;
                    tail = &ll->first;

                    for (t = l->first; t; t = t->next) {
                        if (t->text || t->type == TOK_WHITESPACE) {
                            tt = *tail =
                                new_Token(NULL, t->type, t->text, 0);
                            tail = &tt->next;
                        }
                    }

                    istk->expansion = ll;
                }
            } else {
                /*
                 * Check whether a `%rep' was started and not ended
                 * within this macro expansion. This can happen and
                 * should be detected. It's a fatal error because
                 * I'm too confused to work out how to recover
                 * sensibly from it.
                 */
                if (defining) {
                    if (defining->name)
                        error(ERR_PANIC,
                              "defining with name in expansion");
                    else if (istk->mstk->name)
                        error(ERR_FATAL,
                              "`%%rep' without `%%endrep' within"
                              " expansion of macro `%s'",
                              istk->mstk->name);
                }

                /*
                 * FIXME:  investigate the relationship at this point between
                 * istk->mstk and l->finishes
                 */
                {
                    MMacro *m = istk->mstk;
                    istk->mstk = m->next_active;
                    if (m->name) {
                        /*
                         * This was a real macro call, not a %rep, and
                         * therefore the parameter information needs to
                         * be freed.
                         */
                        nasm_free(m->params);
                        free_tlist(m->iline);
                        nasm_free(m->paramlen);
                        l->finishes->in_progress = false;
                    } else
                        free_mmacro(m);
                }
                istk->expansion = l->next;
                nasm_free(l);
                list->downlevel(LIST_MACRO);
            }
        }
        while (1) {             /* until we get a line we can use */

            if (istk->expansion) {      /* from a macro expansion */
                char *p;
                Line *l = istk->expansion;
                if (istk->mstk)
                    istk->mstk->lineno++;
                tline = l->first;
                istk->expansion = l->next;
                nasm_free(l);
                p = detoken(tline, false);
                list->line(LIST_MACRO, p);
                nasm_free(p);
                break;
            }
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
                if (i->conds)
                    error(ERR_FATAL,
                          "expected `%%endif' before end of file");
                /* only set line and file name if there's a next node */
                if (i->next) {
                    src_set_linnum(i->lineno);
                    nasm_free(src_set_fname(i->fname));
                }
                istk = i->next;
                list->downlevel(LIST_INCLUDE);
                nasm_free(i);
                if (!istk)
                    return NULL;
            }
        }

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
        if (!defining && !(istk->conds && !emitting(istk->conds->state)))
            tline = expand_mmac_params(tline);

        /*
         * Check the line to see if it's a preprocessor directive.
         */
        if (do_directive(tline) == DIRECTIVE_FOUND) {
            continue;
        } else if (defining) {
            /*
             * We're defining a multi-line macro. We emit nothing
             * at all, and just
             * shove the tokenized line on to the macro definition.
             */
            Line *l = nasm_malloc(sizeof(Line));
            l->next = defining->expansion;
            l->first = tline;
            l->finishes = false;
            defining->expansion = l;
            continue;
        } else if (istk->conds && !emitting(istk->conds->state)) {
            /*
             * We're in a non-emitting branch of a condition block.
             * Emit nothing at all, not even a blank line: when we
             * emerge from the condition we'll give a line-number
             * directive so we keep our place correctly.
             */
            free_tlist(tline);
            continue;
        } else if (istk->mstk && !istk->mstk->in_progress) {
            /*
             * We're in a %rep block which has been terminated, so
             * we're walking through to the %endrep without
             * emitting anything. Emit nothing at all, not even a
             * blank line: when we emerge from the %rep block we'll
             * give a line-number directive so we keep our place
             * correctly.
             */
            free_tlist(tline);
            continue;
        } else {
            tline = expand_smacro(tline);
            if (!expand_mmacro(tline)) {
                /*
                 * De-tokenize the line again, and emit it.
                 */
                line = detoken(tline, true);
                free_tlist(tline);
                break;
            } else {
                continue;       /* expand_mmacro calls free_tlist */
            }
        }
    }

    return line;
}

static void pp_cleanup(int pass)
{
    if (defining) {
        error(ERR_NONFATAL, "end of file while still defining macro `%s'",
              defining->name);
        free_mmacro(defining);
    }
    while (cstk)
        ctx_pop();
    free_macros();
    while (istk) {
        Include *i = istk;
        istk = istk->next;
        fclose(i->fp);
        nasm_free(i->fname);
        nasm_free(i);
    }
    while (cstk)
        ctx_pop();
    if (pass == 0) {
        free_llist(predef);
        delete_Blocks();
    }
}

void pp_include_path(char *path)
{
    IncPath *i;

    i = nasm_malloc(sizeof(IncPath));
    i->path = path ? nasm_strdup(path) : NULL;
    i->next = NULL;

    if (ipath != NULL) {
        IncPath *j = ipath;
        while (j->next != NULL)
            j = j->next;
        j->next = i;
    } else {
        ipath = i;
    }
}

/*
 * added by alexfru:
 *
 * This function is used to "export" the include paths, e.g.
 * the paths specified in the '-I' command switch.
 * The need for such exporting is due to the 'incbin' directive,
 * which includes raw binary files (unlike '%include', which
 * includes text source files). It would be real nice to be
 * able to specify paths to search for incbin'ned files also.
 * So, this is a simple workaround.
 *
 * The function use is simple:
 *
 * The 1st call (with NULL argument) returns a pointer to the 1st path
 * (char** type) or NULL if none include paths available.
 *
 * All subsequent calls take as argument the value returned by this
 * function last. The return value is either the next path
 * (char** type) or NULL if the end of the paths list is reached.
 *
 * It is maybe not the best way to do things, but I didn't want
 * to export too much, just one or two functions and no types or
 * variables exported.
 *
 * Can't say I like the current situation with e.g. this path list either,
 * it seems to be never deallocated after creation...
 */
char **pp_get_include_path_ptr(char **pPrevPath)
{
/*   This macro returns offset of a member of a structure */
#define GetMemberOffset(StructType,MemberName)\
  ((size_t)&((StructType*)0)->MemberName)
    IncPath *i;

    if (pPrevPath == NULL) {
        if (ipath != NULL)
            return &ipath->path;
        else
            return NULL;
    }
    i = (IncPath *) ((char *)pPrevPath - GetMemberOffset(IncPath, path));
    i = i->next;
    if (i != NULL)
        return &i->path;
    else
        return NULL;
#undef GetMemberOffset
}

void pp_pre_include(char *fname)
{
    Token *inc, *space, *name;
    Line *l;

    name = new_Token(NULL, TOK_INTERNAL_STRING, fname, 0);
    space = new_Token(name, TOK_WHITESPACE, NULL, 0);
    inc = new_Token(space, TOK_PREPROC_ID, "%include", 0);

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = inc;
    l->finishes = false;
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

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = false;
    predef = l;
}

void pp_pre_undefine(char *definition)
{
    Token *def, *space;
    Line *l;

    space = new_Token(NULL, TOK_WHITESPACE, NULL, 0);
    def = new_Token(space, TOK_PREPROC_ID, "%undef", 0);
    space->next = tokenize(definition);

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = false;
    predef = l;
}

/*
 * Added by Keith Kanios:
 *
 * This function is used to assist with "runtime" preprocessor
 * directives. (e.g. pp_runtime("%define __BITS__ 64");)
 *
 * ERRORS ARE IGNORED HERE, SO MAKE COMPLETELY SURE THAT YOU
 * PASS A VALID STRING TO THIS FUNCTION!!!!!
 */

void pp_runtime(char *definition)
{
    Token *def;

    def = tokenize(definition);
    if(do_directive(def) == NO_DIRECTIVE_FOUND)
        free_tlist(def);

}

void pp_extra_stdmac(const char **macros)
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

Preproc nasmpp = {
    pp_reset,
    pp_getline,
    pp_cleanup
};
