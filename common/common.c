/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2025 The NASM Authors - All Rights Reserved
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
 * common.c - code common to nasm and ndisasm
 */

#include "compiler.h"
#include "nasm.h"
#include "nasmlib.h"
#include "insns.h"

/*
 * The current bit size of the CPU
 */
int globalbits = 0;

/*
 * Name of a register token, if applicable; otherwise NULL
 */
const char *register_name(int token)
{
    if (is_register(token))
        return nasm_reg_names[token - EXPR_REG_START];
    else
        return NULL;
}

/*
 * Common list of prefix names; ideally should be auto-generated
 * from tokens.dat. This MUST match the enum in include/nasm.h.
 */
const char *prefix_name(int token)
{
    static const char * const
        prefix_names[PREFIX_ENUM_LIMIT - PREFIX_ENUM_START] = {
        "a16", "a32", "a64", "asp", "lock", "o16", "o32", "o64", "osp",
        "rep", "repe", "repne", "repnz", "repz", "wait",
        "xacquire", "xrelease", "bnd", "nobnd", "{rex}", "{rex2}",
        "{evex}", "{vex}", "{vex3}", "{vex2}", "{nf}", "{zu}",
        "{pt}", "{pn}"
    };
    const char *name;

    /* A register can also be a prefix */
    name = register_name(token);

    if (!name) {
        const unsigned int prefix = token - PREFIX_ENUM_START;
        if (prefix < ARRAY_SIZE(prefix_names))
            name = prefix_names[prefix];
    }

    return name;
}

/*
 * True for a valid hinting-NOP opcode, after 0F.
 */
bool is_hint_nop(uint64_t op)
{
    if (op >> 16)
        return false;

    if ((op >> 8) == 0x0f)
        op = (uint8_t)op;
    else if (op >> 8)
        return false;

    return ((op & ~7) == 0x18) || (op == 0x0d);
}
