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
 * Common list of prefix names; ideally should be auto-generated
 * from tokens.dat
 */
const char *prefix_name(int token)
{
    static const char *prefix_names[] = {
        "a16", "a32", "a64", "asp", "lock", "o16", "o32", "o64", "osp",
        "rep", "repe", "repne", "repnz", "repz", "times", "wait",
        "xacquire", "xrelease", "bnd"
    };
    unsigned int prefix = token-PREFIX_ENUM_START;

    if (prefix >= ARRAY_SIZE(prefix_names))
	return NULL;

    return prefix_names[prefix];
}

/*
 * initialized data bytes length from opcode
 */
int idata_bytes(int opcode)
{
    switch (opcode) {
    case I_DB:
        return 1;
    case I_DW:
        return 2;
    case I_DD:
        return 4;
    case I_DQ:
        return 8;
    case I_DT:
        return 10;
    case I_DO:
        return 16;
    case I_DY:
        return 32;
    case I_DZ:
        return 64;
    case I_none:
        return -1;
    default:
        return 0;
    }
}

/*
 * Uninitialized data bytes length from opcode
 */
int resv_bytes(int opcode)
{
    switch (opcode) {
    case I_RESB:
        return 1;
    case I_RESW:
        return 2;
    case I_RESD:
        return 4;
    case I_RESQ:
        return 8;
    case I_REST:
        return 10;
    case I_RESO:
        return 16;
    case I_RESY:
        return 32;
    case I_RESZ:
        return 64;
    case I_none:
        return -1;
    default:
        return 0;
    }
}
