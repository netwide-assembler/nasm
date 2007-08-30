/* stdscan.h	header file for stdscan.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_STDSCAN_H
#define NASM_STDSCAN_H
/*
 * Standard scanner.
 */
extern char *stdscan_bufptr;
void stdscan_reset(void);
int stdscan(void *private_data, struct tokenval *tv);
int nasm_token_hash(const char *token, struct tokenval *tv);
void stdscan_cleanup(void);

#endif
