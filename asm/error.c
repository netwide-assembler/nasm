/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2018 The NASM Authors - All Rights Reserved
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
 * error.c - error message handling routines for the assembler
 */

#include "compiler.h"

#include <stdlib.h>

#include "nasmlib.h"
#include "error.h"

/*
 * Description of the suppressible warnings for the command line and
 * the [warning] directive.
 */
#define on	(WARN_ST_ENABLED)
#define off	0
#define err	(WARN_ST_ENABLED|WARN_ST_ERROR)

const struct warning warnings[WARN_ALL+1] = {
    {NULL, NULL, on},	/* must be on - used for unconditional enable */
    {"macro-params", "macro calls with wrong parameter count", on},
    {"macro-selfref", "cyclic macro references", off},
    {"macro-defaults", "macros with more default than optional parameters", on},
    {"orphan-labels", "labels alone on lines without trailing `:'", on},
    {"number-overflow", "numeric constant does not fit", on},
    {"gnu-elf-extensions", "using 8- or 16-bit relocation in ELF32, a GNU extension", off},
    {"float-overflow", "floating point overflow", on},
    {"float-denorm", "floating point denormal", off},
    {"float-underflow", "floating point underflow", off},
    {"float-toolong", "too many digits in floating-point number", on},
    {"user", "%warning directives", on},
    {"lock", "lock prefix on unlockable instructions", on},
    {"hle", "invalid hle prefixes", on},
    {"bnd", "invalid bnd prefixes", on},
    {"zext-reloc", "relocation zero-extended to match output format", on},
    {"ptr", "non-NASM keyword used in other assemblers", on},
    {"bad-pragma", "empty or malformed %pragma", off},
    {"unknown-pragma", "unknown %pragma facility or directive", off},
    {"not-my-pragma", "%pragma not applicable to this compilation", off},
    {"unknown-warning", "unknown warning in -W/-w or warning directive", off},
    {"negative-rep", "regative %rep count", on},
    {"phase", "phase error during stabilization", off},
    {"label-redef", "label redefined to an identical value", off},
    {"label-redef-late", "label (re)defined during code generation", err},

    /* THESE ENTRIES SHOULD COME LAST */
    {"other", "any warning not specifially mentioned above", on},
    {"all", "all possible warnings", off}
};

uint8_t warning_state[WARN_ALL];/* Current state */
uint8_t warning_state_init[WARN_ALL]; /* Command-line state, for reset */

vefunc nasm_verror;    /* Global error handling function */

void nasm_error(int severity, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(severity, fmt, ap);
    va_end(ap);
}

fatal_func nasm_fatal(int flags, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(flags | ERR_FATAL, fmt, ap);
    abort();			/* We should never get here */
}

fatal_func nasm_panic(int flags, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(flags | ERR_PANIC, fmt, ap);
    abort();			/* We should never get here */
}

fatal_func nasm_panic_from_macro(const char *file, int line)
{
    nasm_panic(ERR_NOFILE, "Internal error at %s:%d\n", file, line);
}

fatal_func nasm_assert_failed(const char *file, int line, const char *msg)
{
    nasm_panic(0, "assertion %s failed at %s:%d", msg, file, line);
}

/*
 * This is called when processing a -w or -W option, or a warning directive.
 * Returns on if if the action was successful.
 */
bool set_warning_status(const char *value)
{
    enum warn_action { WID_OFF, WID_ON, WID_RESET };
    enum warn_action action;
    uint8_t mask;
    int i;
    bool ok = false;

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

    /* This is inefficient, but it shouldn't matter... */
    for (i = 1; i < WARN_ALL; i++) {
        if (!value || !nasm_stricmp(value, warnings[i].name)) {
            ok = true;          /* At least one action taken */
            switch (action) {
            case WID_OFF:
                warning_state[i] &= ~mask;
                break;
            case WID_ON:
                warning_state[i] |= mask;
                break;
            case WID_RESET:
                warning_state[i] &= ~mask;
                warning_state[i] |= warning_state_init[i] & mask;
                break;
            }
        }
    }

    return ok;
}
