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

#ifndef OUTPUT_ELFCOMMON_H
#define OUTPUT_ELFCOMMON_H

#include "compiler.h"
#include <inttypes.h>

/* Segment types */
#define PT_NULL    	0
#define PT_LOAD    	1
#define PT_DYNAMIC 	2
#define PT_INTERP  	3
#define PT_NOTE    	4
#define PT_SHLIB   	5
#define PT_PHDR    	6
#define PT_LOOS    	0x60000000
#define PT_HIOS    	0x6fffffff
#define PT_LOPROC  	0x70000000
#define PT_HIPROC  	0x7fffffff
#define PT_GNU_EH_FRAME	0x6474e550	/* Extension, eh? */

/* ELF file types */
#define ET_NONE   	0
#define ET_REL    	1
#define ET_EXEC   	2
#define ET_DYN    	3
#define ET_CORE   	4
#define ET_LOPROC 	0xff00
#define ET_HIPROC 	0xffff

/* ELF machine types */
#define EM_NONE  	0
#define EM_M32   	1
#define EM_SPARC 	2
#define EM_386   	3
#define EM_68K   	4
#define EM_88K   	5
#define EM_486   	6	/* Not used in Linux at least */
#define EM_860   	7
#define EM_MIPS         8	/* R3k, bigendian(?) */
#define EM_MIPS_RS4_BE 	10	/* R4k BE */
#define EM_PARISC      	15
#define EM_SPARC32PLUS 	18
#define EM_PPC         	20
#define EM_PPC64       	21
#define EM_S390         22
#define EM_SH          	42
#define EM_SPARCV9	43	/* v9 = SPARC64 */
#define EM_H8_300H      47
#define EM_H8S          48
#define EM_IA_64        50
#define EM_X86_64       62
#define EM_CRIS         76
#define EM_V850         87
#define EM_ALPHA        0x9026	/* Interrim Alpha that stuck around */
#define EM_CYGNUS_V850  0x9080	/* Old v850 ID used by Cygnus */
#define EM_S390_OLD     0xA390	/* Obsolete interrim value for S/390 */

/* Dynamic type values */
#define DT_NULL		0
#define DT_NEEDED	1
#define DT_PLTRELSZ	2
#define DT_PLTGOT	3
#define DT_HASH		4
#define DT_STRTAB	5
#define DT_SYMTAB	6
#define DT_RELA		7
#define DT_RELASZ	8
#define DT_RELAENT	9
#define DT_STRSZ	10
#define DT_SYMENT	11
#define DT_INIT		12
#define DT_FINI		13
#define DT_SONAME	14
#define DT_RPATH	15
#define DT_SYMBOLIC	16
#define DT_REL		17
#define DT_RELSZ	18
#define DT_RELENT	19
#define DT_PLTREL	20
#define DT_DEBUG	21
#define DT_TEXTREL	22
#define DT_JMPREL	23
#define DT_LOPROC	0x70000000
#define DT_HIPROC	0x7fffffff

/* Auxilliary table entries */
#define AT_NULL		0	/* end of vector */
#define AT_IGNORE	1	/* entry should be ignored */
#define AT_EXECFD	2	/* file descriptor of program */
#define AT_PHDR		3	/* program headers for program */
#define AT_PHENT	4	/* size of program header entry */
#define AT_PHNUM	5	/* number of program headers */
#define AT_PAGESZ	6	/* system page size */
#define AT_BASE		7	/* base address of interpreter */
#define AT_FLAGS	8	/* flags */
#define AT_ENTRY	9	/* entry point of program */
#define AT_NOTELF	10	/* program is not ELF */
#define AT_UID		11	/* real uid */
#define AT_EUID		12	/* effective uid */
#define AT_GID		13	/* real gid */
#define AT_EGID		14	/* effective gid */
#define AT_PLATFORM	15	/* string identifying CPU for optimizations */
#define AT_HWCAP  	16	/* arch dependent hints at CPU capabilities */
#define AT_CLKTCK 	17	/* frequency at which times() increments */
/* 18..22 = ? */
#define AT_SECURE 	23	/* secure mode boolean */

/* Program header permission flags */
#define PF_X            0x1
#define PF_W            0x2
#define PF_R            0x4

/* Section header types */
#define SHT_NULL        0
#define SHT_PROGBITS    1
#define SHT_SYMTAB      2
#define SHT_STRTAB      3
#define SHT_RELA        4
#define SHT_HASH        5
#define SHT_DYNAMIC     6
#define SHT_NOTE        7
#define SHT_NOBITS      8
#define SHT_REL         9
#define SHT_SHLIB       10
#define SHT_DYNSYM      11
#define SHT_NUM         12
#define SHT_LOPROC      0x70000000
#define SHT_HIPROC      0x7fffffff
#define SHT_LOUSER      0x80000000
#define SHT_HIUSER      0xffffffff

/* Section header flags */
#define SHF_WRITE            (1 << 0)   /* Writable */
#define SHF_ALLOC            (1 << 1)   /* Occupies memory during execution */
#define SHF_EXECINSTR        (1 << 2)   /* Executable */
#define SHF_MERGE            (1 << 4)   /* Might be merged */
#define SHF_STRINGS          (1 << 5)   /* Contains nul-terminated strings */
#define SHF_INFO_LINK        (1 << 6)   /* `sh_info' contains SHT index */
#define SHF_LINK_ORDER       (1 << 7)   /* Preserve order after combining */
#define SHF_OS_NONCONFORMING (1 << 8)   /* Non-standard OS specific handling
                                           required */
#define SHF_GROUP            (1 << 9)   /* Section is member of a group.  */
#define SHF_TLS              (1 << 10)  /* Section hold thread-local data.  */

/* Special section numbers */
#define SHN_UNDEF       0
#define SHN_LORESERVE   0xff00
#define SHN_LOPROC      0xff00
#define SHN_HIPROC      0xff1f
#define SHN_ABS         0xfff1
#define SHN_COMMON      0xfff2
#define SHN_HIRESERVE   0xffff

/* Lenght of magic at the start of a file */
#define EI_NIDENT	16

/* Magic number constants... */
#define EI_MAG0         0	/* e_ident[] indexes */
#define EI_MAG1         1
#define EI_MAG2         2
#define EI_MAG3         3
#define EI_CLASS        4
#define EI_DATA         5
#define EI_VERSION      6
#define EI_OSABI        7
#define EI_PAD          8

#define ELFMAG0         0x7f	/* EI_MAG */
#define ELFMAG1         'E'
#define ELFMAG2         'L'
#define ELFMAG3         'F'
#define ELFMAG          "\177ELF"
#define SELFMAG         4

#define ELFCLASSNONE    0	/* EI_CLASS */
#define ELFCLASS32      1
#define ELFCLASS64      2
#define ELFCLASSNUM     3

#define ELFDATANONE     0	/* e_ident[EI_DATA] */
#define ELFDATA2LSB     1
#define ELFDATA2MSB     2

#define EV_NONE         0	/* e_version, EI_VERSION */
#define EV_CURRENT      1
#define EV_NUM          2

#define ELFOSABI_NONE   0
#define ELFOSABI_LINUX  3

/* Legal values for ST_BIND subfield of st_info (symbol binding).  */
#define STB_LOCAL	0		/* Local symbol */
#define STB_GLOBAL	1		/* Global symbol */
#define STB_WEAK	2		/* Weak symbol */
#define STB_NUM		3		/* Number of defined types.  */
#define STB_LOOS	10		/* Start of OS-specific */
#define STB_HIOS	12		/* End of OS-specific */
#define STB_LOPROC	13		/* Start of processor-specific */
#define STB_HIPROC	15		/* End of processor-specific */

/* Symbol types */
#define STT_NOTYPE	0		/* Symbol type is unspecified */
#define STT_OBJECT	1		/* Symbol is a data object */
#define STT_FUNC	2		/* Symbol is a code object */
#define STT_SECTION	3		/* Symbol associated with a section */
#define STT_FILE	4		/* Symbol's name is file name */
#define STT_COMMON	5		/* Symbol is a common data object */
#define STT_TLS		6		/* Symbol is thread-local data object*/
#define	STT_NUM		7		/* Number of defined types.  */

/* Symbol visibilities */
#define STV_DEFAULT     0               /* Default symbol visibility rules */
#define STV_INTERNAL    1               /* Processor specific hidden class */
#define STV_HIDDEN      2               /* Sym unavailable in other modules */
#define STV_PROTECTED   3               /* Not preemptible, not exported */

#endif /* OUTPUT_ELFCOMMON_H */
