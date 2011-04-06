/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2011 The NASM Authors - All Rights Reserved
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
 * The Netwide Assembler main program module
 */

#include "compiler.h"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>
#include <limits.h>
#include <time.h>

#include "nasm.h"
#include "nasmlib.h"
#include "saa.h"
#include "raa.h"
#include "float.h"
#include "stdscan.h"
#include "insns.h"
#include "preproc.h"
#include "parser.h"
#include "eval.h"
#include "assemble.h"
#include "labels.h"
#include "output/outform.h"
#include "listing.h"

/*
 * This is the maximum number of optimization passes to do.  If we ever
 * find a case where the optimizer doesn't naturally converge, we might
 * have to drop this value so the assembler doesn't appear to just hang.
 */
#define MAX_OPTIMIZE (INT_MAX >> 1)

struct forwrefinfo {            /* info held on forward refs. */
    int lineno;
    int operand;
};

static int get_bits(char *value);
static uint32_t get_cpu(char *cpu_str);
static void parse_cmdline(int, char **);
static void assemble_file(char *, StrList **);
static void nasm_verror_gnu(int severity, const char *fmt, va_list args);
static void nasm_verror_vc(int severity, const char *fmt, va_list args);
static void nasm_verror_common(int severity, const char *fmt, va_list args);
static bool is_suppressed_warning(int severity);
static void usage(void);

static int using_debug_info, opt_verbose_info;
bool tasm_compatible_mode = false;
int pass0, passn;
int maxbits = 0;
int globalrel = 0;

static time_t official_compile_time;

static char inname[FILENAME_MAX];
static char outname[FILENAME_MAX];
static char listname[FILENAME_MAX];
static char errname[FILENAME_MAX];
static int globallineno;        /* for forward-reference tracking */
/* static int pass = 0; */
struct ofmt *ofmt = &OF_DEFAULT;
struct ofmt_alias *ofmt_alias = NULL;
const struct dfmt *dfmt;

static FILE *error_file;        /* Where to write error messages */

FILE *ofile = NULL;
int optimizing = MAX_OPTIMIZE; /* number of optimization passes to take */
static int sb, cmd_sb = 16;    /* by default */
static uint32_t cmd_cpu = IF_PLEVEL;       /* highest level by default */
static uint32_t cpu = IF_PLEVEL;   /* passed to insn_size & assemble.c */
int64_t global_offset_changed;      /* referenced in labels.c */
int64_t prev_offset_changed;
int32_t stall_count;

static struct location location;
int in_abs_seg;                 /* Flag we are in ABSOLUTE seg */
int32_t abs_seg;                   /* ABSOLUTE segment basis */
int32_t abs_offset;                /* ABSOLUTE offset */

static struct RAA *offsets;

static struct SAA *forwrefs;    /* keep track of forward references */
static const struct forwrefinfo *forwref;

static Preproc *preproc;
enum op_type {
    op_normal,                  /* Preprocess and assemble */
    op_preprocess,              /* Preprocess only */
    op_depend,                  /* Generate dependencies */
};
static enum op_type operating_mode;
/* Dependency flags */
static bool depend_emit_phony = false;
static bool depend_missing_ok = false;
static const char *depend_target = NULL;
static const char *depend_file = NULL;

/*
 * Which of the suppressible warnings are suppressed. Entry zero
 * isn't an actual warning, but it used for -w+error/-Werror.
 */

static bool warning_on[ERR_WARN_MAX+1]; /* Current state */
static bool warning_on_global[ERR_WARN_MAX+1]; /* Command-line state */

static const struct warning {
    const char *name;
    const char *help;
    bool enabled;
} warnings[ERR_WARN_MAX+1] = {
    {"error", "treat warnings as errors", false},
    {"macro-params", "macro calls with wrong parameter count", true},
    {"macro-selfref", "cyclic macro references", false},
    {"macro-defaults", "macros with more default than optional parameters", true},
    {"orphan-labels", "labels alone on lines without trailing `:'", true},
    {"number-overflow", "numeric constant does not fit", true},
    {"gnu-elf-extensions", "using 8- or 16-bit relocation in ELF32, a GNU extension", false},
    {"float-overflow", "floating point overflow", true},
    {"float-denorm", "floating point denormal", false},
    {"float-underflow", "floating point underflow", false},
    {"float-toolong", "too many digits in floating-point number", true},
    {"user", "%warning directives", true},
};

/*
 * This is a null preprocessor which just copies lines from input
 * to output. It's used when someone explicitly requests that NASM
 * not preprocess their source file.
 */

static void no_pp_reset(char *, int, ListGen *, StrList **);
static char *no_pp_getline(void);
static void no_pp_cleanup(int);
static Preproc no_pp = {
    no_pp_reset,
    no_pp_getline,
    no_pp_cleanup
};

/*
 * get/set current offset...
 */
#define GET_CURR_OFFS (in_abs_seg?abs_offset:\
		      raa_read(offsets,location.segment))
#define SET_CURR_OFFS(x) (in_abs_seg?(void)(abs_offset=(x)):\
			 (void)(offsets=raa_write(offsets,location.segment,(x))))

static bool want_usage;
static bool terminate_after_phase;
int user_nolist = 0;            /* fbk 9/2/00 */

static void nasm_fputs(const char *line, FILE * outfile)
{
    if (outfile) {
        fputs(line, outfile);
        putc('\n', outfile);
    } else
        puts(line);
}

/* Convert a struct tm to a POSIX-style time constant */
static int64_t posix_mktime(struct tm *tm)
{
    int64_t t;
    int64_t y = tm->tm_year;

    /* See IEEE 1003.1:2004, section 4.14 */

    t = (y-70)*365 + (y-69)/4 - (y-1)/100 + (y+299)/400;
    t += tm->tm_yday;
    t *= 24;
    t += tm->tm_hour;
    t *= 60;
    t += tm->tm_min;
    t *= 60;
    t += tm->tm_sec;

    return t;
}

static void define_macros_early(void)
{
    char temp[128];
    struct tm lt, *lt_p, gm, *gm_p;
    int64_t posix_time;

    lt_p = localtime(&official_compile_time);
    if (lt_p) {
	lt = *lt_p;

	strftime(temp, sizeof temp, "__DATE__=\"%Y-%m-%d\"", &lt);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__DATE_NUM__=%Y%m%d", &lt);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__TIME__=\"%H:%M:%S\"", &lt);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__TIME_NUM__=%H%M%S", &lt);
	pp_pre_define(temp);
    }

    gm_p = gmtime(&official_compile_time);
    if (gm_p) {
	gm = *gm_p;

	strftime(temp, sizeof temp, "__UTC_DATE__=\"%Y-%m-%d\"", &gm);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__UTC_DATE_NUM__=%Y%m%d", &gm);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__UTC_TIME__=\"%H:%M:%S\"", &gm);
	pp_pre_define(temp);
	strftime(temp, sizeof temp, "__UTC_TIME_NUM__=%H%M%S", &gm);
	pp_pre_define(temp);
    }

    if (gm_p)
	posix_time = posix_mktime(&gm);
    else if (lt_p)
	posix_time = posix_mktime(&lt);
    else
	posix_time = 0;

    if (posix_time) {
	snprintf(temp, sizeof temp, "__POSIX_TIME__=%"PRId64, posix_time);
	pp_pre_define(temp);
    }
}

static void define_macros_late(void)
{
    char temp[128];

    /*
     * In case if output format is defined by alias
     * we have to put shortname of the alias itself here
     * otherwise ABI backward compatibility gets broken.
     */
    snprintf(temp, sizeof(temp), "__OUTPUT_FORMAT__=%s",
             ofmt_alias ? ofmt_alias->shortname : ofmt->shortname);
    pp_pre_define(temp);
}

static void emit_dependencies(StrList *list)
{
    FILE *deps;
    int linepos, len;
    StrList *l, *nl;

    if (depend_file && strcmp(depend_file, "-")) {
	deps = fopen(depend_file, "w");
	if (!deps) {
	    nasm_error(ERR_NONFATAL|ERR_NOFILE|ERR_USAGE,
			 "unable to write dependency file `%s'", depend_file);
	    return;
	}
    } else {
	deps = stdout;
    }

    linepos = fprintf(deps, "%s:", depend_target);
    list_for_each(l, list) {
	len = strlen(l->str);
	if (linepos + len > 62) {
	    fprintf(deps, " \\\n ");
	    linepos = 1;
	}
	fprintf(deps, " %s", l->str);
	linepos += len+1;
    }
    fprintf(deps, "\n\n");

    list_for_each_safe(l, nl, list) {
	if (depend_emit_phony)
	    fprintf(deps, "%s:\n\n", l->str);
	nasm_free(l);
    }

    if (deps != stdout)
	fclose(deps);
}

int main(int argc, char **argv)
{
    StrList *depend_list = NULL, **depend_ptr;

    time(&official_compile_time);

    pass0 = 0;
    want_usage = terminate_after_phase = false;
    nasm_set_verror(nasm_verror_gnu);

    error_file = stderr;

    tolower_init();

    nasm_init_malloc_error();
    offsets = raa_init();
    forwrefs = saa_init((int32_t)sizeof(struct forwrefinfo));

    preproc = &nasmpp;
    operating_mode = op_normal;

    seg_init();

    /* Define some macros dependent on the runtime, but not
       on the command line. */
    define_macros_early();

    parse_cmdline(argc, argv);

    if (terminate_after_phase) {
        if (want_usage)
            usage();
        return 1;
    }

    /* If debugging info is disabled, suppress any debug calls */
    if (!using_debug_info)
        ofmt->current_dfmt = &null_debug_form;

    if (ofmt->stdmac)
        pp_extra_stdmac(ofmt->stdmac);
    parser_global_info(&location);
    eval_global_info(ofmt, lookup_label, &location);

    /* define some macros dependent of command-line */
    define_macros_late();

    depend_ptr = (depend_file || (operating_mode == op_depend))
	? &depend_list : NULL;
    if (!depend_target)
	depend_target = outname;

    switch (operating_mode) {
    case op_depend:
        {
            char *line;

	    if (depend_missing_ok)
		pp_include_path(NULL);	/* "assume generated" */

            preproc->reset(inname, 0, &nasmlist, depend_ptr);
            if (outname[0] == '\0')
                ofmt->filename(inname, outname);
            ofile = NULL;
            while ((line = preproc->getline()))
                nasm_free(line);
            preproc->cleanup(0);
        }
        break;

    case op_preprocess:
        {
            char *line;
            char *file_name = NULL;
            int32_t prior_linnum = 0;
            int lineinc = 0;

            if (*outname) {
                ofile = fopen(outname, "w");
                if (!ofile)
                    nasm_error(ERR_FATAL | ERR_NOFILE,
                                 "unable to open output file `%s'",
                                 outname);
            } else
                ofile = NULL;

            location.known = false;

	    /* pass = 1; */
            preproc->reset(inname, 3, &nasmlist, depend_ptr);

            while ((line = preproc->getline())) {
                /*
                 * We generate %line directives if needed for later programs
                 */
                int32_t linnum = prior_linnum += lineinc;
                int altline = src_get(&linnum, &file_name);
                if (altline) {
                    if (altline == 1 && lineinc == 1)
                        nasm_fputs("", ofile);
                    else {
                        lineinc = (altline != -1 || lineinc != 1);
                        fprintf(ofile ? ofile : stdout,
                                "%%line %"PRId32"+%d %s\n", linnum, lineinc,
                                file_name);
                    }
                    prior_linnum = linnum;
                }
                nasm_fputs(line, ofile);
                nasm_free(line);
            }
            nasm_free(file_name);
            preproc->cleanup(0);
            if (ofile)
                fclose(ofile);
            if (ofile && terminate_after_phase)
                remove(outname);
	    ofile = NULL;
        }
        break;

    case op_normal:
        {
            /*
             * We must call ofmt->filename _anyway_, even if the user
             * has specified their own output file, because some
             * formats (eg OBJ and COFF) use ofmt->filename to find out
             * the name of the input file and then put that inside the
             * file.
             */
            ofmt->filename(inname, outname);

            ofile = fopen(outname, (ofmt->flags & OFMT_TEXT) ? "w" : "wb");
            if (!ofile) {
                nasm_error(ERR_FATAL | ERR_NOFILE,
                             "unable to open output file `%s'", outname);
            }

            /*
             * We must call init_labels() before ofmt->init() since
             * some object formats will want to define labels in their
             * init routines. (eg OS/2 defines the FLAT group)
             */
            init_labels();

            ofmt->init();
	    dfmt = ofmt->current_dfmt;
            dfmt->init();

            assemble_file(inname, depend_ptr);

            if (!terminate_after_phase) {
                ofmt->cleanup(using_debug_info);
                cleanup_labels();
		fflush(ofile);
		if (ferror(ofile)) {
		    nasm_error(ERR_NONFATAL|ERR_NOFILE,
				 "write error on output file `%s'", outname);
		}
	    }

	    if (ofile) {
		fclose(ofile);
		if (terminate_after_phase)
		    remove(outname);
		ofile = NULL;
	    }
        }
        break;
    }

    if (depend_list && !terminate_after_phase)
	emit_dependencies(depend_list);

    if (want_usage)
        usage();

    raa_free(offsets);
    saa_free(forwrefs);
    eval_cleanup();
    stdscan_cleanup();

    return terminate_after_phase;
}

/*
 * Get a parameter for a command line option.
 * First arg must be in the form of e.g. -f...
 */
static char *get_param(char *p, char *q, bool *advance)
{
    *advance = false;
    if (p[2]) /* the parameter's in the option */
        return nasm_skip_spaces(p + 2);
    if (q && q[0]) {
        *advance = true;
        return q;
    }
    nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                 "option `-%c' requires an argument", p[1]);
    return NULL;
}

/*
 * Copy a filename
 */
static void copy_filename(char *dst, const char *src)
{
    size_t len = strlen(src);

    if (len >= (size_t)FILENAME_MAX) {
	nasm_error(ERR_FATAL | ERR_NOFILE, "file name too long");
	return;
    }
    strncpy(dst, src, FILENAME_MAX);
}

/*
 * Convert a string to Make-safe form
 */
static char *quote_for_make(const char *str)
{
    const char *p;
    char *os, *q;

    size_t n = 1;		/* Terminating zero */
    size_t nbs = 0;

    if (!str)
	return NULL;

    for (p = str; *p; p++) {
	switch (*p) {
	case ' ':
	case '\t':
	    /* Convert N backslashes + ws -> 2N+1 backslashes + ws */
	    n += nbs + 2;
	    nbs = 0;
	    break;
	case '$':
	case '#':
	    nbs = 0;
	    n += 2;
	    break;
	case '\\':
	    nbs++;
	    n++;
	    break;
	default:
	    nbs = 0;
	    n++;
	break;
	}
    }

    /* Convert N backslashes at the end of filename to 2N backslashes */
    if (nbs)
	n += nbs;

    os = q = nasm_malloc(n);

    nbs = 0;
    for (p = str; *p; p++) {
	switch (*p) {
	case ' ':
	case '\t':
	    while (nbs--)
		*q++ = '\\';
	    *q++ = '\\';
	    *q++ = *p;
	    break;
	case '$':
	    *q++ = *p;
	    *q++ = *p;
	    nbs = 0;
	    break;
	case '#':
	    *q++ = '\\';
	    *q++ = *p;
	    nbs = 0;
	    break;
	case '\\':
	    *q++ = *p;
	    nbs++;
	    break;
	default:
	    *q++ = *p;
	    nbs = 0;
	break;
	}
    }
    while (nbs--)
	*q++ = '\\';

    *q = '\0';

    return os;
}

struct textargs {
    const char *label;
    int value;
};

#define OPT_PREFIX 0
#define OPT_POSTFIX 1
struct textargs textopts[] = {
    {"prefix", OPT_PREFIX},
    {"postfix", OPT_POSTFIX},
    {NULL, 0}
};

static bool stopoptions = false;
static bool process_arg(char *p, char *q)
{
    char *param;
    int i;
    bool advance = false;
    bool do_warn;

    if (!p || !p[0])
        return false;

    if (p[0] == '-' && !stopoptions) {
	if (strchr("oOfpPdDiIlFXuUZwW", p[1])) {
	    /* These parameters take values */
	    if (!(param = get_param(p, q, &advance)))
		return advance;
	}

        switch (p[1]) {
        case 's':
            error_file = stdout;
            break;

	case 'o':		/* output file */
	    copy_filename(outname, param);
	    break;

	case 'f':		/* output format */
        ofmt = ofmt_find(param, &ofmt_alias);
	    if (!ofmt) {
		nasm_error(ERR_FATAL | ERR_NOFILE | ERR_USAGE,
			     "unrecognised output format `%s' - "
			     "use -hf for a list", param);
	    }
	    break;

	case 'O':		/* Optimization level */
	{
	    int opt;

	    if (!*param) {
		/* Naked -O == -Ox */
		optimizing = MAX_OPTIMIZE;
	    } else {
		while (*param) {
		    switch (*param) {
		    case '0': case '1': case '2': case '3': case '4':
		    case '5': case '6': case '7': case '8': case '9':
			opt = strtoul(param, &param, 10);

			/* -O0 -> optimizing == -1, 0.98 behaviour */
			/* -O1 -> optimizing == 0, 0.98.09 behaviour */
			if (opt < 2)
			    optimizing = opt - 1;
			else
			    optimizing = opt;
			break;

		    case 'v':
		    case '+':
			param++;
			opt_verbose_info = true;
			break;

		    case 'x':
			param++;
			optimizing = MAX_OPTIMIZE;
			break;

		    default:
			nasm_error(ERR_FATAL,
				     "unknown optimization option -O%c\n",
				     *param);
			break;
		    }
		}
		if (optimizing > MAX_OPTIMIZE)
		    optimizing = MAX_OPTIMIZE;
	    }
	    break;
	}

	case 'p':			/* pre-include */
	case 'P':
	    pp_pre_include(param);
	    break;

	case 'd':			/* pre-define */
	case 'D':
	    pp_pre_define(param);
	    break;

	case 'u':			/* un-define */
	case 'U':
	    pp_pre_undefine(param);
	    break;

	case 'i':			/* include search path */
	case 'I':
	    pp_include_path(param);
	    break;

	case 'l':			/* listing file */
	    copy_filename(listname, param);
	    break;

	case 'Z':			/* error messages file */
	    copy_filename(errname, param);
	    break;

	case 'F':			/* specify debug format */
	    ofmt->current_dfmt = dfmt_find(ofmt, param);
	    if (!ofmt->current_dfmt) {
		nasm_error(ERR_FATAL | ERR_NOFILE | ERR_USAGE,
			     "unrecognized debug format `%s' for"
			     " output format `%s'",
			     param, ofmt->shortname);
	    }
	    using_debug_info = true;
	    break;

	case 'X':		/* specify error reporting format */
	    if (nasm_stricmp("vc", param) == 0)
		nasm_set_verror(nasm_verror_vc);
	    else if (nasm_stricmp("gnu", param) == 0)
		nasm_set_verror(nasm_verror_gnu);
	    else
		nasm_error(ERR_FATAL | ERR_NOFILE | ERR_USAGE,
			     "unrecognized error reporting format `%s'",
			     param);
            break;

        case 'g':
            using_debug_info = true;
            break;

        case 'h':
            printf
                ("usage: nasm [-@ response file] [-o outfile] [-f format] "
                 "[-l listfile]\n"
                 "            [options...] [--] filename\n"
                 "    or nasm -v   for version info\n\n"
                 "    -t          assemble in SciTech TASM compatible mode\n"
                 "    -g          generate debug information in selected format\n");
            printf
                ("    -E (or -e)  preprocess only (writes output to stdout by default)\n"
                 "    -a          don't preprocess (assemble only)\n"
                 "    -M          generate Makefile dependencies on stdout\n"
                 "    -MG         d:o, missing files assumed generated\n"
                 "    -MF <file>  set Makefile dependency file\n"
                 "    -MD <file>  assemble and generate dependencies\n"
                 "    -MT <file>  dependency target name\n"
                 "    -MQ <file>  dependency target name (quoted)\n"
                 "    -MP         emit phony target\n\n"
                 "    -Z<file>    redirect error messages to file\n"
                 "    -s          redirect error messages to stdout\n\n"
                 "    -F format   select a debugging format\n\n"
                 "    -I<path>    adds a pathname to the include file path\n");
            printf
                ("    -O<digit>   optimize branch offsets\n"
                 "                -O0: No optimization (default)\n"
                 "                -O1: Minimal optimization\n"
                 "                -Ox: Multipass optimization (recommended)\n\n"
                 "    -P<file>    pre-includes a file\n"
                 "    -D<macro>[=<value>] pre-defines a macro\n"
                 "    -U<macro>   undefines a macro\n"
                 "    -X<format>  specifies error reporting format (gnu or vc)\n"
                 "    -w+foo      enables warning foo (equiv. -Wfoo)\n"
                 "    -w-foo      disable warning foo (equiv. -Wno-foo)\n\n"
                 "--prefix,--postfix\n"
                 "  this options prepend or append the given argument to all\n"
                 "  extern and global variables\n\n"
                 "Warnings:\n");
            for (i = 0; i <= ERR_WARN_MAX; i++)
                printf("    %-23s %s (default %s)\n",
                       warnings[i].name, warnings[i].help,
                       warnings[i].enabled ? "on" : "off");
            printf
                ("\nresponse files should contain command line parameters"
                 ", one per line.\n");
            if (p[2] == 'f') {
                printf("\nvalid output formats for -f are"
                       " (`*' denotes default):\n");
                ofmt_list(ofmt, stdout);
            } else {
                printf("\nFor a list of valid output formats, use -hf.\n");
                printf("For a list of debug formats, use -f <form> -y.\n");
            }
            exit(0);            /* never need usage message here */
            break;

        case 'y':
            printf("\nvalid debug formats for '%s' output format are"
                   " ('*' denotes default):\n", ofmt->shortname);
            dfmt_list(ofmt, stdout);
            exit(0);
            break;

        case 't':
            tasm_compatible_mode = true;
            break;

        case 'v':
	    printf("NASM version %s compiled on %s%s\n",
		   nasm_version, nasm_date, nasm_compile_options);
	    exit(0);        /* never need usage message here */
            break;

        case 'e':              /* preprocess only */
	case 'E':
            operating_mode = op_preprocess;
            break;

        case 'a':              /* assemble only - don't preprocess */
            preproc = &no_pp;
            break;

	case 'W':
	    if (param[0] == 'n' && param[1] == 'o' && param[2] == '-') {
		do_warn = false;
		param += 3;
	    } else {
		do_warn = true;
	    }
	    goto set_warning;

        case 'w':
            if (param[0] != '+' && param[0] != '-') {
                nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                             "invalid option to `-w'");
		break;
            }
	    do_warn = (param[0] == '+');
	    param++;

set_warning:
	    for (i = 0; i <= ERR_WARN_MAX; i++)
		if (!nasm_stricmp(param, warnings[i].name))
		    break;
	    if (i <= ERR_WARN_MAX)
		warning_on_global[i] = do_warn;
	    else if (!nasm_stricmp(param, "all"))
		for (i = 1; i <= ERR_WARN_MAX; i++)
		    warning_on_global[i] = do_warn;
	    else if (!nasm_stricmp(param, "none"))
		for (i = 1; i <= ERR_WARN_MAX; i++)
		    warning_on_global[i] = !do_warn;
	    else
		nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			     "invalid warning `%s'", param);
            break;

        case 'M':
	    switch (p[2]) {
	    case 0:
		operating_mode = op_depend;
		break;
	    case 'G':
		operating_mode = op_depend;
		depend_missing_ok = true;
		break;
	    case 'P':
		depend_emit_phony = true;
		break;
	    case 'D':
		depend_file = q;
		advance = true;
		break;
	    case 'T':
		depend_target = q;
		advance = true;
		break;
	    case 'Q':
		depend_target = quote_for_make(q);
		advance = true;
		break;
	    default:
		nasm_error(ERR_NONFATAL|ERR_NOFILE|ERR_USAGE,
			     "unknown dependency option `-M%c'", p[2]);
		break;
	    }
	    if (advance && (!q || !q[0])) {
		nasm_error(ERR_NONFATAL|ERR_NOFILE|ERR_USAGE,
			     "option `-M%c' requires a parameter", p[2]);
		break;
	    }
            break;

        case '-':
            {
                int s;

                if (p[2] == 0) {        /* -- => stop processing options */
                    stopoptions = 1;
                    break;
                }
                for (s = 0; textopts[s].label; s++) {
                    if (!nasm_stricmp(p + 2, textopts[s].label)) {
                        break;
                    }
                }

                switch (s) {

                case OPT_PREFIX:
                case OPT_POSTFIX:
                    {
                        if (!q) {
                            nasm_error(ERR_NONFATAL | ERR_NOFILE |
                                         ERR_USAGE,
                                         "option `--%s' requires an argument",
                                         p + 2);
                            break;
                        } else {
                            advance = 1, param = q;
                        }

                        if (s == OPT_PREFIX) {
                            strncpy(lprefix, param, PREFIX_MAX - 1);
                            lprefix[PREFIX_MAX - 1] = 0;
                            break;
                        }
                        if (s == OPT_POSTFIX) {
                            strncpy(lpostfix, param, POSTFIX_MAX - 1);
                            lpostfix[POSTFIX_MAX - 1] = 0;
                            break;
                        }
                        break;
                    }
                default:
                    {
                        nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                                     "unrecognised option `--%s'", p + 2);
                        break;
                    }
                }
                break;
            }

        default:
            if (!ofmt->setinfo(GI_SWITCH, &p))
                nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                             "unrecognised option `-%c'", p[1]);
            break;
        }
    } else {
        if (*inname) {
            nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                         "more than one input file specified");
        } else {
            copy_filename(inname, p);
	}
    }

    return advance;
}

#define ARG_BUF_DELTA 128

static void process_respfile(FILE * rfile)
{
    char *buffer, *p, *q, *prevarg;
    int bufsize, prevargsize;

    bufsize = prevargsize = ARG_BUF_DELTA;
    buffer = nasm_malloc(ARG_BUF_DELTA);
    prevarg = nasm_malloc(ARG_BUF_DELTA);
    prevarg[0] = '\0';

    while (1) {                 /* Loop to handle all lines in file */
        p = buffer;
        while (1) {             /* Loop to handle long lines */
            q = fgets(p, bufsize - (p - buffer), rfile);
            if (!q)
                break;
            p += strlen(p);
            if (p > buffer && p[-1] == '\n')
                break;
            if (p - buffer > bufsize - 10) {
                int offset;
                offset = p - buffer;
                bufsize += ARG_BUF_DELTA;
                buffer = nasm_realloc(buffer, bufsize);
                p = buffer + offset;
            }
        }

        if (!q && p == buffer) {
            if (prevarg[0])
                process_arg(prevarg, NULL);
            nasm_free(buffer);
            nasm_free(prevarg);
            return;
        }

        /*
         * Play safe: remove CRs, LFs and any spurious ^Zs, if any of
         * them are present at the end of the line.
         */
        *(p = &buffer[strcspn(buffer, "\r\n\032")]) = '\0';

        while (p > buffer && nasm_isspace(p[-1]))
            *--p = '\0';

        p = nasm_skip_spaces(buffer);

        if (process_arg(prevarg, p))
            *p = '\0';

        if ((int) strlen(p) > prevargsize - 10) {
            prevargsize += ARG_BUF_DELTA;
            prevarg = nasm_realloc(prevarg, prevargsize);
        }
        strncpy(prevarg, p, prevargsize);
    }
}

/* Function to process args from a string of args, rather than the
 * argv array. Used by the environment variable and response file
 * processing.
 */
static void process_args(char *args)
{
    char *p, *q, *arg, *prevarg;
    char separator = ' ';

    p = args;
    if (*p && *p != '-')
        separator = *p++;
    arg = NULL;
    while (*p) {
        q = p;
        while (*p && *p != separator)
            p++;
        while (*p == separator)
            *p++ = '\0';
        prevarg = arg;
        arg = q;
        if (process_arg(prevarg, arg))
            arg = NULL;
    }
    if (arg)
        process_arg(arg, NULL);
}

static void process_response_file(const char *file)
{
    char str[2048];
    FILE *f = fopen(file, "r");
    if (!f) {
	perror(file);
	exit(-1);
    }
    while (fgets(str, sizeof str, f)) {
	process_args(str);
    }
    fclose(f);
}

static void parse_cmdline(int argc, char **argv)
{
    FILE *rfile;
    char *envreal, *envcopy = NULL, *p, *arg;
    int i;

    *inname = *outname = *listname = *errname = '\0';
    for (i = 0; i <= ERR_WARN_MAX; i++)
	warning_on_global[i] = warnings[i].enabled;

    /*
     * First, process the NASMENV environment variable.
     */
    envreal = getenv("NASMENV");
    arg = NULL;
    if (envreal) {
        envcopy = nasm_strdup(envreal);
        process_args(envcopy);
        nasm_free(envcopy);
    }

    /*
     * Now process the actual command line.
     */
    while (--argc) {
	bool advance;
        argv++;
        if (argv[0][0] == '@') {
            /* We have a response file, so process this as a set of
             * arguments like the environment variable. This allows us
             * to have multiple arguments on a single line, which is
             * different to the -@resp file processing below for regular
             * NASM.
             */
	    process_response_file(argv[0]+1);
            argc--;
            argv++;
        }
        if (!stopoptions && argv[0][0] == '-' && argv[0][1] == '@') {
	    p = get_param(argv[0], argc > 1 ? argv[1] : NULL, &advance);
            if (p) {
		rfile = fopen(p, "r");
                if (rfile) {
                    process_respfile(rfile);
                    fclose(rfile);
                } else
                    nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                                 "unable to open response file `%s'", p);
            }
        } else
            advance = process_arg(argv[0], argc > 1 ? argv[1] : NULL);
        argv += advance, argc -= advance;
    }

    /* Look for basic command line typos.  This definitely doesn't
       catch all errors, but it might help cases of fumbled fingers. */
    if (!*inname)
        nasm_error(ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
                     "no input file specified");
    else if (!strcmp(inname, errname) ||
	     !strcmp(inname, outname) ||
	     !strcmp(inname, listname) ||
	     (depend_file && !strcmp(inname, depend_file)))
	nasm_error(ERR_FATAL | ERR_NOFILE | ERR_USAGE,
		     "file `%s' is both input and output file",
		     inname);

    if (*errname) {
	error_file = fopen(errname, "w");
	if (!error_file) {
	    error_file = stderr;        /* Revert to default! */
	    nasm_error(ERR_FATAL | ERR_NOFILE | ERR_USAGE,
			 "cannot open file `%s' for error messages",
			 errname);
	}
    }
}

static enum directives getkw(char **directive, char **value);

static void assemble_file(char *fname, StrList **depend_ptr)
{
    char *directive, *value, *p, *q, *special, *line;
    insn output_ins;
    int i, validid;
    bool rn_error;
    int32_t seg;
    int64_t offs;
    struct tokenval tokval;
    expr *e;
    int pass_max;

    if (cmd_sb == 32 && cmd_cpu < IF_386)
        nasm_error(ERR_FATAL, "command line: "
                     "32-bit segment size requires a higher cpu");

    pass_max = prev_offset_changed = (INT_MAX >> 1) + 2; /* Almost unlimited */
    for (passn = 1; pass0 <= 2; passn++) {
        int pass1, pass2;
        ldfunc def_label;

        pass1 = pass0 == 2 ? 2 : 1;	/* 1, 1, 1, ..., 1, 2 */
        pass2 = passn > 1  ? 2 : 1;     /* 1, 2, 2, ..., 2, 2 */
        /* pass0                           0, 0, 0, ..., 1, 2 */

        def_label = passn > 1 ? redefine_label : define_label;

        globalbits = sb = cmd_sb;   /* set 'bits' to command line default */
        cpu = cmd_cpu;
        if (pass0 == 2) {
            if (*listname)
                nasmlist.init(listname, nasm_error);
        }
        in_abs_seg = false;
        global_offset_changed = 0;  /* set by redefine_label */
        location.segment = ofmt->section(NULL, pass2, &sb);
        globalbits = sb;
        if (passn > 1) {
            saa_rewind(forwrefs);
            forwref = saa_rstruct(forwrefs);
            raa_free(offsets);
            offsets = raa_init();
        }
        preproc->reset(fname, pass1, &nasmlist,
		       pass1 == 2 ? depend_ptr : NULL);
        memcpy(warning_on, warning_on_global, (ERR_WARN_MAX+1) * sizeof(bool));

        globallineno = 0;
        if (passn == 1)
            location.known = true;
        location.offset = offs = GET_CURR_OFFS;

        while ((line = preproc->getline())) {
	    enum directives d;
            globallineno++;

            /*
	     * Here we parse our directives; this is not handled by the
	     * 'real' parser.  This really should be a separate function.
	     */
            directive = line;
	    d = getkw(&directive, &value);
            if (d) {
		int err = 0;

                switch (d) {
                case D_SEGMENT:		/* [SEGMENT n] */
		case D_SECTION:
                    seg = ofmt->section(value, pass2, &sb);
                    if (seg == NO_SEG) {
                        nasm_error(pass1 == 1 ? ERR_NONFATAL : ERR_PANIC,
                                     "segment name `%s' not recognized",
                                     value);
                    } else {
                        in_abs_seg = false;
                        location.segment = seg;
                    }
                    break;
                case D_SECTALIGN:        /* [SECTALIGN n] */
                    {
                        if (*value) {
                            unsigned int align = atoi(value);
                            if (!is_power2(align)) {
                                nasm_error(ERR_NONFATAL,
                                           "segment alignment `%s' is not power of two",
                                            value);
                            }
                            /* callee should be able to handle all details */
                            ofmt->sectalign(location.segment, align);
                        }
                    }
                    break;
                case D_EXTERN:              /* [EXTERN label:special] */
                    if (*value == '$')
                        value++;        /* skip initial $ if present */
                    if (pass0 == 2) {
                        q = value;
                        while (*q && *q != ':')
                            q++;
                        if (*q == ':') {
                            *q++ = '\0';
                            ofmt->symdef(value, 0L, 0L, 3, q);
                        }
                    } else if (passn == 1) {
                        q = value;
                        validid = true;
                        if (!isidstart(*q))
                            validid = false;
                        while (*q && *q != ':') {
                            if (!isidchar(*q))
                                validid = false;
                            q++;
                        }
                        if (!validid) {
                            nasm_error(ERR_NONFATAL,
                                         "identifier expected after EXTERN");
                            break;
                        }
                        if (*q == ':') {
                            *q++ = '\0';
                            special = q;
                        } else
                            special = NULL;
                        if (!is_extern(value)) {        /* allow re-EXTERN to be ignored */
                            int temp = pass0;
                            pass0 = 1;  /* fake pass 1 in labels.c */
                            declare_as_global(value, special);
                            define_label(value, seg_alloc(), 0L, NULL,
                                         false, true);
                            pass0 = temp;
                        }
                    }           /* else  pass0 == 1 */
                    break;
                case D_BITS:		/* [BITS bits] */
                    globalbits = sb = get_bits(value);
                    break;
                case D_GLOBAL:		/* [GLOBAL symbol:special] */
                    if (*value == '$')
                        value++;        /* skip initial $ if present */
                    if (pass0 == 2) {   /* pass 2 */
                        q = value;
                        while (*q && *q != ':')
                            q++;
                        if (*q == ':') {
                            *q++ = '\0';
                            ofmt->symdef(value, 0L, 0L, 3, q);
                        }
                    } else if (pass2 == 1) {    /* pass == 1 */
                        q = value;
                        validid = true;
                        if (!isidstart(*q))
                            validid = false;
                        while (*q && *q != ':') {
                            if (!isidchar(*q))
                                validid = false;
                            q++;
                        }
                        if (!validid) {
                            nasm_error(ERR_NONFATAL,
                                         "identifier expected after GLOBAL");
                            break;
                        }
                        if (*q == ':') {
                            *q++ = '\0';
                            special = q;
                        } else
                            special = NULL;
                        declare_as_global(value, special);
                    }           /* pass == 1 */
                    break;
                case D_COMMON:		/* [COMMON symbol size:special] */
		{
		    int64_t size;

                    if (*value == '$')
                        value++;        /* skip initial $ if present */
		    p = value;
		    validid = true;
		    if (!isidstart(*p))
			validid = false;
		    while (*p && !nasm_isspace(*p)) {
			if (!isidchar(*p))
			    validid = false;
			p++;
		    }
		    if (!validid) {
			nasm_error(ERR_NONFATAL,
				     "identifier expected after COMMON");
			break;
		    }
		    if (*p) {
                        p = nasm_zap_spaces_fwd(p);
			q = p;
			while (*q && *q != ':')
			    q++;
			if (*q == ':') {
			    *q++ = '\0';
			    special = q;
			} else {
			    special = NULL;
			}
			size = readnum(p, &rn_error);
			if (rn_error) {
			    nasm_error(ERR_NONFATAL,
					 "invalid size specified"
					 " in COMMON declaration");
			    break;
			}
		    } else {
			nasm_error(ERR_NONFATAL,
				     "no size specified in"
				     " COMMON declaration");
			break;
		    }

                    if (pass0 < 2) {
			define_common(value, seg_alloc(), size, special);
                    } else if (pass0 == 2) {
			if (special)
			    ofmt->symdef(value, 0L, 0L, 3, special);
                    }
                    break;
		}
                case D_ABSOLUTE:		/* [ABSOLUTE address] */
                    stdscan_reset();
                    stdscan_set(value);
                    tokval.t_type = TOKEN_INVALID;
                    e = evaluate(stdscan, NULL, &tokval, NULL, pass2,
                                 nasm_error, NULL);
                    if (e) {
                        if (!is_reloc(e))
                            nasm_error(pass0 ==
                                         1 ? ERR_NONFATAL : ERR_PANIC,
                                         "cannot use non-relocatable expression as "
                                         "ABSOLUTE address");
                        else {
                            abs_seg = reloc_seg(e);
                            abs_offset = reloc_value(e);
                        }
                    } else if (passn == 1)
                        abs_offset = 0x100;     /* don't go near zero in case of / */
                    else
                        nasm_error(ERR_PANIC, "invalid ABSOLUTE address "
                                     "in pass two");
                    in_abs_seg = true;
                    location.segment = NO_SEG;
                    break;
                case D_DEBUG:		/* [DEBUG] */
		{
		    char debugid[128];
		    bool badid, overlong;

                    p = value;
                    q = debugid;
		    badid = overlong = false;
                    if (!isidstart(*p)) {
                        badid = true;
		    } else {
			while (*p && !nasm_isspace(*p)) {
			    if (q >= debugid + sizeof debugid - 1) {
				overlong = true;
				break;
			    }
			    if (!isidchar(*p))
				badid = true;
			    *q++ = *p++;
			}
			*q = 0;
		    }
                    if (badid) {
			nasm_error(passn == 1 ? ERR_NONFATAL : ERR_PANIC,
				   "identifier expected after DEBUG");
			break;
		    }
		    if (overlong) {
			nasm_error(passn == 1 ? ERR_NONFATAL : ERR_PANIC,
				   "DEBUG identifier too long");
			break;
		    }
                    p = nasm_skip_spaces(p);
                    if (pass0 == 2)
                        dfmt->debug_directive(debugid, p);
                    break;
		}
                case D_WARNING:		/* [WARNING {+|-|*}warn-name] */
                    value = nasm_skip_spaces(value);
		    switch(*value) {
		    case '-': validid = 0; value++; break;
		    case '+': validid = 1; value++; break;
		    case '*': validid = 2; value++; break;
		    default:  validid = 1; break;
		    }

		    for (i = 1; i <= ERR_WARN_MAX; i++)
			if (!nasm_stricmp(value, warnings[i].name))
			    break;
		    if (i <= ERR_WARN_MAX) {
			switch(validid) {
			case 0:
			    warning_on[i] = false;
			    break;
			case 1:
			    warning_on[i] = true;
			    break;
			case 2:
			    warning_on[i] = warning_on_global[i];
			    break;
			}
		    }
		    else
			nasm_error(ERR_NONFATAL,
				     "invalid warning id in WARNING directive");
                    break;
                case D_CPU:		/* [CPU] */
                    cpu = get_cpu(value);
                    break;
                case D_LIST:		/* [LIST {+|-}] */
                    value = nasm_skip_spaces(value);
                    if (*value == '+') {
                        user_nolist = 0;
                    } else {
                        if (*value == '-') {
                            user_nolist = 1;
                        } else {
			    err = 1;
                        }
                    }
                    break;
		case D_DEFAULT:		/* [DEFAULT] */
		    stdscan_reset();
                    stdscan_set(value);
                    tokval.t_type = TOKEN_INVALID;
		    if (stdscan(NULL, &tokval) == TOKEN_SPECIAL) {
			switch ((int)tokval.t_integer) {
			case S_REL:
			    globalrel = 1;
			    break;
			case S_ABS:
			    globalrel = 0;
			    break;
			default:
			    err = 1;
			    break;
			}
		    } else {
			err = 1;
		    }
		    break;
		case D_FLOAT:
		    if (float_option(value)) {
			nasm_error(pass1 == 1 ? ERR_NONFATAL : ERR_PANIC,
				     "unknown 'float' directive: %s",
				     value);
		    }
		    break;
                default:
		    if (ofmt->directive(d, value, pass2))
			break;
		    /* else fall through */
		case D_unknown:
		    nasm_error(pass1 == 1 ? ERR_NONFATAL : ERR_PANIC,
			       "unrecognised directive [%s]",
			       directive);
		    break;
                }
		if (err) {
		    nasm_error(ERR_NONFATAL,
				 "invalid parameter to [%s] directive",
				 directive);
		}
            } else {            /* it isn't a directive */
                parse_line(pass1, line, &output_ins, def_label);

                if (optimizing > 0) {
                    if (forwref != NULL && globallineno == forwref->lineno) {
                        output_ins.forw_ref = true;
                        do {
                            output_ins.oprs[forwref->operand].opflags |= OPFLAG_FORWARD;
                            forwref = saa_rstruct(forwrefs);
                        } while (forwref != NULL
                                 && forwref->lineno == globallineno);
                    } else
                        output_ins.forw_ref = false;

		    if (output_ins.forw_ref) {
			if (passn == 1) {
			    for (i = 0; i < output_ins.operands; i++) {
				if (output_ins.oprs[i].opflags & OPFLAG_FORWARD) {
				    struct forwrefinfo *fwinf =
					(struct forwrefinfo *)
					saa_wstruct(forwrefs);
				    fwinf->lineno = globallineno;
                                fwinf->operand = i;
				}
			    }
			}
                    }
                }

                /*  forw_ref */
                if (output_ins.opcode == I_EQU) {
                    if (pass1 == 1) {
                        /*
                         * Special `..' EQUs get processed in pass two,
                         * except `..@' macro-processor EQUs which are done
                         * in the normal place.
                         */
                        if (!output_ins.label)
                            nasm_error(ERR_NONFATAL,
                                         "EQU not preceded by label");

                        else if (output_ins.label[0] != '.' ||
                                 output_ins.label[1] != '.' ||
                                 output_ins.label[2] == '@') {
                            if (output_ins.operands == 1 &&
                                (output_ins.oprs[0].type & IMMEDIATE) &&
                                output_ins.oprs[0].wrt == NO_SEG) {
                                bool isext = !!(output_ins.oprs[0].opflags
						& OPFLAG_EXTERN);
                                def_label(output_ins.label,
                                          output_ins.oprs[0].segment,
                                          output_ins.oprs[0].offset, NULL,
                                          false, isext);
                            } else if (output_ins.operands == 2
                                       && (output_ins.oprs[0].type & IMMEDIATE)
                                       && (output_ins.oprs[0].type & COLON)
                                       && output_ins.oprs[0].segment == NO_SEG
                                       && output_ins.oprs[0].wrt == NO_SEG
                                       && (output_ins.oprs[1].type & IMMEDIATE)
                                       && output_ins.oprs[1].segment == NO_SEG
                                       && output_ins.oprs[1].wrt == NO_SEG) {
                                def_label(output_ins.label,
                                          output_ins.oprs[0].offset | SEG_ABS,
                                          output_ins.oprs[1].offset,
					  NULL, false, false);
                            } else
                                nasm_error(ERR_NONFATAL,
                                             "bad syntax for EQU");
                        }
                    } else {
                        /*
                         * Special `..' EQUs get processed here, except
                         * `..@' macro processor EQUs which are done above.
                         */
                        if (output_ins.label[0] == '.' &&
                            output_ins.label[1] == '.' &&
                            output_ins.label[2] != '@') {
                            if (output_ins.operands == 1 &&
                                (output_ins.oprs[0].type & IMMEDIATE)) {
                                define_label(output_ins.label,
                                             output_ins.oprs[0].segment,
                                             output_ins.oprs[0].offset,
                                             NULL, false, false);
                            } else if (output_ins.operands == 2
                                       && (output_ins.oprs[0].type & IMMEDIATE)
                                       && (output_ins.oprs[0].type & COLON)
                                       && output_ins.oprs[0].segment == NO_SEG
                                       && (output_ins.oprs[1].type & IMMEDIATE)
                                       && output_ins.oprs[1].segment == NO_SEG) {
                                define_label(output_ins.label,
                                             output_ins.oprs[0].offset | SEG_ABS,
                                             output_ins.oprs[1].offset,
                                             NULL, false, false);
                            } else
                                nasm_error(ERR_NONFATAL,
                                             "bad syntax for EQU");
                        }
                    }
                } else {        /* instruction isn't an EQU */

                    if (pass1 == 1) {

                        int64_t l = insn_size(location.segment, offs, sb, cpu,
                                           &output_ins, nasm_error);

                        /* if (using_debug_info)  && output_ins.opcode != -1) */
                        if (using_debug_info)
                        {       /* fbk 03/25/01 */
                            /* this is done here so we can do debug type info */
                            int32_t typeinfo =
                                TYS_ELEMENTS(output_ins.operands);
                            switch (output_ins.opcode) {
                            case I_RESB:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_BYTE;
                                break;
                            case I_RESW:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_WORD;
                                break;
                            case I_RESD:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_DWORD;
                                break;
                            case I_RESQ:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_QWORD;
                                break;
                            case I_REST:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_TBYTE;
                                break;
                            case I_RESO:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_OWORD;
                                break;
                            case I_RESY:
                                typeinfo =
                                    TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_YWORD;
                                break;
                            case I_DB:
                                typeinfo |= TY_BYTE;
                                break;
                            case I_DW:
                                typeinfo |= TY_WORD;
                                break;
                            case I_DD:
                                if (output_ins.eops_float)
                                    typeinfo |= TY_FLOAT;
                                else
                                    typeinfo |= TY_DWORD;
                                break;
                            case I_DQ:
                                typeinfo |= TY_QWORD;
                                break;
                            case I_DT:
                                typeinfo |= TY_TBYTE;
                                break;
			    case I_DO:
				typeinfo |= TY_OWORD;
				break;
			    case I_DY:
				typeinfo |= TY_YWORD;
				break;
                            default:
                                typeinfo = TY_LABEL;

                            }

                            dfmt->debug_typevalue(typeinfo);
                        }
                        if (l != -1) {
                            offs += l;
                            SET_CURR_OFFS(offs);
                        }
                        /*
                         * else l == -1 => invalid instruction, which will be
                         * flagged as an error on pass 2
                         */

                    } else {
                        offs += assemble(location.segment, offs, sb, cpu,
                                         &output_ins, ofmt, nasm_error,
                                         &nasmlist);
                        SET_CURR_OFFS(offs);

                    }
                }               /* not an EQU */
                cleanup_insn(&output_ins);
            }
            nasm_free(line);
            location.offset = offs = GET_CURR_OFFS;
        }                       /* end while (line = preproc->getline... */

        if (pass0 == 2 && global_offset_changed && !terminate_after_phase)
            nasm_error(ERR_NONFATAL,
			 "phase error detected at end of assembly.");

        if (pass1 == 1)
            preproc->cleanup(1);

        if ((passn > 1 && !global_offset_changed) || pass0 == 2) {
            pass0++;
	} else if (global_offset_changed &&
		 global_offset_changed < prev_offset_changed) {
            prev_offset_changed = global_offset_changed;
            stall_count = 0;
	} else {
	    stall_count++;
	}

	if (terminate_after_phase)
	    break;

        if ((stall_count > 997) || (passn >= pass_max)) {
            /* We get here if the labels don't converge
             * Example: FOO equ FOO + 1
             */
             nasm_error(ERR_NONFATAL,
                          "Can't find valid values for all labels "
                          "after %d passes, giving up.", passn);
	     nasm_error(ERR_NONFATAL,
			  "Possible causes: recursive EQUs, macro abuse.");
	     break;
	}
    }

    preproc->cleanup(0);
    nasmlist.cleanup();
    if (!terminate_after_phase && opt_verbose_info) {
	/*  -On and -Ov switches */
        fprintf(stdout, "info: assembly required 1+%d+1 passes\n", passn-3);
    }
}

static enum directives getkw(char **directive, char **value)
{
    char *p, *q, *buf;

    buf = nasm_skip_spaces(*directive);

    /* it should be enclosed in [ ] */
    if (*buf != '[')
        return D_none;
    q = strchr(buf, ']');
    if (!q)
        return D_none;

    /* stip off the comments */
    p = strchr(buf, ';');
    if (p) {
        if (p < q) /* ouch! somwhere inside */
            return D_none;
        *p = '\0';
    }

    /* no brace, no trailing spaces */
    *q = '\0';
    nasm_zap_spaces_rev(--q);

    /* directive */
    p = nasm_skip_spaces(++buf);
    q = nasm_skip_word(p);
    if (!q)
        return D_none; /* sigh... no value there */
    *q = '\0';
    *directive = p;

    /* and value finally */
    p = nasm_skip_spaces(++q);
    *value = p;

    return find_directive(*directive);
}

/**
 * gnu style error reporting
 * This function prints an error message to error_file in the
 * style used by GNU. An example would be:
 * file.asm:50: error: blah blah blah
 * where file.asm is the name of the file, 50 is the line number on
 * which the error occurs (or is detected) and "error:" is one of
 * the possible optional diagnostics -- it can be "error" or "warning"
 * or something else.  Finally the line terminates with the actual
 * error message.
 *
 * @param severity the severity of the warning or error
 * @param fmt the printf style format string
 */
static void nasm_verror_gnu(int severity, const char *fmt, va_list ap)
{
    char *currentfile = NULL;
    int32_t lineno = 0;

    if (is_suppressed_warning(severity))
        return;

    if (!(severity & ERR_NOFILE))
        src_get(&lineno, &currentfile);

    if (currentfile) {
	fprintf(error_file, "%s:%"PRId32": ", currentfile, lineno);
	nasm_free(currentfile);
    } else {
	fputs("nasm: ", error_file);
    }

    nasm_verror_common(severity, fmt, ap);
}

/**
 * MS style error reporting
 * This function prints an error message to error_file in the
 * style used by Visual C and some other Microsoft tools. An example
 * would be:
 * file.asm(50) : error: blah blah blah
 * where file.asm is the name of the file, 50 is the line number on
 * which the error occurs (or is detected) and "error:" is one of
 * the possible optional diagnostics -- it can be "error" or "warning"
 * or something else.  Finally the line terminates with the actual
 * error message.
 *
 * @param severity the severity of the warning or error
 * @param fmt the printf style format string
 */
static void nasm_verror_vc(int severity, const char *fmt, va_list ap)
{
    char *currentfile = NULL;
    int32_t lineno = 0;

    if (is_suppressed_warning(severity))
        return;

    if (!(severity & ERR_NOFILE))
        src_get(&lineno, &currentfile);

    if (currentfile) {
        fprintf(error_file, "%s(%"PRId32") : ", currentfile, lineno);
        nasm_free(currentfile);
    } else {
        fputs("nasm: ", error_file);
    }

    nasm_verror_common(severity, fmt, ap);
}

/**
 * check for supressed warning
 * checks for suppressed warning or pass one only warning and we're
 * not in pass 1
 *
 * @param severity the severity of the warning or error
 * @return true if we should abort error/warning printing
 */
static bool is_suppressed_warning(int severity)
{
    /*
     * See if it's a suppressed warning.
     */
    return (severity & ERR_MASK) == ERR_WARNING &&
	(((severity & ERR_WARN_MASK) != 0 &&
	  !warning_on[(severity & ERR_WARN_MASK) >> ERR_WARN_SHR]) ||
	 /* See if it's a pass-one only warning and we're not in pass one. */
	 ((severity & ERR_PASS1) && pass0 != 1) ||
	 ((severity & ERR_PASS2) && pass0 != 2));
}

/**
 * common error reporting
 * This is the common back end of the error reporting schemes currently
 * implemented.  It prints the nature of the warning and then the
 * specific error message to error_file and may or may not return.  It
 * doesn't return if the error severity is a "panic" or "debug" type.
 *
 * @param severity the severity of the warning or error
 * @param fmt the printf style format string
 */
static void nasm_verror_common(int severity, const char *fmt, va_list args)
{
    char msg[1024];
    const char *pfx;

    switch (severity & (ERR_MASK|ERR_NO_SEVERITY)) {
    case ERR_WARNING:
        pfx = "warning: ";
        break;
    case ERR_NONFATAL:
        pfx = "error: ";
        break;
    case ERR_FATAL:
        pfx = "fatal: ";
        break;
    case ERR_PANIC:
        pfx = "panic: ";
        break;
    case ERR_DEBUG:
        pfx = "debug: ";
        break;
    default:
	pfx = "";
	break;
    }

    vsnprintf(msg, sizeof msg, fmt, args);

    fprintf(error_file, "%s%s\n", pfx, msg);

    if (*listname)
	nasmlist.error(severity, pfx, msg);

    if (severity & ERR_USAGE)
        want_usage = true;

    switch (severity & ERR_MASK) {
    case ERR_DEBUG:
        /* no further action, by definition */
        break;
    case ERR_WARNING:
	if (warning_on[0])	/* Treat warnings as errors */
	    terminate_after_phase = true;
	break;
    case ERR_NONFATAL:
        terminate_after_phase = true;
        break;
    case ERR_FATAL:
        if (ofile) {
            fclose(ofile);
            remove(outname);
	    ofile = NULL;
        }
        if (want_usage)
            usage();
        exit(1);                /* instantly die */
        break;                  /* placate silly compilers */
    case ERR_PANIC:
        fflush(NULL);
        /*	abort();	*//* halt, catch fire, and dump core */
        exit(3);
        break;
    }
}

static void usage(void)
{
    fputs("type `nasm -h' for help\n", error_file);
}

#define BUF_DELTA 512

static FILE *no_pp_fp;
static ListGen *no_pp_list;
static int32_t no_pp_lineinc;

static void no_pp_reset(char *file, int pass, ListGen * listgen,
			StrList **deplist)
{
    src_set_fname(nasm_strdup(file));
    src_set_linnum(0);
    no_pp_lineinc = 1;
    no_pp_fp = fopen(file, "r");
    if (!no_pp_fp)
        nasm_error(ERR_FATAL | ERR_NOFILE,
		   "unable to open input file `%s'", file);
    no_pp_list = listgen;
    (void)pass;                 /* placate compilers */

    if (deplist) {
	StrList *sl = nasm_malloc(strlen(file)+1+sizeof sl->next);
	sl->next = NULL;
	strcpy(sl->str, file);
	*deplist = sl;
    }
}

static char *no_pp_getline(void)
{
    char *buffer, *p, *q;
    int bufsize;

    bufsize = BUF_DELTA;
    buffer = nasm_malloc(BUF_DELTA);
    src_set_linnum(src_get_linnum() + no_pp_lineinc);

    while (1) {                 /* Loop to handle %line */

        p = buffer;
        while (1) {             /* Loop to handle long lines */
            q = fgets(p, bufsize - (p - buffer), no_pp_fp);
            if (!q)
                break;
            p += strlen(p);
            if (p > buffer && p[-1] == '\n')
                break;
            if (p - buffer > bufsize - 10) {
                int offset;
                offset = p - buffer;
                bufsize += BUF_DELTA;
                buffer = nasm_realloc(buffer, bufsize);
                p = buffer + offset;
            }
        }

        if (!q && p == buffer) {
            nasm_free(buffer);
            return NULL;
        }

        /*
         * Play safe: remove CRs, LFs and any spurious ^Zs, if any of
         * them are present at the end of the line.
         */
        buffer[strcspn(buffer, "\r\n\032")] = '\0';

        if (!nasm_strnicmp(buffer, "%line", 5)) {
            int32_t ln;
            int li;
            char *nm = nasm_malloc(strlen(buffer));
            if (sscanf(buffer + 5, "%"PRId32"+%d %s", &ln, &li, nm) == 3) {
                nasm_free(src_set_fname(nm));
                src_set_linnum(ln);
                no_pp_lineinc = li;
                continue;
            }
            nasm_free(nm);
        }
        break;
    }

    no_pp_list->line(LIST_READ, buffer);

    return buffer;
}

static void no_pp_cleanup(int pass)
{
    (void)pass;                     /* placate GCC */
    if (no_pp_fp) {
        fclose(no_pp_fp);
        no_pp_fp = NULL;
    }
}

static uint32_t get_cpu(char *value)
{
    if (!strcmp(value, "8086"))
        return IF_8086;
    if (!strcmp(value, "186"))
        return IF_186;
    if (!strcmp(value, "286"))
        return IF_286;
    if (!strcmp(value, "386"))
        return IF_386;
    if (!strcmp(value, "486"))
        return IF_486;
    if (!strcmp(value, "586") || !nasm_stricmp(value, "pentium"))
        return IF_PENT;
    if (!strcmp(value, "686") ||
        !nasm_stricmp(value, "ppro") ||
        !nasm_stricmp(value, "pentiumpro") || !nasm_stricmp(value, "p2"))
        return IF_P6;
    if (!nasm_stricmp(value, "p3") || !nasm_stricmp(value, "katmai"))
        return IF_KATMAI;
    if (!nasm_stricmp(value, "p4") ||   /* is this right? -- jrc */
        !nasm_stricmp(value, "willamette"))
        return IF_WILLAMETTE;
    if (!nasm_stricmp(value, "prescott"))
        return IF_PRESCOTT;
    if (!nasm_stricmp(value, "x64") ||
        !nasm_stricmp(value, "x86-64"))
        return IF_X86_64;
    if (!nasm_stricmp(value, "ia64") ||
        !nasm_stricmp(value, "ia-64") ||
        !nasm_stricmp(value, "itanium") ||
        !nasm_stricmp(value, "itanic") || !nasm_stricmp(value, "merced"))
        return IF_IA64;

    nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_FATAL,
                 "unknown 'cpu' type");

    return IF_PLEVEL;           /* the maximum level */
}

static int get_bits(char *value)
{
    int i;

    if ((i = atoi(value)) == 16)
        return i;               /* set for a 16-bit segment */
    else if (i == 32) {
        if (cpu < IF_386) {
            nasm_error(ERR_NONFATAL,
                         "cannot specify 32-bit segment on processor below a 386");
            i = 16;
        }
    } else if (i == 64) {
        if (cpu < IF_X86_64) {
            nasm_error(ERR_NONFATAL,
                         "cannot specify 64-bit segment on processor below an x86-64");
            i = 16;
        }
        if (i != maxbits) {
            nasm_error(ERR_NONFATAL,
                         "%s output format does not support 64-bit code",
                         ofmt->shortname);
            i = 16;
        }
    } else {
        nasm_error(pass0 < 2 ? ERR_NONFATAL : ERR_FATAL,
                     "`%s' is not a valid segment size; must be 16, 32 or 64",
                     value);
        i = 16;
    }
    return i;
}
