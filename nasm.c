/* The Netwide Assembler main program module
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "nasm.h"
#include "nasmlib.h"
#include "preproc.h"
#include "parser.h"
#include "assemble.h"
#include "labels.h"
#include "outform.h"

static void report_error (int, char *, ...);
static void parse_cmdline (int, char **);
static void assemble_file (char *);
static int getkw (char *buf, char **value);
static void register_output_formats(void);
static void usage(void);

static char *obuf;
static char inname[FILENAME_MAX];
static char outname[FILENAME_MAX];
static char realout[FILENAME_MAX];
static int lineno;		       /* for error reporting */
static int lineinc;		       /* set by [LINE] or [ONELINE] */
static int globallineno;	       /* for forward-reference tracking */
static int pass;
static struct ofmt *ofmt = NULL;

static FILE *ofile = NULL;
static int sb = 16;		       /* by default */

static long current_seg;
static struct RAA *offsets;
static long abs_offset;

static struct SAA *forwrefs;	       /* keep track of forward references */
static int forwline;

static Preproc *preproc;
static int preprocess_only;

/* used by error function to report location */
static char currentfile[FILENAME_MAX];

/*
 * This is a null preprocessor which just copies lines from input
 * to output. It's used when someone explicitly requests that NASM
 * not preprocess their source file.
 */

static void no_pp_reset (char *, efunc);
static char *no_pp_getline (void);
static void no_pp_cleanup (void);
static Preproc no_pp = {
    no_pp_reset,
    no_pp_getline,
    no_pp_cleanup
};

/*
 * get/set current offset...
 */
#define get_curr_ofs (current_seg==NO_SEG?abs_offset:\
		      raa_read(offsets,current_seg))
#define set_curr_ofs(x) (current_seg==NO_SEG?(void)(abs_offset=(x)):\
			 (void)(offsets=raa_write(offsets,current_seg,(x))))

static int want_usage;
static int terminate_after_phase;

int main(int argc, char **argv) {
    want_usage = terminate_after_phase = FALSE;

    nasm_set_malloc_error (report_error);
    offsets = raa_init();
    forwrefs = saa_init ((long)sizeof(int));

    preproc = &nasmpp;
    preprocess_only = FALSE;

    seg_init();

    register_output_formats();

    parse_cmdline(argc, argv);

    if (terminate_after_phase) {
	if (want_usage)
	    usage();
	return 1;
    }

    if (preprocess_only) {
	char *line;

	if (*outname) {
	    ofile = fopen(outname, "w");
	    if (!ofile)
		report_error (ERR_FATAL | ERR_NOFILE,
			      "unable to open output file `%s'", outname);
	} else
	    ofile = NULL;
	preproc->reset (inname, report_error);
	strcpy(currentfile,inname);
	lineno = 0;
	lineinc = 1;
	while ( (line = preproc->getline()) ) {
	    lineno += lineinc;
	    if (ofile) {
		fputs(line, ofile);
		fputc('\n', ofile);
	    } else
		puts(line);
	    nasm_free (line);
	}
	preproc->cleanup();
	if (ofile)
	    fclose(ofile);
	if (ofile && terminate_after_phase)
	    remove(outname);
    } else {
	if (!*outname) {
	    ofmt->filename (inname, realout, report_error);
	    strcpy(outname, realout);
	}

	ofile = fopen(outname, "wb");
	if (!ofile) {
	    report_error (ERR_FATAL | ERR_NOFILE,
			  "unable to open output file `%s'", outname);
	}
	ofmt->init (ofile, report_error, define_label);
	assemble_file (inname);
	if (!terminate_after_phase) {
	    ofmt->cleanup ();
	    cleanup_labels ();
	}
	fclose (ofile);
	if (terminate_after_phase)
	    remove(outname);
    }

    if (want_usage)
	usage();
    raa_free (offsets);
    saa_free (forwrefs);

    return 0;
}

static void parse_cmdline(int argc, char **argv) {
    char *param;

    *inname = *outname = '\0';
    while (--argc) {
	char *p = *++argv;
	if (p[0]=='-') {
	    switch (p[1]) {
	      case 'o':		       /* these parameters take values */
	      case 'f':
		if (p[2])	       /* the parameter's in the option */
		    param = p+2;
		else if (!argv[1]) {
		    report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
				  "option `-%c' requires an argument",
				  p[1]);
		    break;
		} else
		    --argc, param = *++argv;
		if (p[1]=='o') {       /* output file */
		    strcpy (outname, param);
		} else if (p[1]=='f') { /* output format */
		    ofmt = ofmt_find(param);
		    if (!ofmt) {
			report_error (ERR_FATAL | ERR_NOFILE | ERR_USAGE,
				      "unrecognised output format `%s'",
				      param);
		    }
		}
		break;
	      case 'h':
		fprintf(stderr,
			"usage: nasm [-o outfile] [-f format]"
			" [-a] [-e] filename\n");
		fprintf(stderr,
			"    or nasm -r   for version info\n\n");
		fprintf(stderr,
			"    -e means preprocess only; "
			"-a means don't preprocess\n\n");
		fprintf(stderr,
			"valid output formats for -f are"
			" (`*' denotes default):\n");
		ofmt_list(ofmt);
		exit (0);	       /* never need usage message here */
		break;
	      case 'r':
		fprintf(stderr, "NASM version %s\n", NASM_VER);
		exit (0);	       /* never need usage message here */
		break;
	      case 'e':		       /* preprocess only */
		preprocess_only = TRUE;
		break;
	      case 'a':		       /* assemble only - don't preprocess */
		preproc = &no_pp;
		break;
	      default:
		report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			      "unrecognised option `-%c'",
			      p[1]);
		break;
	    }
	} else {
	    if (*inname) {
		report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			      "more than one input file specified");
	    } else
		strcpy(inname, p);
	}
    }
    if (!*inname)
	report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
		      "no input file specified");
}

static void assemble_file (char *fname) {
    char *value, *p, *line;
    insn output_ins;
    int i, rn_error;
    long seg;

    init_labels ();

    /* pass one */
    pass = 1;
    current_seg = ofmt->section(NULL, pass, &sb);
    preproc->reset(fname, report_error);
    strcpy(currentfile,fname);
    lineno = 0;
    lineinc = 1;
    globallineno = 0;
    while ( (line = preproc->getline()) ) {
	lineno += lineinc;
	globallineno++;

	if (line[0] == '%') {
	    int ln, li;
	    char buf[FILENAME_MAX];

	    /*
	     * This will be a line number directive. They come
	     * straight from the preprocessor, so we'll subject
	     * them to only minimal error checking.
	     */
	    if (strncmp(line, "%line", 5)) {
		if (preproc == &no_pp)
		    report_error (ERR_WARNING, "unknown `%%' directive in "
				  " preprocessed source");
	    } else if (sscanf(line, "%%line %d+%d %s", &ln, &li, buf) != 3) {
		report_error (ERR_WARNING, "bogus line number directive in"
			      " preprocessed source");
	    } else {
		lineno = ln - li;
		lineinc = li;
		strncpy (currentfile, buf, FILENAME_MAX-1);
		currentfile[FILENAME_MAX-1] = '\0';
	    }
	    continue;
	}

	/* here we parse our directives; this is not handled by the 'real'
	 * parser. */
	if ( (i = getkw (line, &value)) ) {
	    switch (i) {
	      case 1:	       /* [SEGMENT n] */
		seg = ofmt->section (value, pass, &sb);
		if (seg == NO_SEG) {
		    report_error (ERR_NONFATAL,
				  "segment name `%s' not recognised",
				  value);
		} else {
		    current_seg = seg;
		}
		break;
	      case 2:	       /* [EXTERN label] */
		if (*value == '$')
		    value++;	       /* skip initial $ if present */
		declare_as_global (value, report_error);
		define_label (value, seg_alloc(), 0L, ofmt, report_error);
		break;
	      case 3:	       /* [BITS bits] */
		switch (atoi(value)) {
		  case 16:
		  case 32:
		    sb = atoi(value);
		    break;
		  default:
		    report_error(ERR_NONFATAL,
				 "`%s' is not a valid argument to [BITS]",
				 value);
		    break;
		}
		break;
	      case 4:	       /* [GLOBAL symbol] */
		if (*value == '$')
		    value++;	       /* skip initial $ if present */
		declare_as_global (value, report_error);
		break;
	      case 5:	       /* [COMMON symbol size] */
		p = value;
		while (*p && !isspace(*p))
		    p++;
		if (*p) {
		    long size;

		    while (*p && isspace(*p))
			*p++ = '\0';
		    size = readnum (p, &rn_error);
		    if (rn_error)
			report_error (ERR_NONFATAL, "invalid size specified"
				      " in COMMON declaration");
		    else
			define_common (value, seg_alloc(), size,
				       ofmt, report_error);
		} else
		    report_error (ERR_NONFATAL, "no size specified in"
				  " COMMON declaration");
		break;
	      case 6:		       /* [ABSOLUTE address] */
		current_seg = NO_SEG;
		abs_offset = readnum(value, &rn_error);
		if (rn_error) {
		    report_error (ERR_NONFATAL, "invalid address specified"
				  " for ABSOLUTE directive");
		    abs_offset = 0x100;/* don't go near zero in case of / */
		}
		break;
	      default:
		if (!ofmt->directive (line+1, value, 1))
		    report_error (ERR_NONFATAL, "unrecognised directive [%s]",
				  line+1);
		break;
	    }
	} else {
	    long offs = get_curr_ofs;
	    parse_line (current_seg, offs, lookup_label,
			1, line, &output_ins, ofmt, report_error);
	    if (output_ins.forw_ref)
		*(int *)saa_wstruct(forwrefs) = globallineno;

	    /*
	     * Hack to prevent phase error in the code
	     *   rol ax,x
	     *   x equ 1
	     *
	     * We rule that the presence of a forward reference
	     * cancels out the UNITY property of the number 1. This
	     * isn't _strictly_ necessary in pass one, since the
	     * problem occurs in pass two, but for the sake of
	     * having the passes as near to identical as we can
	     * manage, we do it like this.
	     */
	    if (output_ins.forw_ref) {
		int i;
		for (i=0; i<output_ins.operands; i++)
		    output_ins.oprs[i].type &= ~ONENESS;
	    }

	    if (output_ins.opcode == I_EQU) {
		/*
		 * Special `..' EQUs get processed in pass two.
		 */
		if (!output_ins.label)
		    report_error (ERR_NONFATAL,
				  "EQU not preceded by label");
		else if (output_ins.label[0] != '.' ||
			 output_ins.label[1] != '.') {
		    if (output_ins.operands == 1 &&
			(output_ins.oprs[0].type & IMMEDIATE)) {
			define_label (output_ins.label,
				      output_ins.oprs[0].segment,
				      output_ins.oprs[0].offset,
				      ofmt, report_error);
		    } else if (output_ins.operands == 2 &&
			       (output_ins.oprs[0].type & IMMEDIATE) &&
			       (output_ins.oprs[0].type & COLON) &&
			       output_ins.oprs[0].segment == NO_SEG &&
			       (output_ins.oprs[1].type & IMMEDIATE) &&
			       output_ins.oprs[1].segment == NO_SEG) {
			define_label (output_ins.label,
				      output_ins.oprs[0].offset | SEG_ABS,
				      output_ins.oprs[1].offset,
				      ofmt, report_error);
		    } else
			report_error(ERR_NONFATAL, "bad syntax for EQU");
		}
	    } else {
		if (output_ins.label)
		    define_label (output_ins.label,
				  current_seg, offs,
				  ofmt, report_error);
		offs += insn_size (current_seg, offs, sb,
				   &output_ins, report_error);
		set_curr_ofs (offs);
	    }
	    cleanup_insn (&output_ins);
	}
	nasm_free (line);
    }
    preproc->cleanup();

    if (terminate_after_phase) {
	fclose(ofile);
	remove(outname);
	if (want_usage)
	    usage();
	exit (1);
    }

    /* pass two */
    pass = 2;
    saa_rewind (forwrefs);
    {
	int *p = saa_rstruct (forwrefs);
	if (p)
	    forwline = *p;
	else
	    forwline = -1;
    }
    current_seg = ofmt->section(NULL, pass, &sb);
    raa_free (offsets);
    offsets = raa_init();
    preproc->reset(fname, report_error);
    strcpy(currentfile,fname);
    lineno = 0;
    lineinc = 1;
    globallineno = 0;
    while ( (line = preproc->getline()) ) {
	lineno += lineinc;
	globallineno++;

	if (line[0] == '%') {
	    int ln, li;
	    char buf[FILENAME_MAX];

	    /*
	     * This will be a line number directive. They come
	     * straight from the preprocessor, so we'll subject
	     * them to only minimal error checking.
	     */
	    if (!strncmp(line, "%line", 5) &&
		sscanf(line, "%%line %d+%d %s", &ln, &li, buf) == 3) {
		lineno = ln - li;
		lineinc = li;
		strncpy (currentfile, buf, FILENAME_MAX-1);
		currentfile[FILENAME_MAX-1] = '\0';
	    }
	    continue;
	}

	/* here we parse our directives; this is not handled by
	 * the 'real' parser. */

	if ( (i = getkw (line, &value)) ) {
	    switch (i) {
	      case 1:	       /* [SEGMENT n] */
		seg = ofmt->section (value, pass, &sb);
		if (seg == NO_SEG) {
		    report_error (ERR_PANIC,
				  "invalid segment name on pass two");
		} else
		    current_seg = seg;
		break;
	      case 2:	       /* [EXTERN label] */
		break;
	      case 3:	       /* [BITS bits] */
		switch (atoi(value)) {
		  case 16:
		  case 32:
		    sb = atoi(value);
		    break;
		  default:
		    report_error(ERR_PANIC,
				 "invalid [BITS] value on pass two",
				 value);
		    break;
		}
		break;
	      case 4:		       /* [GLOBAL symbol] */
		break;
	      case 5:		       /* [COMMON symbol size] */
		break;
	      case 6:		       /* [ABSOLUTE addr] */
		current_seg = NO_SEG;
		abs_offset = readnum(value, &rn_error);
		if (rn_error)
		    report_error (ERR_PANIC, "invalid ABSOLUTE address "
				  "in pass two");
		break;
	      default:
		if (!ofmt->directive (line+1, value, 2))
		    report_error (ERR_PANIC, "invalid directive on pass two");
		break;
	    }
	} else {
	    long offs = get_curr_ofs;
	    parse_line (current_seg, offs, lookup_label, 2,
			line, &output_ins, ofmt, report_error);
	    if (globallineno == forwline) {
		int *p = saa_rstruct (forwrefs);
		if (p)
		    forwline = *p;
		else
		    forwline = -1;
		output_ins.forw_ref = TRUE;
	    } else
		output_ins.forw_ref = FALSE;

	    /*
	     * Hack to prevent phase error in the code
	     *   rol ax,x
	     *   x equ 1
	     */
	    if (output_ins.forw_ref) {
		int i;
		for (i=0; i<output_ins.operands; i++)
		    output_ins.oprs[i].type &= ~ONENESS;
	    }

	    obuf = line;
	    if (output_ins.label)
		define_label_stub (output_ins.label, report_error);
	    if (output_ins.opcode == I_EQU) {
		/*
		 * Special `..' EQUs get processed here.
		 */
		if (output_ins.label[0] == '.' &&
		    output_ins.label[1] == '.') {
		    if (output_ins.operands == 1 &&
			(output_ins.oprs[0].type & IMMEDIATE)) {
			define_label (output_ins.label,
				      output_ins.oprs[0].segment,
				      output_ins.oprs[0].offset,
				      ofmt, report_error);
		    } else if (output_ins.operands == 2 &&
			       (output_ins.oprs[0].type & IMMEDIATE) &&
			       (output_ins.oprs[0].type & COLON) &&
			       output_ins.oprs[0].segment == NO_SEG &&
			       (output_ins.oprs[1].type & IMMEDIATE) &&
			       output_ins.oprs[1].segment == NO_SEG) {
			define_label (output_ins.label,
				      output_ins.oprs[0].offset | SEG_ABS,
				      output_ins.oprs[1].offset,
				      ofmt, report_error);
		    } else
			report_error(ERR_NONFATAL, "bad syntax for EQU");
		}
	    }
	    offs += assemble (current_seg, offs, sb,
			      &output_ins, ofmt, report_error);
	    cleanup_insn (&output_ins);
	    set_curr_ofs (offs);
	}
	nasm_free (line);
    }
    preproc->cleanup();
}

static int getkw (char *buf, char **value) {
    char *p, *q;

    if (*buf!='[')
    	return 0;
    p = buf;
    while (*p && *p != ']') p++;
    if (!*p)
	return 0;
    q = p++;
    while (*p && *p != ';') {
	if (!isspace(*p))
	    return 0;
	p++;
    }
    q[1] = '\0';

    p = buf+1;
    while (*buf && *buf!=' ' && *buf!=']' && *buf!='\t')
    	buf++;
    if (*buf==']') {
	*buf = '\0';
	*value = buf;
    } else {
	*buf++ = '\0';
	*value = buf;
	while (*buf!=']') buf++;
	*buf++ = '\0';
    }
    for (q=p; *q; q++)
	*q = tolower(*q);
    if (!strcmp(p, "segment") || !strcmp(p, "section"))
    	return 1;
    if (!strcmp(p, "extern"))
    	return 2;
    if (!strcmp(p, "bits"))
    	return 3;
    if (!strcmp(p, "global"))
    	return 4;
    if (!strcmp(p, "common"))
    	return 5;
    if (!strcmp(p, "absolute"))
    	return 6;
    return -1;
}

static void report_error (int severity, char *fmt, ...) {
    va_list ap;

    if (severity & ERR_NOFILE)
	fputs ("nasm: ", stderr);
    else
	fprintf (stderr, "%s:%d: ", currentfile,
		 lineno + (severity & ERR_OFFBY1 ? lineinc : 0));

    if ( (severity & ERR_MASK) == ERR_WARNING)
	fputs ("warning: ", stderr);
    else if ( (severity & ERR_MASK) == ERR_PANIC)
	fputs ("panic: ", stderr);

    va_start (ap, fmt);
    vfprintf (stderr, fmt, ap);
    fputc ('\n', stderr);

    if (severity & ERR_USAGE)
	want_usage = TRUE;

    switch (severity & ERR_MASK) {
      case ERR_WARNING:
	/* no further action, by definition */
	break;
      case ERR_NONFATAL:
	terminate_after_phase = TRUE;
	break;
      case ERR_FATAL:
	if (ofile) {
	    fclose(ofile);
	    remove(outname);
	}
	if (want_usage)
	    usage();
	exit(1);		       /* instantly die */
	break;			       /* placate silly compilers */
      case ERR_PANIC:
	abort();		       /* halt, catch fire, and dump core */
	break;
    }
}

static void usage(void) {
    fputs("type `nasm -h' for help\n", stderr);
}

static void register_output_formats(void) {
    /* Flat-form binary format */
#ifdef OF_BIN
    extern struct ofmt of_bin;
#endif
    /* Unix formats: a.out, COFF, ELF */
#ifdef OF_AOUT
    extern struct ofmt of_aout;
#endif
#ifdef OF_COFF
    extern struct ofmt of_coff;
#endif
#ifdef OF_ELF
    extern struct ofmt of_elf;
#endif
    /* Linux strange format: as86 */
#ifdef OF_AS86
    extern struct ofmt of_as86;
#endif
    /* DOS formats: OBJ, Win32 */
#ifdef OF_OBJ
    extern struct ofmt of_obj;
#endif
#ifdef OF_WIN32
    extern struct ofmt of_win32;
#endif
#ifdef OF_RDF
    extern struct ofmt of_rdf;
#endif
#ifdef OF_DBG     /* debug format must be included specifically */
    extern struct ofmt of_dbg;
#endif

#ifdef OF_BIN
    ofmt_register (&of_bin);
#endif
#ifdef OF_AOUT
    ofmt_register (&of_aout);
#endif
#ifdef OF_COFF
    ofmt_register (&of_coff);
#endif
#ifdef OF_ELF
    ofmt_register (&of_elf);
#endif
#ifdef OF_AS86
    ofmt_register (&of_as86);
#endif
#ifdef OF_OBJ
    ofmt_register (&of_obj);
#endif
#ifdef OF_WIN32
    ofmt_register (&of_win32);
#endif
#ifdef OF_RDF
    ofmt_register (&of_rdf);
#endif
#ifdef OF_DBG
    ofmt_register (&of_dbg);
#endif
    /*
     * set the default format
     */
    ofmt = &OF_DEFAULT;
}

#define BUF_DELTA 512

static FILE *no_pp_fp;
static efunc no_pp_err;

static void no_pp_reset (char *file, efunc error) {
    no_pp_err = error;
    no_pp_fp = fopen(file, "r");
    if (!no_pp_fp)
	no_pp_err (ERR_FATAL | ERR_NOFILE,
		   "unable to open input file `%s'", file);
}

static char *no_pp_getline (void) {
    char *buffer, *p, *q;
    int bufsize;

    bufsize = BUF_DELTA;
    buffer = nasm_malloc(BUF_DELTA);
    p = buffer;
    while (1) {
	q = fgets(p, bufsize-(p-buffer), no_pp_fp);
	if (!q)
	    break;
	p += strlen(p);
	if (p > buffer && p[-1] == '\n')
	    break;
	if (p-buffer > bufsize-10) {
	    bufsize += BUF_DELTA;
	    buffer = nasm_realloc(buffer, bufsize);
	}
    }

    if (!q && p == buffer) {
	nasm_free (buffer);
	return NULL;
    }

    /*
     * Play safe: remove CRs as well as LFs, if any of either are
     * present at the end of the line.
     */
    while (p > buffer && (p[-1] == '\n' || p[-1] == '\r'))
	*--p = '\0';

    /*
     * Handle spurious ^Z, which may be inserted into source files
     * by some file transfer utilities.
     */
    buffer[strcspn(buffer, "\032")] = '\0';

    return buffer;
}

static void no_pp_cleanup (void) {
    fclose(no_pp_fp);
}
