/* names.c   included source file defining instruction and register
 *           names for the Netwide [Dis]Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

static const char *conditions[] = {     /* condition code names */
    "a", "ae", "b", "be", "c", "e", "g", "ge", "l", "le", "na", "nae",
    "nb", "nbe", "nc", "ne", "ng", "nge", "nl", "nle", "no", "np",
    "ns", "nz", "o", "p", "pe", "po", "s", "z"
};

/* Register names automatically generated from regs.dat */
#include "regs.c"

/* Instruction names automatically generated from insns.dat */
#include "insnsn.c"
