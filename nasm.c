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
#include "eval.h"
#include "assemble.h"
#include "labels.h"
#include "outform.h"
#include "listing.h"

struct forwrefinfo {		       /* info held on forward refs. */
    int lineno;
    int operand;
};

static void report_error (int, char *, ...);
static void parse_cmdline (int, char **);
static void assemble_file (char *);
static int getkw (char *buf, char **value);
static void register_output_formats(void);
static void usage(void);

static int using_debug_info;

static char inname[FILENAME_MAX];
static char outname[FILENAME_MAX];
static char listname[FILENAME_MAX];
static int globallineno;	       /* for forward-reference tracking */
static int pass;
static struct ofmt *ofmt = NULL;

static FILE *error_file;	       /* Where to write error messages */

static FILE *ofile = NULL;
static int sb = 16;		       /* by default */

static loc_t location;
int          in_abs_seg;	       /* Flag we are in ABSOLUTE seg */
static long  abs_seg;

static struct RAA *offsets;
static long abs_offset;

static struct SAA *forwrefs;	       /* keep track of forward references */
static struct forwrefinfo *forwref;

static Preproc *preproc;
enum op_type {
  op_normal,			/* Preprocess and assemble */
  op_preprocess,		/* Preprocess only */
  op_depend			/* Generate dependencies */
};
static enum op_type operating_mode;

/* used by error function to report location */

/*
 * Which of the suppressible warnings are suppressed. Entry zero
 * doesn't do anything. Initial defaults are given here.
 */
static char suppressed[1+ERR_WARN_MAX] = {
    0, TRUE, TRUE, FALSE
};

/*
 * The option names for the suppressible warnings. As before, entry
 * zero does nothing.
 */
static char *suppressed_names[1+ERR_WARN_MAX] = {
    NULL, "macro-params", "orphan-labels", "number-overflow"
};

/*
 * The explanations for the suppressible warnings. As before, entry
 * zero does nothing.
 */
static char *suppressed_what[1+ERR_WARN_MAX] = {
    NULL, "macro calls with wrong no. of params",
    "labels alone on lines without trailing `:'",
    "numeric constants greater than 0xFFFFFFFF"
};

/*
 * This is a null preprocessor which just copies lines from input
 * to output. It's used when someone explicitly requests that NASM
 * not preprocess their source file.
 */

static void no_pp_reset (char *, int, efunc, evalfunc, ListGen *);
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
#define get_curr_ofs (in_abs_seg?abs_offset:\
		      raa_read(offsets,location.segment))
#define set_curr_ofs(x) (in_abs_seg?(void)(abs_offset=(x)):\
			 (void)(offsets=raa_write(offsets,location.segment,(x))))

static int want_usage;
static int terminate_after_phase;

static void nasm_fputs(char *line, FILE *ofile) 
{
    if (ofile) {
	fputs(line, ofile);
	fputc('\n', ofile);
    } else
	puts(line);
}

int main(int argc, char **argv) 
{
    want_usage = terminate_after_phase = FALSE;

    nasm_set_malloc_error (report_error);
    offsets = raa_init();
    forwrefs = saa_init ((long)sizeof(struct forwrefinfo));

    preproc = &nasmpp;
    operating_mode = op_normal;
    
    error_file = stderr;

    seg_init();

    register_output_formats();

    parse_cmdline(argc, argv);

    if (terminate_after_phase) 
    {
	if (want_usage)
	    usage();
	return 1;
    }

    if (ofmt->stdmac)
	pp_extra_stdmac (ofmt->stdmac);
    parser_global_info (ofmt, &location);
    eval_global_info (ofmt, lookup_label, &location);

    switch ( operating_mode ) {
    case op_depend:
      {
	char *line;
	preproc->reset (inname, 0, report_error, evaluate, &nasmlist);
	if (outname[0] == '\0')
	  ofmt->filename (inname, outname, report_error);
	ofile = NULL;
	printf("%s: %s", outname, inname);
	while ( (line = preproc->getline()) )
	  nasm_free (line);
	preproc->cleanup();
	putc('\n', stdout);
      }
    break;

    case op_preprocess:
    {
      char *line;
      char *file_name = NULL;
      long  prior_linnum=0;
      int   lineinc=0;
      
      if (*outname) {
	ofile = fopen(outname, "w");
	if (!ofile)
	  report_error (ERR_FATAL | ERR_NOFILE,
			"unable to open output file `%s'", outname);
      } else
	ofile = NULL;
      
      location.known = FALSE;
      
      preproc->reset (inname, 2, report_error, evaluate, &nasmlist);
      while ( (line = preproc->getline()) ) {
	/*
	 * We generate %line directives if needed for later programs
	 */
	long linnum = prior_linnum += lineinc;
	int  altline = src_get(&linnum, &file_name);
	if (altline) {
	  if (altline==1 && lineinc==1)
	    nasm_fputs("", ofile);
	  else {
	    lineinc = (altline != -1 || lineinc!=1);
	    fprintf(ofile ? ofile : stdout, "%%line %ld+%d %s\n",
		    linnum, lineinc, file_name);
	  }
	  prior_linnum = linnum;
	}
	nasm_fputs(line, ofile);
	nasm_free (line);
      }
      nasm_free(file_name);
      preproc->cleanup();
      if (ofile)
	fclose(ofile);
      if (ofile && terminate_after_phase)
	remove(outname);
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
	ofmt->filename (inname, outname, report_error);
	
	ofile = fopen(outname, "wb");
	if (!ofile) {
	  report_error (ERR_FATAL | ERR_NOFILE,
			"unable to open output file `%s'", outname);
	}
	
	/*
	 * We must call init_labels() before ofmt->init() since
	 * some object formats will want to define labels in their
	 * init routines. (eg OS/2 defines the FLAT group)
	 */
	init_labels ();
	
	ofmt->init (ofile, report_error, define_label, evaluate);
	
	assemble_file (inname);
	
	if (!terminate_after_phase) {
	  ofmt->cleanup (using_debug_info);
	  cleanup_labels ();
	}
	else {
	  
	  /*
	   * We had an fclose on the output file here, but we
	   * actually do that in all the object file drivers as well,
	   * so we're leaving out the one here.
	   *     fclose (ofile);
	   */
	  
	  remove(outname);
	  if (listname[0])
	    remove(listname);
	}
      }
    break;
    }
    
    if (want_usage)
      usage();
    
    raa_free (offsets);
    saa_free (forwrefs);
    eval_cleanup ();
    nasmlib_cleanup ();

    if (terminate_after_phase)
	return 1;
    else
	return 0;
}


/*
 * Get a parameter for a command line option.
 * First arg must be in the form of e.g. -f...
 */
static char *get_param (char *p, char *q, int *advance)
{
    *advance = 0;
    if (p[2])  		       /* the parameter's in the option */
    {
	p += 2;
	while (isspace(*p))
	    p++;
	return p;
    }
    if (q && q[0])
    {
	*advance = 1;
	return q;
    }
    report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
		  "option `-%c' requires an argument",
		  p[1]);
    return NULL;
}

int stopoptions = 0;
static int process_arg (char *p, char *q)
{
    char *param;
    int  i, advance = 0;

    if (!p || !p[0])
	return 0;

    if (p[0]=='-' && ! stopoptions) 
    {
	switch (p[1]) {
  	  case '-':			/* -- => stop processing options */
	      stopoptions = 1;
	      break;
	  case 's':
	      error_file = stdout;
	      break;
	  case 'o':		       /* these parameters take values */
	  case 'f':
	  case 'p':
	  case 'd':
	  case 'D':
	  case 'i':
	  case 'l':
	  case 'E':
	  case 'F':
	    if ( !(param = get_param (p, q, &advance)) )
		break;
	    if (p[1]=='o') {	       /* output file */
		strcpy (outname, param);
	    } else if (p[1]=='f') {    /* output format */
		ofmt = ofmt_find(param);
		if (!ofmt) {
		    report_error (ERR_FATAL | ERR_NOFILE | ERR_USAGE,
				  "unrecognised output format `%s' - "
				  "use -hf for a list",
				  param);
		}
		else
		    ofmt->current_dfmt = ofmt->debug_formats[0];
	    } else if (p[1]=='P' || p[1]=='p') {    /* pre-include */
		pp_pre_include (param);
	    } else if (p[1]=='D' || p[1]=='d') {    /* pre-define */
		pp_pre_define (param);
	    } else if (p[1]=='U' || p[1]=='u') {    /* un-define */
		pp_pre_undefine (param);
	    } else if (p[1]=='I' || p[1]=='i') {    /* include search path */
		pp_include_path (param);
	    } else if (p[1]=='l') {    /* listing file */
		strcpy (listname, param);
	    } else if (p[1]=='E') {    /* error messages file */
	        error_file = fopen(param, "wt");
		if ( !error_file ) {
		  error_file = stderr; /* Revert to default! */
		  report_error (ERR_FATAL | ERR_NOFILE | ERR_USAGE,
				"cannot open file `%s' for error messages",
				param);
		}
	    } else if (p[1] == 'F') {  /* specify debug format */
	        ofmt->current_dfmt = dfmt_find(ofmt, param);
	        if (!ofmt->current_dfmt) {
	            report_error (ERR_FATAL | ERR_NOFILE | ERR_USAGE,
	    	    		  "unrecognized debug format `%s' for"
			    	  " output format `%s'",
				  param, ofmt->shortname);
                }
            }
	    break;
	  case 'g':
	    using_debug_info = TRUE;
	    break;
	  case 'h':
	    printf("usage: nasm [-@ response file] [-o outfile] [-f format] "
		   "[-l listfile]\n"
		   "            [options...] [--] filename\n"
		   "    or nasm -r   for version info\n\n"
		   "    -e          preprocess only (writes output to stdout by default)\n"
		   "    -a          don't preprocess (assemble only)\n"
		   "    -M          generate Makefile dependencies on stdout\n\n"
		   "    -E<file>    redirect error messages to file\n"
		   "    -s          redirect error messages to stdout\n\n"
		   "    -g          enable debug info\n"
		   "    -F format   select a debugging format\n\n"
		   "    -I<path>    adds a pathname to the include file path\n"
		   "    -P<file>    pre-includes a file\n"
		   "    -D<macro>[=<value>] pre-defines a macro\n"
		   "    -U<macro>   undefines a macro\n"
		   "    -w+foo      enables warnings about foo; -w-foo disables them\n"
		   "where foo can be:\n");
	    for (i=1; i<=ERR_WARN_MAX; i++)
		printf("    %-16s%s (default %s)\n",
		       suppressed_names[i], suppressed_what[i],
		       suppressed[i] ? "off" : "on");
	    printf ("\nresponse files should contain command line parameters"
		    ", one per line.\n");
	    if (p[2] == 'f') {
		printf("\nvalid output formats for -f are"
		       " (`*' denotes default):\n");
		ofmt_list(ofmt, stdout);
	    }
	    else {
		printf ("\nFor a list of valid output formats, use -hf.\n");
		printf ("For a list of debug formats, use -f <form> -y.\n");
	    }
	    exit (0);		       /* never need usage message here */
	    break;
          case 'y':
	    printf("\nvalid debug formats for '%s' output format are"
		   " ('*' denotes default):\n",
		ofmt->shortname);
	    dfmt_list(ofmt, stdout);
	    exit(0);
	    break;
	  case 'r':
	    printf("NASM version %s\n", NASM_VER);
#ifdef DEBUG
	    printf("Compiled with -DDEBUG on " __DATE__ "\n");
#endif
	    exit (0);		       /* never need usage message here */
	    break;
	  case 'e':		       /* preprocess only */
	    operating_mode = op_preprocess;
	    break;
	  case 'a':		       /* assemble only - don't preprocess */
	    preproc = &no_pp;
	    break;
	  case 'w':
	    if (p[2] != '+' && p[2] != '-') {
		report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			      "invalid option to `-w'");
	    } else {
		for (i=1; i<=ERR_WARN_MAX; i++)
		    if (!nasm_stricmp(p+3, suppressed_names[i]))
			break;
		if (i <= ERR_WARN_MAX)
		    suppressed[i] = (p[2] == '-');
		else
		    report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
				  "invalid option to `-w'");
	    }
	    break;
          case 'M':
	    operating_mode = op_depend;
	    break; 
	  default:
	    if (!ofmt->setinfo(GI_SWITCH,&p))
	    	report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			  "unrecognised option `-%c'",
			  p[1]);
	    break;
	}
    } 
    else 
    {
	if (*inname) {
	    report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			  "more than one input file specified");
	} else
	    strcpy(inname, p);
    }

    return advance;
}

#define ARG_BUF_DELTA 128

static void process_respfile (FILE *rfile)
{
    char *buffer, *p, *q, *prevarg;
    int bufsize, prevargsize;

    bufsize = prevargsize = ARG_BUF_DELTA;
    buffer = nasm_malloc(ARG_BUF_DELTA);
    prevarg = nasm_malloc(ARG_BUF_DELTA);
    prevarg[0] = '\0';

    while (1) {   /* Loop to handle all lines in file */

	p = buffer;
	while (1) {  /* Loop to handle long lines */
	    q = fgets(p, bufsize-(p-buffer), rfile);
	    if (!q)
		break;
	    p += strlen(p);
	    if (p > buffer && p[-1] == '\n')
		break;
	    if (p-buffer > bufsize-10) {
		int offset;
		offset = p - buffer;
		bufsize += ARG_BUF_DELTA;
		buffer = nasm_realloc(buffer, bufsize);
		p = buffer + offset;
	    }
	}

	if (!q && p == buffer) {
	    if (prevarg[0])
		process_arg (prevarg, NULL);
	    nasm_free (buffer);
	    nasm_free (prevarg);
	    return;
	}

	/*
	 * Play safe: remove CRs, LFs and any spurious ^Zs, if any of
	 * them are present at the end of the line.
	 */
	*(p = &buffer[strcspn(buffer, "\r\n\032")]) = '\0';

	while (p > buffer && isspace(p[-1]))
	    *--p = '\0';

	p = buffer;
	while (isspace(*p))
	    p++;

	if (process_arg (prevarg, p))
	    *p = '\0';

	if (strlen(p) > prevargsize-10) {
	    prevargsize += ARG_BUF_DELTA;
	    prevarg = nasm_realloc(prevarg, prevargsize);
	}
	strcpy (prevarg, p);
    }
}

static void parse_cmdline(int argc, char **argv)
{
    FILE *rfile;
    char *envreal, *envcopy=NULL, *p, *q, *arg, *prevarg;
    char separator = ' ';

    *inname = *outname = *listname = '\0';

    /*
     * First, process the NASM environment variable.
     */
    envreal = getenv("NASM");
    arg = NULL;
    if (envreal) {
	envcopy = nasm_strdup(envreal);
	p = envcopy;
	if (*p && *p != '-')
	    separator = *p++;
	while (*p) {
	    q = p;
	    while (*p && *p != separator) p++;
	    while (*p == separator) *p++ = '\0';
	    prevarg = arg;
	    arg = q;
	    if (process_arg (prevarg, arg))
		arg = NULL;
	}
	if (arg)
	    process_arg (arg, NULL);
	nasm_free (envcopy);
    }

    /*
     * Now process the actual command line.
     */
    while (--argc)
    {
	int i;
	argv++;
	if (!stopoptions && argv[0][0] == '-' && argv[0][1] == '@') {
	    if ((p = get_param (argv[0], argc > 1 ? argv[1] : NULL, &i)))
		if ((rfile = fopen(p, "r"))) {
		    process_respfile (rfile);
		    fclose(rfile);
		} else
		    report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
			    "unable to open response file `%s'", p);
	} else
	    i = process_arg (argv[0], argc > 1 ? argv[1] : NULL);
	argv += i, argc -= i;
    }

    if (!*inname)
	report_error (ERR_NONFATAL | ERR_NOFILE | ERR_USAGE,
		      "no input file specified");
}

static void assemble_file (char *fname)
{
    char   * value, * p, * q, * special, * line, debugid[80];
    insn   output_ins;
    int    i, rn_error, validid;
    long   seg, offs;
    struct tokenval tokval;
    expr   * e;

    /*
     * pass one 
     */
    pass = 1;
    in_abs_seg = FALSE;
    location.segment = ofmt->section(NULL, pass, &sb);
    preproc->reset(fname, 1, report_error, evaluate, &nasmlist);
    globallineno = 0;
    location.known = TRUE;
    location.offset = offs = get_curr_ofs;

    while ( (line = preproc->getline()) ) 
    {
	globallineno++;

	/* here we parse our directives; this is not handled by the 'real'
	 * parser. */
	if ( (i = getkw (line, &value)) ) 
	{
	    switch (i) {
	      case 1:	       /* [SEGMENT n] */
		seg = ofmt->section (value, pass, &sb);
		if (seg == NO_SEG) {
		    report_error (ERR_NONFATAL,
				  "segment name `%s' not recognised",
				  value);
		} else {
		    in_abs_seg = FALSE;
		    location.segment = seg;
		}
		break;
	      case 2:	       /* [EXTERN label:special] */
		if (*value == '$')
		    value++;	       /* skip initial $ if present */
		q = value;
		validid = TRUE;
		if (!isidstart(*q))
		    validid = FALSE;
		while (*q && *q != ':') {
		    if (!isidchar(*q))
			validid = FALSE;
		    q++;
		}
		if (!validid) {
		    report_error (ERR_NONFATAL,
				  "identifier expected after EXTERN");
		    break;
		}
		if (*q == ':') {
		    *q++ = '\0';
		    special = q;
		} else
		    special = NULL;
		if (!is_extern(value)) {   /* allow re-EXTERN to be ignored */
		    declare_as_global (value, special, report_error);
		    define_label (value, seg_alloc(), 0L, NULL, FALSE, TRUE,
				  ofmt, report_error);
		}
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
	      case 4:	       /* [GLOBAL symbol:special] */
		if (*value == '$')
		    value++;	       /* skip initial $ if present */
		q = value;
		validid = TRUE;
		if (!isidstart(*q))
		    validid = FALSE;
		while (*q && *q != ':') {
		    if (!isidchar(*q))
			validid = FALSE;
		    q++;
		}
		if (!validid) {
		    report_error (ERR_NONFATAL,
				  "identifier expected after GLOBAL");
		    break;
		}
		if (*q == ':') {
		    *q++ = '\0';
		    special = q;
		} else
		    special = NULL;
		declare_as_global (value, special, report_error);
		break;
	      case 5:	       /* [COMMON symbol size:special] */
		p = value;
		validid = TRUE;
		if (!isidstart(*p))
		    validid = FALSE;
		while (*p && !isspace(*p)) {
		    if (!isidchar(*p))
			validid = FALSE;
		    p++;
		}
		if (!validid) {
		    report_error (ERR_NONFATAL,
				  "identifier expected after COMMON");
		    break;
		}
		if (*p) {
		    long size;

		    while (*p && isspace(*p))
			*p++ = '\0';
		    q = p;
		    while (*q && *q != ':')
			q++;
		    if (*q == ':') {
			*q++ = '\0';
			special = q;
		    } else
			special = NULL;
		    size = readnum (p, &rn_error);
		    if (rn_error)
			report_error (ERR_NONFATAL, "invalid size specified"
				      " in COMMON declaration");
		    else
			define_common (value, seg_alloc(), size,
				       special, ofmt, report_error);
		} else
		    report_error (ERR_NONFATAL, "no size specified in"
				  " COMMON declaration");
		break;
	      case 6:		       /* [ABSOLUTE address] */
		stdscan_reset();
		stdscan_bufptr = value;
		tokval.t_type = TOKEN_INVALID;
		e = evaluate(stdscan, NULL, &tokval, NULL, 1, report_error,
			     NULL);
		if (e) {
		    if (!is_reloc(e))
			report_error (ERR_NONFATAL, "cannot use non-"
				      "relocatable expression as ABSOLUTE"
				      " address");
		    else {
			abs_seg = reloc_seg(e);
			abs_offset = reloc_value(e);
		    }
		} else
		    abs_offset = 0x100;/* don't go near zero in case of / */
		in_abs_seg = TRUE;
		location.segment = abs_seg;
		break;
	      case 7:
		p = value;
		validid = TRUE;
		if (!isidstart(*p))
		    validid = FALSE;
		while (*p && !isspace(*p)) {
		    if (!isidchar(*p))
			validid = FALSE;
                    p++;
		}
		if (!validid) {
		    report_error (ERR_NONFATAL,
				  "identifier expected after DEBUG");
		    break;
		}
                while (*p && isspace(*p)) p++;
		break;
	      default:
		if (!ofmt->directive (line+1, value, 1))
		    report_error (ERR_NONFATAL, "unrecognised directive [%s]",
				  line+1);
		break;
	    }
	}
	else 	/* it isn't a directive */
	{
	    parse_line (1, line, &output_ins,
			report_error, evaluate, define_label);

	    if (output_ins.forw_ref) 
	    {
		for(i = 0; i < output_ins.operands; i++) 
		{
		    if (output_ins.oprs[i].opflags & OPFLAG_FORWARD) 
		    {
		    	struct forwrefinfo *fwinf =
		    	    (struct forwrefinfo *)saa_wstruct(forwrefs);
			fwinf->lineno = globallineno;
			fwinf->operand = i;
		    }
		}
	    }

	    if (output_ins.opcode == I_EQU) 
	    {
		/*
		 * Special `..' EQUs get processed in pass two,
		 * except `..@' macro-processor EQUs which are done
		 * in the normal place.
		 */
		if (!output_ins.label)
		    report_error (ERR_NONFATAL,
				  "EQU not preceded by label");

		else if (output_ins.label[0] != '.' ||
			 output_ins.label[1] != '.' ||
			 output_ins.label[2] == '@') 
		{
		    if (output_ins.operands == 1 &&
			(output_ins.oprs[0].type & IMMEDIATE) &&
			output_ins.oprs[0].wrt == NO_SEG) 
		    {
		      int isext = output_ins.oprs[0].opflags & OPFLAG_EXTERN;
		      define_label (output_ins.label,
				    output_ins.oprs[0].segment,
				    output_ins.oprs[0].offset,
				    NULL, FALSE, isext, ofmt, report_error);
		    } 
		    else if (output_ins.operands == 2 &&
			       (output_ins.oprs[0].type & IMMEDIATE) &&
			       (output_ins.oprs[0].type & COLON) &&
			       output_ins.oprs[0].segment == NO_SEG &&
			       output_ins.oprs[0].wrt == NO_SEG &&
			       (output_ins.oprs[1].type & IMMEDIATE) &&
			       output_ins.oprs[1].segment == NO_SEG &&
			       output_ins.oprs[1].wrt == NO_SEG) 
		    {
			define_label (output_ins.label,
				      output_ins.oprs[0].offset | SEG_ABS,
				      output_ins.oprs[1].offset,
				      NULL, FALSE, FALSE, ofmt, report_error);
		    } 
		    else
			report_error(ERR_NONFATAL, "bad syntax for EQU");
		}
	    } 
	    else  /* instruction isn't an EQU */
	    {
		long l = insn_size (location.segment, offs, sb,
				   &output_ins, report_error);
		if (using_debug_info && output_ins.opcode != -1) {
		    /* this is done here so we can do debug type info */
                    long typeinfo = TYS_ELEMENTS(output_ins.operands);
		    switch (output_ins.opcode) {
		    	case I_RESB:
        		    typeinfo = TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_BYTE;  
			    break;
		    	case I_RESW:
        		    typeinfo = TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_WORD;  
			    break;
		    	case I_RESD:
        		    typeinfo = TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_DWORD;  
			    break;
		    	case I_RESQ:
        		    typeinfo = TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_QWORD;  
			    break;
		    	case I_REST:
        		    typeinfo = TYS_ELEMENTS(output_ins.oprs[0].offset) | TY_TBYTE;  
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
	    	    	default:
		    	    typeinfo = TY_LABEL;
		    }
		    ofmt->current_dfmt->debug_typevalue(typeinfo);
		}
		if (l != -1) {
		    offs += l;
		    set_curr_ofs (offs);
		}
		/* 
		 * else l == -1 => invalid instruction, which will be
		 * flagged as an error on pass 2
		 */
	    }
	    cleanup_insn (&output_ins);
	}
	nasm_free (line);
	location.offset = offs = get_curr_ofs;
    }

    preproc->cleanup();

    if (terminate_after_phase) {
	fclose(ofile);
	remove(outname);
	if (want_usage)
	    usage();
	exit (1);
    }

    /*
     * pass two 
     */

    pass = 2;
    saa_rewind (forwrefs);
    if (*listname)
	nasmlist.init(listname, report_error);
    forwref = saa_rstruct (forwrefs);
    in_abs_seg = FALSE;
    location.segment = ofmt->section(NULL, pass, &sb);
    raa_free (offsets);
    offsets = raa_init();
    preproc->reset(fname, 2, report_error, evaluate, &nasmlist);
    globallineno = 0;
    location.offset = offs = get_curr_ofs;

    while ( (line = preproc->getline()) ) 
    {
	globallineno++;

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
		    in_abs_seg = FALSE;
		    location.segment = seg;
		break;
	      case 2:	       /* [EXTERN label] */
		q = value;
		while (*q && *q != ':')
		    q++;
		if (*q == ':') {
		    *q++ = '\0';
		    ofmt->symdef(value, 0L, 0L, 3, q);
		}
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
		q = value;
		while (*q && *q != ':')
		    q++;
		if (*q == ':') {
		    *q++ = '\0';
		    ofmt->symdef(value, 0L, 0L, 3, q);
		}
		break;
	      case 5:		       /* [COMMON symbol size] */
		q = value;
		while (*q && *q != ':') {
		    if (isspace(*q))
			*q = '\0';
		    q++;
		}
		if (*q == ':') {
		    *q++ = '\0';
		    ofmt->symdef(value, 0L, 0L, 3, q);
		}
		break;
	      case 6:		       /* [ABSOLUTE addr] */
		stdscan_reset();
		stdscan_bufptr = value;
		tokval.t_type = TOKEN_INVALID;
		e = evaluate(stdscan, NULL, &tokval, NULL, 2, report_error,
			     NULL);
		if (e) {
		    if (!is_reloc(e))
			report_error (ERR_PANIC, "non-reloc ABSOLUTE address"
				      " in pass two");
		    else {
			abs_seg = reloc_seg(e);
			abs_offset = reloc_value(e);
		    }
		} else
		    report_error (ERR_PANIC, "invalid ABSOLUTE address "
				  "in pass two");
		in_abs_seg = TRUE;
		location.segment = abs_seg;
		break;
	      case 7:
		p = value;
                q = debugid;
		validid = TRUE;
		if (!isidstart(*p))
		    validid = FALSE;
		while (*p && !isspace(*p)) {
		    if (!isidchar(*p))
			validid = FALSE;
		    *q++ = *p++;
		}
		*q++ = 0;
		if (!validid) {
		    report_error (ERR_PANIC,
				  "identifier expected after DEBUG in pass 2");
		    break;
		}
                while (*p && isspace(*p)) 
		    p++;
		ofmt->current_dfmt->debug_directive (debugid, p);
		break;
	      default:
		if (!ofmt->directive (line+1, value, 2))
		    report_error (ERR_PANIC, "invalid directive on pass two");
		break;
	    }
	} 
	else 		/* not a directive */
	{
	    parse_line (2, line, &output_ins,
			report_error, evaluate, redefine_label);
	    if (forwref != NULL && globallineno == forwref->lineno) {
		output_ins.forw_ref = TRUE;
		do {
		    output_ins.oprs[forwref->operand].opflags|= OPFLAG_FORWARD;
		    forwref = saa_rstruct (forwrefs);
		} while (forwref != NULL && forwref->lineno == globallineno);
	    } else
		output_ins.forw_ref = FALSE;

	    /*
	     * Hack to prevent phase error in the code
	     *   rol ax,x
	     *   x equ 1
	     *
	     * If the second operand is a forward reference,
	     * the UNITY property of the number 1 in that
	     * operand is cancelled. Otherwise the above
	     * sequence will cause a phase error.
	     *
	     * This hack means that the above code will
	     * generate 286+ code.
	     *
	     * The forward reference will mean that the
	     * operand will not have the UNITY property on
	     * the first pass, so the pass behaviours will
	     * be consistent.
	     */

	    if (output_ins.forw_ref &&
		output_ins.operands >= 2 &&
		(output_ins.oprs[1].opflags & OPFLAG_FORWARD)) 
	    {
		    output_ins.oprs[1].type &= ~ONENESS;
	    }

	    if (output_ins.opcode == I_EQU) 
	    {
		/*
		 * Special `..' EQUs get processed here, except
		 * `..@' macro processor EQUs which are done above.
		 */
		if (output_ins.label[0] == '.' &&
		    output_ins.label[1] == '.' &&
		    output_ins.label[2] != '@') 
		{
		    if (output_ins.operands == 1 &&
			(output_ins.oprs[0].type & IMMEDIATE)) {
			define_label (output_ins.label,
				      output_ins.oprs[0].segment,
				      output_ins.oprs[0].offset,
				      NULL, FALSE, FALSE, ofmt, report_error);
		    } 
		    else if (output_ins.operands == 2 &&
			       (output_ins.oprs[0].type & IMMEDIATE) &&
			       (output_ins.oprs[0].type & COLON) &&
			       output_ins.oprs[0].segment == NO_SEG &&
			       (output_ins.oprs[1].type & IMMEDIATE) &&
			       output_ins.oprs[1].segment == NO_SEG) 
		    {
			define_label (output_ins.label,
				      output_ins.oprs[0].offset | SEG_ABS,
				      output_ins.oprs[1].offset,
				      NULL, FALSE, FALSE, ofmt, report_error);
		    } 
		    else
			report_error(ERR_NONFATAL, "bad syntax for EQU");
		}
	    }
	    offs += assemble (location.segment, offs, sb,
			      &output_ins, ofmt, report_error, &nasmlist);
	    cleanup_insn (&output_ins);
	    set_curr_ofs (offs);
	}

	nasm_free (line);

	location.offset = offs = get_curr_ofs;
    }

    preproc->cleanup();
    nasmlist.cleanup();
}

static int getkw (char *buf, char **value) 
{
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
        while (isspace(*buf)) buf++;   /* beppu - skip leading whitespace */
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
    if (!strcmp(p, "debug"))
	return 7;
    return -1;
}

static void report_error (int severity, char *fmt, ...) 
{
    va_list ap;

    /*
     * See if it's a suppressed warning.
     */
    if ((severity & ERR_MASK) == ERR_WARNING &&
	(severity & ERR_WARN_MASK) != 0 &&
	suppressed[ (severity & ERR_WARN_MASK) >> ERR_WARN_SHR ])
	return;			       /* and bail out if so */

    /*
     * See if it's a pass-one only warning and we're not in pass one.
     */
    if ((severity & ERR_PASS1) && pass != 1)
	return;

    if (severity & ERR_NOFILE)
	fputs ("nasm: ", error_file);
    else {
	char * currentfile = NULL;
	long lineno = 0;
	src_get (&lineno, &currentfile);
	fprintf (error_file, "%s:%ld: ", currentfile, lineno);
	nasm_free (currentfile);
    }

    if ( (severity & ERR_MASK) == ERR_WARNING)
	fputs ("warning: ", error_file);
    else if ( (severity & ERR_MASK) == ERR_PANIC)
	fputs ("panic: ", error_file);

    va_start (ap, fmt);
    vfprintf (error_file, fmt, ap);
    fputc ('\n', error_file);

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
	fflush(NULL);
	abort();		       /* halt, catch fire, and dump core */
	break;
    }
}

static void usage(void) 
{
    fputs("type `nasm -h' for help\n", error_file);
}

static void register_output_formats(void) 
{
    ofmt = ofmt_register (report_error);
}

#define BUF_DELTA 512

static FILE *no_pp_fp;
static efunc no_pp_err;
static ListGen *no_pp_list;
static long no_pp_lineinc;

static void no_pp_reset (char *file, int pass, efunc error, evalfunc eval,
			 ListGen *listgen) 
{
    src_set_fname(nasm_strdup(file));
    src_set_linnum(0);
    no_pp_lineinc = 1;
    no_pp_err = error;
    no_pp_fp = fopen(file, "r");
    if (!no_pp_fp)
	no_pp_err (ERR_FATAL | ERR_NOFILE,
		   "unable to open input file `%s'", file);
    no_pp_list = listgen;
    (void) pass;		       /* placate compilers */
    (void) eval;		       /* placate compilers */
}

static char *no_pp_getline (void) 
{
    char *buffer, *p, *q;
    int bufsize;

    bufsize = BUF_DELTA;
    buffer = nasm_malloc(BUF_DELTA);
    src_set_linnum(src_get_linnum() + no_pp_lineinc);

    while (1) {   /* Loop to handle %line */

	p = buffer;
	while (1) {  /* Loop to handle long lines */
	    q = fgets(p, bufsize-(p-buffer), no_pp_fp);
	    if (!q)
		break;
	    p += strlen(p);
	    if (p > buffer && p[-1] == '\n')
		break;
	    if (p-buffer > bufsize-10) {
		int offset;
		offset = p - buffer;
		bufsize += BUF_DELTA;
		buffer = nasm_realloc(buffer, bufsize);
		p = buffer + offset;
	    }
	}

	if (!q && p == buffer) {
	    nasm_free (buffer);
	    return NULL;
	}

	/*
	 * Play safe: remove CRs, LFs and any spurious ^Zs, if any of
	 * them are present at the end of the line.
	 */
	buffer[strcspn(buffer, "\r\n\032")] = '\0';

	if (!strncmp(buffer, "%line", 5)) {
	    long ln;
	    int  li;
	    char *nm = nasm_malloc(strlen(buffer));
	    if (sscanf(buffer+5, "%ld+%d %s", &ln, &li, nm) == 3) {
		nasm_free( src_set_fname(nm) );
		src_set_linnum(ln);
		no_pp_lineinc = li;
		continue;
	    }
	    nasm_free(nm);
	}
	break;
    }

    no_pp_list->line (LIST_READ, buffer);

    return buffer;
}

static void no_pp_cleanup (void) 
{
    fclose(no_pp_fp);
}
