/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2010 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

#ifndef PECOFF_H
#define PECOFF_H

/*
 * Machine types
 */
#define IMAGE_FILE_MACHINE_UNKNOWN      0x000
#define IMAGE_FILE_MACHINE_ALPHA        0x184
#define IMAGE_FILE_MACHINE_ARM          0x1c0
#define IMAGE_FILE_MACHINE_ALPHA64      0x284
#define IMAGE_FILE_MACHINE_I386         0x14c
#define IMAGE_FILE_MACHINE_IA64         0x200
#define IMAGE_FILE_MACHINE_M68K         0x268
#define IMAGE_FILE_MACHINE_MIPS16       0x266
#define IMAGE_FILE_MACHINE_MIPSFPU      0x366
#define IMAGE_FILE_MACHINE_MIPSFPU16    0x466
#define IMAGE_FILE_MACHINE_POWERPC      0x1f0
#define IMAGE_FILE_MACHINE_R3000        0x162
#define IMAGE_FILE_MACHINE_R4000        0x166
#define IMAGE_FILE_MACHINE_R10000       0x168
#define IMAGE_FILE_MACHINE_SH3          0x1a2
#define IMAGE_FILE_MACHINE_SH4          0x1a6
#define IMAGE_FILE_MACHINE_THUMB        0x1c2
#define IMAGE_FILE_MACHINE_MASK         0xfff

/*
 * Section flags
 */
#define IMAGE_SCN_TYPE_REG                      0x00000000
#define IMAGE_SCN_TYPE_DSECT                    0x00000001
#define IMAGE_SCN_TYPE_NOLOAD                   0x00000002
#define IMAGE_SCN_TYPE_GROUP                    0x00000004
#define IMAGE_SCN_TYPE_NO_PAD                   0x00000008
#define IMAGE_SCN_TYPE_COPY                     0x00000010

#define IMAGE_SCN_CNT_CODE                      0x00000020
#define IMAGE_SCN_CNT_INITIALIZED_DATA          0x00000040
#define IMAGE_SCN_CNT_UNINITIALIZED_DATA        0x00000080

#define IMAGE_SCN_LNK_OTHER                     0x00000100
#define IMAGE_SCN_LNK_INFO                      0x00000200
#define IMAGE_SCN_TYPE_OVER                     0x00000400
#define IMAGE_SCN_LNK_REMOVE                    0x00000800
#define IMAGE_SCN_LNK_COMDAT                    0x00001000

#define IMAGE_SCN_MEM_FARDATA                   0x00008000
#define IMAGE_SCN_MEM_PURGEABLE                 0x00020000
#define IMAGE_SCN_MEM_16BIT                     0x00020000
#define IMAGE_SCN_MEM_LOCKED                    0x00040000
#define IMAGE_SCN_MEM_PRELOAD                   0x00080000

#define IMAGE_SCN_ALIGN_1BYTES                  0x00100000
#define IMAGE_SCN_ALIGN_2BYTES                  0x00200000
#define IMAGE_SCN_ALIGN_4BYTES                  0x00300000
#define IMAGE_SCN_ALIGN_8BYTES                  0x00400000
#define IMAGE_SCN_ALIGN_16BYTES                 0x00500000
#define IMAGE_SCN_ALIGN_32BYTES                 0x00600000
#define IMAGE_SCN_ALIGN_64BYTES                 0x00700000
#define IMAGE_SCN_ALIGN_128BYTES                0x00800000
#define IMAGE_SCN_ALIGN_256BYTES                0x00900000
#define IMAGE_SCN_ALIGN_512BYTES                0x00a00000
#define IMAGE_SCN_ALIGN_1024BYTES               0x00b00000
#define IMAGE_SCN_ALIGN_2048BYTES               0x00c00000
#define IMAGE_SCN_ALIGN_4096BYTES               0x00d00000
#define IMAGE_SCN_ALIGN_8192BYTES               0x00e00000
#define IMAGE_SCN_ALIGN_MASK                    0x00f00000

#define IMAGE_SCN_LNK_NRELOC_OVFL               0x01000000
#define IMAGE_SCN_MEM_DISCARDABLE               0x02000000
#define IMAGE_SCN_MEM_NOT_CACHED                0x04000000
#define IMAGE_SCN_MEM_NOT_PAGED                 0x08000000
#define IMAGE_SCN_MEM_SHARED                    0x10000000
#define IMAGE_SCN_MEM_EXECUTE                   0x20000000
#define IMAGE_SCN_MEM_READ                      0x40000000
#define IMAGE_SCN_MEM_WRITE                     0x80000000

#endif /* PECOFF_H */