/* float.h   header file for the floating-point constant module of
 *	     the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_FLOAT_H
#define NASM_FLOAT_H

enum float_round {
    FLOAT_RC_NEAR,
    FLOAT_RC_ZERO,
    FLOAT_RC_DOWN,
    FLOAT_RC_UP,
};

int float_const(const char *string, int sign, uint8_t *result, int bytes,
                efunc error);
int float_option(const char *option);

#endif
