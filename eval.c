/* eval.c    expression evaluator for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 27/iii/95 by Simon Tatham
 */

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <ctype.h>

#include "nasm.h"
#include "nasmlib.h"
#include "eval.h"
#include "labels.h"

#define TEMPEXPRS_DELTA 128
#define TEMPEXPR_DELTA 8

static scanner scan;	/* Address of scanner routine */
static efunc error;	/* Address of error reporting routine */
static lfunc labelfunc;	/* Address of label routine */

static struct ofmt *outfmt;  /* Structure of addresses of output routines */

static expr **tempexprs = NULL;
static int    ntempexprs;
static int    tempexprs_size = 0;

static expr  *tempexpr;
static int   ntempexpr;
static int   tempexpr_size;

static struct tokenval *tokval;	  /* The current token */
static int i;			  /* The t_type of tokval */

static void *scpriv;
static loc_t *location;		/* Pointer to current line's segment,offset */
static int *opflags;

static struct eval_hints *hint;

/*
 * Unimportant cleanup is done to avoid confusing people who are trying
 * to debug real memory leaks
 */
void eval_cleanup(void) 
{
    while (ntempexprs)
	nasm_free (tempexprs[--ntempexprs]);
    nasm_free (tempexprs);
}

/*
 * Construct a temporary expression.
 */
static void begintemp(void) 
{
    tempexpr = NULL;
    tempexpr_size = ntempexpr = 0;
}

static void addtotemp(long type, long value) 
{
    while (ntempexpr >= tempexpr_size) {
	tempexpr_size += TEMPEXPR_DELTA;
	tempexpr = nasm_realloc(tempexpr,
				 tempexpr_size*sizeof(*tempexpr));
    }
    tempexpr[ntempexpr].type = type;
    tempexpr[ntempexpr++].value = value;
}

static expr *finishtemp(void) 
{
    addtotemp (0L, 0L);		       /* terminate */
    while (ntempexprs >= tempexprs_size) {
	tempexprs_size += TEMPEXPRS_DELTA;
	tempexprs = nasm_realloc(tempexprs,
				 tempexprs_size*sizeof(*tempexprs));
    }
    return tempexprs[ntempexprs++] = tempexpr;
}

/*
 * Add two vector datatypes. We have some bizarre behaviour on far-
 * absolute segment types: we preserve them during addition _only_
 * if one of the segments is a truly pure scalar.
 */
static expr *add_vectors(expr *p, expr *q) 
{
    int preserve;

    preserve = is_really_simple(p) || is_really_simple(q);

    begintemp();

    while (p->type && q->type &&
	   p->type < EXPR_SEGBASE+SEG_ABS &&
	   q->type < EXPR_SEGBASE+SEG_ABS)
    {
	int lasttype;

    	if (p->type > q->type) {
	    addtotemp(q->type, q->value);
	    lasttype = q++->type;
	} else if (p->type < q->type) {
	    addtotemp(p->type, p->value);
	    lasttype = p++->type;
	} else {		       /* *p and *q have same type */
	    long sum = p->value + q->value;
	    if (sum)
		addtotemp(p->type, sum);
	    lasttype = p->type;
	    p++, q++;
	}
	if (lasttype == EXPR_UNKNOWN) {
	    return finishtemp();
	}
    }
    while (p->type &&
	   (preserve || p->type < EXPR_SEGBASE+SEG_ABS)) 
    {
	addtotemp(p->type, p->value);
	p++;
    }
    while (q->type &&
	   (preserve || q->type < EXPR_SEGBASE+SEG_ABS)) 
    {
	addtotemp(q->type, q->value);
	q++;
    }

    return finishtemp();
}

/*
 * Multiply a vector by a scalar. Strip far-absolute segment part
 * if present.
 *
 * Explicit treatment of UNKNOWN is not required in this routine,
 * since it will silently do the Right Thing anyway.
 *
 * If `affect_hints' is set, we also change the hint type to
 * NOTBASE if a MAKEBASE hint points at a register being
 * multiplied. This allows [eax*1+ebx] to hint EBX rather than EAX
 * as the base register.
 */
static expr *scalar_mult(expr *vect, long scalar, int affect_hints) 
{
    expr *p = vect;

    while (p->type && p->type < EXPR_SEGBASE+SEG_ABS) {
	p->value = scalar * (p->value);
	if (hint && hint->type == EAH_MAKEBASE &&
	    p->type == hint->base && affect_hints)
	    hint->type = EAH_NOTBASE;
	p++;
    }
    p->type = 0;

    return vect;
}

static expr *scalarvect (long scalar) 
{
    begintemp();
    addtotemp(EXPR_SIMPLE, scalar);
    return finishtemp();
}

static expr *unknown_expr (void) 
{
    begintemp();
    addtotemp(EXPR_UNKNOWN, 1L);
    return finishtemp();
}

/*
 * The SEG operator: calculate the segment part of a relocatable
 * value. Return NULL, as usual, if an error occurs. Report the
 * error too.
 */
static expr *segment_part (expr *e) 
{
    long seg;

    if (is_unknown(e))
	return unknown_expr();

    if (!is_reloc(e)) {
	error(ERR_NONFATAL, "cannot apply SEG to a non-relocatable value");
	return NULL;
    }

    seg = reloc_seg(e);
    if (seg == NO_SEG) {
	error(ERR_NONFATAL, "cannot apply SEG to a non-relocatable value");
	return NULL;
    } else if (seg & SEG_ABS) {
	return scalarvect(seg & ~SEG_ABS);
    } else if (seg & 1) {
	error(ERR_NONFATAL, "SEG applied to something which"
	      " is already a segment base");
	return NULL;
    }
    else {
	long base = outfmt->segbase(seg+1);

	begintemp();
	addtotemp((base == NO_SEG ? EXPR_UNKNOWN : EXPR_SEGBASE+base), 1L);
	return finishtemp();
    }
}

/*
 * Recursive-descent parser. Called with a single boolean operand,
 * which is TRUE if the evaluation is critical (i.e. unresolved
 * symbols are an error condition). Must update the global `i' to
 * reflect the token after the parsed string. May return NULL.
 *
 * evaluate() should report its own errors: on return it is assumed
 * that if NULL has been returned, the error has already been
 * reported.
 */

/*
 * Grammar parsed is:
 *
 * expr  : bexpr [ WRT expr6 ]
 * bexpr : rexp0 or expr0 depending on relative-mode setting
 * rexp0 : rexp1 [ {||} rexp1...]
 * rexp1 : rexp2 [ {^^} rexp2...]
 * rexp2 : rexp3 [ {&&} rexp3...]
 * rexp3 : expr0 [ {=,==,<>,!=,<,>,<=,>=} expr0 ]
 * expr0 : expr1 [ {|} expr1...]
 * expr1 : expr2 [ {^} expr2...]
 * expr2 : expr3 [ {&} expr3...]
 * expr3 : expr4 [ {<<,>>} expr4...]
 * expr4 : expr5 [ {+,-} expr5...]
 * expr5 : expr6 [ {*,/,%,//,%%} expr6...]
 * expr6 : { ~,+,-,SEG } expr6
 *       | (bexpr)
 *       | symbol
 *       | $
 *       | number
 */

static expr *rexp0(int), *rexp1(int), *rexp2(int), *rexp3(int);

static expr *expr0(int), *expr1(int), *expr2(int), *expr3(int);
static expr *expr4(int), *expr5(int), *expr6(int);

static expr *(*bexpr)(int);

static expr *rexp0(int critical) 
{
    expr *e, *f;

    e = rexp1(critical);
    if (!e)
	return NULL;

    while (i == TOKEN_DBL_OR) 
    {	
	i = scan(scpriv, tokval);
	f = rexp1(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`|' operator may only be applied to"
		  " scalar values");
	}

	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect ((long) (reloc_value(e) || reloc_value(f)));
    }
    return e;
}

static expr *rexp1(int critical) 
{
    expr *e, *f;

    e = rexp2(critical);
    if (!e)
	return NULL;
    
    while (i == TOKEN_DBL_XOR) 
    {
	i = scan(scpriv, tokval);
	f = rexp2(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`^' operator may only be applied to"
		  " scalar values");
	}

	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect ((long) (!reloc_value(e) ^ !reloc_value(f)));
    }
    return e;
}

static expr *rexp2(int critical) 
{
    expr *e, *f;

    e = rexp3(critical);
    if (!e)
	return NULL;
    while (i == TOKEN_DBL_AND) 
    {
	i = scan(scpriv, tokval);
	f = rexp3(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`&' operator may only be applied to"
		  " scalar values");
	}
	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect ((long) (reloc_value(e) && reloc_value(f)));
    }
    return e;
}

static expr *rexp3(int critical) 
{
    expr *e, *f;
    long v;

    e = expr0(critical);
    if (!e)
	return NULL;

    while (i == TOKEN_EQ || i == TOKEN_LT || i == TOKEN_GT ||
	   i == TOKEN_NE || i == TOKEN_LE || i == TOKEN_GE) 
    {
	int j = i;
	i = scan(scpriv, tokval);
	f = expr0(critical);
	if (!f)
	    return NULL;

	e = add_vectors (e, scalar_mult(f, -1L, FALSE));

	switch (j) 
	{
	  case TOKEN_EQ: case TOKEN_NE:
	    if (is_unknown(e))
		v = -1;		       /* means unknown */
	    else if (!is_really_simple(e) || reloc_value(e) != 0)
		v = (j == TOKEN_NE);   /* unequal, so return TRUE if NE */
	    else
		v = (j == TOKEN_EQ);   /* equal, so return TRUE if EQ */
	    break;
	  default:
	    if (is_unknown(e))
		v = -1;		       /* means unknown */
	    else if (!is_really_simple(e)) {
		error(ERR_NONFATAL, "`%s': operands differ by a non-scalar",
		      (j == TOKEN_LE ? "<=" : j == TOKEN_LT ? "<" :
		       j == TOKEN_GE ? ">=" : ">"));
		v = 0;		       /* must set it to _something_ */
	    } else {
		int vv = reloc_value(e);
		if (vv == 0)
		    v = (j == TOKEN_LE || j == TOKEN_GE);
		else if (vv > 0)
		    v = (j == TOKEN_GE || j == TOKEN_GT);
		else /* vv < 0 */
		    v = (j == TOKEN_LE || j == TOKEN_LT);
	    }
	    break;
	}

	if (v == -1)
	    e = unknown_expr();
	else
	    e = scalarvect(v);
    }
    return e;
}

static expr *expr0(int critical) 
{
    expr *e, *f;

    e = expr1(critical);
    if (!e)
	return NULL;

    while (i == '|') 
    {
	i = scan(scpriv, tokval);
	f = expr1(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`|' operator may only be applied to"
		  " scalar values");
	}
	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect (reloc_value(e) | reloc_value(f));
    }
    return e;
}

static expr *expr1(int critical) 
{
    expr *e, *f;

    e = expr2(critical);
    if (!e)
	return NULL;

    while (i == '^') {
	i = scan(scpriv, tokval);
	f = expr2(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`^' operator may only be applied to"
		  " scalar values");
	}
	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect (reloc_value(e) ^ reloc_value(f));
    }
    return e;
}

static expr *expr2(int critical) 
{
    expr *e, *f;

    e = expr3(critical);
    if (!e)
	return NULL;

    while (i == '&') {
	i = scan(scpriv, tokval);
	f = expr3(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "`&' operator may only be applied to"
		  " scalar values");
	}
	if (is_just_unknown(e) || is_just_unknown(f))
	    e = unknown_expr();
	else
	    e = scalarvect (reloc_value(e) & reloc_value(f));
    }
    return e;
}

static expr *expr3(int critical) 
{
    expr *e, *f;

    e = expr4(critical);
    if (!e)
	return NULL;

    while (i == TOKEN_SHL || i == TOKEN_SHR) 
    {
	int j = i;
	i = scan(scpriv, tokval);
	f = expr4(critical);
	if (!f)
	    return NULL;
	if (!(is_simple(e) || is_just_unknown(e)) ||
	    !(is_simple(f) || is_just_unknown(f))) 
	{
	    error(ERR_NONFATAL, "shift operator may only be applied to"
		  " scalar values");
	} else if (is_just_unknown(e) || is_just_unknown(f)) {
	    e = unknown_expr();
	} else switch (j) {
	  case TOKEN_SHL:
	    e = scalarvect (reloc_value(e) << reloc_value(f));
	    break;
	  case TOKEN_SHR:
	    e = scalarvect (((unsigned long)reloc_value(e)) >>
			    reloc_value(f));
	    break;
	}
    }
    return e;
}

static expr *expr4(int critical) 
{
    expr *e, *f;

    e = expr5(critical);
    if (!e)
	return NULL;
    while (i == '+' || i == '-') 
    {
	int j = i;
	i = scan(scpriv, tokval);
	f = expr5(critical);
	if (!f)
	    return NULL;
	switch (j) {
	  case '+':
	    e = add_vectors (e, f);
	    break;
	  case '-':
	    e = add_vectors (e, scalar_mult(f, -1L, FALSE));
	    break;
	}
    }
    return e;
}

static expr *expr5(int critical) 
{
    expr *e, *f;

    e = expr6(critical);
    if (!e)
	return NULL;
    while (i == '*' || i == '/' || i == '%' ||
	   i == TOKEN_SDIV || i == TOKEN_SMOD) 
    {
	int j = i;
	i = scan(scpriv, tokval);
	f = expr6(critical);
	if (!f)
	    return NULL;
	if (j != '*' && (!(is_simple(e) || is_just_unknown(e)) ||
			 !(is_simple(f) || is_just_unknown(f)))) 
	{
	    error(ERR_NONFATAL, "division operator may only be applied to"
		  " scalar values");
	    return NULL;
	}
	if (j != '*' && !is_unknown(f) && reloc_value(f) == 0) {
	    error(ERR_NONFATAL, "division by zero");
	    return NULL;
	}
	switch (j) {
	  case '*':
	    if (is_simple(e))
		e = scalar_mult (f, reloc_value(e), TRUE);
	    else if (is_simple(f))
		e = scalar_mult (e, reloc_value(f), TRUE);
	    else if (is_just_unknown(e) && is_just_unknown(f))
		e = unknown_expr();
	    else {
		error(ERR_NONFATAL, "unable to multiply two "
		      "non-scalar objects");
		return NULL;
	    }
	    break;
	  case '/':
	    if (is_just_unknown(e) || is_just_unknown(f))
		e = unknown_expr();
	    else
		e = scalarvect (((unsigned long)reloc_value(e)) /
				((unsigned long)reloc_value(f)));
	    break;
	  case '%':
	    if (is_just_unknown(e) || is_just_unknown(f))
		e = unknown_expr();
	    else
		e = scalarvect (((unsigned long)reloc_value(e)) %
				((unsigned long)reloc_value(f)));
	    break;
	  case TOKEN_SDIV:
	    if (is_just_unknown(e) || is_just_unknown(f))
		e = unknown_expr();
	    else
		e = scalarvect (((signed long)reloc_value(e)) /
				((signed long)reloc_value(f)));
	    break;
	  case TOKEN_SMOD:
	    if (is_just_unknown(e) || is_just_unknown(f))
		e = unknown_expr();
	    else
		e = scalarvect (((signed long)reloc_value(e)) %
				((signed long)reloc_value(f)));
	    break;
	}
    }
    return e;
}

static expr *expr6(int critical) 
{
    long type;
    expr *e;
    long label_seg, label_ofs;

    if (i == '-') {
	i = scan(scpriv, tokval);
	e = expr6(critical);
	if (!e)
	    return NULL;
	return scalar_mult (e, -1L, FALSE);
    } else if (i == '+') {
	i = scan(scpriv, tokval);
	return expr6(critical);
    } else if (i == '~') {
	i = scan(scpriv, tokval);
	e = expr6(critical);
	if (!e)
	    return NULL;
	if (is_just_unknown(e))
	    return unknown_expr();
	else if (!is_simple(e)) {
	    error(ERR_NONFATAL, "`~' operator may only be applied to"
		  " scalar values");
	    return NULL;
	}
	return scalarvect(~reloc_value(e));
    } else if (i == TOKEN_SEG) {
	i = scan(scpriv, tokval);
	e = expr6(critical);
	if (!e)
	    return NULL;
	e = segment_part(e);
	if (is_unknown(e) && critical) {
	    error(ERR_NONFATAL, "unable to determine segment base");
	    return NULL;
	}
	return e;
    } else if (i == '(') {
	i = scan(scpriv, tokval);
	e = bexpr(critical);
	if (!e)
	    return NULL;
	if (i != ')') {
	    error(ERR_NONFATAL, "expecting `)'");
	    return NULL;
	}
	i = scan(scpriv, tokval);
	return e;
    } 
    else if (i == TOKEN_NUM || i == TOKEN_REG || i == TOKEN_ID ||
	     i == TOKEN_HERE || i == TOKEN_BASE) 
    {
	begintemp();
	switch (i) {
	  case TOKEN_NUM:
	    addtotemp(EXPR_SIMPLE, tokval->t_integer);
	    break;
	  case TOKEN_REG:
	    addtotemp(tokval->t_integer, 1L);
	    if (hint && hint->type == EAH_NOHINT)
		hint->base = tokval->t_integer, hint->type = EAH_MAKEBASE;
	    break;
	  case TOKEN_ID:
	  case TOKEN_HERE:
	  case TOKEN_BASE:
	    /*
	     * If !location->known, this indicates that no
	     * symbol, Here or Base references are valid because we
	     * are in preprocess-only mode.
	     */
	    if (!location->known) {
		error(ERR_NONFATAL,
		      "%s not supported in preprocess-only mode",
		      (i == TOKEN_ID ? "symbol references" :
		       i == TOKEN_HERE ? "`$'" : "`$$'"));
		addtotemp(EXPR_UNKNOWN, 1L);
		break;
	    }

	    type = EXPR_SIMPLE;	       /* might get overridden by UNKNOWN */
	    if (i == TOKEN_BASE)
	    {
		label_seg = location->segment;
		label_ofs = 0;
	    } else if (i == TOKEN_HERE) {
		label_seg = location->segment;
		label_ofs = location->offset;
	    } else {
		if (!labelfunc(tokval->t_charptr,&label_seg,&label_ofs))
		{
		if (critical == 2) {
		    error (ERR_NONFATAL, "symbol `%s' undefined",
			   tokval->t_charptr);
		    return NULL;
		} else if (critical == 1) {
			error (ERR_NONFATAL,
				"symbol `%s' not defined before use",
			   tokval->t_charptr);
		    return NULL;
		} else {
		    if (opflags)
			*opflags |= 1;
		    type = EXPR_UNKNOWN;
		    label_seg = NO_SEG;
		    label_ofs = 1;
		}
	    }
		if (opflags && is_extern (tokval->t_charptr))
		    *opflags |= OPFLAG_EXTERN;
	    }
	    addtotemp(type, label_ofs);
	    if (label_seg!=NO_SEG)
		addtotemp(EXPR_SEGBASE + label_seg, 1L);
	    break;
	}
	i = scan(scpriv, tokval);
	return finishtemp();
    } else {
	error(ERR_NONFATAL, "expression syntax error");
	return NULL;
    }
}

void eval_global_info (struct ofmt *output, lfunc lookup_label, loc_t *locp) 
{
    outfmt = output;
    labelfunc = lookup_label;
    location = locp;
}

expr *evaluate (scanner sc, void *scprivate, struct tokenval *tv,
		int *fwref, int critical, efunc report_error,
		struct eval_hints *hints) 
{
    expr *e;
    expr *f = NULL;

    hint = hints;
    if (hint)
	hint->type = EAH_NOHINT;

    if (critical & 0x10) {
	critical &= ~0x10;
	bexpr = rexp0;
    } else
	bexpr = expr0;

    scan = sc;
    scpriv = scprivate;
    tokval = tv;
    error = report_error;
    opflags = fwref;

    if (tokval->t_type == TOKEN_INVALID)
	i = scan(scpriv, tokval);
    else
	i = tokval->t_type;

    while (ntempexprs)		       /* initialise temporary storage */
	nasm_free (tempexprs[--ntempexprs]);

    e = bexpr (critical);
    if (!e)
	return NULL;

    if (i == TOKEN_WRT) {
	i = scan(scpriv, tokval);      /* eat the WRT */
	f = expr6 (critical);
	if (!f)
	    return NULL;
    }
    e = scalar_mult (e, 1L, FALSE);    /* strip far-absolute segment part */
    if (f) {
	expr *g;
	if (is_just_unknown(f))
	    g = unknown_expr();
	else {
	    long value;
	    begintemp();
	    if (!is_reloc(f)) {
		error(ERR_NONFATAL, "invalid right-hand operand to WRT");
		return NULL;
	    }
	    value = reloc_seg(f);
	    if (value == NO_SEG)
		value = reloc_value(f) | SEG_ABS;
	    else if (!(value & SEG_ABS) && !(value % 2) && critical) 
	    {
		error(ERR_NONFATAL, "invalid right-hand operand to WRT");
		return NULL;
	    }
	    addtotemp(EXPR_WRT, value);
	    g = finishtemp();
	}
	e = add_vectors (e, g);
    }
    return e;
}
