/* outmacho.c	output routines for the Netwide Assembler to produce
 *		NeXTstep/OpenStep/Rhapsody/Darwin/MacOS X object files
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
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
#include "outform.h"
#include "compiler.h"

#if defined(OF_MACHO)

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

static FILE *machofp;
static efunc error;
static evalfunc evaluate;

extern struct ofmt of_macho;

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

#define align(x, y)							\
    (((x) + (y) - 1) & ~((y) - 1))      /* align x to multiple of y */

#define alignint32_t(x)							\
    align(x, sizeof(int32_t))      /* align x to int32_t boundary */

static void debug_reloc (struct reloc *);
static void debug_section_relocs (struct section *) _unused;

static int exact_log2 (uint32_t align)
{
    if (align == 0) {
	return 0;
    } else if (align & (align-1)) {
	return -1;		/* Not a power of 2 */
    } else {
#ifdef HAVE_GNUC_4
	return __builtin_ctzl (align);
#else
	uint32_t result = 0;

	/* We know exactly one bit is set at this point. */
	if (align & 0xffff0000)
	    result |= 16;
	if (align & 0xff00ff00)
	    result |= 8;
	if (align & 0xf0f0f0f0)
	    result |= 4;
	if (align & 0xcccccccc)
	    result |= 2;
	if (align & 0xaaaaaaaa)
	    result |= 1;

	return result;
#endif
    }
}

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
        error(ERR_WARNING,
              "too many sections (>255) - clipped by fileindex");

    return NO_SECT;
}

static void macho_init(FILE * fp, efunc errfunc, ldfunc ldef,
                       evalfunc eval)
{
    char zero = 0;

    machofp = fp;
    error = errfunc;
    evaluate = eval;

    (void)ldef;                 /* placate optimisers */

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

static int macho_setinfo(enum geninfo type, char **val)
{
    (void)type;
    (void)val;
    return 0;
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

static void macho_output(int32_t secto, const void *data, uint32_t type,
                         int32_t section, int32_t wrt)
{
    struct section *s, *sbss;
    int32_t realbytes = type & OUT_SIZMASK;
    int32_t addr;
    uint8_t mydata[4], *p;

    type &= OUT_TYPMASK;

    if (wrt != NO_SEG) {
        wrt = NO_SEG;
        error(ERR_NONFATAL, "WRT not supported by Mach-O output format");
        /* continue to do _something_ */
    }

    if (secto == NO_SEG) {
        if (type != OUT_RESERVE)
            error(ERR_NONFATAL, "attempt to assemble code in "
                  "[ABSOLUTE] space");

        return;
    }

    s = get_section_by_index(secto);

    if (s == NULL) {
        error(ERR_WARNING, "attempt to assemble code in"
              " section %d: defaulting to `.text'", secto);
        s = get_section_by_name("__TEXT", "__text");

        /* should never happen */
        if (s == NULL)
            error(ERR_PANIC, "text section not found");
    }

    sbss = get_section_by_name("__DATA", "__bss");

    if (s == sbss && type != OUT_RESERVE) {
        error(ERR_WARNING, "attempt to initialize memory in the"
              " BSS section: ignored");

        switch (type) {
        case OUT_REL2ADR:
            realbytes = 2;
            break;

        case OUT_REL4ADR:
            realbytes = 4;
            break;

        default:
            break;
        }

        s->size += realbytes;
        return;
    }

    switch (type) {
    case OUT_RESERVE:
        if (s != sbss) {
            error(ERR_WARNING, "uninitialized space declared in"
                  " %s section: zeroing",
                  get_section_name_by_index(secto));

            sect_write(s, NULL, realbytes);
        } else
            s->size += realbytes;

        break;

    case OUT_RAWDATA:
        if (section != NO_SEG)
            error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");

        sect_write(s, data, realbytes);
        break;

    case OUT_ADDRESS:
        addr = *(int32_t *)data;

        if (section != NO_SEG) {
            if (section % 2) {
                error(ERR_NONFATAL, "Mach-O format does not support"
                      " section base references");
            } else
                add_reloc(s, section, 0, realbytes);
        }

        p = mydata;

        if (realbytes == 2)
            WRITESHORT(p, addr);
        else
            WRITELONG(p, addr);

        sect_write(s, mydata, realbytes);
        break;

    case OUT_REL2ADR:
        if (section == secto)
            error(ERR_PANIC, "intra-section OUT_REL2ADR");

        if (section != NO_SEG && section % 2) {
            error(ERR_NONFATAL, "Mach-O format does not support"
                  " section base references");
        } else
            add_reloc(s, section, 1, 2);

        p = mydata;
        WRITESHORT(p, *(int32_t *)data - (realbytes + s->size));
        sect_write(s, mydata, 2L);
        break;

    case OUT_REL4ADR:
        if (section == secto)
            error(ERR_PANIC, "intra-section OUT_REL4ADR");

        if (section != NO_SEG && section % 2) {
            error(ERR_NONFATAL, "Mach-O format does not support"
                  " section base references");
        } else
            add_reloc(s, section, 1, 4);

        p = mydata;
        WRITELONG(p, *(int32_t *)data - (realbytes + s->size));
        sect_write(s, mydata, 4L);
        break;

    default:
        error(ERR_PANIC, "unknown output type?");
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
                s->align = DEFAULT_SECTION_ALIGNMENT;

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
                        newAlignment = exact_log2(value);

                        if (0 != *end) {
                            error(ERR_PANIC,
                                  "unknown or missing alignment value \"%s\" "
                                      "specified for section \"%s\"",
                                  currentAttribute + 6,
                                  name);
                            return NO_SEG;
                        } else if (0 > newAlignment) {
                            error(ERR_PANIC,
                                  "alignment of %d (for section \"%s\") is not "
                                      "a power of two",
                                  value,
                                  name);
                            return NO_SEG;
                        }

                        if ((-1 != originalIndex)
                            && (s->align != newAlignment)) {
                            error(ERR_PANIC,
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
                        error(ERR_PANIC,
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

    error(ERR_PANIC, "invalid section name %s", name);
    return NO_SEG;
}

static void macho_symdef(char *name, int32_t section, int32_t offset,
                         int is_global, char *special)
{
    struct symbol *sym;

    if (special) {
        error(ERR_NONFATAL, "The Mach-O output format does "
              "not support any special symbol types");
        return;
    }

    if (is_global == 3) {
        error(ERR_NONFATAL, "The Mach-O format does not "
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
                error(ERR_PANIC, "in-file index for section %d not found",
                      section);
            }
        }
    }

    ++nsyms;
}

static int32_t macho_segbase(int32_t section)
{
    return section;
}

static int macho_directive(char *directive, char *value, int pass)
{
    (void)directive;
    (void)value;
    (void)pass;
    return 0;
}

static void macho_filename(char *inname, char *outname, efunc error)
{
    standard_extension(inname, outname, ".o", error);
}

static const char *macho_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

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
        /* zerofill sections aren't actually written to the file */
        if ((s->flags & SECTION_TYPE) != S_ZEROFILL)
            seg_filesize += s->size;

        seg_vmsize += s->size;
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
    fwriteint32_t(MH_MAGIC, machofp);	/* magic */
    fwriteint32_t(CPU_TYPE_I386, machofp);	/* CPU type */
    fwriteint32_t(CPU_SUBTYPE_I386_ALL, machofp);	/* CPU subtype */
    fwriteint32_t(MH_OBJECT, machofp);	/* Mach-O file type */
    fwriteint32_t(head_ncmds, machofp);	/* number of load commands */
    fwriteint32_t(head_sizeofcmds, machofp);	/* size of load commands */
    fwriteint32_t(0, machofp);	/* no flags */
}

/* Write out the segment load command at offset.  */

static uint32_t macho_write_segment (uint32_t offset)
{
    uint32_t s_addr = 0;
    uint32_t rel_base = alignint32_t (offset + seg_filesize);
    uint32_t s_reloff = 0;
    struct section *s;

    fwriteint32_t(LC_SEGMENT, machofp);        /* cmd == LC_SEGMENT */

    /* size of load command including section load commands */
    fwriteint32_t(MACHO_SEGCMD_SIZE + seg_nsects *
	       MACHO_SECTCMD_SIZE, machofp);

    /* in an MH_OBJECT file all sections are in one unnamed (name
    ** all zeros) segment */
    fwrite("\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 16, 1, machofp);
    fwriteint32_t(0, machofp); /* in-memory offset */
    fwriteint32_t(seg_vmsize, machofp);        /* in-memory size */
    fwriteint32_t(offset, machofp);    /* in-file offset to data */
    fwriteint32_t(seg_filesize, machofp);      /* in-file size */
    fwriteint32_t(VM_PROT_DEFAULT, machofp);   /* maximum vm protection */
    fwriteint32_t(VM_PROT_DEFAULT, machofp);   /* initial vm protection */
    fwriteint32_t(seg_nsects, machofp);        /* number of sections */
    fwriteint32_t(0, machofp); /* no flags */

    /* emit section headers */
    for (s = sects; s != NULL; s = s->next) {
	fwrite(s->sectname, sizeof(s->sectname), 1, machofp);
	fwrite(s->segname, sizeof(s->segname), 1, machofp);
	fwriteint32_t(s_addr, machofp);
	fwriteint32_t(s->size, machofp);

	/* dummy data for zerofill sections or proper values */
	if ((s->flags & SECTION_TYPE) != S_ZEROFILL) {
	    fwriteint32_t(offset, machofp);
	    /* Write out section alignment, as a power of two.
	       e.g. 32-bit word alignment would be 2 (2^^2 = 4).  */
	    fwriteint32_t(s->align, machofp);
	    /* To be compatible with cctools as we emit
	       a zero reloff if we have no relocations.  */
	    fwriteint32_t(s->nreloc ? rel_base + s_reloff : 0, machofp);
	    fwriteint32_t(s->nreloc, machofp);

	    offset += s->size;
	    s_reloff += s->nreloc * MACHO_RELINFO_SIZE;
	} else {
	    fwriteint32_t(0, machofp);
	    fwriteint32_t(0, machofp);
	    fwriteint32_t(0, machofp);
	    fwriteint32_t(0, machofp);
	}

	fwriteint32_t(s->flags, machofp);      /* flags */
	fwriteint32_t(0, machofp);     /* reserved */
	fwriteint32_t(0, machofp);     /* reserved */

	s_addr += s->size;
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

	fwriteint32_t(r->addr, machofp); /* reloc offset */

	word2 = r->snum;
	word2 |= r->pcrel << 24;
	word2 |= r->length << 25;
	word2 |= r->ext << 27;
	word2 |= r->type << 28;
	fwriteint32_t(word2, machofp); /* reloc data */

	r = r->next;
    }
}

/* Write out the section data.  */
static void macho_write_section (void)
{
    struct section *s, *s2;
    struct reloc *r;
    char *rel_paddata = "\0\0\0";
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
		/* add sizes of previous sections to current offset */
		for (s2 = sects, fi = 1;
		     s2 != NULL && fi < r->snum; s2 = s2->next, fi++)
		    if ((s2->flags & SECTION_TYPE) != S_ZEROFILL)
			l += s2->size;
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
	saa_fpwrite(s->data, machofp);
    }

    /* pad last section up to reloc entries on int32_t boundary */
    fwrite(rel_paddata, rel_padcnt, 1, machofp);

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
	    fwriteint32_t(sym->strx, machofp);		/* string table entry number */
	    fwrite(&sym->type, 1, 1, machofp);	/* symbol type */
	    fwrite(&sym->sect, 1, 1, machofp);	/* section */
	    fwriteint16_t(sym->desc, machofp);	/* description */

	    /* Fix up the symbol value now that we know the final section
	       sizes.  */
	    if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
		for (s = sects, fi = 1;
		     s != NULL && fi < sym->sect; s = s->next, ++fi)
		    sym->value += s->size;
	    }

	    fwriteint32_t(sym->value, machofp);	/* value (i.e. offset) */
	}
    }

    for (i = 0; i < nextdefsym; i++) {
	sym = extdefsyms[i];
	fwriteint32_t(sym->strx, machofp);
	fwrite(&sym->type, 1, 1, machofp);	/* symbol type */
	fwrite(&sym->sect, 1, 1, machofp);	/* section */
	fwriteint16_t(sym->desc, machofp);	/* description */

	/* Fix up the symbol value now that we know the final section
	   sizes.  */
	if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
	    for (s = sects, fi = 1;
		 s != NULL && fi < sym->sect; s = s->next, ++fi)
		sym->value += s->size;
	}

	fwriteint32_t(sym->value, machofp);	/* value (i.e. offset) */
    }

     for (i = 0; i < nundefsym; i++) {
	 sym = undefsyms[i];
	 fwriteint32_t(sym->strx, machofp);
	 fwrite(&sym->type, 1, 1, machofp);	/* symbol type */
	 fwrite(&sym->sect, 1, 1, machofp);	/* section */
	 fwriteint16_t(sym->desc, machofp);	/* description */

	 /* Fix up the symbol value now that we know the final section
	    sizes.  */
	 if (((sym->type & N_TYPE) == N_SECT) && (sym->sect != NO_SECT)) {
	     for (s = sects, fi = 1;
		  s != NULL && fi < sym->sect; s = s->next, ++fi)
		 sym->value += s->size;
	 }

	 fwriteint32_t(sym->value, machofp);	/* value (i.e. offset) */
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
        error(ERR_WARNING, "no sections?");

    if (nsyms > 0) {
        /* write out symbol command */
        fwriteint32_t(LC_SYMTAB, machofp); /* cmd == LC_SYMTAB */
        fwriteint32_t(MACHO_SYMCMD_SIZE, machofp); /* size of load command */
        fwriteint32_t(offset, machofp);    /* symbol table offset */
        fwriteint32_t(nsyms, machofp);     /* number of symbol
                                         ** table entries */

        offset += nsyms * MACHO_NLIST_SIZE;
        fwriteint32_t(offset, machofp);    /* string table offset */
        fwriteint32_t(strslen, machofp);   /* string table size */
    }

    /* emit section data */
    if (seg_nsects > 0)
	macho_write_section ();

    /* emit symbol table if we have symbols */
    if (nsyms > 0)
	macho_write_symtab ();

    /* we don't need to pad here since MACHO_NLIST_SIZE == 12 */

    /* emit string table */
    saa_fpwrite(strs, machofp);
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

    /* done - yay! */
    fclose(machofp);

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

struct ofmt of_macho = {
    "NeXTstep/OpenStep/Rhapsody/Darwin/MacOS X object files",
    "macho",
    NULL,
    null_debug_arr,
    &null_debug_form,
    macho_stdmac,
    macho_init,
    macho_setinfo,
    macho_output,
    macho_symdef,
    macho_section,
    macho_segbase,
    macho_directive,
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
