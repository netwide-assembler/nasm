/* sync.h   header file for sync.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_SYNC_H
#define NASM_SYNC_H

void init_sync(void);
void add_sync(uint32_t position, uint32_t length);
uint32_t next_sync(uint32_t position, uint32_t *length);

#endif
