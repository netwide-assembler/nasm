/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
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

/*
 * Common code for outelf32 and outelf64
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

#include "nasm.h"
#include "output/outform.h"

#include "output/dwarf.h"
#include "output/elf.h"
#include "output/outelf.h"

#if defined(OF_ELF32) || defined(OF_ELF64)

const struct elf_known_section elf_known_sections[] = {
    { ".text",    SHT_PROGBITS, SHF_ALLOC|SHF_EXECINSTR,     16 },
    { ".rodata",  SHT_PROGBITS, SHF_ALLOC,                    4 },
    { ".lrodata", SHT_PROGBITS, SHF_ALLOC,                    4 },
    { ".data",    SHT_PROGBITS, SHF_ALLOC|SHF_WRITE,          4 },
    { ".ldata",   SHT_PROGBITS, SHF_ALLOC|SHF_WRITE,          4 },
    { ".bss",     SHT_NOBITS,   SHF_ALLOC|SHF_WRITE,          4 },
    { ".lbss",    SHT_NOBITS,   SHF_ALLOC|SHF_WRITE,          4 },
    { ".tdata",   SHT_PROGBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS,  4 },
    { ".tbss",    SHT_NOBITS,   SHF_ALLOC|SHF_WRITE|SHF_TLS,  4 },
    { ".comment", SHT_PROGBITS, 0,                            1 },
    { NULL,       SHT_PROGBITS, SHF_ALLOC,                    1 } /* default */
};

#endif /* defined(OF_ELF32) || defined(OF_ELF64) */
