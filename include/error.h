/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2018 The NASM Authors - All Rights Reserved
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
 * Error reporting functions for the assembler
 */

#ifndef NASM_ERROR_H
#define NASM_ERROR_H 1

#include "compiler.h"

/*
 * File pointer for error messages
 */
extern FILE *error_file;        /* Error file descriptor */

/*
 * An error reporting function should look like this.
 */
void printf_func(2, 3) nasm_error(int severity, const char *fmt, ...);
fatal_func printf_func(2, 3) nasm_fatal(int flags, const char *fmt, ...);
fatal_func printf_func(2, 3) nasm_panic(int flags, const char *fmt, ...);
fatal_func nasm_panic_from_macro(const char *file, int line);
#define panic() nasm_panic_from_macro(__FILE__, __LINE__);

typedef void (*vefunc) (int severity, const char *fmt, va_list ap);
extern vefunc nasm_verror;
static inline vefunc nasm_set_verror(vefunc ve)
{
    vefunc old_verror = nasm_verror;
    nasm_verror = ve;
    return old_verror;
}

/*
 * These are the error severity codes which get passed as the first
 * argument to an efunc.
 */

#define ERR_DEBUG       0x00000000      /* put out debugging message */
#define ERR_NOTE	0x00000001      /* additional error information */
#define ERR_WARNING     0x00000002      /* warn only: no further action */
#define ERR_NONFATAL    0x00000003      /* terminate assembly after phase */
#define ERR_FATAL       0x00000006      /* instantly fatal: exit with error */
#define ERR_PANIC       0x00000007      /* internal error: panic instantly
                                         * and dump core for reference */
#define ERR_MASK        0x00000007      /* mask off the above codes */
#define ERR_NOFILE      0x00000010      /* don't give source file name/line */
#define ERR_HERE	0x00000020      /* point to a specific source location */
#define ERR_USAGE       0x00000040      /* print a usage message */
#define ERR_PASS1       0x00000080      /* only print this error on pass 1 */
#define ERR_PASS2       0x00000100      /* only print this error on pass 2 */

#define ERR_NO_SEVERITY 0x00000200      /* suppress printing severity */
#define ERR_PP_PRECOND	0x00000400	/* for preprocessor use */
#define ERR_PP_LISTMACRO 0x00000800	/* from preproc->error_list_macros() */

/*
 * These codes define specific types of suppressible warning.
 * They are assumed to occupy the most significant bits of the
 * severity code.
 */

#define WARN_SHR		12              /* how far to shift right */
#define WARN(x)         	((x) << WARN_SHR)
#define WARN_MASK		WARN(~0)
#define WARN_IDX(x)     	((x) >> WARN_SHR)

#define WARN_MNP            	WARN( 1) /* macro-num-parameters warning */
#define WARN_MSR            	WARN( 2) /* macro self-reference */
#define WARN_MDP            	WARN( 3) /* macro default parameters check */
#define WARN_OL             	WARN( 4) /* orphan label (no colon, and alone on line) */
#define WARN_NOV            	WARN( 5) /* numeric overflow */
#define WARN_GNUELF         	WARN( 6) /* using GNU ELF extensions */
#define WARN_FL_OVERFLOW    	WARN( 7) /* FP overflow */
#define WARN_FL_DENORM      	WARN( 8) /* FP denormal */
#define WARN_FL_UNDERFLOW   	WARN( 9) /* FP underflow */
#define WARN_FL_TOOLONG     	WARN(10) /* FP too many digits */
#define WARN_USER           	WARN(11) /* %warning directives */
#define WARN_LOCK		WARN(12) /* bad LOCK prefixes */
#define WARN_HLE		WARN(13) /* bad HLE prefixes */
#define WARN_BND		WARN(14) /* bad BND prefixes */
#define WARN_ZEXTRELOC		WARN(15) /* relocation zero-extended */
#define WARN_PTR		WARN(16) /* not a NASM keyword */
#define WARN_BAD_PRAGMA		WARN(17) /* malformed pragma */
#define WARN_UNKNOWN_PRAGMA	WARN(18) /* unknown pragma */
#define WARN_NOTMY_PRAGMA	WARN(19) /* pragma inapplicable */
#define WARN_UNK_WARNING	WARN(20) /* unknown warning */
#define WARN_NEG_REP		WARN(21) /* negative repeat count */
#define WARN_PHASE		WARN(22) /* phase error in pass 1 */
#define WARN_LABEL_REDEF	WARN(23) /* label redefined, but consistent */
#define WARN_LABEL_LATE		WARN(24) /* label (re)defined during code generation */

/* These two should come last */
#define WARN_ALL		(24+2) /* Do not use WARN() here */
#define WARN_OTHER		WARN(WARN_ALL-1) /* any noncategorized warning */

/* This is a bitmask */
#define WARN_ST_ENABLED      1   /* Warning is currently enabled */
#define WARN_ST_ERROR        2   /* Treat this warning as an error */

struct warning {
    const char *name;
    const char *help;
    uint8_t state;              /* Default state for this warning */
};
extern const struct warning warnings[WARN_ALL+1];
extern uint8_t warning_state[WARN_ALL];
extern uint8_t warning_state_init[WARN_ALL];

/* Process a warning option or directive */
bool set_warning_status(const char *);

#endif /* NASM_ERROR_H */
