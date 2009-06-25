/*
 * Common code for outelf32 and outelf64
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

#include "nasm.h"

#include "output/elfcommon.h"
#include "output/dwarf.h"
#include "output/outelf.h"

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
