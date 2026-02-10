/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2009 The NASM Authors - All Rights Reserved */

/*
 * sync.h   header file for sync.c
 */

#ifndef NASM_SYNC_H
#define NASM_SYNC_H

void init_sync(void);
void add_sync(uint64_t position, uint64_t length);
uint64_t next_sync(uint64_t position, uint64_t *length);

#endif
