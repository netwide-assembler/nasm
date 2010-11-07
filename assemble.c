/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2010 The NASM Authors - All Rights Reserved
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
 * assemble.c   code generation for the Netwide Assembler
 *
 * the actual codes (C syntax, i.e. octal):
 * \0            - terminates the code. (Unless it's a literal of course.)
 * \1..\4        - that many literal bytes follow in the code stream
 * \5            - add 4 to the primary operand number (b, low octdigit)
 * \6            - add 4 to the secondary operand number (a, middle octdigit)
 * \7            - add 4 to both the primary and the secondary operand number
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
 *                 depending on the address size of the instruction.
 * \50..\53      - a byte relative operand, from operand 0..3
 * \54..\57      - a qword immediate operand, from operand 0..3
 * \60..\63      - a word relative operand, from operand 0..3
 * \64..\67      - select between \6[0-3] and \7[0-3] depending on 16/32 bit
 *                 assembly mode or the operand-size override on the operand
 * \70..\73      - a long relative operand, from operand 0..3
 * \74..\77      - a word constant, from the _segment_ part of operand 0..3
 * \1ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field the register value of operand b.
 * \140..\143    - an immediate word or signed byte for operand 0..3
 * \144..\147    - or 2 (s-field) into opcode byte if operand 0..3
 *                  is a signed byte rather than a word.  Opcode byte follows.
 * \150..\153    - an immediate dword or signed byte for operand 0..3
 * \154..\157    - or 2 (s-field) into opcode byte if operand 0..3
 *                  is a signed byte rather than a dword.  Opcode byte follows.
 * \160..\163    - this instruction uses DREX rather than REX, with the
 *                 OC0 field set to 0, and the dest field taken from
 *                 operand 0..3.
 * \164..\167    - this instruction uses DREX rather than REX, with the
 *                 OC0 field set to 1, and the dest field taken from
 *                 operand 0..3.
 * \171          - placement of DREX suffix in the absence of an EA
 * \172\ab       - the register number from operand a in bits 7..4, with
 *                 the 4-bit immediate from operand b in bits 3..0.
 * \173\xab      - the register number from operand a in bits 7..4, with
 *                 the value b in bits 3..0.
 * \174\a        - the register number from operand a in bits 7..4, and
 *                 an arbitrary value in bits 3..0 (assembled as zero.)
 * \2ab          - a ModRM, calculated on EA in operand a, with the spare
 *                 field equal to digit b.
 * \250..\253    - same as \150..\153, except warn if the 64-bit operand
 *                 is not equal to the truncated and sign-extended 32-bit
 *                 operand; used for 32-bit immediates in 64-bit mode.
 * \254..\257    - a signed 32-bit operand to be extended to 64 bits.
 * \260..\263    - this instruction uses VEX/XOP rather than REX, with the
 *                 V field taken from operand 0..3.
 * \270          - this instruction uses VEX/XOP rather than REX, with the
 *                 V field set to 1111b.
 *
 * VEX/XOP prefixes are followed by the sequence:
 * \tmm\wlp        where mm is the M field; and wlp is:
 *                 00 wwl lpp
 *		   [l0]  ll = 0 for L = 0 (.128, .lz)
 *		   [l1]  ll = 1 for L = 1 (.256)
 *		   [lig] ll = 2 for L don't care (always assembled as 0)
 *
 *                 [w0]  ww = 0 for W = 0
 *                 [w1 ] ww = 1 for W = 1
 *                 [wig] ww = 2 for W don't care (always assembled as 0)
 *                 [ww]  ww = 3 for W used as REX.W
 *
 * t = 0 for VEX (C4/C5), t = 1 for XOP (8F).
 *
 * \274..\277    - a signed byte immediate operand, from operand 0..3,
 *                 which is to be extended to the operand size.
 * \310          - indicates fixed 16-bit address size, i.e. optional 0x67.
 * \311          - indicates fixed 32-bit address size, i.e. optional 0x67.
 * \312          - (disassembler only) invalid with non-default address size.
 * \313          - indicates fixed 64-bit address size, 0x67 invalid.
 * \314          - (disassembler only) invalid with REX.B
 * \315          - (disassembler only) invalid with REX.X
 * \316          - (disassembler only) invalid with REX.R
 * \317          - (disassembler only) invalid with REX.W
 * \320          - indicates fixed 16-bit operand size, i.e. optional 0x66.
 * \321          - indicates fixed 32-bit operand size, i.e. optional 0x66.
 * \322          - indicates that this instruction is only valid when the
 *                 operand size is the default (instruction to disassembler,
 *                 generates no code in the assembler)
 * \323          - indicates fixed 64-bit operand size, REX on extensions only.
 * \324          - indicates 64-bit operand size requiring REX prefix.
 * \325          - instruction which always uses spl/bpl/sil/dil
 * \330          - a literal byte follows in the code stream, to be added
 *                 to the condition code value of the instruction.
 * \331          - instruction not valid with REP prefix.  Hint for
 *                 disassembler only; for SSE instructions.
 * \332          - REP prefix (0xF2 byte) used as opcode extension.
 * \333          - REP prefix (0xF3 byte) used as opcode extension.
 * \334          - LOCK prefix used as REX.R (used in non-64-bit mode)
 * \335          - disassemble a rep (0xF3 byte) prefix as repe not rep.
 * \336          - force a REP(E) prefix (0xF2) even if not specified.
 * \337          - force a REPNE prefix (0xF3) even if not specified.
 *                 \336-\337 are still listed as prefixes in the disassembler.
 * \340          - reserve <operand 0> bytes of uninitialized storage.
 *                 Operand 0 had better be a segmentless constant.
 * \341          - this instruction needs a WAIT "prefix"
 * \344,\345     - the PUSH/POP (respectively) codes for CS, DS, ES, SS
 *                 (POP is never used for CS) depending on operand 0
 * \346,\347     - the second byte of PUSH/POP codes for FS, GS, depending
 *                 on operand 0
 * \360          - no SSE prefix (== \364\331)
 * \361          - 66 SSE prefix (== \366\331)
 * \362          - F2 SSE prefix (== \364\332)
 * \363          - F3 SSE prefix (== \364\333)
 * \364          - operand-size prefix (0x66) not permitted
 * \365          - address-size prefix (0x67) not permitted
 * \366          - operand-size prefix (0x66) used as opcode extension
 * \367          - address-size prefix (0x67) used as opcode extension
 * \370,\371,\372 - match only if operand 0 meets byte jump criteria.
 *                 370 is used for Jcc, 371 is used for JMP.
 * \373          - assemble 0x03 if bits==16, 0x05 if bits==32;
 *                 used for conditional jump over longer jump
 */

#include "compiler.h"

#include <stdio.h>
#include <string.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "assemble.h"
#include "insns.h"
#include "tables.h"

enum match_result {
    /*
     * Matching errors.  These should be sorted so that more specific
     * errors come later in the sequence.
     */
    MERR_INVALOP,
    MERR_OPSIZEMISSING,
    MERR_OPSIZEMISMATCH,
    MERR_BADCPU,
    MERR_BADMODE,
    /*
     * Matching success; the conditional ones first
     */
    MOK_JUMP,   /* Matching OK but needs jmp_match() */
    MOK_GOOD    /* Matching unconditionally OK */
};

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

static int64_t calcsize(int32_t, int64_t, int, insn *, const uint8_t *);
static void gencode(int32_t segment, int64_t offset, int bits,
                    insn * ins, const struct itemplate *temp,
                    int64_t insn_end);
static enum match_result find_match(const struct itemplate **tempp,
                                    insn *instruction,
                                    int32_t segment, int64_t offset, int bits);
static enum match_result matches(const struct itemplate *, insn *, int bits);
static opflags_t regflag(const operand *);
static int32_t regval(const operand *);
static int rexflags(int, opflags_t, int);
static int op_rexflags(const operand *, int);
static ea *process_ea(operand *, ea *, int, int, int, opflags_t);
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
    case 32:
        return "yword";
    default:
        return "???";
    }
}

static void warn_overflow(int pass, int size)
{
    errfunc(ERR_WARNING | pass | ERR_WARN_NOV,
            "%s data exceeds bounds", size_name(size));
}

static void warn_overflow_const(int64_t data, int size)
{
    if (overflow_general(data, size))
        warn_overflow(ERR_PASS1, size);
}

static void warn_overflow_opd(const struct operand *o, int size)
{
    if (o->wrt == NO_SEG && o->segment == NO_SEG) {
        if (overflow_general(o->offset, size))
            warn_overflow(ERR_PASS2, size);
    }
}

/*
 * This routine wrappers the real output format's output routine,
 * in order to pass a copy of the data off to the listing file
 * generator at the same time.
 */
static void out(int64_t offset, int32_t segto, const void *data,
                enum out_type type, uint64_t size,
                int32_t segment, int32_t wrt)
{
    static int32_t lineno = 0;     /* static!!! */
    static char *lnfname = NULL;
    uint8_t p[8];

    if (type == OUT_ADDRESS && segment == NO_SEG && wrt == NO_SEG) {
        /*
         * This is a non-relocated address, and we're going to
         * convert it into RAWDATA format.
         */
        uint8_t *q = p;

        if (size > 8) {
            errfunc(ERR_PANIC, "OUT_ADDRESS with size > 8");
            return;
        }

        WRITEADDR(q, *(int64_t *)data, size);
        data = p;
        type = OUT_RAWDATA;
    }

    list->output(offset, data, type, size);

    /*
     * this call to src_get determines when we call the
     * debug-format-specific "linenum" function
     * it updates lineno and lnfname to the current values
     * returning 0 if "same as last time", -2 if lnfname
     * changed, and the amount by which lineno changed,
     * if it did. thus, these variables must be static
     */

    if (src_get(&lineno, &lnfname))
        outfmt->current_dfmt->linenum(lnfname, lineno, segto);

    outfmt->output(segto, data, type, size, segment, wrt);
}

static bool jmp_match(int32_t segment, int64_t offset, int bits,
                     insn * ins, const uint8_t *code)
{
    int64_t isize;
    uint8_t c = code[0];

    if ((c != 0370 && c != 0371) || (ins->oprs[0].type & STRICT))
        return false;
    if (!optimizing)
        return false;
    if (optimizing < 0 && c == 0371)
        return false;

    isize = calcsize(segment, offset, bits, ins, code);

    if (ins->oprs[0].opflags & OPFLAG_UNKNOWN)
        /* Be optimistic in pass 1 */
        return true;

    if (ins->oprs[0].segment != segment)
        return false;

    isize = ins->oprs[0].offset - offset - isize; /* isize is delta */
    return (isize >= -128 && isize <= 127); /* is it byte size? */
}

int64_t assemble(int32_t segment, int64_t offset, int bits, uint32_t cp,
                 insn * instruction, struct ofmt *output, efunc error,
                 ListGen * listgen)
{
    const struct itemplate *temp;
    int j;
    enum match_result m;
    int64_t insn_end;
    int32_t itimes;
    int64_t start = offset;
    int64_t wsize;              /* size for DB etc. */

    errfunc = error;            /* to pass to other functions */
    cpu = cp;
    outfmt = output;            /* likewise */
    list = listgen;             /* and again */

    wsize = idata_bytes(instruction->opcode);
    if (wsize == -1)
        return 0;

    if (wsize) {
        extop *e;
        int32_t t = instruction->times;
        if (t < 0)
            errfunc(ERR_PANIC,
                    "instruction->times < 0 (%ld) in assemble()", t);

        while (t--) {           /* repeat TIMES times */
            list_for_each(e, instruction->eops) {
                if (e->type == EOT_DB_NUMBER) {
                    if (wsize > 8) {
                        errfunc(ERR_NONFATAL,
                                "integer supplied to a DT, DO or DY"
                                " instruction");
                    } else {
                        out(offset, segment, &e->offset,
                            OUT_ADDRESS, wsize, e->segment, e->wrt);
                        offset += wsize;
                    }
                } else if (e->type == EOT_DB_STRING ||
                           e->type == EOT_DB_STRING_FREE) {
                    int align;

                    out(offset, segment, e->stringval,
                        OUT_RAWDATA, e->stringlen, NO_SEG, NO_SEG);
                    align = e->stringlen % wsize;

                    if (align) {
                        align = wsize - align;
                        out(offset, segment, zero_buffer,
                            OUT_RAWDATA, align, NO_SEG, NO_SEG);
                    }
                    offset += e->stringlen + align;
                }
            }
            if (t > 0 && t == instruction->times - 1) {
                /*
                 * Dummy call to list->output to give the offset to the
                 * listing module.
                 */
                list->output(offset, NULL, OUT_RAWDATA, 0);
                list->uplevel(LIST_TIMES);
            }
        }
        if (instruction->times > 1)
            list->downlevel(LIST_TIMES);
        return offset - start;
    }

    if (instruction->opcode == I_INCBIN) {
        const char *fname = instruction->eops->stringval;
        FILE *fp;

        fp = fopen(fname, "rb");
        if (!fp) {
            error(ERR_NONFATAL, "`incbin': unable to open file `%s'",
                  fname);
        } else if (fseek(fp, 0L, SEEK_END) < 0) {
            error(ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
                  fname);
        } else {
            static char buf[4096];
            size_t t = instruction->times;
            size_t base = 0;
            size_t len;

            len = ftell(fp);
            if (instruction->eops->next) {
                base = instruction->eops->next->offset;
                len -= base;
                if (instruction->eops->next->next &&
                    len > (size_t)instruction->eops->next->next->offset)
                    len = (size_t)instruction->eops->next->next->offset;
            }
            /*
             * Dummy call to list->output to give the offset to the
             * listing module.
             */
            list->output(offset, NULL, OUT_RAWDATA, 0);
            list->uplevel(LIST_INCBIN);
            while (t--) {
                size_t l;

                fseek(fp, base, SEEK_SET);
                l = len;
                while (l > 0) {
                    int32_t m;
                    m = fread(buf, 1, l > sizeof(buf) ? sizeof(buf) : l, fp);
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
                    out(offset, segment, buf, OUT_RAWDATA, m,
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
                list->output(offset, NULL, OUT_RAWDATA, 0);
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

    m = find_match(&temp, instruction, segment, offset, bits);

    if (m == MOK_GOOD) {
        /* Matches! */
        int64_t insn_size = calcsize(segment, offset, bits,
                                     instruction, temp->code);
        itimes = instruction->times;
        if (insn_size < 0)  /* shouldn't be, on pass two */
            error(ERR_PANIC, "errors made it through from pass one");
        else
            while (itimes--) {
                for (j = 0; j < MAXPREFIX; j++) {
                    uint8_t c = 0;
                    switch (instruction->prefixes[j]) {
                    case P_WAIT:
                        c = 0x9B;
                        break;
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
                            error(ERR_WARNING | ERR_PASS2,
                                  "cs segment base generated, but will be ignored in 64-bit mode");
                        }
                        c = 0x2E;
                        break;
                    case R_DS:
                        if (bits == 64) {
                            error(ERR_WARNING | ERR_PASS2,
                                  "ds segment base generated, but will be ignored in 64-bit mode");
                        }
                        c = 0x3E;
                        break;
                    case R_ES:
                        if (bits == 64) {
                            error(ERR_WARNING | ERR_PASS2,
                                  "es segment base generated, but will be ignored in 64-bit mode");
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
                            error(ERR_WARNING | ERR_PASS2,
                                  "ss segment base generated, but will be ignored in 64-bit mode");
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
                        out(offset, segment, &c, OUT_RAWDATA, 1,
                            NO_SEG, NO_SEG);
                        offset++;
                    }
                }
                insn_end = offset + insn_size;
                gencode(segment, offset, bits, instruction,
                        temp, insn_end);
                offset += insn_size;
                if (itimes > 0 && itimes == instruction->times - 1) {
                    /*
                     * Dummy call to list->output to give the offset to the
                     * listing module.
                     */
                    list->output(offset, NULL, OUT_RAWDATA, 0);
                    list->uplevel(LIST_TIMES);
                }
            }
        if (instruction->times > 1)
            list->downlevel(LIST_TIMES);
        return offset - start;
    } else {
        /* No match */
        switch (m) {
        case MERR_OPSIZEMISSING:
            error(ERR_NONFATAL, "operation size not specified");
            break;
        case MERR_OPSIZEMISMATCH:
            error(ERR_NONFATAL, "mismatch in operand sizes");
            break;
        case MERR_BADCPU:
            error(ERR_NONFATAL, "no instruction for this cpu level");
            break;
        case MERR_BADMODE:
            error(ERR_NONFATAL, "instruction not supported in %d-bit mode",
                  bits);
            break;
        default:
            error(ERR_NONFATAL,
                  "invalid combination of opcode and operands");
            break;
        }
    }
    return 0;
}

int64_t insn_size(int32_t segment, int64_t offset, int bits, uint32_t cp,
                  insn * instruction, efunc error)
{
    const struct itemplate *temp;
    enum match_result m;

    errfunc = error;            /* to pass to other functions */
    cpu = cp;

    if (instruction->opcode == I_none)
        return 0;

    if (instruction->opcode == I_DB || instruction->opcode == I_DW ||
        instruction->opcode == I_DD || instruction->opcode == I_DQ ||
        instruction->opcode == I_DT || instruction->opcode == I_DO ||
        instruction->opcode == I_DY) {
        extop *e;
        int32_t isize, osize, wsize;

        isize = 0;
        wsize = idata_bytes(instruction->opcode);

        list_for_each(e, instruction->eops) {
            int32_t align;

            osize = 0;
            if (e->type == EOT_DB_NUMBER) {
                osize = 1;
                warn_overflow_const(e->offset, wsize);
            } else if (e->type == EOT_DB_STRING ||
                       e->type == EOT_DB_STRING_FREE)
                osize = e->stringlen;

            align = (-osize) % wsize;
            if (align < 0)
                align += wsize;
            isize += osize + align;
        }
        return isize * instruction->times;
    }

    if (instruction->opcode == I_INCBIN) {
        const char *fname = instruction->eops->stringval;
        FILE *fp;
        int64_t val = 0;
        size_t len;

        fp = fopen(fname, "rb");
        if (!fp)
            error(ERR_NONFATAL, "`incbin': unable to open file `%s'",
                  fname);
        else if (fseek(fp, 0L, SEEK_END) < 0)
            error(ERR_NONFATAL, "`incbin': unable to seek on file `%s'",
                  fname);
        else {
            len = ftell(fp);
            if (instruction->eops->next) {
                len -= instruction->eops->next->offset;
                if (instruction->eops->next->next &&
                    len > (size_t)instruction->eops->next->next->offset) {
                    len = (size_t)instruction->eops->next->next->offset;
                }
            }
            val = instruction->times * len;
        }
        if (fp)
            fclose(fp);
        return val;
    }

    /* Check to see if we need an address-size prefix */
    add_asp(instruction, bits);

    m = find_match(&temp, instruction, segment, offset, bits);
    if (m == MOK_GOOD) {
        /* we've matched an instruction. */
        int64_t isize;
        const uint8_t *codes = temp->code;
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
    } else {
        return -1;                  /* didn't match any instruction */
    }
}

static bool possible_sbyte(operand *o)
{
    return o->wrt == NO_SEG && o->segment == NO_SEG &&
        !(o->opflags & OPFLAG_UNKNOWN) &&
        optimizing >= 0 && !(o->type & STRICT);
}

/* check that opn[op]  is a signed byte of size 16 or 32 */
static bool is_sbyte16(operand *o)
{
    int16_t v;

    if (!possible_sbyte(o))
        return false;

    v = o->offset;
    return v >= -128 && v <= 127;
}

static bool is_sbyte32(operand *o)
{
    int32_t v;

    if (!possible_sbyte(o))
        return false;

    v = o->offset;
    return v >= -128 && v <= 127;
}

/* Common construct */
#define case4(x) case (x): case (x)+1: case (x)+2: case (x)+3

static int64_t calcsize(int32_t segment, int64_t offset, int bits,
                        insn * ins, const uint8_t *codes)
{
    int64_t length = 0;
    uint8_t c;
    int rex_mask = ~0;
    int op1, op2;
    struct operand *opx;
    uint8_t opex = 0;

    ins->rex = 0;               /* Ensure REX is reset */

    if (ins->prefixes[PPS_OSIZE] == P_O64)
        ins->rex |= REX_W;

    (void)segment;              /* Don't warn that this parameter is unused */
    (void)offset;               /* Don't warn that this parameter is unused */

    while (*codes) {
        c = *codes++;
        op1 = (c & 3) + ((opex & 1) << 2);
        op2 = ((c >> 3) & 3) + ((opex & 2) << 1);
        opx = &ins->oprs[op1];
        opex = 0;               /* For the next iteration */

        switch (c) {
        case 01:
        case 02:
        case 03:
        case 04:
            codes += c, length += c;
            break;

        case 05:
        case 06:
        case 07:
            opex = c;
            break;

        case4(010):
            ins->rex |=
                op_rexflags(opx, REX_B|REX_H|REX_P|REX_W);
            codes++, length++;
            break;

        case4(014):
        case4(020):
        case4(024):
            length++;
            break;

        case4(030):
            length += 2;
            break;

        case4(034):
            if (opx->type & (BITS16 | BITS32 | BITS64))
                length += (opx->type & BITS16) ? 2 : 4;
            else
                length += (bits == 16) ? 2 : 4;
            break;

        case4(040):
            length += 4;
            break;

        case4(044):
            length += ins->addr_size >> 3;
            break;

        case4(050):
            length++;
            break;

        case4(054):
            length += 8; /* MOV reg64/imm */
            break;

        case4(060):
            length += 2;
            break;

        case4(064):
            if (opx->type & (BITS16 | BITS32 | BITS64))
                length += (opx->type & BITS16) ? 2 : 4;
            else
                length += (bits == 16) ? 2 : 4;
            break;

        case4(070):
            length += 4;
            break;

        case4(074):
            length += 2;
            break;

        case4(0140):
            length += is_sbyte16(opx) ? 1 : 2;
            break;

        case4(0144):
            codes++;
            length++;
            break;

        case4(0150):
            length += is_sbyte32(opx) ? 1 : 4;
            break;

        case4(0154):
            codes++;
            length++;
            break;

        case4(0160):
            length++;
            ins->rex |= REX_D;
            ins->drexdst = regval(opx);
            break;

        case4(0164):
            length++;
            ins->rex |= REX_D|REX_OC;
            ins->drexdst = regval(opx);
            break;

        case 0171:
            break;

        case 0172:
        case 0173:
        case 0174:
            codes++;
            length++;
            break;

        case4(0250):
            length += is_sbyte32(opx) ? 1 : 4;
            break;

        case4(0254):
            length += 4;
            break;

        case4(0260):
            ins->rex |= REX_V;
            ins->drexdst = regval(opx);
            ins->vex_cm = *codes++;
            ins->vex_wlp = *codes++;
            break;

        case 0270:
            ins->rex |= REX_V;
            ins->drexdst = 0;
            ins->vex_cm = *codes++;
            ins->vex_wlp = *codes++;
            break;

        case4(0274):
            length++;
            break;

        case4(0300):
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

        case4(0314):
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

        case 0325:
            ins->rex |= REX_NH;
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

        case 0336:
            if (!ins->prefixes[PPS_LREP])
                ins->prefixes[PPS_LREP] = P_REP;
            break;

        case 0337:
            if (!ins->prefixes[PPS_LREP])
                ins->prefixes[PPS_LREP] = P_REPNE;
            break;

        case 0340:
            if (ins->oprs[0].segment != NO_SEG)
                errfunc(ERR_NONFATAL, "attempt to reserve non-constant"
                        " quantity of BSS space");
            else
                length += ins->oprs[0].offset;
            break;

        case 0341:
            if (!ins->prefixes[PPS_WAIT])
                ins->prefixes[PPS_WAIT] = P_WAIT;
            break;

        case4(0344):
            length++;
            break;

        case 0360:
            break;

        case 0361:
        case 0362:
        case 0363:
            length++;
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

        case4(0100):
        case4(0110):
        case4(0120):
        case4(0130):
        case4(0200):
        case4(0204):
        case4(0210):
        case4(0214):
        case4(0220):
        case4(0224):
        case4(0230):
        case4(0234):
            {
                ea ea_data;
                int rfield;
                opflags_t rflags;
                struct operand *opy = &ins->oprs[op2];

                ea_data.rex = 0;           /* Ensure ea.REX is initially 0 */

                if (c <= 0177) {
                    /* pick rfield from operand b (opx) */
                    rflags = regflag(opx);
                    rfield = nasm_regvals[opx->basereg];
                } else {
                    rflags = 0;
                    rfield = c & 7;
                }
                if (!process_ea(opy, &ea_data, bits,
                                ins->addr_size, rfield, rflags)) {
                    errfunc(ERR_NONFATAL, "invalid effective address");
                    return -1;
                } else {
                    ins->rex |= ea_data.rex;
                    length += ea_data.size;
                }
            }
            break;

        default:
            errfunc(ERR_PANIC, "internal instruction table corrupt"
                    ": instruction code \\%o (0x%02X) given", c, c);
            break;
        }
    }

    ins->rex &= rex_mask;

    if (ins->rex & REX_NH) {
        if (ins->rex & REX_H) {
            errfunc(ERR_NONFATAL, "instruction cannot use high registers");
            return -1;
        }
        ins->rex &= ~REX_P;        /* Don't force REX prefix due to high reg */
    }

    if (ins->rex & REX_V) {
        int bad32 = REX_R|REX_W|REX_X|REX_B;

        if (ins->rex & REX_H) {
            errfunc(ERR_NONFATAL, "cannot use high register in vex instruction");
            return -1;
        }
        switch (ins->vex_wlp & 060) {
        case 000:
        case 040:
            ins->rex &= ~REX_W;
            break;
        case 020:
            ins->rex |= REX_W;
            bad32 &= ~REX_W;
            break;
        case 060:
            /* Follow REX_W */
            break;
        }

        if (bits != 64 && ((ins->rex & bad32) || ins->drexdst > 7)) {
            errfunc(ERR_NONFATAL, "invalid operands in non-64-bit mode");
            return -1;
        }
        if (ins->vex_cm != 1 || (ins->rex & (REX_W|REX_X|REX_B)))
            length += 3;
        else
            length += 2;
    } else if (ins->rex & REX_D) {
        if (ins->rex & REX_H) {
            errfunc(ERR_NONFATAL, "cannot use high register in drex instruction");
            return -1;
        }
        if (bits != 64 && ((ins->rex & (REX_R|REX_W|REX_X|REX_B)) ||
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

#define EMIT_REX()                                                              \
    if (!(ins->rex & (REX_D|REX_V)) && (ins->rex & REX_REAL) && (bits == 64)) { \
        ins->rex = (ins->rex & REX_REAL)|REX_P;                                 \
        out(offset, segment, &ins->rex, OUT_RAWDATA, 1, NO_SEG, NO_SEG);        \
        ins->rex = 0;                                                           \
        offset += 1;                                                            \
    }

static void gencode(int32_t segment, int64_t offset, int bits,
                    insn * ins, const struct itemplate *temp,
                    int64_t insn_end)
{
    static char condval[] = {   /* conditional opcodes */
        0x7, 0x3, 0x2, 0x6, 0x2, 0x4, 0xF, 0xD, 0xC, 0xE, 0x6, 0x2,
        0x3, 0x7, 0x3, 0x5, 0xE, 0xC, 0xD, 0xF, 0x1, 0xB, 0x9, 0x5,
        0x0, 0xA, 0xA, 0xB, 0x8, 0x4
    };
    uint8_t c;
    uint8_t bytes[4];
    int64_t size;
    int64_t data;
    int op1, op2;
    struct operand *opx;
    const uint8_t *codes = temp->code;
    uint8_t opex = 0;

    while (*codes) {
        c = *codes++;
        op1 = (c & 3) + ((opex & 1) << 2);
        op2 = ((c >> 3) & 3) + ((opex & 2) << 1);
        opx = &ins->oprs[op1];
        opex = 0;                /* For the next iteration */

        switch (c) {
        case 01:
        case 02:
        case 03:
        case 04:
            EMIT_REX();
            out(offset, segment, codes, OUT_RAWDATA, c, NO_SEG, NO_SEG);
            codes += c;
            offset += c;
            break;

        case 05:
        case 06:
        case 07:
            opex = c;
            break;

        case4(010):
            EMIT_REX();
            bytes[0] = *codes++ + (regval(opx) & 7);
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case4(014):
            /*
             * The test for BITS8 and SBYTE here is intended to avoid
             * warning on optimizer actions due to SBYTE, while still
             * warn on explicit BYTE directives.  Also warn, obviously,
             * if the optimizer isn't enabled.
             */
            if (((opx->type & BITS8) ||
                 !(opx->type & temp->opd[op1] & BYTENESS)) &&
                (opx->offset < -128 || opx->offset > 127)) {
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "signed byte value exceeds bounds");
            }
            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS, 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case4(020):
            if (opx->offset < -256 || opx->offset > 255) {
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "byte value exceeds bounds");
            }
            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS, 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case4(024):
            if (opx->offset < 0 || opx->offset > 255)
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "unsigned byte value exceeds bounds");
            if (opx->segment != NO_SEG) {
                data = opx->offset;
                out(offset, segment, &data, OUT_ADDRESS, 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = opx->offset;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;

        case4(030):
            warn_overflow_opd(opx, 2);
            data = opx->offset;
            out(offset, segment, &data, OUT_ADDRESS, 2,
                opx->segment, opx->wrt);
            offset += 2;
            break;

        case4(034):
            if (opx->type & (BITS16 | BITS32))
                size = (opx->type & BITS16) ? 2 : 4;
            else
                size = (bits == 16) ? 2 : 4;
            warn_overflow_opd(opx, size);
            data = opx->offset;
            out(offset, segment, &data, OUT_ADDRESS, size,
                opx->segment, opx->wrt);
            offset += size;
            break;

        case4(040):
            warn_overflow_opd(opx, 4);
            data = opx->offset;
            out(offset, segment, &data, OUT_ADDRESS, 4,
                opx->segment, opx->wrt);
            offset += 4;
            break;

        case4(044):
            data = opx->offset;
            size = ins->addr_size >> 3;
            warn_overflow_opd(opx, size);
            out(offset, segment, &data, OUT_ADDRESS, size,
                opx->segment, opx->wrt);
            offset += size;
            break;

        case4(050):
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    OUT_REL1ADR, insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                if (data > 127 || data < -128)
                    errfunc(ERR_NONFATAL, "short jump is out of range");
                out(offset, segment, &data,
                    OUT_ADDRESS, 1, NO_SEG, NO_SEG);
            }
            offset += 1;
            break;

        case4(054):
            data = (int64_t)opx->offset;
            out(offset, segment, &data, OUT_ADDRESS, 8,
                opx->segment, opx->wrt);
            offset += 8;
            break;

        case4(060):
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    OUT_REL2ADR, insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS, 2, NO_SEG, NO_SEG);
            }
            offset += 2;
            break;

        case4(064):
            if (opx->type & (BITS16 | BITS32 | BITS64))
                size = (opx->type & BITS16) ? 2 : 4;
            else
                size = (bits == 16) ? 2 : 4;
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    size == 2 ? OUT_REL2ADR : OUT_REL4ADR,
                    insn_end - offset, opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS, size, NO_SEG, NO_SEG);
            }
            offset += size;
            break;

        case4(070):
            if (opx->segment != segment) {
                data = opx->offset;
                out(offset, segment, &data,
                    OUT_REL4ADR, insn_end - offset,
                    opx->segment, opx->wrt);
            } else {
                data = opx->offset - insn_end;
                out(offset, segment, &data,
                    OUT_ADDRESS, 4, NO_SEG, NO_SEG);
            }
            offset += 4;
            break;

        case4(074):
            if (opx->segment == NO_SEG)
                errfunc(ERR_NONFATAL, "value referenced by FAR is not"
                        " relocatable");
            data = 0;
            out(offset, segment, &data, OUT_ADDRESS, 2,
                outfmt->segbase(1 + opx->segment),
                opx->wrt);
            offset += 2;
            break;

        case4(0140):
            data = opx->offset;
            warn_overflow_opd(opx, 2);
            if (is_sbyte16(opx)) {
                bytes[0] = data;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
                offset++;
            } else {
                out(offset, segment, &data, OUT_ADDRESS, 2,
                    opx->segment, opx->wrt);
                offset += 2;
            }
            break;

        case4(0144):
            EMIT_REX();
            bytes[0] = *codes++;
            if (is_sbyte16(opx))
                bytes[0] |= 2;  /* s-bit */
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case4(0150):
            data = opx->offset;
            warn_overflow_opd(opx, 4);
            if (is_sbyte32(opx)) {
                bytes[0] = data;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
                offset++;
            } else {
                out(offset, segment, &data, OUT_ADDRESS, 4,
                    opx->segment, opx->wrt);
                offset += 4;
            }
            break;

        case4(0154):
            EMIT_REX();
            bytes[0] = *codes++;
            if (is_sbyte32(opx))
                bytes[0] |= 2;  /* s-bit */
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case4(0160):
        case4(0164):
            break;

        case 0171:
            bytes[0] =
                (ins->drexdst << 4) |
                (ins->rex & REX_OC ? 0x08 : 0) |
                (ins->rex & (REX_R|REX_X|REX_B));
            ins->rex = 0;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0172:
            c = *codes++;
            opx = &ins->oprs[c >> 3];
            bytes[0] = nasm_regvals[opx->basereg] << 4;
            opx = &ins->oprs[c & 7];
            if (opx->segment != NO_SEG || opx->wrt != NO_SEG) {
                errfunc(ERR_NONFATAL,
                        "non-absolute expression not permitted as argument %d",
                        c & 7);
            } else {
                if (opx->offset & ~15) {
                    errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                            "four-bit argument exceeds bounds");
                }
                bytes[0] |= opx->offset & 15;
            }
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0173:
            c = *codes++;
            opx = &ins->oprs[c >> 4];
            bytes[0] = nasm_regvals[opx->basereg] << 4;
            bytes[0] |= c & 15;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0174:
            c = *codes++;
            opx = &ins->oprs[c];
            bytes[0] = nasm_regvals[opx->basereg] << 4;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case4(0250):
            data = opx->offset;
            if (opx->wrt == NO_SEG && opx->segment == NO_SEG &&
                (int32_t)data != (int64_t)data) {
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "signed dword immediate exceeds bounds");
            }
            if (is_sbyte32(opx)) {
                bytes[0] = data;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
                offset++;
            } else {
                out(offset, segment, &data, OUT_ADDRESS, 4,
                    opx->segment, opx->wrt);
                offset += 4;
            }
            break;

        case4(0254):
            data = opx->offset;
            if (opx->wrt == NO_SEG && opx->segment == NO_SEG &&
                (int32_t)data != (int64_t)data) {
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "signed dword immediate exceeds bounds");
            }
            out(offset, segment, &data, OUT_ADDRESS, 4,
                opx->segment, opx->wrt);
            offset += 4;
            break;

        case4(0260):
        case 0270:
            codes += 2;
            if (ins->vex_cm != 1 || (ins->rex & (REX_W|REX_X|REX_B))) {
                bytes[0] = (ins->vex_cm >> 6) ? 0x8f : 0xc4;
                bytes[1] = (ins->vex_cm & 31) | ((~ins->rex & 7) << 5);
                bytes[2] = ((ins->rex & REX_W) << (7-3)) |
                    ((~ins->drexdst & 15)<< 3) | (ins->vex_wlp & 07);
                out(offset, segment, &bytes, OUT_RAWDATA, 3, NO_SEG, NO_SEG);
                offset += 3;
            } else {
                bytes[0] = 0xc5;
                bytes[1] = ((~ins->rex & REX_R) << (7-2)) |
                    ((~ins->drexdst & 15) << 3) | (ins->vex_wlp & 07);
                out(offset, segment, &bytes, OUT_RAWDATA, 2, NO_SEG, NO_SEG);
                offset += 2;
            }
            break;

        case4(0274):
        {
            uint64_t uv, um;
            int s;

            if (ins->rex & REX_W)
                s = 64;
            else if (ins->prefixes[PPS_OSIZE] == P_O16)
                s = 16;
            else if (ins->prefixes[PPS_OSIZE] == P_O32)
                s = 32;
            else
                s = bits;

            um = (uint64_t)2 << (s-1);
            uv = opx->offset;

            if (uv > 127 && uv < (uint64_t)-128 &&
                (uv < um-128 || uv > um-1)) {
                errfunc(ERR_WARNING | ERR_PASS2 | ERR_WARN_NOV,
                        "signed byte value exceeds bounds");
            }
            if (opx->segment != NO_SEG) {
                data = uv;
                out(offset, segment, &data, OUT_ADDRESS, 1,
                    opx->segment, opx->wrt);
            } else {
                bytes[0] = uv;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG,
                    NO_SEG);
            }
            offset += 1;
            break;
        }

        case4(0300):
            break;

        case 0310:
            if (bits == 32 && !has_prefix(ins, PPS_ASIZE, P_A16)) {
                *bytes = 0x67;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0311:
            if (bits != 32 && !has_prefix(ins, PPS_ASIZE, P_A32)) {
                *bytes = 0x67;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
                offset += 1;
            } else
                offset += 0;
            break;

        case 0312:
            break;

        case 0313:
            ins->rex = 0;
            break;

        case4(0314):
            break;

        case 0320:
        {
            enum prefixes pfx = ins->prefixes[PPS_OSIZE];
            if (pfx != P_O16 && pfx != P_none)
                nasm_error(ERR_WARNING, "Invalid operand size prefix");
            if (pfx != P_O16 && bits != 16) {
                ins->prefixes[PPS_OSIZE] = P_O16;
                *bytes = 0x66;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
                offset += 1;
            }
            break;
        }

        case 0321:
        {
            enum prefixes pfx = ins->prefixes[PPS_OSIZE];
            if (pfx != P_O32 && pfx != P_none)
                nasm_error(ERR_WARNING, "Invalid operand size prefix");
            if (pfx != P_O32 && bits == 16) {
                ins->prefixes[PPS_OSIZE] = P_O32;
                *bytes = 0x66;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
                offset += 1;
            }
            break;
        }

        case 0322:
        case 0323:
            break;

        case 0324:
            ins->rex |= REX_W;
            break;

        case 0325:
            break;

        case 0330:
            *bytes = *codes++ ^ condval[ins->condition];
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0331:
            break;

        case 0332:
        case 0333:
            *bytes = c - 0332 + 0xF2;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0334:
            if (ins->rex & REX_R) {
                *bytes = 0xF0;
                out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
                offset += 1;
            }
            ins->rex &= ~(REX_L|REX_R);
            break;

        case 0335:
            break;

        case 0336:
        case 0337:
            break;

        case 0340:
            if (ins->oprs[0].segment != NO_SEG)
                errfunc(ERR_PANIC, "non-constant BSS size in pass two");
            else {
                int64_t size = ins->oprs[0].offset;
                if (size > 0)
                    out(offset, segment, NULL,
                        OUT_RESERVE, size, NO_SEG, NO_SEG);
                offset += size;
            }
            break;

        case 0341:
            break;

        case 0344:
        case 0345:
            bytes[0] = c & 1;
            switch (ins->oprs[0].basereg) {
            case R_CS:
                bytes[0] += 0x0E;
                break;
            case R_DS:
                bytes[0] += 0x1E;
                break;
            case R_ES:
                bytes[0] += 0x06;
                break;
            case R_SS:
                bytes[0] += 0x16;
                break;
            default:
                errfunc(ERR_PANIC,
                        "bizarre 8086 segment register received");
            }
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0346:
        case 0347:
            bytes[0] = c & 1;
            switch (ins->oprs[0].basereg) {
            case R_FS:
                bytes[0] += 0xA0;
                break;
            case R_GS:
                bytes[0] += 0xA8;
                break;
            default:
                errfunc(ERR_PANIC,
                        "bizarre 386 segment register received");
            }
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset++;
            break;

        case 0360:
            break;

        case 0361:
            bytes[0] = 0x66;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0362:
        case 0363:
            bytes[0] = c - 0362 + 0xf2;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0364:
        case 0365:
            break;

        case 0366:
        case 0367:
            *bytes = c - 0366 + 0x66;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case 0370:
        case 0371:
        case 0372:
            break;

        case 0373:
            *bytes = bits == 16 ? 3 : 5;
            out(offset, segment, bytes, OUT_RAWDATA, 1, NO_SEG, NO_SEG);
            offset += 1;
            break;

        case4(0100):
        case4(0110):
        case4(0120):
        case4(0130):
        case4(0200):
        case4(0204):
        case4(0210):
        case4(0214):
        case4(0220):
        case4(0224):
        case4(0230):
        case4(0234):
            {
                ea ea_data;
                int rfield;
                opflags_t rflags;
                uint8_t *p;
                int32_t s;
                enum out_type type;
                struct operand *opy = &ins->oprs[op2];

                if (c <= 0177) {
                    /* pick rfield from operand b (opx) */
                    rflags = regflag(opx);
                    rfield = nasm_regvals[opx->basereg];
                } else {
                    /* rfield is constant */
                    rflags = 0;
                    rfield = c & 7;
                }

                if (!process_ea(opy, &ea_data, bits, ins->addr_size,
                                rfield, rflags)) {
                    errfunc(ERR_NONFATAL, "invalid effective address");
                }


                p = bytes;
                *p++ = ea_data.modrm;
                if (ea_data.sib_present)
                    *p++ = ea_data.sib;

                /* DREX suffixes come between the SIB and the displacement */
                if (ins->rex & REX_D) {
                    *p++ = (ins->drexdst << 4) |
                           (ins->rex & REX_OC ? 0x08 : 0) |
                           (ins->rex & (REX_R|REX_X|REX_B));
                    ins->rex = 0;
                }

                s = p - bytes;
                out(offset, segment, bytes, OUT_RAWDATA, s, NO_SEG, NO_SEG);

                /*
                 * Make sure the address gets the right offset in case
                 * the line breaks in the .lst file (BR 1197827)
                 */
                offset += s;
                s = 0;

                switch (ea_data.bytes) {
                case 0:
                    break;
                case 1:
                case 2:
                case 4:
                case 8:
                    data = opy->offset;
                    s += ea_data.bytes;
                    if (ea_data.rip) {
                        if (opy->segment == segment) {
                            data -= insn_end;
                            if (overflow_signed(data, ea_data.bytes))
                                warn_overflow(ERR_PASS2, ea_data.bytes);
                            out(offset, segment, &data, OUT_ADDRESS,
                                ea_data.bytes, NO_SEG, NO_SEG);
                        } else {
                            /* overflow check in output/linker? */
                            out(offset, segment, &data,        OUT_REL4ADR,
                                insn_end - offset, opy->segment, opy->wrt);
                        }
                    } else {
                        if (overflow_general(opy->offset, ins->addr_size >> 3) ||
                            signed_bits(opy->offset, ins->addr_size) !=
                            signed_bits(opy->offset, ea_data.bytes * 8))
                            warn_overflow(ERR_PASS2, ea_data.bytes);

                        type = OUT_ADDRESS;
                        out(offset, segment, &data, OUT_ADDRESS,
                            ea_data.bytes, opy->segment, opy->wrt);
                    }
                    break;
                default:
                    /* Impossible! */
                    errfunc(ERR_PANIC,
                            "Invalid amount of bytes (%d) for offset?!",
                            ea_data.bytes);
                    break;
                }
                offset += s;
            }
            break;

        default:
            errfunc(ERR_PANIC, "internal instruction table corrupt"
                    ": instruction code \\%o (0x%02X) given", c, c);
            break;
        }
    }
}

static opflags_t regflag(const operand * o)
{
    if (!is_register(o->basereg))
        errfunc(ERR_PANIC, "invalid operand passed to regflag()");
    return nasm_reg_flags[o->basereg];
}

static int32_t regval(const operand * o)
{
    if (!is_register(o->basereg))
        errfunc(ERR_PANIC, "invalid operand passed to regval()");
    return nasm_regvals[o->basereg];
}

static int op_rexflags(const operand * o, int mask)
{
    opflags_t flags;
    int val;

    if (!is_register(o->basereg))
        errfunc(ERR_PANIC, "invalid operand passed to op_rexflags()");

    flags = nasm_reg_flags[o->basereg];
    val = nasm_regvals[o->basereg];

    return rexflags(val, flags, mask);
}

static int rexflags(int val, opflags_t flags, int mask)
{
    int rex = 0;

    if (val >= 8)
        rex |= REX_B|REX_X|REX_R;
    if (flags & BITS64)
        rex |= REX_W;
    if (!(REG_HIGH & ~flags))                   /* AH, CH, DH, BH */
        rex |= REX_H;
    else if (!(REG8 & ~flags) && val >= 4)      /* SPL, BPL, SIL, DIL */
        rex |= REX_P;

    return rex & mask;
}

static enum match_result find_match(const struct itemplate **tempp,
                                    insn *instruction,
                                    int32_t segment, int64_t offset, int bits)
{
    const struct itemplate *temp;
    enum match_result m, merr;
    opflags_t xsizeflags[MAX_OPERANDS];
    bool opsizemissing = false;
    int i;

    for (i = 0; i < instruction->operands; i++)
        xsizeflags[i] = instruction->oprs[i].type & SIZE_MASK;

    merr = MERR_INVALOP;

    for (temp = nasm_instructions[instruction->opcode];
         temp->opcode != I_none; temp++) {
        m = matches(temp, instruction, bits);
        if (m == MOK_JUMP) {
            if (jmp_match(segment, offset, bits, instruction, temp->code))
                m = MOK_GOOD;
            else
                m = MERR_INVALOP;
        } else if (m == MERR_OPSIZEMISSING &&
                   (temp->flags & IF_SMASK) != IF_SX) {
            /*
             * Missing operand size and a candidate for fuzzy matching...
             */
            for (i = 0; i < temp->operands; i++) {
                if ((temp->opd[i] & SAME_AS) == 0)
                    xsizeflags[i] |= temp->opd[i] & SIZE_MASK;
            }
            opsizemissing = true;
        }
        if (m > merr)
            merr = m;
        if (merr == MOK_GOOD)
            goto done;
    }

    /* No match, but see if we can get a fuzzy operand size match... */
    if (!opsizemissing)
        goto done;

    for (i = 0; i < instruction->operands; i++) {
        /*
         * We ignore extrinsic operand sizes on registers, so we should
         * never try to fuzzy-match on them.  This also resolves the case
         * when we have e.g. "xmmrm128" in two different positions.
         */
        if (is_class(REGISTER, instruction->oprs[i].type))
            continue;

        /* This tests if xsizeflags[i] has more than one bit set */
        if ((xsizeflags[i] & (xsizeflags[i]-1)))
            goto done;                /* No luck */

        instruction->oprs[i].type |= xsizeflags[i]; /* Set the size */
    }

    /* Try matching again... */
    for (temp = nasm_instructions[instruction->opcode];
         temp->opcode != I_none; temp++) {
        m = matches(temp, instruction, bits);
        if (m == MOK_JUMP) {
            if (jmp_match(segment, offset, bits, instruction, temp->code))
                m = MOK_GOOD;
            else
                m = MERR_INVALOP;
        }
        if (m > merr)
            merr = m;
        if (merr == MOK_GOOD)
            goto done;
    }

done:
    *tempp = temp;
    return merr;
}

static enum match_result matches(const struct itemplate *itemp,
                                 insn *instruction, int bits)
{
    int i, size[MAX_OPERANDS], asize, oprs;
    bool opsizemissing = false;

    /*
     * Check the opcode
     */
    if (itemp->opcode != instruction->opcode)
        return MERR_INVALOP;

    /*
     * Count the operands
     */
    if (itemp->operands != instruction->operands)
        return MERR_INVALOP;

    /*
     * Check that no spurious colons or TOs are present
     */
    for (i = 0; i < itemp->operands; i++)
        if (instruction->oprs[i].type & ~itemp->opd[i] & (COLON | TO))
            return MERR_INVALOP;

    /*
     * Process size flags
     */
    switch (itemp->flags & IF_SMASK) {
    case IF_SB:
        asize = BITS8;
        break;
    case IF_SW:
        asize = BITS16;
        break;
    case IF_SD:
        asize = BITS32;
        break;
    case IF_SQ:
        asize = BITS64;
        break;
    case IF_SO:
        asize = BITS128;
        break;
    case IF_SY:
        asize = BITS256;
        break;
    case IF_SZ:
        switch (bits) {
        case 16:
            asize = BITS16;
            break;
        case 32:
            asize = BITS32;
            break;
        case 64:
            asize = BITS64;
            break;
        default:
            asize = 0;
            break;
        }
        break;
    default:
        asize = 0;
        break;
    }

    if (itemp->flags & IF_ARMASK) {
        /* S- flags only apply to a specific operand */
        i = ((itemp->flags & IF_ARMASK) >> IF_ARSHFT) - 1;
        memset(size, 0, sizeof size);
        size[i] = asize;
    } else {
        /* S- flags apply to all operands */
        for (i = 0; i < MAX_OPERANDS; i++)
            size[i] = asize;
    }

    /*
     * Check that the operand flags all match up,
     * it's a bit tricky so lets be verbose:
     *
     * 1) Find out the size of operand. If instruction
     *    doesn't have one specified -- we're trying to
     *    guess it either from template (IF_S* flag) or
     *    from code bits.
     *
     * 2) If template operand (i) has SAME_AS flag [used for registers only]
     *    (ie the same operand as was specified somewhere in template, and
     *    this referred operand index is being achieved via ~SAME_AS)
     *    we are to be sure that both registers (in template and instruction)
     *    do exactly match.
     *
     * 3) If template operand do not match the instruction OR
     *    template has an operand size specified AND this size differ
     *    from which instruction has (perhaps we got it from code bits)
     *    we are:
     *      a)  Check that only size of instruction and operand is differ
     *          other characteristics do match
     *      b)  Perhaps it's a register specified in instruction so
     *          for such a case we just mark that operand as "size
     *          missing" and this will turn on fuzzy operand size
     *          logic facility (handled by a caller)
     */
    for (i = 0; i < itemp->operands; i++) {
        opflags_t type = instruction->oprs[i].type;
        if (!(type & SIZE_MASK))
            type |= size[i];

        if (itemp->opd[i] & SAME_AS) {
            int j = itemp->opd[i] & ~SAME_AS;
            if (type != instruction->oprs[j].type ||
                instruction->oprs[i].basereg != instruction->oprs[j].basereg)
                return MERR_INVALOP;
        } else if (itemp->opd[i] & ~type ||
            ((itemp->opd[i] & SIZE_MASK) &&
             ((itemp->opd[i] ^ type) & SIZE_MASK))) {
            if ((itemp->opd[i] & ~type & ~SIZE_MASK) || (type & SIZE_MASK)) {
                return MERR_INVALOP;
            } else if (!is_class(REGISTER, type)) {
                /*
                 * Note: we don't honor extrinsic operand sizes for registers,
                 * so "missing operand size" for a register should be
                 * considered a wildcard match rather than an error.
                 */
                opsizemissing = true;
            }
        }
    }

    if (opsizemissing)
        return MERR_OPSIZEMISSING;

    /*
     * Check operand sizes
     */
    if (itemp->flags & (IF_SM | IF_SM2)) {
        oprs = (itemp->flags & IF_SM2 ? 2 : itemp->operands);
        for (i = 0; i < oprs; i++) {
            asize = itemp->opd[i] & SIZE_MASK;
            if (asize) {
                for (i = 0; i < oprs; i++)
                    size[i] = asize;
                break;
            }
        }
    } else {
        oprs = itemp->operands;
    }

    for (i = 0; i < itemp->operands; i++) {
        if (!(itemp->opd[i] & SIZE_MASK) &&
            (instruction->oprs[i].type & SIZE_MASK & ~size[i]))
            return MERR_OPSIZEMISMATCH;
    }

    /*
     * Check template is okay at the set cpu level
     */
    if (((itemp->flags & IF_PLEVEL) > cpu))
        return MERR_BADCPU;

    /*
     * Verify the appropriate long mode flag.
     */
    if ((itemp->flags & (bits == 64 ? IF_NOLONG : IF_LONG)))
        return MERR_BADMODE;

    /*
     * Check if special handling needed for Jumps
     */
    if ((itemp->code[0] & 0374) == 0370)
        return MOK_JUMP;

    return MOK_GOOD;
}

static ea *process_ea(operand * input, ea * output, int bits,
                      int addrbits, int rfield, opflags_t rflags)
{
    bool forw_ref = !!(input->opflags & OPFLAG_UNKNOWN);

    output->rip = false;

    /* REX flags for the rfield operand */
    output->rex |= rexflags(rfield, rflags, REX_R | REX_P | REX_W | REX_H);

    if (is_class(REGISTER, input->type)) {  /* register direct */
        int i;
        opflags_t f;

        if (!is_register(input->basereg))
            return NULL;
        f = regflag(input);
        i = nasm_regvals[input->basereg];

        if (REG_EA & ~f)
            return NULL;        /* Invalid EA register */

        output->rex |= op_rexflags(input, REX_B | REX_P | REX_W | REX_H);

        output->sib_present = false;    /* no SIB necessary */
        output->bytes = 0;              /* no offset necessary either */
        output->modrm = 0xC0 | ((rfield & 7) << 3) | (i & 7);
    } else {                    /* it's a memory reference */
        if (input->basereg == -1 &&
            (input->indexreg == -1 || input->scale == 0)) {
            /* it's a pure offset */

            if (bits == 64 && ((input->type & IP_REL) == IP_REL) &&
                input->segment == NO_SEG) {
                nasm_error(ERR_WARNING | ERR_PASS1, "absolute address can not be RIP-relative");
                input->type &= ~IP_REL;
                input->type |= MEMORY;
            }

            if (input->eaflags & EAF_BYTEOFFS ||
                (input->eaflags & EAF_WORDOFFS &&
                 input->disp_size != (addrbits != 16 ? 32 : 16))) {
                nasm_error(ERR_WARNING | ERR_PASS1, "displacement size ignored on absolute address");
            }

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
            int32_t seg = input->segment;
            int hb = input->hintbase, ht = input->hinttype;
            int t, it, bt;              /* register numbers */
            opflags_t x, ix, bx;        /* register flags */

            if (s == 0)
                i = -1;         /* make this easy, at least */

            if (is_register(i)) {
                it = nasm_regvals[i];
                ix = nasm_reg_flags[i];
            } else {
                it = -1;
                ix = 0;
            }

            if (is_register(b)) {
                bt = nasm_regvals[b];
                bx = nasm_reg_flags[b];
            } else {
                bt = -1;
                bx = 0;
            }

            /* check for a 32/64-bit memory reference... */
            if ((ix|bx) & (BITS32|BITS64)) {
                /*
                 * it must be a 32/64-bit memory reference. Firstly we have
                 * to check that all registers involved are type E/Rxx.
                 */
                int32_t sok = BITS32 | BITS64, o = input->offset;

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

                /*
                 * While we're here, ensure the user didn't specify
                 * WORD or QWORD
                 */
                if (input->disp_size == 16 || input->disp_size == 64)
                    return NULL;

                if (addrbits == 16 ||
                    (addrbits == 32 && !(sok & BITS32)) ||
                    (addrbits == 64 && !(sok & BITS64)))
                    return NULL;

                /* now reorganize base/index */
                if (s == 1 && bt != it && bt != -1 && it != -1 &&
                    ((hb == b && ht == EAH_NOTBASE) ||
                     (hb == i && ht == EAH_MAKEBASE))) {
                    /* swap if hints say so */
                    t = bt, bt = it, it = t;
                    x = bx, bx = ix, ix = x;
                }
                if (bt == it)     /* convert EAX+2*EAX to 3*EAX */
                    bt = -1, bx = 0, s++;
                if (bt == -1 && s == 1 && !(hb == it && ht == EAH_NOTBASE)) {
                    /* make single reg base, unless hint */
                    bt = it, bx = ix, it = -1, ix = 0;
                }
                if (((s == 2 && it != REG_NUM_ESP && !(input->eaflags & EAF_TIMESTWO)) ||
                      s == 3 || s == 5 || s == 9) && bt == -1)
                    bt = it, bx = ix, s--; /* convert 3*EAX to EAX+2*EAX */
                if (it == -1 && (bt & 7) != REG_NUM_ESP &&
                    (input->eaflags & EAF_TIMESTWO))
                    it = bt, ix = bx, bt = -1, bx = 0, s = 1;
                /* convert [NOSPLIT EAX] to sib format with 0x0 displacement */
                if (s == 1 && it == REG_NUM_ESP) {
                    /* swap ESP into base if scale is 1 */
                    t = it, it = bt, bt = t;
                    x = ix, ix = bx, bx = x;
                }
                if (it == REG_NUM_ESP ||
                    (s != 1 && s != 2 && s != 4 && s != 8 && it != -1))
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
                            !(input->eaflags & (EAF_BYTEOFFS | EAF_WORDOFFS)))
                            mod = 0;
                        else if (input->eaflags & EAF_BYTEOFFS ||
                                 (o >= -128 && o <= 127 &&
                                  seg == NO_SEG && !forw_ref &&
                                  !(input->eaflags & EAF_WORDOFFS)))
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
                            !(input->eaflags & (EAF_BYTEOFFS | EAF_WORDOFFS)))
                            mod = 0;
                        else if (input->eaflags & EAF_BYTEOFFS ||
                                 (o >= -128 && o <= 127 &&
                                  seg == NO_SEG && !forw_ref &&
                                  !(input->eaflags & EAF_WORDOFFS)))
                            mod = 1;
                        else
                            mod = 2;
                    }

                    output->sib_present = true;
                    output->bytes = (bt == -1 || mod == 2 ? 4 : mod);
                    output->modrm = (mod << 6) | ((rfield & 7) << 3) | 4;
                    output->sib = (scale << 6) | (index << 3) | base;
                }
            } else {            /* it's 16-bit */
                int mod, rm;
                int16_t o = input->offset;

                /* check for 64-bit long mode */
                if (addrbits == 64)
                    return NULL;

                /* check all registers are BX, BP, SI or DI */
                if ((b != -1 && b != R_BP && b != R_BX && b != R_SI && b != R_DI) ||
                    (i != -1 && i != R_BP && i != R_BX && i != R_SI && i != R_DI))
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
                if (b == -1)            /* pure offset: handled above */
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
                if (rm == -1)           /* can't happen, in theory */
                    return NULL;        /* so panic if it does */

                if (o == 0 && seg == NO_SEG && !forw_ref && rm != 6 &&
                    !(input->eaflags & (EAF_BYTEOFFS | EAF_WORDOFFS)))
                    mod = 0;
                else if (input->eaflags & EAF_BYTEOFFS ||
                         (o >= -128 && o <= 127 && seg == NO_SEG &&
                          !forw_ref && !(input->eaflags & EAF_WORDOFFS)))
                    mod = 1;
                else
                    mod = 2;

                output->sib_present = false;    /* no SIB - it's 16-bit */
                output->bytes = mod;            /* bytes of offset needed */
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
        if (is_class(MEMORY, ins->oprs[j].type)) {
            opflags_t i, b;

            /* Verify as Register */
            if (!is_register(ins->oprs[j].indexreg))
                i = 0;
            else
                i = nasm_reg_flags[ins->oprs[j].indexreg];

            /* Verify as Register */
            if (!is_register(ins->oprs[j].basereg))
                b = 0;
            else
                b = nasm_reg_flags[ins->oprs[j].basereg];

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
            (ins->oprs[j].disp_size ? ins->oprs[j].disp_size : defdisp) != ins->addr_size) {
            /*
             * mem_offs sizes must match the address size; if not,
             * strip the MEM_OFFS bit and match only EA instructions
             */
            ins->oprs[j].type &= ~(MEM_OFFS & ~MEMORY);
        }
    }
}
