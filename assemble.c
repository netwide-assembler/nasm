/* assemble.c   code generation for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * the actual codes (C syntax, i.e. octal):
 * \0            - terminates the code. (Unless it's a literal of course.)
 * \1, \2, \3    - that many literal bytes follow in the code stream
 * \4, \6        - the POP/PUSH (respectively) codes for CS, DS, ES, SS
 *                 (POP is never used for CS) depending on operand 0
 * \5, \7        - the second byte of POP/PUSH codes for FS, GS, depending
 *                 on operand 0
 * \10..\13      - a literal byte follows in the code stream, to be added
 *                 to the register value of operand 0..3
 * \14..\17      - a signed byte immediate operand, from operand 0..3
 * \20..\23      - a byte immediate operand, from operand 0..3
 * \24..\27      - an unsigned byte immediate operand, from operand 0..3
 * \30..\33      - a word immediate operand, from operand 0..3
 * \34..\37      - select between \3[0-3] and \4[0-3] depending on 16/32 bit
 *                 assembly mode or the operand-size override on the operand
 * \40..\43      - a long immediate operand, from operand 0..3
 * \44..\47      - select between \3[0-3], \4[0-3] and \5[4-7]
 *		   depending on the address size of the instruction.
 * \50..\53      - a byte relative operand, from operand 0..3
 * \54..\57      - a qword immediate operand, from operand 0..3
 * \60..\63      - a word relative operand, from operand 0..3
 * \64..\67      - select between \6[0-3] and \7[0-3] depending on 16/32 bit
 *                 assembly mode or the operand-size override on the operand
 * \70..\73      - a long relative operand, from operand 0..3
 * \74..\77       - a word constant, from the _segment_ part of operand 0..3
 * \1ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field the register value of operand b.
 * \140..\143    - an immediate word or signed byte for operand 0..3
 * \144..\147    - or 2 (s-field) into next opcode byte if operand 0..3
 *		    is a signed byte rather than a word.
 * \150..\153     - an immediate dword or signed byte for operand 0..3
 * \154..\157     - or 2 (s-field) into next opcode byte if operand 0..3
 *		    is a signed byte rather than a dword.
 * \160..\163    - this instruction uses DREX rather than REX, with the
 *		   OC0 field set to 0, and the dest field taken from
 *                 operand 0..3.
 * \164..\167    - this instruction uses DREX rather than REX, with the
 *		   OC0 field set to 1, and the dest field taken from
 *                 operand 0..3.
 * \170          - encodes the literal byte 0. (Some compilers don't take
 *                 kindly to a zero byte in the _middle_ of a compile time
 *                 string constant, so I had to put this hack in.)
 * \171		 - placement of DREX suffix in the absence of an EA
 * \2ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field equal to digit b.
 * \310          - indicates fixed 16-bit address size, i.e. optional 0x67.
 * \311          - indicates fixed 32-bit address size, i.e. optional 0x67.
 * \312          - (disassembler only) marker on LOOP, LOOPxx instructions.
 * \313          - indicates fixed 64-bit address size, 0x67 invalid.
 * \320          - indicates fixed 16-bit operand size, i.e. optional 0x66.
 * \321          - indicates fixed 32-bit operand size, i.e. optional 0x66.
 * \322          - indicates that this instruction is only valid when the
 *                 operand size is the default (instruction to disassembler,
 *                 generates no code in the assembler)
 * \323          - indicates fixed 64-bit operand size, REX on extensions only.
 * \324          - indicates 64-bit operand size requiring REX prefix.
 * \330          - a literal byte follows in the code stream, to be added
 *                 to the condition code value of the instruction.
 * \331          - instruction not valid with REP prefix.  Hint for
 *                 disassembler only; for SSE instructions.
 * \332          - REP prefix (0xF2 byte) used as opcode extension.
 * \333          - REP prefix (0xF3 byte) used as opcode extension.
 * \334          - LOCK prefix used instead of REX.R
 * \335          - disassemble a rep (0xF3 byte) prefix as repe not rep.
 * \340          - reserve <operand 0> bytes of uninitialized storage.
 *                 Operand 0 had better be a segmentless constant.
 * \364          - operand-size prefix (0x66) not permitted
 * \365          - address-size prefix (0x67) not permitted
 * \366          - operand-size prefix (0x66) used as opcode extension
 * \367          - address-size prefix (0x67) used as opcode extension
 * \370,\371,\372 - match only if operand 0 meets byte jump criteria.
 *		   370 is used for Jcc, 371 is used for JMP.
 * \373		 - assemble 0x03 if bits==16, 0x05 if bits==32;
 *		   used for conditional jump over longer jump
 */

#include "compiler.h"

#include <stdio.h>
#include <string.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "assemble.h"
#include "insns.h"
#include "preproc.h"
#include "regflags.c"
#include "regvals.c"

typedef struct {
    int sib_present;                 /* is a SIB byte necessary? */
    int bytes;                       /* # of bytes of offset needed */
    int size;                        /* lazy - this is sib+bytes+1 */
    uint8_t modrm, sib, rex, rip;    /* the bytes themselves */
} ea;

static uint32_t cpu;            /* cpu level received from nasm.c */
static efunc errfunc;
static struct ofmt *outfmt;
static ListGen *list;

static int32_t calcsize(int32_t, int32_t, int, insn *, const char *);
static void gencode(int32_t, int32_t, int, insn *, const char *, int32_t);
static int matches(const struct itemplate *, insn *, int bits);
static int32_t regflag(const operand *);
static int32_t regval(const operand *);
static int rexflags(int, int32_t, int);
static int op_rexflags(const operand *, int);
static ea *process_ea(operand *, ea *, int, int, int, int32_t, int);
static void add_asp(insn *, int);

static int has_prefix(insn * ins, enum prefix_pos pos, enum prefixes prefix)
{
    return ins->prefixes[pos] == prefix;
}

static void assert_no_prefix(insn * ins, enum prefix_pos pos)
{
    if (ins->prefixes[pos])
	errfunc(ERR_NONFATAL, "invalid %s prefix",
		prefix_name(ins->prefixes[pos]));
}

static const char *size_name(int size)
{
    switch (size) {
    case 1:
	return "byte";
    case 2:
	return "word";
    case 4:
	return "dword";
    case 8:
	return "qword";
    case 10:
	return "tword";
    case 16:
	return "oword";
    default:
	return "???";
    }
}

static void warn_overflow(int size, int64_t data)
{
    if (size < 8) {
	int64_t lim = (1 << (size*8))-1;

	if (data < ~lim || data > lim)
	    errfunc(ERR_WARNING, "%s data exceeds bounds", size_name(size));
    }
}
/*
 * This routine wrappers the real output format's output routine,
 * in order to pass a copy of the data off to the listing file
 * generator at the same time.
 */
static void out(int32_t offset, int32_t segto, const void *data,
                uint32_t type, int32_t segment, int32_t wrt)
{
    static int32_t lineno = 0;     /* static!!! */
    static char *lnfname = NULL;

    if ((type & OUT_TYPMASK) == OUT_ADDRESS) {
        if (segment != NO_SEG || wrt != NO_SEG) {
            /*
             * This address is relocated. We must write it as
             * OUT_ADDRESS, so there's no work to be done here.
             */
            list->output(offset, data, type);
        } else {
            uint8_t p[8], *q = p;
            /*
             * This is a non-relocated address, and we're going to
             * convert it into RAWDATA format.
             */
            if ((type & OUT_SIZMASK) == 4) {
                WRITELONG(q, *(int32_t *)data);
                list->output(offset, p, OUT_RAWDATA + 4);
            } else if ((type & OUT_SIZMASK) == 8) {
                WRITEDLONG(q, *(int64_t *)data);
                list->output(offset, p, OUT_RAWDATA + 8);
            } else {
                WRITESHORT(q, *(int32_t *)data);
                list->output(offset, p, OUT_RAWDATA + 2);
            }
        }
    } else if ((type & OUT_TYPMASK) == OUT_RAWDATA) {
        list->output(offset, data, type);
    } else if ((type & OUT_TYPMASK) == OUT_RESERVE) {
        list->output(offset, NULL, type);
    } else if ((type & OUT_TYPMASK) == OUT_REL2ADR ||
               (type & OUT_TYPMASK) == OUT_REL4ADR) {
        list->output(offset, data, type);
    }

    /*
     * this call to src_get determines when we call the
     * debug-format-specific "linenum" function
     * it updates lineno and lnfname to the current values
     * returning 0 if "same as last time", -2 if lnfname
     * changed, and the amount by which lineno changed,
     * if it did. thus, these variables must be static
     */

    if (src_get(&lineno, &lnfname)) {
        outfmt->current_dfmt->linenum(lnfname, lineno, segto);
    }

    outfmt->output(segto, data, type, segment, wrt);
}

static int jmp_match(int32_t segment, int32_t offset, int bits,
                     insn * ins, const char *code)
{
    int32_t isize;
    uint8_t c = code[0];

    if (c != 0370 && c != 0371)
        return 0;
    if (ins->oprs[0].opflags & OPFLAG_FORWARD) {
        if ((optimizing < 0 || (ins->oprs[0].type & STRICT))
            && c == 0370)
            return 1;
        else
            return (pass0 == 0);        /* match a forward reference */
    }
    isize = calcsize(segment, offset, bits, ins, code);
    if (ins->oprs[0].segment != segment)
        return 0;
    isize = ins->oprs[0].offset - offset - isize;       /* isize is now the delta */
    if (isize >= -128L && isize <= 127L)
        return 1;               /* it is byte size */

    return 0;
}

int32_t assemble(int32_t segment, int32_t offset, int bits, uint32_t cp,
              insn * instruction, struct ofmt *output, efunc error,
              ListGen * listgen)
{
    const struct itemplate *temp;
    int j;
    int size_prob;
    int32_t insn_end;
    int32_t itimes;
    int32_t start = offset;
    int32_t wsize = 0;             /* size for DB etc. */

    errfunc = error;            /* to pass to other functions */
    cpu = cp;
    outfmt = output;            /* likewise */
    list = listgen;             /* and again */

    switch (instruction->opcode) {
    case -1:
        return 0;
    case I_DB:
        wsize = 1;
        break;
    case I_DW:
        wsize = 2;
        break;
    case I_DD:
        wsize = 4;
        break;
    case I_DQ:
        wsize = 8;
        break;
    case I_DT:
        wsize = 10;
        break;
    case I_DO:
	wsize = 16;
	break;
    default:
	break;
    }

    if (wsize) {
        extop *e;
        int32_t t = instruction->times;
        if (t < 0)
            errfunc(ERR_PANIC,
                    "instruction->times < 0 (%ld) in assemble()", t);

        while (t--) {           /* repeat TIMES times */
            for (e = instruction->eops; e; e = e->next) {
                if (e->type == EOT_DB_NUMBER) {
                    if (wsize == 1) {
                        if (e->segment != NO_SEG)
                            errfunc(ERR_NONFATAL,
                                    "one-byte relocation attempted");
                        else {
                            uint8_t out_byte = e->offset;
                            out(offset, segment, &out_byte,
                                OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                        }
                    } else if (wsize > 8) {
                        errfunc(ERR_NONFATAL, "integer supplied to a DT or DO"
                                " instruction");
                    } else
                        out(offset, segment, &e->offset,
                            OUT_ADDRESS + wsize, e->segment, e->wrt);
                    offset += wsize;
                } else if (e->type == EOT_DB_STRING) {
                    int align;

                    out(offset, segment, e->stringval,
                        OUT_RAWDATA + e->stringlen, NO_SEG, NO_SEG);
                    align = e->stringlen % wsize;

                    if (align) {
                        align = wsize - align;
                        out(offset, segment, "\0\0\0\0\0\0\0\0",
                            OUT_RAWDATA + align, NO_SEG, NO_SEG);
                    }
                    offset += e->stringlen + align;
                }
            }
            if (t > 0 && t == instruction->times - 1) {
                /*
                 * Dummy call to list->output to give the offset to the
                 * listing module.
                 */
                list->output(offset, NULL, OUT_RAWDATA);
                list->uplevel(LIST_TIMES);
            }
        }
        if (instruction->times > 1)
            list->downlevel(LIST_TIMES);
        return offset - start;
    }

    if (instruction->opcode == I_INCBIN) {
        static char fname[FILENAME_MAX];
        FILE *fp;
        int32_t len;
        char *prefix = "", *combine;
        char **pPrevPath = NULL;

        len = FILENAME_MAX - 1;
        if (len > instruction->eops->stringlen)
            len = instruction->eops->stringlen;
        strncpy(fname, instruction->eops->stringval, len);
        fname[len] = '\0';

        while (1) {         /* added by alexfru: 'incbin' uses include paths */
            combine = nasm_malloc(strlen(prefix) + len + 1);
            strcpy(combine, prefix);
            strcat(combine, fname);

            if ((fp = fopen(combine, "rb")) != NULL) {
                nasm_free(combine);
                break;
            }

            nasm_free(combine);
            pPrevPath = pp_get_include_path_ptr(pPrevPath);
            if (pPrevPath == NULL)
                break;
            prefix = *pPrevPath;
        }

        if (fp == NULL)
            error(ERR_NONFATAL, "`incbin': unable to open file `%s'",
                  fname);
        else if (fseek(fp, 0L, SEEK_END) < 0)
            error(ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
                  fname);
        else {
            static char buf[2048];
            int32_t t = instruction->times;
            int32_t base = 0;

            len = ftell(fp);
            if (instruction->eops->next) {
                base = instruction->eops->next->offset;
                len -= base;
                if (instruction->eops->next->next &&
                    len > instruction->eops->next->next->offset)
                    len = instruction->eops->next->next->offset;
            }
            /*
             * Dummy call to list->output to give the offset to the
             * listing module.
             */
            list->output(offset, NULL, OUT_RAWDATA);
            list->uplevel(LIST_INCBIN);
            while (t--) {
                int32_t l;

                fseek(fp, base, SEEK_SET);
                l = len;
                while (l > 0) {
                    int32_t m =
                        fread(buf, 1, (l > (int32_t) sizeof(buf) ? (int32_t) sizeof(buf) : l),
                              fp);
                    if (!m) {
                        /*
                         * This shouldn't happen unless the file
                         * actually changes while we are reading
                         * it.
                         */
                        error(ERR_NONFATAL,
                              "`incbin': unexpected EOF while"
                              " reading file `%s'", fname);
                        t = 0;  /* Try to exit cleanly */
                        break;
                    }
                    out(offset, segment, buf, OUT_RAWDATA + m,
                        NO_SEG, NO_SEG);
                    l -= m;
                }
            }
            list->downlevel(LIST_INCBIN);
            if (instruction->times > 1) {
                /*
                 * Dummy call to list->output to give the offset to the
                 * listing module.
                 */
                list->output(offset, NULL, OUT_RAWDATA);
                list->uplevel(LIST_TIMES);
                list->downlevel(LIST_TIMES);
            }
            fclose(fp);
            return instruction->times * len;
        }
        return 0;               /* if we're here, there's an error */
    }

    /* Check to see if we need an address-size prefix */
    add_asp(instruction, bits);

    size_prob = false;

    for (temp = nasm_instructions[instruction->opcode]; temp->opcode != -1; temp++){
        int m = matches(temp, instruction, bits);

        if (m == 99)
            m += jmp_match(segment, offset, bits, instruction, temp->code);

        if (m == 100) {         /* matches! */
            const char *codes = temp->code;
            int32_t insn_size = calcsize(segment, offset, bits,
                                      instruction, codes);
            itimes = instruction->times;
            if (insn_size < 0)  /* shouldn't be, on pass two */
                error(ERR_PANIC, "errors made it through from pass one");
            else
                while (itimes--) {
                    for (j = 0; j < MAXPREFIX; j++) {
                        uint8_t c = 0;
                        switch (instruction->prefixes[j]) {
                        case P_LOCK:
                            c = 0xF0;
                            break;
                        case P_REPNE:
                        case P_REPNZ:
                            c = 0xF2;
                            break;
                        case P_REPE:
                        case P_REPZ:
                        case P_REP:
                            c = 0xF3;
                            break;
                        case R_CS:
                            if (bits == 64) {
                                error(ERR_WARNING,
                                      "cs segment base ignored in 64-bit mode");
                            }
                            c = 0x2E;
                            break;
                        case R_DS:
                            if (bits == 64) {
                                error(ERR_WARNING,
                                      "ds segment base ignored in 64-bit mode");
                            }
                            c = 0x3E;
                            break;
                        case R_ES:
                           if (bits == 64) {
                                error(ERR_WARNING,
                                      "es segment base ignored in 64-bit mode");
                           }
                            c = 0x26;
                            break;
                        case R_FS:
                            c = 0x64;
                            break;
                        case R_GS:
                            c = 0x65;
                            break;
                        case R_SS:
                            if (bits == 64) {
                                error(ERR_WARNING,
                                      "ss segment base ignored in 64-bit mode");
                            }
                            c = 0x36;
                            break;
                        case R_SEGR6:
                        case R_SEGR7:
                            error(ERR_NONFATAL,
                                  "segr6 and segr7 cannot be used as prefixes");
                            break;
                        case P_A16:
                            if (bits == 64) {
                                error(ERR_NONFATAL,
				      "16-bit addressing is not supported "
				      "in 64-bit mode");
                            } else if (bits != 16)
                                c = 0x67;
                            break;
                        case P_A32:
                            if (bits != 32)
                                c = 0x67;
                            break;
			case P_A64:
			    if (bits != 64) {
				error(ERR_NONFATAL,
				      "64-bit addressing is only supported "
				      "in 64-bit mode");
			    }
			    break;
			case P_ASP:
			    c = 0x67;
			    break;
                        case P_O16:
                            if (bits != 16)
                                c = 0x66;
                            break;
                        case P_O32:
                            if (bits == 16)
                                c = 0x66;
                            break;
			case P_O64:
			    /* REX.W */
			    break;
			case P_OSP:
			    c = 0x66;
			    break;
			case P_none:
			    break;
                        default:
                            error(ERR_PANIC, "invalid instruction prefix");
                        }
                        if (c != 0) {
                            out(offset, segment, &c, OUT_RAWDATA + 1,
                                NO_SEG, NO_SEG);
                            offset++;
                        }
                    }
                    insn_end = offset + insn_size;
                    gencode(segment, offset, bits, instruction, codes,
                            insn_end);
                    offset += insn_size;
                    if (itimes > 0 && itimes == instruction->times - 1) {
                        /*
                         * Dummy call to list->output to give the offset to the
                         * listing module.
                         */
                        list->output(offset, NULL, OUT_RAWDATA);
                        list->uplevel(LIST_TIMES);
                    }
                }
            if (instruction->times > 1)
                list->downlevel(LIST_TIMES);
            return offset - start;
        } else if (m > 0 && m > size_prob) {
            size_prob = m;
        }
//        temp++;
    }

    if (temp->opcode == -1) {   /* didn't match any instruction */
	switch (size_prob) {
	case 1:
	    error(ERR_NONFATAL, "operation size not specified");
	    break;
	case 2:
            error(ERR_NONFATAL, "mismatch in operand sizes");
	    break;
	case 3:
            error(ERR_NONFATAL, "no instruction for this cpu level");
	    break;
	case 4:
            error(ERR_NONFATAL, "instruction not supported in 64-bit mode");
	    break;
	default:
            error(ERR_NONFATAL,
                  "invalid combination of opcode and operands");
	    break;
	}
    }
    return 0;
}

int32_t insn_size(int32_t segment, int32_t offset, int bits, uint32_t cp,
               insn * instruction, efunc error)
{
    const struct itemplate *temp;

    errfunc = error;            /* to pass to other functions */
    cpu = cp;

    if (instruction->opcode == -1)
        return 0;

    if (instruction->opcode == I_DB || instruction->opcode == I_DW ||
        instruction->opcode == I_DD || instruction->opcode == I_DQ ||
	instruction->opcode == I_DT || instruction->opcode == I_DO) {
        extop *e;
        int32_t isize, osize, wsize = 0;   /* placate gcc */

        isize = 0;
        switch (instruction->opcode) {
        case I_DB:
            wsize = 1;
            break;
        case I_DW:
            wsize = 2;
            break;
        case I_DD:
            wsize = 4;
            break;
        case I_DQ:
            wsize = 8;
            break;
        case I_DT:
            wsize = 10;
            break;
	case I_DO:
	    wsize = 16;
	    break;
	default:
	    break;
        }

        for (e = instruction->eops; e; e = e->next) {
            int32_t align;

            osize = 0;
            if (e->type == EOT_DB_NUMBER)
                osize = 1;
            else if (e->type == EOT_DB_STRING)
                osize = e->stringlen;

            align = (-osize) % wsize;
            if (align < 0)
                align += wsize;
            isize += osize + align;
        }
        return isize * instruction->times;
    }

    if (instruction->opcode == I_INCBIN) {
        char fname[FILENAME_MAX];
        FILE *fp;
        int32_t len;
        char *prefix = "", *combine;
        char **pPrevPath = NULL;

        len = FILENAME_MAX - 1;
        if (len > instruction->eops->stringlen)
            len = instruction->eops->stringlen;
        strncpy(fname, instruction->eops->stringval, len);
        fname[len] = '\0';

	/* added by alexfru: 'incbin' uses include paths */
        while (1) {
            combine = nasm_malloc(strlen(prefix) + len + 1);
            strcpy(combine, prefix);
            strcat(combine, fname);

            if ((fp = fopen(combine, "rb")) != NULL) {
                nasm_free(combine);
                break;
            }

            nasm_free(combine);
            pPrevPath = pp_get_include_path_ptr(pPrevPath);
            if (pPrevPath == NULL)
                break;
            prefix = *pPrevPath;
        }

        if (fp == NULL)
            error(ERR_NONFATAL, "`incbin': unable to open file `%s'",
                  fname);
        else if (fseek(fp, 0L, SEEK_END) < 0)
            error(ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
                  fname);
        else {
            len = ftell(fp);
            fclose(fp);
            if (instruction->eops->next) {
                len -= instruction->eops->next->offset;
                if (instruction->eops->next->next &&
                    len > instruction->eops->next->next->offset) {
                    len = instruction->eops->next->next->offset;
                }
            }
            return instruction->times * len;
        }
        return 0;               /* if we're here, there's an error */
    }

    /* Check to see if we need an address-size prefix */
    add_asp(instruction, bits);

    for (temp = nasm_instructions[instruction->opcode]; temp->opcode != -1; temp++) {
        int m = matches(temp, instruction, bits);
        if (m == 99)
            m += jmp_match(segment, offset, bits, instruction, temp->code);

        if (m == 100) {
            /* we've matched an instruction. */
            int32_t isize;
            const char *codes = temp->code;
            int j;

            isize = calcsize(segment, offset, bits, instruction, codes);
            if (isize < 0)
                return -1;
            for (j = 0; j < MAXPREFIX; j++) {
		switch (instruction->prefixes[j]) {
		case P_A16:
		    if (bits != 16)
			isize++;
		    break;
		case P_A32:
		    if (bits != 32)
			isize++;
		    break;
		case P_O16:
		    if (bits != 16)
			isize++;
		    break;
		case P_O32:
		    if (bits == 16)
			isize++;
		    break;
		case P_A64:
		case P_O64:
		case P_none:
		    break;
		default:
		    isize++;
		    break;
		}
            }
            return isize * instruction->times;
        }
    }
    return -1;                  /* didn't match any instruction */
}

/* check that  opn[op]  is a signed byte of size 16 or 32,
					and return the signed value*/
static int is_sbyte(insn * ins, int op, int size)
{
    int32_t v;
    int ret;

    ret = !(ins->forw_ref && ins->oprs[op].opflags) &&  /* dead in the water on forward reference or External */
        optimizing >= 0 &&
        !(ins->oprs[op].type & STRICT) &&
        ins->oprs[op].wrt == NO_SEG && ins->oprs[op].segment == NO_SEG;

    v = ins->oprs[op].offset;
    if (size == 16)
        v = (int16_t)v;    /* sign extend if 16 bits */

    return ret && v >= -128L && v <= 127L;
}

static int32_t calcsize(int32_t segment, int32_t offset, int bits,
                     insn * ins, const char *codes)
{
    int32_t length = 0;
    uint8_t c;
    int rex_mask = ~0;
    ins->rex = 0;               /* Ensure REX is reset */
    struct operand *opx;

    if (ins->prefixes[PPS_OSIZE] == P_O64)
	ins->rex |= REX_W;

    (void)segment;              /* Don't warn that this parameter is unused */
    (void)offset;               /* Don't warn that this parameter is unused */

    while (*codes) {
	c = *codes++;
	opx = &ins->oprs[c & 3];
        switch (c) {
        case 01:
        case 02:
        case 03:
            codes += c, length += c;
            break;
        case 04:
        case 05:
        case 06:
        case 07:
            length++;
            break;
        case 010:
        case 011:
        case 012:
	case 013:
	    ins->rex |=
		op_rexflags(opx, REX_B|REX_H|REX_P|REX_W);
            codes++, length++;
            break;
        case 014:
        case 015:
        case 016:
	case 017:
            length++;
            break;
        case 020:
        case 021:
        case 022:
	case 023:
            length++;
            break;
        case 024:
        case 025:
        case 026:
	case 027:
            length++;
            break;
        case 030:
        case 031:
        case 032:
	case 033:
            length += 2;
            break;
        case 034:
        case 035:
        case 036:
	case 037:
            if (opx->type & (BITS16 | BITS32 | BITS64))
                length += (opx->type & BITS16) ? 2 : 4;
            else
                length += (bits == 16) ? 2 : 4;
            break;
        case 040:
        case 041:
        case 042:
	case 043:
            length += 4;
            break;
        case 044:
        case 045:
        case 046:
	case 047:
            length += ins->addr_size >> 3;
            break;
        case 050:
        case 051:
        case 052:
	case 053:
            length++;
            break;
        case 054:
        case 055:
        case 056:
	case 057:
            length += 8; /* MOV reg64/imm */
            break;
        case 060:
        case 061:
        case 062:
	case 063:
            length += 2;
            break;
        case 064:
        case 065:
        case 066:
	case 067:
            if (opx->type & (BITS16 | BITS32 | BITS64))
                length += (opx->type & BITS16) ? 2 : 4;
            else
                length += (bits == 16) ? 2 : 4;
            break;
        case 070:
        case 071:
        case 072:
	case 073:
            length += 4;
            break;
        case 074:
        case 075:
        case 076:
        case 077:
            length += 2;
            break;
        case 0140:
        case 0141:
        case 0142:
	case 0143:
            length += is_sbyte(ins, c & 3, 16) ? 1 : 2;
            break;
        case 0144:
        case 0145:
        case 0146:
        case 0147:
            codes += 2;
            length++;
            break;
        case 0150:
        case 0151:
        case 0152:
        case 0153:
            length += is_sbyte(ins, c & 3, 32) ? 1 : 4;
            break;
        case 0154:
        case 0155:
        case 0156:
        case 0157:
            codes += 2;
            length++;
            break;
	case 0160:
	case 0161:
	case 0162:
	case 0163:
	    length++;
	    ins->rex |= REX_D;
	    ins->drexdst = regval(&ins->oprs[c & 3]);
	    break;
	case 0164:
	case 0165:
	case 0166:
	case 0167:
	    length++;
	    ins->rex |= REX_D|REX_OC;
	    ins->drexdst = regval(&ins->oprs[c & 3]);
	    break;
        case 0170:
            length++;
            break;
	case 0171:
	    break;
        case 0300:
        case 0301:
        case 0302:
        case 0303:
            break;
        case 0310:
	    if (bits == 64)
		return -1;
            length += (bits != 16) && !has_prefix(ins, PPS_ASIZE, P_A16);
            break;
        case 0311:
            length += (bits != 32) && !has_prefix(ins, PPS_ASIZE, P_A32);
            break;
        case 0312:
            break;
        case 0313:
	    if (bits != 64 || has_prefix(ins, PPS_ASIZE, P_A16) ||
		has_prefix(ins, PPS_ASIZE, P_A32))
		return -1;
            break;
        case 0320:
            length += (bits != 16);
            break;
        case 0321:
            length += (bits == 16);
            break;
        case 0322:
            break;
        case 0323:
            rex_mask &= ~REX_W;
            break;
        case 0324:
	    ins->rex |= REX_W;
            break;
        case 0330:
            codes++, length++;
            break;
        case 0331:
            break;
        case 0332:
        case 0333:
            length++;
            break;
	case 0334:
	    ins->rex |= REX_L;
	    break;
        case 0335:
	    break;
        case 0340:
        case 0341:
        case 0342:
            if (ins->oprs[0].segment != NO_SEG)
                errfunc(ERR_NONFATAL, "attempt to reserve non-constant"
                        " quantity of BSS space");
            else
                length += ins->oprs[0].offset << (c & 3);
            break;
	case 0364:
	case 0365:
	    break;
        case 0366:
        case 0367:
	    length++;
	    break;
        case 0370:
        case 0371:
        case 0372:
            break;
        case 0373:
            length++;
            break;
        default:               /* can't do it by 'case' statements */
            if (c >= 0100 && c <= 0277) {       /* it's an EA */
                ea ea_data;
                int rfield;
		int32_t rflags;
                ea_data.rex = 0;           /* Ensure ea.REX is initially 0 */

		if (c <= 0177) {
		    /* pick rfield from operand b */
		    rflags = regflag(&ins->oprs[c & 7]);
		    rfield = regvals[ins->oprs[c & 7].basereg];
		} else {
		    rflags = 0;
		    rfield = c & 7;
		}

                if (!process_ea
                    (&ins->oprs[(c >> 3) & 7], &ea_data, bits,
		     ins->addr_size, rfield, rflags, ins->forw_ref)) {
                    errfunc(ERR_NONFATAL, "invalid effective address");
                    return -1;
                } else {
		    ins->rex |= ea_data.rex;
                    length += ea_data.size;
                }
            } else {
                errfunc(ERR_PANIC, "internal instruction table corrupt"
                        ": instruction code 0x%02X given", c);
	    }
        }
    }

    ins->rex &= rex_mask;

    if (ins->rex & REX_D) {
	if (ins->rex & REX_H) {
	    errfunc(ERR_NONFATAL, "cannot use high register in drex instruction");
	    return -1;
	}
	if (bits != 64 && ((ins->rex & (REX_W|REX_X|REX_B)) ||
			   ins->drexdst > 7)) {
	    errfunc(ERR_NONFATAL, "invalid operands in non-64-bit mode");
	    return -1;
	}
	length++;
    } else if (ins->rex & REX_REAL) {
	if (ins->rex & REX_H) {
	    errfunc(ERR_NONFATAL, "cannot use high register in rex instruction");
	    return -1;
	} else if (bits == 64) {
	    length++;
	} else if ((ins->rex & REX_L) &&
		   !(ins->rex & (REX_P|REX_W|REX_X|REX_B)) &&
		   cpu >= IF_X86_64) {
	    /* LOCK-as-REX.R */
	    assert_no_prefix(ins, PPS_LREP);
	    length++;
	} else {
	    errfunc(ERR_NONFATAL, "invalid operands in non-64-bit mode");
	    return -1;
	}
    }

    return length;
}

#define EMIT_REX()							\
    if (!(ins->rex & REX_D) && (ins->rex & REX_REAL) && (bits == 64)) {	\
	ins->rex = (ins->rex & REX_REAL)|REX_P;				\
	out(offset, segment, &ins->rex, OUT_RAWDATA+1, NO_SEG, NO_SEG); \
	ins->rex = 0;							\
	offset += 1; \
    }

static void gencode(int32_t segment, int32_t offset, int bits,
                    insn * ins, const char *codes, int32_t insn_end)
{
    static char condval[] = {   /* conditional opcodes */
        0x7, 0x3, 0x2, 0x6, 0x2, 0x4, 0xF, 0xD, 0xC, 0xE, 0x6, 0x2,
        0x3, 0x7, 0x3, 0x5, 0xE, 0xC, 0xD, 0xF, 0x1, 0xB, 0x9, 0x5,
        0x0, 0xA, 0xA, 0xB, 0x8, 0x4
    };
    uint8_t c;
    uint8_t bytes[4];
    int32_t size;
    int64_t data;
    struct operand *opx;

    while (*codes) {
	c = *codes++;
	opx = &ins->oprs[c & 3];
        switch (c) {
        case 01:
        case 02:
        case 03:
	    EMIT_REX();
            out(offset, segment, codes, OUT_RAWDATA + c, NO_SEG, NO_SEG);
            codes += c;
            offset += c;
            break;

        case 04:
        case 06:
            switch (ins->oprs[0].basereg) {
            case R_CS:
                bytes[0] = 0x0E + (c == 0x04 ? 1 : 0);
                break;
            case R_DS:
                bytes[0] = 0x1E + (c == 0x04 ? 1 : 0);
                break;
            case R_ES:
                bytes[0] = 0x06 + (c == 0x04 ? 1 : 0);
                break;
            case R_SS:
                bytes[0] = 0x16 + (c == 0x04 ? 1 : 0);
                break;
            default:
                errfunc(ERR_PANIC,
                        "bizarre 8086 segment register received");
            }
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 05:
        case 07:
            switch (ins->oprs[0].basereg) {
            case R_FS:
                bytes[0] = 0xA0 + (c == 0x05 ? 1 : 0);
                break;
            case R_GS:
                bytes[0] = 0xA8 + (c == 0x05 ? 1 : 0);
                break;
            default:
                errfunc(ERR_PANIC,
                        "bizarre 386 segment register received");
            }
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 010:
        case 011:
        case 012:
	case 013:
	    EMIT_REX();
            bytes[0] = *codes++ + ((regval(opx)) & 7);
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 014:
        case 015:
        case 016:
	case 017:
            if (opx->offset < -128 || opx->offset > 127) {
                errfunc(ERR_WARNING, "signed byte value exceeds bounds");
            }

            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS + 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case 020:
        case 021:
        case 022:
	case 023:
            if (opx->offset < -256 || opx->offset > 255) {
                errfunc(ERR_WARNING, "byte value exceeds bounds");
            }
            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS + 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case 024:
        case 025:
        case 026:
	case 027:
            if (opx->offset < 0 || opx->offset > 255)
                errfunc(ERR_WARNING, "unsigned byte value exceeds bounds");
            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS + 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case 030:
        case 031:
        case 032:
	case 033:
            data = opx->offset;
            if (opx->segment == NO_SEG && opx->wrt == NO_SEG)
		warn_overflow(2, data);
            out(offset, segment, &data, OUT_ADDRESS + 2,
                opx->segment, opx->wrt);
            offset += 2;
            break;

        case 034:
        case 035:
        case 036:
	case 037:
            if (opx->type & (BITS16 | BITS32))
                size = (opx->type & BITS16) ? 2 : 4;
            else
                size = (bits == 16) ? 2 : 4;
            data = opx->offset;
            if (opx->segment == NO_SEG && opx->wrt == NO_SEG)
		warn_overflow(size, data);
            out(offset, segment, &data, OUT_ADDRESS + size,
                opx->segment, opx->wrt);
            offset += size;
            break;

        case 040:
        case 041:
        case 042:
	case 043:
            data = opx->offset;
            out(offset, segment, &data, OUT_ADDRESS + 4,
                opx->segment, opx->wrt);
            offset += 4;
            break;

        case 044:
        case 045:
        case 046:
	case 047:
            data = opx->offset;
            size = ins->addr_size >> 3;
	    if (opx->segment == NO_SEG &&
		opx->wrt == NO_SEG)
		warn_overflow(size, data);
            out(offset, segment, &data, OUT_ADDRESS + size,
                opx->segment, opx->wrt);
            offset += size;
            break;

        case 050:
        case 051:
        case 052:
	case 053:
            if (opx->segment != segment)
                errfunc(ERR_NONFATAL,
                        "short relative jump outside segment");
            data = opx->offset - insn_end;
            if (data > 127 || data < -128)
                errfunc(ERR_NONFATAL, "short jump is out of range");
            bytes[0] = data;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 054:
        case 055:
        case 056:
	case 057:
            data = (int64_t)opx->offset;
            out(offset, segment, &data, OUT_ADDRESS + 8,
                opx->segment, opx->wrt);
            offset += 8;
            break;

        case 060:
        case 061:
        case 062:
	case 063:
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    OUT_REL2ADR + insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS + 2, NO_SEG, NO_SEG);
            }
            offset += 2;
            break;

        case 064:
        case 065:
        case 066:
	case 067:
            if (opx->type & (BITS16 | BITS32 | BITS64))
                size = (opx->type & BITS16) ? 2 : 4;
            else
                size = (bits == 16) ? 2 : 4;
            if (opx->segment != segment) {
                int32_t reltype = (size == 2 ? OUT_REL2ADR : OUT_REL4ADR);
                data = opx->offset;
                out(offset, segment, &data, reltype + insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS + size, NO_SEG, NO_SEG);
            }
            offset += size;
            break;

        case 070:
        case 071:
        case 072:
	case 073:
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    OUT_REL4ADR + insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS + 4, NO_SEG, NO_SEG);
            }
            offset += 4;
            break;

        case 074:
        case 075:
        case 076:
        case 077:
            if (opx->segment == NO_SEG)
                errfunc(ERR_NONFATAL, "value referenced by FAR is not"
                        " relocatable");
            data = 0L;
            out(offset, segment, &data, OUT_ADDRESS + 2,
                outfmt->segbase(1 + opx->segment),
                opx->wrt);
            offset += 2;
            break;

        case 0140:
        case 0141:
        case 0142:
	case 0143:
            data = opx->offset;
            if (is_sbyte(ins, c & 3, 16)) {
                bytes[0] = data;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG,
                    NO_SEG);
                offset++;
            } else {
                if (opx->segment == NO_SEG &&
                    opx->wrt == NO_SEG)
		    warn_overflow(2, data);
                out(offset, segment, &data, OUT_ADDRESS + 2,
                    opx->segment, opx->wrt);
                offset += 2;
            }
            break;

        case 0144:
        case 0145:
        case 0146:
	case 0147:
	    EMIT_REX();
            codes++;
            bytes[0] = *codes++;
            if (is_sbyte(ins, c & 3, 16))
                bytes[0] |= 2;  /* s-bit */
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0150:
        case 0151:
        case 0152:
	case 0153:
            data = opx->offset;
            if (is_sbyte(ins, c & 3, 32)) {
                bytes[0] = data;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG,
                    NO_SEG);
                offset++;
            } else {
                out(offset, segment, &data, OUT_ADDRESS + 4,
                    opx->segment, opx->wrt);
                offset += 4;
            }
            break;

        case 0154:
        case 0155:
        case 0156:
	case 0157:
	    EMIT_REX();
            codes++;
            bytes[0] = *codes++;
            if (is_sbyte(ins, c & 3, 32))
                bytes[0] |= 2;  /* s-bit */
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset++;
            break;

	case 0160:
	case 0161:
	case 0162:
	case 0163:
	case 0164:
	case 0165:
	case 0166:
	case 0167:
	    break;

        case 0170:
	    EMIT_REX();
            bytes[0] = 0;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

	case 0171:
	    bytes[0] =
		(ins->drexdst << 4) |
		(ins->rex & REX_OC ? 0x08 : 0) |
		(ins->rex & (REX_R|REX_X|REX_B));
	    ins->rex = 0;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
	    offset++;
	    break;

        case 0300:
        case 0301:
        case 0302:
        case 0303:
            break;

        case 0310:
            if (bits == 32 && !has_prefix(ins, PPS_ASIZE, P_A16)) {
                *bytes = 0x67;
                out(offset, segment, bytes,
                    OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0311:
            if (bits != 32 && !has_prefix(ins, PPS_ASIZE, P_A32)) {
                *bytes = 0x67;
                out(offset, segment, bytes,
                    OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0312:
            break;

        case 0313:
            ins->rex = 0;
            break;

        case 0320:
            if (bits != 16) {
                *bytes = 0x66;
                out(offset, segment, bytes,
                    OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0321:
            if (bits == 16) {
                *bytes = 0x66;
                out(offset, segment, bytes,
                    OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0322:
        case 0323:
            break;

        case 0324:
            ins->rex |= REX_W;
            break;

        case 0330:
            *bytes = *codes++ ^ condval[ins->condition];
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0331:
            break;

	case 0332:
        case 0333:
            *bytes = c - 0332 + 0xF2;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0334:
            if (ins->rex & REX_R) {
                *bytes = 0xF0;
                out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
                offset += 1;
            }
            ins->rex &= ~(REX_L|REX_R);
            break;

        case 0335:
	    break;

        case 0340:
        case 0341:
        case 0342:
            if (ins->oprs[0].segment != NO_SEG)
                errfunc(ERR_PANIC, "non-constant BSS size in pass two");
            else {
                int32_t size = ins->oprs[0].offset << (c & 3);
                if (size > 0)
                    out(offset, segment, NULL,
                        OUT_RESERVE + size, NO_SEG, NO_SEG);
                offset += size;
            }
            break;

	case 0364:
	case 0365:
	    break;

        case 0366:
	case 0367:
            *bytes = c - 0366 + 0x66;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0370:
        case 0371:
        case 0372:
            break;

        case 0373:
            *bytes = bits == 16 ? 3 : 5;
            out(offset, segment, bytes, OUT_RAWDATA + 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        default:               /* can't do it by 'case' statements */
            if (c >= 0100 && c <= 0277) {       /* it's an EA */
                ea ea_data;
                int rfield;
		int32_t rflags;
                uint8_t *p;
                int32_t s;

                if (c <= 0177) {
		    /* pick rfield from operand b */
		    rflags = regflag(&ins->oprs[c & 7]);
                    rfield = regvals[ins->oprs[c & 7].basereg];
		} else {
		    /* rfield is constant */
		    rflags = 0;
                    rfield = c & 7;
		}

                if (!process_ea
                    (&ins->oprs[(c >> 3) & 7], &ea_data, bits,
		     ins->addr_size, rfield, rflags, ins->forw_ref)) {
                    errfunc(ERR_NONFATAL, "invalid effective address");
                }

                p = bytes;
                *p++ = ea_data.modrm;
                if (ea_data.sib_present)
                    *p++ = ea_data.sib;

		/* DREX suffixes come between the SIB and the displacement */
		if (ins->rex & REX_D) {
		    *p++ =
			(ins->drexdst << 4) |
			(ins->rex & REX_OC ? 0x08 : 0) |
			(ins->rex & (REX_R|REX_X|REX_B));
		    ins->rex = 0;
		}

                s = p - bytes;
                out(offset, segment, bytes, OUT_RAWDATA + s,
                    NO_SEG, NO_SEG);

                switch (ea_data.bytes) {
                case 0:
                    break;
                case 1:
                    if (ins->oprs[(c >> 3) & 7].segment != NO_SEG) {
                        data = ins->oprs[(c >> 3) & 7].offset;
                        out(offset, segment, &data, OUT_ADDRESS + 1,
                            ins->oprs[(c >> 3) & 7].segment,
                            ins->oprs[(c >> 3) & 7].wrt);
                    } else {
                        *bytes = ins->oprs[(c >> 3) & 7].offset;
                        out(offset, segment, bytes, OUT_RAWDATA + 1,
                            NO_SEG, NO_SEG);
                    }
                    s++;
                    break;
                case 8:
                case 2:
                case 4:
                    data = ins->oprs[(c >> 3) & 7].offset;
                    out(offset, segment, &data,
                        (ea_data.rip ?  OUT_REL4ADR : OUT_ADDRESS)
			+ ea_data.bytes,
                        ins->oprs[(c >> 3) & 7].segment,
                        ins->oprs[(c >> 3) & 7].wrt);
                    s += ea_data.bytes;
                    break;
                }
                offset += s;
            } else {
                errfunc(ERR_PANIC, "internal instruction table corrupt"
                        ": instruction code 0x%02X given", c);
	    }
        }
    }
}

static int32_t regflag(const operand * o)
{
    if (o->basereg < EXPR_REG_START || o->basereg >= REG_ENUM_LIMIT) {
        errfunc(ERR_PANIC, "invalid operand passed to regflag()");
    }
    return reg_flags[o->basereg];
}

static int32_t regval(const operand * o)
{
    if (o->basereg < EXPR_REG_START || o->basereg >= REG_ENUM_LIMIT) {
        errfunc(ERR_PANIC, "invalid operand passed to regval()");
    }
    return regvals[o->basereg];
}

static int op_rexflags(const operand * o, int mask)
{
    int32_t flags;
    int val;

    if (o->basereg < EXPR_REG_START || o->basereg >= REG_ENUM_LIMIT) {
        errfunc(ERR_PANIC, "invalid operand passed to op_rexflags()");
    }

    flags = reg_flags[o->basereg];
    val = regvals[o->basereg];

    return rexflags(val, flags, mask);
}

static int rexflags(int val, int32_t flags, int mask)
{
    int rex = 0;

    if (val >= 8)
	rex |= REX_B|REX_X|REX_R;
    if (flags & BITS64)
	rex |= REX_W;
    if (!(REG_HIGH & ~flags))	/* AH, CH, DH, BH */
	rex |= REX_H;
    else if (!(REG8 & ~flags) && val >= 4) /* SPL, BPL, SIL, DIL */
	rex |= REX_P;

    return rex & mask;
}

static int matches(const struct itemplate *itemp, insn * instruction, int bits)
{
    int i, size[MAX_OPERANDS], asize, oprs, ret;

    ret = 100;

    /*
     * Check the opcode
     */
    if (itemp->opcode != instruction->opcode)
        return 0;

    /*
     * Count the operands
     */
    if (itemp->operands != instruction->operands)
        return 0;

    /*
     * Check that no spurious colons or TOs are present
     */
    for (i = 0; i < itemp->operands; i++)
        if (instruction->oprs[i].type & ~itemp->opd[i] & (COLON | TO))
            return 0;

    /*
     * Check that the operand flags all match up
     */
    for (i = 0; i < itemp->operands; i++) {
	if (itemp->opd[i] & SAME_AS) {
	    int j = itemp->opd[i] & ~SAME_AS;
	    if (instruction->oprs[i].type != instruction->oprs[j].type ||
		instruction->oprs[i].basereg != instruction->oprs[j].basereg)
		return 0;
	} else  if (itemp->opd[i] & ~instruction->oprs[i].type ||
            ((itemp->opd[i] & SIZE_MASK) &&
             ((itemp->opd[i] ^ instruction->oprs[i].type) & SIZE_MASK))) {
            if ((itemp->opd[i] & ~instruction->oprs[i].type & ~SIZE_MASK) ||
                (instruction->oprs[i].type & SIZE_MASK))
                return 0;
            else
                return 1;
        }
    }

    /*
     * Check operand sizes
     */
    if (itemp->flags & IF_ARMASK) {
	memset(size, 0, sizeof size);

        switch (itemp->flags & IF_ARMASK) {
        case IF_AR0:
            i = 0;
            break;
        case IF_AR1:
            i = 1;
            break;
        case IF_AR2:
            i = 2;
            break;
	case IF_AR3:
	    i = 3;
	    break;
        default:
            break;              /* Shouldn't happen */
        }
	switch (itemp->flags & IF_SMASK) {
	case IF_SB:
            size[i] = BITS8;
	    break;
	case IF_SW:
            size[i] = BITS16;
	    break;
	case IF_SD:
            size[i] = BITS32;
	    break;
	case IF_SQ:
            size[i] = BITS64;
	    break;
	case IF_SO:
	    size[i] = BITS128;
	    break;
	default:
	    break;
        }
    } else {
        asize = 0;
	switch (itemp->flags & IF_SMASK) {
	case IF_SB:
            asize = BITS8;
            oprs = itemp->operands;
	    break;
	case IF_SW:
            asize = BITS16;
            oprs = itemp->operands;
	    break;
	case IF_SD:
            asize = BITS32;
            oprs = itemp->operands;
	    break;
	case IF_SQ:
            asize = BITS64;
            oprs = itemp->operands;
	    break;
	case IF_SO:
            asize = BITS128;
            oprs = itemp->operands;
	    break;
	default:
	    break;
        }
	for (i = 0; i < MAX_OPERANDS; i++)
	    size[i] = asize;
    }

    if (itemp->flags & (IF_SM | IF_SM2)) {
        oprs = (itemp->flags & IF_SM2 ? 2 : itemp->operands);
        asize = 0;
        for (i = 0; i < oprs; i++) {
            if ((asize = itemp->opd[i] & SIZE_MASK) != 0) {
                int j;
                for (j = 0; j < oprs; j++)
                    size[j] = asize;
                break;
            }
        }
    } else {
        oprs = itemp->operands;
    }

    for (i = 0; i < itemp->operands; i++) {
        if (!(itemp->opd[i] & SIZE_MASK) &&
            (instruction->oprs[i].type & SIZE_MASK & ~size[i]))
            return 2;
    }

    /*
     * Check template is okay at the set cpu level
     */
    if (((itemp->flags & IF_PLEVEL) > cpu))
        return 3;

    /*
     * Check if instruction is available in long mode
     */
    if ((itemp->flags & IF_NOLONG) && (bits == 64))
        return 4;

    /*
     * Check if special handling needed for Jumps
     */
    if ((uint8_t)(itemp->code[0]) >= 0370)
        return 99;

    return ret;
}

static ea *process_ea(operand * input, ea * output, int bits,
		      int addrbits, int rfield, int32_t rflags, int forw_ref)
{
    output->rip = false;

    /* REX flags for the rfield operand */
    output->rex |= rexflags(rfield, rflags, REX_R|REX_P|REX_W|REX_H);

    if (!(REGISTER & ~input->type)) {   /* register direct */
        int i;
	int32_t f;

        if (input->basereg < EXPR_REG_START /* Verify as Register */
            || input->basereg >= REG_ENUM_LIMIT)
            return NULL;
	f = regflag(input);
        i = regvals[input->basereg];

	if (REG_EA & ~f)
	    return NULL;	/* Invalid EA register */

	output->rex |= op_rexflags(input, REX_B|REX_P|REX_W|REX_H);

        output->sib_present = false;             /* no SIB necessary */
        output->bytes = 0;  /* no offset necessary either */
        output->modrm = 0xC0 | ((rfield & 7) << 3) | (i & 7);
    } else {                    /* it's a memory reference */
        if (input->basereg == -1
            && (input->indexreg == -1 || input->scale == 0)) {
            /* it's a pure offset */
            if (bits == 64 && (~input->type & IP_REL)) {
              int scale, index, base;
              output->sib_present = true;
              scale = 0;
              index = 4;
              base = 5;
              output->sib = (scale << 6) | (index << 3) | base;
              output->bytes = 4;
              output->modrm = 4 | ((rfield & 7) << 3);
	      output->rip = false;
            } else {
              output->sib_present = false;
              output->bytes = (addrbits != 16 ? 4 : 2);
              output->modrm = (addrbits != 16 ? 5 : 6) | ((rfield & 7) << 3);
	      output->rip = bits == 64;
            }
        } else {                /* it's an indirection */
            int i = input->indexreg, b = input->basereg, s = input->scale;
            int32_t o = input->offset, seg = input->segment;
            int hb = input->hintbase, ht = input->hinttype;
            int t;
            int it, bt;
	    int32_t ix, bx;	/* register flags */

            if (s == 0)
                i = -1;         /* make this easy, at least */

            if (i >= EXPR_REG_START && i < REG_ENUM_LIMIT) {
                it = regvals[i];
		ix = reg_flags[i];
	    } else {
                it = -1;
		ix = 0;
	    }

	    if (b >= EXPR_REG_START && b < REG_ENUM_LIMIT) {
                bt = regvals[b];
		bx = reg_flags[b];
	    } else {
                bt = -1;
		bx = 0;
	    }

	    /* check for a 32/64-bit memory reference... */
	    if ((ix|bx) & (BITS32|BITS64)) {
                /* it must be a 32/64-bit memory reference. Firstly we have
                 * to check that all registers involved are type E/Rxx. */
		int32_t sok = BITS32|BITS64;

                if (it != -1) {
		    if (!(REG64 & ~ix) || !(REG32 & ~ix))
			sok &= ix;
		    else
			return NULL;
		}

		if (bt != -1) {
		    if (REG_GPR & ~bx)
			return NULL; /* Invalid register */
		    if (~sok & bx & SIZE_MASK)
			return NULL; /* Invalid size */
		    sok &= bx;
		}

                /* While we're here, ensure the user didn't specify
		   WORD or QWORD. */
                if (input->disp_size == 16 || input->disp_size == 64)
		    return NULL;

		if (addrbits == 16 ||
		    (addrbits == 32 && !(sok & BITS32)) ||
		    (addrbits == 64 && !(sok & BITS64)))
		    return NULL;

                /* now reorganize base/index */
                if (s == 1 && bt != it && bt != -1 && it != -1 &&
                    ((hb == b && ht == EAH_NOTBASE)
                     || (hb == i && ht == EAH_MAKEBASE))) {
		    /* swap if hints say so */
                    t = bt, bt = it, it = t;
		    t = bx, bx = ix, ix = t;
		}
                if (bt == it)     /* convert EAX+2*EAX to 3*EAX */
                    bt = -1, bx = 0, s++;
                if (bt == -1 && s == 1 && !(hb == it && ht == EAH_NOTBASE)) {
		    /* make single reg base, unless hint */
                    bt = it, bx = ix, it = -1, ix = 0;
		}
                if (((s == 2 && it != REG_NUM_ESP
                      && !(input->eaflags & EAF_TIMESTWO)) || s == 3
                     || s == 5 || s == 9) && bt == -1)
                    bt = it, bx = ix, s--; /* convert 3*EAX to EAX+2*EAX */
                if (it == -1 && (bt & 7) != REG_NUM_ESP
                    && (input->eaflags & EAF_TIMESTWO))
                    it = bt, ix = bx, bt = -1, bx = 0, s = 1;
                /* convert [NOSPLIT EAX] to sib format with 0x0 displacement */
                if (s == 1 && it == REG_NUM_ESP) {
		    /* swap ESP into base if scale is 1 */
                    t = it, it = bt, bt = t;
		    t = ix, ix = bx, bx = t;
		}
                if (it == REG_NUM_ESP
                    || (s != 1 && s != 2 && s != 4 && s != 8 && it != -1))
                    return NULL;        /* wrong, for various reasons */

		output->rex |= rexflags(it, ix, REX_X);
		output->rex |= rexflags(bt, bx, REX_B);

                if (it == -1 && (bt & 7) != REG_NUM_ESP) {
		    /* no SIB needed */
                    int mod, rm;

                    if (bt == -1) {
                        rm = 5;
                        mod = 0;
                    } else {
                        rm = (bt & 7);
                        if (rm != REG_NUM_EBP && o == 0 &&
                                seg == NO_SEG && !forw_ref &&
                                !(input->eaflags &
                                  (EAF_BYTEOFFS | EAF_WORDOFFS)))
                            mod = 0;
                        else if (input->eaflags & EAF_BYTEOFFS ||
                                 (o >= -128 && o <= 127 && seg == NO_SEG
                                  && !forw_ref
                                  && !(input->eaflags & EAF_WORDOFFS)))
                            mod = 1;
                        else
                            mod = 2;
                    }

                    output->sib_present = false;
                    output->bytes = (bt == -1 || mod == 2 ? 4 : mod);
                    output->modrm = (mod << 6) | ((rfield & 7) << 3) | rm;
                } else {
		    /* we need a SIB */
                    int mod, scale, index, base;

                    if (it == -1)
                        index = 4, s = 1;
                    else
                        index = (it & 7);

                    switch (s) {
                    case 1:
                        scale = 0;
                        break;
                    case 2:
                        scale = 1;
                        break;
                    case 4:
                        scale = 2;
                        break;
                    case 8:
                        scale = 3;
                        break;
                    default:   /* then what the smeg is it? */
                        return NULL;    /* panic */
                    }

                    if (bt == -1) {
                        base = 5;
                        mod = 0;
                    } else {
                        base = (bt & 7);
                        if (base != REG_NUM_EBP && o == 0 &&
                                    seg == NO_SEG && !forw_ref &&
                                    !(input->eaflags &
                                      (EAF_BYTEOFFS | EAF_WORDOFFS)))
                            mod = 0;
                        else if (input->eaflags & EAF_BYTEOFFS ||
                                 (o >= -128 && o <= 127 && seg == NO_SEG
                                  && !forw_ref
                                  && !(input->eaflags & EAF_WORDOFFS)))
                            mod = 1;
                        else
                            mod = 2;
                    }

                    output->sib_present = true;
                    output->bytes =  (bt == -1 || mod == 2 ? 4 : mod);
                    output->modrm = (mod << 6) | ((rfield & 7) << 3) | 4;
                    output->sib = (scale << 6) | (index << 3) | base;
                }
            } else {            /* it's 16-bit */
                int mod, rm;

                /* check for 64-bit long mode */
                if (addrbits == 64)
                    return NULL;

                /* check all registers are BX, BP, SI or DI */
                if ((b != -1 && b != R_BP && b != R_BX && b != R_SI
                     && b != R_DI) || (i != -1 && i != R_BP && i != R_BX
                                       && i != R_SI && i != R_DI))
                    return NULL;

                /* ensure the user didn't specify DWORD/QWORD */
                if (input->disp_size == 32 || input->disp_size == 64)
                    return NULL;

                if (s != 1 && i != -1)
                    return NULL;        /* no can do, in 16-bit EA */
                if (b == -1 && i != -1) {
                    int tmp = b;
                    b = i;
                    i = tmp;
                }               /* swap */
                if ((b == R_SI || b == R_DI) && i != -1) {
                    int tmp = b;
                    b = i;
                    i = tmp;
                }
                /* have BX/BP as base, SI/DI index */
                if (b == i)
                    return NULL;        /* shouldn't ever happen, in theory */
                if (i != -1 && b != -1 &&
                    (i == R_BP || i == R_BX || b == R_SI || b == R_DI))
                    return NULL;        /* invalid combinations */
                if (b == -1)    /* pure offset: handled above */
                    return NULL;        /* so if it gets to here, panic! */

                rm = -1;
                if (i != -1)
                    switch (i * 256 + b) {
                    case R_SI * 256 + R_BX:
                        rm = 0;
                        break;
                    case R_DI * 256 + R_BX:
                        rm = 1;
                        break;
                    case R_SI * 256 + R_BP:
                        rm = 2;
                        break;
                    case R_DI * 256 + R_BP:
                        rm = 3;
                        break;
                } else
                    switch (b) {
                    case R_SI:
                        rm = 4;
                        break;
                    case R_DI:
                        rm = 5;
                        break;
                    case R_BP:
                        rm = 6;
                        break;
                    case R_BX:
                        rm = 7;
                        break;
                    }
                if (rm == -1)   /* can't happen, in theory */
                    return NULL;        /* so panic if it does */

                if (o == 0 && seg == NO_SEG && !forw_ref && rm != 6 &&
                    !(input->eaflags & (EAF_BYTEOFFS | EAF_WORDOFFS)))
                    mod = 0;
                else if (input->eaflags & EAF_BYTEOFFS ||
                         (o >= -128 && o <= 127 && seg == NO_SEG
                          && !forw_ref
                          && !(input->eaflags & EAF_WORDOFFS)))
                    mod = 1;
                else
                    mod = 2;

                output->sib_present = false;    /* no SIB - it's 16-bit */
                output->bytes = mod;    /* bytes of offset needed */
                output->modrm = (mod << 6) | ((rfield & 7) << 3) | rm;
            }
        }
    }

    output->size = 1 + output->sib_present + output->bytes;
    return output;
}

static void add_asp(insn *ins, int addrbits)
{
    int j, valid;
    int defdisp;

    valid = (addrbits == 64) ? 64|32 : 32|16;

    switch (ins->prefixes[PPS_ASIZE]) {
    case P_A16:
	valid &= 16;
	break;
    case P_A32:
	valid &= 32;
	break;
    case P_A64:
	valid &= 64;
	break;
    case P_ASP:
	valid &= (addrbits == 32) ? 16 : 32;
	break;
    default:
	break;
    }

    for (j = 0; j < ins->operands; j++) {
	if (!(MEMORY & ~ins->oprs[j].type)) {
	    int32_t i, b;

	    /* Verify as Register */
	    if (ins->oprs[j].indexreg < EXPR_REG_START
		|| ins->oprs[j].indexreg >= REG_ENUM_LIMIT)
		i = 0;
	    else
		i = reg_flags[ins->oprs[j].indexreg];

	    /* Verify as Register */
	    if (ins->oprs[j].basereg < EXPR_REG_START
		|| ins->oprs[j].basereg >= REG_ENUM_LIMIT)
		b = 0;
	    else
		b = reg_flags[ins->oprs[j].basereg];

	    if (ins->oprs[j].scale == 0)
		i = 0;

	    if (!i && !b) {
		int ds = ins->oprs[j].disp_size;
		if ((addrbits != 64 && ds > 8) ||
		    (addrbits == 64 && ds == 16))
		    valid &= ds;
	    } else {
		if (!(REG16 & ~b))
		    valid &= 16;
		if (!(REG32 & ~b))
		    valid &= 32;
		if (!(REG64 & ~b))
		    valid &= 64;

		if (!(REG16 & ~i))
		    valid &= 16;
		if (!(REG32 & ~i))
		    valid &= 32;
		if (!(REG64 & ~i))
		    valid &= 64;
	    }
	}
    }

    if (valid & addrbits) {
	ins->addr_size = addrbits;
    } else if (valid & ((addrbits == 32) ? 16 : 32)) {
	/* Add an address size prefix */
	enum prefixes pref = (addrbits == 32) ? P_A16 : P_A32;
	ins->prefixes[PPS_ASIZE] = pref;
	ins->addr_size = (addrbits == 32) ? 16 : 32;
    } else {
	/* Impossible... */
	errfunc(ERR_NONFATAL, "impossible combination of address sizes");
	ins->addr_size = addrbits; /* Error recovery */
    }

    defdisp = ins->addr_size == 16 ? 16 : 32;

    for (j = 0; j < ins->operands; j++) {
	if (!(MEM_OFFS & ~ins->oprs[j].type) &&
	    (ins->oprs[j].disp_size ? ins->oprs[j].disp_size : defdisp)
	    != ins->addr_size) {
	    /* mem_offs sizes must match the address size; if not,
	       strip the MEM_OFFS bit and match only EA instructions */
	    ins->oprs[j].type &= ~(MEM_OFFS & ~MEMORY);
	}
    }
}
