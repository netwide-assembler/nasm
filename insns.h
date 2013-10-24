/* insns.h   header file for insns.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the license given in the file "LICENSE"
 * distributed in the NASM archive.
 */

#ifndef NASM_INSNS_H
#define NASM_INSNS_H

#include "nasm.h"
#include "tokens.h"

/* if changed, ITEMPLATE_END should be also changed accordingly */
struct itemplate {
    enum opcode     opcode;             /* the token, passed from "parser.c" */
    int             operands;           /* number of operands */
    opflags_t       opd[MAX_OPERANDS];  /* bit flags for operand types */
    decoflags_t     deco[MAX_OPERANDS]; /* bit flags for operand decorators */
    const uint8_t   *code;              /* the code it assembles to */
    iflags_t        flags;              /* some flags */
};

/* Disassembler table structure */

/*
 * If n == -1, then p points to another table of 256
 * struct disasm_index, otherwise p points to a list of n
 * struct itemplates to consider.
 */
struct disasm_index {
    const void *p;
    int n;
};

/* Tables for the assembler and disassembler, respectively */
extern const struct itemplate * const nasm_instructions[];
extern const struct disasm_index itable[256];
extern const struct disasm_index * const itable_vex[NASM_VEX_CLASSES][32][4];

/* Common table for the byte codes */
extern const uint8_t nasm_bytecodes[];

/*
 * this define is used to signify the end of an itemplate
 */
#define ITEMPLATE_END {-1,-1,{-1,-1,-1,-1,-1},{-1,-1,-1,-1,-1},NULL,0}

/*
 * Instruction template flags. These specify which processor
 * targets the instruction is eligible for, whether it is
 * privileged or undocumented, and also specify extra error
 * checking on the matching of the instruction.
 *
 * IF_SM stands for Size Match: any operand whose size is not
 * explicitly specified by the template is `really' intended to be
 * the same size as the first size-specified operand.
 * Non-specification is tolerated in the input instruction, but
 * _wrong_ specification is not.
 *
 * IF_SM2 invokes Size Match on only the first _two_ operands, for
 * three-operand instructions such as SHLD: it implies that the
 * first two operands must match in size, but that the third is
 * required to be _unspecified_.
 *
 * IF_SB invokes Size Byte: operands with unspecified size in the
 * template are really bytes, and so no non-byte specification in
 * the input instruction will be tolerated. IF_SW similarly invokes
 * Size Word, and IF_SD invokes Size Doubleword.
 *
 * (The default state if neither IF_SM nor IF_SM2 is specified is
 * that any operand with unspecified size in the template is
 * required to have unspecified size in the instruction too...)
 *
 * iflags_t is defined to store these flags.
 */

#define IF_SM           UINT64_C(0x00000001)    /* size match */
#define IF_SM2          UINT64_C(0x00000002)    /* size match first two operands */
#define IF_SB           UINT64_C(0x00000004)    /* unsized operands can't be non-byte */
#define IF_SW           UINT64_C(0x00000008)    /* unsized operands can't be non-word */
#define IF_SD           UINT64_C(0x0000000C)    /* unsized operands can't be non-dword */
#define IF_SQ           UINT64_C(0x00000010)    /* unsized operands can't be non-qword */
#define IF_SO           UINT64_C(0x00000014)    /* unsized operands can't be non-oword */
#define IF_SY           UINT64_C(0x00000018)    /* unsized operands can't be non-yword */
#define IF_SZ           UINT64_C(0x0000001C)    /* unsized operands can't be non-zword */
#define IF_SIZE         UINT64_C(0x00000038)    /* unsized operands must match the bitsize */
#define IF_SX           UINT64_C(0x0000003C)    /* unsized operands not allowed */
#define IF_SMASK        UINT64_C(0x0000003C)    /* mask for unsized argument size */
#define IF_AR0          UINT64_C(0x00000040)    /* SB, SW, SD applies to argument 0 */
#define IF_AR1          UINT64_C(0x00000080)    /* SB, SW, SD applies to argument 1 */
#define IF_AR2          UINT64_C(0x000000C0)    /* SB, SW, SD applies to argument 2 */
#define IF_AR3          UINT64_C(0x00000100)    /* SB, SW, SD applies to argument 3 */
#define IF_AR4          UINT64_C(0x00000140)    /* SB, SW, SD applies to argument 4 */
#define IF_ARMASK       UINT64_C(0x000001C0)    /* mask for unsized argument spec */
#define IF_ARSHFT       6                         /* LSB in IF_ARMASK */
#define IF_OPT          UINT64_C(0x00000200)    /* optimizing assembly only */
/* The next 3 bits aren't actually used for anything */
#define IF_PRIV         UINT64_C(0x00000000)    /* it's a privileged instruction */
#define IF_SMM          UINT64_C(0x00000000)    /* it's only valid in SMM */
#define IF_PROT         UINT64_C(0x00000000)    /* it's protected mode only */
#define IF_LOCK         UINT64_C(0x00000400)    /* lockable if operand 0 is memory */
#define IF_NOLONG       UINT64_C(0x00000800)    /* it's not available in long mode */
#define IF_LONG         UINT64_C(0x00001000)    /* long mode instruction */
#define IF_NOHLE        UINT64_C(0x00002000)    /* HLE prefixes forbidden */
#define IF_MIB          UINT64_C(0x00004000)    /* Disassemble with split EA */
#define IF_BND          UINT64_C(0x00008000)    /* BND (0xF2) prefix available */
/* These flags are currently not used for anything - intended for insn set */
#define IF_UNDOC        UINT64_C(0x8000000000)    /* it's an undocumented instruction */
#define IF_HLE          UINT64_C(0x4000000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_AVX512       UINT64_C(0x2000000000)    /* it's an AVX-512F (512b) instruction */
#define IF_FPU          UINT64_C(0x0100000000)    /* it's an FPU instruction */
#define IF_MMX          UINT64_C(0x0200000000)    /* it's an MMX instruction */
#define IF_3DNOW        UINT64_C(0x0300000000)    /* it's a 3DNow! instruction */
#define IF_SSE          UINT64_C(0x0400000000)    /* it's a SSE (KNI, MMX2) instruction */
#define IF_SSE2         UINT64_C(0x0500000000)    /* it's a SSE2 instruction */
#define IF_SSE3         UINT64_C(0x0600000000)    /* it's a SSE3 (PNI) instruction */
#define IF_VMX          UINT64_C(0x0700000000)    /* it's a VMX instruction */
#define IF_SSSE3        UINT64_C(0x0800000000)    /* it's an SSSE3 instruction */
#define IF_SSE4A        UINT64_C(0x0900000000)    /* AMD SSE4a */
#define IF_SSE41        UINT64_C(0x0A00000000)    /* it's an SSE4.1 instruction */
#define IF_SSE42        UINT64_C(0x0B00000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_SSE5         UINT64_C(0x0C00000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_AVX          UINT64_C(0x0D00000000)    /* it's an AVX     (128b) instruction */
#define IF_AVX2         UINT64_C(0x0E00000000)    /* it's an AVX2    (256b) instruction */
#define IF_FMA          UINT64_C(0x1000000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_BMI1         UINT64_C(0x1100000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_BMI2         UINT64_C(0x1200000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_TBM          UINT64_C(0x1300000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_RTM          UINT64_C(0x1400000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_INVPCID      UINT64_C(0x1500000000)    /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_AVX512CD     (UINT64_C(0x1600000000)|IF_AVX512) /* AVX-512 Conflict Detection insns */
#define IF_AVX512ER     (UINT64_C(0x1700000000)|IF_AVX512) /* AVX-512 Exponential and Reciprocal */
#define IF_AVX512PF     (UINT64_C(0x1800000000)|IF_AVX512) /* AVX-512 Prefetch instructions */
#define IF_MPX          UINT64_C(0x1900000000)    /* MPX instructions */
#define IF_SHA          UINT64_C(0x1A00000000)    /* SHA instructions */
#define IF_PREFETCHWT1  UINT64_C(0x1F00000000)    /* PREFETCHWT1 instructions */
#define IF_INSMASK      UINT64_C(0xFF00000000)    /* the mask for instruction set types */
#define IF_PMASK        UINT64_C(0xFF000000)    /* the mask for processor types */
#define IF_PLEVEL       UINT64_C(0x0F000000)    /* the mask for processor instr. level */
                                                  /* also the highest possible processor */
#define IF_8086         UINT64_C(0x00000000)    /* 8086 instruction */
#define IF_186          UINT64_C(0x01000000)    /* 186+ instruction */
#define IF_286          UINT64_C(0x02000000)    /* 286+ instruction */
#define IF_386          UINT64_C(0x03000000)    /* 386+ instruction */
#define IF_486          UINT64_C(0x04000000)    /* 486+ instruction */
#define IF_PENT         UINT64_C(0x05000000)    /* Pentium instruction */
#define IF_P6           UINT64_C(0x06000000)    /* P6 instruction */
#define IF_KATMAI       UINT64_C(0x07000000)    /* Katmai instructions */
#define IF_WILLAMETTE   UINT64_C(0x08000000)    /* Willamette instructions */
#define IF_PRESCOTT     UINT64_C(0x09000000)    /* Prescott instructions */
#define IF_X86_64       UINT64_C(0x0A000000)    /* x86-64 instruction (long or legacy mode) */
#define IF_NEHALEM      UINT64_C(0x0B000000)    /* Nehalem instruction */
#define IF_WESTMERE     UINT64_C(0x0C000000)    /* Westmere instruction */
#define IF_SANDYBRIDGE  UINT64_C(0x0D000000)    /* Sandy Bridge instruction */
#define IF_FUTURE       UINT64_C(0x0E000000)    /* Future processor (not yet disclosed) */
#define IF_X64          (IF_LONG|IF_X86_64)
#define IF_IA64         UINT64_C(0x0F000000)    /* IA64 instructions (in x86 mode) */
#define IF_CYRIX        UINT64_C(0x10000000)    /* Cyrix-specific instruction */
#define IF_AMD          UINT64_C(0x20000000)    /* AMD-specific instruction */
#define IF_SPMASK       UINT64_C(0x30000000)    /* specific processor types mask */
#define IF_PFMASK       (IF_INSMASK|IF_SPMASK) /* disassembly "prefer" mask */

#endif /* NASM_INSNS_H */
