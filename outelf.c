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

struct Reloc {
    struct Reloc *next;
    long address;		       /* relative to _start_ of section */
    long symbol;		       /* ELF symbol info thingy */
    int relative;		       /* TRUE or FALSE */
};

struct Symbol {
    long strpos;		       /* string table position of name */
    long section;		       /* section ID of the symbol */
    int type;			       /* TRUE or FALSE */
    long value;			       /* address, or COMMON variable size */
};

struct Section {
    struct SAA *data;
    unsigned long len, size, nrelocs;
    long index;
    struct Reloc *head, **tail;
};

static struct Section stext, sdata;
static unsigned long bsslen;
static long bssindex;

static struct SAA *syms;
static unsigned long nlocals, nglobs;

static struct RAA *bsym;

static struct SAA *strs;
static unsigned long strslen;

static FILE *elffp;
static efunc error;

static char elf_module[FILENAME_MAX];

#define SHN_ABS 0xFFF1
#define SHN_COMMON 0xFFF2
#define SHN_UNDEF 0

#define SYM_SECTION 0x04
#define SYM_GLOBAL 0x10

#define GLOBAL_TEMP_BASE 6	       /* bigger than any constant sym id */

#define SEG_ALIGN 16		       /* alignment of sections in file */
#define SEG_ALIGN_1 (SEG_ALIGN-1)

static const char align_str[SEG_ALIGN] = ""; /* ANSI will pad this with 0s */

#define ELF_MAX_SECTIONS 16	       /* really 10, but let's play safe */
static struct ELF_SECTDATA {
    void *data;
    long len;
    int is_saa;
} elf_sects[ELF_MAX_SECTIONS];
static int elf_nsect;
static long elf_foffs;

static void elf_write(void);
static void elf_sect_write(struct Section *, unsigned char *, unsigned long);
static void elf_section_header (int, int, int, void *, int, long,
				int, int, int, int);
static void elf_write_sections (void);
static struct SAA *elf_build_symtab (long *, long *);
static struct SAA *elf_build_reltab (long *, struct Reloc *);

static void elf_init(FILE *fp, efunc errfunc, ldfunc ldef) {
    elffp = fp;
    error = errfunc;
    (void) ldef;		       /* placate optimisers */
    stext.data = saa_init(1L); stext.head = NULL; stext.tail = &stext.head;
    sdata.data = saa_init(1L); sdata.head = NULL; sdata.tail = &sdata.head;
    stext.len = stext.size = sdata.len = sdata.size = bsslen = 0;
    stext.nrelocs = sdata.nrelocs = 0;
    stext.index = seg_alloc();
    sdata.index = seg_alloc();
    bssindex = seg_alloc();
    syms = saa_init((long)sizeof(struct Symbol));
    nlocals = nglobs = 0;
    bsym = raa_init();

    strs = saa_init(1L);
    saa_wbytes (strs, "\0", 1L);
    saa_wbytes (strs, elf_module, (long)(strlen(elf_module)+1));
    strslen = 2+strlen(elf_module);
}

static void elf_cleanup(void) {
    struct Reloc *r;

    elf_write();
    fclose (elffp);
    saa_free (stext.data);
    while (stext.head) {
	r = stext.head;
	stext.head = stext.head->next;
	nasm_free (r);
    }
    saa_free (sdata.data);
    while (sdata.head) {
	r = sdata.head;
	sdata.head = sdata.head->next;
	nasm_free (r);
    }
    saa_free (syms);
    raa_free (bsym);
    saa_free (strs);
}

static long elf_section_names (char *name, int pass, int *bits) {
    /*
     * Default is 32 bits.
     */
    if (!name)
	*bits = 32;

    if (!name)
	return stext.index;

    if (!strcmp(name, ".text"))
	return stext.index;
    else if (!strcmp(name, ".data"))
	return sdata.index;
    else if (!strcmp(name, ".bss"))
	return bssindex;
    else
	return NO_SEG;
}

static void elf_deflabel (char *name, long segment, long offset,
			   int is_global) {
    int pos = strslen;
    struct Symbol *sym;

    if (name[0] == '.' && name[1] == '.') {
	return;
    }

    saa_wbytes (strs, name, (long)(1+strlen(name)));
    strslen += 1+strlen(name);

    sym = saa_wstruct (syms);

    sym->strpos = pos;
    sym->type = is_global ? SYM_GLOBAL : 0;
    if (segment == NO_SEG)
	sym->section = SHN_ABS;
    else if (segment == stext.index)
	sym->section = 1;
    else if (segment == sdata.index)
	sym->section = 2;
    else if (segment == bssindex)
	sym->section = 3;
    else
	sym->section = SHN_UNDEF;

    if (is_global == 2) {
	sym->value = offset;
	sym->section = SHN_COMMON;
    } else
	sym->value = (sym->section == SHN_UNDEF ? 0 : offset);

    if (sym->type == SYM_GLOBAL) {
	if (sym->section == SHN_UNDEF || sym->section == SHN_COMMON)
	    bsym = raa_write (bsym, segment, nglobs);
	nglobs++;
    } else
	nlocals++;
}

static void elf_add_reloc (struct Section *sect, long segment,
			    int relative) {
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = (segment == NO_SEG ? 5 :
		 segment == stext.index ? 2 :
		 segment == sdata.index ? 3 :
		 segment == bssindex ? 4 :
		 GLOBAL_TEMP_BASE + raa_read(bsym, segment));
    r->relative = relative;

    sect->nrelocs++;
}

static void elf_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) {
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    unsigned char mydata[4], *p;

    if (wrt != NO_SEG) {
	wrt = NO_SEG;		       /* continue to do _something_ */
	error (ERR_NONFATAL, "WRT not supported by ELF output format");
    }

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

    if (segto == stext.index)
	s = &stext;
    else if (segto == sdata.index)
	s = &sdata;
    else if (segto == bssindex)
	s = NULL;
    else {
	error(ERR_WARNING, "attempt to assemble code in"
	      " segment %d: defaulting to `.text'", segto);
	s = &stext;
    }

    if (!s && type != OUT_RESERVE) {
	error(ERR_WARNING, "attempt to initialise memory in the"
	      " BSS section: ignored");
	if (type == OUT_REL2ADR)
	    realbytes = 2;
	else if (type == OUT_REL4ADR)
	    realbytes = 4;
	bsslen += realbytes;
	return;
    }

    if (type == OUT_RESERVE) {
	if (s) {
	    error(ERR_WARNING, "uninitialised space declared in"
		  " %s section: zeroing",
		  (segto == stext.index ? "code" : "data"));
	    elf_sect_write (s, NULL, realbytes);
	} else
	    bsslen += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	elf_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	if (wrt != NO_SEG)
	    error(ERR_NONFATAL, "ELF format does not support WRT types");
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "ELF format does not support"
		      " segment base references");
	    } else
		elf_add_reloc (s, segment, FALSE);
	}
	p = mydata;
	if (realbytes == 2 && segment != NO_SEG)
	    error (ERR_NONFATAL, "ELF format does not support 16-bit"
		   " relocations");
	WRITELONG (p, *(long *)data);
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
	} else
	    elf_add_reloc (s, segment, TRUE);
	p = mydata;
	WRITELONG (p, *(long*)data - realbytes);
	elf_sect_write (s, mydata, 4L);
    }
}

static void elf_write(void) {
    int nsections, align;
    char shstrtab[80], *p;
    int shstrtablen, commlen;
    char comment[64];

    struct SAA *symtab, *reltext, *reldata;
    long symtablen, symtablocal, reltextlen, reldatalen;

    /*
     * Work out how many sections we will have.
     *
     * Fixed sections are:
     *    SHN_UNDEF .text .data .bss .comment .shstrtab .symtab .strtab
     *
     * Optional sections are:
     *    .rel.text .rel.data
     *
     * (.rel.bss makes very little sense;-)
     */
    nsections = 8;
    *shstrtab = '\0';
    shstrtablen = 1;
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".text");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".data");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".bss");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".comment");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".shstrtab");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".symtab");
    shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".strtab");
    if (stext.head) {
	nsections++;
	shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".rel.text");
    }
    if (sdata.head) {
	nsections++;
	shstrtablen += 1+sprintf(shstrtab+shstrtablen, ".rel.data");
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
    fwriteshort (nsections, elffp);     /* number of sections */
    fwriteshort (5, elffp);	       /* string table section index for
					* section header table */
    fwritelong (0L, elffp);	       /* align to 0x40 bytes */
    fwritelong (0L, elffp);
    fwritelong (0L, elffp);

    /*
     * Build the symbol table and relocation tables.
     */
    symtab = elf_build_symtab (&symtablen, &symtablocal);
    reltext = elf_build_reltab (&reltextlen, stext.head);
    reldata = elf_build_reltab (&reldatalen, sdata.head);

    /*
     * Now output the section header table.
     */

    elf_foffs = 0x40 + 0x28 * nsections;
    align = ((elf_foffs+SEG_ALIGN_1) & ~SEG_ALIGN_1) - elf_foffs;
    elf_foffs += align;
    elf_nsect = 0;

    elf_section_header (0, 0, 0, NULL, FALSE, 0L, 0, 0, 0, 0); /* SHN_UNDEF */
    p = shstrtab+1;
    elf_section_header (p - shstrtab, 1, 6, stext.data, TRUE,
			stext.len, 0, 0, 16, 0);   /* .text */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 1, 3, sdata.data, TRUE,
			sdata.len, 0, 0, 4, 0);   /* .data */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 8, 3, NULL, TRUE,
			bsslen, 0, 0, 4, 0);   /* .bss */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 1, 0, comment, FALSE,
			(long)commlen, 0, 0, 1, 0);/* .comment */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 3, 0, shstrtab, FALSE,
			(long)shstrtablen, 0, 0, 1, 0);/* .shstrtab */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 2, 0, symtab, TRUE,
			symtablen, 7, symtablocal, 4, 16);/* .symtab */
    p += strlen(p)+1;
    elf_section_header (p - shstrtab, 3, 0, strs, TRUE,
			strslen, 0, 0, 1, 0);	    /* .strtab */
    if (reltext) {
	p += strlen(p)+1;
	elf_section_header (p - shstrtab, 9, 0, reltext, TRUE,
			    reltextlen, 6, 1, 4, 8);    /* .rel.text */
    }
    if (reldata) {
	p += strlen(p)+1;
	elf_section_header (p - shstrtab, 9, 0, reldata, TRUE,
			    reldatalen, 6, 2, 4, 8);    /* .rel.data */
    }

    fwrite (align_str, align, 1, elffp);

    /*
     * Now output the sections.
     */
    elf_write_sections();

    saa_free (symtab);
    if (reltext)
	saa_free (reltext);
    if (reldata)
	saa_free (reldata);
}

static struct SAA *elf_build_symtab (long *len, long *local) {
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
     * Now four standard symbols defining segments, for relocation
     * purposes.
     */
    for (i = 1; i <= 4; i++) {
	p = entry;
	WRITELONG (p, 0);	       /* no symbol name */
	WRITELONG (p, 0);	       /* offset zero */
	WRITELONG (p, 0);	       /* size zero */
	WRITESHORT (p, 3);	       /* local section-type thing */
	WRITESHORT (p, (i==4 ? SHN_ABS : i));   /* the section id */
	saa_wbytes (s, entry, 16L);
	*len += 16;
	(*local)++;
    }

    /*
     * Now the other local symbols.
     */
    saa_rewind (syms);
    while ( (sym = saa_rstruct (syms)) ) {
	if (sym->type == SYM_GLOBAL)
	    continue;
	p = entry;
	WRITELONG (p, sym->strpos);
	WRITELONG (p, sym->value);
	if (sym->section == SHN_COMMON)
	    WRITELONG (p, sym->value);
	else
	    WRITELONG (p, 0);
	WRITESHORT (p, 0);	       /* local non-typed thing */
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
	if (sym->type != SYM_GLOBAL)
	    continue;
	p = entry;
	WRITELONG (p, sym->strpos);
	WRITELONG (p, sym->value);
	if (sym->section == SHN_COMMON)
	    WRITELONG (p, sym->value);
	else
	    WRITELONG (p, 0);
	WRITESHORT (p, SYM_GLOBAL);    /* global non-typed thing */
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
	    sym += -GLOBAL_TEMP_BASE + 6 + nlocals;

	p = entry;
	WRITELONG (p, r->address);
	WRITELONG (p, (sym << 8) + (r->relative ? 2 : 1));
	saa_wbytes (s, entry, 8L);
	*len += 8;

	r = r->next;
    }

    return s;
}

static void elf_section_header (int name, int type, int flags,
				void *data, int is_saa, long datalen,
				int link, int info, int align, int eltsize) {
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

static void elf_write_sections (void) {
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
			     unsigned char *data, unsigned long len) {
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static long elf_segbase (long segment) {
    return segment;
}

static int elf_directive (char *directive, char *value, int pass) {
    return 0;
}

static void elf_filename (char *inname, char *outname, efunc error) {
    strcpy(elf_module, inname);
    standard_extension (inname, outname, ".o", error);
}

struct ofmt of_elf = {
    "ELF32 (i386) object files (e.g. Linux)",
    "elf",
    elf_init,
    elf_out,
    elf_deflabel,
    elf_section_names,
    elf_segbase,
    elf_directive,
    elf_filename,
    elf_cleanup
};

#endif /* OF_ELF */
