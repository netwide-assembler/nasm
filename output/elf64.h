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

#ifndef OUTPUT_ELF64_H
#define OUTPUT_ELF64_H

#include "output/elfcommon.h"

/* ELF standard typedefs (yet more proof that <stdint.h> was way overdue) */
typedef uint16_t Elf64_Half;
typedef int16_t Elf64_SHalf;
typedef uint32_t Elf64_Word;
typedef int32_t Elf64_Sword;
typedef uint64_t Elf64_Xword;
typedef int64_t Elf64_Sxword;

typedef uint64_t Elf64_Off;
typedef uint64_t Elf64_Addr;
typedef uint16_t Elf64_Section;

/* Dynamic header */

typedef struct elf64_dyn {
    Elf64_Sxword d_tag;
    union {
	Elf64_Xword d_val;
	Elf64_Addr d_ptr;
    } d_un;
} Elf64_Dyn;

/* Relocations */

#define ELF64_R_SYM(x)	((x) >> 32)
#define ELF64_R_TYPE(x)	((x) & 0xffffffff)

typedef struct elf64_rel {
    Elf64_Addr r_offset;
    Elf64_Xword r_info;
} Elf64_Rel;

typedef struct elf64_rela {
    Elf64_Addr r_offset;
    Elf64_Xword r_info;
    Elf64_Sxword r_addend;
} Elf64_Rela;

enum reloc64_type {
    R_X86_64_NONE       =  0,	/* No reloc */
    R_X86_64_64	        =  1,	/* Direct 64 bit  */
    R_X86_64_PC32	=  2,  	/* PC relative 32 bit signed */
    R_X86_64_GOT32	=  3,	/* 32 bit GOT entry */
    R_X86_64_PLT32	=  4,	/* 32 bit PLT address */
    R_X86_64_COPY	=  5,	/* Copy symbol at runtime */
    R_X86_64_GLOB_DAT	=  6,	/* Create GOT entry */
    R_X86_64_JUMP_SLOT	=  7,	/* Create PLT entry */
    R_X86_64_RELATIVE	=  8,	/* Adjust by program base */
    R_X86_64_GOTPCREL	=  9,	/* 32 bit signed PC relative offset to GOT */
    R_X86_64_32		= 10,	/* Direct 32 bit zero extended */
    R_X86_64_32S	= 11,	/* Direct 32 bit sign extended */
    R_X86_64_16		= 12,	/* Direct 16 bit zero extended */
    R_X86_64_PC16	= 13,	/* 16 bit sign extended pc relative */
    R_X86_64_8		= 14,	/* Direct 8 bit sign extended  */
    R_X86_64_PC8	= 15,	/* 8 bit sign extended pc relative */
    R_X86_64_DTPMOD64	= 16,	/* ID of module containing symbol */
    R_X86_64_DTPOFF64	= 17,	/* Offset in module's TLS block */
    R_X86_64_TPOFF64	= 18,	/* Offset in initial TLS block */
    R_X86_64_TLSGD	= 19,	/* 32 bit signed PC relative offset
				   to two GOT entries for GD symbol */
    R_X86_64_TLSLD	= 20,	/* 32 bit signed PC relative offset
				   to two GOT entries for LD symbol */
    R_X86_64_DTPOFF32	= 21,	/* Offset in TLS block */
    R_X86_64_GOTTPOFF	= 22,	/* 32 bit signed PC relative offset
				   to GOT entry for IE symbol */
    R_X86_64_TPOFF32	= 23,	/* Offset in initial TLS block */
    R_X86_64_PC64	= 24, 	/* word64 S + A - P */
    R_X86_64_GOTOFF64	= 25, 	/* word64 S + A - GOT */
    R_X86_64_GOTPC32	= 26, 	/* word32 GOT + A - P */
    R_X86_64_GOT64	= 27, 	/* word64 G + A */
    R_X86_64_GOTPCREL64	= 28, 	/* word64 G + GOT - P + A */
    R_X86_64_GOTPC64	= 29, 	/* word64 GOT - P + A */
    R_X86_64_GOTPLT64	= 30, 	/* word64 G + A */
    R_X86_64_PLTOFF64	= 31, 	/* word64 L - GOT + A */
    R_X86_64_SIZE32	= 32, 	/* word32 Z + A */
    R_X86_64_SIZE64	= 33, 	/* word64 Z + A */
    R_X86_64_GOTPC32_TLSDESC = 34, 	/* word32 */
    R_X86_64_TLSDESC_CALL    = 35, 	/* none */
    R_X86_64_TLSDESC    = 36 	/* word64×2 */
};

/* Symbol */

typedef struct elf64_sym {
    Elf64_Word st_name;
    unsigned char st_info;
    unsigned char st_other;
    Elf64_Half st_shndx;
    Elf64_Addr st_value;
    Elf64_Xword st_size;
} Elf64_Sym;

/* Main file header */

typedef struct elf64_hdr {
    unsigned char e_ident[EI_NIDENT];
    Elf64_Half e_type;
    Elf64_Half e_machine;
    Elf64_Word e_version;
    Elf64_Addr e_entry;
    Elf64_Off e_phoff;
    Elf64_Off e_shoff;
    Elf64_Word e_flags;
    Elf64_Half e_ehsize;
    Elf64_Half e_phentsize;
    Elf64_Half e_phnum;
    Elf64_Half e_shentsize;
    Elf64_Half e_shnum;
    Elf64_Half e_shstrndx;
} Elf64_Ehdr;

/* Program header */

typedef struct elf64_phdr {
    Elf64_Word p_type;
    Elf64_Word p_flags;
    Elf64_Off p_offset;
    Elf64_Addr p_vaddr;
    Elf64_Addr p_paddr;
    Elf64_Xword p_filesz;
    Elf64_Xword p_memsz;
    Elf64_Xword p_align;
} Elf64_Phdr;

/* Section header */

typedef struct elf64_shdr {
    Elf64_Word sh_name;
    Elf64_Word sh_type;
    Elf64_Xword sh_flags;
    Elf64_Addr sh_addr;
    Elf64_Off sh_offset;
    Elf64_Xword sh_size;
    Elf64_Word sh_link;
    Elf64_Word sh_info;
    Elf64_Xword sh_addralign;
    Elf64_Xword sh_entsize;
} Elf64_Shdr;

/* Note header */
typedef struct elf64_note {
    Elf64_Word n_namesz;	/* Name size */
    Elf64_Word n_descsz;	/* Content size */
    Elf64_Word n_type;	/* Content type */
} Elf64_Nhdr;

/* Both Elf32_Sym and Elf64_Sym use the same one-byte st_info field.  */
#define ELF64_ST_BIND(val)		ELF32_ST_BIND (val)
#define ELF64_ST_TYPE(val)		ELF32_ST_TYPE (val)

#endif /* OUTPUT_ELF64_H */
