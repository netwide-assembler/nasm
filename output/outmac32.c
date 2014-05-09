/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2013 The NASM Authors - All Rights Reserved
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
 * outmacho.c	output routines for the Netwide Assembler to produce
 *		NeXTstep/OpenStep/Rhapsody/Darwin/MacOS X object files
 */

/* Most of this file is, like Mach-O itself, based on a.out. For more
 * guidelines see outaout.c.  */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "saa.h"
#include "raa.h"
#include "eval.h"
#include "output/outform.h"
#include "output/outlib.h"

#if defined(OF_MACHO32)

/* Mach-O in-file header structure sizes */
#define MACHO_HEADER_SIZE	(28)
#define MACHO_SEGCMD_SIZE	(56)
#define MACHO_SECTCMD_SIZE	(68)
#define MACHO_SYMCMD_SIZE	(24)
#define MACHO_NLIST_SIZE	(12)
#define MACHO_RELINFO_SIZE	(8)

/* Mach-O file header values */
#define	MH_MAGIC		(0xfeedface)
#define CPU_TYPE_I386		(7)     /* x86 platform */
#define	CPU_SUBTYPE_I386_ALL	(3)     /* all-x86 compatible */
#define	MH_OBJECT		(0x1)   /* object file */

#define	LC_SEGMENT		(0x1)   /* segment load command */
#define LC_SYMTAB		(0x2)   /* symbol table load command */

#define	VM_PROT_NONE	(0x00)
#define VM_PROT_READ	(0x01)
#define VM_PROT_WRITE	(0x02)
#define VM_PROT_EXECUTE	(0x04)

#define VM_PROT_DEFAULT	(VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE)
#define VM_PROT_ALL	(VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE)

struct section {
    /* nasm internal data */
    struct section *next;
    struct SAA *data;
    int32_t index;
    struct reloc *relocs;
    int align;

    /* data that goes into the file */
    char sectname[16];          /* what this section is called */
    char segname[16];           /* segment this section will be in */
    uint32_t addr;         /* in-memory address (subject to alignment) */
    uint32_t size;         /* in-memory and -file size  */
    uint32_t nreloc;       /* relocation entry count */
    uint32_t flags;        /* type and attributes (masked) */
};

#define SECTION_TYPE	0x000000ff      /* section type mask */

#define	S_REGULAR	(0x0)   /* standard section */
#define	S_ZEROFILL	(0x1)   /* zerofill, in-memory only */

#define SECTION_ATTRIBUTES_SYS   0x00ffff00     /* system setable attributes */
#define S_ATTR_SOME_INSTRUCTIONS 0x00000400     /* section contains some
                                                   machine instructions */
#define S_ATTR_EXT_RELOC         0x00000200     /* section has external
                                                   relocation entries */
#define S_ATTR_LOC_RELOC         0x00000100     /* section has local
                                                   relocation entries */


static struct sectmap {
    const char *nasmsect;
    const char *segname;
    const char *sectname;
    const int32_t flags;
} sectmap[] = {
    {".text", "__TEXT", "__text", S_REGULAR|S_ATTR_SOME_INSTRUCTIONS},
    {".data", "__DATA", "__data", S_REGULAR},
    {".rodata", "__DATA", "__const", S_REGULAR},
    {".bss", "__DATA", "__bss", S_ZEROFILL},
    {NULL, NULL, NULL, 0}
};

struct reloc {
    /* nasm internal data */
    struct reloc *next;

    /* data that goes into the file */
    int32_t addr;                  /* op's offset in section */
    unsigned int snum:24,       /* contains symbol index if
				** ext otherwise in-file
				** section number */
	pcrel:1,                /* relative relocation */
	length:2,               /* 0=byte, 1=word, 2=int32_t */
	ext:1,                  /* external symbol referenced */
	type:4;                 /* reloc type, 0 for us */
};

#define	R_ABS		0       /* absolute relocation */
#define R_SCATTERED	0x80000000      /* reloc entry is scattered if
					** highest bit == 1 */

struct symbol {
    /* nasm internal data */
    struct symbol *next;	/* next symbol in the list */
    char *name;			/* name of this symbol */
    int32_t initial_snum;		/* symbol number used above in
				   reloc */
    int32_t snum;			/* true snum for reloc */

    /* data that goes into the file */
    int32_t strx;                  /* string table index */
    uint8_t type;         /* symbol type */
    uint8_t sect;         /* NO_SECT or section number */
    int16_t desc;                 /* for stab debugging, 0 for us */
    uint32_t value;        /* offset of symbol in section */
};

/* symbol type bits */
#define	N_EXT	0x01            /* global or external symbol */

#define	N_UNDF	0x0             /* undefined symbol | n_sect == */
#define	N_ABS	0x2             /* absolute symbol  |  NO_SECT */
#define	N_SECT	0xe             /* defined symbol, n_sect holds
				** section number */

#define	N_TYPE	0x0e            /* type bit mask */

#define DEFAULT_SECTION_ALIGNMENT 0 /* byte (i.e. no) alignment */

/* special section number values */
#define	NO_SECT		0       /* no section, invalid */
#define MAX_SECT	255     /* maximum number of sections */

static struct section *sects, **sectstail;
static struct symbol *syms, **symstail;
static uint32_t nsyms;

/* These variables are set by macho_layout_symbols() to organize
   the symbol table and string table in order the dynamic linker
   expects.  They are then used in macho_write() to put out the
   symbols and strings in that order.

   The order of the symbol table is:
     local symbols
     defined external symbols (sorted by name)
     undefined external symbols (sorted by name)

   The order of the string table is:
     strings for external symbols
     strings for local symbols
 */
static uint32_t ilocalsym = 0;
static uint32_t iextdefsym = 0;
static uint32_t iundefsym = 0;
static uint32_t nlocalsym;
static uint32_t nextdefsym;
static uint32_t nundefsym;
static struct symbol **extdefsyms = NULL;
static struct symbol **undefsyms = NULL;

static struct RAA *extsyms;
static struct SAA *strs;
static uint32_t strslen;

/* Global file information. This should be cleaned up into either
   a structure or as function arguments.  */
uint32_t head_ncmds = 0;
uint32_t head_sizeofcmds = 0;
uint32_t seg_filesize = 0;
uint32_t seg_vmsize = 0;
uint32_t seg_nsects = 0;
uint32_t rel_padcnt = 0;


#define xstrncpy(xdst, xsrc)						\
    memset(xdst, '\0', sizeof(xdst));	/* zero out whole buffer */	\
    strncpy(xdst, xsrc, sizeof(xdst));	/* copy over string */		\
    xdst[sizeof(xdst) - 1] = '\0';      /* proper null-termination */

#define alignint32_t(x)							\
    ALIGN(x, sizeof(int32_t))      /* align x to int32_t boundary */

static void debug_reloc (struct reloc *);
static void debug_section_relocs (struct section *) _unused;

static struct section *get_section_by_name(const char *segname,
                                           const char *sectname)
{
    struct section *s;

    for (s = sects; s != NULL; s = s->next)
        if (!strcmp(s->segname, segname) && !strcmp(s->sectname, sectname))
            break;

    return s;
}

static struct section *get_section_by_index(const int32_t index)
{
    struct section *s;

    for (s = sects; s != NULL; s = s->next)
        if (index == s->index)
            break;

    return s;
}

static int32_t get_section_index_by_name(const char *segname,
                                      const char *sectname)
{
    struct section *s;

    for (s = sects; s != NULL; s = s->next)
        if (!strcmp(s->segname, segname) && !strcmp(s->sectname, sectname))
            return s->index;

    return -1;
}

static char *get_section_name_by_index(const int32_t index)
{
    struct section *s;

    for (s = sects; s != NULL; s = s->next)
        if (index == s->index)
            return s->sectname;

    return NULL;
}

static uint8_t get_section_fileindex_by_index(const int32_t index)
{
    struct section *s;
    uint8_t i = 1;

    for (s = sects; s != NULL && i < MAX_SECT; s = s->next, ++i)
        if (index == s->index)
            return i;

    if (i == MAX_SECT)
        nasm_error(ERR_WARNING,
              "too many sections (>255) - clipped by fileindex");

    return NO_SECT;
}

static void macho_init(void)
{
    char zero = 0;

    sects = NULL;
    sectstail = &sects;

    syms = NULL;
    symstail = &syms;
    nsyms = 0;
    nlocalsym = 0;
    nextdefsym = 0;
    nundefsym = 0;

    extsyms = raa_init();
    strs = saa_init(1L);

    /* string table starts with a zero byte - don't ask why */
    saa_wbytes(strs, &zero, sizeof(char));
    strslen = 1;
}

static void sect_write(struct section *sect,
                       const uint8_t *data, uint32_t len)
{
    saa_wbytes(sect->data, data, len);
    sect->size += len;
}

static void add_reloc(struct section *sect, int32_t section,
                      int pcrel, int bytes)
{
    struct reloc *r;
    int32_t fi;

    /* NeXT as puts relocs in reversed order (address-wise) into the
     ** files, so we do the same, doesn't seem to make much of a
     ** difference either way */
    r = nasm_malloc(sizeof(struct reloc));
    r->next = sect->relocs;
    sect->relocs = r;

    /* the current end of the section will be the symbol's address for
     ** now, might have to be fixed by macho_fixup_relocs() later on. make
     ** sure we don't make the symbol scattered by setting the highest
     ** bit by accident */
    r->addr = sect->size & ~R_SCATTERED;
    r->ext = 0;
    r->pcrel = pcrel;

    /* match byte count 1, 2, 4 to length codes 0, 1, 2 respectively */
    r->length = bytes >> 1;

    /* vanilla relocation (GENERIC_RELOC_VANILLA) */
    r->type = 0;

    if (section == NO_SEG) {
        /* absolute local symbol if no section index given */
        r->snum = R_ABS;
    } else {
        fi = get_section_fileindex_by_index(section);

        if (fi == NO_SECT) {
            /* external symbol if no section with that index known,
             ** symbol number was saved in macho_symdef() */
            r->snum = raa_read(extsyms, section);
            r->ext = 1;
        } else {
            /* local symbol in section fi */
            r->snum = fi;
        }
    }

    ++sect->nreloc;
}

static void macho_output(int32_t secto, const void *data,
			 enum out_type type, uint64_t size,
                         int32_t section, int32_t wrt)
{
    struct section *s, *sbss;
    int32_t addr;
    uint8_t mydata[4], *p;

    if (wrt != NO_SEG) {
        wrt = NO_SEG;
        nasm_error(ERR_NONFATAL, "WRT not supported by Mach-O output format");
        /* continue to do _something_ */
    }

    if (secto == NO_SEG) {
        if (type != OUT_RESERVE)
            nasm_error(ERR_NONFATAL, "attempt to assemble code in "
                  "[ABSOLUTE] space");

        return;
    }

    s = get_section_by_index(secto);

    if (s == NULL) {
        nasm_error(ERR_WARNING, "attempt to assemble code in"
              " section %d: defaulting to `.text'", secto);
        s = get_section_by_name("__TEXT", "__text");

        /* should never happen */
        if (s == NULL)
            nasm_error(ERR_PANIC, "text section not found");
    }

    sbss = get_section_by_name("__DATA", "__bss");

    if (s == sbss && type != OUT_RESERVE) {
        nasm_error(ERR_WARNING, "attempt to initialize memory in the"
              " BSS section: ignored");
        s->size += realsize(type, size);
        return;
    }

    switch (type) {
    case OUT_RESERVE:
        if (s != sbss) {
            nasm_error(ERR_WARNING, "uninitialized space declared in"
                  " %s section: zeroing",
                  get_section_name_by_index(secto));

            sect_write(s, NULL, size);
        } else
            s->size += size;

        break;

    case OUT_RAWDATA:
        if (section != NO_SEG)
            nasm_error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");

        sect_write(s, data, size);
        break;

    case OUT_ADDRESS:
    {
	int asize = abs(size);
	
	addr = *(int64_t *)data;
	
	if (section != NO_SEG) {
	    if (section % 2) {
		nasm_error(ERR_NONFATAL, "Mach-O format does not support"
			   " section base references");
	    } else
		add_reloc(s, section, 0, asize);
	}
	
	p = mydata;
	WRITEADDR(p, addr, asize);
	sect_write(s, mydata, asize);
	break;
    }

    case OUT_REL2ADR:
        if (section == secto)
            nasm_error(ERR_PANIC, "intra-section OUT_REL2ADR");

        if (section != NO_SEG && section % 2) {
            nasm_error(ERR_NONFATAL, "Mach-O format does not support"
                  " section base references");
        } else
            add_reloc(s, section, 1, 2);

        p = mydata;
        WRITESHORT(p, *(int32_t *)data - (size + s->size));
        sect_write(s, mydata, 2L);
        break;

    case OUT_REL4ADR:
        if (section == secto)
            nasm_error(ERR_PANIC, "intra-section OUT_REL4ADR");

        if (section != NO_SEG && section % 2) {
            nasm_error(ERR_NONFATAL, "Mach-O format does not support"
                  " section base references");
        } else
            add_reloc(s, section, 1, 4);

        p = mydata;
        WRITELONG(p, *(int32_t *)data - (size + s->size));
        sect_write(s, mydata, 4L);
        break;

    default:
        nasm_error(ERR_PANIC, "unknown output type?");
        break;
    }
}

static int32_t macho_section(char *name, int pass, int *bits)
{
    int32_t index, originalIndex;
    char *sectionAttributes;
    struct sectmap *sm;
    struct section *s;

    (void)pass;

    /* Default to 32 bits. */
    if (!name) {
        *bits = 32;
        name = ".text";
        sectionAttributes = NULL;
    } else {
        sectionAttributes = name;
        name = nasm_strsep(&sectionAttributes, " \t");
    }

    for (sm = sectmap; sm->nasmsect != NULL; ++sm) {
        /* make lookup into section name translation table */
        if (!strcmp(name, sm->nasmsect)) {
            char *currentAttribute;

            /* try to find section with that name */
            originalIndex = index = get_section_index_by_name(sm->segname,
                                                              sm->sectname);

            /* create it if it doesn't exist yet */
            if (index == -1) {
                s = *sectstail = nasm_malloc(sizeof(struct section));
                s->next = NULL;
                sectstail = &s->next;

                s->data = saa_init(1L);
                s->index = seg_alloc();
                s->relocs = NULL;
                s->align = -1;

                xstrncpy(s->segname, sm->segname);
                xstrncpy(s->sectname, sm->sectname);
                s->size = 0;
                s->nreloc = 0;
                s->flags = sm->flags;

                index = s->index;
            } else {
                s = get_section_by_index(index);
            }

            while ((NULL != sectionAttributes)
                   && (currentAttribute = nasm_strsep(&sectionAttributes, " \t"))) {
                if (0 != *currentAttribute) {
                    if (!nasm_strnicmp("align=", currentAttribute, 6)) {
                        char *end;
                        int newAlignment, value;

                        value = strtoul(currentAttribute + 6, (char**)&end, 0);
                        newAlignment = alignlog2_32(value);

                        if (0 != *end) {
                            nasm_error(ERR_PANIC,
                                  "unknown or missing alignment value \"%s\" "
                                      "specified for section \"%s\"",
                                  currentAttribute + 6,
                                  name);
                            return NO_SEG;
                        } else if (0 > newAlignment) {
                            nasm_error(ERR_PANIC,
                                  "alignment of %d (for section \"%s\") is not "
                                      "a power of two",
                                  value,
                                  name);
                            return NO_SEG;
                        }

                        if ((-1 != originalIndex)
                            && (s->align != newAlignment)
                           && (s->align != -1)) {
                            nasm_error(ERR_PANIC,
                                  "section \"%s\" has already been specified "
                                      "with alignment %d, conflicts with new "
                                      "alignment of %d",
                            name,
                            (1 << s->align),
                            value);
                            return NO_SEG;
                        }

                        s->align = newAlignment;
                    } else if (!nasm_stricmp("data", currentAttribute)) {
                        /* Do nothing; 'data' is implicit */
                    } else {
                        nasm_error(ERR_PANIC,
                              "unknown section attribute %s for section %s",
                              currentAttribute,
                              name);
                        return NO_SEG;
                    }
                }
            }

            return index;
        }
    }

    nasm_error(ERR_PANIC, "invalid section name %s", name);
    return NO_SEG;
}

static void macho_symdef(char *name, int32_t section, int64_t offset,
                         int is_global, char *special)
{
    struct symbol *sym;

    if (special) {
        nasm_error(ERR_NONFATAL, "The Mach-O output format does "
              "not support any special symbol types");
        return;
    }

    if (is_global == 3) {
        nasm_error(ERR_NONFATAL, "The Mach-O format does not "
              "(yet) support forward reference fixups.");
        return;
    }

    sym = *symstail = nasm_malloc(sizeof(struct symbol));
    sym->next = NULL;
    symstail = &sym->next;

    sym->name = name;
    sym->strx = strslen;
    sym->type = 0;
    sym->desc = 0;
    sym->value = offset;
    sym->initial_snum = -1;

    /* external and common symbols get N_EXT */
    if (is_global != 0)
        sym->type |= N_EXT;

    if (section == NO_SEG) {
        /* symbols in no section get absolute */
        sym->type |= N_ABS;
        sym->sect = NO_SECT;
    } else {
        sym->type |= N_SECT;

        /* get the in-file index of the section the symbol was defined in */
        sym->sect = get_section_fileindex_by_index(section);

        if (sym->sect == NO_SECT) {
            /* remember symbol number of references to external
             ** symbols, this works because every external symbol gets
             ** its own section number allocated internally by nasm and
             ** can so be used as a key */
	    extsyms = raa_write(extsyms, section, nsyms);
	    sym->initial_snum = nsyms;

            switch (is_global) {
            case 1:
            case 2:
                /* there isn't actually a difference between global
                 ** and common symbols, both even have their size in
                 ** sym->value */
                sym->type = N_EXT;
                break;

            default:
                /* give an error on unfound section if it's not an
                 ** external or common symbol (assemble_file() does a
                 ** seg_alloc() on every call for them) */
                nasm_error(ERR_PANIC, "in-file index for section %d not found",
                      section);
            }
        }
    }

    ++nsyms;
}

static void macho_sectalign(int32_t seg, unsigned int value)
{
    struct section *s;

    list_for_each(s, sects) {
        if (s->index == seg)
            break;
    }

    if (!s || !is_power2(value))
        return;

    value = alignlog2_32(value);
    if (s->align < (int)value)
        s->align = value;
}

static int32_t macho_segbase(int32_t section)
{
    return section;
}

static void macho_filename(char *inname, char *outname)
{
    standard_extension(inname, outname, ".o");
}

extern macros_t macho_stdmac[];

/* Comparison function for qsort symbol layout.  */
static int layout_compare (const struct symbol **s1,
			   const struct symbol **s2)
{
    return (strcmp ((*s1)->name, (*s2)->name));
}

/* The native assembler does a few things in a similar function

	* Remove temporary labels
	* Sort symbols according to local, external, undefined (by name)
	* Order the string table

   We do not remove temporary labels right now.

   numsyms is the total number of symbols we have. strtabsize is the
   number entries in the string table.  */

static void macho_layout_symbols (uint32_t *numsyms,
				  uint32_t *strtabsize)
{
    struct symbol *sym, **symp;
    uint32_t i,j;

    *numsyms = 0;
    *strtabsize = sizeof (char);

    symp = &syms;

    while ((sym = *symp)) {
	/* Undefined symbols are now external.  */
	if (sym->type == N_UNDF)
	    sym->type |= N_EXT;

	if ((sym->type & N_EXT) == 0) {
	    sym->snum = *numsyms;
	    *numsyms = *numsyms + 1;
	    nlocalsym++;
	}
	else {
	    if ((sym->type & N_TYPE) != N_UNDF)
		nextdefsym++;
	    else
		nundefsym++;

	    /* If we handle debug info we'll want
	       to check for it here instead of just
	       adding the symbol to the string table.  */
	    sym->strx = *strtabsize;
	    saa_wbytes (strs, sym->name, (int32_t)(strlen(sym->name) + 1));
	    *strtabsize += strlen(sym->name) + 1;
	}
	symp = &(sym->next);
    }

    /* Next, sort the symbols.  Most of this code is a direct translation from
       the Apple cctools symbol layout. We need to keep compatibility with that.  */
    /* Set the indexes for symbol groups into the symbol table */
    ilocalsym = 0;
    iextdefsym = nlocalsym;
    iundefsym = nlocalsym + nextdefsym;

    /* allocate arrays for sorting externals by name */
    extdefsyms = nasm_malloc(nextdefsym * sizeof(struct symbol *));
    undefsyms = nasm_malloc(nundefsym * sizeof(struct symbol *));

    i = 0;
    j = 0;

    symp = &syms;

    while ((sym = *symp)) {

	if((sym->type & N_EXT) == 0) {
	    sym->strx = *strtabsize;
	    saa_wbytes (strs, sym->name, (int32_t)(strlen (sym->name) + 1));
	    *strtabsize += strlen(sym->name) + 1;
	}
	else {
	    if((sym->type & N_TYPE) != N_UNDF)
		extdefsyms[i++] = sym;
	    else
		undefsyms[j++] = sym;
	}
	symp = &(sym->next);
    }

    qsort(extdefsyms, nextdefsym, sizeof(struct symbol *),
	  (int (*)(const void *, const void *))layout_compare);
    qsort(undefsyms, nundefsym, sizeof(struct symbol *),
	  (int (*)(const void *, const void *))layout_compare);

    for(i = 0; i < nextdefsym; i++) {
	extdefsyms[i]->snum = *numsyms;
	*numsyms += 1;
    }
    for(j = 0; j < nundefsym; j++) {
	undefsyms[j]->snum = *numsyms;
	*numsyms += 1;
    }
}

/* Calculate some values we'll need for writing later.  */

static void macho_calculate_sizes (void)
{
    struct section *s;

    /* count sections and calculate in-memory and in-file offsets */
    for (s = sects; s != NULL; s = s->next) {
        uint32_t pad = 0;

        /* zerofill sections aren't actually written to the file */
        if ((s->flags & SECTION_TYPE) != S_ZEROFILL)
            seg_filesize += s->size;

        /* recalculate segment address based on alignment and vm size */
        s->addr = seg_vmsize;
        /* we need section alignment to calculate final section address */
        if (s->align == -1)
            s->align = DEFAULT_SECTION_ALIGNMENT;
        if(s->align) {
            uint32_t newaddr = ALIGN(s->addr, 1 << s->align);
            pad = newaddr - s->addr;
            s->addr = newaddr;
        }

        seg_vmsize += s->size + pad;
        ++seg_nsects;
    }

    /* calculate size of all headers, load commands and sections to
    ** get a pointer to the start of all the raw data */
    if (seg_nsects > 0) {
        ++head_ncmds;
        head_sizeofcmds +=
            MACHO_SEGCMD_SIZE + seg_nsects * MACHO_SECTCMD_SIZE;
    }

    if (nsyms > 0) {
	++head_ncmds;
	head_sizeofcmds += MACHO_SYMCMD_SIZE;
    }
}

/* Write out the header information for the file.  */

static void macho_write_header (void)
{
    fwriteint32_t(MH_MAGIC, ofile);	/* magic */
    fwriteint32_t(CPU_TYPE_I386, ofile);	/* CPU type */
    fwriteint32_t(CPU_SUBTYPE_I386_ALL, ofile);	/* CPU subtype */
    fwriteint32_t(MH_OBJECT, ofile);	/* Mach-O file type */
    fwriteint32_t(head_ncmds, ofile);	/* number of load commands */
    fwriteint32_t(head_sizeofcmds, ofile);	/* size of load commands */
    fwriteint32_t(0, ofile);	/* no flags */
}

/* Write out the segment load command at offset.  */

static uint32_t macho_write_segment (uint32_t offset)
{
    uint32_t rel_base = alignint32_t (offset + seg_filesize);
    uint32_t s_reloff = 0;
    struct section *s;

    fwriteint32_t(LC_SEGMENT, ofile);        /* cmd == LC_SEGMENT */

    /* size of load command including section load commands */
    fwriteint32_t(MACHO_SEGCMD_SIZE + seg_nsects *
	       MACHO_SECTCMD_SIZE, ofile);

    /* in an MH_OBJECT file all sections are in one unnamed (name
    ** all zeros) segment */
    fwritezero(16, ofile);
    fwriteint32_t(0, ofile); /* in-memory offset */
    fwriteint32_t(seg_vmsize, ofile);        /* in-memory size */
    fwriteint32_t(offset, ofile);    /* in-file offset to data */
    fwriteint32_t(seg_filesize, ofile);      /* in-file size */
    fwriteint32_t(VM_PROT_DEFAULT, ofile);   /* maximum vm protection */
    fwriteint32_t(VM_PROT_DEFAULT, ofile);   /* initial vm protection */
    fwriteint32_t(seg_nsects, ofile);        /* number of sections */
    fwriteint32_t(0, ofile); /* no flags */

    /* emit section headers */
    for (s = sects; s != NULL; s = s->next) {
	fwrite(s->sectname, sizeof(s->sectname), 1, ofile);
	fwrite(s->segname, sizeof(s->segname), 1, ofile);
	fwriteint32_t(s->addr, ofile);
	fwriteint32_t(s->size, ofile);

	/* dummy data for zerofill sections or proper values */
	if ((s->flags & SECTION_TYPE) != S_ZEROFILL) {
	    fwriteint32_t(offset, ofile);
	    /* Write out section alignment, as a power of two.
	       e.g. 32-bit word alignment would be 2 (2^^2 = 4).  */
	    if (s->align == -1)
		s->align = DEFAULT_SECTION_ALIGNMENT;
	    fwriteint32_t(s->align, ofile);
	    /* To be compatible with cctools as we emit
	       a zero reloff if we have no relocations.  */
	    fwriteint32_t(s->nreloc ? rel_base + s_reloff : 0, ofile);
	    fwriteint32_t(s->nreloc, ofile);

	    offset += s->size;
	    s_reloff += s->nreloc * MACHO_RELINFO_SIZE;
	} else {
	    fwriteint32_t(0, ofile);
	    fwriteint32_t(0, ofile);
	    fwriteint32_t(0, ofile);
	    fwriteint32_t(0, ofile);
	}

	fwriteint32_t(s->flags, ofile);      /* flags */
	fwriteint32_t(0, ofile);     /* reserved */
	fwriteint32_t(0, ofile);     /* reserved */
    }

    rel_padcnt = rel_base - offset;
    offset = rel_base + s_reloff;

    return offset;
}

/* For a given chain of relocs r, write out the entire relocation
   chain to the object file.  */

static void macho_write_relocs (struct reloc *r)
{
    while (r) {
	uint32_t word2;

	fwriteint32_t(r->addr, ofile); /* reloc offset */

	word2 = r->snum;
	word2 |= r->pcrel << 24;
	word2 |= r->length << 25;
	word2 |= r->ext << 27;
	word2 |= r->type << 28;
	fwriteint32_t(word2, ofile); /* reloc data */

	r = r->next;
    }
}

/* Write out the section data.  */
static void macho_write_section (void)
{
    struct section *s, *s2;
    struct reloc *r;
    uint8_t fi, *p, *q, blk[4];
    int32_t l;

    for (s = sects; s != NULL; s = s->next) {
	if ((s->flags & SECTION_TYPE) == S_ZEROFILL)
	    continue;

	/* no padding needs to be done to the sections */

	/* Like a.out Mach-O references things in the data or bss
	 * sections by addresses which are actually relative to the
	 * start of the _text_ section, in the _file_. See outaout.c
	 * for more information. */
	saa_rewind(s->data);
	for (r = s->relocs; r != NULL; r = r->next) {
	    saa_fread(s->data, r->addr, blk, (int32_t)r->length << 1);
	    p = q = blk;
	    l = *p++;

	    /* get offset based on relocation type */
	    if (r->length > 0) {
		l += ((int32_t)*p++) << 8;

		if (r->length == 2) {
		    l += ((int32_t)*p++) << 16;
		    l += ((int32_t)*p++) << 24;
		}
	    }

	    /* If the relocation is internal add to the current section
	       offset. Otherwise the only value we need is the symbol
	       offset which we already have. The linker takes care
	       of the rest of the address.  */
	    if (!r->ext) {
            /* generate final address by section address and offset */
		    for (s2 = sects, fi = 1;
		        s2 != NULL; s2 = s2->next, fi++) {
		        if (fi == r->snum) {
		            l += s2->addr;
		            break;
		        }
		    }
	    }

	    /* write new offset back */
	    if (r->length == 2)
		WRITELONG(q, l);
	    else if (r->length == 1)
		WRITESHORT(q, l);
	    else
		*q++ = l & 0xFF;

	    saa_fwrite(s->data, r->addr, blk, (int32_t)r->length << 1);
	}

	/* dump the section data to file */
	saa_fpwrite(s->data, ofile);
    }

    /* pad last section up to reloc entries on int32_t boundary */
    fwritezero(rel_padcnt, ofile);

    /* emit relocation entries */
    for (s = sects; s != NULL; s = s->next)
	macho_write_relocs (s->relocs);
}

/* Write out the symbol table. We should already have sorted this
   before now.  */
static void macho_write_symtab (void)
{
    struct symbol *sym;
    struct section *s;
    int32_t fi;
    uint32_t i;

    /* we don't need to pad here since MACHO_RELINFO_SIZE == 8 */

    for (sym = syms; sym != NULL; sym = sym->next) {
	if ((sym->type & N_EXT) == 0) {
	    fwriteint32_t(sym->strx, ofile);		/* string table entry number */
	    fwrite(&sym->type, 1, 1, ofile);	/* symbol type */
	    fwrite(&sym->sect, 1, 1, ofile);	/* section */
	    fwriteint16_t(sym->desc, ofile);	/* description */

	    /* Fix up the symbol value now that we know the final section
	       sizes.  */
	    if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
		    for (s = sects, fi = 1; s != NULL; s = s->next, fi++) {
		        if (fi == sym->sect) {
		            sym->value += s->addr;
		            break;
		        }
		    }
	    }

	    fwriteint32_t(sym->value, ofile);	/* value (i.e. offset) */
	}
    }

    for (i = 0; i < nextdefsym; i++) {
	sym = extdefsyms[i];
	fwriteint32_t(sym->strx, ofile);
	fwrite(&sym->type, 1, 1, ofile);	/* symbol type */
	fwrite(&sym->sect, 1, 1, ofile);	/* section */
	fwriteint16_t(sym->desc, ofile);	/* description */

	/* Fix up the symbol value now that we know the final section
	   sizes.  */
	if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
	    for (s = sects, fi = 1;
		 s != NULL && fi < sym->sect; s = s->next, ++fi)
		sym->value += s->size;
	}

	fwriteint32_t(sym->value, ofile);	/* value (i.e. offset) */
    }

     for (i = 0; i < nundefsym; i++) {
	 sym = undefsyms[i];
	 fwriteint32_t(sym->strx, ofile);
	 fwrite(&sym->type, 1, 1, ofile);	/* symbol type */
	 fwrite(&sym->sect, 1, 1, ofile);	/* section */
	 fwriteint16_t(sym->desc, ofile);	/* description */

	 /* Fix up the symbol value now that we know the final section
	    sizes.  */
	 if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
	     for (s = sects, fi = 1;
		  s != NULL && fi < sym->sect; s = s->next, ++fi)
		 sym->value += s->size;
	 }

	 fwriteint32_t(sym->value, ofile);	/* value (i.e. offset) */
     }
}

/* Fixup the snum in the relocation entries, we should be
   doing this only for externally undefined symbols. */
static void macho_fixup_relocs (struct reloc *r)
{
    struct symbol *sym;
    uint32_t i;

    while (r != NULL) {
	if (r->ext) {
	    for (i = 0; i < nundefsym; i++) {
		sym = undefsyms[i];
		if (sym->initial_snum == r->snum) {
		    r->snum = sym->snum;
                   break;
		}
	    }
	}
	r = r->next;
    }
}

/* Write out the object file.  */

static void macho_write (void)
{
    uint32_t offset = 0;

    /* mach-o object file structure:
    **
    ** mach header
    **  uint32_t magic
    **  int   cpu type
    **  int   cpu subtype
    **  uint32_t mach file type
    **  uint32_t number of load commands
    **  uint32_t size of all load commands
    **   (includes section struct size of segment command)
    **  uint32_t flags
    **
    ** segment command
    **  uint32_t command type == LC_SEGMENT
    **  uint32_t size of load command
    **   (including section load commands)
    **  char[16] segment name
    **  uint32_t in-memory offset
    **  uint32_t in-memory size
    **  uint32_t in-file offset to data area
    **  uint32_t in-file size
    **   (in-memory size excluding zerofill sections)
    **  int   maximum vm protection
    **  int   initial vm protection
    **  uint32_t number of sections
    **  uint32_t flags
    **
    ** section commands
    **   char[16] section name
    **   char[16] segment name
    **   uint32_t in-memory offset
    **   uint32_t in-memory size
    **   uint32_t in-file offset
    **   uint32_t alignment
    **    (irrelevant in MH_OBJECT)
    **   uint32_t in-file offset of relocation entires
    **   uint32_t number of relocations
    **   uint32_t flags
    **   uint32_t reserved
    **   uint32_t reserved
    **
    ** symbol table command
    **  uint32_t command type == LC_SYMTAB
    **  uint32_t size of load command
    **  uint32_t symbol table offset
    **  uint32_t number of symbol table entries
    **  uint32_t string table offset
    **  uint32_t string table size
    **
    ** raw section data
    **
    ** padding to int32_t boundary
    **
    ** relocation data (struct reloc)
    ** int32_t offset
    **  uint data (symbolnum, pcrel, length, extern, type)
    **
    ** symbol table data (struct nlist)
    **  int32_t  string table entry number
    **  uint8_t type
    **   (extern, absolute, defined in section)
    **  uint8_t section
    **   (0 for global symbols, section number of definition (>= 1, <=
    **   254) for local symbols, size of variable for common symbols
    **   [type == extern])
    **  int16_t description
    **   (for stab debugging format)
    **  uint32_t value (i.e. file offset) of symbol or stab offset
    **
    ** string table data
    **  list of null-terminated strings
    */

    /* Emit the Mach-O header.  */
    macho_write_header();

    offset = MACHO_HEADER_SIZE + head_sizeofcmds;

    /* emit the segment load command */
    if (seg_nsects > 0)
	offset = macho_write_segment (offset);
    else
        nasm_error(ERR_WARNING, "no sections?");

    if (nsyms > 0) {
        /* write out symbol command */
        fwriteint32_t(LC_SYMTAB, ofile); /* cmd == LC_SYMTAB */
        fwriteint32_t(MACHO_SYMCMD_SIZE, ofile); /* size of load command */
        fwriteint32_t(offset, ofile);    /* symbol table offset */
        fwriteint32_t(nsyms, ofile);     /* number of symbol
                                         ** table entries */

        offset += nsyms * MACHO_NLIST_SIZE;
        fwriteint32_t(offset, ofile);    /* string table offset */
        fwriteint32_t(strslen, ofile);   /* string table size */
    }

    /* emit section data */
    if (seg_nsects > 0)
	macho_write_section ();

    /* emit symbol table if we have symbols */
    if (nsyms > 0)
	macho_write_symtab ();

    /* we don't need to pad here since MACHO_NLIST_SIZE == 12 */

    /* emit string table */
    saa_fpwrite(strs, ofile);
}
/* We do quite a bit here, starting with finalizing all of the data
   for the object file, writing, and then freeing all of the data from
   the file.  */

static void macho_cleanup(int debuginfo)
{
    struct section *s;
    struct reloc *r;
    struct symbol *sym;

    (void)debuginfo;

    /* Sort all symbols.  */
    macho_layout_symbols (&nsyms, &strslen);

    /* Fixup relocation entries */
    for (s = sects; s != NULL; s = s->next) {
	macho_fixup_relocs (s->relocs);
    }

    /* First calculate and finalize needed values.  */
    macho_calculate_sizes();
    macho_write();

    /* free up everything */
    while (sects->next) {
        s = sects;
        sects = sects->next;

        saa_free(s->data);
        while (s->relocs != NULL) {
            r = s->relocs;
            s->relocs = s->relocs->next;
            nasm_free(r);
        }

        nasm_free(s);
    }

    saa_free(strs);
    raa_free(extsyms);

    if (syms) {
    while (syms->next) {
       sym = syms;
       syms = syms->next;

       nasm_free (sym);
    }
}
}

/* Debugging routines.  */
static void debug_reloc (struct reloc *r)
{
    fprintf (stdout, "reloc:\n");
    fprintf (stdout, "\taddr: %"PRId32"\n", r->addr);
    fprintf (stdout, "\tsnum: %d\n", r->snum);
    fprintf (stdout, "\tpcrel: %d\n", r->pcrel);
    fprintf (stdout, "\tlength: %d\n", r->length);
    fprintf (stdout, "\text: %d\n", r->ext);
    fprintf (stdout, "\ttype: %d\n", r->type);
}

static void debug_section_relocs (struct section *s)
{
    struct reloc *r = s->relocs;

    fprintf (stdout, "relocs for section %s:\n\n", s->sectname);

    while (r != NULL) {
	debug_reloc (r);
	r = r->next;
    }
}

struct ofmt of_macho32 = {
    "NeXTstep/OpenStep/Rhapsody/Darwin/MacOS X (i386) object files",
    "macho32",
    0,
    null_debug_arr,
    &null_debug_form,
    macho_stdmac,
    macho_init,
    null_setinfo,
    macho_output,
    macho_symdef,
    macho_section,
    macho_sectalign,
    macho_segbase,
    null_directive,
    macho_filename,
    macho_cleanup
};

#endif

/*
 * Local Variables:
 * mode:c
 * c-basic-offset:4
 * End:
 *
 * end of file */
