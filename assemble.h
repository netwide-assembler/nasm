/* assemble.h  header file for assemble.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_ASSEMBLE_H
#define NASM_ASSEMBLE_H

long insn_size (long segment, long offset, int bits,
		insn *instruction, efunc error);
long assemble (long segment, long offset, int bits,
	       insn *instruction, struct ofmt *output, efunc error,
	       ListGen *listgen);

#endif
