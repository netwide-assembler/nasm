/* outelf.c	output routines for the Netwide Assembler to produce
 *		ELF64 (x86_64 of course) object file format
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "stdscan.h"
#include "outform.h"

/* Definitions in lieu of elf.h */

#define SHT_PROGBITS 1
#define SHT_RELA	  4		/* Relocation entries with addends */
#define SHT_NOBITS 8
#define SHF_WRITE	     (1 << 0)	/* Writable */
#define SHF_ALLOC	     (1 << 1)	/* Occupies memory during execution */
#define SHF_EXECINSTR	     (1 << 2)	/* Executable */
#define SHN_ABS		0xfff1		/* Associated symbol is absolute */
#define SHN_COMMON	0xfff2		/* Associated symbol is common */
#define R_X86_64_NONE		0	/* No reloc */
#define R_X86_64_64		1	/* Direct 64 bit address */
#define R_X86_64_PC32		2	/* PC relative 32 bit signed */
#define R_X86_64_GOT32		3	/* 32 bit GOT entry */
#define R_X86_64_PLT32		4	/* 32 bit PLT address */
#define R_X86_64_GOTPCREL	9	/* 32 bit signed PC relative */
#define R_X86_64_32		10	/* Direct 32 bit zero extended */
#define R_X86_64_16		12	/* Direct 16 bit zero extended */
#define R_X86_64_PC16		13	/* 16 bit sign extended pc relative */
#define R_X86_64_GOTTPOFF	22	/* 32 bit signed PC relative offset */
#define ET_REL		1		/* Relocatable file */
#define EM_X86_64	62		/* AMD x86-64 architecture */
#define STT_NOTYPE	0		/* Symbol type is unspecified */
#define STT_OBJECT	1		/* Symbol is a data object */
#define STT_FUNC	2		/* Symbol is a code object */
#define STT_SECTION	3		/* Symbol associated with a section */
#define STT_FILE	4		/* Symbol's name is file name */
#define STT_COMMON	5		/* Symbol is a common data object */
#define STT_TLS		6		/* Symbol is thread-local data object*/
#define	STT_NUM		7		/* Number of defined types.  */
typedef uint32_t Elf64_Word;
typedef uint64_t Elf64_Xword;
typedef uint64_t Elf64_Addr;
typedef uint64_t Elf64_Off;
typedef struct
{
  Elf64_Word	sh_name;		/* Section name (string tbl index) */
  Elf64_Word	sh_type;		/* Section type */
  Elf64_Xword	sh_flags;		/* Section flags */
  Elf64_Addr	sh_addr;		/* Section virtual addr at execution */
  Elf64_Off	sh_offset;		/* Section file offset */
  Elf64_Xword	sh_size;		/* Section size in bytes */
  Elf64_Word	sh_link;		/* Link to another section */
  Elf64_Word	sh_info;		/* Additional section information */
  Elf64_Xword	sh_addralign;		/* Section alignment */
  Elf64_Xword	sh_entsize;		/* Entry size if section holds table */
} Elf64_Shdr;


#ifdef OF_ELF64


struct Reloc {
    struct Reloc *next;
    int64_t address;               /* relative to _start_ of section */
    int64_t symbol;                /* symbol index */
    int type;                   /* type of relocation */
};

struct Symbol {
    int32_t strpos;                /* string table position of name */
    int32_t section;               /* section ID of the symbol */
    int type;                   /* symbol type */
    int other;                     /* symbol visibility */
    int64_t value;                 /* address, or COMMON variable align */
    int32_t size;                  /* size of symbol */
    int32_t globnum;               /* symbol table offset if global */
    struct Symbol *next;        /* list of globals in each section */
    struct Symbol *nextfwd;     /* list of unresolved-size symbols */
    char *name;                 /* used temporarily if in above list */
};


struct Section {
    struct SAA *data;
    uint32_t len, size, nrelocs;
    int32_t index;
    int type;                   /* SHT_PROGBITS or SHT_NOBITS */
    int align;                  /* alignment: power of two */
    uint32_t flags;        /* section flags */
    char *name;
    struct SAA *rel;
    int32_t rellen;
    struct Reloc *head, **tail;
    struct Symbol *gsyms;       /* global symbols in section */
};

#define SECT_DELTA 32
static struct Section **sects;
static int nsects, sectlen;

#define SHSTR_DELTA 256
static char *shstrtab;
static int shstrtablen, shstrtabsize;

static struct SAA *syms;
static uint32_t nlocals, nglobs;

static int32_t def_seg;

static struct RAA *bsym;

static struct SAA *strs;
static uint32_t strslen;

static FILE *elffp;
static efunc error;
static evalfunc evaluate;

static struct Symbol *fwds;

static char elf_module[FILENAME_MAX];

extern struct ofmt of_elf64;

#define SHN_UNDEF 0

#define SYM_GLOBAL 0x10

#define STV_DEFAULT 0
#define STV_INTERNAL 1
#define STV_HIDDEN 2
#define STV_PROTECTED 3

#define GLOBAL_TEMP_BASE 16     /* bigger than any constant sym id */

#define SEG_ALIGN 16            /* alignment of sections in file */
#define SEG_ALIGN_1 (SEG_ALIGN-1)

static const char align_str[SEG_ALIGN] = "";    /* ANSI will pad this with 0s */

#define ELF_MAX_SECTIONS 16     /* really 10, but let's play safe */
static struct ELF_SECTDATA {
    void *data;
    int32_t len;
    bool is_saa;
} *elf_sects;
static int elf_nsect;
static int32_t elf_foffs;

static void elf_write(void);
static void elf_sect_write(struct Section *, const uint8_t *,
                           uint32_t);
static void elf_section_header(int, int, int, void *, bool, int32_t, int, int,
                               int, int);
static void elf_write_sections(void);
static struct SAA *elf_build_symtab(int32_t *, int32_t *);
static struct SAA *elf_build_reltab(int32_t *, struct Reloc *);
static void add_sectname(char *, char *);

/* this stuff is needed for the stabs debugging format */
#define N_SO 0x64               /* ID for main source file */
#define N_SOL 0x84              /* ID for sub-source file */
#define N_BINCL 0x82
#define N_EINCL 0xA2
#define N_SLINE 0x44
#define TY_STABSSYMLIN 0x40     /* ouch */

struct stabentry {
    uint32_t n_strx;
    uint8_t n_type;
    uint8_t n_other;
    uint16_t n_desc;
    uint32_t n_value;
};

struct erel {
    int offset, info;
};

struct symlininfo {
    int offset;
    int section;                /* section index */
    char *name;                 /* shallow-copied pointer of section name */
};

struct linelist {
    struct symlininfo info;
    int line;
    char *filename;
    struct linelist *next;
    struct linelist *last;
};

static struct linelist *stabslines = 0;
static int stabs_immcall = 0;
static int currentline = 0;
static int numlinestabs = 0;
static char *stabs_filename = 0;
static int symtabsection;
static uint8_t *stabbuf = 0, *stabstrbuf = 0, *stabrelbuf = 0;
static int stablen, stabstrlen, stabrellen;

static struct dfmt df_stabs;
static struct Symbol *lastsym;

void stabs64_init(struct ofmt *, void *, FILE *, efunc);
void stabs64_linenum(const char *filename, int32_t linenumber, int32_t);
void stabs64_deflabel(char *, int32_t, int32_t, int, char *);
void stabs64_directive(const char *, const char *);
void stabs64_typevalue(int32_t);
void stabs64_output(int, void *);
void stabs64_generate(void);
void stabs64_cleanup(void);

/* end of stabs debugging stuff */

/*
 * Special section numbers which are used to define ELF special
 * symbols, which can be used with WRT to provide PIC relocation
 * types.
 */
static int32_t elf_gotpc_sect, elf_gotoff_sect;
static int32_t elf_got_sect, elf_plt_sect;
static int32_t elf_sym_sect;

static void elf_init(FILE * fp, efunc errfunc, ldfunc ldef, evalfunc eval)
{
    maxbits = 64;
    elffp = fp;
    error = errfunc;
    evaluate = eval;
    (void)ldef;                 /* placate optimisers */
    sects = NULL;
    nsects = sectlen = 0;
    syms = saa_init((int32_t)sizeof(struct Symbol));
    nlocals = nglobs = 0;
    bsym = raa_init();
    strs = saa_init(1L);
    saa_wbytes(strs, "\0", 1L);
    saa_wbytes(strs, elf_module, (int32_t)(strlen(elf_module) + 1));
    strslen = 2 + strlen(elf_module);
    shstrtab = NULL;
    shstrtablen = shstrtabsize = 0;;
    add_sectname("", "");

    fwds = NULL;

    elf_gotpc_sect = seg_alloc();
    ldef("..gotpc", elf_gotpc_sect + 1, 0L, NULL, false, false, &of_elf64,
         error);
    elf_gotoff_sect = seg_alloc();
    ldef("..gotoff", elf_gotoff_sect + 1, 0L, NULL, false, false, &of_elf64,
         error);
    elf_got_sect = seg_alloc();
    ldef("..got", elf_got_sect + 1, 0L, NULL, false, false, &of_elf64,
         error);
    elf_plt_sect = seg_alloc();
    ldef("..plt", elf_plt_sect + 1, 0L, NULL, false, false, &of_elf64,
         error);
    elf_sym_sect = seg_alloc();
    ldef("..sym", elf_sym_sect + 1, 0L, NULL, false, false, &of_elf64,
         error);

    def_seg = seg_alloc();
}

static void elf_cleanup(int debuginfo)
{
    struct Reloc *r;
    int i;

    (void)debuginfo;

    elf_write();
    fclose(elffp);
    for (i = 0; i < nsects; i++) {
        if (sects[i]->type != SHT_NOBITS)
            saa_free(sects[i]->data);
        if (sects[i]->head)
            saa_free(sects[i]->rel);
        while (sects[i]->head) {
            r = sects[i]->head;
            sects[i]->head = sects[i]->head->next;
            nasm_free(r);
        }
    }
    nasm_free(sects);
    saa_free(syms);
    raa_free(bsym);
    saa_free(strs);
    if (of_elf64.current_dfmt) {
        of_elf64.current_dfmt->cleanup();
    }
}

static void add_sectname(char *firsthalf, char *secondhalf)
{
    int len = strlen(firsthalf) + strlen(secondhalf);
    while (shstrtablen + len + 1 > shstrtabsize)
        shstrtab = nasm_realloc(shstrtab, (shstrtabsize += SHSTR_DELTA));
    strcpy(shstrtab + shstrtablen, firsthalf);
    strcat(shstrtab + shstrtablen, secondhalf);
    shstrtablen += len + 1;
}

static int elf_make_section(char *name, int type, int flags, int align)
{
    struct Section *s;

    s = nasm_malloc(sizeof(*s));

    if (type != SHT_NOBITS)
        s->data = saa_init(1L);
    s->head = NULL;
    s->tail = &s->head;
    s->len = s->size = 0;
    s->nrelocs = 0;
    if (!strcmp(name, ".text"))
        s->index = def_seg;
    else
        s->index = seg_alloc();
    add_sectname("", name);
    s->name = nasm_malloc(1 + strlen(name));
    strcpy(s->name, name);
    s->type = type;
    s->flags = flags;
    s->align = align;
    s->gsyms = NULL;

    if (nsects >= sectlen)
        sects =
            nasm_realloc(sects, (sectlen += SECT_DELTA) * sizeof(*sects));
    sects[nsects++] = s;

    return nsects - 1;
}

static int32_t elf_section_names(char *name, int pass, int *bits)
{
    char *p;
    unsigned flags_and, flags_or;
    int type, align, i;

    /*
     * Default is 64 bits.
     */
    if (!name) {
        *bits = 64;
        return def_seg;
    }

    p = name;
    while (*p && !isspace(*p))
        p++;
    if (*p)
        *p++ = '\0';
    flags_and = flags_or = type = align = 0;

    while (*p && isspace(*p))
        p++;
    while (*p) {
        char *q = p;
        while (*p && !isspace(*p))
            p++;
        if (*p)
            *p++ = '\0';
        while (*p && isspace(*p))
            p++;

        if (!nasm_strnicmp(q, "align=", 6)) {
            align = atoi(q + 6);
            if (align == 0)
                align = 1;
            if ((align - 1) & align) {  /* means it's not a power of two */
                error(ERR_NONFATAL, "section alignment %d is not"
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
        !strcmp(name, ".symtab") || !strcmp(name, ".strtab")) {
        error(ERR_NONFATAL, "attempt to redefine reserved section"
              "name `%s'", name);
        return NO_SEG;
    }

    for (i = 0; i < nsects; i++)
        if (!strcmp(name, sects[i]->name))
            break;
    if (i == nsects) {
        if (!strcmp(name, ".text"))
            i = elf_make_section(name, SHT_PROGBITS,
                                 SHF_ALLOC | SHF_EXECINSTR, 16);
        else if (!strcmp(name, ".rodata"))
            i = elf_make_section(name, SHT_PROGBITS, SHF_ALLOC, 4);
        else if (!strcmp(name, ".data"))
            i = elf_make_section(name, SHT_PROGBITS,
                                 SHF_ALLOC | SHF_WRITE, 4);
        else if (!strcmp(name, ".bss"))
            i = elf_make_section(name, SHT_NOBITS,
                                 SHF_ALLOC | SHF_WRITE, 4);
        else
            i = elf_make_section(name, SHT_PROGBITS, SHF_ALLOC, 1);
        if (type)
            sects[i]->type = type;
        if (align)
            sects[i]->align = align;
        sects[i]->flags &= ~flags_and;
        sects[i]->flags |= flags_or;
    } else if (pass == 1) {
          if ((type && sects[i]->type != type)
             || (align && sects[i]->align != align)
             || (flags_and && ((sects[i]->flags & flags_and) != flags_or)))
            error(ERR_WARNING, "incompatible section attributes ignored on"
                  " redeclaration of section `%s'", name);
    }

    return sects[i]->index;
}

static void elf_deflabel(char *name, int32_t segment, int32_t offset,
                         int is_global, char *special)
{
    int pos = strslen;
    struct Symbol *sym;
    bool special_used = false;

#if defined(DEBUG) && DEBUG>2
    fprintf(stderr,
            " elf_deflabel: %s, seg=%x, off=%x, is_global=%d, %s\n",
            name, segment, offset, is_global, special);
#endif
    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
        /*
         * This is a NASM special symbol. We never allow it into
         * the ELF symbol table, even if it's a valid one. If it
         * _isn't_ a valid one, we should barf immediately.
         */
        if (strcmp(name, "..gotpc") && strcmp(name, "..gotoff") &&
            strcmp(name, "..got") && strcmp(name, "..plt") &&
            strcmp(name, "..sym"))
            error(ERR_NONFATAL, "unrecognised special symbol `%s'", name);
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

                while (*p && !isspace(*p))
                    p++;
                while (*p && isspace(*p))
                    p++;
                stdscan_reset();
                stdscan_bufptr = p;
                tokval.t_type = TOKEN_INVALID;
                e = evaluate(stdscan, NULL, &tokval, NULL, 1, error, NULL);
                if (e) {
                    if (!is_simple(e))
                        error(ERR_NONFATAL, "cannot use relocatable"
                              " expression as symbol size");
                    else
                        (*s)->size = reloc_value(e);
                }

                /*
                 * Remove it from the list of unresolved sizes.
                 */
                nasm_free((*s)->name);
                *s = (*s)->nextfwd;
                return;
            }
        return;                 /* it wasn't an important one */
    }

    saa_wbytes(strs, name, (int32_t)(1 + strlen(name)));
    strslen += 1 + strlen(name);

    lastsym = sym = saa_wstruct(syms);

    sym->strpos = pos;
    sym->type = is_global ? SYM_GLOBAL : 0;
    sym->other = STV_DEFAULT;
    sym->size = 0;
    if (segment == NO_SEG)
        sym->section = SHN_ABS;
    else {
        int i;
        sym->section = SHN_UNDEF;
        if (nsects == 0 && segment == def_seg) {
            int tempint;
            if (segment != elf_section_names(".text", 2, &tempint))
                error(ERR_PANIC,
                      "strange segment conditions in ELF driver");
            sym->section = nsects;
        } else {
            for (i = 0; i < nsects; i++)
                if (segment == sects[i]->index) {
                    sym->section = i + 1;
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
            bool err;
            sym->value = readnum(special, &err);
            if (err)
                error(ERR_NONFATAL, "alignment constraint `%s' is not a"
                      " valid number", special);
            else if ((sym->value | (sym->value - 1)) != 2 * sym->value - 1)
                error(ERR_NONFATAL, "alignment constraint `%s' is not a"
                      " power of two", special);
        }
        special_used = true;
    } else
        sym->value = (sym->section == SHN_UNDEF ? 0 : offset);

    if (sym->type == SYM_GLOBAL) {
        /*
         * If sym->section == SHN_ABS, then the first line of the
         * else section would cause a core dump, because its a reference
         * beyond the end of the section array.
         * This behaviour is exhibited by this code:
         *     GLOBAL crash_nasm
         *     crash_nasm equ 0
         * To avoid such a crash, such requests are silently discarded.
         * This may not be the best solution.
         */
        if (sym->section == SHN_UNDEF || sym->section == SHN_COMMON) {
            bsym = raa_write(bsym, segment, nglobs);
        } else if (sym->section != SHN_ABS) {
            /*
             * This is a global symbol; so we must add it to the linked
             * list of global symbols in its section. We'll push it on
             * the beginning of the list, because it doesn't matter
             * much which end we put it on and it's easier like this.
             *
             * In addition, we check the special text for symbol
             * type and size information.
             */
            sym->next = sects[sym->section - 1]->gsyms;
            sects[sym->section - 1]->gsyms = sym;

            if (special) {
                int n = strcspn(special, " \t");

                if (!nasm_strnicmp(special, "function", n))
                    sym->type |= STT_FUNC;
                else if (!nasm_strnicmp(special, "data", n) ||
                         !nasm_strnicmp(special, "object", n))
                    sym->type |= STT_OBJECT;
                else if (!nasm_strnicmp(special, "notype", n))
                    sym->type |= STT_NOTYPE;
                else
                    error(ERR_NONFATAL, "unrecognised symbol type `%.*s'",
                          n, special);
                special += n;

                while (isspace(*special))
                    ++special;
                if (*special) {
                    n = strcspn(special, " \t");
                    if (!nasm_strnicmp(special, "default", n))
                        sym->other = STV_DEFAULT;
                    else if (!nasm_strnicmp(special, "internal", n))
                        sym->other = STV_INTERNAL;
                    else if (!nasm_strnicmp(special, "hidden", n))
                        sym->other = STV_HIDDEN;
                    else if (!nasm_strnicmp(special, "protected", n))
                        sym->other = STV_PROTECTED;
                    else
                        n = 0;
                    special += n;
                }

                if (*special) {
                    struct tokenval tokval;
                    expr *e;
		    int fwd = 0;
                    char *saveme = stdscan_bufptr;      /* bugfix? fbk 8/10/00 */

                    while (special[n] && isspace(special[n]))
                        n++;
                    /*
                     * We have a size expression; attempt to
                     * evaluate it.
                     */
                    stdscan_reset();
                    stdscan_bufptr = special + n;
                    tokval.t_type = TOKEN_INVALID;
                    e = evaluate(stdscan, NULL, &tokval, &fwd, 0, error,
                                 NULL);
                    if (fwd) {
                        sym->nextfwd = fwds;
                        fwds = sym;
                        sym->name = nasm_strdup(name);
                    } else if (e) {
                        if (!is_simple(e))
                            error(ERR_NONFATAL, "cannot use relocatable"
                                  " expression as symbol size");
                        else
                            sym->size = reloc_value(e);
                    }
                    stdscan_bufptr = saveme;    /* bugfix? fbk 8/10/00 */
                }
                special_used = true;
            }
        }
        sym->globnum = nglobs;
        nglobs++;
    } else
        nlocals++;

    if (special && !special_used)
        error(ERR_NONFATAL, "no special symbol features supported here");
}

static void elf_add_reloc(struct Section *sect, int32_t segment, int type)
{
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    if (segment == NO_SEG)
        r->symbol = 0;
    else {
        int i;
        r->symbol = 0;
        for (i = 0; i < nsects; i++)
            if (segment == sects[i]->index)
                r->symbol = i + 2;
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
static int32_t elf_add_gsym_reloc(struct Section *sect,
                               int32_t segment, int64_t offset,
                               int type, bool exact)
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
    for (i = 0; i < nsects; i++)
        if (segment == sects[i]->index) {
            s = sects[i];
            break;
        }
    if (!s) {
        if (exact && offset != 0)
            error(ERR_NONFATAL, "unable to find a suitable global symbol"
                  " for this reference");
        else
            elf_add_reloc(sect, segment, type);
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
        error(ERR_NONFATAL, "unable to find a suitable global symbol"
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

static void elf_out(int32_t segto, const void *data, uint32_t type,
                    int32_t segment, int32_t wrt)
{
    struct Section *s;
    int32_t realbytes = type & OUT_SIZMASK;
    int64_t addr;
    uint8_t mydata[16], *p;
    int i;
    static struct symlininfo sinfo;

    type &= OUT_TYPMASK;

#if defined(DEBUG) && DEBUG>2
    fprintf(stderr,
            " elf_out type: %x seg: %d bytes: %x data: %x\n",
               (type >> 24), segment, realbytes, *(int32_t *)data);
#endif

    /*
     * handle absolute-assembly (structure definitions)
     */
    if (segto == NO_SEG) {
        if (type != OUT_RESERVE)
            error(ERR_NONFATAL, "attempt to assemble code in [ABSOLUTE]"
                  " space");
        return;
    }

    s = NULL;
    for (i = 0; i < nsects; i++)
        if (segto == sects[i]->index) {
            s = sects[i];
            break;
        }
    if (!s) {
        int tempint;            /* ignored */
        if (segto != elf_section_names(".text", 2, &tempint))
            error(ERR_PANIC, "strange segment conditions in ELF driver");
        else {
            s = sects[nsects - 1];
            i = nsects - 1;
        }
    }

    /* again some stabs debugging stuff */
    if (of_elf64.current_dfmt) {
        sinfo.offset = s->len;
        sinfo.section = i;
        sinfo.name = s->name;
        of_elf64.current_dfmt->debug_output(TY_STABSSYMLIN, &sinfo);
    }
    /* end of debugging stuff */

    if (s->type == SHT_NOBITS && type != OUT_RESERVE) {
        error(ERR_WARNING, "attempt to initialize memory in"
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
            error(ERR_WARNING, "uninitialized space declared in"
                  " non-BSS section `%s': zeroing", s->name);
            elf_sect_write(s, NULL, realbytes);
        } else
            s->len += realbytes;
    } else if (type == OUT_RAWDATA) {
        if (segment != NO_SEG)
            error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
        elf_sect_write(s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
        bool gnu16 = false;
        addr = *(int64_t *)data;
        if (segment != NO_SEG) {
            if (segment % 2) {
                error(ERR_NONFATAL, "ELF format does not support"
                      " segment base references");
            } else {
                if (wrt == NO_SEG) {
		    switch (realbytes) {
		    case 2:
                        elf_add_reloc(s, segment, R_X86_64_16);
			break;
		    case 4:
                        elf_add_reloc(s, segment, R_X86_64_32);
			break;
		    case 8:
			elf_add_reloc(s, segment, R_X86_64_64);
			break;
		    default:
			error(ERR_PANIC, "internal error elf64-hpa-871");
			break;
                    }
                } else if (wrt == elf_gotpc_sect + 1) {
                    /*
                     * The user will supply GOT relative to $$. ELF
                     * will let us have GOT relative to $. So we
                     * need to fix up the data item by $-$$.
                     */
                    addr += s->len;
                    elf_add_reloc(s, segment, R_X86_64_GOTPCREL);
                } else if (wrt == elf_gotoff_sect + 1) {
                    elf_add_reloc(s, segment, R_X86_64_GOTTPOFF);
                } else if (wrt == elf_got_sect + 1) {
                    addr = elf_add_gsym_reloc(s, segment, addr,
                                              R_X86_64_GOT32, true);
                } else if (wrt == elf_sym_sect + 1) {
		    switch (realbytes) {
		    case 2:
                        gnu16 = true;
                        addr = elf_add_gsym_reloc(s, segment, addr,
                                                  R_X86_64_16, false);
			break;
		    case 4:
                        addr = elf_add_gsym_reloc(s, segment, addr,
                                                  R_X86_64_32, false);
			break;
		    case 8:
			addr = elf_add_gsym_reloc(s, segment, addr,
						  R_X86_64_64, false);
			break;
		    default:
			error(ERR_PANIC, "internal error elf64-hpa-903");
			break;
                    }
                } else if (wrt == elf_plt_sect + 1) {
                    error(ERR_NONFATAL, "ELF format cannot produce non-PC-"
                          "relative PLT references");
                } else {
                    error(ERR_NONFATAL, "ELF format does not support this"
                          " use of WRT");
                    wrt = NO_SEG;       /* we can at least _try_ to continue */
                }
            }
        }
        p = mydata;
        if (gnu16) {
            WRITESHORT(p, addr);
        } else {
            if (realbytes != 8 && realbytes != 4 && segment != NO_SEG) {
                error(ERR_NONFATAL,
                      "Unsupported non-64-bit ELF relocation");
            }
            if (realbytes == 4) WRITELONG(p, addr);
            else WRITEDLONG(p, (int64_t)addr);
        }
        elf_sect_write(s, mydata, realbytes);
    } else if (type == OUT_REL2ADR) {
        if (segment == segto)
            error(ERR_PANIC, "intra-segment OUT_REL2ADR");
        if (segment != NO_SEG && segment % 2) {
            error(ERR_NONFATAL, "ELF format does not support"
                  " segment base references");
        } else {
            if (wrt == NO_SEG) {
                elf_add_reloc(s, segment, R_X86_64_PC16);
            } else {
                error(ERR_NONFATAL,
                      "Unsupported non-32-bit ELF relocation [2]");
            }
        }
        p = mydata;
        WRITESHORT(p, *(int32_t *)data - realbytes);
        elf_sect_write(s, mydata, 2L);
    } else if (type == OUT_REL4ADR) {
        if (segment == segto)
            error(ERR_PANIC, "intra-segment OUT_REL4ADR");
        if (segment != NO_SEG && segment % 2) {
            error(ERR_NONFATAL, "ELF format does not support"
                  " segment base references");
        } else {
            if (wrt == NO_SEG) {
                elf_add_reloc(s, segment, R_X86_64_PC32);
            } else if (wrt == elf_plt_sect + 1) {
                elf_add_reloc(s, segment, R_X86_64_PLT32);
            } else if (wrt == elf_gotpc_sect + 1 ||
                       wrt == elf_gotoff_sect + 1 ||
                       wrt == elf_got_sect + 1) {
                error(ERR_NONFATAL, "ELF format cannot produce PC-"
                      "relative GOT references");
            } else {
                error(ERR_NONFATAL, "ELF format does not support this"
                      " use of WRT");
                wrt = NO_SEG;   /* we can at least _try_ to continue */
            }
        }
        p = mydata;
        WRITELONG(p, *(int32_t *)data - realbytes);
        elf_sect_write(s, mydata, 4L);
    }
}

static void elf_write(void)
{
    int nsections, align;
    int scount;
    char *p;
    int commlen;
    char comment[64];
    int i;

    struct SAA *symtab;
    int32_t symtablen, symtablocal;

    /*
     * Work out how many sections we will have. We have SHN_UNDEF,
     * then the flexible user sections, then the four fixed
     * sections `.comment', `.shstrtab', `.symtab' and `.strtab',
     * then optionally relocation sections for the user sections.
     */
    if (of_elf64.current_dfmt == &df_stabs)
        nsections = 8;
    else
        nsections = 5;          /* SHN_UNDEF and the fixed ones */

    add_sectname("", ".comment");
    add_sectname("", ".shstrtab");
    add_sectname("", ".symtab");
    add_sectname("", ".strtab");
    for (i = 0; i < nsects; i++) {
        nsections++;            /* for the section itself */
        if (sects[i]->head) {
            nsections++;        /* for its relocations without addends*/
            add_sectname(".rela", sects[i]->name);
        }
    }

    if (of_elf64.current_dfmt == &df_stabs) {
        /* in case the debug information is wanted, just add these three sections... */
        add_sectname("", ".stab");
        add_sectname("", ".stabstr");
        add_sectname(".rel", ".stab");
    }

    /*
     * Do the comment.
     */
    *comment = '\0';
    commlen =
        2 + sprintf(comment + 1, "The Netwide Assembler %s", NASM_VER);

    /*
     * Output the ELF header.
     */
    fwrite("\177ELF\2\1\1\0\0\0\0\0\0\0\0\0", 16, 1, elffp);
    fwriteint16_t(ET_REL, elffp);      /* relocatable file */
    fwriteint16_t(EM_X86_64, elffp);      /* processor ID */
    fwriteint32_t(1L, elffp);      /* EV_CURRENT file format version */
    fwriteint64_t(0L, elffp);      /* no entry point */
    fwriteint64_t(0L, elffp);      /* no program header table */
    fwriteint64_t(0x40L, elffp);   /* section headers straight after
                                 * ELF header plus alignment */
    fwriteint32_t(0L, elffp);      /* 386 defines no special flags */
    fwriteint16_t(0x40, elffp);   /* size of ELF header */
    fwriteint16_t(0, elffp);      /* no program header table, again */
    fwriteint16_t(0, elffp);      /* still no program header table */
    fwriteint16_t(sizeof(Elf64_Shdr), elffp);   /* size of section header */
    fwriteint16_t(nsections, elffp);      /* number of sections */
    fwriteint16_t(nsects + 2, elffp);     /* string table section index for
                                         * section header table */

    /*
     * Build the symbol table and relocation tables.
     */
    symtab = elf_build_symtab(&symtablen, &symtablocal);
    for (i = 0; i < nsects; i++)
        if (sects[i]->head)
            sects[i]->rel = elf_build_reltab(&sects[i]->rellen,
                                             sects[i]->head);

    /*
     * Now output the section header table.
     */

    elf_foffs = 0x40 + sizeof(Elf64_Shdr) * nsections;
    align = ((elf_foffs + SEG_ALIGN_1) & ~SEG_ALIGN_1) - elf_foffs;
    elf_foffs += align;
    elf_nsect = 0;
    elf_sects = nasm_malloc(sizeof(*elf_sects) * (2 * nsects + 10));

    elf_section_header(0, 0, 0, NULL, false, 0L, 0, 0, 0, 0);   /* SHN_UNDEF */
    scount = 1;                 /* needed for the stabs debugging to track the symtable section */
    p = shstrtab + 1;
    for (i = 0; i < nsects; i++) {
        elf_section_header(p - shstrtab, sects[i]->type, sects[i]->flags,
                           (sects[i]->type == SHT_PROGBITS ?
                            sects[i]->data : NULL), true,
                           sects[i]->len, 0, 0, sects[i]->align, 0);
        p += strlen(p) + 1;
        scount++;               /* dito */
    }
    elf_section_header(p - shstrtab, 1, 0, comment, false, (int32_t)commlen, 0, 0, 1, 0);  /* .comment */
    scount++;                   /* dito */
    p += strlen(p) + 1;
    elf_section_header(p - shstrtab, 3, 0, shstrtab, false, (int32_t)shstrtablen, 0, 0, 1, 0);     /* .shstrtab */
    scount++;                   /* dito */
    p += strlen(p) + 1;
    elf_section_header(p - shstrtab, 2, 0, symtab, true, symtablen, nsects + 4, symtablocal, 4, 24);    /* .symtab */
    symtabsection = scount;     /* now we got the symtab section index in the ELF file */
    p += strlen(p) + 1;
    elf_section_header(p - shstrtab, 3, 0, strs, true, strslen, 0, 0, 1, 0);    /* .strtab */
    for (i = 0; i < nsects; i++)
        if (sects[i]->head) {
            p += strlen(p) + 1;
            elf_section_header(p - shstrtab,SHT_RELA, 0, sects[i]->rel, true,
                               sects[i]->rellen, nsects + 3, i + 1, 4, 24);
        }
    if (of_elf64.current_dfmt == &df_stabs) {
        /* for debugging information, create the last three sections
           which are the .stab , .stabstr and .rel.stab sections respectively */

        /* this function call creates the stab sections in memory */
        stabs64_generate();

        if ((stabbuf) && (stabstrbuf) && (stabrelbuf)) {
            p += strlen(p) + 1;
            elf_section_header(p - shstrtab, 1, 0, stabbuf, false, stablen,
                               nsections - 2, 0, 4, 12);

            p += strlen(p) + 1;
            elf_section_header(p - shstrtab, 3, 0, stabstrbuf, false,
                               stabstrlen, 0, 0, 4, 0);

            p += strlen(p) + 1;
            /* link -> symtable  info -> section to refer to */
            elf_section_header(p - shstrtab, 9, 0, stabrelbuf, false,
                               stabrellen, symtabsection, nsections - 3, 4,
                               16);
        }
    }
    fwrite(align_str, align, 1, elffp);

    /*
     * Now output the sections.
     */
    elf_write_sections();

    nasm_free(elf_sects);
    saa_free(symtab);
}

static struct SAA *elf_build_symtab(int32_t *len, int32_t *local)
{
    struct SAA *s = saa_init(1L);
    struct Symbol *sym;
    uint8_t entry[24], *p;
    int i;

    *len = *local = 0;

    /*
     * First, an all-zeros entry, required by the ELF spec.
     */
    saa_wbytes(s, NULL, 24L);   /* null symbol table entry */
    *len += 24;
    (*local)++;

    /*
     * Next, an entry for the file name.
     */
    p = entry;
    WRITELONG(p, 1);            /* we know it's 1st entry in strtab */
    WRITESHORT(p, STT_FILE);    /* type FILE */
    WRITESHORT(p, SHN_ABS);
    WRITEDLONG(p, (uint64_t) 0);  /* no value */
    WRITEDLONG(p, (uint64_t) 0);  /* no size either */
    saa_wbytes(s, entry, 24L);
    *len += 24;
    (*local)++;

    /*
     * Now some standard symbols defining the segments, for relocation
     * purposes.
     */
    for (i = 1; i <= nsects; i++) {
        p = entry;
        WRITELONG(p, 0);        /* no symbol name */
        WRITESHORT(p, STT_SECTION);       /* type, binding, and visibility */
        WRITESHORT(p, i);       /* section id */
        WRITEDLONG(p, (uint64_t) 0);        /* offset zero */
        WRITEDLONG(p, (uint64_t) 0);        /* size zero */
        saa_wbytes(s, entry, 24L);
        *len += 24;
        (*local)++;
    }

    /*
     * Now the other local symbols.
     */
    saa_rewind(syms);
    while ((sym = saa_rstruct(syms))) {
        if (sym->type & SYM_GLOBAL)
            continue;
        p = entry;
        WRITELONG(p, sym->strpos);
        WRITECHAR(p, sym->type);        /* type and binding */
        WRITECHAR(p, sym->other);	/* visibility */
        WRITESHORT(p, sym->section);
        WRITEDLONG(p, (int64_t)sym->value);
        WRITEDLONG(p, (int64_t)sym->size);
        saa_wbytes(s, entry, 24L);
        *len += 24;
        (*local)++;
    }

    /*
     * Now the global symbols.
     */
    saa_rewind(syms);
    while ((sym = saa_rstruct(syms))) {
        if (!(sym->type & SYM_GLOBAL))
            continue;
        p = entry;
        WRITELONG(p, sym->strpos);
        WRITECHAR(p, sym->type);        /* type and binding */
        WRITECHAR(p, sym->other);       /* visibility */
        WRITESHORT(p, sym->section);
        WRITEDLONG(p, (int64_t)sym->value);
        WRITEDLONG(p, (int64_t)sym->size);
        saa_wbytes(s, entry, 24L);
        *len += 24;
    }

    return s;
}

static struct SAA *elf_build_reltab(int32_t *len, struct Reloc *r)
{
    struct SAA *s;
    uint8_t *p, entry[24];

    if (!r)
        return NULL;

    s = saa_init(1L);
    *len = 0;

    while (r) {
        int64_t sym = r->symbol;

        if (sym >= GLOBAL_TEMP_BASE)
            sym += -GLOBAL_TEMP_BASE + (nsects + 2) + nlocals;

        p = entry;
        WRITEDLONG(p, r->address);
        WRITEDLONG(p, (sym << 32) + r->type);
	WRITEDLONG(p, (uint64_t) 0);
        saa_wbytes(s, entry, 24L);
        *len += 24;

        r = r->next;
    }

    return s;
}

static void elf_section_header(int name, int type, int flags,
                               void *data, bool is_saa, int32_t datalen,
                               int link, int info, int align, int eltsize)
{
    elf_sects[elf_nsect].data = data;
    elf_sects[elf_nsect].len = datalen;
    elf_sects[elf_nsect].is_saa = is_saa;
    elf_nsect++;

    fwriteint32_t((int32_t)name, elffp);
    fwriteint32_t((int32_t)type, elffp);
    fwriteint64_t((int64_t)flags, elffp);
    fwriteint64_t(0L, elffp);      /* no address, ever, in object files */
    fwriteint64_t(type == 0 ? 0L : elf_foffs, elffp);
    fwriteint64_t(datalen, elffp);
    if (data)
        elf_foffs += (datalen + SEG_ALIGN_1) & ~SEG_ALIGN_1;
    fwriteint32_t((int32_t)link, elffp);
    fwriteint32_t((int32_t)info, elffp);
    fwriteint64_t((int64_t)align, elffp);
    fwriteint64_t((int64_t)eltsize, elffp);
}

static void elf_write_sections(void)
{
    int i;
    for (i = 0; i < elf_nsect; i++)
        if (elf_sects[i].data) {
            int32_t len = elf_sects[i].len;
            int32_t reallen = (len + SEG_ALIGN_1) & ~SEG_ALIGN_1;
            int32_t align = reallen - len;
            if (elf_sects[i].is_saa)
                saa_fpwrite(elf_sects[i].data, elffp);
            else
                fwrite(elf_sects[i].data, len, 1, elffp);
            fwrite(align_str, align, 1, elffp);
        }
}

static void elf_sect_write(struct Section *sect,
                           const uint8_t *data, uint32_t len)
{
    saa_wbytes(sect->data, data, len);
    sect->len += len;
}

static int32_t elf_segbase(int32_t segment)
{
    return segment;
}

static int elf_directive(char *directive, char *value, int pass)
{
    (void)directive;
    (void)value;
    (void)pass;
    return 0;
}

static void elf_filename(char *inname, char *outname, efunc error)
{
    strcpy(elf_module, inname);
    standard_extension(inname, outname, ".o", error);
}

static const char *elf_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%define $_%1 $%1",
    "%endmacro",
    NULL
};
static int elf_set_info(enum geninfo type, char **val)
{
    (void)type;
    (void)val;
    return 0;
}

static struct dfmt df_stabs = {
    "ELF64 (X86_64) stabs debug format for Linux",
    "stabs",
    stabs64_init,
    stabs64_linenum,
    stabs64_deflabel,
    stabs64_directive,
    stabs64_typevalue,
    stabs64_output,
    stabs64_cleanup
};

struct dfmt *elf64_debugs_arr[2] = { &df_stabs, NULL };

struct ofmt of_elf64 = {
    "ELF64 (x86_64) object files (e.g. Linux)",
    "elf64",
    NULL,
    elf64_debugs_arr,
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

/* again, the stabs debugging stuff (code) */

void stabs64_init(struct ofmt *of, void *id, FILE * fp, efunc error)
{
    (void)of;
    (void)id;
    (void)fp;
    (void)error;
}

void stabs64_linenum(const char *filename, int32_t linenumber, int32_t segto)
{
    (void)segto;

    if (!stabs_filename) {
        stabs_filename = (char *)nasm_malloc(strlen(filename) + 1);
        strcpy(stabs_filename, filename);
    } else {
        if (strcmp(stabs_filename, filename)) {
            /* yep, a memory leak...this program is one-shot anyway, so who cares...
               in fact, this leak comes in quite handy to maintain a list of files
               encountered so far in the symbol lines... */

            /* why not nasm_free(stabs_filename); we're done with the old one */

            stabs_filename = (char *)nasm_malloc(strlen(filename) + 1);
            strcpy(stabs_filename, filename);
        }
    }
    stabs_immcall = 1;
    currentline = linenumber;
}

void stabs64_deflabel(char *name, int32_t segment, int32_t offset, int is_global,
                    char *special)
{
    (void)name;
    (void)segment;
    (void)offset;
    (void)is_global;
    (void)special;
}

void stabs64_directive(const char *directive, const char *params)
{
    (void)directive;
    (void)params;
}

void stabs64_typevalue(int32_t type)
{
    int32_t stype, ssize;
    switch (TYM_TYPE(type)) {
        case TY_LABEL:
            ssize = 0;
            stype = STT_NOTYPE;
            break;
        case TY_BYTE:
            ssize = 1;
            stype = STT_OBJECT;
            break;
        case TY_WORD:
            ssize = 2;
            stype = STT_OBJECT;
            break;
        case TY_DWORD:
            ssize = 4;
            stype = STT_OBJECT;
            break;
        case TY_FLOAT:
            ssize = 4;
            stype = STT_OBJECT;
            break;
        case TY_QWORD:
            ssize = 8;
            stype = STT_OBJECT;
            break;
        case TY_TBYTE:
            ssize = 10;
            stype = STT_OBJECT;
            break;
        case TY_OWORD:
            ssize = 8;
            stype = STT_OBJECT;
            break;
        case TY_COMMON:
            ssize = 0;
            stype = STT_COMMON;
            break;
        case TY_SEG:
            ssize = 0;
            stype = STT_SECTION;
            break;
        case TY_EXTERN:
            ssize = 0;
            stype = STT_NOTYPE;
            break;
        case TY_EQU:
            ssize = 0;
            stype = STT_NOTYPE;
            break;
        default:
            ssize = 0;
            stype = STT_NOTYPE;
            break;
    }
    if (stype == STT_OBJECT && !lastsym->type) {
        lastsym->size = ssize;
        lastsym->type = stype;
    }
}

void stabs64_output(int type, void *param)
{
    struct symlininfo *s;
    struct linelist *el;
    if (type == TY_STABSSYMLIN) {
        if (stabs_immcall) {
            s = (struct symlininfo *)param;
            if (!(sects[s->section]->flags & SHF_EXECINSTR))
                return;         /* we are only interested in the text stuff */
            numlinestabs++;
            el = (struct linelist *)nasm_malloc(sizeof(struct linelist));
            el->info.offset = s->offset;
            el->info.section = s->section;
            el->info.name = s->name;
            el->line = currentline;
            el->filename = stabs_filename;
            el->next = 0;
            if (stabslines) {
                stabslines->last->next = el;
                stabslines->last = el;
            } else {
                stabslines = el;
                stabslines->last = el;
            }
        }
    }
    stabs_immcall = 0;
}

#define WRITE_STAB(p,n_strx,n_type,n_other,n_desc,n_value) \
  do {\
    WRITELONG(p,n_strx); \
    WRITECHAR(p,n_type); \
    WRITECHAR(p,n_other); \
    WRITESHORT(p,n_desc); \
    WRITELONG(p,n_value); \
  } while (0)

/* for creating the .stab , .stabstr and .rel.stab sections in memory */

void stabs64_generate(void)
{
    int i, numfiles, strsize, numstabs = 0, currfile, mainfileindex;
    uint8_t *sbuf, *ssbuf, *rbuf, *sptr, *rptr;
    char **allfiles;
    int *fileidx;

    struct linelist *ptr;

    ptr = stabslines;

    allfiles = (char **)nasm_malloc(numlinestabs * sizeof(int8_t *));
    for (i = 0; i < numlinestabs; i++)
        allfiles[i] = 0;
    numfiles = 0;
    while (ptr) {
        if (numfiles == 0) {
            allfiles[0] = ptr->filename;
            numfiles++;
        } else {
            for (i = 0; i < numfiles; i++) {
                if (!strcmp(allfiles[i], ptr->filename))
                    break;
            }
            if (i >= numfiles) {
                allfiles[i] = ptr->filename;
                numfiles++;
            }
        }
        ptr = ptr->next;
    }
    strsize = 1;
    fileidx = (int *)nasm_malloc(numfiles * sizeof(int));
    for (i = 0; i < numfiles; i++) {
        fileidx[i] = strsize;
        strsize += strlen(allfiles[i]) + 1;
    }
    mainfileindex = 0;
    for (i = 0; i < numfiles; i++) {
        if (!strcmp(allfiles[i], elf_module)) {
            mainfileindex = i;
            break;
        }
    }

    /* worst case size of the stab buffer would be:
       the sourcefiles changes each line, which would mean 1 SOL, 1 SYMLIN per line
     */
    sbuf =
        (uint8_t *)nasm_malloc((numlinestabs * 2 + 3) *
                                     sizeof(struct stabentry));

    ssbuf = (uint8_t *)nasm_malloc(strsize);

    rbuf = (uint8_t *)nasm_malloc(numlinestabs * 16 * (2 + 3));
    rptr = rbuf;

    for (i = 0; i < numfiles; i++) {
        strcpy((char *)ssbuf + fileidx[i], allfiles[i]);
    }
    ssbuf[0] = 0;

    stabstrlen = strsize;       /* set global variable for length of stab strings */

    sptr = sbuf;
    ptr = stabslines;
    numstabs = 0;

    if (ptr) {
        /* this is the first stab, its strx points to the filename of the
        the source-file, the n_desc field should be set to the number
        of remaining stabs
        */
        WRITE_STAB(sptr, fileidx[0], 0, 0, 0, strlen(allfiles[0] + 12));

        /* this is the stab for the main source file */
        WRITE_STAB(sptr, fileidx[mainfileindex], N_SO, 0, 0, 0);

        /* relocation table entry */

        /* Since the symbol table has two entries before */
        /* the section symbols, the index in the info.section */
        /* member must be adjusted by adding 2 */

        WRITEDLONG(rptr, (int64_t)(sptr - sbuf) - 4);
	WRITELONG(rptr, R_X86_64_32);
	WRITELONG(rptr, ptr->info.section + 2);

        numstabs++;
        currfile = mainfileindex;
    }

    while (ptr) {
        if (strcmp(allfiles[currfile], ptr->filename)) {
            /* oops file has changed... */
            for (i = 0; i < numfiles; i++)
                if (!strcmp(allfiles[i], ptr->filename))
                    break;
            currfile = i;
            WRITE_STAB(sptr, fileidx[currfile], N_SOL, 0, 0,
                       ptr->info.offset);
            numstabs++;

            /* relocation table entry */

            WRITEDLONG(rptr, (int64_t)(sptr - sbuf) - 4);
	    WRITELONG(rptr, R_X86_64_32);
	    WRITELONG(rptr, ptr->info.section + 2);
        }

        WRITE_STAB(sptr, 0, N_SLINE, 0, ptr->line, ptr->info.offset);
        numstabs++;

        /* relocation table entry */

        WRITEDLONG(rptr, (int64_t)(sptr - sbuf) - 4);
	WRITELONG(rptr, R_X86_64_32);
	WRITELONG(rptr, ptr->info.section + 2);

        ptr = ptr->next;

    }

    ((struct stabentry *)sbuf)->n_desc = numstabs;

    nasm_free(allfiles);
    nasm_free(fileidx);

    stablen = (sptr - sbuf);
    stabrellen = (rptr - rbuf);
    stabrelbuf = rbuf;
    stabbuf = sbuf;
    stabstrbuf = ssbuf;
}

void stabs64_cleanup(void)
{
    struct linelist *ptr, *del;
    if (!stabslines)
        return;
    ptr = stabslines;
    while (ptr) {
        del = ptr;
        ptr = ptr->next;
        nasm_free(del);
    }
    if (stabbuf)
        nasm_free(stabbuf);
    if (stabrelbuf)
        nasm_free(stabrelbuf);
    if (stabstrbuf)
        nasm_free(stabstrbuf);
}

#endif                          /* OF_ELF */
