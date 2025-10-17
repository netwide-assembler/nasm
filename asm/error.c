/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

/*
 * error.c - error message handling routines for the assembler
 */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"

unsigned int debug_nasm;        /* Debugging messages? */
unsigned int opt_verbose_info;  /* Informational messages? */

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


/*
 * Warning stack management. Note that there is an implicit "push"
 * after the command line has been parsed, but this particular push
 * cannot be popped.
 */
struct warning_stack {
	struct warning_stack *next;
	uint8_t state[sizeof warning_state];
};
static struct warning_stack *warning_stack, *warning_state_init;

/* Push the warning status onto the warning stack */
void push_warnings(void)
{
	struct warning_stack *ws;

	ws = nasm_malloc(sizeof *ws);
	memcpy(ws->state, warning_state, sizeof warning_state);
	ws->next = warning_stack;
	warning_stack = ws;
}

/* Pop the warning status off the warning stack */
void pop_warnings(void)
{
	struct warning_stack *ws = warning_stack;

	memcpy(warning_state, ws->state, sizeof warning_state);
	if (!ws->next) {
		nasm_warn(WARN_WARN_STACK_EMPTY, "warning stack empty");
	} else {
		warning_stack = ws->next;
		nasm_free(ws);
	}
}

/* Call after the command line is parsed, but before the first pass */
void init_warnings(void)
{
	push_warnings();
	warning_state_init = warning_stack;
}


/* Call after each pass */
void reset_warnings(void)
{
	struct warning_stack *ws = warning_stack;

	/* Unwind the warning stack. We do NOT delete the last entry! */
	while (ws->next) {
		struct warning_stack *wst = ws;
		ws = ws->next;
		nasm_free(wst);
	}
	warning_stack = ws;
	memcpy(warning_state, ws->state, sizeof warning_state);
}

/*
 * This is called when processing a -w or -W option, or a warning directive.
 * Returns ok if the action was successful.
 *
 * Special pseudo-warnings (see warnings.dat):
 * all   - all possible warnings
 * other - any warning not specifically assigned a class
 */
bool set_warning_status(const char *value)
{
	enum warn_action { WID_OFF, WID_ON, WID_RESET };
	enum warn_action action;
        const struct warning_alias *wa;
        size_t vlen;
	bool ok = false;
	uint8_t mask;

	value = nasm_skip_spaces(value);

	switch (*value) {
	case '-':
		action = WID_OFF;
		value++;
		break;
	case '+':
		action = WID_ON;
		value++;
		break;
	case '*':
		action = WID_RESET;
		value++;
		break;
	case 'N':
	case 'n':
		if (!nasm_strnicmp(value, "no-", 3)) {
			action = WID_OFF;
			value += 3;
			break;
		} else if (!nasm_stricmp(value, "none")) {
			action = WID_OFF;
			value = NULL;
			break;
		}
		/* else fall through */
	default:
		action = WID_ON;
		break;
	}

	mask = WARN_ST_ENABLED;

	if (value && !nasm_strnicmp(value, "error", 5)) {
		switch (value[5]) {
		case '=':
			mask = WARN_ST_ERROR;
			value += 6;
			break;
		case '\0':
			mask = WARN_ST_ERROR;
			value = NULL;
			break;
		default:
			/* Just an accidental prefix? */
			break;
		}
	}

	if (value && !nasm_stricmp(value, "all"))
		value = NULL;

        vlen = value ? strlen(value) : 0;

	/*
         * This is inefficient, but it shouldn't matter.
         * Note: warning_alias[0] is "all".
         */
	for (wa = warning_alias+1;
             wa < &warning_alias[NUM_WARNING_ALIAS]; wa++) {
            enum warn_index i = wa->warning;

            if (value) {
                char sep;

                if (nasm_strnicmp(value, wa->name, vlen))
                    continue;   /* Not a prefix */

                sep = wa->name[vlen];
                if (sep != '\0' && sep != '-')
                    continue;   /* Not a valid prefix */
            }

            ok = true; /* At least one action taken */
            switch (action) {
            case WID_OFF:
                warning_state[i] &= ~mask;
                break;
            case WID_ON:
                warning_state[i] |= mask;
                break;
            case WID_RESET:
                warning_state[i] &= ~mask;
                warning_state[i] |= warning_state_init->state[i] & mask;
                break;
            }
        }

        if (!ok && value) {
            nasm_warn(WARN_UNKNOWN_WARNING, "unknown warning name: %s", value);
	}

	return ok;
}

/*
 * The various error type prefixes
 */
const char *error_pfx(errflags severity)
{
    switch (severity & ERR_MASK) {
    case ERR_LISTMSG:
        return ";;; ";
    case ERR_NOTE:
        return "note: ";
    case ERR_DEBUG:
        return "debug: ";
    case ERR_INFO:
        return "info: ";
    case ERR_WARNING:
        return "warning: ";
    case ERR_NONFATAL:
        return "error: ";
    case ERR_FATAL:
        return "fatal: ";
    case ERR_CRITICAL:
        return "critical: ";
    case ERR_PANIC:
        return "panic: ";
    default:
        return "internal error: ";
    }
}
