/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2025 The NASM Authors - All Rights Reserved */

/*
 * diserror.c - stubs for the error functions for the disassembler
 */

#include "compiler.h"
#include "error.h"
#include "disasm.h"

void usage(void)
{
    const char help[] =
    "usage: ndisasm [-aihlruvw] [-b bits] [-o origin] [-s sync...]\n"
    "               [-e bytes] [-k start,bytes] [-p vendor] file\n"
    "   -a or -i activates auto (intelligent) sync\n"
    "   -b 16, -b 32 or -b 64 sets the processor mode\n"
    "   -u same as -b 32\n"
    "   -l same as -b 64\n"
    "   -w wide output (avoids continuation lines)\n"
    "   -h displays this text\n"
    "   -r or -v displays the version number\n"
    "   -e skips <bytes> bytes of header\n"
    "   -k avoids disassembling <bytes> bytes from position <start>\n"
    "   -p selects the preferred vendor instruction set (intel, amd, cyrix, idt)\n";

    fputs(help, stderr);
}

void nasm_verror(errflags severity, const char *fmt, va_list val)
{
    severity &= ERR_MASK;

    vfprintf(stderr, fmt, val);
    if (severity >= ERR_FATAL)
        exit(severity - ERR_FATAL + 1);
}

fatal_func nasm_verror_critical(errflags severity, const char *fmt, va_list val)
{
    nasm_verror(severity, fmt, val);
    abort();
}

uint8_t warning_state[NUM_WARNINGS];
