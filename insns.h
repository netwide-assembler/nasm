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

struct itemplate {
    enum opcode opcode;		/* the token, passed from "parser.c" */
    int operands;		/* number of operands */
    opflags_t opd[MAX_OPERANDS]; /* bit flags for operand types */
    const uint8_t *code;	/* the code it assembles to */
    uint32_t flags;		/* some flags */
};

/* Disassembler table structure */
/* If n == -1, then p points to another table of 256
   struct disasm_index, otherwise p points to a list of n
   struct itemplates to consider. */
struct disasm_index {
    const void *p;
    int n;
};

/* Tables for the assembler and disassembler, respectively */
extern const struct itemplate * const nasm_instructions[];
extern const struct disasm_index itable[256];
extern const struct disasm_index * const itable_vex[2][32][8];

/* Common table for the byte codes */
extern const uint8_t nasm_bytecodes[];

/*
 * this define is used to signify the end of an itemplate
 */
#define ITEMPLATE_END {-1,-1,{-1,-1,-1},NULL,0}

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
 */

#define IF_SM     0x00000001UL  /* size match */
#define IF_SM2    0x00000002UL  /* size match first two operands */
#define IF_SB     0x00000004UL  /* unsized operands can't be non-byte */
#define IF_SW     0x00000008UL  /* unsized operands can't be non-word */
#define IF_SD     0x0000000CUL  /* unsized operands can't be non-dword */
#define IF_SQ     0x00000010UL  /* unsized operands can't be non-qword */
#define IF_SO     0x00000014UL  /* unsized operands can't be non-oword */
#define IF_SY     0x00000018UL  /* unsized operands can't be non-yword */
#define IF_SZ     0x00000038UL  /* unsized operands must match the bitsize */
#define IF_SX	  0x0000003CUL	/* unsized operands not allowed */
#define IF_SMASK  0x0000003CUL  /* mask for unsized argument size */
#define IF_AR0	  0x00000040UL  /* SB, SW, SD applies to argument 0 */
#define IF_AR1	  0x00000080UL  /* SB, SW, SD applies to argument 1 */
#define IF_AR2	  0x000000C0UL  /* SB, SW, SD applies to argument 2 */
#define IF_AR3	  0x00000100UL  /* SB, SW, SD applies to argument 3 */
#define IF_AR4	  0x00000140UL  /* SB, SW, SD applies to argument 4 */
#define IF_ARMASK 0x000001C0UL  /* mask for unsized argument spec */
#define IF_ARSHFT 6		/* LSB in IF_ARMASK */
/* The next 3 bits aren't actually used for anything */
#define IF_PRIV   0x00000000UL  /* it's a privileged instruction */
#define IF_SMM    0x00000000UL  /* it's only valid in SMM */
#define IF_PROT   0x00000000UL  /* it's protected mode only */
#define IF_NOLONG 0x00000800UL  /* it's not available in long mode */
#define IF_UNDOC  0x00001000UL  /* it's an undocumented instruction */
#define IF_FPU    0x00002000UL  /* it's an FPU instruction */
#define IF_MMX    0x00004000UL  /* it's an MMX instruction */
#define IF_3DNOW  0x00008000UL  /* it's a 3DNow! instruction */
#define IF_SSE    0x00010000UL  /* it's a SSE (KNI, MMX2) instruction */
#define IF_SSE2   0x00020000UL  /* it's a SSE2 instruction */
#define IF_SSE3   0x00040000UL  /* it's a SSE3 (PNI) instruction */
#define IF_VMX	  0x00080000UL  /* it's a VMX instruction */
#define IF_LONG   0x00100000UL	/* long mode instruction */
#define IF_SSSE3  0x00200000UL  /* it's an SSSE3 instruction */
#define IF_SSE4A  0x00400000UL  /* AMD SSE4a */
#define IF_SSE41  0x00800000UL  /* it's an SSE4.1 instruction */
#define IF_SSE42  0x00800000UL  /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_SSE5   0x00800000UL  /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_AVX    0x00800000UL  /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_FMA    0x00800000UL  /* HACK NEED TO REORGANIZE THESE BITS */
#define IF_PMASK  0xFF000000UL  /* the mask for processor types */
#define IF_PLEVEL 0x0F000000UL  /* the mask for processor instr. level */
                                /* also the highest possible processor */
#define IF_PFMASK 0xF01FFF00UL  /* the mask for disassembly "prefer" */
#define IF_8086   0x00000000UL  /* 8086 instruction */
#define IF_186    0x01000000UL  /* 186+ instruction */
#define IF_286    0x02000000UL  /* 286+ instruction */
#define IF_386    0x03000000UL  /* 386+ instruction */
#define IF_486    0x04000000UL  /* 486+ instruction */
#define IF_PENT   0x05000000UL  /* Pentium instruction */
#define IF_P6     0x06000000UL  /* P6 instruction */
#define IF_KATMAI 0x07000000UL  /* Katmai instructions */
#define IF_WILLAMETTE 0x08000000UL      /* Willamette instructions */
#define IF_PRESCOTT   0x09000000UL      /* Prescott instructions */
#define IF_X86_64 0x0A000000UL	/* x86-64 instruction (long or legacy mode) */
#define IF_NEHALEM 0x0B000000UL  /* Nehalem instruction */
#define IF_WESTMERE 0x0C000000UL   /* Westmere instruction */
#define IF_SANDYBRIDGE 0x0D000000UL /* Sandy Bridge instruction */
#define IF_FUTURE 0x0E000000UL	/* Future processor (not yet disclosed) */
#define IF_X64	  (IF_LONG|IF_X86_64)
#define IF_IA64   0x0F000000UL  /* IA64 instructions (in x86 mode) */
#define IF_CYRIX  0x10000000UL  /* Cyrix-specific instruction */
#define IF_AMD    0x20000000UL  /* AMD-specific instruction */

#endif
