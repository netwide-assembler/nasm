/* parser.h   header file for the parser module of the Netwide
 *            Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_PARSER_H
#define NASM_PARSER_H

insn *parse_line (long segment, long offset, lfunc lookup_label, int pass,
		  char *buffer, insn *result, struct ofmt *output,
		  efunc error);
void cleanup_insn (insn *instruction);

#endif
