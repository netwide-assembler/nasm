/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
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
 * nasmlib.c	library routines for the Netwide Assembler
 */

#include "compiler.h"

#include <stdlib.h>

#include "nasmlib.h"

vefunc nasm_verror;    /* Global error handling function */

void nasm_error(int severity, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(severity, fmt, ap);
    va_end(ap);
}

no_return nasm_fatal(int flags, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(flags | ERR_FATAL, fmt, ap);
    abort();			/* We should never get here */
}

no_return nasm_panic(int flags, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(flags | ERR_PANIC, fmt, ap);
    abort();			/* We should never get here */
}

no_return nasm_panic_from_macro(const char *file, int line)
{
    nasm_panic(ERR_NOFILE, "Internal error at %s:%d\n", file, line);
}

no_return nasm_assert_failed(const char *file, int line, const char *msg)
{
    nasm_fatal(0, "assertion %s failed at %s:%d", msg, file, line);
}
