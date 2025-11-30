/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

/*
 * error.c - error message handling routines for the assembler
 */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"
#include "listing.h"
#include "srcfile.h"
#include "strlist.h"

struct error_format {
    const char *beforeline;     /* Before line number, if present */
    const char *afterline;      /* After line number, if present */
    const char *beforemsg;      /* Before actual message */
};

enum error_formats {
    ERRFMT_GNU,
    ERRFMT_MSVC
};
static const struct error_format errfmts[] = {
    { ":", "",  ": "  },        /* ERRFMT_GNU */
    { "(", ")", " : " }         /* ERRFMT_MSVC */
};
static const struct error_format *errfmt = &errfmts[ERRFMT_GNU];

static void usage(void);

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
static struct strlist *warn_list;

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

/* Called after the command line is parsed, but before the first pass */
static void init_warnings(void)
{
	push_warnings();
	warning_state_init = warning_stack;
}

void error_init(void)
{
    erropt.worst = 0;
    init_warnings();
}

/* Called before each pass. Buffer warnings if "final" is false. */
void error_pass_start(bool final)
{
    nasm_assert(!warn_list);

    erropt.worst = 0;
    if (!final)
        warn_list = strlist_alloc(false);
}

/*
 * Called after the completion of each pass. This MUST preserve erropt.worst!
 */
static void reset_warnings(void)
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

void error_pass_end(void)
{
    strlist_free(&warn_list);
    reset_warnings();
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

static bool skip_this_pass(errflags severity)
{
    errflags type = severity & ERR_MASK;

    /*
     * See if it's a pass-specific error or warning which should be skipped.
     * We can never skip fatal errors as by definition they cannot be
     * resumed from.
     */
    if (type >= ERR_FATAL)
        return false;

    /*
     * ERR_LISTMSG and ERR_NOTE messages are always skipped; the list
     * file receives them anyway as this function is not consulted for
     * sending to the list file.
     */
    if (type <= ERR_NOTE)
        return true;

    /*
     * This message is not applicable unless it is the last pass we
     * are going to execute; this can be either the final
     * code-generation pass or the single pass executed in
     * preproc-only mode.
     */
    return (severity & ERR_PASS2) && !pass_final_or_preproc();
}

/**
 * check for suppressed message (usually warnings or notes)
 *
 * @param severity the severity of the warning or error
 * @return true if we should abort error/warning printing
 */
static bool is_suppressed(errflags flags)
{
    const errflags severity = flags & ERR_MASK;
    const errflags level = WARN_IDX(flags);

    if (severity >= ERR_FATAL) {
        /* Fatal errors or higher can never be suppressed */
        return false;
    }

    if (flags & erropt.never)
        return true;

    switch (severity) {
    case ERR_WARNING:
        if (!(warning_state[level] & WARN_ST_ENABLED))
            return true;
        break;

    case ERR_INFO:
        if (!info_level(level))
            return true;
        break;

    case ERR_DEBUG:
        if (!debug_level(level))
            return true;
        break;

    default:
        break;
    }

    /* Suppressed by the preprocessor? */
    if (!(flags & ERR_PP_LISTMACRO))
        return pp_suppress_error(flags);

    return false;
}

/**
 * Return the true error type (the ERR_MASK part) of the given
 * severity, accounting for warnings that may need to be promoted to
 * error.
 *
 * @param severity the severity of the warning or error
 * @return true if we should error out
 */
static errflags pure_func true_error_type(errflags severity)
{
    const uint8_t warn_is_err = WARN_ST_ENABLED|WARN_ST_ERROR;
    int type;

    type = severity & ERR_MASK;

    if (type == ERR_WARNING) {
        /* Promote warning to error? */
        uint8_t state = warning_state[WARN_IDX(severity)];
        if ((state & warn_is_err) == warn_is_err)
            type = ERR_NONFATAL;
    }
    return type;
}

static const char no_file_name[] = "nasm"; /* What to print if no file name */

/*
 * For fatal/critical/panic errors, kill this process.
 *
 * For FATAL errors doing cleanups, tidying up the list process,
 * and so in is acceptable.
 *
 * For CRITICAL errors, minimize dependencies on memory allocation
 * and/or having a system valid state.
 *
 * For PANIC, if abort_on_panic is set, abort without any other action.
 */
static_fatal_func die_hard(errflags true_type, errflags severity)
{
    if (true_type < ERR_PANIC || !erropt.abort_on_panic) {
        if (true_type < ERR_CRITICAL) {
            /* FATAL shutdown, general cleanup actions are valid */
            print_final_report(true);
            lfmt->cleanup();
        }

        fflush(NULL);

        close_output(true);

        if (severity & ERR_USAGE)
            usage();

        /* Terminate immediately (exit closes any still open files) */
        exit(true_type - ERR_FATAL + 1);
    }

    /*
     * abort() shouldn't ever return, but be paranoid about this,
     * plus it helps some compilers clue in to the fact that this
     * function can never, ever return.
     */
    while (1)
        abort();
}

/*
 * Returns the struct src_location appropriate for use, after some
 * potential filename mangling.
 */
static struct src_location error_where(errflags severity)
{
    struct src_location where;

    if (severity & ERR_NOFILE) {
        where.filename = NULL;
        where.lineno = 0;
    } else {
        where = src_where_error();

        if (!where.filename) {
            where.filename =
            inname && inname[0] ? inname :
                outname && outname[0] ? outname :
                NULL;
            where.lineno = 0;
        }
    }

    return where;
}

/*
 * error reporting for critical and panic errors: minimize
 * the amount of system dependencies for getting a message out,
 * and in particular try to avoid memory allocations.
 */
fatal_func nasm_verror_critical(errflags severity, const char *fmt, va_list args)
{
    struct src_location where;
    errflags true_type = severity & ERR_MASK;
    static bool been_here = false;

    while (unlikely(been_here))
        abort();                /* Recursive critical error... just die */

    been_here = true;

    erropt.worst = true_type;

    where = error_where(severity);
    if (!where.filename)
        where.filename = no_file_name;

    fputs(error_pfx(severity), erropt.file);
    fputs(where.filename, erropt.file);
    if (where.lineno) {
        fprintf(erropt.file, "%s%"PRId32"%s",
                errfmt->beforeline, where.lineno, errfmt->afterline);
    }
    fputs(errfmt->beforemsg, erropt.file);
    vfprintf(erropt.file, fmt, args);
    fputc('\n', erropt.file);

    die_hard(true_type, severity);
    unreachable();
}

/**
 * Stack of tentative error hold lists.
 */
struct nasm_errtext {
    struct nasm_errtext *next;
    char *msg;                  /* Owned by this structure */
    struct src_location where;  /* Owned by the srcfile system */
    errflags severity;
    errflags true_type;
    int c_errno;                /* Saved errno (for ERR_PERROR) */
};
struct nasm_errhold {
    struct nasm_errhold *up;
    struct nasm_errtext *head, **tail;
};

static struct strlist *warn_list;
static struct nasm_errhold *errhold_stack;

static void nasm_free_error(struct nasm_errtext *et)
{
    nasm_free(et->msg);
    nasm_free(et);
}

static void nasm_issue_error(struct nasm_errtext *et);

struct nasm_errhold *nasm_error_hold_push(void)
{
    struct nasm_errhold *eh;

    nasm_new(eh);
    eh->up = errhold_stack;
    eh->tail = &eh->head;
    errhold_stack = eh;

    return eh;
}

/* Pop an error hold. Returns the highest severity issued or dropped. */
errflags nasm_error_hold_pop(struct nasm_errhold *eh, bool issue)
{
    struct nasm_errtext *et, *etmp;
    errflags worst = 0;

    /*
     * Allow calling with a null argument saying no hold in the first place.
     */
    if (!eh)
        return worst;

    /* This *must* be the current top of the errhold stack */
    nasm_assert(eh == errhold_stack);

    if (eh->head) {
        if (issue) {
            if (eh->up) {
                /* Commit the current hold list to the previous level */
                *eh->up->tail = eh->head;
                eh->up->tail = eh->tail;
            } else {
                /* Issue errors */
                list_for_each_safe(et, etmp, eh->head) {
                    if (et->true_type > worst)
                        worst = et->true_type;
                    nasm_issue_error(et);
                }
            }
        } else {
            /* Free the list, drop errors */
            list_for_each_safe(et, etmp, eh->head) {
                if (et->true_type > worst)
                    worst = et->true_type;
                nasm_free_error(et);
            }
        }
    }

    errhold_stack = eh->up;
    nasm_free(eh);
    return worst;
}

/**
 * common error reporting
 * This is the common back end of the error reporting schemes currently
 * implemented.  It prints the nature of the warning and then the
 * specific error message to erropt.file and may or may not return.  It
 * doesn't return if the error severity is a "panic" or "debug" type.
 *
 * @param severity the severity of the warning or error
 * @param fmt the printf style format string
 */
void nasm_verror(errflags severity, const char *fmt, va_list args)
{
    struct nasm_errtext *et;
    int c_errno = errno;
    errflags true_type = true_error_type(severity);

    if (true_type >= ERR_CRITICAL) {
        nasm_verror_critical(severity, fmt, args);
        abort();
    }

    if (is_suppressed(severity))
        return;

    nasm_new(et);
    et->c_errno = c_errno;
    et->severity = severity;
    et->true_type = true_type;
    et->msg = nasm_vasprintf(fmt, args);
    et->where = error_where(severity);

    if (errhold_stack && true_type <= ERR_NONFATAL) {
        /* It is a tentative error */
        *errhold_stack->tail = et;
        errhold_stack->tail = &et->next;
    } else {
        nasm_issue_error(et);
    }

    /*
     * Don't do this before then, if we do, we lose messages in the list
     * file, as the list file is only generated in the last pass.
     */
    if (skip_this_pass(severity))
        return;

    if (!(severity & (ERR_HERE|ERR_PP_LISTMACRO)))
        pp_error_list_macros(severity);
}

/*
 * Actually print, list and take action on an error
 */
static void nasm_issue_error(struct nasm_errtext *et)
{
    const char *pfx;
    char warnsuf[64];           /* Warning suffix */
    char linestr[64];           /* Formatted line number if applicable */
    const errflags severity  = et->severity;
    const errflags true_type = et->true_type;
    const struct src_location where = et->where;
    const char *cerrsep = "";
    const char *cerrmsg = "";
    bool buffer = true_type < ERR_NONFATAL || (severity & ERR_HOLD);

    if (severity & ERR_NO_SEVERITY)
        pfx = "";
    else
        pfx = error_pfx(true_type);

    *warnsuf = 0;
    if (!(severity & (ERR_HERE|ERR_PP_LISTMACRO))) {
        switch (severity & ERR_MASK) {
        case ERR_WARNING:
        {
            const unsigned int level = WARN_IDX(severity);
            snprintf(warnsuf, sizeof warnsuf, " [-w+%s%s]",
                     (true_type >= ERR_NONFATAL) ? "error=" : "",
                     warning_name[level]);
            break;
        }
        case ERR_DEBUG:
            snprintf(warnsuf, sizeof warnsuf, " [--debug=%u]", erropt.debug_nasm);
            break;
        case ERR_INFO:
            snprintf(warnsuf, sizeof warnsuf, " [--info=%u]", erropt.verbose_info);
            break;
        default:
            /* Not WARNING, DEBUG or INFO, not suppressible */
            break;
        }

        if (severity & ERR_PERROR) {
            cerrsep = ":";
            cerrmsg = strerror(et->c_errno);
        }
    }

    *linestr = 0;
    if (where.lineno) {
        snprintf(linestr, sizeof linestr, "%s%"PRId32"%s",
                 errfmt->beforeline, where.lineno, errfmt->afterline);
    }

    if (!skip_this_pass(severity)) {
        const char *file = where.filename ? where.filename : no_file_name;
        const char *here = "";

        if (severity & ERR_HERE) {
            here = where.filename ? " here" : " in an unknown location";
        }

        if (!warn_list)
            buffer = false;

        if (buffer) {
            /*
             * Buffer up warnings and held errors until we either get
             * an error or we are on the code-generation pass.
             */
            strlist_printf(warn_list, "%s%s%s%s%s%s%s%s%s",
                           file, linestr, errfmt->beforemsg,
                           pfx, et->msg, cerrsep, cerrmsg,
                           here, warnsuf);
        } else {
            /*
             * Actually output an error.  If we have buffered
             * warnings, and this is a non-warning, output them now.
             */
            if (warn_list) {
                strlist_write(warn_list, "\n", erropt.file);
                strlist_free(&warn_list);
            }

            fprintf(erropt.file, "%s%s%s%s%s%s%s%s%s\n",
                    file, linestr, errfmt->beforemsg,
                    pfx, et->msg, cerrsep, cerrmsg,
                    here, warnsuf);
        }
    }

    /* Are we recursing from error_list_macros? */
    if (severity & ERR_PP_LISTMACRO)
        goto done;

    /*
     * Don't suppress this with skip_this_pass(), or we don't get
     * pass1 or preprocessor warnings in the list file
     */
    if (severity & ERR_HERE) {
        if (where.lineno)
            lfmt->error(severity, "%s%s at %s:%"PRId32"%s",
                        pfx, et->msg, where.filename, where.lineno, warnsuf);
        else if (where.filename)
            lfmt->error(severity, "%s%s in file %s%s",
                        pfx, et->msg, where.filename, warnsuf);
        else
            lfmt->error(severity, "%s%s in an unknown location%s",
                        pfx, et->msg, warnsuf);
    } else {
        lfmt->error(severity, "%s%s%s", pfx, et->msg, warnsuf);
    }

    if (skip_this_pass(severity))
        goto done;

    if (true_type >= ERR_FATAL) {
        die_hard(true_type, severity);
    } else if (!buffer) {
        if (true_type > erropt.worst)
            erropt.worst = true_type;

        if (true_type >= ERR_NONFATAL)
            erropt.never |= ERR_UNDEAD;
    }

done:
    nasm_free_error(et);
}


int set_error_format(const char *fmt)
{
    if (!nasm_stricmp("vc", fmt) ||
        !nasm_stricmp("msvc", fmt) ||
        !nasm_stricmp("ms", fmt))
        errfmt = &errfmts[ERRFMT_MSVC];
    else if (!nasm_stricmp("gnu", fmt) ||
             !nasm_stricmp("gcc", fmt))
        errfmt = &errfmts[ERRFMT_GNU];
    else
        return -1;

    return 0;
}

static void usage(void)
{
    fprintf(erropt.file,
            "Usage: %s [-@ response_file] [options...] [--] filename\n"
            "   For additional help:\n"
            "       %s -h [run|topics|all|-option]\n",
            _progname, _progname);
}

void warn_dollar_hex(void)
{
    nasm_warn(WARN_NUMBER_DEPRECATED_HEX,
              "$ prefix for hexadecimal is deprecated");
}
