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
 * disasm.h   header file for disasm.c
 */

#ifndef NASM_DISASM_H
#define NASM_DISASM_H

#include "nasm.h"
#include "insnsi.h"
#include "iflag.h"

/*
 * This buffer must be at least twice as long as the max instruction,
 * which must include the WAIT pseudo-prefix, for a total of 15+1 = 16
 * bytes.
 */
#define INSN_MAX 32

int32_t disasm(const uint8_t *dp, int32_t data_size,
               char *output, int outbufsize,
               int segsize, int64_t offset, int autosync,
               iflag_t *prefer);
int32_t eatbyte(uint8_t byte, char *output, int outbufsize, int segsize);

/* The rex types that matter for the purpose of decoding */
enum rextype {
    REX_NONE,
    REX_REX,
    REX_REX2,
    REX_VEX,                    /* Includes XOP */
    REX_EVEX
};

/*
 * Prefix information
 */
struct rexfields {
    uint32_t raw;               /* Raw value */
    uint32_t flags;             /* REX_ flags from nasm.h */
    enum rextype type;
    uint8_t len;                /* Length of REX prefix */
    uint8_t breg;               /* B register */
    uint8_t bregbv;             /* B register if B is a vector */
    uint8_t xreg;               /* X register */
    uint8_t xregxv;             /* X register if X is a vector */
    uint8_t vreg;               /* V register */
    uint8_t vregxv;             /* V register if X is a vector */
    uint8_t rreg;
    uint8_t opc;                /* Masked opcode */
    uint8_t map;
    uint8_t xmap;               /* Extended map (base from insnsi.h added) */
    uint8_t pp;
    uint8_t w;
    uint8_t l;
    uint8_t z;
    uint8_t b;
    uint8_t nd;
    uint8_t zu;
    uint8_t aaa;
    uint8_t nf;
    uint8_t dfl;
    uint8_t scc;
};

struct prefix_info {
    uint8_t osize;              /* Operand size */
    uint8_t asize;              /* Address size */
    uint8_t osp;                /* Operand size prefix present */
    uint8_t asp;                /* Address size prefix present */
    uint8_t rep;                /* Rep prefix present */
    uint8_t seg;                /* Segment override prefix present */
    uint8_t wait;               /* WAIT "prefix" present */
    uint8_t lock;               /* Lock prefix present */
    enum reg_enum segover;      /* Segment override register enum */
    struct rexfields rex;       /* REX/REX2/VEX/EVEX */
};

const uint8_t *parse_prefixes(struct prefix_info *pf, const uint8_t *data,
                              int bits);

#define fetch_safe(_start, _ptr, _size, _need, _op)         \
    do {                                                    \
        if (((_ptr) - (_start)) >= ((_size) - (_need)))     \
            _op;                                            \
    } while (0)

#endif
