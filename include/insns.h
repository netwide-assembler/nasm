/* insns.h   header file for insns.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the license given in the file "LICENSE"
 * distributed in the NASM archive.
 */

#ifndef NASM_INSNS_H
#define NASM_INSNS_H

#include "nasm.h"
#include "tokens.h"
#include "iflag.h"

/* if changed, ITEMPLATE_END should be also changed accordingly */
struct itemplate {
    enum opcode     opcode;             /* the token, passed from "parser.c" */
    int             operands;           /* number of operands */
    opflags_t       opd[MAX_OPERANDS];  /* bit flags for operand types */
    decoflags_t     deco[MAX_OPERANDS]; /* bit flags for operand decorators */
    const uint8_t   *code;              /* the code it assembles to */
    uint32_t        iflag_idx;          /* some flags referenced by index */
};

/* Disassembler table structure */

/*
 * If n == -1, then p points to another table of 256
 * struct disasm_index, otherwise p points to a list of n
 * struct itemplates to consider.
 */
struct disasm_index {
    const void *p;
    int n;
};

/* Tables for the assembler and disassembler, respectively */
extern const struct itemplate * const nasm_instructions[];
extern const struct disasm_index itable[256];
extern const struct disasm_index * const itable_vex[NASM_VEX_CLASSES][32][4];

/* Common table for the byte codes */
extern const uint8_t nasm_bytecodes[];

/*
 * this define is used to signify the end of an itemplate
 */
#define ITEMPLATE_END {I_none,0,{0,},{0,},NULL,0}

/* Width of Dx and RESx instructions */
int const_func idata_bytes(enum opcode opcode);
int const_func resv_bytes(enum opcode opcode);

/*
 * Pseudo-op tests
 */
/* DB-type instruction (DB, DW, ...) */
static inline bool opcode_is_db(enum opcode opcode)
{
    return idata_bytes(opcode) > 0;
}

/* RESB-type instruction (RESB, RESW, ...) */
static inline bool opcode_is_resb(enum opcode opcode)
{
    return resv_bytes(opcode) > 0;
}

#endif /* NASM_INSNS_H */
