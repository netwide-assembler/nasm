/* float.h   header file for the floating-point constant module of
 * 	     the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_FLOAT_H
#define NASM_FLOAT_H

int float_const (char *number, long sign, unsigned char *result, int bytes,
		 efunc error);

#endif
