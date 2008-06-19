/*
 * tables.h
 *
 * Declarations for auto-generated tables
 */

#ifndef TABLES_H
#define TABLES_H

#include "compiler.h"
#include <inttypes.h>
#include "insnsi.h"		/* For enum opcode */

/* --- From standard.mac via macros.pl: --- */

/* macros.c */
extern const char * const nasm_stdmac[];
extern const char * const * const nasm_stdmac_after_tasm;
const char * const *nasm_stdmac_find_package(const char *);

/* --- From insns.dat via insns.pl: --- */

/* insnsn.c */
extern const char * const nasm_insn_names[];

/* --- From regs.dat via regs.pl: --- */

/* regs.c */
extern const char * const nasm_reg_names[];
/* regflags.c */
extern const int32_t nasm_reg_flags[];
/* regvals.c */
extern const int nasm_regvals[];

#endif /* TABLES_H */
