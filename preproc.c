/* preproc.c   macro preprocessor for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 18/iii/97 by Simon Tatham
 */

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>

#include "nasm.h"
#include "nasmlib.h"

typedef struct SMacro SMacro;
typedef struct MMacro MMacro;
typedef struct Context Context;
typedef struct Token Token;
typedef struct Line Line;
typedef struct Include Include;
typedef struct Cond Cond;
typedef struct IncPath IncPath;

/*
 * Store the definition of a single-line macro.
 */
struct SMacro {
    SMacro *next;
    char *name;
    int casesense;
    int nparam;
    int in_progress;
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
    int casesense;
    int nparam_min, nparam_max;
    int plus;			       /* is the last parameter greedy? */
    int nolist;			       /* is this macro listing-inhibited? */
    int in_progress;
    Token **defaults, *dlist;
    int ndefs;			       /* number of default parameters */
    Line *expansion;

    MMacro *next_active;
    Token **params, *iline;
    int nparam, rotate, *paramlen;
    unsigned long unique;
};

/*
 * The context stack is composed of a linked list of these.
 */
struct Context {
    Context *next;
    SMacro *localmac;
    char *name;
    unsigned long number;
};

/*
 * This is the internal form which we break input lines up into.
 * Typically stored in linked lists.
 *
 * TOK_PS_OTHER is a token type used internally within
 * expand_smacro(), to denote a token which has already been
 * checked for being a potential macro, but may still be a context-
 * local label.
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
struct Token {
    Token *next;
    char *text;
    SMacro *mac;		       /* associated macro for TOK_SMAC_END */
    int type;
};
enum {
    TOK_WHITESPACE = 1, TOK_COMMENT, TOK_ID, TOK_PREPROC_ID, TOK_STRING,
    TOK_NUMBER, TOK_SMAC_END, TOK_OTHER, TOK_PS_OTHER, TOK_SMAC_PARAM,
    TOK_INTERNAL_STRING
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
    MMacro *mstk;		       /* stack of active macros/reps */
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
 * Condition codes. Note that we use c_ prefix not C_ because C_ is
 * used in nasm.h for the "real" condition codes. At _this_ level,
 * we treat CXZ and ECXZ as condition codes, albeit non-invertible
 * ones, so we need a different enum...
 */
static char *conditions[] = {
    "a", "ae", "b", "be", "c", "cxz", "e", "ecxz", "g", "ge", "l", "le",
    "na", "nae", "nb", "nbe", "nc", "ne", "ng", "nge", "nl", "nle", "no",
    "np", "ns", "nz", "o", "p", "pe", "po", "s", "z"
};
enum {
    c_A, c_AE, c_B, c_BE, c_C, c_CXZ, c_E, c_ECXZ, c_G, c_GE, c_L, c_LE,
    c_NA, c_NAE, c_NB, c_NBE, c_NC, c_NE, c_NG, c_NGE, c_NL, c_NLE, c_NO,
    c_NP, c_NS, c_NZ, c_O, c_P, c_PE, c_PO, c_S, c_Z
};
static int inverse_ccs[] = {
    c_NA, c_NAE, c_NB, c_NBE, c_NC, -1, c_NE, -1, c_NG, c_NGE, c_NL, c_NLE,
    c_A, c_AE, c_B, c_BE, c_C, c_E, c_G, c_GE, c_L, c_LE, c_O, c_P, c_S,
    c_Z, c_NO, c_NP, c_PO, c_PE, c_NS, c_NZ
};

/*
 * Directive names.
 */
static char *directives[] = {
    "%assign", "%clear", "%define", "%elif", "%elifctx", "%elifdef",
    "%elifid", "%elifidn", "%elifidni", "%elifnctx", "%elifndef",
    "%elifnid", "%elifnidn", "%elifnidni", "%elifnnum", "%elifnstr",
    "%elifnum", "%elifstr", "%else", "%endif", "%endm", "%endmacro",
    "%endrep", "%error", "%exitrep", "%iassign", "%idefine", "%if",
    "%ifctx", "%ifdef", "%ifid", "%ifidn", "%ifidni", "%ifnctx",
    "%ifndef", "%ifnid", "%ifnidn", "%ifnidni", "%ifnnum",
    "%ifnstr", "%ifnum", "%ifstr", "%imacro", "%include", "%line",
    "%macro", "%pop", "%push", "%rep", "%repl", "%rotate"
};
enum {
    PP_ASSIGN, PP_CLEAR, PP_DEFINE, PP_ELIF, PP_ELIFCTX, PP_ELIFDEF,
    PP_ELIFID, PP_ELIFIDN, PP_ELIFIDNI, PP_ELIFNCTX, PP_ELIFNDEF,
    PP_ELIFNID, PP_ELIFNIDN, PP_ELIFNIDNI, PP_ELIFNNUM, PP_ELIFNSTR,
    PP_ELIFNUM, PP_ELIFSTR, PP_ELSE, PP_ENDIF, PP_ENDM, PP_ENDMACRO,
    PP_ENDREP, PP_ERROR, PP_EXITREP, PP_IASSIGN, PP_IDEFINE, PP_IF,
    PP_IFCTX, PP_IFDEF, PP_IFID, PP_IFIDN, PP_IFIDNI, PP_IFNCTX,
    PP_IFNDEF, PP_IFNID, PP_IFNIDN, PP_IFNIDNI, PP_IFNNUM,
    PP_IFNSTR, PP_IFNUM, PP_IFSTR, PP_IMACRO, PP_INCLUDE, PP_LINE,
    PP_MACRO, PP_POP, PP_PUSH, PP_REP, PP_REPL, PP_ROTATE
};


static Context *cstk;
static Include *istk;
static IncPath *ipath = NULL;

static efunc error;
static evalfunc evaluate;

static int pass;

static unsigned long unique;	       /* unique identifier numbers */

static char *linesync, *outline;

static Line *predef = NULL;

static ListGen *list;

/*
 * The number of hash values we use for the macro lookup tables.
 */
#define NHASH 31

/*
 * The current set of multi-line macros we have defined.
 */
static MMacro *mmacros[NHASH];

/*
 * The current set of single-line macros we have defined.
 */
static SMacro *smacros[NHASH];

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
static char **stdmacpos;

/*
 * The extra standard macros that come from the object format, if
 * any.
 */
static char **extrastdmac = NULL;
int any_extrastdmac;

/*
 * Forward declarations.
 */
static Token *expand_smacro (Token *tline);
static void update_fileline (int which);

/*
 * The pre-preprocessing stage... This function translates line
 * number indications as they emerge from GNU cpp (`# lineno "file"
 * flags') into NASM preprocessor line number indications (`%line
 * lineno file').
 */
static char *prepreproc(char *line) {
    int lineno, fnlen;
    char *fname, *oldline;

    if (line[0] == '#' && line[1] == ' ') {
	oldline = line;
	fname = oldline+2;
	lineno = atoi(fname);
	fname += strspn(fname, "0123456789 ");
	if (*fname == '"')
	    fname++;
	fnlen = strcspn(fname, "\"");
	line = nasm_malloc(20+fnlen);
	sprintf(line, "%%line %d %.*s", lineno, fnlen, fname);
	nasm_free (oldline);
    }
    return line;
}

/*
 * The hash function for macro lookups. Note that due to some
 * macros having case-insensitive names, the hash function must be
 * invariant under case changes. We implement this by applying a
 * perfectly normal hash function to the uppercase of the string.
 */
static int hash(char *s) {
    /*
     * Powers of three, mod 31.
     */
    static const int multipliers[] = {
	1, 3, 9, 27, 19, 26, 16, 17, 20, 29, 25, 13, 8, 24, 10,
	30, 28, 22, 4, 12, 5, 15, 14, 11, 2, 6, 18, 23, 7, 21
    };
    int h = 0;
    int i = 0;

    while (*s) {
	h += multipliers[i] * (unsigned char) (toupper(*s));
	s++;
	if (++i >= sizeof(multipliers)/sizeof(*multipliers))
	    i = 0;
    }
    h %= NHASH;
    return h;
}

/*
 * Free a linked list of tokens.
 */
static void free_tlist (Token *list) {
    Token *t;
    while (list) {
	t = list;
	list = list->next;
	nasm_free (t->text);
	nasm_free (t);
    }
}

/*
 * Free a linked list of lines.
 */
static void free_llist (Line *list) {
    Line *l;
    while (list) {
	l = list;
	list = list->next;
	free_tlist (l->first);
	nasm_free (l);
    }
}

/*
 * Pop the context stack.
 */
static void ctx_pop (void) {
    Context *c = cstk;
    SMacro *smac, *s;

    cstk = cstk->next;
    smac = c->localmac;
    while (smac) {
	s = smac;
	smac = smac->next;
	nasm_free (s->name);
	free_tlist (s->expansion);
	nasm_free (s);
    }
    nasm_free (c->name);
    nasm_free (c);
}

/*
 * Generate a line synchronisation comment, to ensure the assembler
 * knows which source file the current output has really come from.
 */
static void line_sync (void) {
    char text[30+FILENAME_MAX];
    sprintf(text, "%%line %d+%d %s",
	    (istk->expansion ? istk->lineno - istk->lineinc : istk->lineno),
	    (istk->expansion ? 0 : istk->lineinc), istk->fname);
    nasm_free (linesync);
    linesync = nasm_strdup(text);
}

#define BUF_DELTA 512
/*
 * Read a line from the top file in istk, handling multiple CR/LFs
 * at the end of the line read, and handling spurious ^Zs. Will
 * return lines from the standard macro set if this has not already
 * been done.
 */
static char *read_line (void) {
    char *buffer, *p, *q;
    int bufsize;

    if (stdmacpos) {
	if (*stdmacpos) {
	    char *ret = nasm_strdup(*stdmacpos++);
	    if (!*stdmacpos && any_extrastdmac) {
		stdmacpos = extrastdmac;
		any_extrastdmac = FALSE;
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
		Token *head, **tail, *t, *tt;

		for (pd = predef; pd; pd = pd->next) {
		    head = NULL;
		    tail = &head;
		    for (t = pd->first; t; t = t->next) {
			tt = *tail = nasm_malloc(sizeof(Token));
			tt->next = NULL;
			tail = &tt->next;
			tt->type = t->type;
			tt->text = nasm_strdup(t->text);
			tt->mac = t->mac;   /* always NULL here, in fact */
		    }
		    l = nasm_malloc(sizeof(Line));
		    l->next = istk->expansion;
		    l->first = head;
		    l->finishes = FALSE;
		    istk->expansion = l;
		}
	    }
	    return ret;
	} else {
	    stdmacpos = NULL;
	    line_sync();
	    update_fileline(3);	       /* update __FILE__ and __LINE__ */
	}
    }

    bufsize = BUF_DELTA;
    buffer = nasm_malloc(BUF_DELTA);
    p = buffer;
    while (1) {
	q = fgets(p, bufsize-(p-buffer), istk->fp);
	if (!q)
	    break;
	p += strlen(p);
	if (p > buffer && p[-1] == '\n') {
	    istk->lineno += istk->lineinc;
	    update_fileline(1);	       /* update __LINE__ only */
	    break;
	}
	if (p-buffer > bufsize-10) {
	    bufsize += BUF_DELTA;
	    buffer = nasm_realloc(buffer, bufsize);
	}
    }

    if (!q && p == buffer) {
	nasm_free (buffer);
	return NULL;
    }

    /*
     * Play safe: remove CRs as well as LFs, if any of either are
     * present at the end of the line.
     */
    while (p > buffer && (p[-1] == '\n' || p[-1] == '\r'))
	*--p = '\0';

    /*
     * Handle spurious ^Z, which may be inserted into source files
     * by some file transfer utilities.
     */
    buffer[strcspn(buffer, "\032")] = '\0';

    list->line (LIST_READ, buffer);

    return buffer;
}

/*
 * Tokenise a line of text. This is a very simple process since we
 * don't need to parse the value out of e.g. numeric tokens: we
 * simply split one string into many.
 */
static Token *tokenise (char *line) {
    char *p = line;
    int type;
    Token *list = NULL;
    Token *t, **tail = &list;

    while (*line) {
	p = line;
	if (*p == '%' &&
	    (p[1] == '{' || p[1] == '!' || (p[1] == '%' && isidchar(p[2])) ||
	     p[1] == '$' || p[1] == '+' || p[1] == '-' || isidchar(p[1]))) {
	    type = TOK_PREPROC_ID;
	    p++;
	    if (*p == '{') {
		p++;
		while (*p && *p != '}') {
		    p[-1] = *p;
		    p++;
		}
		p[-1] = '\0';
		if (*p) p++;
	    } else {
		if (*p == '!' || *p == '%' || *p == '$' ||
		    *p == '+' || *p == '-') p++;
		while (*p && isidchar(*p))
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
	    if (*p) p++;
	} else if (isnumstart(*p)) {
	    /*
	     * A number token.
	     */
	    type = TOK_NUMBER;
	    p++;
	    while (*p && isnumchar(*p))
		p++;
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
		while (*p) p++;
	    }
	} else if (*p == ';') {
	    type = TOK_COMMENT;
	    while (*p) p++;
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
		(p[0] == '%' && p[1] == '%') ||
		(p[0] == '<' && p[1] == '=') ||
		(p[0] == '>' && p[1] == '=') ||
		(p[0] == '=' && p[1] == '=') ||
		(p[0] == '!' && p[1] == '=') ||
		(p[0] == '<' && p[1] == '>') ||
		(p[0] == '&' && p[1] == '&') ||
		(p[0] == '|' && p[1] == '|') ||
		(p[0] == '^' && p[1] == '^'))
		p++;
	    p++;
	}
	if (type != TOK_COMMENT) {
	    *tail = t = nasm_malloc (sizeof(Token));
	    tail = &t->next;
	    t->next = NULL;
	    t->type = type;
	    t->text = nasm_malloc(1+p-line);
	    strncpy(t->text, line, p-line);
	    t->text[p-line] = '\0';
	}
	line = p;
    }

    return list;
}

/*
 * Convert a line of tokens back into text.
 */
static char *detoken (Token *tlist) {
    Token *t;
    int len;
    char *line, *p;

    len = 0;
    for (t = tlist; t; t = t->next) {
	if (t->type == TOK_PREPROC_ID && t->text[1] == '!') {
	    char *p = getenv(t->text+2);
	    nasm_free (t->text);
	    if (p)
		t->text = nasm_strdup(p);
	    else
		t->text = NULL;
	}
	if (t->text)
	    len += strlen(t->text);
    }
    p = line = nasm_malloc(len+1);
    for (t = tlist; t; t = t->next) {
	if (t->text) {
	    strcpy (p, t->text);
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
 */
static int ppscan(void *private_data, struct tokenval *tokval) {
    Token **tlineptr = private_data;
    Token *tline;

    do {
	tline = *tlineptr;
	*tlineptr = tline ? tline->next : NULL;
    } while (tline && (tline->type == TOK_WHITESPACE ||
		       tline->type == TOK_COMMENT));

    if (!tline)
	return tokval->t_type = TOKEN_EOS;

    if (tline->text[0] == '$' && !tline->text[1])
	return tokval->t_type = TOKEN_HERE;
    if (tline->text[0] == '$' && tline->text[1] == '$' && !tline->text[1])
	return tokval->t_type = TOKEN_BASE;

    if (tline->type == TOK_ID) {
	tokval->t_charptr = tline->text;
	if (tline->text[0] == '$') {
	    tokval->t_charptr++;
	    return tokval->t_type = TOKEN_ID;
	}

	/*
	 * This is the only special case we actually need to worry
	 * about in this restricted context.
	 */
	if (!nasm_stricmp(tline->text, "seg"))
	    return tokval->t_type = TOKEN_SEG;

	return tokval->t_type = TOKEN_ID;
    }

    if (tline->type == TOK_NUMBER) {
	int rn_error;

	tokval->t_integer = readnum(tline->text, &rn_error);
	if (rn_error)
	    return tokval->t_type = TOKEN_ERRNUM;
	tokval->t_charptr = NULL;
	return tokval->t_type = TOKEN_NUM;
    }

    if (tline->type == TOK_OTHER) {
	if (!strcmp(tline->text, "<<")) return tokval->t_type = TOKEN_SHL;
	if (!strcmp(tline->text, ">>")) return tokval->t_type = TOKEN_SHR;
	if (!strcmp(tline->text, "//")) return tokval->t_type = TOKEN_SDIV;
	if (!strcmp(tline->text, "%%")) return tokval->t_type = TOKEN_SMOD;
	if (!strcmp(tline->text, "==")) return tokval->t_type = TOKEN_EQ;
	if (!strcmp(tline->text, "<>")) return tokval->t_type = TOKEN_NE;
	if (!strcmp(tline->text, "!=")) return tokval->t_type = TOKEN_NE;
	if (!strcmp(tline->text, "<=")) return tokval->t_type = TOKEN_LE;
	if (!strcmp(tline->text, ">=")) return tokval->t_type = TOKEN_GE;
	if (!strcmp(tline->text, "&&")) return tokval->t_type = TOKEN_DBL_AND;
	if (!strcmp(tline->text, "^^")) return tokval->t_type = TOKEN_DBL_XOR;
	if (!strcmp(tline->text, "||")) return tokval->t_type = TOKEN_DBL_OR;
    }

    /*
     * We have no other options: just return the first character of
     * the token text.
     */
    return tokval->t_type = tline->text[0];
}

/*
 * Return the Context structure associated with a %$ token. Return
 * NULL, having _already_ reported an error condition, if the
 * context stack isn't deep enough for the supplied number of $
 * signs.
 */
static Context *get_ctx (char *name) {
    Context *ctx;
    int i;

    if (!cstk) {
	error (ERR_NONFATAL|ERR_OFFBY1, "`%s': context stack is empty", name);
	return NULL;
    }

    i = 1;
    ctx = cstk;
    while (name[i+1] == '$') {
	i++;
	ctx = ctx->next;
	if (!ctx) {
	    error (ERR_NONFATAL|ERR_OFFBY1, "`%s': context stack is only"
		   " %d level%s deep", name, i-1, (i==2 ? "" : "s"));
	    return NULL;
	}
    }
    return ctx;
}

/*
 * Compare a string to the name of an existing macro; this is a
 * simple wrapper which calls either strcmp or nasm_stricmp
 * depending on the value of the `casesense' parameter.
 */
static int mstrcmp(char *p, char *q, int casesense) {
    return casesense ? strcmp(p,q) : nasm_stricmp(p,q);
}

/*
 * Open an include file. This routine must always return a valid
 * file pointer if it returns - it's responsible for throwing an
 * ERR_FATAL and bombing out completely if not. It should also try
 * the include path one by one until it finds the file or reaches
 * the end of the path.
 */
static FILE *inc_fopen(char *file) {
    FILE *fp;
    char *prefix = "", *combine;
    IncPath *ip = ipath;
    int len = strlen(file);

    do {
	combine = nasm_malloc(strlen(prefix)+len+1);
	strcpy(combine, prefix);
	strcat(combine, file);
	fp = fopen(combine, "r");
	nasm_free (combine);
	if (fp)
	    return fp;
	prefix = ip ? ip->path : NULL;
	if (ip)
	    ip = ip->next;
    } while (prefix);

    error (ERR_FATAL|ERR_OFFBY1,
	   "unable to open include file `%s'", file);
    return NULL;		       /* never reached - placate compilers */
}

/*
 * Determine if we should warn on defining a single-line macro of
 * name `name', with `nparam' parameters. If nparam is 0, will
 * return TRUE if _any_ single-line macro of that name is defined.
 * Otherwise, will return TRUE if a single-line macro with either
 * `nparam' or no parameters is defined.
 *
 * If a macro with precisely the right number of parameters is
 * defined, the address of the definition structure will be
 * returned in `defn'; otherwise NULL will be returned. If `defn'
 * is NULL, no action will be taken regarding its contents, and no
 * error will occur.
 *
 * Note that this is also called with nparam zero to resolve
 * `ifdef'.
 */
static int smacro_defined (char *name, int nparam, SMacro **defn) {
    SMacro *m;
    Context *ctx;
    char *p;

    if (name[0] == '%' && name[1] == '$') {
	ctx = get_ctx (name);
	if (!ctx)
	    return FALSE;	       /* got to return _something_ */
	m = ctx->localmac;
	p = name+1;
	p += strspn(p, "$");
    } else {
	m = smacros[hash(name)];
	p = name;
    }

    while (m) {
	if (!mstrcmp(m->name, p, m->casesense) &&
	    (nparam == 0 || m->nparam == 0 || nparam == m->nparam)) {
	    if (defn) {
		if (nparam == m->nparam)
		    *defn = m;
		else
		    *defn = NULL;
	    }
	    return TRUE;
	}
	m = m->next;
    }
    return FALSE;
}

/*
 * Update the __FILE__ and __LINE__ macros. Specifically, update
 * __FILE__ if bit 1 of our argument is set, and update __LINE__ if
 * bit 0 is set.
 *
 * If the macros don't exist, a `%clear' must have happened, in
 * which case we should exit quite happily and carry on going. It's
 * not an error condition.
 */
static void update_fileline(int which) {
    SMacro *sm;
    char num[20];

    if ((which & 3) && smacro_defined ("__FILE__", 0, &sm) && sm) {
	free_tlist(sm->expansion);
	sm->expansion = nasm_malloc(sizeof(Token));
	sm->expansion->next = NULL;
	sm->expansion->mac = NULL;
	sm->expansion->type = TOK_STRING;
	sm->expansion->text = nasm_malloc(3+strlen(istk->fname));
	/* FIXME: throw an error if both sorts of quote are present */
	/* Better still, invent a way for us to cope with that case */
	sprintf(sm->expansion->text, "\"%s\"", istk->fname);
    }

    if ((which & 1) && smacro_defined ("__LINE__", 0, &sm) && sm) {
	free_tlist(sm->expansion);
	sm->expansion = nasm_malloc(sizeof(Token));
	sm->expansion->next = NULL;
	sm->expansion->mac = NULL;
	sm->expansion->type = TOK_NUMBER;
	sprintf(num, "%d", istk->lineno - istk->lineinc);
	sm->expansion->text = nasm_strdup(num);
    }
}

/*
 * Count and mark off the parameters in a multi-line macro call.
 * This is called both from within the multi-line macro expansion
 * code, and also to mark off the default parameters when provided
 * in a %macro definition line.
 */
static void count_mmac_params (Token *t, int *nparam, Token ***params) {
    int paramsize, brace;

    *nparam = paramsize = 0;
    *params = NULL;
    while (t) {
	if (*nparam >= paramsize) {
	    paramsize += PARAM_DELTA;
	    *params = nasm_realloc(*params, sizeof(**params) * paramsize);
	}
	if (t && t->type == TOK_WHITESPACE)
	    t = t->next;
	brace = FALSE;
	if (t && t->type == TOK_OTHER && !strcmp(t->text, "{"))
	    brace = TRUE;
	(*params)[(*nparam)++] = t;
	while (t && (t->type != TOK_OTHER ||
		     strcmp(t->text, brace ? "}" : ",")))
	    t = t->next;
	if (t) {		       /* got a comma/brace */
	    t = t->next;
	    if (brace) {
		/*
		 * Now we've found the closing brace, look further
		 * for the comma.
		 */
		if (t && t->type == TOK_WHITESPACE)
		    t = t->next;
		if (t && (t->type != TOK_OTHER || strcmp(t->text, ","))) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "braces do not enclose all of macro parameter");
		    while (t && (t->type != TOK_OTHER ||
				 strcmp(t->text, ",")))
			t = t->next;
		}
		if (t)
		    t = t->next;	       /* eat the comma */
	    }
	}
	else			       /* got EOL */
	    break;
    }
}

/*
 * Determine whether one of the various `if' conditions is true or
 * not.
 *
 * We must free the tline we get passed.
 */
static int if_condition (Token *tline, int i) {
    int j, casesense;
    Token *t, *tt, **tptr, *origline;
    struct tokenval tokval;
    expr *evalresult;

    origline = tline;

    switch (i) {
      case PP_IFCTX: case PP_ELIFCTX:
      case PP_IFNCTX: case PP_ELIFNCTX:
	j = FALSE;		       /* have we matched yet? */
	if (!cstk)
	    error(ERR_FATAL|ERR_OFFBY1,
		  "`%s': context stack is empty", directives[i]);
	else while (tline) {
	    if (tline->type == TOK_WHITESPACE)
		tline = tline->next;
	    if (!tline || tline->type != TOK_ID) {
		error(ERR_NONFATAL|ERR_OFFBY1,
		      "`%s' expects context identifiers", directives[i]);
		free_tlist (origline);
		return -1;
	    }
	    if (!nasm_stricmp(tline->text, cstk->name))
		j = TRUE;
	    tline = tline->next;
	}
	if (i == PP_IFNCTX || i == PP_ELIFNCTX)
	    j = !j;
	free_tlist (origline);
	return j;

      case PP_IFDEF: case PP_ELIFDEF:
      case PP_IFNDEF: case PP_ELIFNDEF:
	j = FALSE;		       /* have we matched yet? */
	while (tline) {
	    if (tline->type == TOK_WHITESPACE)
		tline = tline->next;
	    if (!tline || (tline->type != TOK_ID &&
			   (tline->type != TOK_PREPROC_ID ||
			    tline->text[1] != '$'))) {
		error(ERR_NONFATAL|ERR_OFFBY1,
		      "`%%if%sdef' expects macro identifiers",
		      (i==PP_ELIFNDEF ? "n" : ""));
		free_tlist (origline);
		return -1;
	    }
	    if (smacro_defined(tline->text, 0, NULL))
		j = TRUE;
		tline = tline->next;
	}
	if (i == PP_IFNDEF || i == PP_ELIFNDEF)
	    j = !j;
	free_tlist (origline);
	return j;

      case PP_IFIDN: case PP_ELIFIDN: case PP_IFNIDN: case PP_ELIFNIDN:
      case PP_IFIDNI: case PP_ELIFIDNI: case PP_IFNIDNI: case PP_ELIFNIDNI:
	tline = expand_smacro(tline);
	t = tt = tline;
	while (tt && (tt->type != TOK_OTHER || strcmp(tt->text, ",")))
	    tt = tt->next;
	if (!tt) {
	    error(ERR_NONFATAL, "`%s' expects two comma-separated arguments");
	    free_tlist (tline);
	    return -1;
	}
	tt = tt->next;
	casesense = (i == PP_IFIDN || i == PP_ELIFIDN ||
		     i == PP_IFNIDN || i == PP_ELIFNIDN);
	j = TRUE;		       /* assume equality unless proved not */
	while ((t->type != TOK_OTHER || strcmp(t->text, ",")) && tt) {
	    if (tt->type == TOK_OTHER && !strcmp(tt->text, ",")) {
		error(ERR_NONFATAL, "`%s': more than one comma on line",
		      directives[i]);
		free_tlist (tline);
		return -1;
	    }
	    if (t->type == TOK_WHITESPACE) {
		t = t->next;
		continue;
	    } else if (tt->type == TOK_WHITESPACE) {
		tt = tt->next;
		continue;
	    } else if (tt->type != t->type ||
		       (casesense ? strcmp(tt->text, t->text) :
			nasm_stricmp(tt->text, t->text))) {
		j = FALSE;	       /* found mismatching tokens */
		break;
	    } else {
		t = t->next;
		tt = tt->next;
		continue;
	    }
	}
	if ((t->type != TOK_OTHER || strcmp(t->text, ",")) || tt)
	    j = FALSE;		       /* trailing gunk on one end or other */
	if (i == PP_IFNIDN || i == PP_ELIFNIDN)
	    j = !j;
	free_tlist (tline);
	return j;

      case PP_IFID: case PP_ELIFID: case PP_IFNID: case PP_ELIFNID:
      case PP_IFNUM: case PP_ELIFNUM: case PP_IFNNUM: case PP_ELIFNNUM:
      case PP_IFSTR: case PP_ELIFSTR: case PP_IFNSTR: case PP_ELIFNSTR:
	tline = expand_smacro(tline);
	t = tline;
	while (t && t->type == TOK_WHITESPACE)
	    t = t->next;
	j = FALSE;		       /* placate optimiser */
	switch (i) {
	  case PP_IFID: case PP_ELIFID: case PP_IFNID: case PP_ELIFNID:
	    j = (t->type == TOK_ID);
	    break;
	  case PP_IFNUM: case PP_ELIFNUM: case PP_IFNNUM: case PP_ELIFNNUM:
	    j = (t->type == TOK_NUMBER);
	    break;
	  case PP_IFSTR: case PP_ELIFSTR: case PP_IFNSTR: case PP_ELIFNSTR:
	    j = (t->type == TOK_STRING);
	    break;
	}
	if (i == PP_IFNID || i == PP_ELIFNID ||
	    i == PP_IFNNUM || i == PP_ELIFNNUM ||
	    i == PP_IFNSTR || i == PP_ELIFNSTR)
	    j = !j;
	free_tlist (tline);
	return j;

      case PP_IF: case PP_ELIF:
	t = tline = expand_smacro(tline);
	tptr = &t;
	tokval.t_type = TOKEN_INVALID;
	evalresult = evaluate (ppscan, tptr, &tokval,
			       NULL, pass | 0x10, error, NULL);
	free_tlist (tline);
	if (!evalresult)
	    return -1;
	if (tokval.t_type)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after expression ignored");
	if (!is_simple(evalresult)) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "non-constant value given to `%s'", directives[i]);
	    return -1;
	}
	return reloc_value(evalresult) != 0;

      default:
	error(ERR_FATAL|ERR_OFFBY1,
	      "preprocessor directive `%s' not yet implemented",
	      directives[i]);
	free_tlist (origline);
	return -1;		       /* yeah, right */
    }
}

/*
 * Find out if a line contains a preprocessor directive, and deal
 * with it if so.
 * 
 * If a directive _is_ found, we are expected to free_tlist() the
 * line.
 *
 * Return values go like this:
 * 
 * bit 0 is set if a directive was found (so the line gets freed)
 * bit 1 is set if a blank line should be emitted
 * bit 2 is set if a re-sync line number comment should be emitted
 *
 * (bits 1 and 2 are mutually exclusive in that the rest of the
 * preprocessor doesn't guarantee to be able to handle the case in
 * which both are set)
 */
static int do_directive (Token *tline) {
    int i, j, k, m, nparam, nolist;
    char *p, *mname;
    Include *inc;
    Context *ctx;
    Cond *cond;
    SMacro *smac, **smhead;
    MMacro *mmac;
    Token *t, *tt, *param_start, *macro_start, *last, **tptr, *origline;
    Line *l;
    struct tokenval tokval;
    expr *evalresult;

    origline = tline;

    if (tline && tline->type == TOK_WHITESPACE)
	tline = tline->next;
    if (!tline || tline->type != TOK_PREPROC_ID ||
	(tline->text[1]=='%' || tline->text[1]=='$' || tline->text[1]=='!'))
	return 0;

    i = -1;
    j = sizeof(directives)/sizeof(*directives);
    while (j-i > 1) {
	k = (j+i) / 2;
	m = nasm_stricmp(tline->text, directives[k]);
	if (m == 0) {
	    i = k;
	    j = -2;
	    break;
	} else if (m < 0) {
	    j = k;
	} else
	    i = k;
    }

    /*
     * If we're in a non-emitting branch of a condition construct,
     * or walking to the end of an already terminated %rep block,
     * we should ignore all directives except for condition
     * directives.
     */
    if (((istk->conds && !emitting(istk->conds->state)) ||
	 (istk->mstk && !istk->mstk->in_progress)) &&
	i != PP_IF && i != PP_ELIF &&
	i != PP_IFCTX && i != PP_ELIFCTX &&
	i != PP_IFDEF && i != PP_ELIFDEF &&
	i != PP_IFID && i != PP_ELIFID &&
	i != PP_IFIDN && i != PP_ELIFIDN &&
	i != PP_IFIDNI && i != PP_ELIFIDNI &&
	i != PP_IFNCTX && i != PP_ELIFNCTX &&
	i != PP_IFNDEF && i != PP_ELIFNDEF &&
	i != PP_IFNID && i != PP_ELIFNID &&
	i != PP_IFNIDN && i != PP_ELIFNIDN &&
	i != PP_IFNIDNI && i != PP_ELIFNIDNI &&
	i != PP_IFNNUM && i != PP_ELIFNNUM &&
	i != PP_IFNSTR && i != PP_ELIFNSTR &&
	i != PP_IFNUM && i != PP_ELIFNUM &&
	i != PP_IFSTR && i != PP_ELIFSTR &&
	i != PP_ELSE && i != PP_ENDIF)
	return 0;

    /*
     * If we're defining a macro or reading a %rep block, we should
     * ignore all directives except for %macro/%imacro (which
     * generate an error), %endm/%endmacro, and (only if we're in a
     * %rep block) %endrep.
     */
    if (defining && i != PP_MACRO && i != PP_IMACRO &&
	i != PP_ENDMACRO && i != PP_ENDM &&
	(defining->name || i != PP_ENDREP))
	return 0;

    if (j != -2) {
	error(ERR_NONFATAL|ERR_OFFBY1, "unknown preprocessor directive `%s'",
	      tline->text);
	return 0;		       /* didn't get it */
    }

    switch (i) {

      case PP_CLEAR:
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%clear' ignored");
	for (j=0; j<NHASH; j++) {
	    while (mmacros[j]) {
		MMacro *m = mmacros[j];
		mmacros[j] = mmacros[j]->next;
		nasm_free (m->name);
		free_tlist (m->dlist);
		free_llist (m->expansion);
		nasm_free (m);
	    }
	    while (smacros[j]) {
		SMacro *s = smacros[j];
		smacros[j] = smacros[j]->next;
		nasm_free (s->name);
		free_tlist (s->expansion);
		nasm_free (s);
	    }
	}
	free_tlist (origline);
	return 3;

      case PP_INCLUDE:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || (tline->type != TOK_STRING &&
		       tline->type != TOK_INTERNAL_STRING)) {
	    error(ERR_NONFATAL|ERR_OFFBY1, "`%%include' expects a file name");
	    free_tlist (origline);
	    return 3;		       /* but we did _something_ */
	}
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%include' ignored");
	if (tline->type != TOK_INTERNAL_STRING) {
	    p = tline->text+1;	       /* point past the quote to the name */
	    p[strlen(p)-1] = '\0';     /* remove the trailing quote */
	} else
	    p = tline->text;	       /* internal_string is easier */
	inc = nasm_malloc(sizeof(Include));
	inc->next = istk;
	inc->conds = NULL;
	inc->fp = inc_fopen(p);
	inc->fname = nasm_strdup(p);
	inc->lineno = inc->lineinc = 1;
	inc->expansion = NULL;
	inc->mstk = NULL;
	istk = inc;
	list->uplevel (LIST_INCLUDE);
	update_fileline(3);	       /* update __FILE__ and __LINE__ */
	free_tlist (origline);
	return 5;

      case PP_PUSH:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_ID) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "`%%push' expects a context identifier");
	    free_tlist (origline);
	    return 3;		       /* but we did _something_ */
	}
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%push' ignored");
	ctx = nasm_malloc(sizeof(Context));
	ctx->next = cstk;
	ctx->localmac = NULL;
	ctx->name = nasm_strdup(tline->text);
	ctx->number = unique++;
	cstk = ctx;
	free_tlist (origline);
	break;

      case PP_REPL:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_ID) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "`%%repl' expects a context identifier");
	    free_tlist (origline);
	    return 3;		       /* but we did _something_ */
	}
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%repl' ignored");
	if (!cstk)
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "`%%repl': context stack is empty");
	else {
	    nasm_free (cstk->name);
	    cstk->name = nasm_strdup(tline->text);
	}
	free_tlist (origline);
	break;

      case PP_POP:
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%pop' ignored");
	if (!cstk)
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "`%%pop': context stack is already empty");
	else
	    ctx_pop();
	free_tlist (origline);
	break;

      case PP_ERROR:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_STRING) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "`%%error' expects an error string");
	    free_tlist (origline);
	    return 3;		       /* but we did _something_ */
	}
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%error' ignored");
	p = tline->text+1;	       /* point past the quote to the name */
	p[strlen(p)-1] = '\0';	       /* remove the trailing quote */
	error(ERR_NONFATAL|ERR_OFFBY1, "user error: %s", p);
	free_tlist (origline);
	break;

      case PP_IF:
      case PP_IFCTX:
      case PP_IFDEF:
      case PP_IFID:
      case PP_IFIDN:
      case PP_IFIDNI:
      case PP_IFNCTX:
      case PP_IFNDEF:
      case PP_IFNID:
      case PP_IFNIDN:
      case PP_IFNIDNI:
      case PP_IFNNUM:
      case PP_IFNSTR:
      case PP_IFNUM:
      case PP_IFSTR:
	if (istk->conds && !emitting(istk->conds->state))
	    j = COND_NEVER;
	else {
	    j = if_condition(tline->next, i);
	    tline->next = NULL;	       /* it got freed */
	    free_tlist (origline);
	    if (j < 0)
		return 3;
	    else
		j = j ? COND_IF_TRUE : COND_IF_FALSE;
	}
	cond = nasm_malloc(sizeof(Cond));
	cond->next = istk->conds;
	cond->state = j;
	istk->conds = cond;
	return (j == COND_IF_TRUE ? 3 : 1);

      case PP_ELIF:
      case PP_ELIFCTX:
      case PP_ELIFDEF:
      case PP_ELIFID:
      case PP_ELIFIDN:
      case PP_ELIFIDNI:
      case PP_ELIFNCTX:
      case PP_ELIFNDEF:
      case PP_ELIFNID:
      case PP_ELIFNIDN:
      case PP_ELIFNIDNI:
      case PP_ELIFNNUM:
      case PP_ELIFNSTR:
      case PP_ELIFNUM:
      case PP_ELIFSTR:
	if (!istk->conds)
	    error(ERR_FATAL|ERR_OFFBY1, "`%s': no matching `%%if'",
		  directives[i]);
	if (emitting(istk->conds->state) || istk->conds->state == COND_NEVER)
	    istk->conds->state = COND_NEVER;
	else {
	    j = if_condition(tline->next, i);
	    tline->next = NULL;	       /* it got freed */
	    free_tlist (origline);
	    if (j < 0)
		return 3;
	    else
		istk->conds->state = j ? COND_IF_TRUE : COND_IF_FALSE;
	}
	return (istk->conds->state == COND_IF_TRUE ? 5 : 1);

      case PP_ELSE:
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%else' ignored");
	if (!istk->conds)
	    error(ERR_FATAL|ERR_OFFBY1,
		  "`%%else': no matching `%%if'");
	if (emitting(istk->conds->state) || istk->conds->state == COND_NEVER)
	    istk->conds->state = COND_ELSE_FALSE;
	else
	    istk->conds->state = COND_ELSE_TRUE;
	free_tlist (origline);
	return 5;

      case PP_ENDIF:
	if (tline->next)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after `%%endif' ignored");
	if (!istk->conds)
	    error(ERR_FATAL|ERR_OFFBY1,
		  "`%%endif': no matching `%%if'");
	cond = istk->conds;
	istk->conds = cond->next;
	nasm_free (cond);
	free_tlist (origline);
	return 5;

      case PP_MACRO:
      case PP_IMACRO:
	if (defining)
	    error (ERR_FATAL|ERR_OFFBY1,
		   "`%%%smacro': already defining a macro",
		   (i == PP_IMACRO ? "i" : ""));
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_ID) {
	    error (ERR_NONFATAL|ERR_OFFBY1,
		   "`%%%smacro' expects a macro name",
		   (i == PP_IMACRO ? "i" : ""));
	    return 3;
	}
	defining = nasm_malloc(sizeof(MMacro));
	defining->name = nasm_strdup(tline->text);
	defining->casesense = (i == PP_MACRO);
	defining->plus = FALSE;
	defining->nolist = FALSE;
	defining->in_progress = FALSE;
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_NUMBER) {
	    error (ERR_NONFATAL|ERR_OFFBY1,
		   "`%%%smacro' expects a parameter count",
		   (i == PP_IMACRO ? "i" : ""));
	    defining->nparam_min = defining->nparam_max = 0;
	} else {
	    defining->nparam_min = defining->nparam_max =
		readnum(tline->text, &j);
	    if (j)
		error (ERR_NONFATAL|ERR_OFFBY1,
		       "unable to parse parameter count `%s'", tline->text);
	}
	if (tline && tline->next && tline->next->type == TOK_OTHER &&
	    !strcmp(tline->next->text, "-")) {
	    tline = tline->next->next;
	    if (tline && tline->type == TOK_OTHER &&
		!strcmp(tline->text, "*"))
		defining->nparam_max = INT_MAX;
	    else if (!tline || tline->type != TOK_NUMBER)
		error (ERR_NONFATAL|ERR_OFFBY1,
		       "`%%%smacro' expects a parameter count after `-'",
		       (i == PP_IMACRO ? "i" : ""));
	    else {
		defining->nparam_max = readnum(tline->text, &j);
		if (j)
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "unable to parse parameter count `%s'",
			   tline->text);
		if (defining->nparam_min > defining->nparam_max)
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "minimum parameter count exceeds maximum");
	    }
	}
	if (tline && tline->next && tline->next->type == TOK_OTHER &&
	    !strcmp(tline->next->text, "+")) {
	    tline = tline->next;
	    defining->plus = TRUE;
	}
	if (tline && tline->next && tline->next->type == TOK_ID &&
	    !nasm_stricmp(tline->next->text, ".nolist")) {
	    tline = tline->next;
	    defining->nolist = TRUE;
	}
	mmac = mmacros[hash(defining->name)];
	while (mmac) {
	    if (!strcmp(mmac->name, defining->name) &&
		(mmac->nparam_min<=defining->nparam_max || defining->plus) &&
		(defining->nparam_min<=mmac->nparam_max || mmac->plus)) {
		error (ERR_WARNING|ERR_OFFBY1,
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
	    count_mmac_params (defining->dlist, &defining->ndefs,
			       &defining->defaults);
	} else {
	    defining->dlist = NULL;
	    defining->defaults = NULL;
	}
	defining->expansion = NULL;
	free_tlist (origline);
	return 1;

      case PP_ENDM:
      case PP_ENDMACRO:
	if (!defining) {
	    error (ERR_NONFATAL|ERR_OFFBY1, "`%s': not defining a macro",
		   tline->text);
	    return 3;
	}
	k = hash(defining->name);
	defining->next = mmacros[k];
	mmacros[k] = defining;
	defining = NULL;
	free_tlist (origline);
	return 5;

      case PP_ROTATE:
	if (tline->next && tline->next->type == TOK_WHITESPACE)
	    tline = tline->next;
	t = expand_smacro(tline->next);
	tline->next = NULL;
	free_tlist (origline);
	tline = t;
	tptr = &t;
	tokval.t_type = TOKEN_INVALID;
	evalresult = evaluate (ppscan, tptr, &tokval, NULL, pass, error, NULL);
	free_tlist (tline);
	if (!evalresult)
	    return 3;
	if (tokval.t_type)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after expression ignored");
	if (!is_simple(evalresult)) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "non-constant value given to `%%rotate'");
	    return 3;
	}
	mmac = istk->mstk;
	while (mmac && !mmac->name)    /* avoid mistaking %reps for macros */
	    mmac = mmac->next_active;
	if (!mmac)
	    error(ERR_NONFATAL, "`%rotate' invoked outside a macro call");
	mmac->rotate = mmac->rotate + reloc_value(evalresult);
	if (mmac->rotate < 0)
	    mmac->rotate = mmac->nparam - (-mmac->rotate) % mmac->nparam;
	mmac->rotate %= mmac->nparam;
	return 1;

      case PP_REP:
	nolist = FALSE;
	tline = tline->next;
	if (tline->next && tline->next->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (tline->next && tline->next->type == TOK_ID &&
	    !nasm_stricmp(tline->next->text, ".nolist")) {
	    tline = tline->next;
	    nolist = TRUE;
	}
	t = expand_smacro(tline->next);
	tline->next = NULL;
	free_tlist (origline);
	tline = t;
	tptr = &t;
	tokval.t_type = TOKEN_INVALID;
	evalresult = evaluate (ppscan, tptr, &tokval, NULL, pass, error, NULL);
	free_tlist (tline);
	if (!evalresult)
	    return 3;
	if (tokval.t_type)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after expression ignored");
	if (!is_simple(evalresult)) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "non-constant value given to `%%rep'");
	    return 3;
	}
	defining = nasm_malloc(sizeof(MMacro));
	defining->name = NULL;	       /* flags this macro as a %rep block */
	defining->casesense = 0;
	defining->plus = FALSE;
	defining->nolist = nolist;
	defining->in_progress = reloc_value(evalresult) + 1;
	defining->nparam_min = defining->nparam_max = 0;
	defining->expansion = NULL;
	defining->next_active = istk->mstk;
	return 1;

      case PP_ENDREP:
	if (!defining) {
	    error (ERR_NONFATAL|ERR_OFFBY1,
		   "`%%endrep': no matching `%%rep'");
	    return 3;
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

	list->uplevel (defining->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);
	defining = NULL;
	free_tlist (origline);
	return 1;		       /* the expansion will line-sync */

      case PP_EXITREP:
	/*
	 * We must search along istk->expansion until we hit a
	 * macro-end marker for a macro with no name. Then we set
	 * its `in_progress' flag to 0.
	 */
	for (l = istk->expansion; l; l = l->next)
	    if (l->finishes && !l->finishes->name)
		break;

	if (l->finishes && !l->finishes->name)
	    l->finishes->in_progress = 0;
	else
	    error (ERR_NONFATAL, "`%%exitrep' not within `%%rep' block");
	free_tlist (origline);
	return 1;		       /* the end marker will line-sync */

      case PP_DEFINE:
      case PP_IDEFINE:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || (tline->type != TOK_ID &&
		       (tline->type != TOK_PREPROC_ID ||
			tline->text[1] != '$'))) {
	    error (ERR_NONFATAL|ERR_OFFBY1,
		   "`%%%sdefine' expects a macro identifier",
		   (i == PP_IDEFINE ? "i" : ""));
	    free_tlist (origline);
	    return 3;
	}
	mname = tline->text;
	if (tline->type == TOK_ID) {
	    p = tline->text;
	    smhead = &smacros[hash(mname)];
	} else {
	    ctx = get_ctx (tline->text);
	    if (ctx == NULL)
		return 3;
	    else {
		p = tline->text+1;
		p += strspn(p, "$");
		smhead = &ctx->localmac;
	    }
	}
	last = tline;
	param_start = tline = tline->next;
	nparam = 0;
	if (tline && tline->type == TOK_OTHER && !strcmp(tline->text, "(")) {
	    /*
	     * This macro has parameters.
	     */

	    tline = tline->next;
	    while (1) {
		if (tline && tline->type == TOK_WHITESPACE)
		    tline = tline->next;
		if (!tline) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "parameter identifier expected");
		    free_tlist (origline);
		    return 3;
		}
		if (tline->type != TOK_ID) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "`%s': parameter identifier expected",
			   tline->text);
		    free_tlist (origline);
		    return 3;
		}
		tline->type = TOK_SMAC_PARAM + nparam++;
		tline = tline->next;
		if (tline && tline->type == TOK_WHITESPACE)
		    tline = tline->next;
		if (tline && tline->type == TOK_OTHER &&
		    !strcmp(tline->text, ",")) {
		    tline = tline->next;
		    continue;
		}
		if (!tline || tline->type != TOK_OTHER ||
		    strcmp(tline->text, ")")) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "`)' expected to terminate macro template");
		    free_tlist (origline);
		    return 3;
		}
		break;
	    }
	    last = tline;
	    tline = tline->next;
	}
	if (tline && tline->type == TOK_WHITESPACE)
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
	if (smacro_defined (mname, nparam, &smac)) {
	    if (!smac)
		error (ERR_WARNING|ERR_OFFBY1,
		       "single-line macro `%s' defined both with and"
		       " without parameters", mname);
	    else {
		/*
		 * We're redefining, so we have to take over an
		 * existing SMacro structure. This means freeing
		 * what was already in it.
		 */
		nasm_free (smac->name);
		free_tlist (smac->expansion);
	    }
	} else {
	    smac = nasm_malloc(sizeof(SMacro));
	    smac->next = *smhead;
	    *smhead = smac;
	}
	smac->name = nasm_strdup(p);
	smac->casesense = (i == PP_DEFINE);
	smac->nparam = nparam;
	smac->expansion = macro_start;
	smac->in_progress = FALSE;
	free_tlist (origline);
	return 3;

      case PP_ASSIGN:
      case PP_IASSIGN:
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || (tline->type != TOK_ID &&
		       (tline->type != TOK_PREPROC_ID ||
			tline->text[1] != '$'))) {
	    error (ERR_NONFATAL|ERR_OFFBY1,
		   "`%%%sassign' expects a macro identifier",
		   (i == PP_IASSIGN ? "i" : ""));
	    free_tlist (origline);
	    return 3;
	}
	mname = tline->text;
	if (tline->type == TOK_ID) {
	    p = tline->text;
	    smhead = &smacros[hash(mname)];
	} else {
	    ctx = get_ctx (tline->text);
	    if (ctx == NULL) {
		free_tlist (origline);
		return 3;
	    } else {
		p = tline->text+1;
		p += strspn(p, "$");
		smhead = &ctx->localmac;
	    }
	}
	last = tline;
	tline = tline->next;
	last->next = NULL;

	tline = expand_smacro (tline);
	t = tline;
	tptr = &t;
	tokval.t_type = TOKEN_INVALID;
	evalresult = evaluate (ppscan, tptr, &tokval, NULL, pass, error, NULL);
	free_tlist (tline);
	if (!evalresult) {
	    free_tlist (origline);
	    return 3;
	}

	if (tokval.t_type)
	    error(ERR_WARNING|ERR_OFFBY1,
		  "trailing garbage after expression ignored");

	if (!is_simple(evalresult)) {
	    error(ERR_NONFATAL|ERR_OFFBY1,
		  "non-constant value given to `%%%sassign'",
		  (i == PP_IASSIGN ? "i" : ""));
	    free_tlist (origline);
	    return 3;
	}

	macro_start = nasm_malloc(sizeof(*macro_start));
	macro_start->next = NULL;
	{
	    char numbuf[20];
	    sprintf(numbuf, "%ld", reloc_value(evalresult));
	    macro_start->text = nasm_strdup(numbuf);
	}
	macro_start->mac = NULL;
	macro_start->type = TOK_NUMBER;

	/*
	 * We now have a macro name, an implicit parameter count of
	 * zero, and a numeric token to use as an expansion. Create
	 * and store an SMacro.
	 */
	if (smacro_defined (mname, 0, &smac)) {
	    if (!smac)
		error (ERR_WARNING|ERR_OFFBY1,
		       "single-line macro `%s' defined both with and"
		       " without parameters", mname);
	    else {
		/*
		 * We're redefining, so we have to take over an
		 * existing SMacro structure. This means freeing
		 * what was already in it.
		 */
		nasm_free (smac->name);
		free_tlist (smac->expansion);
	    }
	} else {
	    smac = nasm_malloc(sizeof(SMacro));
	    smac->next = *smhead;
	    *smhead = smac;
	}
	smac->name = nasm_strdup(p);
	smac->casesense = (i == PP_ASSIGN);
	smac->nparam = 0;
	smac->expansion = macro_start;
	smac->in_progress = FALSE;
	free_tlist (origline);
	return 3;

      case PP_LINE:
	/*
	 * Syntax is `%line nnn[+mmm] [filename]'
	 */
	tline = tline->next;
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	if (!tline || tline->type != TOK_NUMBER) {
	    error (ERR_NONFATAL|ERR_OFFBY1, "`%%line' expects line number");
	    free_tlist (origline);
	    return 3;
	}
	k = readnum(tline->text, &j);
	m = 1;
	tline = tline->next;
	if (tline && tline->type == TOK_OTHER && !strcmp(tline->text, "+")) {
	    tline = tline->next;
	    if (!tline || tline->type != TOK_NUMBER) {
		error (ERR_NONFATAL|ERR_OFFBY1,
		       "`%%line' expects line increment");
		free_tlist (origline);
		return 3;
	    }
	    m = readnum(tline->text, &j);
	    tline = tline->next;
	}
	if (tline && tline->type == TOK_WHITESPACE)
	    tline = tline->next;
	istk->lineno = k;
	istk->lineinc = m;
	update_fileline(3);	       /* update __FILE__ and __LINE__ */
	if (tline) {
	    char *s = detoken(tline);
	    nasm_free (istk->fname);
	    istk->fname = s;
	}
	free_tlist (origline);
	return 5;

      default:
	error(ERR_FATAL|ERR_OFFBY1,
	      "preprocessor directive `%s' not yet implemented",
	      directives[i]);
	break;
    }
    return 3;
}

/*
 * Ensure that a macro parameter contains a condition code and
 * nothing else. Return the condition code index if so, or -1
 * otherwise.
 */
static int find_cc (Token *t) {
    Token *tt;
    int i, j, k, m;

    if (t && t->type == TOK_WHITESPACE)
	t = t->next;
    if (t->type != TOK_ID)
	return -1;
    tt = t->next;
    if (tt && tt->type == TOK_WHITESPACE)
	tt = tt->next;
    if (tt && (tt->type != TOK_OTHER || strcmp(tt->text, ",")))
	return -1;

    i = -1;
    j = sizeof(conditions)/sizeof(*conditions);
    while (j-i > 1) {
	k = (j+i) / 2;
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
static Token *expand_mmac_params (Token *tline) {
    Token *t, *tt, *ttt, **tail, *thead;

    tail = &thead;
    thead = NULL;

    while (tline) {
	if (tline->type == TOK_PREPROC_ID &&
	    (tline->text[1] == '+' || tline->text[1] == '-' ||
	     tline->text[1] == '%' ||
	     (tline->text[1] >= '0' && tline->text[1] <= '9'))) {
	    char *text = NULL;
	    int type = 0, cc;	       /* type = 0 to placate optimisers */
	    char tmpbuf[30];
	    int n, i;
	    MMacro *mac;

	    t = tline;
	    tline = tline->next;

	    mac = istk->mstk;
	    while (mac && !mac->name)  /* avoid mistaking %reps for macros */
		mac = mac->next_active;
	    if (!mac)
		error(ERR_NONFATAL, "`%s': not in a macro call", t->text);
	    else switch (t->text[1]) {
		/*
		 * We have to make a substitution of one of the
		 * forms %1, %-1, %+1, %%foo, %0.
		 */
	      case '0':
		type = TOK_NUMBER;
		sprintf(tmpbuf, "%d", mac->nparam);
		text = nasm_strdup(tmpbuf);
		break;
	      case '%':
		type = TOK_ID;
		sprintf(tmpbuf, "..@%lu.", mac->unique);
		text = nasm_malloc(strlen(tmpbuf)+strlen(t->text+2)+1);
		strcpy(text, tmpbuf);
		strcat(text, t->text+2);
		break;
	      case '-':
		n = atoi(t->text+2)-1;
		if (n >= mac->nparam)
		    tt = NULL;
		else {
		    if (mac->nparam > 1)
			n = (n + mac->rotate) % mac->nparam;
		    tt = mac->params[n];
		}
		cc = find_cc (tt);
		if (cc == -1) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "macro parameter %d is not a condition code",
			   n+1);
		    text = NULL;
		} else {
		    type = TOK_ID;
		    if (inverse_ccs[cc] == -1) {
			error (ERR_NONFATAL|ERR_OFFBY1,
			       "condition code `%s' is not invertible",
			       conditions[cc]);
			text = NULL;
		    } else
			text = nasm_strdup(conditions[inverse_ccs[cc]]);
		}
		break;
	      case '+':
		n = atoi(t->text+2)-1;
		if (n >= mac->nparam)
		    tt = NULL;
		else {
		    if (mac->nparam > 1)
			n = (n + mac->rotate) % mac->nparam;
		    tt = mac->params[n];
		}
		cc = find_cc (tt);
		if (cc == -1) {
		    error (ERR_NONFATAL|ERR_OFFBY1,
			   "macro parameter %d is not a condition code",
			   n+1);
		    text = NULL;
		} else {
		    type = TOK_ID;
		    text = nasm_strdup(conditions[cc]);
		}
		break;
	      default:
		n = atoi(t->text+1)-1;
		if (n >= mac->nparam)
		    tt = NULL;
		else {
		    if (mac->nparam > 1)
			n = (n + mac->rotate) % mac->nparam;
		    tt = mac->params[n];
		}
		if (tt) {
		    for (i=0; i<mac->paramlen[n]; i++) {
			ttt = *tail = nasm_malloc(sizeof(Token));
			ttt->next = NULL;
			tail = &ttt->next;
			ttt->type = tt->type;
			ttt->text = nasm_strdup(tt->text);
			ttt->mac = NULL;
			tt = tt->next;
		    }
		}
		text = NULL;       /* we've done it here */
		break;
	    }
	    nasm_free (t->text);
	    nasm_free (t);
	    if (text) {
		t = *tail = nasm_malloc(sizeof(Token));
		t->next = NULL;
		tail = &t->next;
		t->type = type;
		t->text = text;
		t->mac = NULL;
	    }
	    continue;
	} else {
	    t = *tail = tline;
	    tline = tline->next;
	    t->mac = NULL;
	    t->next = NULL;
	    tail = &t->next;
	}
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
static Token *expand_smacro (Token *tline) {
    Token *t, *tt, *mstart, **tail, *thead;
    SMacro *head, *m;
    Token **params;
    int *paramsize;
    int nparam, sparam, brackets;
    char *p;

    tail = &thead;
    thead = NULL;

    while (tline) {
	while (tline && tline->type != TOK_ID &&
	       (tline->type != TOK_PREPROC_ID || tline->text[1] != '$')) {
	    if (tline->type == TOK_SMAC_END) {
		tline->mac->in_progress = FALSE;
		t = tline;
		tline = tline->next;
		nasm_free (t);
	    } else {
		t = *tail = tline;
		tline = tline->next;
		t->mac = NULL;
		t->next = NULL;
		tail = &t->next;
		if (t->type == TOK_PS_OTHER) {
		    /*
		     * If we see a PS_OTHER, we must at the very
		     * least restore its correct token type. We
		     * should also check for a %$ token, since this
		     * is the point at which we expand context-
		     * local labels.
		     */
		    t->type = TOK_ID;
		    if (t->text[0] == '%' && t->text[1] == '$') {
			Context *c = get_ctx (t->text);
			char *p, *q, buffer[40];

			if (c) {
			    q = t->text+1;
			    q += strspn(q, "$");
			    sprintf(buffer, "..@%lu.", c->number);
			    p = nasm_malloc (strlen(buffer)+strlen(q)+1);
			    strcpy (p, buffer);
			    strcat (p, q);
			    nasm_free (t->text);
			    t->text = p;
			}
		    }
		}
	    }
	}

	if (!tline)
	    break;
	/*
	 * We've hit an identifier. As in is_mmacro below, we first
	 * check whether the identifier is a single-line macro at
	 * all, then think about checking for parameters if
	 * necessary.
	 */
	if (tline->type == TOK_ID) {
	    head = smacros[hash(tline->text)];
	    p = tline->text;
	} else {
	    Context *ctx = get_ctx (tline->text);
	    if (ctx) {
		p = tline->text+1;
		p += strspn(p, "$");
		head = ctx->localmac;
	    } else {
		tline->type = TOK_OTHER; /* so it will get copied above */
		continue;		
	    }
	}
	for (m = head; m; m = m->next)
	    if (!mstrcmp(m->name, p, m->casesense))
		break;
	if (!m || m->in_progress) {
	    /*
	     * Either we didn't find a macro, so this can't be a
	     * macro call, or we found a macro which was already in
	     * progress, in which case we don't _treat_ this as a
	     * macro call. Copy it through and ignore it.
	     */
	    tline->type = TOK_PS_OTHER;   /* so it will get copied above */
	    continue;
	}
	mstart = tline;
	if (m->nparam == 0) {
	    /*
	     * Simple case: the macro is parameterless. Discard the
	     * one token that the macro call took, and push the
	     * expansion back on the to-do stack.
	     */
	    params = NULL;
	    paramsize = NULL;
	} else {
	    /*
	     * Complicated case: at least one macro with this name
	     * exists and takes parameters. We must find the
	     * parameters in the call, count them, find the SMacro
	     * that corresponds to that form of the macro call, and
	     * substitute for the parameters when we expand. What a
	     * pain.
	     */
	    nparam = sparam = 0;
	    params = NULL;
	    paramsize = NULL;
	    tline = tline->next;
	    if (tline && tline->type == TOK_WHITESPACE)
		tline = tline->next;
	    if (!tline || tline->type != TOK_OTHER ||
		strcmp(tline->text, "(")) {
		/*
		 * This macro wasn't called with parameters: ignore
		 * the call. (Behaviour borrowed from gnu cpp.)
		 */
		tline = mstart;
		tline->type = TOK_PS_OTHER;
		continue;
	    }
	    tline = tline->next;
	    while (1) {
		if (tline && tline->type == TOK_WHITESPACE)
		    tline = tline->next;
		if (!tline) {
		    error(ERR_NONFATAL|ERR_OFFBY1,
			  "macro call expects terminating `)'");
		    break;
		}
		if (nparam >= sparam) {
		    sparam += PARAM_DELTA;
		    params = nasm_realloc (params, sparam*sizeof(Token *));
		    paramsize = nasm_realloc (paramsize, sparam*sizeof(int));
		}
		params[nparam] = tline;
		paramsize[nparam] = 0;
		brackets = 0;
		if (tline && tline->type == TOK_OTHER &&
		    !strcmp(tline->text, "{")) {
		    params[nparam] = tline = tline->next;
		    while (tline && (brackets > 0 ||
				     tline->type != TOK_OTHER ||
				     strcmp(tline->text, "}"))) {
			tline = tline->next;
			paramsize[nparam]++;
		    }
		    tline = tline->next;
		    if (tline && tline->type == TOK_WHITESPACE)
			tline = tline->next;
		    if (tline && (tline->type != TOK_OTHER ||
				  (strcmp(tline->text, ")") &&
				   strcmp(tline->text, ",")))) {
			error (ERR_NONFATAL|ERR_OFFBY1, "braces do not "
			       "enclose all of macro parameter");
		    }
		    if (tline && tline->type == TOK_OTHER &&
			!strcmp(tline->text, ","))
			tline = tline->next;
		} else {
		    while (tline && (brackets > 0 ||
				     tline->type != TOK_OTHER ||
				     (strcmp(tline->text, ",") &&
				      strcmp(tline->text, ")")))) {
			if (tline->type == TOK_OTHER && !tline->text[1])
			    brackets += (tline->text[0] == '(' ? 1 :
					 tline->text[0] == ')' ? -1 : 0);
			tline = tline->next;
			paramsize[nparam]++;
		    }
		}
		nparam++;
		if (tline && !strcmp(tline->text, ")"))
		    break;
		if (tline && !strcmp(tline->text, ","))
		    tline = tline->next;
	    }
	    while (m && m->nparam != nparam) {
		while ( (m = m->next) )
		    if (!strcmp(m->name, mstart->text))
			break;
	    }
	    if (!m) {
		error (ERR_WARNING|ERR_OFFBY1|ERR_WARN_MNP,
		       "macro `%s' exists, but not taking %d parameters",
		       mstart->text, nparam);
		nasm_free (params);
		nasm_free (paramsize);
		tline = mstart;
		tline->type = TOK_PS_OTHER;
		continue;
	    }
	}
	/*
	 * Expand the macro: we are placed on the last token of the
	 * call, so that we can easily split the call from the
	 * following tokens. We also start by pushing an SMAC_END
	 * token for the cycle removal.
	 */
	t = tline;
	tline = tline->next;
	t->next = NULL;
	tt = nasm_malloc(sizeof(Token));
	tt->type = TOK_SMAC_END;
	tt->text = NULL;
	tt->mac = m;
	m->in_progress = TRUE;
	tt->next = tline;
	tline = tt;
	for (t = m->expansion; t; t = t->next) {
	    if (t->type >= TOK_SMAC_PARAM) {
		Token *pcopy = tline, **ptail = &pcopy;
		Token *ttt, *pt;
		int i;
		
		ttt = params[t->type - TOK_SMAC_PARAM];
		for (i=0; i<paramsize[t->type-TOK_SMAC_PARAM]; i++) {
		    pt = *ptail = nasm_malloc(sizeof(Token));
		    pt->next = tline;
		    ptail = &pt->next;
		    pt->text = nasm_strdup(ttt->text);
		    pt->type = ttt->type;
		    pt->mac = NULL;
		    ttt = ttt->next;
		}
		tline = pcopy;
	    } else {
		tt = nasm_malloc(sizeof(Token));
		tt->type = t->type;
		tt->text = nasm_strdup(t->text);
		tt->mac = NULL;
		tt->next = tline;
		tline = tt;
	    }
	}

	/*
	 * Having done that, get rid of the macro call, and clean
	 * up the parameters.
	 */
	nasm_free (params);
	nasm_free (paramsize);
	free_tlist (mstart);
    }

    return thead;
}

/*
 * Determine whether the given line constitutes a multi-line macro
 * call, and return the MMacro structure called if so. Doesn't have
 * to check for an initial label - that's taken care of in
 * expand_mmacro - but must check numbers of parameters. Guaranteed
 * to be called with tline->type == TOK_ID, so the putative macro
 * name is easy to find.
 */
static MMacro *is_mmacro (Token *tline, Token ***params_array) {
    MMacro *head, *m;
    Token **params;
    int nparam;

    head = mmacros[hash(tline->text)];

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
    count_mmac_params (tline->next, &nparam, &params);

    /*
     * So we know how many parameters we've got. Find the MMacro
     * structure that handles this number.
     */
    while (m) {
	if (m->nparam_min <= nparam && (m->plus || nparam <= m->nparam_max)) {
	    /*
	     * This one is right. Just check if cycle removal
	     * prohibits us using it before we actually celebrate...
	     */
	    if (m->in_progress) {
		error (ERR_NONFATAL|ERR_OFFBY1,
		       "self-reference in multi-line macro `%s'",
		       m->name);
		nasm_free (params);
		return NULL;
	    }
	    /*
	     * It's right, and we can use it. Add its default
	     * parameters to the end of our list if necessary.
	     */
	    if (m->defaults && nparam < m->nparam_min + m->ndefs) {
		params = nasm_realloc (params, ((m->nparam_min+m->ndefs+1) *
						sizeof(*params)));
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
	    if (!params) {	       /* need this special case */
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
    error (ERR_WARNING|ERR_OFFBY1|ERR_WARN_MNP,
	   "macro `%s' exists, but not taking %d parameters",
	   tline->text, nparam);
    nasm_free (params);
    return NULL;
}

/*
 * Expand the multi-line macro call made by the given line, if
 * there is one to be expanded. If there is, push the expansion on
 * istk->expansion and return 1 or 2, as according to whether a
 * line sync is needed (2 if it is). Otherwise return 0.
 */
static int expand_mmacro (Token *tline) {
    Token *label = NULL, **params, *t, *tt, *last = NULL;
    MMacro *m = NULL;
    Line *l, *ll;
    int i, nparam, *paramlen;
    int need_sync = FALSE;

    t = tline;
    if (t && t->type == TOK_WHITESPACE)
	t = t->next;
    if (t && t->type == TOK_ID) {
	m = is_mmacro (t, &params);
	if (!m) {
	    /*
	     * We have an id which isn't a macro call. We'll assume
	     * it might be a label; we'll also check to see if a
	     * colon follows it. Then, if there's another id after
	     * that lot, we'll check it again for macro-hood.
	     */
	    last = t, t = t->next;
	    if (t && t->type == TOK_WHITESPACE)
		last = t, t = t->next;
	    if (t && t->type == TOK_OTHER && !strcmp(t->text, ":"))
		last = t, t = t->next;
	    if (t && t->type == TOK_WHITESPACE)
		last = t, t = t->next;
	    if (t && t->type == TOK_ID) {
		m = is_mmacro(t, &params);
		if (m) {
		    last->next = NULL;
		    label = tline;
		    tline = t;
		}
	    }
	}	
    }
    if (!m)
	return 0;

    /*
     * If we're not already inside another macro expansion, we'd
     * better push a line synchronisation to ensure we stay put on
     * line numbering.
     */
    if (!istk->expansion)
	need_sync = TRUE;

    /*
     * Fix up the parameters: this involves stripping leading and
     * trailing whitespace, then stripping braces if they are
     * present.
     */
    for (nparam = 0; params[nparam]; nparam++);
    paramlen = nparam ? nasm_malloc(nparam*sizeof(*paramlen)) : NULL;

    for (i = 0; params[i]; i++) {
	int brace = FALSE;
	int comma = (!m->plus || i < nparam-1);

	t = params[i];
	if (t && t->type == TOK_WHITESPACE)
	    t = t->next;
	if (t && t->type == TOK_OTHER && !strcmp(t->text, "{"))
	    t = t->next, brace = TRUE, comma = FALSE;
	params[i] = t;
	paramlen[i] = 0;
	while (t) {
	    if (!t)		       /* end of param because EOL */
		break;
	    if (comma && t->type == TOK_OTHER && !strcmp(t->text, ","))
		break;		       /* ... because we have hit a comma */
	    if (comma && t->type == TOK_WHITESPACE &&
		t->next->type == TOK_OTHER && !strcmp(t->next->text, ","))
		break;		       /* ... or a space then a comma */
	    if (brace && t->type == TOK_OTHER && !strcmp(t->text, "}"))
		break;		       /* ... or a brace */
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

    m->in_progress = TRUE;
    m->params = params;
    m->iline = tline;
    m->nparam = nparam;
    m->rotate = 0;
    m->paramlen = paramlen;
    m->unique = unique++;

    m->next_active = istk->mstk;
    istk->mstk = m;

    for (l = m->expansion; l; l = l->next) {
	Token **tail;

	ll = nasm_malloc(sizeof(Line));
	ll->next = istk->expansion;
	ll->finishes = NULL;
	ll->first = NULL;
	tail = &ll->first;

	for (t = l->first; t; t = t->next) {
	    tt = *tail = nasm_malloc(sizeof(Token));
	    tt->next = NULL;
	    tail = &tt->next;
	    tt->type = t->type;
	    tt->text = nasm_strdup(t->text);
	    tt->mac = NULL;
	}

	istk->expansion = ll;

    }

    /*
     * If we had a label, push it on the front of the first line of
     * the macro expansion. We must check that this doesn't give
     * two consecutive TOK_WHITESPACE.
     */
    if (label) {
	if (last->type == TOK_WHITESPACE &&
	    istk->expansion->first->type == TOK_WHITESPACE) {
	    Token *victim = istk->expansion->first; /* kill this whitespace */
	    istk->expansion->first = victim->next;
	    nasm_free (victim->text);
	    nasm_free (victim);
	}
	last->next = istk->expansion->first;
	istk->expansion->first = label;
    }

    list->uplevel (m->nolist ? LIST_MACRO_NOLIST : LIST_MACRO);

    return need_sync ? 2 : 1;
}

static void pp_reset (char *file, int apass, efunc errfunc, evalfunc eval,
		      ListGen *listgen) {
    int h;

    error = errfunc;
    cstk = NULL;
    linesync = outline = NULL;
    istk = nasm_malloc(sizeof(Include));
    istk->next = NULL;
    istk->conds = NULL;
    istk->expansion = NULL;
    istk->mstk = NULL;
    istk->fp = fopen(file, "r");
    istk->fname = nasm_strdup(file);
    istk->lineno = istk->lineinc = 1;
    if (!istk->fp)
	error (ERR_FATAL|ERR_NOFILE, "unable to open input file `%s'", file);
    defining = NULL;
    for (h=0; h<NHASH; h++) {
	mmacros[h] = NULL;
	smacros[h] = NULL;
    }
    unique = 0;
    stdmacpos = stdmac;
    any_extrastdmac = (extrastdmac != NULL);
    list = listgen;
    evaluate = eval;
    pass = apass;
}

static char *pp_getline (void) {
    char *line;
    Token *tline;
    int ret;

    if (outline) {
	line = outline;
	outline = NULL;
	return line;
    }

    while (1) {
	/*
	 * Fetch a tokenised line, either from the macro-expansion
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
			if (t->text) {
			    tt = *tail = nasm_malloc(sizeof(Token));
			    tt->next = NULL;
			    tail = &tt->next;
			    tt->type = t->type;
			    tt->text = nasm_strdup(t->text);
			    tt->mac = NULL;
			}
		    }

		    istk->expansion = ll;
		}
		line_sync();
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
			error (ERR_PANIC,
			       "defining with name in expansion");
		    else if (!istk->mstk->name)
			error (ERR_PANIC, "istk->mstk has no name but"
			       " defining is set at end of expansion");
		    else
			error (ERR_FATAL, "`%%rep' without `%%endrep' within"
			       " expansion of macro `%s'", istk->mstk->name);
		}

		if (istk->mstk->name) {
		    /*
		     * This was a real macro call, not a %rep, and
		     * therefore the parameter information needs to
		     * be freed.
		     */
		    nasm_free(istk->mstk->params);
		    free_tlist(istk->mstk->iline);
		    nasm_free(istk->mstk->paramlen);
		}
		istk->mstk = istk->mstk->next_active;
		l->finishes->in_progress = FALSE;
		istk->expansion = l->next;
		nasm_free (l);
		list->downlevel (LIST_MACRO);
		if (!istk->expansion)
		    line_sync();
	    }
	}
	if (istk->expansion) {
	    char *p;
	    Line *l = istk->expansion;
	    tline = l->first;
	    istk->expansion = l->next;
	    nasm_free (l);
	    p = detoken(tline);
	    list->line (LIST_MACRO, p);
	    nasm_free(p);
	    if (!istk->expansion)
		line_sync();
	} else {
	    line = read_line();
	    while (!line) {
		/*
		 * The current file has ended; work down the istk
		 * until we find a file we can read from.
		 */
		Include *i;
		fclose(istk->fp);
		if (istk->conds)
		    error(ERR_FATAL, "expected `%%endif' before end of file");
		i = istk;
		istk = istk->next;
		list->downlevel (LIST_INCLUDE);
		nasm_free (i->fname);
		nasm_free (i);
		if (!istk)
		    return NULL;
		else
		    line_sync();
		update_fileline(3);    /* update __FILE__ and __LINE__ */
		line = read_line();
	    }
	    line = prepreproc(line);
	    tline = tokenise(line);
	    nasm_free (line);
	}

	/*
	 * We must expand MMacro parameters and MMacro-local labels
	 * _before_ we plunge into directive processing, to cope
	 * with things like `%define something %1' such as STRUC
	 * uses. Unless we're _defining_ a MMacro, in which case
	 * those tokens should be left alone to go into the
	 * definition.
	 */
	if (!defining)
	    tline = expand_mmac_params(tline);

	/*
	 * Check the line to see if it's a preprocessor directive.
	 */
	ret = do_directive(tline);
	if (ret & 1) {
	    if (ret & 4)
		line_sync();
	    if ((ret & 2) && !stdmacpos) {/* give a blank line to the output */
		outline = nasm_strdup("");
		break;
	    }
	    else
		continue;
	} else if (defining) {
	    /*
	     * We're defining a multi-line macro. We emit nothing
	     * at all, not even a blank line (when we finish
	     * defining the macro, we'll emit a line-number
	     * directive so that we keep sync properly), and just
	     * shove the tokenised line on to the macro definition.
	     */
	    Line *l = nasm_malloc(sizeof(Line));
	    l->next = defining->expansion;
	    l->first = tline;
	    l->finishes = FALSE;
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
	    ret = expand_mmacro(tline);
	    if (!ret) {
		/*
		 * De-tokenise the line again, and emit it.
		 */
		line = detoken(tline);
		free_tlist (tline);
		outline = line;
		break;
	    } else {
		if (ret == 2)
		    line_sync();
		continue;	       /* expand_mmacro calls free_tlist */
	    }
	}
    }

    /*
     * Once we're out of this loop, outline _must_ be non-NULL. The
     * only question is whether linesync is NULL or not.
     */
    if (linesync) {
	line = linesync;
	linesync = NULL;
    } else {
	line = outline;
	outline = NULL;
    }
    return line;
}

static void pp_cleanup (void) {
    int h;

    if (defining) {
	error (ERR_NONFATAL, "end of file while still defining macro `%s'",
	       defining->name);
	nasm_free (defining->name);
	free_tlist (defining->dlist);
	free_llist (defining->expansion);
	nasm_free (defining);
    }
    nasm_free (linesync);	       /* might just be necessary */
    nasm_free (outline);	       /* really shouldn't be necessary */
    while (cstk)
	ctx_pop();
    for (h=0; h<NHASH; h++) {
	while (mmacros[h]) {
	    MMacro *m = mmacros[h];
	    mmacros[h] = mmacros[h]->next;
	    nasm_free (m->name);
	    free_tlist (m->dlist);
	    nasm_free (m->defaults);
	    free_llist (m->expansion);
	    nasm_free (m);
	}
	while (smacros[h]) {
	    SMacro *s = smacros[h];
	    smacros[h] = smacros[h]->next;
	    nasm_free (s->name);
	    free_tlist (s->expansion);
	    nasm_free (s);
	}
    }
    while (istk) {
	Include *i = istk;
	istk = istk->next;
	fclose(i->fp);
	nasm_free (i->fname);
	nasm_free (i);
    }
    while (cstk)
	ctx_pop();
}

void pp_include_path (char *path) {
    IncPath *i;

    i = nasm_malloc(sizeof(IncPath));
    i->path = nasm_strdup(path);
    i->next = ipath;

    ipath = i;
}

void pp_pre_include (char *fname) {
    Token *inc, *space, *name;
    Line *l;

    inc = nasm_malloc(sizeof(Token));
    inc->next = space = nasm_malloc(sizeof(Token));
    space->next = name = nasm_malloc(sizeof(Token));
    name->next = NULL;

    inc->type = TOK_PREPROC_ID;
    inc->text = nasm_strdup("%include");
    space->type = TOK_WHITESPACE;
    space->text = nasm_strdup(" ");
    name->type = TOK_INTERNAL_STRING;
    name->text = nasm_strdup(fname);

    inc->mac = space->mac = name->mac = NULL;

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = inc;
    l->finishes = FALSE;
    predef = l;
}

void pp_pre_define (char *definition) {
    Token *def, *space, *name;
    Line *l;
    char *equals;

    equals = strchr(definition, '=');

    def = nasm_malloc(sizeof(Token));
    def->next = space = nasm_malloc(sizeof(Token));
    if (equals)
	*equals = ' ';
    space->next = name = tokenise(definition);
    if (equals)
	*equals = '=';

    def->type = TOK_PREPROC_ID;
    def->text = nasm_strdup("%define");
    space->type = TOK_WHITESPACE;
    space->text = nasm_strdup(" ");

    def->mac = space->mac = NULL;

    l = nasm_malloc(sizeof(Line));
    l->next = predef;
    l->first = def;
    l->finishes = FALSE;
    predef = l;
}

void pp_extra_stdmac (char **macros) {
    extrastdmac = macros;
}

Preproc nasmpp = {
    pp_reset,
    pp_getline,
    pp_cleanup
};
