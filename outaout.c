/* outaout.c	output routines for the Netwide Assembler to produce
 *		Linux a.out object files
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

#if defined OF_AOUT || defined OF_AOUTB

#define RELTYPE_ABSOLUTE 0x00
#define RELTYPE_RELATIVE 0x01
#define RELTYPE_GOTPC    0x01   /* no explicit GOTPC in a.out */
#define RELTYPE_GOTOFF   0x10
#define RELTYPE_GOT      0x10   /* distinct from GOTOFF bcos sym not sect */
#define RELTYPE_PLT      0x21
#define RELTYPE_SYMFLAG  0x08

struct Reloc {
    struct Reloc *next;
    long address;		       /* relative to _start_ of section */
    long symbol;		       /* symbol number or -ve section id */
    int bytes;			       /* 2 or 4 */
    int reltype;		       /* see above */
};

struct Symbol {
    long strpos;		       /* string table position of name */
    int type;			       /* symbol type - see flags below */
    long value;			       /* address, or COMMON variable size */
    long size;			       /* size for data or function exports */
    long segment;		       /* back-reference used by gsym_reloc */
    struct Symbol *next;	       /* list of globals in each section */
    struct Symbol *nextfwd;	       /* list of unresolved-size symbols */
    char *name;			       /* for unresolved-size symbols */
    long symnum;		       /* index into symbol table */
};

/*
 * Section IDs - used in Reloc.symbol when negative, and in
 * Symbol.type when positive.
 */
#define SECT_ABS 2		       /* absolute value */
#define SECT_TEXT 4		       /* text section */
#define SECT_DATA 6		       /* data section */
#define SECT_BSS 8		       /* bss section */
#define SECT_MASK 0xE		       /* mask out any of the above */

/*
 * More flags used in Symbol.type.
 */
#define SYM_GLOBAL 1		       /* it's a global symbol */
#define SYM_DATA 0x100		       /* used for shared libs */
#define SYM_FUNCTION 0x200	       /* used for shared libs */
#define SYM_WITH_SIZE 0x4000	       /* not output; internal only */

/*
 * Bit more explanation of symbol types: SECT_xxx denotes a local
 * symbol. SECT_xxx|SYM_GLOBAL denotes a global symbol, defined in
 * this module. Just SYM_GLOBAL, with zero value, denotes an
 * external symbol referenced in this module. And just SYM_GLOBAL,
 * but with a non-zero value, declares a C `common' variable, of
 * size `value'.
 */

struct Section {
    struct SAA *data;
    unsigned long len, size, nrelocs;
    long index;
    struct Reloc *head, **tail;
    struct Symbol *gsyms, *asym;
};

static struct Section stext, sdata, sbss;

static struct SAA *syms;
static unsigned long nsyms;

static struct RAA *bsym;

static struct SAA *strs;
static unsigned long strslen;

static struct Symbol *fwds;

static FILE *aoutfp;
static efunc error;
static evalfunc evaluate;

static int bsd;
static int is_pic;

static void aout_write(void);
static void aout_write_relocs(struct Reloc *);
static void aout_write_syms(void);
static void aout_sect_write(struct Section *, unsigned char *, unsigned long);
static void aout_pad_sections(void);
static void aout_fixup_relocs(struct Section *);

/*
 * Special section numbers which are used to define special
 * symbols, which can be used with WRT to provide PIC relocation
 * types.
 */
static long aout_gotpc_sect, aout_gotoff_sect;
static long aout_got_sect, aout_plt_sect;
static long aout_sym_sect;

static void aoutg_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    aoutfp = fp;
    error = errfunc;
    evaluate = eval;
    (void) ldef;		       /* placate optimisers */
    stext.data = saa_init(1L); stext.head = NULL; stext.tail = &stext.head;
    sdata.data = saa_init(1L); sdata.head = NULL; sdata.tail = &sdata.head;
    stext.len = stext.size = sdata.len = sdata.size = sbss.len = 0;
    stext.nrelocs = sdata.nrelocs = 0;
    stext.gsyms = sdata.gsyms = sbss.gsyms = NULL;
    stext.index = seg_alloc();
    sdata.index = seg_alloc();
    sbss.index = seg_alloc();
    stext.asym = sdata.asym = sbss.asym = NULL;
    syms = saa_init((long)sizeof(struct Symbol));
    nsyms = 0;
    bsym = raa_init();
    strs = saa_init(1L);
    strslen = 0;
    fwds = NULL;
}

#ifdef OF_AOUT

static void aout_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    bsd = FALSE;
    aoutg_init (fp, errfunc, ldef, eval);

    aout_gotpc_sect = aout_gotoff_sect = aout_got_sect =
	aout_plt_sect = aout_sym_sect = NO_SEG;
}

#endif

#ifdef OF_AOUTB

extern struct ofmt of_aoutb;

static void aoutb_init(FILE *fp, efunc errfunc, ldfunc ldef, evalfunc eval) 
{
    bsd = TRUE;
    aoutg_init (fp, errfunc, ldef, eval);

    is_pic = 0x00;		       /* may become 0x40 */

    aout_gotpc_sect = seg_alloc();
    ldef("..gotpc", aout_gotpc_sect+1, 0L, NULL, FALSE,FALSE,&of_aoutb,error);
    aout_gotoff_sect = seg_alloc();
    ldef("..gotoff", aout_gotoff_sect+1, 0L,NULL,FALSE,FALSE,&of_aoutb,error);
    aout_got_sect = seg_alloc();
    ldef("..got", aout_got_sect+1, 0L, NULL, FALSE,FALSE,&of_aoutb,error);
    aout_plt_sect = seg_alloc();
    ldef("..plt", aout_plt_sect+1, 0L, NULL, FALSE,FALSE,&of_aoutb,error);
    aout_sym_sect = seg_alloc();
    ldef("..sym", aout_sym_sect+1, 0L, NULL, FALSE,FALSE,&of_aoutb,error);
}

#endif

static void aout_cleanup(int debuginfo) 
{
    struct Reloc *r;

    (void) debuginfo;

    aout_pad_sections();
    aout_fixup_relocs(&stext);
    aout_fixup_relocs(&sdata);
    aout_write();
    fclose (aoutfp);
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

static long aout_section_names (char *name, int pass, int *bits) 
{
    /*
     * Default to 32 bits.
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
	return sbss.index;
    else
	return NO_SEG;
}

static void aout_deflabel (char *name, long segment, long offset,
			   int is_global, char *special) 
{
    int pos = strslen+4;
    struct Symbol *sym;
    int special_used = FALSE;

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	/*
	 * This is a NASM special symbol. We never allow it into
	 * the a.out symbol table, even if it's a valid one. If it
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
    sym->segment = segment;
    if (segment == NO_SEG)
	sym->type |= SECT_ABS;
    else if (segment == stext.index) {
	sym->type |= SECT_TEXT;
	if (is_global) {
	    sym->next = stext.gsyms;
	    stext.gsyms = sym;
	} else if (!stext.asym)
	    stext.asym = sym;
    } else if (segment == sdata.index) {
	sym->type |= SECT_DATA;
	if (is_global) {
	    sym->next = sdata.gsyms;
	    sdata.gsyms = sym;
	} else if (!sdata.asym)
	    sdata.asym = sym;
    } else if (segment == sbss.index) {
	sym->type |= SECT_BSS;
	if (is_global) {
	    sym->next = sbss.gsyms;
	    sbss.gsyms = sym;
	} else if (!sbss.asym)
	    sbss.asym = sym;
    } else
	sym->type = SYM_GLOBAL;
    if (is_global == 2)
	sym->value = offset;
    else
	sym->value = (sym->type == SYM_GLOBAL ? 0 : offset);

    if (is_global && sym->type != SYM_GLOBAL) {
	/*
	 * Global symbol exported _from_ this module. We must check
	 * the special text for type information.
	 */

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

		if (!bsd) {
		    error(ERR_NONFATAL, "Linux a.out does not support"
			  " symbol size information");
		} else {
		    while (special[n] && isspace(special[n]))
			n++;
		    /*
		     * We have a size expression; attempt to
		     * evaluate it.
		     */
		    sym->type |= SYM_WITH_SIZE;
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
	    }
	    special_used = TRUE;
	}
    }

    /*
     * define the references from external-symbol segment numbers
     * to these symbol records.
     */
    if (segment != NO_SEG && segment != stext.index &&
	segment != sdata.index && segment != sbss.index)
	bsym = raa_write (bsym, segment, nsyms);
    sym->symnum = nsyms;

    nsyms++;
    if (sym->type & SYM_WITH_SIZE)
	nsyms++;		       /* and another for the size */

    if (special && !special_used)
	error(ERR_NONFATAL, "no special symbol features supported here");
}

static void aout_add_reloc (struct Section *sect, long segment,
			    int reltype, int bytes) 
{
    struct Reloc *r;

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = (segment == NO_SEG ? -SECT_ABS :
		 segment == stext.index ? -SECT_TEXT :
		 segment == sdata.index ? -SECT_DATA :
		 segment == sbss.index ? -SECT_BSS :
		 raa_read(bsym, segment));
    r->reltype = reltype;
    if (r->symbol >= 0)
	r->reltype |= RELTYPE_SYMFLAG;
    r->bytes = bytes;

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
 * RELTYPE_GOT references require the _exact_ symbol address to be
 * used; RELTYPE_ABSOLUTE references can be at an offset from the
 * symbol. The boolean argument `exact' tells us this.
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
static long aout_add_gsym_reloc (struct Section *sect,
				 long segment, long offset,
				 int type, int bytes, int exact) 
{
    struct Symbol *sym, *sm, *shead;
    struct Reloc *r;

    /*
     * First look up the segment to find whether it's text, data,
     * bss or an external symbol.
     */
    shead = NULL;
    if (segment == stext.index)
	shead = stext.gsyms;
    else if (segment == sdata.index)
	shead = sdata.gsyms;
    else if (segment == sbss.index)
	shead = sbss.gsyms;
    if (!shead) {
	if (exact && offset != 0)
	    error (ERR_NONFATAL, "unable to find a suitable global symbol"
		   " for this reference");
	else
	    aout_add_reloc (sect, segment, type, bytes);
	return offset;
    }

    if (exact) {
	/*
	 * Find a symbol pointing _exactly_ at this one.
	 */
	for (sym = shead; sym; sym = sym->next)
	    if (sym->value == offset)
		break;
    } else {
	/*
	 * Find the nearest symbol below this one.
	 */
	sym = NULL;
	for (sm = shead; sm; sm = sm->next)
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
    r->symbol = sym->symnum;
    r->reltype = type | RELTYPE_SYMFLAG;
    r->bytes = bytes;

    sect->nrelocs++;

    return offset - sym->value;
}

/*
 * This routine deals with ..gotoff relocations. These _must_ refer
 * to a symbol, due to a perversity of *BSD's PIC implementation,
 * and it must be a non-global one as well; so we store `asym', the
 * first nonglobal symbol defined in each section, and always work
 * from that. Relocation type is always RELTYPE_GOTOFF.
 *
 * Return value is the adjusted value of `addr', having become an
 * offset from the `asym' symbol rather than the section.
 */
static long aout_add_gotoff_reloc (struct Section *sect, long segment,
				   long offset, int bytes) 
{
    struct Reloc *r;
    struct Symbol *asym;

    /*
     * First look up the segment to find whether it's text, data,
     * bss or an external symbol.
     */
    asym = NULL;
    if (segment == stext.index)
	asym = stext.asym;
    else if (segment == sdata.index)
	asym = sdata.asym;
    else if (segment == sbss.index)
	asym = sbss.asym;
    if (!asym)
	error (ERR_NONFATAL, "`..gotoff' relocations require a non-global"
	       " symbol in the section");

    r = *sect->tail = nasm_malloc(sizeof(struct Reloc));
    sect->tail = &r->next;
    r->next = NULL;

    r->address = sect->len;
    r->symbol = asym->symnum;
    r->reltype = RELTYPE_GOTOFF;
    r->bytes = bytes;

    sect->nrelocs++;

    return offset - asym->value;
}

static void aout_out (long segto, void *data, unsigned long type,
		      long segment, long wrt) 
{
    struct Section *s;
    long realbytes = type & OUT_SIZMASK;
    long addr;
    unsigned char mydata[4], *p;

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
    else if (segto == sbss.index)
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
	sbss.len += realbytes;
	return;
    }

    if (type == OUT_RESERVE) {
	if (s) {
	    error(ERR_WARNING, "uninitialised space declared in"
		  " %s section: zeroing",
		  (segto == stext.index ? "code" : "data"));
	    aout_sect_write (s, NULL, realbytes);
	} else
	    sbss.len += realbytes;
    } else if (type == OUT_RAWDATA) {
	if (segment != NO_SEG)
	    error(ERR_PANIC, "OUT_RAWDATA with other than NO_SEG");
	aout_sect_write (s, data, realbytes);
    } else if (type == OUT_ADDRESS) {
	addr = *(long *)data;
	if (segment != NO_SEG) {
	    if (segment % 2) {
		error(ERR_NONFATAL, "a.out format does not support"
		      " segment base references");
	    } else {
		if (wrt == NO_SEG) {
		    aout_add_reloc (s, segment, RELTYPE_ABSOLUTE, realbytes);
		} else if (!bsd) {
		    error (ERR_NONFATAL, "Linux a.out format does not support"
			   " any use of WRT");
		    wrt = NO_SEG;      /* we can at least _try_ to continue */
		} else if (wrt == aout_gotpc_sect+1) {
		    is_pic = 0x40;
		    aout_add_reloc (s, segment, RELTYPE_GOTPC, realbytes);
		} else if (wrt == aout_gotoff_sect+1) {
		    is_pic = 0x40;
		    addr = aout_add_gotoff_reloc (s, segment,
						  addr, realbytes);
		} else if (wrt == aout_got_sect+1) {
		    is_pic = 0x40;
		    addr = aout_add_gsym_reloc (s, segment, addr, RELTYPE_GOT,
						realbytes, TRUE);
		} else if (wrt == aout_sym_sect+1) {
		    addr = aout_add_gsym_reloc (s, segment, addr,
						RELTYPE_ABSOLUTE, realbytes,
						FALSE);
		} else if (wrt == aout_plt_sect+1) {
		    is_pic = 0x40;
		    error(ERR_NONFATAL, "a.out format cannot produce non-PC-"
			  "relative PLT references");
		} else {
		    error (ERR_NONFATAL, "a.out format does not support this"
			   " use of WRT");
		    wrt = NO_SEG;      /* we can at least _try_ to continue */
		}
	    }
	}
	p = mydata;
	if (realbytes == 2)
	    WRITESHORT (p, addr);
	else
	    WRITELONG (p, addr);
	aout_sect_write (s, mydata, realbytes);
    } else if (type == OUT_REL2ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL2ADR");
	if (segment != NO_SEG && segment % 2) {
	    error(ERR_NONFATAL, "a.out format does not support"
		  " segment base references");
	} else {
	    if (wrt == NO_SEG) {
		aout_add_reloc (s, segment, RELTYPE_RELATIVE, 2);
	    } else if (!bsd) {
		error (ERR_NONFATAL, "Linux a.out format does not support"
		       " any use of WRT");
		wrt = NO_SEG;      /* we can at least _try_ to continue */
	    } else if (wrt == aout_plt_sect+1) {
		is_pic = 0x40;
		aout_add_reloc (s, segment, RELTYPE_PLT, 2);
	    } else if (wrt == aout_gotpc_sect+1 ||
		       wrt == aout_gotoff_sect+1 ||
		       wrt == aout_got_sect+1) {
		error(ERR_NONFATAL, "a.out format cannot produce PC-"
		      "relative GOT references");
	    } else {
		error (ERR_NONFATAL, "a.out format does not support this"
		       " use of WRT");
		wrt = NO_SEG;      /* we can at least _try_ to continue */
	    }
	}
	p = mydata;
	WRITESHORT (p, *(long*)data-(realbytes + s->len));
	aout_sect_write (s, mydata, 2L);
    } else if (type == OUT_REL4ADR) {
	if (segment == segto)
	    error(ERR_PANIC, "intra-segment OUT_REL4ADR");
	if (segment != NO_SEG && segment % 2) {
	    error(ERR_NONFATAL, "a.out format does not support"
		  " segment base references");
	} else {
	    if (wrt == NO_SEG) {
		aout_add_reloc (s, segment, RELTYPE_RELATIVE, 4);
	    } else if (!bsd) {
		error (ERR_NONFATAL, "Linux a.out format does not support"
		       " any use of WRT");
		wrt = NO_SEG;      /* we can at least _try_ to continue */
	    } else if (wrt == aout_plt_sect+1) {
		is_pic = 0x40;
		aout_add_reloc (s, segment, RELTYPE_PLT, 4);
	    } else if (wrt == aout_gotpc_sect+1 ||
		       wrt == aout_gotoff_sect+1 ||
		       wrt == aout_got_sect+1) {
		error(ERR_NONFATAL, "a.out format cannot produce PC-"
		      "relative GOT references");
	    } else {
		error (ERR_NONFATAL, "a.out format does not support this"
		       " use of WRT");
		wrt = NO_SEG;      /* we can at least _try_ to continue */
	    }
	}
	p = mydata;
	WRITELONG (p, *(long*)data-(realbytes + s->len));
	aout_sect_write (s, mydata, 4L);
    }
}

static void aout_pad_sections(void) 
{
    static unsigned char pad[] = { 0x90, 0x90, 0x90, 0x90 };
    /*
     * Pad each of the text and data sections with NOPs until their
     * length is a multiple of four. (NOP == 0x90.) Also increase
     * the length of the BSS section similarly.
     */
    aout_sect_write (&stext, pad, (-(long)stext.len) & 3);
    aout_sect_write (&sdata, pad, (-(long)sdata.len) & 3);
    sbss.len = (sbss.len + 3) & ~3;
}

/*
 * a.out files have the curious property that all references to
 * things in the data or bss sections are done by addresses which
 * are actually relative to the start of the _text_ section, in the
 * _file_. (No relation to what happens after linking. No idea why
 * this should be so. It's very strange.) So we have to go through
 * the relocation table, _after_ the final size of each section is
 * known, and fix up the relocations pointed to.
 */
static void aout_fixup_relocs(struct Section *sect) 
{
    struct Reloc *r;

    saa_rewind (sect->data);
    for (r = sect->head; r; r = r->next) {
	unsigned char *p, *q, blk[4];
	long l;

	saa_fread (sect->data, r->address, blk, (long)r->bytes);
	p = q = blk;
	l = *p++;
	if (r->bytes > 1) {
	    l += ((long)*p++) << 8;
	    if (r->bytes == 4) {
		l += ((long)*p++) << 16;
		l += ((long)*p++) << 24;
	    }
	}
	if (r->symbol == -SECT_DATA)
	    l += stext.len;
	else if (r->symbol == -SECT_BSS)
	    l += stext.len + sdata.len;
	if (r->bytes == 4)
	    WRITELONG(q, l);
	else if (r->bytes == 2)
	    WRITESHORT(q, l);
	else
	    *q++ = l & 0xFF;
	saa_fwrite (sect->data, r->address, blk, (long)r->bytes);
    }
}

static void aout_write(void) 
{
    /*
     * Emit the a.out header.
     */
    /* OMAGIC, M_386 or MID_I386, no flags */
    fwritelong (bsd ? 0x07018600 | is_pic : 0x640107L, aoutfp);
    fwritelong (stext.len, aoutfp);
    fwritelong (sdata.len, aoutfp);
    fwritelong (sbss.len, aoutfp);
    fwritelong (nsyms * 12, aoutfp);   /* length of symbol table */
    fwritelong (0L, aoutfp);	       /* object files have no entry point */
    fwritelong (stext.nrelocs * 8, aoutfp);   /* size of text relocs */
    fwritelong (sdata.nrelocs * 8, aoutfp);   /* size of data relocs */

    /*
     * Write out the code section and the data section.
     */
    saa_fpwrite (stext.data, aoutfp);
    saa_fpwrite (sdata.data, aoutfp);

    /*
     * Write out the relocations.
     */
    aout_write_relocs (stext.head);
    aout_write_relocs (sdata.head);

    /*
     * Write the symbol table.
     */
    aout_write_syms ();

    /*
     * And the string table.
     */
    fwritelong (strslen+4, aoutfp);    /* length includes length count */
    saa_fpwrite (strs, aoutfp);
}

static void aout_write_relocs (struct Reloc *r) 
{
    while (r) {
	unsigned long word2;

	fwritelong (r->address, aoutfp);

	if (r->symbol >= 0)
	    word2 = r->symbol;
	else
	    word2 = -r->symbol;
	word2 |= r->reltype << 24;
	word2 |= (r->bytes == 1 ? 0 :
		  r->bytes == 2 ? 0x2000000L : 0x4000000L);
	fwritelong (word2, aoutfp);

	r = r->next;
    }
}

static void aout_write_syms (void) 
{
    int i;

    saa_rewind (syms);
    for (i=0; i<nsyms; i++) {
	struct Symbol *sym = saa_rstruct(syms);
	fwritelong (sym->strpos, aoutfp);
	fwritelong ((long)sym->type & ~SYM_WITH_SIZE, aoutfp);
	/*
	 * Fix up the symbol value now we know the final section
	 * sizes.
	 */
	if ((sym->type & SECT_MASK) == SECT_DATA)
	    sym->value += stext.len;
	if ((sym->type & SECT_MASK) == SECT_BSS)
	    sym->value += stext.len + sdata.len;
	fwritelong (sym->value, aoutfp);
	/*
	 * Output a size record if necessary.
	 */
	if (sym->type & SYM_WITH_SIZE) {
	    fwritelong(sym->strpos, aoutfp);
	    fwritelong(0x0DL, aoutfp);  /* special value: means size */
	    fwritelong(sym->size, aoutfp);
	    i++;		       /* use up another of `nsyms' */
	}
    }
}

static void aout_sect_write (struct Section *sect,
			     unsigned char *data, unsigned long len) 
{
    saa_wbytes (sect->data, data, len);
    sect->len += len;
}

static long aout_segbase (long segment) 
{
    return segment;
}

static int aout_directive (char *directive, char *value, int pass) 
{
    return 0;
}

static void aout_filename (char *inname, char *outname, efunc error) 
{
    standard_extension (inname, outname, ".o", error);
}

static char *aout_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static int aout_set_info(enum geninfo type, char **val)
{
    return 0;
}
#endif /* OF_AOUT || OF_AOUTB */

#ifdef OF_AOUT

struct ofmt of_aout = {
    "Linux a.out object files",
    "aout",
    NULL,
    null_debug_arr,
    &null_debug_form,
    aout_stdmac,
    aout_init,
    aout_set_info,
    aout_out,
    aout_deflabel,
    aout_section_names,
    aout_segbase,
    aout_directive,
    aout_filename,
    aout_cleanup
};

#endif

#ifdef OF_AOUTB

struct ofmt of_aoutb = {
    "NetBSD/FreeBSD a.out object files",
    "aoutb",
    NULL,
    null_debug_arr,
    &null_debug_form,
    aout_stdmac,
    aoutb_init,
    aout_set_info,
    aout_out,
    aout_deflabel,
    aout_section_names,
    aout_segbase,
    aout_directive,
    aout_filename,
    aout_cleanup
};

#endif
