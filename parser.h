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

void parser_global_info (struct ofmt *output, loc_t *locp);
insn *parse_line (int pass, char *buffer, insn *result,
		  efunc error, evalfunc evaluate, ldfunc ldef);
void cleanup_insn (insn *instruction);

#endif
