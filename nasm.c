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
static int pass;
static struct ofmt *ofmt = NULL;

static FILE *ofile = NULL;
static int sb = 16;		       /* by default */

static long current_seg;
static struct RAA *offsets;
static long abs_offset;
#define OFFSET_DELTA 256

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

    seg_init();

    register_output_formats();

    parse_cmdline(argc, argv);

    if (terminate_after_phase) {
	if (want_usage)
	    usage();
	return 1;
    }

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

    if (want_usage)
	usage();

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
			"usage: nasm [-o outfile] [-f format] filename\n");
		fprintf(stderr,
			"    or nasm -r   for version info\n\n");
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

/* used by error function to report location */
static char currentfile[FILENAME_MAX];

static void assemble_file (char *fname) {
    FILE *fp = fopen (fname, "r");
    FILE *oldfile = NULL;     /* jrh - used when processing include files */
    int oldfileline = 0;
    char *value, *p, buffer[1024+2];   /* maximum line length defined here */
    insn output_ins;
    int i, seg, rn_error;

    if (!fp) {			       /* couldn't open file */
	report_error (ERR_FATAL | ERR_NOFILE,
		      "unable to open input file `%s'", fname);
	return;
    }

    init_labels ();
    strcpy(currentfile,fname);

    /* pass one */
    pass = 1;
    current_seg = ofmt->section(NULL, pass, &sb);
    lineno = 0;
    while (1) {
        if (! fgets(buffer, sizeof(buffer), fp)) {   /* EOF on current file */
	    if (oldfile) {
		fclose(fp);
		fp = oldfile;
		lineno = oldfileline;
		strcpy(currentfile,fname);
		oldfile = NULL;
		continue;
	    }
	    else
		break;
	}
	lineno++;
	if (buffer[strlen(buffer)-1] == '\n') {
	    buffer[strlen(buffer)-1] = '\0';
	} else {
	    /*
	     * We have a line that's too long. Throw an error, read
	     * to EOL, and ignore the line for assembly purposes.
	     */
	    report_error (ERR_NONFATAL, "line is longer than %d characters",
			  sizeof(buffer)-2);
	    while (fgets(buffer, sizeof(buffer), fp) &&
		   buffer[strlen(buffer)-1] != '\n');
	    continue;		       /* read another line */
	}

	/* here we parse our directives; this is not handled by the 'real'
	 * parser. */

	if ( (i = getkw (buffer, &value)) ) {
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
	      case 4:		/* [INC file] */
		oldfile = fp;
		oldfileline = lineno;
		lineno = 0;
		strcpy(currentfile,value);
		fp = fopen(value,"r");
		if (!fp)  {
		    lineno = oldfileline;
		    fp = oldfile;
		    strcpy(currentfile,fname);
		    report_error (ERR_FATAL,
				  "unable to open include file `%s'\n",
				  value);
		}
		break;
	      case 5:	       /* [GLOBAL symbol] */
		if (*value == '$')
		    value++;	       /* skip initial $ if present */
		declare_as_global (value, report_error);
		break;
	      case 6:	       /* [COMMON symbol size] */
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
	      case 7:		       /* [ABSOLUTE address] */
		current_seg = NO_SEG;
		abs_offset = readnum(value, &rn_error);
		if (rn_error) {
		    report_error (ERR_NONFATAL, "invalid address specified"
				  " for ABSOLUTE directive");
		    abs_offset = 0x100;/* don't go near zero in case of / */
		}
		break;
	      default:
		if (!ofmt->directive (buffer+1, value, 1))
		    report_error (ERR_NONFATAL, "unrecognised directive [%s]",
				  buffer+1);
		break;
	    }
	} else {
	    long offs = get_curr_ofs;
	    parse_line (current_seg, offs, lookup_label,
			1, buffer, &output_ins, ofmt, report_error);
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
    }

    if (terminate_after_phase) {
	fclose(ofile);
	remove(outname);
	if (want_usage)
	    usage();
	exit (1);
    }

    /* pass two */
    pass = 2;
    rewind (fp);
    current_seg = ofmt->section(NULL, pass, &sb);
    raa_free (offsets);
    offsets = raa_init();
    lineno = 0;
    while (1) {
        if (!fgets(buffer, sizeof(buffer), fp)) {
	    if (oldfile) {
		fclose(fp);
		fp = oldfile;
		lineno = oldfileline;
		strcpy(currentfile,fname);
		oldfile = NULL;
		continue;
	    } else
		break;
        }
	lineno++;
	if (buffer[strlen(buffer)-1] == '\n')
	    buffer[strlen(buffer)-1] = '\0';
	else
	    report_error (ERR_PANIC,
			  "too-long line got through from pass one");

	/* here we parse our directives; this is not handled by
	 * the 'real' parser. */

	if ( (i = getkw (buffer, &value)) ) {
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
	      case 4:
		oldfile = fp;
		oldfileline = lineno;
		lineno = 0;
		strcpy(currentfile,value);
		fp = fopen(value,"r");
		if (!fp) {
		    lineno = oldfileline;
		    fp = oldfile;
		    strcpy(currentfile,fname);
		    /*
		     * We don't report this error in the PANIC
		     * class, even though we might expect to have
		     * already picked it up during pass one,
		     * because of the tiny chance that some other
		     * process may have removed the include file
		     * between the passes.
		     */
		    report_error (ERR_FATAL,
				  "unable to open include file `%s'\n",
				  value);
		}
		break;
	      case 5:		       /* [GLOBAL symbol] */
		break;
	      case 6:		       /* [COMMON symbol size] */
		break;
	      case 7:		       /* [ABSOLUTE addr] */
		current_seg = NO_SEG;
		abs_offset = readnum(value, &rn_error);
		if (rn_error)
		    report_error (ERR_PANIC, "invalid ABSOLUTE address "
				  "in pass two");
		break;
	      default:
		if (!ofmt->directive (buffer+1, value, 2))
		    report_error (ERR_PANIC, "invalid directive on pass two");
		break;
	    }
	} else {
	    long offs = get_curr_ofs;
	    parse_line (current_seg, offs, lookup_label, 2,
			buffer, &output_ins, ofmt, report_error);
	    obuf = buffer;
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
    }
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
    if (!strcmp(p, "inc") || !strcmp(p, "include"))
        return 4;
    if (!strcmp(p, "global"))
    	return 5;
    if (!strcmp(p, "common"))
    	return 6;
    if (!strcmp(p, "absolute"))
    	return 7;
    return -1;
}

static void report_error (int severity, char *fmt, ...) {
    va_list ap;

    if (severity & ERR_NOFILE)
	fputs ("nasm: ", stderr);
    else
	fprintf (stderr, "%s:%d: ", currentfile, lineno);

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
	fclose(ofile);
	remove(outname);
	if (want_usage)
	    usage();
	exit(1);		       /* instantly die */
	break;			       /* placate silly compilers */
      case ERR_PANIC:
	abort();		       /* panic and dump core */
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
