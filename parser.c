/* parser.c   source line parser for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version 27/iii/95 by Simon Tatham
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "insns.h"
#include "nasmlib.h"
#include "stdscan.h"
#include "parser.h"
#include "float.h"

extern int in_abs_seg;          /* ABSOLUTE segment flag */
extern int32_t abs_seg;            /* ABSOLUTE segment */
extern int32_t abs_offset;         /* ABSOLUTE segment offset */

#include "regflags.c"           /* List of register flags */

static int is_comma_next(void);

static int i;
static struct tokenval tokval;
static efunc error;
static struct ofmt *outfmt;     /* Structure of addresses of output routines */
static struct location *location;         /* Pointer to current line's segment,offset */

void parser_global_info(struct ofmt *output, struct location * locp)
{
    outfmt = output;
    location = locp;
}

static int prefix_slot(enum prefixes prefix)
{
    switch (prefix) {
    case R_CS:
    case R_DS:
    case R_SS:
    case R_ES:
    case R_FS:
    case R_GS:
	return PPS_SEG;
    case P_LOCK:
    case P_REP:
    case P_REPE:
    case P_REPZ:
    case P_REPNE:
    case P_REPNZ:
	return PPS_LREP;
    case P_O16:
    case P_O32:
    case P_O64:
    case P_OSP:
	return PPS_OSIZE;
    case P_A16:
    case P_A32:
    case P_A64:
    case P_ASP:
	return PPS_ASIZE;
    default:
	error(ERR_PANIC, "Invalid value %d passed to prefix_slot()", prefix);
	return -1;
    }
}

static void process_size_override(insn * result, int operand)
{
    if (tasm_compatible_mode) {
	switch ((int)tokval.t_integer) {
	    /* For TASM compatibility a size override inside the
	     * brackets changes the size of the operand, not the
	     * address type of the operand as it does in standard
	     * NASM syntax. Hence:
	     *
	     *  mov     eax,[DWORD val]
	     *
	     * is valid syntax in TASM compatibility mode. Note that
	     * you lose the ability to override the default address
	     * type for the instruction, but we never use anything
	     * but 32-bit flat model addressing in our code.
	     */
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
	case S_OWORD:
	    result->oprs[operand].type |= BITS128;
	    break;
	default:
	    error(ERR_NONFATAL,
		  "invalid operand size specification");
	    break;
	}
    } else {
	/* Standard NASM compatible syntax */
	switch ((int)tokval.t_integer) {
	case S_NOSPLIT:
	    result->oprs[operand].eaflags |= EAF_TIMESTWO;
	    break;
	case S_REL:
	    result->oprs[operand].eaflags |= EAF_REL;
	    break;
	case S_ABS:
	    result->oprs[operand].eaflags |= EAF_ABS;
	    break;
	case S_BYTE:
	    result->oprs[operand].disp_size = 8;
	    result->oprs[operand].eaflags |= EAF_BYTEOFFS;
	    break;
	case P_A16:
	case P_A32:
	case P_A64:
	    if (result->prefixes[PPS_ASIZE] &&
		result->prefixes[PPS_ASIZE] != tokval.t_integer)
		error(ERR_NONFATAL,
		      "conflicting address size specifications");
	    else
		result->prefixes[PPS_ASIZE] = tokval.t_integer;
	    break;
	case S_WORD:
	    result->oprs[operand].disp_size = 16;
	    result->oprs[operand].eaflags |= EAF_WORDOFFS;
	    break;
	case S_DWORD:
	case S_LONG:
	    result->oprs[operand].disp_size = 32;
	    result->oprs[operand].eaflags |= EAF_WORDOFFS;
	    break;
	case S_QWORD:
	    result->oprs[operand].disp_size = 64;
	    result->oprs[operand].eaflags |= EAF_WORDOFFS;
	    break;
	default:
	    error(ERR_NONFATAL, "invalid size specification in"
		  " effective address");
	    break;
	}
    }
}

insn *parse_line(int pass, char *buffer, insn * result,
                 efunc errfunc, evalfunc evaluate, ldfunc ldef)
{
    int operand;
    int critical;
    struct eval_hints hints;
    int j;

    result->forw_ref = false;
    error = errfunc;

    stdscan_reset();
    stdscan_bufptr = buffer;
    i = stdscan(NULL, &tokval);

    result->label = NULL;       /* Assume no label */
    result->eops = NULL;        /* must do this, whatever happens */
    result->operands = 0;       /* must initialize this */

    if (i == 0) {               /* blank line - ignore */
        result->opcode = -1;    /* and no instruction either */
        return result;
    }
    if (i != TOKEN_ID && i != TOKEN_INSN && i != TOKEN_PREFIX &&
        (i != TOKEN_REG || (REG_SREG & ~reg_flags[tokval.t_integer]))) {
        error(ERR_NONFATAL, "label or instruction expected"
              " at start of line");
        result->opcode = -1;
        return result;
    }

    if (i == TOKEN_ID) {        /* there's a label here */
        result->label = tokval.t_charptr;
        i = stdscan(NULL, &tokval);
        if (i == ':') {         /* skip over the optional colon */
            i = stdscan(NULL, &tokval);
        } else if (i == 0) {
            error(ERR_WARNING | ERR_WARN_OL | ERR_PASS1,
                  "label alone on a line without a colon might be in error");
        }
        if (i != TOKEN_INSN || tokval.t_integer != I_EQU) {
            /*
             * FIXME: location->segment could be NO_SEG, in which case
             * it is possible we should be passing 'abs_seg'. Look into this.
             * Work out whether that is *really* what we should be doing.
             * Generally fix things. I think this is right as it is, but
             * am still not certain.
             */
            ldef(result->label, in_abs_seg ? abs_seg : location->segment,
                 location->offset, NULL, true, false, outfmt, errfunc);
        }
    }

    if (i == 0) {
        result->opcode = -1;    /* this line contains just a label */
        return result;
    }

    for (j = 0; j < MAXPREFIX; j++)
	result->prefixes[j] = P_none;
    result->times = 1L;

    while (i == TOKEN_PREFIX ||
           (i == TOKEN_REG && !(REG_SREG & ~reg_flags[tokval.t_integer])))
    {
        /*
         * Handle special case: the TIMES prefix.
         */
        if (i == TOKEN_PREFIX && tokval.t_integer == P_TIMES) {
            expr *value;

            i = stdscan(NULL, &tokval);
            value =
                evaluate(stdscan, NULL, &tokval, NULL, pass0, error, NULL);
            i = tokval.t_type;
            if (!value) {       /* but, error in evaluator */
                result->opcode = -1;    /* unrecoverable parse error: */
                return result;  /* ignore this instruction */
            }
            if (!is_simple(value)) {
                error(ERR_NONFATAL,
                      "non-constant argument supplied to TIMES");
                result->times = 1L;
            } else {
                result->times = value->value;
                if (value->value < 0) {
                    error(ERR_NONFATAL, "TIMES value %d is negative",
                          value->value);
                    result->times = 0;
                }
            }
        } else {
	    int slot = prefix_slot(tokval.t_integer);
	    if (result->prefixes[slot]) {
               if (result->prefixes[slot] == tokval.t_integer)
 		    error(ERR_WARNING,
		      "instruction has redundant prefixes");
               else
		    error(ERR_NONFATAL,
		      "instruction has conflicting prefixes");
	    }
	    result->prefixes[slot] = tokval.t_integer;
            i = stdscan(NULL, &tokval);
        }
    }

    if (i != TOKEN_INSN) {
	int j;
	enum prefixes pfx;

	for (j = 0; j < MAXPREFIX; j++)
	    if ((pfx = result->prefixes[j]) != P_none)
		break;

        if (i == 0 && pfx != P_none) {
            /*
             * Instruction prefixes are present, but no actual
             * instruction. This is allowed: at this point we
             * invent a notional instruction of RESB 0.
             */
            result->opcode = I_RESB;
            result->operands = 1;
            result->oprs[0].type = IMMEDIATE;
            result->oprs[0].offset = 0L;
            result->oprs[0].segment = result->oprs[0].wrt = NO_SEG;
            return result;
        } else {
            error(ERR_NONFATAL, "parser: instruction expected");
            result->opcode = -1;
            return result;
        }
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
    if (result->opcode == I_RESB || result->opcode == I_RESW ||
	result->opcode == I_RESD || result->opcode == I_RESQ ||
	result->opcode == I_REST || result->opcode == I_RESO ||
	result->opcode == I_EQU || result->opcode == I_INCBIN) {
        critical = pass0;
    } else
        critical = (pass == 2 ? 2 : 0);

    if (result->opcode == I_DB || result->opcode == I_DW ||
        result->opcode == I_DD || result->opcode == I_DQ ||
        result->opcode == I_DT || result->opcode == I_DO ||
	result->opcode == I_INCBIN) {
        extop *eop, **tail = &result->eops, **fixptr;
        int oper_num = 0;

        result->eops_float = false;

        /*
         * Begin to read the DB/DW/DD/DQ/DT/DO/INCBIN operands.
         */
        while (1) {
            i = stdscan(NULL, &tokval);
            if (i == 0)
                break;
            fixptr = tail;
            eop = *tail = nasm_malloc(sizeof(extop));
            tail = &eop->next;
            eop->next = NULL;
            eop->type = EOT_NOTHING;
            oper_num++;

            if (i == TOKEN_NUM && tokval.t_charptr && is_comma_next()) {
                eop->type = EOT_DB_STRING;
                eop->stringval = tokval.t_charptr;
                eop->stringlen = tokval.t_inttwo;
                i = stdscan(NULL, &tokval);     /* eat the comma */
                continue;
            }

            if ((i == TOKEN_FLOAT && is_comma_next())
		|| i == '-' || i == '+') {
                int32_t sign = +1;

                if (i == '+' || i == '-') {
                    char *save = stdscan_bufptr;
		    int token = i;
		    sign = (i == '-') ? -1 : 1;
                    i = stdscan(NULL, &tokval);
                    if (i != TOKEN_FLOAT || !is_comma_next()) {
                        stdscan_bufptr = save;
                        i = tokval.t_type = token;
                    }
                }

                if (i == TOKEN_FLOAT) {
                    eop->type = EOT_DB_STRING;
                    result->eops_float = true;
		    switch (result->opcode) {
		    case I_DB:
			eop->stringlen = 1;
			break;
		    case I_DW:
			eop->stringlen = 2;
			break;
		    case I_DD:
                        eop->stringlen = 4;
			break;
		    case I_DQ:
                        eop->stringlen = 8;
			break;
		    case I_DT:
                        eop->stringlen = 10;
			break;
		    case I_DO:
                        eop->stringlen = 16;
			break;
		    default:
                        error(ERR_NONFATAL, "floating-point constant"
                              " encountered in unknown instruction");
                        /*
                         * fix suggested by Pedro Gimeno... original line
                         * was:
                         * eop->type = EOT_NOTHING;
                         */
                        eop->stringlen = 0;
			break;
                    }
                    eop = nasm_realloc(eop, sizeof(extop) + eop->stringlen);
                    tail = &eop->next;
                    *fixptr = eop;
                    eop->stringval = (char *)eop + sizeof(extop);
                    if (!eop->stringlen ||
                        !float_const(tokval.t_charptr, sign,
                                     (uint8_t *)eop->stringval,
                                     eop->stringlen, error))
                        eop->type = EOT_NOTHING;
                    i = stdscan(NULL, &tokval); /* eat the comma */
                    continue;
                }
            }

            /* anything else */
            {
                expr *value;
                value = evaluate(stdscan, NULL, &tokval, NULL,
                                 critical, error, NULL);
                i = tokval.t_type;
                if (!value) {   /* error in evaluator */
                    result->opcode = -1;        /* unrecoverable parse error: */
                    return result;      /* ignore this instruction */
                }
                if (is_unknown(value)) {
                    eop->type = EOT_DB_NUMBER;
                    eop->offset = 0;    /* doesn't matter what we put */
                    eop->segment = eop->wrt = NO_SEG;   /* likewise */
                } else if (is_reloc(value)) {
                    eop->type = EOT_DB_NUMBER;
                    eop->offset = reloc_value(value);
                    eop->segment = reloc_seg(value);
                    eop->wrt = reloc_wrt(value);
                } else {
                    error(ERR_NONFATAL,
                          "operand %d: expression is not simple"
                          " or relocatable", oper_num);
                }
            }

            /*
             * We're about to call stdscan(), which will eat the
             * comma that we're currently sitting on between
             * arguments. However, we'd better check first that it
             * _is_ a comma.
             */
            if (i == 0)         /* also could be EOL */
                break;
            if (i != ',') {
                error(ERR_NONFATAL, "comma expected after operand %d",
                      oper_num);
                result->opcode = -1;    /* unrecoverable parse error: */
                return result;  /* ignore this instruction */
            }
        }

        if (result->opcode == I_INCBIN) {
            /*
             * Correct syntax for INCBIN is that there should be
             * one string operand, followed by one or two numeric
             * operands.
             */
            if (!result->eops || result->eops->type != EOT_DB_STRING)
                error(ERR_NONFATAL, "`incbin' expects a file name");
            else if (result->eops->next &&
                     result->eops->next->type != EOT_DB_NUMBER)
                error(ERR_NONFATAL, "`incbin': second parameter is",
                      " non-numeric");
            else if (result->eops->next && result->eops->next->next &&
                     result->eops->next->next->type != EOT_DB_NUMBER)
                error(ERR_NONFATAL, "`incbin': third parameter is",
                      " non-numeric");
            else if (result->eops->next && result->eops->next->next &&
                     result->eops->next->next->next)
                error(ERR_NONFATAL,
                      "`incbin': more than three parameters");
            else
                return result;
            /*
             * If we reach here, one of the above errors happened.
             * Throw the instruction away.
             */
            result->opcode = -1;
            return result;
        } else /* DB ... */ if (oper_num == 0)
            error(ERR_WARNING | ERR_PASS1,
                  "no operand for data declaration");
        else
            result->operands = oper_num;

        return result;
    }

    /* right. Now we begin to parse the operands. There may be up to four
     * of these, separated by commas, and terminated by a zero token. */

    for (operand = 0; operand < MAX_OPERANDS; operand++) {
	expr *value;		/* used most of the time */
        int mref;               /* is this going to be a memory ref? */
        int bracket;            /* is it a [] mref, or a & mref? */
        int setsize = 0;

        result->oprs[operand].disp_size = 0;    /* have to zero this whatever */
        result->oprs[operand].eaflags = 0;      /* and this */
        result->oprs[operand].opflags = 0;

        i = stdscan(NULL, &tokval);
        if (i == 0)
            break;              /* end of operands: get out of here */
        result->oprs[operand].type = 0; /* so far, no override */
        while (i == TOKEN_SPECIAL) {    /* size specifiers */
            switch ((int)tokval.t_integer) {
            case S_BYTE:
                if (!setsize)   /* we want to use only the first */
                    result->oprs[operand].type |= BITS8;
                setsize = 1;
                break;
            case S_WORD:
                if (!setsize)
                    result->oprs[operand].type |= BITS16;
                setsize = 1;
                break;
            case S_DWORD:
            case S_LONG:
                if (!setsize)
                    result->oprs[operand].type |= BITS32;
                setsize = 1;
                break;
            case S_QWORD:
                if (!setsize)
                    result->oprs[operand].type |= BITS64;
                setsize = 1;
                break;
            case S_TWORD:
                if (!setsize)
                    result->oprs[operand].type |= BITS80;
                setsize = 1;
                break;
            case S_OWORD:
                if (!setsize)
                    result->oprs[operand].type |= BITS128;
                setsize = 1;
                break;
            case S_TO:
                result->oprs[operand].type |= TO;
                break;
            case S_STRICT:
                result->oprs[operand].type |= STRICT;
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
            default:
                error(ERR_NONFATAL, "invalid operand size specification");
            }
            i = stdscan(NULL, &tokval);
        }

        if (i == '[' || i == '&') {     /* memory reference */
            mref = true;
            bracket = (i == '[');
            i = stdscan(NULL, &tokval); /* then skip the colon */
            while (i == TOKEN_SPECIAL || i == TOKEN_PREFIX) {
		process_size_override(result, operand);
                i = stdscan(NULL, &tokval);
            }
        } else {                /* immediate operand, or register */
            mref = false;
            bracket = false;    /* placate optimisers */
        }

        if ((result->oprs[operand].type & FAR) && !mref &&
            result->opcode != I_JMP && result->opcode != I_CALL) {
            error(ERR_NONFATAL, "invalid use of FAR operand specifier");
        }

        value = evaluate(stdscan, NULL, &tokval,
                         &result->oprs[operand].opflags,
                         critical, error, &hints);
        i = tokval.t_type;
        if (result->oprs[operand].opflags & OPFLAG_FORWARD) {
            result->forw_ref = true;
        }
        if (!value) {           /* error in evaluator */
            result->opcode = -1;        /* unrecoverable parse error: */
            return result;      /* ignore this instruction */
        }
        if (i == ':' && mref) { /* it was seg:offset */
            /*
             * Process the segment override.
             */
            if (value[1].type != 0 || value->value != 1 ||
                REG_SREG & ~reg_flags[value->type])
                error(ERR_NONFATAL, "invalid segment override");
            else if (result->prefixes[PPS_SEG])
                error(ERR_NONFATAL,
                      "instruction has conflicting segment overrides");
            else {
		result->prefixes[PPS_SEG] = value->type;
		if (!(REG_FSGS & ~reg_flags[value->type]))
		    result->oprs[operand].eaflags |= EAF_FSGS;
	    }

            i = stdscan(NULL, &tokval); /* then skip the colon */
            while (i == TOKEN_SPECIAL || i == TOKEN_PREFIX) {
		process_size_override(result, operand);
                i = stdscan(NULL, &tokval);
            }
            value = evaluate(stdscan, NULL, &tokval,
                             &result->oprs[operand].opflags,
                             critical, error, &hints);
            i = tokval.t_type;
            if (result->oprs[operand].opflags & OPFLAG_FORWARD) {
                result->forw_ref = true;
            }
            /* and get the offset */
            if (!value) {       /* but, error in evaluator */
                result->opcode = -1;    /* unrecoverable parse error: */
                return result;  /* ignore this instruction */
            }
        }
        if (mref && bracket) {  /* find ] at the end */
            if (i != ']') {
                error(ERR_NONFATAL, "parser: expecting ]");
                do {            /* error recovery again */
                    i = stdscan(NULL, &tokval);
                } while (i != 0 && i != ',');
            } else              /* we got the required ] */
                i = stdscan(NULL, &tokval);
        } else {                /* immediate operand */
            if (i != 0 && i != ',' && i != ':') {
                error(ERR_NONFATAL, "comma or end of line expected");
                do {            /* error recovery */
                    i = stdscan(NULL, &tokval);
                } while (i != 0 && i != ',');
            } else if (i == ':') {
                result->oprs[operand].type |= COLON;
            }
        }

        /* now convert the exprs returned from evaluate() into operand
         * descriptions... */

        if (mref) {             /* it's a memory reference */
            expr *e = value;
            int b, i, s;        /* basereg, indexreg, scale */
            int64_t o;             /* offset */

            b = i = -1, o = s = 0;
            result->oprs[operand].hintbase = hints.base;
            result->oprs[operand].hinttype = hints.type;

            if (e->type && e->type <= EXPR_REG_END) {   /* this bit's a register */
                if (e->value == 1)      /* in fact it can be basereg */
                    b = e->type;
                else            /* no, it has to be indexreg */
                    i = e->type, s = e->value;
                e++;
            }
            if (e->type && e->type <= EXPR_REG_END) {   /* it's a 2nd register */
                if (b != -1)    /* If the first was the base, ... */
                    i = e->type, s = e->value;  /* second has to be indexreg */

                else if (e->value != 1) {       /* If both want to be index */
                    error(ERR_NONFATAL,
                          "beroset-p-592-invalid effective address");
                    result->opcode = -1;
                    return result;
                } else
                    b = e->type;
                e++;
            }
            if (e->type != 0) { /* is there an offset? */
                if (e->type <= EXPR_REG_END) {  /* in fact, is there an error? */
                    error(ERR_NONFATAL,
                          "beroset-p-603-invalid effective address");
                    result->opcode = -1;
                    return result;
                } else {
                    if (e->type == EXPR_UNKNOWN) {
                        o = 0;  /* doesn't matter what */
                        result->oprs[operand].wrt = NO_SEG;     /* nor this */
                        result->oprs[operand].segment = NO_SEG; /* or this */
                        while (e->type)
                            e++;        /* go to the end of the line */
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
                            error(ERR_NONFATAL,
                                  "beroset-p-630-invalid effective address");
                            result->opcode = -1;
                            return result;
                        }
                        while (e->type && e->value == 0)
                            e++;
                        if (e->type && e->value != 1) {
                            error(ERR_NONFATAL,
                                  "beroset-p-637-invalid effective address");
                            result->opcode = -1;
                            return result;
                        }
                        if (e->type) {
                            result->oprs[operand].segment =
                                e->type - EXPR_SEGBASE;
                            e++;
                        } else
                            result->oprs[operand].segment = NO_SEG;
                        while (e->type && e->value == 0)
                            e++;
                        if (e->type) {
                            error(ERR_NONFATAL,
                                  "beroset-p-650-invalid effective address");
                            result->opcode = -1;
                            return result;
                        }
                    }
                }
            } else {
                o = 0;
                result->oprs[operand].wrt = NO_SEG;
                result->oprs[operand].segment = NO_SEG;
            }

            if (e->type != 0) { /* there'd better be nothing left! */
                error(ERR_NONFATAL,
                      "beroset-p-663-invalid effective address");
                result->opcode = -1;
                return result;
            }

	    /* It is memory, but it can match any r/m operand */
            result->oprs[operand].type |= MEMORY_ANY;

	    if (b == -1 && (i == -1 || s == 0)) {
		int is_rel = globalbits == 64 &&
		    !(result->oprs[operand].eaflags & EAF_ABS) &&
		    ((globalrel &&
		      !(result->oprs[operand].eaflags & EAF_FSGS)) ||
		     (result->oprs[operand].eaflags & EAF_REL));

		result->oprs[operand].type |= is_rel ? IP_REL : MEM_OFFS;
	    }
            result->oprs[operand].basereg = b;
            result->oprs[operand].indexreg = i;
            result->oprs[operand].scale = s;
            result->oprs[operand].offset = o;
        } else {                /* it's not a memory reference */

            if (is_just_unknown(value)) {       /* it's immediate but unknown */
                result->oprs[operand].type |= IMMEDIATE;
                result->oprs[operand].offset = 0;       /* don't care */
                result->oprs[operand].segment = NO_SEG; /* don't care again */
                result->oprs[operand].wrt = NO_SEG;     /* still don't care */
            } else if (is_reloc(value)) {       /* it's immediate */
                result->oprs[operand].type |= IMMEDIATE;
                result->oprs[operand].offset = reloc_value(value);
                result->oprs[operand].segment = reloc_seg(value);
                result->oprs[operand].wrt = reloc_wrt(value);
                if (is_simple(value)) {
                    if (reloc_value(value) == 1)
                        result->oprs[operand].type |= UNITY;
                    if (optimizing >= 0 &&
                        !(result->oprs[operand].type & STRICT)) {
                        if (reloc_value(value) >= -128 &&
                            reloc_value(value) <= 127)
                            result->oprs[operand].type |= SBYTE;
                    }
                }
            } else {            /* it's a register */

                if (value->type >= EXPR_SIMPLE || value->value != 1) {
                    error(ERR_NONFATAL, "invalid operand type");
                    result->opcode = -1;
                    return result;
                }

                /*
                 * check that its only 1 register, not an expression...
                 */
                for (i = 1; value[i].type; i++)
                    if (value[i].value) {
                        error(ERR_NONFATAL, "invalid operand type");
                        result->opcode = -1;
                        return result;
                    }

                /* clear overrides, except TO which applies to FPU regs */
                if (result->oprs[operand].type & ~TO) {
                    /*
                     * we want to produce a warning iff the specified size
                     * is different from the register size
                     */
                    i = result->oprs[operand].type & SIZE_MASK;
                } else
                    i = 0;

                result->oprs[operand].type &= TO;
                result->oprs[operand].type |= REGISTER;
                result->oprs[operand].type |= reg_flags[value->type];
                result->oprs[operand].basereg = value->type;

                if (i && (result->oprs[operand].type & SIZE_MASK) != i)
                    error(ERR_WARNING | ERR_PASS1,
                          "register size specification ignored");
            }
        }
    }

    result->operands = operand; /* set operand count */

/* clear remaining operands */
while (operand < MAX_OPERANDS)
    result->oprs[operand++].type = 0;

    /*
     * Transform RESW, RESD, RESQ, REST, RESO into RESB.
     */
    switch (result->opcode) {
    case I_RESW:
        result->opcode = I_RESB;
        result->oprs[0].offset *= 2;
        break;
    case I_RESD:
        result->opcode = I_RESB;
        result->oprs[0].offset *= 4;
        break;
    case I_RESQ:
        result->opcode = I_RESB;
        result->oprs[0].offset *= 8;
        break;
    case I_REST:
        result->opcode = I_RESB;
        result->oprs[0].offset *= 10;
        break;
    case I_RESO:
        result->opcode = I_RESB;
        result->oprs[0].offset *= 16;
        break;
    default:
	break;
    }

    return result;
}

static int is_comma_next(void)
{
    char *p;
    int i;
    struct tokenval tv;

    p = stdscan_bufptr;
    i = stdscan(NULL, &tv);
    stdscan_bufptr = p;
    return (i == ',' || i == ';' || !i);
}

void cleanup_insn(insn * i)
{
    extop *e;

    while (i->eops) {
        e = i->eops;
        i->eops = i->eops->next;
        nasm_free(e);
    }
}
