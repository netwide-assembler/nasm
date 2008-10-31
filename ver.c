#include "nasm.h"
#include "version.h"

/* This is printed when entering nasm -v */
const char nasm_version[] = NASM_VER;
const char nasm_date[] = __DATE__;
const char nasm_compile_options[] = ""
#ifdef DEBUG
    " with -DDEBUG"
#endif
    ;

/* These are used by some backends. */
const char nasm_comment[] =
    "The Netwide Assembler " NASM_VER;

const char nasm_signature[] =
    "NASM " NASM_VER;
