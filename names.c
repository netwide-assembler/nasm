/* names.c   included source file defining instruction and register
 *           names for the Netwide [Dis]Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

static char *reg_names[] = {	       /* register names, as strings */
    "ah", "al", "ax", "bh", "bl", "bp", "bx", "ch", "cl",
    "cr0", "cr2", "cr3", "cr4", "cs", "cx", "dh", "di", "dl", "dr0",
    "dr1", "dr2", "dr3", "dr6", "dr7", "ds", "dx", "eax", "ebp",
    "ebx", "ecx", "edi", "edx", "es", "esi", "esp", "fs", "gs",
    "mm0", "mm1", "mm2", "mm3", "mm4", "mm5", "mm6", "mm7", "si",
    "sp", "ss", "st0", "st1", "st2", "st3", "st4", "st5", "st6",
    "st7", "tr3", "tr4", "tr5", "tr6", "tr7",
    "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7"
};

static char *conditions[] = {	       /* condition code names */
    "a", "ae", "b", "be", "c", "e", "g", "ge", "l", "le", "na", "nae",
    "nb", "nbe", "nc", "ne", "ng", "nge", "nl", "nle", "no", "np",
    "ns", "nz", "o", "p", "pe", "po", "s", "z"
};

/* Instruction names automatically generated from insns.dat */
#include "insnsn.c"
