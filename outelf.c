/* outelf.c	output routines for the Netwide Assembler to produce
 *		ELF32 (i386 of course) object file format
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"

#ifdef OF_ELF

/*
 * Relocation types.
 */
#define R_386_32 1		       /* ordinary absolute relocation */
#define R_386_PC32 2		       /* PC-relative relocation */
#define R_386_GOT32 3		       /* an offset into GOT */
#define R_386_PLT32 4		       /* a PC-relative offset into PLT */
#define R_386_GOTOFF 9		       /* an offset from GOT base */
#define R_386_GOTPC 10		       /* a PC-relative offset _to_ GOT */

struct Reloc {
    struct Reloc *next;
    long address;		       /* relative to _start_ of section */
    long symbol;		       /* ELF symbol info thingy */
    int type;			       /* type of relocation */
};

struct Symbol {
    long strpos;		       /* string table position of name */
    long section;		       /* section ID of the symbol */
    int type;			       /* symbol type */
    long value;			       /* address, or COMMON variable align */
    long size;			       /* size of symbol */
    long globnum;		       /* symbol table offset if global */
    struct Symbol *next;	       /* list of globals in each section */
    struct Symbol *nextfwd;	       /* list of unresolved-size symbols */
    char *name;			       /* used temporarily if in above list */
};

#define SHT_PROGBITS 1
#define SHT_NOBITS 8

#define SHF_WRITE 1
#define SHF_ALLOC 2
#define SHF_EXECINSTR 4

struct Section {
    struct SAA *data;
    unsigned long len, size, nrelocs;
    long index;
    int type;			       /* SHT_PROGBITS or SHT_NOBITS */
    int align;			       /* alignment: power of two */
    unsigned long flags;	       /* section flags */
    char *name;
    struct SAA *rel;
    long rellen;
    struct Reloc *head, **tail;
    struct Symbol *gsyms;	       /* global symbols in section */
};

#define SECT_DELTA 32
static struct Section **sects;
static int nsects, sectlen;

#define SHSTR_DELTA 256
static char *shstrtab;
static int shstrtablen, shstrtabsize;

static struct SAA *syms;
static unsigned long nlocals, nglobs;

static long def_seg;

static struct RAA *bsym;

static struct SAA *strs;
static unsigned long strslen;

static FILE *elffp;
static efunc error;
static evalfunc evaluate;

static struct Symbol *fwds;

static char elf_module[FILENAME_MAX];

extern struct ofmt of_elf;

#define SHN_ABS 0xFFF1
#define SHN_COMMON 0xFFF2
#define SHN_UNDEF 0

#define SYM_SECTION 0x04
#define SYM_GLOBAL 0x10
#define SYM_DATA 0x01
#define SYM_FUNCTION 0x02

#define GLOBAL_TEMP_BASE 6	       /* bigger than any constant sym id */

#define SEG_ALIGN 16		       /* alignment of sections in file */
#define SEG_ALIGN_1 (SEG_ALIGN-1)

static const char align_str[SEG_ALIGN] = ""; /* ANSI will pad this with 0s */

#define ELF_MAX_SECTIONS 16	       /* really 10, but let's play safe */
static struct ELF_SECTDATA {
    void *data;
    long len;
    int is_saa;
} *elf_sects;
static int elf_nsect;
static long elf_foffs;

static void elf_write(void);
static void elf_sect_write(struct Section *, unsigned char *, unsigned long);
static void elf_section_header (int, int, int, void *, int, long,
				int, int, int, int);
static void elf_write_sections (void);
static struct SAA *elf_build_symtab (long *, long *);
static struct SAA *elf_build_reltab (long *, struct Reloc *);
static void add_sectname (char *, char *);

/*
 * Special section numbers which are used to define ELF special
 * symbols, which can be used with WRT to provide PIC relocation
 * types.
 */
static long elf_gotpc_sect, elf_gotoff_sect;
static long elf_got_sect, elf_plt_sect;
static long elf_sym_sect;

static void elf_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    elffp = fp;
    error = errfunc;
    evaluate = eval;
    (void) ldef;		       /* placate optimisers */
    sects = NULL;
    nsects = sectlen = 0;
    syms = saa_init((long)sizeof(struct Symbol));
    nlocals = nglobs = 0;
    bsym = raa_init();
    strs = saa_init(1L);
    saa_wbytes (strs, "\0", 1L);
    saa_wbytes (strs, elf_module, (long)(strlen(elf_module)+1));
    strslen = 2+strlen(elf_module);
    shstrtab = NULL;
    shstrtablen = shstrtabsize = 0;;
    add_sectname ("", "");

    fwds = NULL;

    elf_gotpc_sect = seg_alloc();
    ldef("..gotpc", elf_gotpc_sect+1, 0L, NULL, FALSE, FALSE, &of_elf, error);
    elf_gotoff_sect = seg_alloc();
    ldef("..gotoff", elf_gotoff_sect+1, 0L, NULL, FALSE, FALSE,&of_elf,error);
    elf_got_sect = seg_alloc();
    ldef("..got", elf_got_sect+1, 0L, NULL, FALSE, FALSE, &of_elf, error);
    elf_plt_sect = seg_alloc();
    ldef("..plt", elf_plt_sect+1, 0L, NULL, FALSE, FALSE, &of_elf, error);
    elf_sym_sect = seg_alloc();
    ldef("..sym", elf_sym_sect+1, 0L, NULL, FALSE, FALSE, &of_elf, error);

    def_seg = seg_alloc();
}

static void elf_cleanup(int debuginfo) 
{
    struct Reloc *r;
    int i;

    (void) debuginfo;

    elf_write();
    fclose (elffp);
    for (i=0; i<nsects; i++) {
	if (sects[i]->type != SHT_NOBITS)
	    saa_free (sects[i]->data);
	if (sects[i]->head)
	    saa_free (sects[i]->rel);
	while (sects[i]->head) {
	    r = sects[i]->head;
	    sects[i]->head = sects[i]->head->next;
	    nasm_free (r);
	}
    }
    nasm_free (sects);
    saa_free (syms);
    raa_free (bsym);
    saa_free (strs);
}

static void add_sectname (char *firsthalf, char *secondhalf) 
{
    int len = strlen(firsthalf)+strlen(secondhalf);
    while (shstrtablen + len + 1 > shstrtabsize)
	shstrtab = nasm_realloc (shstrtab, (shstrtabsize += SHSTR_DELTA));
    strcpy (shstrtab+shstrtablen, firsthalf);
    strcat (shstrtab+shstrtablen, secondhalf);
    shstrtablen += len+1;
}

static int elf_make_section (char *name, int type, int flags, int align) 
{
    struct Section *s;

    s = nasm_malloc (sizeof(*s));

    if (type != SHT_NOBITS)
	s->data = saa_init (1L);
    s->head = NULL;
    s->tail = &s->head;
    s->len = s->size = 0;
    s->nrelocs = 0;
    if (!strcmp(name, ".text"))
	s->index = def_seg;
    else
	s->index = seg_alloc();
    add_sectname ("", name);
    s->name = nasm_malloc (1+strlen(name));
    strcpy (s->name, name);
    s->type = type;
    s->flags = flags;
    s->align = align;
    s->gsyms = NULL;

    if (nsects >= sectlen)
	sects = nasm_realloc (sects, (sectlen += SECT_DELTA)*sizeof(*sects));
    sects[nsects++] = s;

    return nsects-1;
}

static long elf_section_names (char *name, int pass, int *bits) 
{
    char *p;
    int flags_and, flags_or, type, align, i;

    /*
     * Default is 32 bits.
     */
    if (!name) {
	*bits = 32;
	return def_seg;
    }

    p = name;
    while (*p && !isspace(*p)) p++;
    if (*p) *p++ = '\0';
    flags_and = flags_or = type = align = 0;

    while (*p && isspace(*p)) p++;
    while (*p) {
	char *q = p;
	while (*p && !isspace(*p)) p++;
	if (*p) *p++ = '\0';
	while (*p && isspace(*p)) p++;
	
	if (!nasm_strnicmp(q, "align=", 6)) {
	    align = atoi(q+6);
	    if (align == 0)
		align = 1;
	    if ( (align-1) & align ) {   /* means it's not a power of two */
		error (ERR_NONFATAL, "section alignment %d is not"
		       " a power of two", align);
		align = 1;
	    }
	} else if (!nasm_stricmp(q, "alloc")) {
	    flags_and |= SHF_ALLOC;
	    flags_or |= SHF_ALLOC;
	} else if (!nasm_stricmp(q, "noalloc")) {
	    flags_and |= SHF_ALLOC;
	    flags_or &= ~SHF_ALLOC;
	} else if (!nasm_stricmp(q, "exec")) {
	    flags_and |= SHF_EXECINSTR;
	    flags_or |= SHF_EXECINSTR;
	} else if (!nasm_stricmp(q, "noexec")) {
	    flags_and |= SHF_EXECINSTR;
	    flags_or &= ~SHF_EXECINSTR;
	} else if (!nasm_stricmp(q, "write")) {
	    flags_and |= SHF_WRITE;
	    flags_or |= SHF_WRITE;
	} else if (!nasm_stricmp(q, "nowrite")) {
	    flags_and |= SHF_WRITE;
	    flags_or &= ~SHF_WRITE;
	} else if (!nasm_stricmp(q, "progbits")) {
	    type = SHT_PROGBITS;
	} else if (!nasm_stricmp(q, "nobits")) {
	    type = SHT_NOBITS;
	}
    }

    if (!strcmp(name, ".comment") ||
	!strcmp(name, ".shstrtab") ||
	!strcmp(name, ".symtab") ||
	!strcmp(name, ".strtab")) {
	error (ERR_NONFATAL, "attempt to redefine reserved section"
	       "name `%s'", name);
	return NO_SEG;
    }

    for (i=0; i<nsects; i++)
	if (!strcmp(name, sects[i]->name))
	    break;
    if (i == nsects) {
	if (!strcmp(name, ".text"))
	    i = elf_make_section (name, SHT_PROGBITS,
				  SHF_ALLOC | SHF_EXECINSTR, 16);
	else if (!strcmp(name, ".data"))
	    i = elf_make_section (name, SHT_PROGBITS,
				  SHF_ALLOC | SHF_WRITE, 4);
	else if (!strcmp(name, ".bss"))
	    i = elf_make_section (name, SHT_NOBITS,
				  SHF_ALLOC | SHF_WRITE, 4);
	else
	    i = elf_make_section (name, SHT_PROGBITS, SHF_ALLOC, 1);
	if (type)
	    sects[i]->type = type;
	if (align)
	    sects[i]->align = align;
	sects[i]->flags &= ~flags_and;
	sects[i]->flags |= flags_or;
    } else if (pass == 1) {
	if (type || align || flags_and)
	    error (ERR_WARNING, "section attributes ignored on"
		   " redeclaration of section `%s'", name);
    }

    return sects[i]->index;
}

static void elf_deflabel (char *name, long segment, long offset,
			   int is_global, char *special) 
{
    int pos = strslen;
    struct Symbol *sym;
    int special_used = FALSE;

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	/*
	 * This is a NASM special symbol. We never allow it into
	 * the ELF symbol table, even if it's a valid one. If it
	 * _isn't_ a valid one, we should barf immediately.
	 */
	if (strcmp(name, "..gotpc") && strcmp(name, "..gotoff") &&
	    strcmp(name, "..got") && strcmp(name, "..plt") &&
	    strcmp(name, "..sym"))
	    error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
	return;
    }

    if (is_global == 3) {
	struct Symbol **s;
	/*
	 * Fix up a forward-reference symbol size from the first
	 * pass.
	 */
	for (s = &fwds; *s; s = &(*s)->nextfwd)
	    if (!strcmp((*s)->name, name)) {
		struct tokenval tokval;
		expr *e;
		char *p = special;

		while (*p && !isspace(*p)) p++;
		while (*p && isspace(*p)) p++;
		stdscan_reset();
		stdscan_bufptr = p;
		tokval.t_type = TOKEN_INVALID;
		e = evaluate(stdscan, NULL, &tokval, NULL, 1, error, NULL);
		if (e) {
		    if (!is_simple(e))
			error (ERR_NONFATAL, "cannot use relocatable"
			       " expression as symbol size");
		    else
			(*s)->size = reloc_value(e);
		}

		/*
		 * Remove it from the list of unresolved sizes.
		 */
		nasm_free ((*s)->name);
		*s = (*s)->nextfwd;
		return;
	    }
	return;			       /* it wasn't an important one */
    }

    saa_wbytes (strs, name, (long)(1+strlen(name)));
    strslen += 1+strlen(name);

    sym = saa_wstruct (syms);

    sym->strpos = pos;
    sym->type = is_global ? SYM_GLOBAL : 0;
    sym->size = 0;
    if (segment == NO_SEG)
	sym->section = SHN_ABS;
    else {
	int i;
	sym->section = SHN_UNDEF;
	if (nsects == 0 && segment == def_seg) {
	    int tempint;
	    if (segment != elf_section_names (".text", 2, &tempint))
		error (ERR_PANIC, "strange segment conditions in ELF driver");
	    sym->section = nsects;
	} else {
	    for (i=0; i<nsects; i++)
		if (segment == sects[i]->index) {
		    sym->section = i+1;
		    break;
		}
	}
    }

    if (is_global == 2) {
	sym->size = offset;
	sym->value = 0;
	sym->section = SHN_COMMON;
	/*
	 * We have a common variable. Check the special text to see
	 * if it's a valid number and power of two; if so, store it
	 * as the alignment for the common variable.
	 */
	if (special) {
	    int err;
	    sym->value = readnum (special, &err);
	    if (err)
		error(ERR_NONFATAL, "alignment constraint `%s' is not a"
		      " valid number", special);
	    else if ( (sym->value | (sym->value-1)) != 2*sym->value - 1)
		error(ERR_NONFATAL, "alignment constraint `%s' is not a"
		      " power of two", special);
	}
	special_used = TRUE;
    } else
	sym->value = (sym->section == SHN_UNDEF ? 0 : offset);

    if (sym->type == SYM_GLOBAL) {
	/*
	 * There's a problem here that needs fixing. 
	 * If sym->section == SHN_ABS, then the first line of the
	 * else section causes a core dump, because its a reference
	 * beyond the end of the section array.
	 * This behaviour is exhibited by this code:
	 *     GLOBAL crash_nasm
	 *     crash_nasm equ 0
	 *
	 * I'm not sure how to procede, because I haven't got the
	 * first clue about how ELF works, so I don't know what to
	 * do with it. Furthermore, I'm not sure what the rest of this
	 * section of code does. Help?
	 *
	 * For now, I'll see if doing absolutely nothing with it will
	 * work...
	 */
	if (sym->section == SHN_UNDEF || sym->section == SHN_COMMON)
	{
	    bsym = raa_write (bsym, segment, nglobs);
	}
	else if (sym->section != SHN_ABS) 
	{
	    /*
	     * This is a global symbol; so we must add it to the linked
	     * list of global symbols in its section. We'll push it on
	     * the beginning of the list, because it doesn't matter
	     * much which end we put it on and it's easier like this.
	     *
	     * In addition, we check the special text for symbol
	     * type and size information.
	     */
	    sym->next = sects[sym->section-1]->gsyms;
	    sects[sym->section-1]->gsyms = sym;

	    if (special) {
		int n = strcspn(special, " ");

		if (!nasm_strnicmp(special, "function", n))
		    sym->type |= SYM_FUNCTION;
		else if (!nasm_strnicmp(special, "data", n) ||
			 !nasm_strnicmp(special, "object", n))
		    sym->type |= SYM_DATA;
		else
		    error(ERR_NONFATAL, "unrecognised symbol type `%.*s'",
			  n, special);
		if (special[n]) {
		    struct tokenval tokval;
		    expr *e;
		    int fwd = FALSE;

		    while (special[n] && isspace(special[n]))
			n++;
		    /*
		     * We have a size expression; attempt to
		     * evaluate it.
		     */
		    stdscan_reset();
		    stdscan_bufptr = special+n;
		    tokval.t_type = TOKEN_INVALID;
		    e = evaluate(stdscan, NULL, &tokval, &fwd, 0, error, NULL);
		    if (fwd) {
			sym->nextfwd = fwds;
			fwds = sym;
			sym->name = nasm_strdup(name);
		    } else if (e) {
			if (!is_simple(e))
			    error (ERR_NONFATAL, "cannot use relocatable"
				   " expression as symbol size");
			else
			    sym->size = reloc_value(e);
		    }
		}
		special_used = TRUE;
	    }
	}
	sym->globnum = nglobs;
	nglobs++;
    } else
	nlocals++;

    if (special && !special_used)
	error(ERR_NONFATAL, "no special symbol features supported here");
}

static void elf_add_reloc (struct Section *sect, long segment,
			   int type) 
{
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    if (segment == NO_SEG)
	r->symbol = 2;
    else {
	int i;
	r->symbol = 0;
	for (i=0; i<nsects; i++)
	    if (segment == sects[i]->index)
		r->symbol = i+3;
	if (!r->symbol)
	    r->symbol = GLOBAL_TEMP_BASE + raa_read(bsym, segment);
    }
    r->type = type;

    sect->nrelocs++;
}

/*
 * This routine deals with ..got and ..sym relocations: the more
 * complicated kinds. In shared-library writing, some relocations
 * with respect to global symbols must refer to the precise symbol
 * rather than referring to an offset from the base of the section
 * _containing_ the symbol. Such relocations call to this routine,
 * which searches the symbol list for the symbol in question.
 *
 * R_386_GOT32 references require the _exact_ symbol address to be
 * used; R_386_32 references can be at an offset from the symbol.
 * The boolean argument `exact' tells us this.
 *
 * Return value is the adjusted value of `addr', having become an
 * offset from the symbol rather than the section. Should always be
 * zero when returning from an exact call.
 *
 * Limitation: if you define two symbols at the same place,
 * confusion will occur.
 *
 * Inefficiency: we search, currently, using a linked list which
 * isn't even necessarily sorted.
 */
static long elf_add_gsym_reloc (struct Section *sect,
				long segment, long offset,
				int type, int exact) 
{
    struct Reloc *r;
    struct Section *s;
    struct Symbol *sym, *sm;
    int i;

    /*
     * First look up the segment/offset pair and find a global
     * symbol corresponding to it. If it's not one of our segments,
     * then it must be an external symbol, in which case we're fine
     * doing a normal elf_add_reloc after first sanity-checking
     * that the offset from the symbol is zero.
     */
    s = NULL;
    for (i=0; i<nsects; i++)
	if (segment == sects[i]->index) {
	    s = sects[i];
	    break;
	}
    if (!s) {
	if (exact && offset != 0)
	    error (ERR_NONFATAL, "unable to find a suitable global symbol"
		   " for this reference");
	else
	    elf_add_reloc (sect, segment, type);
	return offset;
    }

    if (exact) {
	/*
	 * Find a symbol pointing _exactly_ at this one.
	 */
	for (sym = s->gsyms; sym; sym = sym->next)
	    if (sym->value == offset)
		break;
    } else {
	/*
	 * Find the nearest symbol below this one.
	 */
	sym = NULL;
	for (sm = s->gsyms; sm; sm = sm->next)
	    if (sm->value <= offset && (!sym || sm->value > sym->value))
		sym = sm;
    }
    if (!sym && exact) {
	error (ERR_NONFATAL, "unable to find a suitable global symbol"
	       " for this reference");
	return 0;
    }

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = GLOBAL_TEMP_BASE + sym->globnum;
    r->type = type;

    sect->nrelocs++;

    return offset - sym->value;
}

static void elf_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) 
{
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    long addr;
    unsigned char mydata[4], *p;
    int i;

    type &= OUT_TYPMASK;

    /*
     * handle absolute-assembly (structure definitions)
     */
    if (segto == NO_SEG) {
	if (type != OUT_RESERVE)
	    error (ERR_NONFATAL, "attempt to assemble code in [ABSOLUTE]"
		   " space");
	return;
    }

    s = NULL;
    for (i=0; i<nsects; i++)
	if (segto == sects[i]->index) {
	    s = sects[i];
	    break;
	}
    if (!s) {
	int tempint;		       /* ignored */
	if (segto != elf_section_names (".text", 2, &tempint))
	    error (ERR_PANIC, "strange segment conditions in ELF driver");
	else
	    s = sects[nsects-1];
    }

    if (s->type == SHT_NOBITS && type != OUT_RESERVE) {
	error(ERR_WARNING, "attempt to initialise memory in"
	      " BSS section `%s': ignored", s->name);
	if (type == OUT_REL2ADR)
	    realbytes = 2;
	else if (type == OUT_REL4ADR)
	    realbytes = 4;
	s->len += realbytes;
	return;
    }

    if (type == OUT_RESERVE) {
	if (s->type == SHT_PROGBITS) {
	    error(ERR_WARNING, "uninitialised space declared in"
		  " non-BSS section `%s': zeroing", s->name);
	    elf_sect_write (s, NULL, realbytes);
	} else
	    s->len += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	elf_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	addr = *(long *)data;
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "ELF format does not support"
		      " segment base references");
	    } else {
		if (wrt == NO_SEG) {
		    elf_add_reloc (s, segment, R_386_32);
		} else if (wrt == elf_gotpc_sect+1) {
		    /*
		     * The user will supply GOT relative to $$. ELF
		     * will let us have GOT relative to $. So we
		     * need to fix up the data item by $-$$.
		     */
		    addr += s->len;
		    elf_add_reloc (s, segment, R_386_GOTPC);
		} else if (wrt == elf_gotoff_sect+1) {
		    elf_add_reloc (s, segment, R_386_GOTOFF);
		} else if (wrt == elf_got_sect+1) {
		    addr = elf_add_gsym_reloc (s, segment, addr,
					       R_386_GOT32, TRUE);
		} else if (wrt == elf_sym_sect+1) {
		    addr = elf_add_gsym_reloc (s, segment, addr,
					       R_386_32, FALSE);
		} else if (wrt == elf_plt_sect+1) {
		    error(ERR_NONFATAL, "ELF format cannot produce non-PC-"
			  "relative PLT references");
		} else {
		    error (ERR_NONFATAL, "ELF format does not support this"
			   " use of WRT");
		    wrt = NO_SEG;      /* we can at least _try_ to continue */
		}
	    }
	}
	p = mydata;
	if (realbytes != 4 && segment != NO_SEG)
	    error (ERR_NONFATAL, "ELF format does not support non-32-bit"
		   " relocations");
	WRITELONG (p, addr);
	elf_sect_write (s, mydata, realbytes);
    } else if (type == OUT_REL2ADR) {
	error (ERR_NONFATAL, "ELF format does not support 16-bit"
	       " relocations");
    } else if (type == OUT_REL4ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL4ADR");
	if (segment != NO_SEG && segment % 2) {
	    error(ERR_NONFATAL, "ELF format does not support"
		  " segment base references");
	} else {
	    if (wrt == NO_SEG) {
		elf_add_reloc (s, segment, R_386_PC32);
	    } else if (wrt == elf_plt_sect+1) {
		elf_add_reloc (s, segment, R_386_PLT32);
	    } else if (wrt == elf_gotpc_sect+1 ||
		       wrt == elf_gotoff_sect+1 ||
		       wrt == elf_got_sect+1) {
		error(ERR_NONFATAL, "ELF format cannot produce PC-"
		      "relative GOT references");
	    } else {
		error (ERR_NONFATAL, "ELF format does not support this"
		       " use of WRT");
		wrt = NO_SEG;      /* we can at least _try_ to continue */
	    }
	}
	p = mydata;
	WRITELONG (p, *(long*)data - realbytes);
	elf_sect_write (s, mydata, 4L);
    }
}

static void elf_write(void) 
{
    int nsections, align;
    char *p;
    int commlen;
    char comment[64];
    int i;

    struct SAA *symtab;
    long symtablen, symtablocal;

    /*
     * Work out how many sections we will have. We have SHN_UNDEF,
     * then the flexible user sections, then the four fixed
     * sections `.comment', `.shstrtab', `.symtab' and `.strtab',
     * then optionally relocation sections for the user sections.
     */
    nsections = 5;		       /* SHN_UNDEF and the fixed ones */
    add_sectname ("", ".comment");
    add_sectname ("", ".shstrtab");
    add_sectname ("", ".symtab");
    add_sectname ("", ".strtab");
    for (i=0; i<nsects; i++) {
	nsections++;		       /* for the section itself */
	if (sects[i]->head) {
	    nsections++;	       /* for its relocations */
	    add_sectname (".rel", sects[i]->name);
	}
    }

    /*
     * Do the comment.
     */
    *comment = '\0';
    commlen = 2+sprintf(comment+1, "The Netwide Assembler %s", NASM_VER);

    /*
     * Output the ELF header.
     */
    fwrite ("\177ELF\1\1\1\0\0\0\0\0\0\0\0\0", 16, 1, elffp);
    fwriteshort (1, elffp);	       /* ET_REL relocatable file */
    fwriteshort (3, elffp);	       /* EM_386 processor ID */
    fwritelong (1L, elffp);	       /* EV_CURRENT file format version */
    fwritelong (0L, elffp);	       /* no entry point */
    fwritelong (0L, elffp);	       /* no program header table */
    fwritelong (0x40L, elffp);	       /* section headers straight after
					* ELF header plus alignment */
    fwritelong (0L, elffp);	       /* 386 defines no special flags */
    fwriteshort (0x34, elffp);	       /* size of ELF header */
    fwriteshort (0, elffp);	       /* no program header table, again */
    fwriteshort (0, elffp);	       /* still no program header table */
    fwriteshort (0x28, elffp);	       /* size of section header */
    fwriteshort (nsections, elffp);    /* number of sections */
    fwriteshort (nsects+2, elffp);     /* string table section index for
					* section header table */
    fwritelong (0L, elffp);	       /* align to 0x40 bytes */
    fwritelong (0L, elffp);
    fwritelong (0L, elffp);

    /*
     * Build the symbol table and relocation tables.
     */
    symtab = elf_build_symtab (&symtablen, &symtablocal);
    for (i=0; i<nsects; i++)
	if (sects[i]->head)
	    sects[i]->rel = elf_build_reltab (&sects[i]->rellen,
					      sects[i]->head);

    /*
     * Now output the section header table.
     */

    elf_foffs = 0x40 + 0x28 * nsections;
    align = ((elf_foffs+SEG_ALIGN_1) & ~SEG_ALIGN_1) - elf_foffs;
    elf_foffs += align;
    elf_nsect = 0;
    elf_sects = nasm_malloc(sizeof(*elf_sects) * (2 * nsects + 10));

    elf_section_header (0, 0, 0, NULL, FALSE, 0L, 0, 0, 0, 0); /* SHN_UNDEF */
    p = shstrtab+1;
    for (i=0; i<nsects; i++) {
	elf_section_header (p - shstrtab, sects[i]->type, sects[i]->flags,
			    (sects[i]->type == SHT_PROGBITS ?
			     sects[i]->data : NULL), TRUE,
			    sects[i]->len, 0, 0, sects[i]->align, 0);
	p += strlen(p)+1;
    }
    elf_section_header (p - shstrtab, 1, 0, comment, FALSE,
			(long)commlen, 0, 0, 1, 0);/* .comment */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 3, 0, shstrtab, FALSE,
			(long)shstrtablen, 0, 0, 1, 0);/* .shstrtab */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 2, 0, symtab, TRUE,
			symtablen, nsects+4, symtablocal, 4, 16);/* .symtab */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 3, 0, strs, TRUE,
			strslen, 0, 0, 1, 0);	    /* .strtab */
    for (i=0; i<nsects; i++) if (sects[i]->head) {
	p += strlen(p)+1;
	elf_section_header (p - shstrtab, 9, 0, sects[i]->rel, TRUE,
			    sects[i]->rellen, nsects+3, i+1, 4, 8);
    }

    fwrite (align_str, align, 1, elffp);

    /*
     * Now output the sections.
     */
    elf_write_sections();

    nasm_free (elf_sects);
    saa_free (symtab);
}

static struct SAA *elf_build_symtab (long *len, long *local) 
{
    struct SAA *s = saa_init(1L);
    struct Symbol *sym;
    unsigned char entry[16], *p;
    int i;

    *len = *local = 0;

    /*
     * First, an all-zeros entry, required by the ELF spec.
     */
    saa_wbytes (s, NULL, 16L);	       /* null symbol table entry */
    *len += 16;
    (*local)++;

    /*
     * Next, an entry for the file name.
     */
    p = entry;
    WRITELONG (p, 1);		       /* we know it's 1st thing in strtab */
    WRITELONG (p, 0);		       /* no value */
    WRITELONG (p, 0);		       /* no size either */
    WRITESHORT (p, 4);		       /* type FILE */
    WRITESHORT (p, SHN_ABS);
    saa_wbytes (s, entry, 16L);
    *len += 16;
    (*local)++;

    /*
     * Now some standard symbols defining the segments, for relocation
     * purposes.
     */
    for (i = 1; i <= nsects+1; i++) {
	p = entry;
	WRITELONG (p, 0);	       /* no symbol name */
	WRITELONG (p, 0);	       /* offset zero */
	WRITELONG (p, 0);	       /* size zero */
	WRITESHORT (p, 3);	       /* local section-type thing */
	WRITESHORT (p, (i==1 ? SHN_ABS : i-1));   /* the section id */
	saa_wbytes (s, entry, 16L);
	*len += 16;
	(*local)++;
    }

    /*
     * Now the other local symbols.
     */
    saa_rewind (syms);
    while ( (sym = saa_rstruct (syms)) ) {
	if (sym->type & SYM_GLOBAL)
	    continue;
	p = entry;
	WRITELONG (p, sym->strpos);
	WRITELONG (p, sym->value);
	WRITELONG (p, sym->size);
	WRITESHORT (p, sym->type);     /* local non-typed thing */
	WRITESHORT (p, sym->section);
	saa_wbytes (s, entry, 16L);
        *len += 16;
	(*local)++;
    }

    /*
     * Now the global symbols.
     */
    saa_rewind (syms);
    while ( (sym = saa_rstruct (syms)) ) {
	if (!(sym->type & SYM_GLOBAL))
	    continue;
	p = entry;
	WRITELONG (p, sym->strpos);
	WRITELONG (p, sym->value);
	WRITELONG (p, sym->size);
	WRITESHORT (p, sym->type);     /* global non-typed thing */
	WRITESHORT (p, sym->section);
	saa_wbytes (s, entry, 16L);
	*len += 16;
    }

    return s;
}

static struct SAA *elf_build_reltab (long *len, struct Reloc *r) {
    struct SAA *s;
    unsigned char *p, entry[8];

    if (!r)
	return NULL;

    s = saa_init(1L);
    *len = 0;

    while (r) {
	long sym = r->symbol;

	if (sym >= GLOBAL_TEMP_BASE)
	    sym += -GLOBAL_TEMP_BASE + (nsects+3) + nlocals;

	p = entry;
	WRITELONG (p, r->address);
	WRITELONG (p, (sym << 8) + r->type);
	saa_wbytes (s, entry, 8L);
	*len += 8;

	r = r->next;
    }

    return s;
}

static void elf_section_header (int name, int type, int flags,
				void *data, int is_saa, long datalen,
				int link, int info, int align, int eltsize) 
{
    elf_sects[elf_nsect].data = data;
    elf_sects[elf_nsect].len = datalen;
    elf_sects[elf_nsect].is_saa = is_saa;
    elf_nsect++;

    fwritelong ((long)name, elffp);
    fwritelong ((long)type, elffp);
    fwritelong ((long)flags, elffp);
    fwritelong (0L, elffp);	       /* no address, ever, in object files */
    fwritelong (type == 0 ? 0L : elf_foffs, elffp);
    fwritelong (datalen, elffp);
    if (data)
	elf_foffs += (datalen+SEG_ALIGN_1) & ~SEG_ALIGN_1;
    fwritelong ((long)link, elffp);
    fwritelong ((long)info, elffp);
    fwritelong ((long)align, elffp);
    fwritelong ((long)eltsize, elffp);
}

static void elf_write_sections (void) 
{
    int i;
    for (i = 0; i < elf_nsect; i++)
	if (elf_sects[i].data) {
	    long len = elf_sects[i].len;
	    long reallen = (len+SEG_ALIGN_1) & ~SEG_ALIGN_1;
	    long align = reallen - len;
	    if (elf_sects[i].is_saa)
		saa_fpwrite (elf_sects[i].data, elffp);
	    else
		fwrite (elf_sects[i].data, len, 1, elffp);
	    fwrite (align_str, align, 1, elffp);
	}
}

static void elf_sect_write (struct Section *sect,
			     unsigned char *data, unsigned long len) 
{
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static long elf_segbase (long segment) 
{
    return segment;
}

static int elf_directive (char *directive, char *value, int pass) 
{
    return 0;
}

static void elf_filename (char *inname, char *outname, efunc error) 
{
    strcpy(elf_module, inname);
    standard_extension (inname, outname, ".o", error);
}

static char *elf_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%define $_%1 $%1",
    "%endmacro",
    NULL
};
static int elf_set_info(enum geninfo type, char **val)
{
    return 0;
}

struct ofmt of_elf = {
    "ELF32 (i386) object files (e.g. Linux)",
    "elf",
    NULL,
    null_debug_arr,
    &null_debug_form,
    elf_stdmac,
    elf_init,
    elf_set_info,
    elf_out,
    elf_deflabel,
    elf_section_names,
    elf_segbase,
    elf_directive,
    elf_filename,
    elf_cleanup
};

#endif /* OF_ELF */
