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

#ifndef OUTPUT_ELF32_H
#define OUTPUT_ELF32_H

#include "output/elfcommon.h"

/* ELF standard typedefs (yet more proof that <stdint.h> was way overdue) */
typedef uint16_t Elf32_Half;
typedef int16_t Elf32_SHalf;
typedef uint32_t Elf32_Word;
typedef int32_t Elf32_Sword;
typedef uint64_t Elf32_Xword;
typedef int64_t Elf32_Sxword;

typedef uint32_t Elf32_Off;
typedef uint32_t Elf32_Addr;
typedef uint16_t Elf32_Section;

/* Dynamic header */

typedef struct elf32_dyn {
    Elf32_Sword d_tag;
    union {
	Elf32_Sword d_val;
	Elf32_Addr d_ptr;
    } d_un;
} Elf32_Dyn;

/* Relocations */

#define ELF32_R_SYM(x)	((x) >> 8)
#define ELF32_R_TYPE(x)	((x) & 0xff)

typedef struct elf32_rel {
    Elf32_Addr r_offset;
    Elf32_Word r_info;
} Elf32_Rel;

typedef struct elf32_rela {
    Elf32_Addr r_offset;
    Elf32_Word r_info;
    Elf32_Sword r_addend;
} Elf32_Rela;

enum reloc32_type {
    R_386_32		=  1,   /* ordinary absolute relocation */
    R_386_PC32          =  2,   /* PC-relative relocation */
    R_386_GOT32         =  3,   /* an offset into GOT */
    R_386_PLT32         =  4,   /* a PC-relative offset into PLT */
    R_386_COPY          =  5,   /* ??? */
    R_386_GLOB_DAT      =  6,   /* ??? */
    R_386_JUMP_SLOT     =  7,   /* ??? */
    R_386_RELATIVE      =  8,   /* ??? */
    R_386_GOTOFF        =  9,   /* an offset from GOT base */
    R_386_GOTPC         = 10,   /* a PC-relative offset _to_ GOT */
    R_386_TLS_TPOFF     = 14,   /* Offset in static TLS block */
    R_386_TLS_IE        = 15,   /* Address of GOT entry for static TLS
                                   block offset */
    /* These are GNU extensions, but useful */
    R_386_16            = 20,   /* A 16-bit absolute relocation */
    R_386_PC16          = 21,   /* A 16-bit PC-relative relocation */
    R_386_8             = 22,   /* An 8-bit absolute relocation */
    R_386_PC8           = 23    /* An 8-bit PC-relative relocation */
};

/* Symbol */

typedef struct elf32_sym {
    Elf32_Word st_name;
    Elf32_Addr st_value;
    Elf32_Word st_size;
    unsigned char st_info;
    unsigned char st_other;
    Elf32_Half st_shndx;
} Elf32_Sym;

/* Main file header */

typedef struct elf32_hdr {
    unsigned char e_ident[EI_NIDENT];
    Elf32_Half e_type;
    Elf32_Half e_machine;
    Elf32_Word e_version;
    Elf32_Addr e_entry;
    Elf32_Off e_phoff;
    Elf32_Off e_shoff;
    Elf32_Word e_flags;
    Elf32_Half e_ehsize;
    Elf32_Half e_phentsize;
    Elf32_Half e_phnum;
    Elf32_Half e_shentsize;
    Elf32_Half e_shnum;
    Elf32_Half e_shstrndx;
} Elf32_Ehdr;

/* Program header */

typedef struct elf32_phdr {
    Elf32_Word p_type;
    Elf32_Off p_offset;
    Elf32_Addr p_vaddr;
    Elf32_Addr p_paddr;
    Elf32_Word p_filesz;
    Elf32_Word p_memsz;
    Elf32_Word p_flags;
    Elf32_Word p_align;
} Elf32_Phdr;

/* Section header */

typedef struct elf32_shdr {
    Elf32_Word sh_name;
    Elf32_Word sh_type;
    Elf32_Word sh_flags;
    Elf32_Addr sh_addr;
    Elf32_Off sh_offset;
    Elf32_Word sh_size;
    Elf32_Word sh_link;
    Elf32_Word sh_info;
    Elf32_Word sh_addralign;
    Elf32_Word sh_entsize;
} Elf32_Shdr;

/* Note header */
typedef struct elf32_note {
    Elf32_Word n_namesz;	/* Name size */
    Elf32_Word n_descsz;	/* Content size */
    Elf32_Word n_type;	/* Content type */
} Elf32_Nhdr;

/* How to extract and insert information held in the st_info field.  */
#define ELF32_ST_BIND(val)		(((unsigned char) (val)) >> 4)
#define ELF32_ST_TYPE(val)		((val) & 0xf)

#endif	/* OUTPUT_ELF32_H */
