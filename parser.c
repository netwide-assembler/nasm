/* parser.c   source line parser for the Netwide Assembler
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
#include "parser.h"
#include "float.h"

#include "names.c"

static long reg_flags[] = {	       /* sizes and special flags */
    0, REG8, REG_AL, REG_AX, REG8, REG8, REG16, REG16, REG8, REG_CL,
    REG_CREG, REG_CREG, REG_CREG, REG_CR4, REG_CS, REG_CX, REG8,
    REG16, REG8, REG_DREG, REG_DREG, REG_DREG, REG_DREG, REG_DREG,
    REG_DREG, REG_DESS, REG_DX, REG_EAX, REG32, REG32, REG_ECX,
    REG32, REG32, REG_DESS, REG32, REG32, REG_FSGS, REG_FSGS,
    MMXREG, MMXREG, MMXREG, MMXREG, MMXREG, MMXREG, MMXREG, MMXREG,
    REG16, REG16, REG_DESS, FPU0, FPUREG, FPUREG, FPUREG, FPUREG,
    FPUREG, FPUREG, FPUREG, REG_TREG, REG_TREG, REG_TREG, REG_TREG,
    REG_TREG
};

enum {				       /* special tokens */
    S_BYTE, S_DWORD, S_FAR, S_LONG, S_NEAR, S_QWORD, S_SHORT, S_TO,
    S_TWORD, S_WORD
};

static char *special_names[] = {       /* and the actual text */
    "byte", "dword", "far", "long", "near", "qword", "short", "to",
    "tword", "word"
};

static char *prefix_names[] = {
    "a16", "a32", "lock", "o16", "o32", "rep", "repe", "repne",
    "repnz", "repz", "times"
};

/*
 * Evaluator datatype. Expressions, within the evaluator, are
 * stored as an array of these beasts, terminated by a record with
 * type==0. Mostly, it's a vector type: each type denotes some kind
 * of a component, and the value denotes the multiple of that
 * component present in the expression. The exception is the WRT
 * type, whose `value' field denotes the segment to which the
 * expression is relative. These segments will be segment-base
 * types, i.e. either odd segment values or SEG_ABS types. So it is
 * still valid to assume that anything with a `value' field of zero
 * is insignificant.
 */
typedef struct {
    long type;			       /* a register, or EXPR_xxx */
    long value;			       /* must be >= 32 bits */
} expr;

static void eval_reset(void);
static expr *evaluate(int);

/*
 * ASSUMPTION MADE HERE. The number of distinct register names
 * (i.e. possible "type" fields for an expr structure) does not
 * exceed 126.
 */
#define EXPR_SIMPLE 126
#define EXPR_WRT 127
#define EXPR_SEGBASE 128

static int is_reloc(expr *);
static int is_simple(expr *);
static int is_really_simple (expr *);
static long reloc_value(expr *);
static long reloc_seg(expr *);
static long reloc_wrt(expr *);

enum {				       /* token types, other than chars */
    TOKEN_ID = 256, TOKEN_NUM, TOKEN_REG, TOKEN_INSN, TOKEN_ERRNUM,
    TOKEN_HERE, TOKEN_BASE, TOKEN_SPECIAL, TOKEN_PREFIX, TOKEN_SHL,
    TOKEN_SHR, TOKEN_SDIV, TOKEN_SMOD, TOKEN_SEG, TOKEN_WRT,
    TOKEN_FLOAT
};

struct tokenval {
    long t_integer, t_inttwo;
    char *t_charptr;
};

static char tempstorage[1024], *q;
static int bsi (char *string, char **array, int size);/* binary search */

static int nexttoken (void);
static int is_comma_next (void);

static char *bufptr;
static int i;
static struct tokenval tokval;
static lfunc labelfunc;
static efunc error;
static char *label;
static struct ofmt *outfmt;

static long seg, ofs;

static int forward;

insn *parse_line (long segment, long offset, lfunc lookup_label, int pass,
		  char *buffer, insn *result, struct ofmt *output,
		  efunc errfunc) {
    int operand;
    int critical;

    forward = result->forw_ref = FALSE;
    q = tempstorage;
    bufptr = buffer;
    labelfunc = lookup_label;
    outfmt = output;
    error = errfunc;
    seg = segment;
    ofs = offset;
    label = "";

    i = nexttoken();

    result->eops = NULL;	       /* must do this, whatever happens */

    if (i==0) {			       /* blank line - ignore */
	result->label = NULL;	       /* so, no label on it */
	result->opcode = -1;	       /* and no instruction either */
	return result;
    }
    if (i != TOKEN_ID && i != TOKEN_INSN && i != TOKEN_PREFIX &&
	(i!=TOKEN_REG || (REG_SREG & ~reg_flags[tokval.t_integer]))) {
	error (ERR_NONFATAL, "label or instruction expected"
	       " at start of line");
	result->label = NULL;
	result->opcode = -1;
	return result;
    }

    if (i == TOKEN_ID) {	       /* there's a label here */
	label = result->label = tokval.t_charptr;
	i = nexttoken();
	if (i == ':') {		       /* skip over the optional colon */
	    i = nexttoken();
	} else if (i == 0 && pass == 1) {
	    error (ERR_WARNING|ERR_WARN_OL,
		   "label alone on a line without a colon might be in error");
	}
    } else			       /* no label; so, moving swiftly on */
	result->label = NULL;

    if (i==0) {
	result->opcode = -1;	       /* this line contains just a label */
	return result;
    }

    result->nprefix = 0;
    result->times = 1L;

    while (i == TOKEN_PREFIX ||
	   (i==TOKEN_REG && !(REG_SREG & ~reg_flags[tokval.t_integer]))) {
	/*
	 * Handle special case: the TIMES prefix.
	 */
	if (i == TOKEN_PREFIX && tokval.t_integer == P_TIMES) {
	    expr *value;

	    i = nexttoken();
	    eval_reset();
	    value = evaluate (pass);
	    if (!value) {	       /* but, error in evaluator */
		result->opcode = -1;   /* unrecoverable parse error: */
		return result;	       /* ignore this instruction */
	    }
	    if (!is_simple (value)) {
		error (ERR_NONFATAL,
		       "non-constant argument supplied to TIMES");
		result->times = 1L;
	    } else {
		result->times = value->value;
		if (value->value < 0)
		    error(ERR_NONFATAL, "TIMES value %d is negative",
			  value->value);
	    }
	} else {
	    if (result->nprefix == MAXPREFIX)
		error (ERR_NONFATAL,
		       "instruction has more than %d prefixes", MAXPREFIX);
	    else
		result->prefixes[result->nprefix++] = tokval.t_integer;
	    i = nexttoken();
	}
    }

    if (i != TOKEN_INSN) {
	error (ERR_NONFATAL, "parser: instruction expected");
	result->opcode = -1;
	return result;
    }

    result->opcode = tokval.t_integer;
    result->condition = tokval.t_inttwo;

    /*
     * RESB, RESW and RESD cannot be satisfied with incorrectly
     * evaluated operands, since the correct values _must_ be known
     * on the first pass. Hence, even in pass one, we set the
     * `critical' flag on calling evaluate(), so that it will bomb
     * out on undefined symbols. Nasty, but there's nothing we can
     * do about it.
     *
     * For the moment, EQU has the same difficulty, so we'll
     * include that.
     */
    if (result->opcode == I_RESB ||
	result->opcode == I_RESW ||
	result->opcode == I_RESD ||
	result->opcode == I_RESQ ||
	result->opcode == I_REST ||
	result->opcode == I_EQU)
	critical = pass;
    else
	critical = (pass==2 ? 2 : 0);

    if (result->opcode == I_DB ||
	result->opcode == I_DW ||
	result->opcode == I_DD ||
	result->opcode == I_DQ ||
	result->opcode == I_DT ||
	result->opcode == I_INCBIN) {
	extop *eop, **tail = &result->eops;
	int oper_num = 0;

	/*
	 * Begin to read the DB/DW/DD/DQ/DT operands.
	 */
	while (1) {
	    i = nexttoken();
	    if (i == 0)
		break;
	    eop = *tail = nasm_malloc(sizeof(extop));
	    tail = &eop->next;
	    eop->next = NULL;
	    eop->type = EOT_NOTHING;
	    oper_num++;

	    if (i == TOKEN_NUM && tokval.t_charptr && is_comma_next()) {
		eop->type = EOT_DB_STRING;
		eop->stringval = tokval.t_charptr;
		eop->stringlen = tokval.t_inttwo;
		i = nexttoken();       /* eat the comma */
		continue;
	    }

	    if (i == TOKEN_FLOAT || i == '-') {
		long sign = +1L;

		if (i == '-') {
		    char *save = bufptr;
		    i = nexttoken();
		    sign = -1L;
		    if (i != TOKEN_FLOAT) {
			bufptr = save;
			i = '-';
		    }
		}

		if (i == TOKEN_FLOAT) {
		    eop->type = EOT_DB_STRING;
		    eop->stringval = q;
		    if (result->opcode == I_DD)
			eop->stringlen = 4;
		    else if (result->opcode == I_DQ)
			eop->stringlen = 8;
		    else if (result->opcode == I_DT)
		    eop->stringlen = 10;
		    else {
			error(ERR_NONFATAL, "floating-point constant"
			      " encountered in `D%c' instruction",
			      result->opcode == I_DW ? 'W' : 'B');
			eop->type = EOT_NOTHING;
		    }
		    q += eop->stringlen;
		    if (!float_const (tokval.t_charptr, sign,
				      (unsigned char *)eop->stringval,
				      eop->stringlen, error))
			eop->type = EOT_NOTHING;
		    i = nexttoken();       /* eat the comma */
		    continue;
		}
	    }

	    /* anything else */ {
		expr *value;
		eval_reset();
		value = evaluate (critical);
		if (!value) {	       /* but, error in evaluator */
		    result->opcode = -1;/* unrecoverable parse error: */
		    return result;     /* ignore this instruction */
		}
		if (is_reloc(value)) {
		    eop->type = EOT_DB_NUMBER;
		    eop->offset = reloc_value(value);
		    eop->segment = reloc_seg(value);
		    eop->wrt = reloc_wrt(value);
		} else {
		    error (ERR_NONFATAL,
			   "`%s' operand %d: expression is not simple"
			   " or relocatable",
			   insn_names[result->opcode], oper_num);
		}
	    }

	    /*
	     * We're about to call nexttoken(), which will eat the
	     * comma that we're currently sitting on between
	     * arguments. However, we'd better check first that it
	     * _is_ a comma.
	     */
	    if (i == 0)		       /* also could be EOL */
		break;
	    if (i != ',') {
		error (ERR_NONFATAL, "comma expected after `%s' operand %d",
		       insn_names[result->opcode], oper_num);
		result->opcode = -1;/* unrecoverable parse error: */
		return result;     /* ignore this instruction */
	    }
	}

	if (result->opcode == I_INCBIN) {
	    /*
	     * Correct syntax for INCBIN is that there should be
	     * one string operand, followed by one or two numeric
	     * operands.
	     */
	    if (!result->eops || result->eops->type != EOT_DB_STRING)
		error (ERR_NONFATAL, "`incbin' expects a file name");
	    else if (result->eops->next &&
		     result->eops->next->type != EOT_DB_NUMBER)
		error (ERR_NONFATAL, "`incbin': second parameter is",
		       " non-numeric");
	    else if (result->eops->next && result->eops->next->next &&
		     result->eops->next->next->type != EOT_DB_NUMBER)
		error (ERR_NONFATAL, "`incbin': third parameter is",
		       " non-numeric");
	    else if (result->eops->next && result->eops->next->next &&
		     result->eops->next->next->next)
		error (ERR_NONFATAL, "`incbin': more than three parameters");
	    else
		return result;
	    /*
	     * If we reach here, one of the above errors happened.
	     * Throw the instruction away.
	     */
	    result->opcode = -1;
	    return result;
	}

	return result;
    }

    /* right. Now we begin to parse the operands. There may be up to three
     * of these, separated by commas, and terminated by a zero token. */

    for (operand = 0; operand < 3; operand++) {
	expr *seg, *value;	       /* used most of the time */
	int mref;		       /* is this going to be a memory ref? */
	int bracket;		       /* is it a [] mref, or a & mref? */

	result->oprs[operand].addr_size = 0;/* have to zero this whatever */
	i = nexttoken();
	if (i == 0) break;	       /* end of operands: get out of here */
	result->oprs[operand].type = 0;   /* so far, no override */
	while (i == TOKEN_SPECIAL)	{/* size specifiers */
	    switch ((int)tokval.t_integer) {
	      case S_BYTE:
		result->oprs[operand].type |= BITS8;
		break;
	      case S_WORD:
		result->oprs[operand].type |= BITS16;
		break;
	      case S_DWORD:
	      case S_LONG:
		result->oprs[operand].type |= BITS32;
		break;
	      case S_QWORD:
		result->oprs[operand].type |= BITS64;
		break;
	      case S_TWORD:
		result->oprs[operand].type |= BITS80;
		break;
	      case S_TO:
		result->oprs[operand].type |= TO;
		break;
	      case S_FAR:
		result->oprs[operand].type |= FAR;
		break;
	      case S_NEAR:
		result->oprs[operand].type |= NEAR;
		break;
	      case S_SHORT:
		result->oprs[operand].type |= SHORT;
		break;
	    }
	    i = nexttoken();
	}

	if (i == '[' || i == '&') {    /* memory reference */
	    mref = TRUE;
	    bracket = (i == '[');
	    i = nexttoken();	    
	    if (i == TOKEN_SPECIAL) {  /* check for address size override */
		switch ((int)tokval.t_integer) {
		  case S_WORD:
		    result->oprs[operand].addr_size = 16;
		    break;
		  case S_DWORD:
		  case S_LONG:
		    result->oprs[operand].addr_size = 32;
		    break;
		  default:
		    error (ERR_NONFATAL, "invalid size specification in"
			   " effective address");
		}
		i = nexttoken();
	    }
	} else {		       /* immediate operand, or register */
	    mref = FALSE;
	    bracket = FALSE;	       /* placate optimisers */
	}

	eval_reset();

	value = evaluate (critical);
	if (forward)
	    result->forw_ref = TRUE;
	if (!value) {		       /* error in evaluator */
	    result->opcode = -1;       /* unrecoverable parse error: */
	    return result;	       /* ignore this instruction */
	}
	if (i == ':' && mref) {	       /* it was seg:offset */
	    seg = value;	       /* so shift this into the segment */
	    i = nexttoken();	       /* then skip the colon */
	    if (i == TOKEN_SPECIAL) {  /* another check for size override */
		switch ((int)tokval.t_integer) {
		  case S_WORD:
		    result->oprs[operand].addr_size = 16;
		    break;
		  case S_DWORD:
		  case S_LONG:
		    result->oprs[operand].addr_size = 32;
		    break;
		  default:
		    error (ERR_NONFATAL, "invalid size specification in"
			   " effective address");
		}
		i = nexttoken();
	    }
	    value = evaluate (critical);
	    if (forward)
		result->forw_ref = TRUE;	
	    /* and get the offset */
	    if (!value) {	       /* but, error in evaluator */
		result->opcode = -1;   /* unrecoverable parse error: */
		return result;	       /* ignore this instruction */
	    }
	} else seg = NULL;
	if (mref && bracket) {	       /* find ] at the end */
	    if (i != ']') {
		error (ERR_NONFATAL, "parser: expecting ]");
		do {		       /* error recovery again */
		    i = nexttoken();
		} while (i != 0 && i != ',');
	    } else		       /* we got the required ] */
		i = nexttoken();
	} else {		       /* immediate operand */
	    if (i != 0 && i != ',' && i != ':') {
		error (ERR_NONFATAL, "comma or end of line expected");
		do {		       /* error recovery */
		    i = nexttoken();
		} while (i != 0 && i != ',');
	    } else if (i == ':') {
		result->oprs[operand].type |= COLON;
	    }
	}

	/* now convert the exprs returned from evaluate() into operand
	 * descriptions... */

	if (mref) {		       /* it's a memory reference */
	    expr *e = value;
	    int b, i, s;	       /* basereg, indexreg, scale */
	    long o;		       /* offset */

	    if (seg) {		       /* segment override */
		if (seg[1].type!=0 || seg->value!=1 ||
		    REG_SREG & ~reg_flags[seg->type])
		    error (ERR_NONFATAL, "invalid segment override");
		else if (result->nprefix == MAXPREFIX)
		    error (ERR_NONFATAL,
			   "instruction has more than %d prefixes",
			   MAXPREFIX);
		else
		    result->prefixes[result->nprefix++] = seg->type;
	    }

	    b = i = -1, o = s = 0;

	    if (e->type < EXPR_SIMPLE) {   /* this bit's a register */
		if (e->value == 1) /* in fact it can be basereg */
		    b = e->type;
		else	       /* no, it has to be indexreg */
		    i = e->type, s = e->value;
		e++;
	    }
	    if (e->type && e->type < EXPR_SIMPLE) {/* it's a second register */
		if (e->value != 1) {   /* it has to be indexreg */
		    if (i != -1) {     /* but it can't be */
			error(ERR_NONFATAL, "invalid effective address");
			result->opcode = -1;
			return result;
		    } else
			i = e->type, s = e->value;
		} else {	       /* it can be basereg */
		    if (b != -1)       /* or can it? */
			i = e->type, s = 1;
		    else
			b = e->type;
		}
		e++;
	    }
	    if (e->type != 0) {	       /* is there an offset? */
		if (e->type < EXPR_SIMPLE) {/* in fact, is there an error? */
		    error (ERR_NONFATAL, "invalid effective address");
		    result->opcode = -1;
		    return result;
		} else {
		    if (e->type == EXPR_SIMPLE) {
			o = e->value;
			e++;
		    }
		    if (e->type == EXPR_WRT) {
			result->oprs[operand].wrt = e->value;
			e++;
		    } else
			result->oprs[operand].wrt = NO_SEG;
		    /*
		     * Look for a segment base type.
		     */
		    if (e->type && e->type < EXPR_SEGBASE) {
			error (ERR_NONFATAL, "invalid effective address");
			result->opcode = -1;
			return result;
		    }
		    while (e->type && e->value == 0)
			e++;
		    if (e->type && e->value != 1) {
			error (ERR_NONFATAL, "invalid effective address");
			result->opcode = -1;
			return result;
		    }
		    if (e->type) {
			result->oprs[operand].segment = e->type-EXPR_SEGBASE;
			e++;
		    } else
			result->oprs[operand].segment = NO_SEG;
		    while (e->type && e->value == 0)
			e++;
		    if (e->type) {
			error (ERR_NONFATAL, "invalid effective address");
			result->opcode = -1;
			return result;
		    }
		}
	    } else {
		o = 0;
		result->oprs[operand].wrt = NO_SEG;
		result->oprs[operand].segment = NO_SEG;
	    }

	    if (e->type != 0) {    /* there'd better be nothing left! */
		error (ERR_NONFATAL, "invalid effective address");
		result->opcode = -1;
		return result;
	    }

	    result->oprs[operand].type |= MEMORY;
	    if (b==-1 && (i==-1 || s==0))
		result->oprs[operand].type |= MEM_OFFS;
	    result->oprs[operand].basereg = b;
	    result->oprs[operand].indexreg = i;
	    result->oprs[operand].scale = s;
	    result->oprs[operand].offset = o;
	} else {		       /* it's not a memory reference */
	    if (is_reloc(value)) {     /* it's immediate */
		result->oprs[operand].type |= IMMEDIATE;
		result->oprs[operand].offset = reloc_value(value);
		result->oprs[operand].segment = reloc_seg(value);
		result->oprs[operand].wrt = reloc_wrt(value);
		if (is_simple(value) && reloc_value(value)==1)
		    result->oprs[operand].type |= UNITY;
	    } else {	       /* it's a register */
		if (value->type>=EXPR_SIMPLE || value->value!=1) {
		    error (ERR_NONFATAL, "invalid operand type");
		    result->opcode = -1;
		    return result;
		}
		/* clear overrides, except TO which applies to FPU regs */
		result->oprs[operand].type &= TO;
		result->oprs[operand].type |= REGISTER;
		result->oprs[operand].type |= reg_flags[value->type];
		result->oprs[operand].basereg = value->type;
	    }
	}
    }

    result->operands = operand;       /* set operand count */

    while (operand<3)		       /* clear remaining operands */
	result->oprs[operand++].type = 0;

    /*
     * Transform RESW, RESD, RESQ, REST into RESB.
     */
    switch (result->opcode) {
      case I_RESW: result->opcode=I_RESB; result->oprs[0].offset*=2; break;
      case I_RESD: result->opcode=I_RESB; result->oprs[0].offset*=4; break;
      case I_RESQ: result->opcode=I_RESB; result->oprs[0].offset*=8; break;
      case I_REST: result->opcode=I_RESB; result->oprs[0].offset*=10; break;
    }

    return result;
}

static int is_comma_next (void) {
    char *p;

    p = bufptr;
    while (isspace(*p)) p++;
    return (*p == ',' || *p == ';' || !*p);
}

/*
 * This tokeniser routine has only one side effect, that of
 * updating `bufptr'. Hence by saving `bufptr', lookahead may be
 * performed.
 */

static int nexttoken (void) {
    char ourcopy[256], *r, *s;

    while (isspace(*bufptr)) bufptr++;
    if (!*bufptr) return 0;

    /* we have a token; either an id, a number or a char */
    if (isidstart(*bufptr) ||
	(*bufptr == '$' && isidstart(bufptr[1]))) {
	/* now we've got an identifier */
	int i;
	int is_sym = FALSE;

	if (*bufptr == '$') {
	    is_sym = TRUE;
	    bufptr++;
	}

 	tokval.t_charptr = q;
	*q++ = *bufptr++;
	while (isidchar(*bufptr)) *q++ = *bufptr++;
	*q++ = '\0';
	for (s=tokval.t_charptr, r=ourcopy; *s; s++)
	    *r++ = tolower (*s);
	*r = '\0';
	if (is_sym)
	    return TOKEN_ID;	       /* bypass all other checks */
	/* right, so we have an identifier sitting in temp storage. now,
	 * is it actually a register or instruction name, or what? */
	if ((tokval.t_integer=bsi(ourcopy, reg_names,
				  elements(reg_names)))>=0)
	    return TOKEN_REG;
	if ((tokval.t_integer=bsi(ourcopy, insn_names,
				  elements(insn_names)))>=0)
	    return TOKEN_INSN;
	for (i=0; i<elements(icn); i++)
	    if (!strncmp(ourcopy, icn[i], strlen(icn[i]))) {
		char *p = ourcopy + strlen(icn[i]);
		tokval.t_integer = ico[i];
		if ((tokval.t_inttwo=bsi(p, conditions,
					 elements(conditions)))>=0)
		    return TOKEN_INSN;
	    }
	if ((tokval.t_integer=bsi(ourcopy, prefix_names,
				  elements(prefix_names)))>=0) {
	    tokval.t_integer += PREFIX_ENUM_START;
	    return TOKEN_PREFIX;
	}
	if ((tokval.t_integer=bsi(ourcopy, special_names,
				  elements(special_names)))>=0)
	    return TOKEN_SPECIAL;
	if (!strcmp(ourcopy, "seg"))
	    return TOKEN_SEG;
	if (!strcmp(ourcopy, "wrt"))
	    return TOKEN_WRT;
	return TOKEN_ID;
    } else if (*bufptr == '$' && !isnumchar(bufptr[1])) {
	/*
	 * It's a $ sign with no following hex number; this must
	 * mean it's a Here token ($), evaluating to the current
	 * assembly location, or a Base token ($$), evaluating to
	 * the base of the current segment.
	 */
	bufptr++;
	if (*bufptr == '$') {
	    bufptr++;
	    return TOKEN_BASE;
	}
	return TOKEN_HERE;
    } else if (isnumstart(*bufptr)) {	       /* now we've got a number */
	char *r = q;
	int rn_error;

	*q++ = *bufptr++;
	while (isnumchar(*bufptr)) {
	    *q++ = *bufptr++;
	}
	if (*bufptr == '.') {
	    /*
	     * a floating point constant
	     */
	    *q++ = *bufptr++;
	    while (isnumchar(*bufptr)) {
		*q++ = *bufptr++;
	    }
	    *q++ = '\0';
	    tokval.t_charptr = r;
	    return TOKEN_FLOAT;
	}
	*q++ = '\0';
	tokval.t_integer = readnum(r, &rn_error);
	if (rn_error)
	    return TOKEN_ERRNUM;       /* some malformation occurred */
	tokval.t_charptr = NULL;
	return TOKEN_NUM;
    } else if (*bufptr == '\'' || *bufptr == '"') {/* a char constant */
    	char quote = *bufptr++, *r;
	r = tokval.t_charptr = bufptr;
	while (*bufptr && *bufptr != quote) bufptr++;
	tokval.t_inttwo = bufptr - r;      /* store full version */
	if (!*bufptr)
	    return TOKEN_ERRNUM;       /* unmatched quotes */
	tokval.t_integer = 0;
	r = bufptr++;		       /* skip over final quote */
	while (quote != *--r) {
	    tokval.t_integer = (tokval.t_integer<<8) + (unsigned char) *r;
	}
	return TOKEN_NUM;
    } else if (*bufptr == ';') {       /* a comment has happened - stay */
	return 0;
    } else if ((*bufptr == '>' || *bufptr == '<' ||
		*bufptr == '/' || *bufptr == '%') && bufptr[1] == *bufptr) {
	bufptr += 2;
	return (bufptr[-2] == '>' ? TOKEN_SHR :
		bufptr[-2] == '<' ? TOKEN_SHL :
		bufptr[-2] == '/' ? TOKEN_SDIV :
		TOKEN_SMOD);
    } else			       /* just an ordinary char */
    	return (unsigned char) (*bufptr++);
}

/* return index of "string" in "array", or -1 if no match. */
static int bsi (char *string, char **array, int size) {
    int i = -1, j = size;	       /* always, i < index < j */
    while (j-i >= 2) {
	int k = (i+j)/2;
	int l = strcmp(string, array[k]);
	if (l<0)		       /* it's in the first half */
	    j = k;
	else if (l>0)		       /* it's in the second half */
	    i = k;
	else			       /* we've got it :) */
	    return k;
    }
    return -1;			       /* we haven't got it :( */
}

void cleanup_insn (insn *i) {
    extop *e;

    while (i->eops) {
	e = i->eops;
	i->eops = i->eops->next;
	nasm_free (e);
    }
}

/* ------------- Evaluator begins here ------------------ */

static expr exprtempstorage[1024], *tempptr;   /* store exprs in here */

/*
 * Add two vector datatypes. We have some bizarre behaviour on far-
 * absolute segment types: we preserve them during addition _only_
 * if one of the segments is a truly pure scalar.
 */
static expr *add_vectors(expr *p, expr *q) {
    expr *r = tempptr;
    int preserve;

    preserve = is_really_simple(p) || is_really_simple(q);

    while (p->type && q->type &&
	   p->type < EXPR_SEGBASE+SEG_ABS &&
	   q->type < EXPR_SEGBASE+SEG_ABS)
    	if (p->type > q->type) {
	    tempptr->type = q->type;
	    tempptr->value = q->value;
	    tempptr++, q++;
	} else if (p->type < q->type) {
	    tempptr->type = p->type;
	    tempptr->value = p->value;
	    tempptr++, p++;
	} else {		       /* *p and *q have same type */
	    tempptr->type = p->type;
	    tempptr->value = p->value + q->value;
	    tempptr++, p++, q++;
	}
    while (p->type &&
	   (preserve || p->type < EXPR_SEGBASE+SEG_ABS)) {
	tempptr->type = p->type;
	tempptr->value = p->value;
	tempptr++, p++;
    }
    while (q->type &&
	   (preserve || q->type < EXPR_SEGBASE+SEG_ABS)) {
	tempptr->type = q->type;
	tempptr->value = q->value;
	tempptr++, q++;
    }
    (tempptr++)->type = 0;

    return r;
}

/*
 * Multiply a vector by a scalar. Strip far-absolute segment part
 * if present.
 */
static expr *scalar_mult(expr *vect, long scalar) {
    expr *p = vect;

    while (p->type && p->type < EXPR_SEGBASE+SEG_ABS) {
	p->value = scalar * (p->value);
	p++;
    }
    p->type = 0;

    return vect;
}

static expr *scalarvect (long scalar) {
    expr *p = tempptr;
    tempptr->type = EXPR_SIMPLE;
    tempptr->value = scalar;
    tempptr++;
    tempptr->type = 0;
    tempptr++;
    return p;
}

/*
 * Return TRUE if the argument is a simple scalar. (Or a far-
 * absolute, which counts.)
 */
static int is_simple (expr *vect) {
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type)
	return 1;
    if (vect->type != EXPR_SIMPLE)
	return 0;
    do {
	vect++;
    } while (vect->type && !vect->value);
    if (vect->type && vect->type < EXPR_SEGBASE+SEG_ABS) return 0;
    return 1;
}

/*
 * Return TRUE if the argument is a simple scalar, _NOT_ a far-
 * absolute.
 */
static int is_really_simple (expr *vect) {
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type)
	return 1;
    if (vect->type != EXPR_SIMPLE)
	return 0;
    do {
	vect++;
    } while (vect->type && !vect->value);
    if (vect->type) return 0;
    return 1;
}

/*
 * Return TRUE if the argument is relocatable (i.e. a simple
 * scalar, plus at most one segment-base, plus possibly a WRT).
 */
static int is_reloc (expr *vect) {
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type)
	return 1;
    if (vect->type < EXPR_SIMPLE)
	return 0;
    if (vect->type == EXPR_SIMPLE) {
	do {
	    vect++;
	} while (vect->type && !vect->value);
	if (!vect->type)
	    return 1;
    }
    if (vect->type != EXPR_WRT && vect->value != 0 && vect->value != 1)
	return 0;		       /* segment base multiplier non-unity */
    do {
	vect++;
    } while (vect->type && (vect->type == EXPR_WRT || !vect->value));
    if (!vect->type)
	return 1;
    return 1;
}

/*
 * Return the scalar part of a relocatable vector. (Including
 * simple scalar vectors - those qualify as relocatable.)
 */
static long reloc_value (expr *vect) {
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type) return 0;
    if (vect->type == EXPR_SIMPLE)
	return vect->value;
    else
	return 0;
}

/*
 * Return the segment number of a relocatable vector, or NO_SEG for
 * simple scalars.
 */
static long reloc_seg (expr *vect) {
    while (vect->type && (vect->type == EXPR_WRT || !vect->value))
    	vect++;
    if (vect->type == EXPR_SIMPLE) {
	do {
	    vect++;
	} while (vect->type && (vect->type == EXPR_WRT || !vect->value));
    }
    if (!vect->type)
	return NO_SEG;
    else
	return vect->type - EXPR_SEGBASE;
}

/*
 * Return the WRT segment number of a relocatable vector, or NO_SEG
 * if no WRT part is present.
 */
static long reloc_wrt (expr *vect) {
    while (vect->type && vect->type < EXPR_WRT)
    	vect++;
    if (vect->type == EXPR_WRT) {
	return vect->value;
    } else
	return NO_SEG;
}

static void eval_reset(void) {
    tempptr = exprtempstorage;	       /* initialise temporary storage */
}

/*
 * The SEG operator: calculate the segment part of a relocatable
 * value. Return NULL, as usual, if an error occurs. Report the
 * error too.
 */
static expr *segment_part (expr *e) {
    long seg;

    if (!is_reloc(e)) {
	error(ERR_NONFATAL, "cannot apply SEG to a non-relocatable value");
	return NULL;
    }

    seg = reloc_seg(e);
    if (seg == NO_SEG) {
	error(ERR_NONFATAL, "cannot apply SEG to a non-relocatable value");
	return NULL;
    } else if (seg & SEG_ABS)
	return scalarvect(seg & ~SEG_ABS);
    else {
	expr *f = tempptr++;
	tempptr++->type = 0;
	f->type = EXPR_SEGBASE+outfmt->segbase(seg+1);
	f->value = 1;
	return f;
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
 * expr  : expr0 [ WRT expr6 ]
 * expr0 : expr1 [ {|} expr1]
 * expr1 : expr2 [ {^} expr2]
 * expr2 : expr3 [ {&} expr3]
 * expr3 : expr4 [ {<<,>>} expr4...]
 * expr4 : expr5 [ {+,-} expr5...]
 * expr5 : expr6 [ {*,/,%,//,%%} expr6...]
 * expr6 : { ~,+,-,SEG } expr6
 *       | (expr0)
 *       | symbol
 *       | $
 *       | number
 */

static expr *expr0(int), *expr1(int), *expr2(int), *expr3(int);
static expr *expr4(int), *expr5(int), *expr6(int);

static expr *expr0(int critical) {
    expr *e, *f;

    e = expr1(critical);
    if (!e)
	return NULL;
    while (i == '|') {
	i = nexttoken();
	f = expr1(critical);
	if (!f)
	    return NULL;
	if (!is_simple(e) || !is_simple(f)) {
	    error(ERR_NONFATAL, "`|' operator may only be applied to"
		  " scalar values");
	}
	e = scalarvect (reloc_value(e) | reloc_value(f));
    }
    return e;
}

static expr *expr1(int critical) {
    expr *e, *f;

    e = expr2(critical);
    if (!e)
	return NULL;
    while (i == '^') {
	i = nexttoken();
	f = expr2(critical);
	if (!f)
	    return NULL;
	if (!is_simple(e) || !is_simple(f)) {
	    error(ERR_NONFATAL, "`^' operator may only be applied to"
		  " scalar values");
	}
	e = scalarvect (reloc_value(e) ^ reloc_value(f));
    }
    return e;
}

static expr *expr2(int critical) {
    expr *e, *f;

    e = expr3(critical);
    if (!e)
	return NULL;
    while (i == '&') {
	i = nexttoken();
	f = expr3(critical);
	if (!f)
	    return NULL;
	if (!is_simple(e) || !is_simple(f)) {
	    error(ERR_NONFATAL, "`&' operator may only be applied to"
		  " scalar values");
	}
	e = scalarvect (reloc_value(e) & reloc_value(f));
    }
    return e;
}

static expr *expr3(int critical) {
    expr *e, *f;

    e = expr4(critical);
    if (!e)
	return NULL;
    while (i == TOKEN_SHL || i == TOKEN_SHR) {
	int j = i;
	i = nexttoken();
	f = expr4(critical);
	if (!f)
	    return NULL;
	if (!is_simple(e) || !is_simple(f)) {
	    error(ERR_NONFATAL, "shift operator may only be applied to"
		  " scalar values");
	}
	switch (j) {
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

static expr *expr4(int critical) {
    expr *e, *f;

    e = expr5(critical);
    if (!e)
	return NULL;
    while (i == '+' || i == '-') {
	int j = i;
	i = nexttoken();
	f = expr5(critical);
	if (!f)
	    return NULL;
	switch (j) {
	  case '+':
	    e = add_vectors (e, f);
	    break;
	  case '-':
	    e = add_vectors (e, scalar_mult(f, -1L));
	    break;
	}
    }
    return e;
}

static expr *expr5(int critical) {
    expr *e, *f;

    e = expr6(critical);
    if (!e)
	return NULL;
    while (i == '*' || i == '/' || i == '*' ||
	   i == TOKEN_SDIV || i == TOKEN_SMOD) {
	int j = i;
	i = nexttoken();
	f = expr6(critical);
	if (!f)
	    return NULL;
	if (j != '*' && (!is_simple(e) || !is_simple(f))) {
	    error(ERR_NONFATAL, "division operator may only be applied to"
		  " scalar values");
	    return NULL;
	}
	if (j != '*' && reloc_value(f) == 0) {
	    error(ERR_NONFATAL, "division by zero");
	    return NULL;
	}
	switch (j) {
	  case '*':
	    if (is_simple(e))
		e = scalar_mult (f, reloc_value(e));
	    else if (is_simple(f))
		e = scalar_mult (e, reloc_value(f));
	    else {
		error(ERR_NONFATAL, "unable to multiply two "
		      "non-scalar objects");
		return NULL;
	    }
	    break;
	  case '/':
	    e = scalarvect (((unsigned long)reloc_value(e)) /
			    ((unsigned long)reloc_value(f)));
	    break;
	  case '%':
	    e = scalarvect (((unsigned long)reloc_value(e)) %
			    ((unsigned long)reloc_value(f)));
	    break;
	  case TOKEN_SDIV:
	    e = scalarvect (((signed long)reloc_value(e)) /
			    ((signed long)reloc_value(f)));
	    break;
	  case TOKEN_SMOD:
	    e = scalarvect (((signed long)reloc_value(e)) %
			    ((signed long)reloc_value(f)));
	    break;
	}
    }
    return e;
}

static expr *expr6(int critical) {
    expr *e;
    long label_seg, label_ofs;

    if (i == '-') {
	i = nexttoken();
	e = expr6(critical);
	if (!e)
	    return NULL;
	return scalar_mult (e, -1L);
    } else if (i == '+') {
	i = nexttoken();
	return expr6(critical);
    } else if (i == '~') {
	i = nexttoken();
	e = expr6(critical);
	if (!e)
	    return NULL;
	if (!is_simple(e)) {
	    error(ERR_NONFATAL, "`~' operator may only be applied to"
		  " scalar values");
	    return NULL;
	}
	return scalarvect(~reloc_value(e));
    } else if (i == TOKEN_SEG) {
	i = nexttoken();
	e = expr6(critical);
	if (!e)
	    return NULL;
	return segment_part(e);
    } else if (i == '(') {
	i = nexttoken();
	e = expr0(critical);
	if (!e)
	    return NULL;
	if (i != ')') {
	    error(ERR_NONFATAL, "expecting `)'");
	    return NULL;
	}
	i = nexttoken();
	return e;
    } else if (i == TOKEN_NUM || i == TOKEN_REG || i == TOKEN_ID ||
	       i == TOKEN_HERE || i == TOKEN_BASE) {
	e = tempptr;
	switch (i) {
	  case TOKEN_NUM:
	    e->type = EXPR_SIMPLE;
	    e->value = tokval.t_integer;
	    break;
	  case TOKEN_REG:
	    e->type = tokval.t_integer;
	    e->value = 1;
	    break;
	  case TOKEN_ID:
	  case TOKEN_HERE:
	  case TOKEN_BASE:
	    /*
	     * Since the whole line is parsed before the label it
	     * defines is given to the label manager, we have
	     * problems with lines such as
	     *
	     *   end: TIMES 512-(end-start) DB 0
	     *
	     * where `end' is not known on pass one, despite not
	     * really being a forward reference, and due to
	     * criticality it is _needed_. Hence we check our label
	     * against the currently defined one, and do our own
	     * resolution of it if we have to.
	     */
	    if (i == TOKEN_BASE) {
		label_seg = seg;
		label_ofs = 0;
	    } else if (i == TOKEN_HERE || !strcmp(tokval.t_charptr, label)) {
		label_seg = seg;
		label_ofs = ofs;
	    } else if (!labelfunc(tokval.t_charptr, &label_seg, &label_ofs)) {
		if (critical == 2) {
		    error (ERR_NONFATAL, "symbol `%s' undefined",
			   tokval.t_charptr);
		    return NULL;
		} else if (critical == 1) {
		    error (ERR_NONFATAL, "symbol `%s' not defined before use",
			   tokval.t_charptr);
		    return NULL;
		} else {
		    forward = TRUE;
		    label_seg = seg;
		    label_ofs = ofs;
		}
	    }
	    e->type = EXPR_SIMPLE;
	    e->value = label_ofs;
	    if (label_seg!=NO_SEG) {
		tempptr++;
		tempptr->type = EXPR_SEGBASE + label_seg;
		tempptr->value = 1;
	    }
	    break;
	}
	tempptr++;
	tempptr->type = 0;
	tempptr++;
	i = nexttoken();
	return e;
    } else {
	error(ERR_NONFATAL, "expression syntax error");
	return NULL;
    }
}

static expr *evaluate (int critical) {
    expr *e;
    expr *f = NULL;

    e = expr0 (critical);
    if (!e)
	return NULL;

    if (i == TOKEN_WRT) {
	i = nexttoken();	       /* eat the WRT */
	f = expr6 (critical);
	if (!f)
	    return NULL;
    }
    e = scalar_mult (e, 1L);	       /* strip far-absolute segment part */
    if (f) {
	expr *g = tempptr++;
	tempptr++->type = 0;
	g->type = EXPR_WRT;
	if (!is_reloc(f)) {
	    error(ERR_NONFATAL, "invalid right-hand operand to WRT");
	    return NULL;
	}
	g->value = reloc_seg(f);
	if (g->value == NO_SEG)
	    g->value = reloc_value(f) | SEG_ABS;
	else if (!(g->value & SEG_ABS) && !(g->value % 2) && critical) {
	    error(ERR_NONFATAL, "invalid right-hand operand to WRT");
	    return NULL;
	}
	e = add_vectors (e, g);
    }
    return e;
}
