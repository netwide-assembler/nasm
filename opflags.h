/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2012 The NASM Authors - All Rights Reserved
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
 * opflags.h - operand flags
 */

#ifndef NASM_OPFLAGS_H
#define NASM_OPFLAGS_H

#include "compiler.h"

/*
 * Here we define the operand types. These are implemented as bit
 * masks, since some are subsets of others; e.g. AX in a MOV
 * instruction is a special operand type, whereas AX in other
 * contexts is just another 16-bit register. (Also, consider CL in
 * shift instructions, DX in OUT, etc.)
 *
 * The basic concept here is that
 *    (class & ~operand) == 0
 *
 * if and only if "operand" belongs to class type "class".
 *
 * The bits are assigned as follows:
 *
 * Bits 0-7, 23, 29: sizes
 *  0:  8 bits (BYTE)
 *  1: 16 bits (WORD)
 *  2: 32 bits (DWORD)
 *  3: 64 bits (QWORD)
 *  4: 80 bits (TWORD)
 *  5: FAR
 *  6: NEAR
 *  7: SHORT
 * 23: 256 bits (YWORD)
 * 29: 128 bits (OWORD)
 *
 * Bits 8-10 modifiers
 *  8: TO
 *  9: COLON
 * 10: STRICT
 *
 * Bits 12-15: type of operand
 * 12: REGISTER
 * 13: IMMEDIATE
 * 14: MEMORY (always has REGMEM attribute as well)
 * 15: REGMEM (valid EA operand)
 *
 * Bits 11, 16-19, 28: subclasses
 * With REG_CDT:
 * 16: REG_CREG (CRx)
 * 17: REG_DREG (DRx)
 * 18: REG_TREG (TRx)

 * With REG_GPR:
 * 16: REG_ACCUM  (AL, AX, EAX, RAX)
 * 17: REG_COUNT  (CL, CX, ECX, RCX)
 * 18: REG_DATA   (DL, DX, EDX, RDX)
 * 19: REG_HIGH   (AH, CH, DH, BH)
 * 28: REG_NOTACC (not REG_ACCUM)
 *
 * With REG_SREG:
 * 16: REG_CS
 * 17: REG_DESS (DS, ES, SS)
 * 18: REG_FSGS
 * 19: REG_SEG67
 *
 * With FPUREG:
 * 16: FPU0
 *
 * With XMMREG:
 * 16: XMM0
 *
 * With YMMREG:
 * 16: YMM0
 *
 * With MEMORY:
 * 16: MEM_OFFS (this is a simple offset)
 * 17: IP_REL (IP-relative offset)
 *
 * With IMMEDIATE:
 * 16: UNITY (1)
 * 17: BYTENESS16 (-128..127)
 * 18: BYTENESS32 (-128..127)
 * 19: BYTENESS64 (-128..127)
 * 28: SDWORD64 (-2^31..2^31-1)
 * 11: UDWORD64 (0..2^32-1)
 *
 * Bits 20-22, 24-27: register classes
 * 20: REG_CDT (CRx, DRx, TRx)
 * 21: RM_GPR (REG_GPR) (integer register)
 * 22: REG_SREG
 * 24: FPUREG
 * 25: RM_MMX (MMXREG)
 * 26: RM_XMM (XMMREG)
 * 27: RM_YMM (YMMREG)
 *
 * 30: SAME_AS
 * Special flag only used in instruction patterns; means this operand
 * has to be identical to another operand.  Currently only supported
 * for registers.
 */

typedef uint64_t opflags_t;

/* Size, and other attributes, of the operand */
#define BITS8           UINT64_C(0x00000001)
#define BITS16          UINT64_C(0x00000002)
#define BITS32          UINT64_C(0x00000004)
#define BITS64          UINT64_C(0x00000008)    /* x64 and FPU only */
#define BITS80          UINT64_C(0x00000010)    /* FPU only */
#define BITS128         UINT64_C(0x20000000)
#define BITS256         UINT64_C(0x00800000)
#define FAR             UINT64_C(0x00000020)    /* grotty: this means 16:16 or */
                                                /* 16:32, like in CALL/JMP */
#define NEAR            UINT64_C(0x00000040)
#define SHORT           UINT64_C(0x00000080)    /* and this means what it says :) */

#define SIZE_MASK       UINT64_C(0x208000FF)    /* all the size attributes */

/* Modifiers */
#define MODIFIER_MASK   UINT64_C(0x00000700)
#define TO              UINT64_C(0x00000100)    /* reverse effect in FADD, FSUB &c */
#define COLON           UINT64_C(0x00000200)    /* operand is followed by a colon */
#define STRICT          UINT64_C(0x00000400)    /* do not optimize this operand */

/* Type of operand: memory reference, register, etc. */
#define OPTYPE_MASK     UINT64_C(0x0000f000)
#define REGISTER        UINT64_C(0x00001000)    /* register number in 'basereg' */
#define IMMEDIATE       UINT64_C(0x00002000)
#define MEMORY          UINT64_C(0x0000c000)
#define REGMEM          UINT64_C(0x00008000)    /* for r/m, ie EA, operands */

#define is_class(class, op)     (!((opflags_t)(class) & ~(opflags_t)(op)))

#define IS_SREG(op)             is_class(REG_SREG, nasm_reg_flags[(op)])
#define IS_FSGS(op)             is_class(REG_FSGS, nasm_reg_flags[(op)])

/* Register classes */
#define REG_EA          UINT64_C(0x00009000)    /* 'normal' reg, qualifies as EA */
#define RM_GPR          UINT64_C(0x00208000)    /* integer operand */
#define REG_GPR         UINT64_C(0x00209000)    /* integer register */
#define REG8            UINT64_C(0x00209001)    /*  8-bit GPR  */
#define REG16           UINT64_C(0x00209002)    /* 16-bit GPR */
#define REG32           UINT64_C(0x00209004)    /* 32-bit GPR */
#define REG64           UINT64_C(0x00209008)    /* 64-bit GPR */
#define FPUREG          UINT64_C(0x01001000)    /* floating point stack registers */
#define FPU0            UINT64_C(0x01011000)    /* FPU stack register zero */
#define RM_MMX          UINT64_C(0x02008000)    /* MMX operand */
#define MMXREG          UINT64_C(0x02009000)    /* MMX register */
#define RM_XMM          UINT64_C(0x04008000)    /* XMM (SSE) operand */
#define XMMREG          UINT64_C(0x04009000)    /* XMM (SSE) register */
#define XMM0            UINT64_C(0x04019000)    /* XMM register zero */
#define RM_YMM          UINT64_C(0x08008000)    /* YMM (AVX) operand */
#define YMMREG          UINT64_C(0x08009000)    /* YMM (AVX) register */
#define YMM0            UINT64_C(0x08019000)    /* YMM register zero */
#define REG_CDT         UINT64_C(0x00101004)    /* CRn, DRn and TRn */
#define REG_CREG        UINT64_C(0x00111004)    /* CRn */
#define REG_DREG        UINT64_C(0x00121004)    /* DRn */
#define REG_TREG        UINT64_C(0x00141004)    /* TRn */
#define REG_SREG        UINT64_C(0x00401002)    /* any segment register */
#define REG_CS          UINT64_C(0x00411002)    /* CS */
#define REG_DESS        UINT64_C(0x00421002)    /* DS, ES, SS */
#define REG_FSGS        UINT64_C(0x00441002)    /* FS, GS */
#define REG_SEG67       UINT64_C(0x00481002)    /* Unimplemented segment registers */

/* Special GPRs */
#define REG_SMASK       UINT64_C(0x100f0800)    /* a mask for the following */
#define REG_ACCUM       UINT64_C(0x00219000)    /* accumulator: AL, AX, EAX, RAX */
#define REG_AL          UINT64_C(0x00219001)
#define REG_AX          UINT64_C(0x00219002)
#define REG_EAX         UINT64_C(0x00219004)
#define REG_RAX         UINT64_C(0x00219008)
#define REG_COUNT       UINT64_C(0x10229000)    /* counter: CL, CX, ECX, RCX */
#define REG_CL          UINT64_C(0x10229001)
#define REG_CX          UINT64_C(0x10229002)
#define REG_ECX         UINT64_C(0x10229004)
#define REG_RCX         UINT64_C(0x10229008)
#define REG_DL          UINT64_C(0x10249001)    /* data: DL, DX, EDX, RDX */
#define REG_DX          UINT64_C(0x10249002)
#define REG_EDX         UINT64_C(0x10249004)
#define REG_RDX         UINT64_C(0x10249008)
#define REG_HIGH        UINT64_C(0x10289001)    /* high regs: AH, CH, DH, BH */
#define REG_NOTACC      UINT64_C(0x10000000)    /* non-accumulator register */
#define REG8NA          UINT64_C(0x10209001)    /*  8-bit non-acc GPR  */
#define REG16NA         UINT64_C(0x10209002)    /* 16-bit non-acc GPR */
#define REG32NA         UINT64_C(0x10209004)    /* 32-bit non-acc GPR */
#define REG64NA         UINT64_C(0x10209008)    /* 64-bit non-acc GPR */

/* special types of EAs */
#define MEM_OFFS        UINT64_C(0x0001c000)    /* simple [address] offset - absolute! */
#define IP_REL          UINT64_C(0x0002c000)    /* IP-relative offset */

/* memory which matches any type of r/m operand */
#define MEMORY_ANY      (MEMORY|RM_GPR|RM_MMX|RM_XMM|RM_YMM)

/* special type of immediate operand */
#define UNITY           UINT64_C(0x00012000)    /* for shift/rotate instructions */
#define SBYTE16         UINT64_C(0x00022000)    /* for op r16,immediate instrs. */
#define SBYTE32         UINT64_C(0x00042000)    /* for op r32,immediate instrs. */
#define SBYTE64         UINT64_C(0x00082000)    /* for op r64,immediate instrs. */
#define BYTENESS        UINT64_C(0x000e0000)    /* for testing for byteness */
#define SDWORD64	UINT64_C(0x10002000)    /* for op r64,simm32 instrs. */
#define UDWORD64	UINT64_C(0x00002800)    /* for op r64,uimm32 instrs. */

/* special flags */
#define SAME_AS         UINT64_C(0x40000000)

#endif /* NASM_OPFLAGS_H */
