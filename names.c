/* names.c   included source file defining instruction and register
 *           names for the Netwide [Dis]Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

static char *reg_names[] = {	       /* register names, as strings */
    "ah", "al", "ax", "bh", "bl", "bp", "bx", "ch", "cl",
    "cr0", "cr2", "cr3", "cr4", "cs", "cx", "dh", "di", "dl", "dr0",
    "dr1", "dr2", "dr3", "dr6", "dr7", "ds", "dx", "eax", "ebp",
    "ebx", "ecx", "edi", "edx", "es", "esi", "esp", "fs", "gs",
    "mm0", "mm1", "mm2", "mm3", "mm4", "mm5", "mm6", "mm7", "si",
    "sp", "ss", "st0", "st1", "st2", "st3", "st4", "st5", "st6",
    "st7", "tr3", "tr4", "tr5", "tr6", "tr7"
};

static char *insn_names[] = {	       /* instruction names, as strings */
    "aaa", "aad", "aam", "aas", "adc", "add", "and", "arpl",
    "bound", "bsf", "bsr", "bswap", "bt", "btc", "btr", "bts",
    "call", "cbw", "cdq", "clc", "cld", "cli", "clts", "cmc", "cmp",
    "cmpsb", "cmpsd", "cmpsw", "cmpxchg", "cmpxchg486", "cmpxchg8b",
    "cpuid", "cwd", "cwde", "daa", "das", "db", "dd", "dec", "div",
    "dq", "dt", "dw", "emms", "enter", "equ", "f2xm1", "fabs",
    "fadd", "faddp", "fbld", "fbstp", "fchs", "fclex", "fcmovb",
    "fcmovbe", "fcmove", "fcmovnb", "fcmovnbe", "fcmovne",
    "fcmovnu", "fcmovu", "fcom", "fcomi", "fcomip", "fcomp",
    "fcompp", "fcos", "fdecstp", "fdisi", "fdiv", "fdivp", "fdivr",
    "fdivrp", "feni", "ffree", "fiadd", "ficom", "ficomp", "fidiv",
    "fidivr", "fild", "fimul", "fincstp", "finit", "fist", "fistp",
    "fisub", "fisubr", "fld", "fld1", "fldcw", "fldenv", "fldl2e",
    "fldl2t", "fldlg2", "fldln2", "fldpi", "fldz", "fmul", "fmulp",
    "fnclex", "fndisi", "fneni", "fninit", "fnop", "fnsave",
    "fnstcw", "fnstenv", "fnstsw", "fpatan", "fprem", "fprem1",
    "fptan", "frndint", "frstor", "fsave", "fscale", "fsetpm",
    "fsin", "fsincos", "fsqrt", "fst", "fstcw", "fstenv", "fstp",
    "fstsw", "fsub", "fsubp", "fsubr", "fsubrp", "ftst", "fucom",
    "fucomi", "fucomip", "fucomp", "fucompp", "fxam", "fxch",
    "fxtract", "fyl2x", "fyl2xp1", "hlt", "ibts", "icebp", "idiv",
    "imul", "in", "inc", "incbin", "insb", "insd", "insw", "int",
    "int1", "int01", "int3", "into", "invd", "invlpg", "iret",
    "iretd", "iretw", "jcxz", "jecxz", "jmp", "lahf", "lar", "lds",
    "lea", "leave", "les", "lfs", "lgdt", "lgs", "lidt", "lldt",
    "lmsw", "loadall", "loadall286", "lodsb", "lodsd", "lodsw",
    "loop", "loope", "loopne", "loopnz", "loopz", "lsl", "lss",
    "ltr", "mov", "movd", "movq", "movsb", "movsd", "movsw",
    "movsx", "movzx", "mul", "neg", "nop", "not", "or", "out",
    "outsb", "outsd", "outsw", "packssdw", "packsswb", "packuswb",
    "paddb", "paddd", "paddsb", "paddsiw", "paddsw", "paddusb",
    "paddusw", "paddw", "pand", "pandn", "paveb", "pcmpeqb",
    "pcmpeqd", "pcmpeqw", "pcmpgtb", "pcmpgtd", "pcmpgtw",
    "pdistib", "pmachriw", "pmaddwd", "pmagw", "pmulhrw",
    "pmulhriw", "pmulhw", "pmullw", "pmvgezb", "pmvlzb", "pmvnzb",
    "pmvzb", "pop", "popa", "popad", "popaw", "popf", "popfd",
    "popfw", "por", "pslld", "psllq", "psllw", "psrad", "psraw",
    "psrld", "psrlq", "psrlw", "psubb", "psubd", "psubsb",
    "psubsiw", "psubsw", "psubusb", "psubusw", "psubw", "punpckhbw",
    "punpckhdq", "punpckhwd", "punpcklbw", "punpckldq", "punpcklwd",
    "push", "pusha", "pushad", "pushaw", "pushf", "pushfd",
    "pushfw", "pxor", "rcl", "rcr", "rdmsr", "rdpmc", "rdtsc",
    "resb", "resd", "resq", "rest", "resw", "ret", "retf", "retn",
    "rol", "ror", "rsm", "sahf", "sal", "salc", "sar", "sbb",
    "scasb", "scasd", "scasw", "sgdt", "shl", "shld", "shr", "shrd",
    "sidt", "sldt", "smi", "smsw", "stc", "std", "sti", "stosb",
    "stosd", "stosw", "str", "sub", "test", "umov", "verr", "verw",
    "wait", "wbinvd", "wrmsr", "xadd", "xbts", "xchg", "xlatb",
    "xor"
};

static char *icn[] = {		       /* conditional instructions */
    "cmov", "j", "set"
};

static int ico[] = {		       /* and the corresponding opcodes */
    I_CMOVcc, I_Jcc, I_SETcc
};

static char *conditions[] = {	       /* condition code names */
    "a", "ae", "b", "be", "c", "e", "g", "ge", "l", "le", "na", "nae",
    "nb", "nbe", "nc", "ne", "ng", "nge", "nl", "nle", "no", "np",
    "ns", "nz", "o", "p", "pe", "po", "s", "z"
};
