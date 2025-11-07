/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"

struct errinfo erropt;

/* Common function body */
#define nasm_do_error(_sev,_flags)                              \
    do {                                                        \
        const errflags nde_severity = (_sev);                   \
        const errflags nde_flags = nde_severity | (_flags);     \
        va_list ap;                                             \
        va_start(ap, fmt);                                      \
        if (nde_severity >= ERR_CRITICAL) {                     \
            nasm_verror_critical(nde_flags, fmt, ap);           \
            unreachable();                                      \
        } else {						\
            nasm_verror(nde_flags, fmt, ap);                    \
            if (nde_severity >= ERR_FATAL)                      \
                unreachable();                                  \
        }                                                       \
        va_end(ap);                                             \
    } while (0)

/*
 * This is the generic function to use when the error type is not
 * known a priori. For ERR_DEBUG and ERR_INFO the level can be
 * included by
 */
void nasm_error(errflags flags, const char *fmt, ...)
{
    nasm_do_error(flags & ERR_MASK, flags);
}

#define nasm_err_helpers(_type, _name, _sev)				\
_type nasm_ ## _name ## f (errflags flags, const char *fmt, ...)	\
{									\
	nasm_do_error(_sev, flags);					\
}									\
_type nasm_ ## _name (const char *fmt, ...)				\
{									\
	nasm_do_error(_sev, 0);						\
}

nasm_err_helpers(void,       listmsg,  ERR_LISTMSG)
nasm_err_helpers(void,       note,     ERR_NOTE)
nasm_err_helpers(void,       nonfatal, ERR_NONFATAL)
nasm_err_helpers(fatal_func, fatal,    ERR_FATAL)
nasm_err_helpers(fatal_func, critical, ERR_CRITICAL)
nasm_err_helpers(fatal_func, panic,    ERR_PANIC)

/*
 * Strongly discourage warnings without level by require flags on warnings.
 * This means nasm_warn() is the equivalent of the -f variants of the
 * other ones.
 *
 * This is wrapped in a macro to be able to elide it if the warning is
 * disabled, hence the extra underscore.
 */
void nasm_warn_(errflags flags, const char *fmt, ...)
{
    nasm_do_error(ERR_WARNING, flags);
}

/*
 * nasm_info() and nasm_debug() takes mandatory enabling levels.
 */
void nasm_info_(unsigned int level, const char *fmt, ...)
{
    if (info_level(level))
        nasm_do_error(ERR_INFO, LEVEL(level));
}

void nasm_debug_(unsigned int level, const char *fmt, ...)
{
    if (debug_level(level))
        nasm_do_error(ERR_DEBUG, LEVEL(level));
}

/*
 * Convenience function for nasm_nonfatal(ERR_HOLD, ...)
 */
void nasm_holderr(const char *fmt, ...)
{
    nasm_do_error(ERR_NONFATAL, ERR_NONFATAL|ERR_HOLD);
}

/*
 * panic() and nasm_assert()
 */
fatal_func nasm_panic_from_macro(const char *func, const char *file, int line)
{
    if (!func)
        func = "<unknown>";

    nasm_panic("internal error in %s at %s:%d\n", func, file, line);
}

fatal_func nasm_assert_failed(const char *msg, const char *func,
                              const char *file, int line)
{
    if (!func)
        func = "<unknown>";

    nasm_panic("assertion %s failed in %s at %s:%d", msg, func, file, line);
}
