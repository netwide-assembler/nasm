/* insns.h   header file for insns.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_INSNS_H
#define NASM_INSNS_H

struct itemplate {
    int opcode;			       /* the token, passed from "parser.c" */
    int operands;		       /* number of operands */
    long opd[3];		       /* bit flags for operand types */
    char *code;			       /* the code it assembles to */
    int flags;			       /* some flags */
};

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
 * the input instruction will be tolerated.
 *
 * IF_SD similarly invokes Size Doubleword.
 *
 * (The default state if neither IF_SM nor IF_SM2 is specified is
 * that any operand with unspecified size in the template is
 * required to have unspecified size in the instruction too...)
 */

#define IF_SM     0x0001	       /* size match */
#define IF_SM2    0x0002	       /* size match first two operands */
#define IF_SB     0x0004	       /* unsized operands can't be non-byte */
#define IF_SD     0x0008	       /* unsized operands can't be nondword */
#define IF_8086   0x0000	       /* 8086 instruction */
#define IF_186    0x0010	       /* 186+ instruction */
#define IF_286    0x0020	       /* 286+ instruction */
#define IF_386    0x0030	       /* 386+ instruction */
#define IF_486    0x0040	       /* 486+ instruction */
#define IF_PENT   0x0050	       /* Pentium instruction */
#define IF_P6     0x0060	       /* P6 instruction */
#define IF_PMASK  0x00F0	       /* the mask for processor types */
#define IF_PRIV   0x0100	       /* it's a privileged instruction */
#define IF_UNDOC  0x0200	       /* it's an undocumented instruction */
#define IF_FPU    0x0400	       /* it's an FPU instruction */
#define IF_MMX    0x0800	       /* it's an MMX instruction */
#define IF_ND     0x1000	       /* ignore this in the disassembler */

#endif
