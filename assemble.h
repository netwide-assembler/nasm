/* assemble.h  header file for assemble.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_ASSEMBLE_H
#define NASM_ASSEMBLE_H

int32_t insn_size(int32_t segment, int32_t offset, int bits, uint32_t cp,
               insn * instruction, efunc error);
int32_t assemble(int32_t segment, int32_t offset, int bits, uint32_t cp,
              insn * instruction, struct ofmt *output, efunc error,
              ListGen * listgen);

#endif
