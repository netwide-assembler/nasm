/* nasm.h   main header file for the Netwide Assembler: inter-module interface
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * initial version: 27/iii/95 by Simon Tatham
 */

#ifndef NASM_NASM_H
#define NASM_NASM_H

#define NASM_MAJOR_VER 0
#define NASM_MINOR_VER 98
#define NASM_VER "0.98"

#ifndef NULL
#define NULL 0
#endif

#ifndef FALSE
#define FALSE 0			       /* comes in handy */
#endif
#ifndef TRUE
#define TRUE 1
#endif

#define NO_SEG -1L		       /* null segment value */
#define SEG_ABS 0x40000000L	       /* mask for far-absolute segments */

#ifndef FILENAME_MAX
#define FILENAME_MAX 256
#endif

/*
 * Name pollution problems: <time.h> on Digital UNIX pulls in some
 * strange hardware header file which sees fit to define R_SP. We
 * undefine it here so as not to break the enum below.
 */
#ifdef R_SP
#undef R_SP
#endif

/*
 * We must declare the existence of this structure type up here,
 * since we have to reference it before we define it...
 */
struct ofmt;

/*
 * -------------------------
 * Error reporting functions
 * -------------------------
 */

/*
 * An error reporting function should look like this.
 */
typedef void (*efunc) (int severity, char *fmt, ...);

/*
 * These are the error severity codes which get passed as the first
 * argument to an efunc.
 */

#define ERR_WARNING 0		       /* warn only: no further action */
#define ERR_NONFATAL 1		       /* terminate assembly after phase */
#define ERR_FATAL 2		       /* instantly fatal: exit with error */
#define ERR_PANIC 3		       /* internal error: panic instantly
					* and dump core for reference */
#define ERR_MASK 0x0F		       /* mask off the above codes */
#define ERR_NOFILE 0x10		       /* don't give source file name/line */
#define ERR_USAGE 0x20		       /* print a usage message */
#define ERR_PASS1 0x80		       /* only print this error on pass one */

/*
 * These codes define specific types of suppressible warning.
 */
#define ERR_WARN_MNP  0x0100	       /* macro-num-parameters warning */
#define ERR_WARN_OL   0x0200	       /* orphan label (no colon, and
					* alone on line) */
#define ERR_WARN_NOV  0x0300	       /* numeric overflow */
#define ERR_WARN_MASK 0xFF00	       /* the mask for this feature */
#define ERR_WARN_SHR  8		       /* how far to shift right */
#define ERR_WARN_MAX  3		       /* the highest numbered one */

/*
 * -----------------------
 * Other function typedefs
 * -----------------------
 */

/*
 * A label-lookup function should look like this.
 */
typedef int (*lfunc) (char *label, long *segment, long *offset);

/*
 * And a label-definition function like this. The boolean parameter
 * `is_norm' states whether the label is a `normal' label (which
 * should affect the local-label system), or something odder like
 * an EQU or a segment-base symbol, which shouldn't.
 */
typedef void (*ldfunc) (char *label, long segment, long offset, char *special,
			int is_norm, int isextrn, struct ofmt *ofmt,
			efunc error);

/*
 * List-file generators should look like this:
 */
typedef struct {
    /*
     * Called to initialise the listing file generator. Before this
     * is called, the other routines will silently do nothing when
     * called. The `char *' parameter is the file name to write the
     * listing to.
     */
    void (*init) (char *, efunc);

    /*
     * Called to clear stuff up and close the listing file.
     */
    void (*cleanup) (void);

    /*
     * Called to output binary data. Parameters are: the offset;
     * the data; the data type. Data types are similar to the
     * output-format interface, only OUT_ADDRESS will _always_ be
     * displayed as if it's relocatable, so ensure that any non-
     * relocatable address has been converted to OUT_RAWDATA by
     * then. Note that OUT_RAWDATA+0 is a valid data type, and is a
     * dummy call used to give the listing generator an offset to
     * work with when doing things like uplevel(LIST_TIMES) or
     * uplevel(LIST_INCBIN).
     */
    void (*output) (long, void *, unsigned long);

    /*
     * Called to send a text line to the listing generator. The
     * `int' parameter is LIST_READ or LIST_MACRO depending on
     * whether the line came directly from an input file or is the
     * result of a multi-line macro expansion.
     */
    void (*line) (int, char *);

    /*
     * Called to change one of the various levelled mechanisms in
     * the listing generator. LIST_INCLUDE and LIST_MACRO can be
     * used to increase the nesting level of include files and
     * macro expansions; LIST_TIMES and LIST_INCBIN switch on the
     * two binary-output-suppression mechanisms for large-scale
     * pseudo-instructions.
     *
     * LIST_MACRO_NOLIST is synonymous with LIST_MACRO except that
     * it indicates the beginning of the expansion of a `nolist'
     * macro, so anything under that level won't be expanded unless
     * it includes another file.
     */
    void (*uplevel) (int);

    /*
     * Reverse the effects of uplevel.
     */
    void (*downlevel) (int);
} ListGen;

/*
 * The expression evaluator must be passed a scanner function; a
 * standard scanner is provided as part of nasmlib.c. The
 * preprocessor will use a different one. Scanners, and the
 * token-value structures they return, look like this.
 *
 * The return value from the scanner is always a copy of the
 * `t_type' field in the structure.
 */
struct tokenval {
    int t_type;
    long t_integer, t_inttwo;
    char *t_charptr;
};
typedef int (*scanner) (void *private_data, struct tokenval *tv);

/*
 * Token types returned by the scanner, in addition to ordinary
 * ASCII character values, and zero for end-of-string.
 */
enum {				       /* token types, other than chars */
    TOKEN_INVALID = -1,		       /* a placeholder value */
    TOKEN_EOS = 0,		       /* end of string */
    TOKEN_EQ = '=', TOKEN_GT = '>', TOKEN_LT = '<',   /* aliases */
    TOKEN_ID = 256, TOKEN_NUM, TOKEN_REG, TOKEN_INSN,  /* major token types */
    TOKEN_ERRNUM,		       /* numeric constant with error in */
    TOKEN_HERE, TOKEN_BASE,	       /* $ and $$ */
    TOKEN_SPECIAL,		       /* BYTE, WORD, DWORD, FAR, NEAR, etc */
    TOKEN_PREFIX,		       /* A32, O16, LOCK, REPNZ, TIMES, etc */
    TOKEN_SHL, TOKEN_SHR,	       /* << and >> */
    TOKEN_SDIV, TOKEN_SMOD,	       /* // and %% */
    TOKEN_GE, TOKEN_LE, TOKEN_NE,      /* >=, <= and <> (!= is same as <>) */
    TOKEN_DBL_AND, TOKEN_DBL_OR, TOKEN_DBL_XOR,   /* &&, || and ^^ */
    TOKEN_SEG, TOKEN_WRT,	       /* SEG and WRT */
    TOKEN_FLOAT			       /* floating-point constant */
};

typedef struct {
    long segment;
    long offset;
    int  known;
} loc_t;

/*
 * Expression-evaluator datatype. Expressions, within the
 * evaluator, are stored as an array of these beasts, terminated by
 * a record with type==0. Mostly, it's a vector type: each type
 * denotes some kind of a component, and the value denotes the
 * multiple of that component present in the expression. The
 * exception is the WRT type, whose `value' field denotes the
 * segment to which the expression is relative. These segments will
 * be segment-base types, i.e. either odd segment values or SEG_ABS
 * types. So it is still valid to assume that anything with a
 * `value' field of zero is insignificant.
 */
typedef struct {
    long type;			       /* a register, or EXPR_xxx */
    long value;			       /* must be >= 32 bits */
} expr;

/*
 * The evaluator can also return hints about which of two registers
 * used in an expression should be the base register. See also the
 * `operand' structure.
 */
struct eval_hints {
    int base;
    int type;
};

/*
 * The actual expression evaluator function looks like this. When
 * called, it expects the first token of its expression to already
 * be in `*tv'; if it is not, set tv->t_type to TOKEN_INVALID and
 * it will start by calling the scanner.
 *
 * If a forward reference happens during evaluation, the evaluator
 * must set `*fwref' to TRUE if `fwref' is non-NULL.
 *
 * `critical' is non-zero if the expression may not contain forward
 * references. The evaluator will report its own error if this
 * occurs; if `critical' is 1, the error will be "symbol not
 * defined before use", whereas if `critical' is 2, the error will
 * be "symbol undefined".
 *
 * If `critical' has bit 4 set (in addition to its main value: 0x11
 * and 0x12 correspond to 1 and 2) then an extended expression
 * syntax is recognised, in which relational operators such as =, <
 * and >= are accepted, as well as low-precedence logical operators
 * &&, ^^ and ||.
 *
 * If `hints' is non-NULL, it gets filled in with some hints as to
 * the base register in complex effective addresses.
 */
typedef expr *(*evalfunc) (scanner sc, void *scprivate, struct tokenval *tv,
			   int *fwref, int critical, efunc error,
			   struct eval_hints *hints);

/*
 * Special values for expr->type. ASSUMPTION MADE HERE: the number
 * of distinct register names (i.e. possible "type" fields for an
 * expr structure) does not exceed 124 (EXPR_REG_START through
 * EXPR_REG_END).
 */
#define EXPR_REG_START 1
#define EXPR_REG_END 124
#define EXPR_UNKNOWN 125L	       /* for forward references */
#define EXPR_SIMPLE 126L
#define EXPR_WRT 127L
#define EXPR_SEGBASE 128L

/*
 * Preprocessors ought to look like this:
 */
typedef struct {
    /*
     * Called at the start of a pass; given a file name, the number
     * of the pass, an error reporting function, an evaluator
     * function, and a listing generator to talk to.
     */
    void (*reset) (char *, int, efunc, evalfunc, ListGen *);

    /*
     * Called to fetch a line of preprocessed source. The line
     * returned has been malloc'ed, and so should be freed after
     * use.
     */
    char *(*getline) (void);

    /*
     * Called at the end of a pass.
     */
    void (*cleanup) (void);
} Preproc;

/*
 * ----------------------------------------------------------------
 * Some lexical properties of the NASM source language, included
 * here because they are shared between the parser and preprocessor
 * ----------------------------------------------------------------
 */

/*
 * isidstart matches any character that may start an identifier, and isidchar
 * matches any character that may appear at places other than the start of an
 * identifier. E.g. a period may only appear at the start of an identifier
 * (for local labels), whereas a number may appear anywhere *but* at the
 * start. 
 */

#define isidstart(c) ( isalpha(c) || (c)=='_' || (c)=='.' || (c)=='?' \
                                  || (c)=='@' )
#define isidchar(c)  ( isidstart(c) || isdigit(c) || (c)=='$' || (c)=='#' \
                                                  || (c)=='~' )

/* Ditto for numeric constants. */

#define isnumstart(c)  ( isdigit(c) || (c)=='$' )
#define isnumchar(c)   ( isalnum(c) )

/* This returns the numeric value of a given 'digit'. */

#define numvalue(c)  ((c)>='a' ? (c)-'a'+10 : (c)>='A' ? (c)-'A'+10 : (c)-'0')

/*
 * Data-type flags that get passed to listing-file routines.
 */
enum {
    LIST_READ, LIST_MACRO, LIST_MACRO_NOLIST, LIST_INCLUDE,
    LIST_INCBIN, LIST_TIMES
};

/*
 * -----------------------------------------------------------
 * Format of the `insn' structure returned from `parser.c' and
 * passed into `assemble.c'
 * -----------------------------------------------------------
 */

/*
 * Here we define the operand types. These are implemented as bit
 * masks, since some are subsets of others; e.g. AX in a MOV
 * instruction is a special operand type, whereas AX in other
 * contexts is just another 16-bit register. (Also, consider CL in
 * shift instructions, DX in OUT, etc.)
 */

/* size, and other attributes, of the operand */
#define BITS8     0x00000001L
#define BITS16    0x00000002L
#define BITS32    0x00000004L
#define BITS64    0x00000008L	       /* FPU only */
#define BITS80    0x00000010L	       /* FPU only */
#define FAR       0x00000020L	       /* grotty: this means 16:16 or */
				       /* 16:32, like in CALL/JMP */
#define NEAR      0x00000040L
#define SHORT     0x00000080L	       /* and this means what it says :) */

#define SIZE_MASK 0x000000FFL	       /* all the size attributes */
#define NON_SIZE  (~SIZE_MASK)

#define TO        0x00000100L          /* reverse effect in FADD, FSUB &c */
#define COLON     0x00000200L	       /* operand is followed by a colon */

/* type of operand: memory reference, register, etc. */
#define MEMORY    0x00204000L
#define REGISTER  0x00001000L	       /* register number in 'basereg' */
#define IMMEDIATE 0x00002000L

#define REGMEM    0x00200000L	       /* for r/m, ie EA, operands */
#define REGNORM   0x00201000L	       /* 'normal' reg, qualifies as EA */
#define REG8      0x00201001L
#define REG16     0x00201002L
#define REG32     0x00201004L
#define MMXREG    0x00201008L	       /* MMX registers */
#define XMMREG    0x00201010L          /* XMM Katmai reg */
#define FPUREG    0x01000000L	       /* floating point stack registers */
#define FPU0      0x01000800L	       /* FPU stack register zero */

/* special register operands: these may be treated differently */
#define REG_SMASK 0x00070000L	       /* a mask for the following */
#define REG_ACCUM 0x00211000L	       /* accumulator: AL, AX or EAX */
#define REG_AL    0x00211001L	       /* REG_ACCUM | BITSxx */
#define REG_AX    0x00211002L	       /* ditto */
#define REG_EAX   0x00211004L	       /* and again */
#define REG_COUNT 0x00221000L	       /* counter: CL, CX or ECX */
#define REG_CL    0x00221001L	       /* REG_COUNT | BITSxx */
#define REG_CX    0x00221002L	       /* ditto */
#define REG_ECX   0x00221004L	       /* another one */
#define REG_DX    0x00241002L
#define REG_SREG  0x00081002L	       /* any segment register */
#define REG_CS    0x01081002L	       /* CS */
#define REG_DESS  0x02081002L	       /* DS, ES, SS (non-CS 86 registers) */
#define REG_FSGS  0x04081002L	       /* FS, GS (386 extended registers) */
#define REG_CDT   0x00101004L	       /* CRn, DRn and TRn */
#define REG_CREG  0x08101004L	       /* CRn */
#define REG_CR4   0x08101404L	       /* CR4 (Pentium only) */
#define REG_DREG  0x10101004L	       /* DRn */
#define REG_TREG  0x20101004L	       /* TRn */

/* special type of EA */
#define MEM_OFFS  0x00604000L	       /* simple [address] offset */

/* special type of immediate operand */
#define ONENESS   0x00800000L          /* so UNITY == IMMEDIATE | ONENESS */
#define UNITY     0x00802000L	       /* for shift/rotate instructions */

/*
 * Next, the codes returned from the parser, for registers and
 * instructions.
 */

enum {				       /* register names */
    R_AH = EXPR_REG_START, R_AL, R_AX, R_BH, R_BL, R_BP, R_BX, R_CH,
    R_CL, R_CR0, R_CR2, R_CR3, R_CR4, R_CS, R_CX, R_DH, R_DI, R_DL,
    R_DR0, R_DR1, R_DR2, R_DR3, R_DR6, R_DR7, R_DS, R_DX, R_EAX,
    R_EBP, R_EBX, R_ECX, R_EDI, R_EDX, R_ES, R_ESI, R_ESP, R_FS,
    R_GS, R_MM0, R_MM1, R_MM2, R_MM3, R_MM4, R_MM5, R_MM6, R_MM7,
    R_SI, R_SP, R_SS, R_ST0, R_ST1, R_ST2, R_ST3, R_ST4, R_ST5,
    R_ST6, R_ST7, R_TR3, R_TR4, R_TR5, R_TR6, R_TR7,
    R_XMM0, R_XMM1, R_XMM2, R_XMM3, R_XMM4, R_XMM5, R_XMM6, R_XMM7, REG_ENUM_LIMIT
};

/* Instruction names automatically generated from insns.dat */
#include "insnsi.h"

/* max length of any instruction, register name etc. */
#if MAX_INSLEN > 9
#define MAX_KEYWORD MAX_INSLEN
#else
#define MAX_KEYWORD 9
#endif

enum {				       /* condition code names */
    C_A, C_AE, C_B, C_BE, C_C, C_E, C_G, C_GE, C_L, C_LE, C_NA, C_NAE,
    C_NB, C_NBE, C_NC, C_NE, C_NG, C_NGE, C_NL, C_NLE, C_NO, C_NP,
    C_NS, C_NZ, C_O, C_P, C_PE, C_PO, C_S, C_Z
};

/*
 * Note that because segment registers may be used as instruction
 * prefixes, we must ensure the enumerations for prefixes and
 * register names do not overlap.
 */
enum {				       /* instruction prefixes */
    PREFIX_ENUM_START = REG_ENUM_LIMIT,
    P_A16 = PREFIX_ENUM_START, P_A32, P_LOCK, P_O16, P_O32, P_REP, P_REPE,
    P_REPNE, P_REPNZ, P_REPZ, P_TIMES
};

enum {				       /* extended operand types */
    EOT_NOTHING, EOT_DB_STRING, EOT_DB_NUMBER
};

enum {				       /* special EA flags */
    EAF_BYTEOFFS = 1,		       /* force offset part to byte size */
    EAF_WORDOFFS = 2,		       /* force offset part to [d]word size */
    EAF_TIMESTWO = 4		       /* really do EAX*2 not EAX+EAX */
};

enum {				       /* values for `hinttype' */
    EAH_NOHINT = 0,		       /* no hint at all - our discretion */
    EAH_MAKEBASE = 1,		       /* try to make given reg the base */
    EAH_NOTBASE = 2		       /* try _not_ to make reg the base */
};

typedef struct {		       /* operand to an instruction */
    long type;			       /* type of operand */
    int addr_size;		       /* 0 means default; 16; 32 */
    int basereg, indexreg, scale;      /* registers and scale involved */
    int hintbase, hinttype;	       /* hint as to real base register */
    long segment;		       /* immediate segment, if needed */
    long offset;		       /* any immediate number */
    long wrt;			       /* segment base it's relative to */
    int eaflags;		       /* special EA flags */
    int opflags;		       /* see OPFLAG_* defines below */
} operand;

#define OPFLAG_FORWARD		1      /* operand is a forward reference */
#define OPFLAG_EXTERN		2      /* operand is an external reference */

typedef struct extop {		       /* extended operand */
    struct extop *next;		       /* linked list */
    long type;			       /* defined above */
    char *stringval;		       /* if it's a string, then here it is */
    int stringlen;		       /* ... and here's how long it is */
    long segment;		       /* if it's a number/address, then... */
    long offset;		       /* ... it's given here ... */
    long wrt;			       /* ... and here */
} extop;

#define MAXPREFIX 4

typedef struct {		       /* an instruction itself */
    char *label;		       /* the label defined, or NULL */
    int prefixes[MAXPREFIX];	       /* instruction prefixes, if any */
    int nprefix;		       /* number of entries in above */
    int opcode;			       /* the opcode - not just the string */
    int condition;		       /* the condition code, if Jcc/SETcc */
    int operands;		       /* how many operands? 0-3 
                                        * (more if db et al) */
    operand oprs[3];	   	       /* the operands, defined as above */
    extop *eops;		       /* extended operands */
    int eops_float;                    /* true if DD and floating */
    long times;			       /* repeat count (TIMES prefix) */
    int forw_ref;		       /* is there a forward reference? */
} insn;

enum geninfo { GI_SWITCH };
/*
 * ------------------------------------------------------------
 * The data structure defining an output format driver, and the
 * interfaces to the functions therein.
 * ------------------------------------------------------------
 */

struct ofmt {
    /*
     * This is a short (one-liner) description of the type of
     * output generated by the driver.
     */
    char *fullname;

    /*
     * This is a single keyword used to select the driver.
     */
    char *shortname;

    /*
     * this is reserved for out module specific help.
     * It is set to NULL in all the out modules but is not implemented
     * in the main program
     */
    char *helpstring;

    /*
     * this is a pointer to the first element of the debug information
     */
    struct dfmt **debug_formats;

    /*
     * and a pointer to the element that is being used
     * note: this is set to the default at compile time and changed if the
     * -F option is selected.  If developing a set of new debug formats for
     * an output format, be sure to set this to whatever default you want
     *
     */
    struct dfmt *current_dfmt;

    /*
     * This, if non-NULL, is a NULL-terminated list of `char *'s
     * pointing to extra standard macros supplied by the object
     * format (e.g. a sensible initial default value of __SECT__,
     * and user-level equivalents for any format-specific
     * directives).
     */
    char **stdmac;

    /*
     * This procedure is called at the start of an output session.
     * It tells the output format what file it will be writing to,
     * what routine to report errors through, and how to interface
     * to the label manager and expression evaluator if necessary.
     * It also gives it a chance to do other initialisation.
     */
    void (*init) (FILE *fp, efunc error, ldfunc ldef, evalfunc eval);

    /*
     * This procedure is called to pass generic information to the
     * object file.  The first parameter gives the information type
     * (currently only command line switches)
     * and the second parameter gives the value.  This function returns
     * 1 if recognized, 0 if unrecognized
     */
    int (*setinfo)(enum geninfo type, char **string);

    /*
     * This procedure is called by assemble() to write actual
     * generated code or data to the object file. Typically it
     * doesn't have to actually _write_ it, just store it for
     * later.
     *
     * The `type' argument specifies the type of output data, and
     * usually the size as well: its contents are described below.
     */
    void (*output) (long segto, void *data, unsigned long type,
		    long segment, long wrt);

    /*
     * This procedure is called once for every symbol defined in
     * the module being assembled. It gives the name and value of
     * the symbol, in NASM's terms, and indicates whether it has
     * been declared to be global. Note that the parameter "name",
     * when passed, will point to a piece of static storage
     * allocated inside the label manager - it's safe to keep using
     * that pointer, because the label manager doesn't clean up
     * until after the output driver has.
     *
     * Values of `is_global' are: 0 means the symbol is local; 1
     * means the symbol is global; 2 means the symbol is common (in
     * which case `offset' holds the _size_ of the variable).
     * Anything else is available for the output driver to use
     * internally.
     *
     * This routine explicitly _is_ allowed to call the label
     * manager to define further symbols, if it wants to, even
     * though it's been called _from_ the label manager. That much
     * re-entrancy is guaranteed in the label manager. However, the
     * label manager will in turn call this routine, so it should
     * be prepared to be re-entrant itself.
     *
     * The `special' parameter contains special information passed
     * through from the command that defined the label: it may have
     * been an EXTERN, a COMMON or a GLOBAL. The distinction should
     * be obvious to the output format from the other parameters.
     */
    void (*symdef) (char *name, long segment, long offset, int is_global,
		    char *special);

    /*
     * This procedure is called when the source code requests a
     * segment change. It should return the corresponding segment
     * _number_ for the name, or NO_SEG if the name is not a valid
     * segment name.
     *
     * It may also be called with NULL, in which case it is to
     * return the _default_ section number for starting assembly in.
     *
     * It is allowed to modify the string it is given a pointer to.
     *
     * It is also allowed to specify a default instruction size for
     * the segment, by setting `*bits' to 16 or 32. Or, if it
     * doesn't wish to define a default, it can leave `bits' alone.
     */
    long (*section) (char *name, int pass, int *bits);

    /*
     * This procedure is called to modify the segment base values
     * returned from the SEG operator. It is given a segment base
     * value (i.e. a segment value with the low bit set), and is
     * required to produce in return a segment value which may be
     * different. It can map segment bases to absolute numbers by
     * means of returning SEG_ABS types.
     *
     * It should return NO_SEG if the segment base cannot be
     * determined; the evaluator (which calls this routine) is
     * responsible for throwing an error condition if that occurs
     * in pass two or in a critical expression.
     */
    long (*segbase) (long segment);

    /*
     * This procedure is called to allow the output driver to
     * process its own specific directives. When called, it has the
     * directive word in `directive' and the parameter string in
     * `value'. It is called in both assembly passes, and `pass'
     * will be either 1 or 2.
     *
     * This procedure should return zero if it does not _recognise_
     * the directive, so that the main program can report an error.
     * If it recognises the directive but then has its own errors,
     * it should report them itself and then return non-zero. It
     * should also return non-zero if it correctly processes the
     * directive.
     */
    int (*directive) (char *directive, char *value, int pass);

    /*
     * This procedure is called before anything else - even before
     * the "init" routine - and is passed the name of the input
     * file from which this output file is being generated. It
     * should return its preferred name for the output file in
     * `outname', if outname[0] is not '\0', and do nothing to
     * `outname' otherwise. Since it is called before the driver is
     * properly initialised, it has to be passed its error handler
     * separately.
     *
     * This procedure may also take its own copy of the input file
     * name for use in writing the output file: it is _guaranteed_
     * that it will be called before the "init" routine.
     *
     * The parameter `outname' points to an area of storage
     * guaranteed to be at least FILENAME_MAX in size.
     */
    void (*filename) (char *inname, char *outname, efunc error);

    /*
     * This procedure is called after assembly finishes, to allow
     * the output driver to clean itself up and free its memory.
     * Typically, it will also be the point at which the object
     * file actually gets _written_.
     *
     * One thing the cleanup routine should always do is to close
     * the output file pointer.
     */
    void (*cleanup) (int debuginfo);
};

/*
 * values for the `type' parameter to an output function. Each one
 * must have the actual number of _bytes_ added to it.
 *
 * Exceptions are OUT_RELxADR, which denote an x-byte relocation
 * which will be a relative jump. For this we need to know the
 * distance in bytes from the start of the relocated record until
 * the end of the containing instruction. _This_ is what is stored
 * in the size part of the parameter, in this case.
 *
 * Also OUT_RESERVE denotes reservation of N bytes of BSS space,
 * and the contents of the "data" parameter is irrelevant.
 *
 * The "data" parameter for the output function points to a "long",
 * containing the address in question, unless the type is
 * OUT_RAWDATA, in which case it points to an "unsigned char"
 * array.
 */
#define OUT_RAWDATA 0x00000000UL
#define OUT_ADDRESS 0x10000000UL
#define OUT_REL2ADR 0x20000000UL
#define OUT_REL4ADR 0x30000000UL
#define OUT_RESERVE 0x40000000UL
#define OUT_TYPMASK 0xF0000000UL
#define OUT_SIZMASK 0x0FFFFFFFUL

/*
 * ------------------------------------------------------------
 * The data structure defining a debug format driver, and the
 * interfaces to the functions therein.
 * ------------------------------------------------------------
 */

struct dfmt {
    
    /*
     * This is a short (one-liner) description of the type of
     * output generated by the driver.
     */
    char *fullname;

    /*
     * This is a single keyword used to select the driver.
     */
    char *shortname;


    /*
     * init - called initially to set up local pointer to object format, 
     * void pointer to implementation defined data, file pointer (which
     * probably won't be used, but who knows?), and error function.
     */
    void (*init) (struct ofmt * of, void * id, FILE * fp, efunc error);

    /*
     * linenum - called any time there is output with a change of
     * line number or file.
     */
    void (*linenum) (const char * filename, long linenumber, long segto);

    /*
     * debug_deflabel - called whenever a label is defined. Parameters
     * are the same as to 'symdef()' in the output format. This function
     * would be called before the output format version.
     */

    void (*debug_deflabel) (char * name, long segment, long offset,
                            int is_global, char * special);
    /*
     * debug_directive - called whenever a DEBUG directive other than 'LINE'
     * is encountered. 'directive' contains the first parameter to the
     * DEBUG directive, and params contains the rest. For example,
     * 'DEBUG VAR _somevar:int' would translate to a call to this
     * function with 'directive' equal to "VAR" and 'params' equal to 
     * "_somevar:int".
     */
    void (*debug_directive) (const char * directive, const char * params);

    /*
     * typevalue - called whenever the assembler wishes to register a type
     * for the last defined label.  This routine MUST detect if a type was
     * already registered and not re-register it.
     */
    void (*debug_typevalue) (long type);

    /*
     * debug_output - called whenever output is required
     * 'type' is the type of info required, and this is format-specific
     */
    void (*debug_output) (int type, void *param);

    /*
     * cleanup - called after processing of file is complete
     */
    void (*cleanup) (void);

};
/*
 * The type definition macros
 * for debugging
 *
 * low 3 bits: reserved
 * next 5 bits: type
 * next 24 bits: number of elements for arrays (0 for labels)
 */

#define TY_UNKNOWN 0x00
#define TY_LABEL   0x08
#define TY_BYTE    0x10
#define TY_WORD    0x18
#define TY_DWORD   0x20
#define TY_FLOAT   0x28
#define TY_QWORD   0x30
#define TY_TBYTE   0x38
#define TY_COMMON  0xE0
#define TY_SEG     0xE8
#define TY_EXTERN  0xF0
#define TY_EQU     0xF8

#define TYM_TYPE(x) ((x) & 0xF8)
#define TYM_ELEMENTS(x) (((x) & 0xFFFFFF00) >> 8)

#define TYS_ELEMENTS(x)  ((x) << 8)
/*
 * -----
 * Other
 * -----
 */

/*
 * This is a useful #define which I keep meaning to use more often:
 * the number of elements of a statically defined array.
 */

#define elements(x)     ( sizeof(x) / sizeof(*(x)) )

#endif
