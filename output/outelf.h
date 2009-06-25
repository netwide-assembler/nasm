/*
 * Internal definitions common to outelf32 and outelf64
 */
#ifndef OUTPUT_OUTELF_H
#define OUTPUT_OUTELF_H

#define SYM_GLOBAL 0x10

#define GLOBAL_TEMP_BASE 1048576     /* bigger than any reasonable sym id */

#define SEG_ALIGN 16            /* alignment of sections in file */
#define SEG_ALIGN_1 (SEG_ALIGN-1)

/* this stuff is needed for the stabs debugging format */
#define N_SO 0x64               /* ID for main source file */
#define N_SOL 0x84              /* ID for sub-source file */
#define N_BINCL 0x82
#define N_EINCL 0xA2
#define N_SLINE 0x44
#define TY_STABSSYMLIN 0x40     /* ouch */

/* this stuff is needed for the dwarf debugging format */
#define TY_DEBUGSYMLIN 0x40     /* internal call to debug_out */

/* Known sections with nonstandard defaults */
struct elf_known_section {
    const char *name;		/* Name of section */
    int type;			/* Section type (SHT_) */
    uint32_t flags;		/* Section flags (SHF_) */
    uint32_t align;		/* Section alignment */
};
extern const struct elf_known_section elf_known_sections[];

#endif /* OUTPUT_OUTELF_H */
