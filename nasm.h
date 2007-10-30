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

#include "compiler.h"

#include <stdio.h>
#include <inttypes.h>
#include "version.h"            /* generated NASM version macros */
#include "nasmlib.h"
#include "insnsi.h"		/* For enum opcode */

#define NO_SEG -1L              /* null segment value */
#define SEG_ABS 0x40000000L     /* mask for far-absolute segments */

#ifndef FILENAME_MAX
#define FILENAME_MAX 256
#endif

#ifndef PREFIX_MAX
#define PREFIX_MAX 10
#endif

#ifndef POSTFIX_MAX
#define POSTFIX_MAX 10
#endif

#define IDLEN_MAX 4096

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
 * -----------------------
 * Other function typedefs
 * -----------------------
 */

/*
 * A label-lookup function should look like this.
 */
typedef bool (*lfunc) (char *label, int32_t *segment, int32_t *offset);

/*
 * And a label-definition function like this. The boolean parameter
 * `is_norm' states whether the label is a `normal' label (which
 * should affect the local-label system), or something odder like
 * an EQU or a segment-base symbol, which shouldn't.
 */
typedef void (*ldfunc) (char *label, int32_t segment, int32_t offset,
                        char *special, bool is_norm, bool isextrn,
                        struct ofmt * ofmt, efunc error);

/*
 * List-file generators should look like this:
 */
typedef struct {
    /*
     * Called to initialize the listing file generator. Before this
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
    void (*output) (int32_t, const void *, uint32_t);

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
    int64_t t_integer, t_inttwo;
    char *t_charptr;
};
typedef int (*scanner) (void *private_data, struct tokenval * tv);

/*
 * Token types returned by the scanner, in addition to ordinary
 * ASCII character values, and zero for end-of-string.
 */
enum {                          /* token types, other than chars */
    TOKEN_INVALID = -1,         /* a placeholder value */
    TOKEN_EOS = 0,              /* end of string */
    TOKEN_EQ = '=', TOKEN_GT = '>', TOKEN_LT = '<',     /* aliases */
    TOKEN_ID = 256, TOKEN_NUM, TOKEN_REG, TOKEN_INSN,   /* major token types */
    TOKEN_ERRNUM,               /* numeric constant with error in */
    TOKEN_HERE, TOKEN_BASE,     /* $ and $$ */
    TOKEN_SPECIAL,              /* BYTE, WORD, DWORD, QWORD, FAR, NEAR, etc */
    TOKEN_PREFIX,               /* A32, O16, LOCK, REPNZ, TIMES, etc */
    TOKEN_SHL, TOKEN_SHR,       /* << and >> */
    TOKEN_SDIV, TOKEN_SMOD,     /* // and %% */
    TOKEN_GE, TOKEN_LE, TOKEN_NE,       /* >=, <= and <> (!= is same as <>) */
    TOKEN_DBL_AND, TOKEN_DBL_OR, TOKEN_DBL_XOR, /* &&, || and ^^ */
    TOKEN_SEG, TOKEN_WRT,       /* SEG and WRT */
    TOKEN_FLOAT,                /* floating-point constant */
    TOKEN_FLOATIZE,		/* __floatX__ */
};

enum floatize {
    FLOAT_8,
    FLOAT_16,
    FLOAT_32,
    FLOAT_64,
    FLOAT_80M,
    FLOAT_80E,
    FLOAT_128L,
    FLOAT_128H,
};

struct location {
    int64_t offset;
    int32_t segment;
    int known;
};

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
    int32_t type;                  /* a register, or EXPR_xxx */
    int64_t value;                 /* must be >= 32 bits */
} expr;

/*
 * Library routines to manipulate expression data types.
 */
int is_reloc(expr *);
int is_simple(expr *);
int is_really_simple(expr *);
int is_unknown(expr *);
int is_just_unknown(expr *);
int64_t reloc_value(expr *);
int32_t reloc_seg(expr *);
int32_t reloc_wrt(expr *);

/*
 * The evaluator can also return hints about which of two registers
 * used in an expression should be the base register. See also the
 * `operand' structure.
 */
struct eval_hints {
    int64_t base;
    int type;
};

/*
 * The actual expression evaluator function looks like this. When
 * called, it expects the first token of its expression to already
 * be in `*tv'; if it is not, set tv->t_type to TOKEN_INVALID and
 * it will start by calling the scanner.
 *
 * If a forward reference happens during evaluation, the evaluator
 * must set `*fwref' to true if `fwref' is non-NULL.
 *
 * `critical' is non-zero if the expression may not contain forward
 * references. The evaluator will report its own error if this
 * occurs; if `critical' is 1, the error will be "symbol not
 * defined before use", whereas if `critical' is 2, the error will
 * be "symbol undefined".
 *
 * If `critical' has bit 8 set (in addition to its main value: 0x101
 * and 0x102 correspond to 1 and 2) then an extended expression
 * syntax is recognised, in which relational operators such as =, <
 * and >= are accepted, as well as low-precedence logical operators
 * &&, ^^ and ||.
 *
 * If `hints' is non-NULL, it gets filled in with some hints as to
 * the base register in complex effective addresses.
 */
#define CRITICAL 0x100
typedef expr *(*evalfunc) (scanner sc, void *scprivate,
                           struct tokenval * tv, int *fwref, int critical,
                           efunc error, struct eval_hints * hints);

/*
 * Special values for expr->type.  These come after EXPR_REG_END
 * as defined in regs.h.
 */

#define EXPR_UNKNOWN	(EXPR_REG_END+1) /* forward references */
#define EXPR_SIMPLE	(EXPR_REG_END+2)
#define EXPR_WRT	(EXPR_REG_END+3)
#define EXPR_SEGBASE	(EXPR_REG_END+4)

/*
 * Preprocessors ought to look like this:
 */
typedef struct preproc_ops {
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
    void (*cleanup) (int);
} Preproc;

extern Preproc nasmpp;

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
#define isnumchar(c)   ( isalnum(c) || (c)=='_' )

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
 *
 * The basic concept here is that
 *    (class & ~operand) == 0
 *
 * if and only if "operand" belongs to class type "class".
 *
 * The bits are assigned as follows:
 *
 * Bits 0-7, 29: sizes
 *  0:  8 bits (BYTE)
 *  1: 16 bits (WORD)
 *  2: 32 bits (DWORD)
 *  3: 64 bits (QWORD)
 *  4: 80 bits (TWORD)
 *  5: FAR
 *  6: NEAR
 *  7: SHORT
 * 29: 128 bits (OWORD)
 *
 * Bits 8-11 modifiers
 *  8: TO
 *  9: COLON
 * 10: STRICT
 * 11: (reserved)
 *
 * Bits 12-15: type of operand
 * 12: REGISTER
 * 13: IMMEDIATE
 * 14: MEMORY (always has REGMEM attribute as well)
 * 15: REGMEM (valid EA operand)
 *
 * Bits 16-19: subclasses
 * With REG_CDT:
 * 16: REG_CREG (CRx)
 * 17: REG_DREG (DRx)
 * 18: REG_TREG (TRx)

 * With REG_GPR:
 * 16: REG_ACCUM (AL, AX, EAX, RAX)
 * 17: REG_COUNT (CL, CX, ECX, RCX)
 * 18: REG_DATA  (DL, DX, EDX, RDX)
 * 19: REG_HIGH  (AH, CH, DH, BH)
 *
 * With REG_SREG:
 * 16: REG_CS
 * 17: REG_DESS (DS, ES, SS)
 * 18: REG_FSGS
 * 19: REG_SEG67
 *
 * With FPUREG:
 * 16: FPU0
 *
 * With XMMREG:
 * 16: XMM0
 *
 * With MEMORY:
 * 16: MEM_OFFS (this is a simple offset)
 * 17: IP_REL (IP-relative offset)
 *
 * With IMMEDIATE:
 * 16: UNITY (1)
 * 17: BYTENESS (-128..127)
 *
 * Bits 20-26: register classes
 * 20: REG_CDT (CRx, DRx, TRx)
 * 21: RM_GPR (REG_GPR) (integer register)
 * 22: REG_SREG
 * 23: IP_REG (RIP or EIP) [unused]
 * 24: FPUREG
 * 25: RM_MMX (MMXREG)
 * 26: RM_XMM (XMMREG)
 *
 * Bits 27-29 & 31 are currently unallocated.
 *
 * 30: SAME_AS
 * Special flag only used in instruction patterns; means this operand
 * has to be identical to another operand.  Currently only supported
 * for registers.
 */

typedef uint32_t opflags_t;

/* Size, and other attributes, of the operand */
#define BITS8		0x00000001L
#define BITS16		0x00000002L
#define BITS32		0x00000004L
#define BITS64		0x00000008L   /* x64 and FPU only */
#define BITS80		0x00000010L   /* FPU only */
#define BITS128		0x20000000L
#define FAR		0x00000020L   /* grotty: this means 16:16 or */
                                       /* 16:32, like in CALL/JMP */
#define NEAR		0x00000040L
#define SHORT		0x00000080L   /* and this means what it says :) */

#define SIZE_MASK	0x200000FFL   /* all the size attributes */

/* Modifiers */
#define MODIFIER_MASK	0x00000f00L
#define TO		0x00000100L   /* reverse effect in FADD, FSUB &c */
#define COLON		0x00000200L   /* operand is followed by a colon */
#define STRICT		0x00000400L   /* do not optimize this operand */

/* Type of operand: memory reference, register, etc. */
#define OPTYPE_MASK	0x0000f000L
#define REGISTER	0x00001000L   /* register number in 'basereg' */
#define IMMEDIATE	0x00002000L
#define MEMORY		0x0000c000L
#define REGMEM		0x00008000L   /* for r/m, ie EA, operands */

/* Register classes */
#define REG_EA		0x00009000L   /* 'normal' reg, qualifies as EA */
#define RM_GPR		0x00208000L   /* integer operand */
#define REG_GPR		0x00209000L   /* integer register */
#define REG8		0x00209001L   /*  8-bit GPR  */
#define REG16		0x00209002L   /* 16-bit GPR */
#define REG32		0x00209004L   /* 32-bit GPR */
#define REG64		0x00209008L   /* 64-bit GPR */
#define IP_REG		0x00801000L   /* RIP or EIP register */
#define RIPREG		0x00801008L   /* RIP */
#define EIPREG		0x00801004L   /* EIP */
#define FPUREG		0x01001000L   /* floating point stack registers */
#define FPU0		0x01011000L   /* FPU stack register zero */
#define RM_MMX		0x02008000L   /* MMX operand */
#define MMXREG		0x02009000L   /* MMX register */
#define RM_XMM		0x04008000L   /* XMM (SSE) operand */
#define XMMREG		0x04009000L   /* XMM (SSE) register */
#define XMM0		0x04019000L   /* XMM register zero */
#define REG_CDT		0x00101004L   /* CRn, DRn and TRn */
#define REG_CREG	0x00111004L   /* CRn */
#define REG_DREG	0x00121004L   /* DRn */
#define REG_TREG	0x00141004L   /* TRn */
#define REG_SREG	0x00401002L   /* any segment register */
#define REG_CS		0x00411002L   /* CS */
#define REG_DESS	0x00421002L   /* DS, ES, SS */
#define REG_FSGS	0x00441002L   /* FS, GS */
#define REG_SEG67	0x00481002L   /* Unimplemented segment registers */

#define REG_RIP		0x00801008L   /* RIP relative addressing */
#define REG_EIP		0x00801004L   /* EIP relative addressing */

/* Special GPRs */
#define REG_SMASK	0x000f0000L   /* a mask for the following */
#define REG_ACCUM	0x00219000L   /* accumulator: AL, AX, EAX, RAX */
#define REG_AL		0x00219001L
#define REG_AX		0x00219002L
#define REG_EAX		0x00219004L
#define REG_RAX		0x00219008L
#define REG_COUNT	0x00229000L   /* counter: CL, CX, ECX, RCX */
#define REG_CL		0x00229001L
#define REG_CX		0x00229002L
#define REG_ECX		0x00229004L
#define REG_RCX		0x00229008L
#define REG_DL		0x00249001L   /* data: DL, DX, EDX, RDX */
#define REG_DX		0x00249002L
#define REG_EDX		0x00249004L
#define REG_RDX		0x00249008L
#define REG_HIGH	0x00289001L   /* high regs: AH, CH, DH, BH */

/* special types of EAs */
#define MEM_OFFS	0x0001c000L   /* simple [address] offset - absolute! */
#define IP_REL		0x0002c000L   /* IP-relative offset */

/* memory which matches any type of r/m operand */
#define MEMORY_ANY	(MEMORY|RM_GPR|RM_MMX|RM_XMM)

/* special type of immediate operand */
#define UNITY		0x00012000L   /* for shift/rotate instructions */
#define SBYTE		0x00022000L   /* for op r16/32,immediate instrs. */

/* special flags */
#define SAME_AS		0x40000000L

/* Register names automatically generated from regs.dat */
#include "regs.h"

enum ccode {			/* condition code names */
    C_A, C_AE, C_B, C_BE, C_C, C_E, C_G, C_GE, C_L, C_LE, C_NA, C_NAE,
    C_NB, C_NBE, C_NC, C_NE, C_NG, C_NGE, C_NL, C_NLE, C_NO, C_NP,
    C_NS, C_NZ, C_O, C_P, C_PE, C_PO, C_S, C_Z,
    C_none = -1
};

/*
 * REX flags
 */
#define REX_OC		0x0200	/* DREX suffix has the OC0 bit set */
#define REX_D		0x0100	/* Instruction uses DREX instead of REX */
#define REX_H		0x80	/* High register present, REX forbidden */
#define REX_P		0x40	/* REX prefix present/required */
#define REX_L		0x20	/* Use LOCK prefix instead of REX.R */
#define REX_W		0x08	/* 64-bit operand size */
#define REX_R		0x04	/* ModRM reg extension */
#define REX_X		0x02	/* SIB index extension */
#define REX_B		0x01	/* ModRM r/m extension */
#define REX_REAL	0x4f	/* Actual REX prefix bits */

/*
 * Note that because segment registers may be used as instruction
 * prefixes, we must ensure the enumerations for prefixes and
 * register names do not overlap.
 */
enum prefixes {			/* instruction prefixes */
    P_none = 0,
    PREFIX_ENUM_START = REG_ENUM_LIMIT,
    P_A16 = PREFIX_ENUM_START, P_A32, P_A64, P_ASP,
    P_LOCK, P_O16, P_O32, P_O64, P_OSP,
    P_REP, P_REPE, P_REPNE, P_REPNZ, P_REPZ, P_TIMES,
    PREFIX_ENUM_LIMIT
};

enum {                          /* extended operand types */
    EOT_NOTHING, EOT_DB_STRING, EOT_DB_NUMBER
};

enum {                          /* special EA flags */
    EAF_BYTEOFFS =  1,          /* force offset part to byte size */
    EAF_WORDOFFS =  2,          /* force offset part to [d]word size */
    EAF_TIMESTWO =  4,          /* really do EAX*2 not EAX+EAX */
    EAF_REL	 =  8,		/* IP-relative addressing */
    EAF_ABS      = 16,		/* non-IP-relative addressing */
    EAF_FSGS	 = 32		/* fs/gs segment override present */
};

enum eval_hint {                /* values for `hinttype' */
    EAH_NOHINT   = 0,           /* no hint at all - our discretion */
    EAH_MAKEBASE = 1,           /* try to make given reg the base */
    EAH_NOTBASE  = 2            /* try _not_ to make reg the base */
};

typedef struct operand {	/* operand to an instruction */
    int32_t type;               /* type of operand */
    int disp_size;              /* 0 means default; 16; 32; 64 */
    enum reg_enum basereg, indexreg; /* address registers */
    int scale;			/* index scale */
    int hintbase;
    enum eval_hint hinttype;    /* hint as to real base register */
    int32_t segment;            /* immediate segment, if needed */
    int64_t offset;             /* any immediate number */
    int32_t wrt;                /* segment base it's relative to */
    int eaflags;                /* special EA flags */
    int opflags;                /* see OPFLAG_* defines below */
} operand;

#define OPFLAG_FORWARD		1       /* operand is a forward reference */
#define OPFLAG_EXTERN		2       /* operand is an external reference */

typedef struct extop {          /* extended operand */
    struct extop *next;         /* linked list */
    int32_t type;               /* defined above */
    char *stringval;          /* if it's a string, then here it is */
    int stringlen;              /* ... and here's how long it is */
    int32_t segment;            /* if it's a number/address, then... */
    int64_t offset;             /* ... it's given here ... */
    int32_t wrt;                /* ... and here */
} extop;

/* Prefix positions: each type of prefix goes in a specific slot.
   This affects the final ordering of the assembled output, which
   shouldn't matter to the processor, but if you have stylistic
   preferences, you can change this.  REX prefixes are handled
   differently for the time being.

   Note that LOCK and REP are in the same slot.  This is
   an x86 architectural constraint. */
enum prefix_pos {
    PPS_LREP,			/* Lock or REP prefix */
    PPS_SEG,			/* Segment override prefix */
    PPS_OSIZE,			/* Operand size prefix */
    PPS_ASIZE,			/* Address size prefix */
    MAXPREFIX			/* Total number of prefix slots */
};

#define MAX_OPERANDS 4

typedef struct insn {		/* an instruction itself */
    char *label;		/* the label defined, or NULL */
    enum prefixes prefixes[MAXPREFIX]; /* instruction prefixes, if any */
    enum opcode opcode;         /* the opcode - not just the string */
    enum ccode condition;       /* the condition code, if Jcc/SETcc */
    int operands;               /* how many operands? 0-3
                                 * (more if db et al) */
    int addr_size;		/* address size */
    operand oprs[MAX_OPERANDS]; /* the operands, defined as above */
    extop *eops;                /* extended operands */
    int eops_float;             /* true if DD and floating */
    int32_t times;              /* repeat count (TIMES prefix) */
    int forw_ref;               /* is there a forward reference? */
    int rex;			/* Special REX Prefix */
    int drexdst;		/* Destination register for DREX suffix */
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
    const char *fullname;

    /*
     * This is a single keyword used to select the driver.
     */
    const char *shortname;


    /*
     * this is reserved for out module specific help.
     * It is set to NULL in all the out modules and is not implemented
     * in the main program
     */
    const char *helpstring;

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
    const char **stdmac;

    /*
     * This procedure is called at the start of an output session.
     * It tells the output format what file it will be writing to,
     * what routine to report errors through, and how to interface
     * to the label manager and expression evaluator if necessary.
     * It also gives it a chance to do other initialisation.
     */
    void (*init) (FILE * fp, efunc error, ldfunc ldef, evalfunc eval);

    /*
     * This procedure is called to pass generic information to the
     * object file.  The first parameter gives the information type
     * (currently only command line switches)
     * and the second parameter gives the value.  This function returns
     * 1 if recognized, 0 if unrecognized
     */
    int (*setinfo) (enum geninfo type, char **string);

    /*
     * This procedure is called by assemble() to write actual
     * generated code or data to the object file. Typically it
     * doesn't have to actually _write_ it, just store it for
     * later.
     *
     * The `type' argument specifies the type of output data, and
     * usually the size as well: its contents are described below.
     */
    void (*output) (int32_t segto, const void *data, uint32_t type,
                    int32_t segment, int32_t wrt);

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
    void (*symdef) (char *name, int32_t segment, int32_t offset,
		    int is_global, char *special);

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
    int32_t (*section) (char *name, int pass, int *bits);

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
    int32_t (*segbase) (int32_t segment);

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
     * properly initialized, it has to be passed its error handler
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
 * The "data" parameter for the output function points to a "int32_t",
 * containing the address in question, unless the type is
 * OUT_RAWDATA, in which case it points to an "uint8_t"
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
    const char *fullname;

    /*
     * This is a single keyword used to select the driver.
     */
    const char *shortname;

    /*
     * init - called initially to set up local pointer to object format,
     * void pointer to implementation defined data, file pointer (which
     * probably won't be used, but who knows?), and error function.
     */
    void (*init) (struct ofmt * of, void *id, FILE * fp, efunc error);

    /*
     * linenum - called any time there is output with a change of
     * line number or file.
     */
    void (*linenum) (const char *filename, int32_t linenumber, int32_t segto);

    /*
     * debug_deflabel - called whenever a label is defined. Parameters
     * are the same as to 'symdef()' in the output format. This function
     * would be called before the output format version.
     */

    void (*debug_deflabel) (char *name, int32_t segment, int32_t offset,
                            int is_global, char *special);
    /*
     * debug_directive - called whenever a DEBUG directive other than 'LINE'
     * is encountered. 'directive' contains the first parameter to the
     * DEBUG directive, and params contains the rest. For example,
     * 'DEBUG VAR _somevar:int' would translate to a call to this
     * function with 'directive' equal to "VAR" and 'params' equal to
     * "_somevar:int".
     */
    void (*debug_directive) (const char *directive, const char *params);

    /*
     * typevalue - called whenever the assembler wishes to register a type
     * for the last defined label.  This routine MUST detect if a type was
     * already registered and not re-register it.
     */
    void (*debug_typevalue) (int32_t type);

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
#define TY_OWORD   0x40
#define TY_COMMON  0xE0
#define TY_SEG     0xE8
#define TY_EXTERN  0xF0
#define TY_EQU     0xF8

#define TYM_TYPE(x) ((x) & 0xF8)
#define TYM_ELEMENTS(x) (((x) & 0xFFFFFF00) >> 8)

#define TYS_ELEMENTS(x)  ((x) << 8)

/*
 * -----
 * Special tokens
 * -----
 */

enum special_tokens {
    SPECIAL_ENUM_START = PREFIX_ENUM_LIMIT,
    S_ABS = SPECIAL_ENUM_START,
    S_BYTE, S_DWORD, S_FAR, S_LONG, S_NEAR, S_NOSPLIT,
    S_OWORD, S_QWORD, S_REL, S_SHORT, S_STRICT, S_TO, S_TWORD, S_WORD,
    SPECIAL_ENUM_LIMIT
};

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

/*
 * -----
 * Global modes
 * -----
 */

/*
 * This declaration passes the "pass" number to all other modules
 * "pass0" assumes the values: 0, 0, ..., 0, 1, 2
 * where 0 = optimizing pass
 *       1 = pass 1
 *       2 = pass 2
 */

extern int pass0;

extern bool tasm_compatible_mode;
extern int optimizing;
extern int globalbits;          /* 16, 32 or 64-bit mode */
extern int globalrel;		/* default to relative addressing? */
extern int maxbits;		/* max bits supported by output */

#endif
