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
#define IMAGE_FILE_MACHINE_UNKNOWN      0x0000
#define IMAGE_FILE_MACHINE_AM33         0x01d3
#define IMAGE_FILE_MACHINE_AMD64        0x8664
#define IMAGE_FILE_MACHINE_EBC          0x0ebc
#define IMAGE_FILE_MACHINE_M32R         0x9041
#define IMAGE_FILE_MACHINE_ALPHA        0x0184
#define IMAGE_FILE_MACHINE_ARM          0x01c0
#define IMAGE_FILE_MACHINE_ALPHA64      0x0284
#define IMAGE_FILE_MACHINE_I386         0x014c
#define IMAGE_FILE_MACHINE_IA64         0x0200
#define IMAGE_FILE_MACHINE_M68K         0x0268
#define IMAGE_FILE_MACHINE_MIPS16       0x0266
#define IMAGE_FILE_MACHINE_MIPSFPU      0x0366
#define IMAGE_FILE_MACHINE_MIPSFPU16    0x0466
#define IMAGE_FILE_MACHINE_POWERPC      0x01f0
#define IMAGE_FILE_MACHINE_POWERPCFP    0x01f1
#define IMAGE_FILE_MACHINE_R3000        0x0162
#define IMAGE_FILE_MACHINE_R4000        0x0166
#define IMAGE_FILE_MACHINE_R10000       0x0168
#define IMAGE_FILE_MACHINE_SH3          0x01a2
#define IMAGE_FILE_MACHINE_SH3DSP       0x01a3
#define IMAGE_FILE_MACHINE_SH4          0x01a6
#define IMAGE_FILE_MACHINE_SH5          0x01a8
#define IMAGE_FILE_MACHINE_THUMB        0x01c2
#define IMAGE_FILE_MACHINE_WCEMIPSV2    0x0169
#define IMAGE_FILE_MACHINE_MASK         0xffff

/*
 * Characteristics
 */
#define IMAGE_FILE_RELOCS_STRIPPED              0x0001
#define IMAGE_FILE_EXECUTABLE_IMAGE             0x0002
#define IMAGE_FILE_LINE_NUMS_STRIPPED           0x0004
#define IMAGE_FILE_LOCAL_SYMS_STRIPPED          0x0008
#define IMAGE_FILE_AGGRESSIVE_WS_TRIM           0x0010
#define IMAGE_FILE_LARGE_ADDRESS_AWARE          0x0020
#define IMAGE_FILE_BYTES_REVERSED_LO            0x0080
#define IMAGE_FILE_32BIT_MACHINE                0x0100
#define IMAGE_FILE_DEBUG_STRIPPED               0x0200
#define IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP      0x0400
#define IMAGE_FILE_NET_RUN_FROM_SWAP            0x0800
#define IMAGE_FILE_SYSTEM                       0x1000
#define IMAGE_FILE_DLL                          0x2000
#define IMAGE_FILE_UP_SYSTEM_ONLY               0x4000
#define IMAGE_FILE_BYTES_REVERSED_HI            0x8000

/*
 * Windows subsystem
 */
#define IMAGE_SUBSYSTEM_UNKNOWN                 0
#define IMAGE_SUBSYSTEM_NATIVE                  1
#define IMAGE_SUBSYSTEM_WINDOWS_GUI             2
#define IMAGE_SUBSYSTEM_WINDOWS_CUI             3
#define IMAGE_SUBSYSTEM_POSIX_CUI               7
#define IMAGE_SUBSYSTEM_WINDOWS_CE_GUI          9
#define IMAGE_SUBSYSTEM_EFI_APPLICATION         10
#define IMAGE_SUBSYSTEM_EFI_BOOT_SERVICE_DRIVER 11
#define IMAGE_SUBSYSTEM_EFI_RUNTIME_DRIVER      12
#define IMAGE_SUBSYSTEM_EFI_ROM                 13
#define IMAGE_SUBSYSTEM_XBOX                    14

/*
 * DLL characteristics
 */
#define IMAGE_DLL_CHARACTERISTICS_DYNAMIC_BASE          0x0040
#define IMAGE_DLL_CHARACTERISTICS_FORCE_INTEGRITY       0x0080
#define IMAGE_DLL_CHARACTERISTICS_NX_COMPAT             0x0100
#define IMAGE_DLLCHARACTERISTICS_NO_ISOLATION           0x0200
#define IMAGE_DLLCHARACTERISTICS_NO_SEH                 0x0400
#define IMAGE_DLLCHARACTERISTICS_NO_BIND                0x0800
#define IMAGE_DLLCHARACTERISTICS_WDM_DRIVER             0x2000
#define IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE  0x8000

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

/*
 * Relocation type x86-64
 */
#define IMAGE_REL_AMD64_ABSOLUTE        0x0000
#define IMAGE_REL_AMD64_ADDR64          0x0001
#define IMAGE_REL_AMD64_ADDR32          0x0002
#define IMAGE_REL_AMD64_ADDR32NB        0x0003
#define IMAGE_REL_AMD64_REL32           0x0004
#define IMAGE_REL_AMD64_REL32_1         0x0005
#define IMAGE_REL_AMD64_REL32_2         0x0006
#define IMAGE_REL_AMD64_REL32_3         0x0007
#define IMAGE_REL_AMD64_REL32_4         0x0008
#define IMAGE_REL_AMD64_REL32_5         0x0009
#define IMAGE_REL_AMD64_SECTION         0x000a
#define IMAGE_REL_AMD64_SECREL          0x000b
#define IMAGE_REL_AMD64_SECREL7         0x000c
#define IMAGE_REL_AMD64_TOKEN           0x000d
#define IMAGE_REL_AMD64_SREL32          0x000e
#define IMAGE_REL_AMD64_PAIR            0x000f
#define IMAGE_REL_AMD64_SSPAN32         0x0010

/*
 * Relocation types i386
 */
#define IMAGE_REL_I386_ABSOLUTE         0x0000
#define IMAGE_REL_I386_DIR16            0x0001
#define IMAGE_REL_I386_REL16            0x0002
#define IMAGE_REL_I386_DIR32            0x0006
#define IMAGE_REL_I386_DIR32NB          0x0007
#define IMAGE_REL_I386_SEG12            0x0009
#define IMAGE_REL_I386_SECTION          0x000a
#define IMAGE_REL_I386_SECREL           0x000b
#define IMAGE_REL_I386_TOKEN            0x000c
#define IMAGE_REL_I386_SECREL7          0x000d
#define IMAGE_REL_I386_REL32            0x0014

/*
 * TODO: Add other archs here?
 */

/*
 * TODO: Append the rest definitions from spec
 */

#endif /* PECOFF_H */
