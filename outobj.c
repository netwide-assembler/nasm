/* outobj.c	output routines for the Netwide Assembler to produce
 *		Microsoft 16-bit .OBJ object files
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

#ifdef OF_OBJ

static char obj_infile[FILENAME_MAX];
static int obj_uppercase;

static efunc error;
static ldfunc deflabel;
static FILE *ofp;
static long first_seg;
static int any_segs;

#define LEDATA_MAX 1024		       /* maximum size of LEDATA record */
#define RECORD_MAX 1024		       /* maximum size of _any_ record */
#define GROUP_MAX 256		       /* we won't _realistically_ have more
					* than this many segs in a group */
#define EXT_BLKSIZ 256		       /* block size for externals list */

static unsigned char record[RECORD_MAX], *recptr;

static struct Public {
    struct Public *next;
    char *name;
    long offset;
    long segment;		       /* only if it's far-absolute */
} *fpubhead, **fpubtail;

static struct External {
    struct External *next;
    char *name;
    long commonsize;
} *exthead, **exttail;

static int externals;

static struct ExtBack {
    struct ExtBack *next;
    int index[EXT_BLKSIZ];
} *ebhead, **ebtail;

static struct Segment {
    struct Segment *next;
    long index;			       /* the NASM segment id */
    long obj_index;		       /* the OBJ-file segment index */
    struct Group *grp;		       /* the group it belongs to */
    long currentpos;
    long align;			       /* can be SEG_ABS + absolute addr */
    enum {
	CMB_PRIVATE = 0,
	CMB_PUBLIC = 2,
	CMB_STACK = 5,
	CMB_COMMON = 6
    } combine;
    long use32;			       /* is this segment 32-bit? */
    struct Public *pubhead, **pubtail;
    char *name;
    char *segclass, *overlay;	       /* `class' is a C++ keyword :-) */
} *seghead, **segtail, *obj_seg_needs_update;

static struct Group {
    struct Group *next;
    char *name;
    long index;			       /* NASM segment id */
    long obj_index;		       /* OBJ-file group index */
    long nentries;		       /* number of elements... */
    long nindices;		       /* ...and number of index elts... */
    union {
	long index;
	char *name;
    } segs[GROUP_MAX];		       /* ...in this */
} *grphead, **grptail, *obj_grp_needs_update, *defgrp;

static struct ObjData {
    struct ObjData *next;
    int nonempty;
    struct Segment *seg;
    long startpos;
    int letype, ftype;
    unsigned char ledata[LEDATA_MAX], *lptr;
    unsigned char fixupp[RECORD_MAX], *fptr;
} *datahead, *datacurr, **datatail;

static long obj_entry_seg, obj_entry_ofs;

static int os2;

enum RecordID {			       /* record ID codes */

    THEADR = 0x80,		       /* module header */
    COMENT = 0x88,		       /* comment record */

    LNAMES = 0x96,		       /* list of names */

    SEGDEF = 0x98,		       /* segment definition */
    GRPDEF = 0x9A,		       /* group definition */
    EXTDEF = 0x8C,		       /* external definition */
    PUBDEF = 0x90,		       /* public definition */
    COMDEF = 0xB0,		       /* common definition */

    LEDATA = 0xA0,		       /* logical enumerated data */
    FIXUPP = 0x9C,		       /* fixups (relocations) */

    MODEND = 0x8A		       /* module end */
};

extern struct ofmt of_obj;

static long obj_ledata_space(struct Segment *);
static int obj_fixup_free(struct Segment *);
static void obj_ledata_new(struct Segment *);
static void obj_ledata_commit(void);
static void obj_write_fixup (struct ObjData *, int, int, long, long, long);
static long obj_segment (char *, int, int *);
static void obj_write_file(void);
static unsigned char *obj_write_data(unsigned char *, unsigned char *, int);
static unsigned char *obj_write_byte(unsigned char *, int);
static unsigned char *obj_write_word(unsigned char *, int);
static unsigned char *obj_write_dword(unsigned char *, long);
static unsigned char *obj_write_rword(unsigned char *, int);
static unsigned char *obj_write_name(unsigned char *, char *);
static unsigned char *obj_write_index(unsigned char *, int);
static unsigned char *obj_write_value(unsigned char *, unsigned long);
static void obj_record(int, unsigned char *, unsigned char *);
static int obj_directive (char *, char *, int);

static void obj_init (FILE *fp, efunc errfunc, ldfunc ldef) {
    ofp = fp;
    error = errfunc;
    deflabel = ldef;
    first_seg = seg_alloc();
    any_segs = FALSE;
    fpubhead = NULL;
    fpubtail = &fpubhead;
    exthead = NULL;
    exttail = &exthead;
    externals = 0;
    ebhead = NULL;
    ebtail = &ebhead;
    seghead = obj_seg_needs_update = NULL;
    segtail = &seghead;
    grphead = obj_grp_needs_update = NULL;
    grptail = &grphead;
    datahead = datacurr = NULL;
    datatail = &datahead;
    obj_entry_seg = NO_SEG;
    obj_uppercase = FALSE;

    if (os2) {
	obj_directive ("group", "FLAT", 1);
	defgrp = grphead;
    } else
	defgrp = NULL;
}

static void dos_init (FILE *fp, efunc errfunc, ldfunc ldef) {
    os2 = FALSE;
    obj_init (fp, errfunc, ldef);
}

static void os2_init (FILE *fp, efunc errfunc, ldfunc ldef) {
    os2 = TRUE;
    obj_init (fp, errfunc, ldef);
}

static void obj_cleanup (void) {
    obj_write_file();
    fclose (ofp);
    while (seghead) {
	struct Segment *segtmp = seghead;
	seghead = seghead->next;
	while (segtmp->pubhead) {
	    struct Public *pubtmp = segtmp->pubhead;
	    segtmp->pubhead = pubtmp->next;
	    nasm_free (pubtmp);
	}
	nasm_free (segtmp);
    }
    while (fpubhead) {
	struct Public *pubtmp = fpubhead;
	fpubhead = fpubhead->next;
	nasm_free (pubtmp);
    }
    while (exthead) {
	struct External *exttmp = exthead;
	exthead = exthead->next;
	nasm_free (exttmp);
    }
    while (ebhead) {
	struct ExtBack *ebtmp = ebhead;
	ebhead = ebhead->next;
	nasm_free (ebtmp);
    }
    while (grphead) {
	struct Group *grptmp = grphead;
	grphead = grphead->next;
	nasm_free (grptmp);
    }
    while (datahead) {
	struct ObjData *datatmp = datahead;
	datahead = datahead->next;
	nasm_free (datatmp);
    }
}

static void obj_deflabel (char *name, long segment,
			  long offset, int is_global) {
    /*
     * We have three cases:
     *
     * (i) `segment' is a segment-base. If so, set the name field
     * for the segment or group structure it refers to, and then
     * return.
     *
     * (ii) `segment' is one of our segments, or a SEG_ABS segment.
     * Save the label position for later output of a PUBDEF record.
     * (Or a MODPUB, if we work out how.)
     *
     * (iii) `segment' is not one of our segments. Save the label
     * position for later output of an EXTDEF, and also store a
     * back-reference so that we can map later references to this
     * segment number to the external index.
     */
    struct External *ext;
    struct ExtBack *eb;
    struct Segment *seg;
    int i;

    /*
     * First check for the double-period, signifying something
     * unusual.
     */
    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
	if (!strcmp(name, "..start")) {
	    obj_entry_seg = segment;
	    obj_entry_ofs = offset;
	    return;
	}
	error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
    }

    /*
     * Case (i):
     */
    if (obj_seg_needs_update) {
	obj_seg_needs_update->name = name;
	return;
    } else if (obj_grp_needs_update) {
	obj_grp_needs_update->name = name;
	return;
    }
    if (segment < SEG_ABS && segment != NO_SEG && segment % 2)
	return;

    if (segment >= SEG_ABS || segment == NO_SEG) {
	/*
	 * SEG_ABS subcase of (ii).
	 */
	if (is_global) {
	    struct Public *pub;

	    pub = *fpubtail = nasm_malloc(sizeof(*pub));
	    fpubtail = &pub->next;
	    pub->next = NULL;
	    pub->name = name;
	    pub->offset = offset;
	    pub->segment = (segment == NO_SEG ? 0 : segment & ~SEG_ABS);
	}
	return;
    }

    /*
     * If `any_segs' is still FALSE, we might need to define a
     * default segment, if they're trying to declare a label in
     * `first_seg'.
     */
    if (!any_segs && segment == first_seg) {
	int tempint;		       /* ignored */
	if (segment != obj_segment("__NASMDEFSEG", 2, &tempint))
	    error (ERR_PANIC, "strange segment conditions in OBJ driver");
    }

    for (seg = seghead; seg; seg = seg->next)
	if (seg->index == segment) {
	    /*
	     * Case (ii). Maybe MODPUB someday?
	     */
	    if (is_global) {
		struct Public *pub;
		pub = *seg->pubtail = nasm_malloc(sizeof(*pub));
		seg->pubtail = &pub->next;
		pub->next = NULL;
		pub->name = name;
		pub->offset = offset;
	    }
	    return;
	}

    /*
     * Case (iii).
     */
    ext = *exttail = nasm_malloc(sizeof(*ext));
    ext->next = NULL;
    exttail = &ext->next;
    ext->name = name;
    if (is_global == 2)
	ext->commonsize = offset;
    else
	ext->commonsize = 0;

    i = segment/2;
    eb = ebhead;
    if (!eb) {
	eb = *ebtail = nasm_malloc(sizeof(*eb));
	eb->next = NULL;
	ebtail = &eb->next;
    }
    while (i > EXT_BLKSIZ) {
	if (eb && eb->next)
	    eb = eb->next;
	else {
	    eb = *ebtail = nasm_malloc(sizeof(*eb));
	    eb->next = NULL;
	    ebtail = &eb->next;
	}
	i -= EXT_BLKSIZ;
    }
    eb->index[i] = ++externals;
}

static void obj_out (long segto, void *data, unsigned long type,
		     long segment, long wrt) {
    long size, realtype;
    unsigned char *ucdata;
    long ldata;
    struct Segment *seg;

    /*
     * handle absolute-assembly (structure definitions)
     */
    if (segto == NO_SEG) {
	if ((type & OUT_TYPMASK) != OUT_RESERVE)
	    error (ERR_NONFATAL, "attempt to assemble code in [ABSOLUTE]"
		   " space");
	return;
    }

    /*
     * If `any_segs' is still FALSE, we must define a default
     * segment.
     */
    if (!any_segs) {
	int tempint;		       /* ignored */
	if (segto != obj_segment("__NASMDEFSEG", 2, &tempint))
	    error (ERR_PANIC, "strange segment conditions in OBJ driver");
    }

    /*
     * Find the segment we are targetting.
     */
    for (seg = seghead; seg; seg = seg->next)
	if (seg->index == segto)
	    break;
    if (!seg)
	error (ERR_PANIC, "code directed to nonexistent segment?");

    size = type & OUT_SIZMASK;
    realtype = type & OUT_TYPMASK;
    if (realtype == OUT_RAWDATA) {
	ucdata = data;
	while (size > 0) {
	    long len = obj_ledata_space(seg);
	    if (len == 0) {
		obj_ledata_new(seg);
		len = obj_ledata_space(seg);
	    }
	    if (len > size)
		len = size;
	    datacurr->lptr = obj_write_data (datacurr->lptr, ucdata, len);
	    datacurr->nonempty = TRUE;
	    ucdata += len;
	    size -= len;
	    seg->currentpos += len;
	}
    } else if (realtype == OUT_ADDRESS || realtype == OUT_REL2ADR ||
	       realtype == OUT_REL4ADR) {
	if (segment == NO_SEG && realtype != OUT_ADDRESS)
	    error(ERR_NONFATAL, "relative call to absolute address not"
		  " supported by OBJ format");
	if (segment >= SEG_ABS)
	    error(ERR_NONFATAL, "far-absolute relocations not supported"
		  " by OBJ format");
	ldata = *(long *)data;
	if (realtype == OUT_REL2ADR)
	    ldata += (size-2);
	if (realtype == OUT_REL4ADR)
	    ldata += (size-4);
	if (obj_ledata_space(seg) < 4 || !obj_fixup_free(seg))
	    obj_ledata_new(seg);
	if (size == 2)
	    datacurr->lptr = obj_write_word (datacurr->lptr, ldata);
	else
	    datacurr->lptr = obj_write_dword (datacurr->lptr, ldata);
	datacurr->nonempty = TRUE;
	if (segment != NO_SEG)
	    obj_write_fixup (datacurr, size,
			     (realtype == OUT_REL2ADR ||
			      realtype == OUT_REL4ADR ? 0 : 0x4000),
			     segment, wrt,
			     (seg->currentpos - datacurr->startpos));
	seg->currentpos += size;
    } else if (realtype == OUT_RESERVE) {
	obj_ledata_commit();
	seg->currentpos += size;
    }
}

static long obj_ledata_space(struct Segment *segto) {
    if (datacurr && datacurr->seg == segto)
	return datacurr->ledata + LEDATA_MAX - datacurr->lptr;
    else
	return 0;
}

static int obj_fixup_free(struct Segment *segto) {
    if (datacurr && datacurr->seg == segto)
	return (datacurr->fixupp + RECORD_MAX - datacurr->fptr) > 8;
    else
	return 0;
}

static void obj_ledata_new(struct Segment *segto) {
    datacurr = *datatail = nasm_malloc(sizeof(*datacurr));
    datacurr->next = NULL;
    datatail = &datacurr->next;
    datacurr->nonempty = FALSE;
    datacurr->lptr = datacurr->ledata;
    datacurr->fptr = datacurr->fixupp;
    datacurr->seg = segto;
    if (segto->use32)
	datacurr->letype = LEDATA+1;
    else
	datacurr->letype = LEDATA;
    datacurr->startpos = segto->currentpos;
    datacurr->ftype = FIXUPP;

    datacurr->lptr = obj_write_index (datacurr->lptr, segto->obj_index);
    if (datacurr->letype == LEDATA)
	datacurr->lptr = obj_write_word (datacurr->lptr, segto->currentpos);
    else
	datacurr->lptr = obj_write_dword (datacurr->lptr, segto->currentpos);
}

static void obj_ledata_commit(void) {
    datacurr = NULL;
}

static void obj_write_fixup (struct ObjData *data, int bytes,
			     int segrel, long seg, long wrt,
			     long offset) {
    int locat, method;
    int base;
    long tidx, fidx;
    struct Segment *s = NULL;
    struct Group *g = NULL;

    locat = 0x8000 | segrel | offset;
    if (seg % 2) {
	base = TRUE;
	locat |= 0x800;
	seg--;
	if (bytes != 2)
	    error(ERR_NONFATAL, "OBJ format can only handle 2-byte"
		  " segment base references");
    } else {
	base = FALSE;
	if (bytes == 2)
	    locat |= 0x400;
	else {
	    locat |= 0x2400;
	    data->ftype = FIXUPP+1;    /* need new-style FIXUPP record */
	}
    }
    data->fptr = obj_write_rword (data->fptr, locat);

    tidx = fidx = -1, method = 0;      /* placate optimisers */

    /*
     * See if we can find the segment ID in our segment list. If
     * so, we have a T4 (LSEG) target.
     */
    for (s = seghead; s; s = s->next)
	if (s->index == seg)
	    break;
    if (s)
	method = 4, tidx = s->obj_index;
    else {
	for (g = grphead; g; g = g->next)
	    if (g->index == seg)
		break;
	if (g)
	    method = 5, tidx = g->obj_index;
	else {
	    long i = seg/2;
	    struct ExtBack *eb = ebhead;
	    while (i > EXT_BLKSIZ) {
		if (eb)
		    eb = eb->next;
		else
		    break;
		i -= EXT_BLKSIZ;
	    }
	    if (eb)
		method = 6, tidx = eb->index[i];
	    else
		error(ERR_PANIC,
		      "unrecognised segment value in obj_write_fixup");
	}
    }

    /*
     * If no WRT given, assume the natural default, which is method
     * F5 unless we are doing an OFFSET fixup for a grouped
     * segment, in which case we require F1 (group). Oh, and in
     * OS/2 mode we're in F1 (group) on `defgrp' _always_, by
     * default.
     */
    if (wrt == NO_SEG) {
	if (os2)
	    method |= 0x10, fidx = defgrp->obj_index;
	else if (!base && s && s->grp)
	    method |= 0x10, fidx = s->grp->obj_index;
	else
	    method |= 0x50, fidx = -1;
    } else {
	/*
	 * See if we can find the WRT-segment ID in our segment
	 * list. If so, we have a F0 (LSEG) frame.
	 */
	for (s = seghead; s; s = s->next)
	    if (s->index == wrt-1)
		break;
	if (s)
	    method |= 0x00, fidx = s->obj_index;
	else {
	    for (g = grphead; g; g = g->next)
		if (g->index == wrt-1)
		    break;
	    if (g)
		method |= 0x10, fidx = g->obj_index;
	    else {
		long i = wrt/2;
		struct ExtBack *eb = ebhead;
		while (i > EXT_BLKSIZ) {
		    if (eb)
			eb = eb->next;
		    else
			break;
		    i -= EXT_BLKSIZ;
		}
		if (eb)
		    method |= 0x20, fidx = eb->index[i];
		else
		    error(ERR_PANIC,
			  "unrecognised WRT value in obj_write_fixup");
	    }
	}
    }

    data->fptr = obj_write_byte (data->fptr, method);
    if (fidx != -1)
	data->fptr = obj_write_index (data->fptr, fidx);
    data->fptr = obj_write_index (data->fptr, tidx);
}

static long obj_segment (char *name, int pass, int *bits) {
    /*
     * We call the label manager here to define a name for the new
     * segment, and when our _own_ label-definition stub gets
     * called in return, it should register the new segment name
     * using the pointer it gets passed. That way we save memory,
     * by sponging off the label manager.
     */
    if (!name) {
	*bits = 16;
	return first_seg;
    } else {
	struct Segment *seg;
	struct Group *grp;
	int obj_idx, i, attrs, rn_error;
	char *p;

	/*
	 * Look for segment attributes.
	 */
	attrs = 0;
	while (*name == '.')
	    name++;		       /* hack, but a documented one */
	p = name;
	while (*p && !isspace(*p))
	    p++;
	if (*p) {
	    *p++ = '\0';
	    while (*p && isspace(*p))
		*p++ = '\0';
	}
	while (*p) {
	    while (*p && !isspace(*p))
		p++;
	    if (*p) {
		*p++ = '\0';
		while (*p && isspace(*p))
		    *p++ = '\0';
	    }

	    attrs++;
	}

	obj_idx = 1;
	for (seg = seghead; seg; seg = seg->next) {
	    obj_idx++;
	    if (!strcmp(seg->name, name)) {
		if (attrs > 0 && pass == 1)
		    error(ERR_WARNING, "segment attributes specified on"
			  " redeclaration of segment: ignoring");
		if (seg->use32)
		    *bits = 32;
		else
		    *bits = 16;
		return seg->index;
	    }
	}

	*segtail = seg = nasm_malloc(sizeof(*seg));
	seg->next = NULL;
	segtail = &seg->next;
	seg->index = (any_segs ? seg_alloc() : first_seg);
	seg->obj_index = obj_idx;
	seg->grp = NULL;
	any_segs = TRUE;
	seg->name = NULL;
	seg->currentpos = 0;
	seg->align = 1;		       /* default */
	seg->use32 = FALSE;	       /* default */
	seg->combine = CMB_PUBLIC;     /* default */
	seg->segclass = seg->overlay = NULL;
	seg->pubhead = NULL;
	seg->pubtail = &seg->pubhead;

	/*
	 * Process the segment attributes.
	 */
	p = name;
	while (attrs--) {
	    p += strlen(p);
	    while (!*p) p++;

	    /*
	     * `p' contains a segment attribute.
	     */
	    if (!nasm_stricmp(p, "private"))
		seg->combine = CMB_PRIVATE;
	    else if (!nasm_stricmp(p, "public"))
		seg->combine = CMB_PUBLIC;
	    else if (!nasm_stricmp(p, "common"))
		seg->combine = CMB_COMMON;
	    else if (!nasm_stricmp(p, "stack"))
		seg->combine = CMB_STACK;
	    else if (!nasm_stricmp(p, "use16"))
		seg->use32 = FALSE;
	    else if (!nasm_stricmp(p, "use32"))
		seg->use32 = TRUE;
	    else if (!nasm_strnicmp(p, "class=", 6))
		seg->segclass = nasm_strdup(p+6);
	    else if (!nasm_strnicmp(p, "overlay=", 8))
		seg->overlay = nasm_strdup(p+8);
	    else if (!nasm_strnicmp(p, "align=", 6)) {
		seg->align = readnum(p+6, &rn_error);
		if (rn_error) {
		    seg->align = 1;
		    error (ERR_NONFATAL, "segment alignment should be"
			   " numeric");
		}
		switch ((int) seg->align) {
		  case 1:	       /* BYTE */
		  case 2:	       /* WORD */
		  case 4:	       /* DWORD */
		  case 16:	       /* PARA */
		  case 256:	       /* PAGE */
		    break;
		  case 8:
		    error(ERR_WARNING, "OBJ format does not support alignment"
			  " of 8: rounding up to 16");
		    seg->align = 16;
		    break;
		  case 32:
		  case 64:
		  case 128:
		    error(ERR_WARNING, "OBJ format does not support alignment"
			  " of %d: rounding up to 256", seg->align);
		    seg->align = 256;
		    break;
		  default:
		    error(ERR_NONFATAL, "invalid alignment value %d",
			  seg->align);
		    seg->align = 1;
		    break;
		}
	    } else if (!nasm_strnicmp(p, "absolute=", 9)) {
		seg->align = SEG_ABS + readnum(p+9, &rn_error);
		if (rn_error)
		    error (ERR_NONFATAL, "argument to `absolute' segment"
			   " attribute should be numeric");
	    }
	}

	obj_seg_needs_update = seg;
	if (seg->align >= SEG_ABS)
	    deflabel (name, NO_SEG, seg->align - SEG_ABS, &of_obj, error);
	else
	    deflabel (name, seg->index+1, 0L, &of_obj, error);
	obj_seg_needs_update = NULL;

	/*
	 * See if this segment is defined in any groups.
	 */
	for (grp = grphead; grp; grp = grp->next) {
	    for (i = grp->nindices; i < grp->nentries; i++) {
		if (!strcmp(grp->segs[i].name, seg->name)) {
		    nasm_free (grp->segs[i].name);
		    grp->segs[i] = grp->segs[grp->nindices];
		    grp->segs[grp->nindices++].index = seg->obj_index;
		    if (seg->grp)
			error(ERR_WARNING, "segment `%s' is already part of"
			      " a group: first one takes precedence",
			      seg->name);
		    else
			seg->grp = grp;
		}
	    }
	}

	if (seg->use32)
	    *bits = 32;
	else
	    *bits = 16;
	return seg->index;
    }
}

static int obj_directive (char *directive, char *value, int pass) {
    if (!strcmp(directive, "group")) {
	char *p, *q, *v;
	if (pass == 1) {
	    struct Group *grp;
	    struct Segment *seg;
	    int obj_idx;

	    q = value;
	    while (*q == '.')
		q++;		       /* hack, but a documented one */
	    v = q;
	    while (*q && !isspace(*q))
		q++;
	    if (isspace(*q)) {
		*q++ = '\0';
		while (*q && isspace(*q))
		    q++;
	    }
	    /*
	     * Here we used to sanity-check the group directive to
	     * ensure nobody tried to declare a group containing no
	     * segments. However, OS/2 does this as standard
	     * practice, so the sanity check has been removed.
	     *
	     * if (!*q) {
	     *     error(ERR_NONFATAL,"GROUP directive contains no segments");
	     *     return 1;
	     * }
	     */

	    obj_idx = 1;
	    for (grp = grphead; grp; grp = grp->next) {
		obj_idx++;
		if (!strcmp(grp->name, v)) {
		    error(ERR_NONFATAL, "group `%s' defined twice", v);
		    return 1;
		}
	    }

	    *grptail = grp = nasm_malloc(sizeof(*grp));
	    grp->next = NULL;
	    grptail = &grp->next;
	    grp->index = seg_alloc();
	    grp->obj_index = obj_idx;
	    grp->nindices = grp->nentries = 0;
	    grp->name = NULL;

	    obj_grp_needs_update = grp;
	    deflabel (v, grp->index+1, 0L, &of_obj, error);
	    obj_grp_needs_update = NULL;

	    while (*q) {
		p = q;
		while (*q && !isspace(*q))
		    q++;
		if (isspace(*q)) {
		    *q++ = '\0';
		    while (*q && isspace(*q))
			q++;
		}
		/*
		 * Now p contains a segment name. Find it.
		 */
		for (seg = seghead; seg; seg = seg->next)
		    if (!strcmp(seg->name, p))
			break;
		if (seg) {
		    /*
		     * We have a segment index. Shift a name entry
		     * to the end of the array to make room.
		     */
		    grp->segs[grp->nentries++] = grp->segs[grp->nindices];
		    grp->segs[grp->nindices++].index = seg->obj_index;
		    if (seg->grp)
			error(ERR_WARNING, "segment `%s' is already part of"
			      " a group: first one takes precedence",
			      seg->name);
		    else
			seg->grp = grp;
		} else {
		    /*
		     * We have an as-yet undefined segment.
		     * Remember its name, for later.
		     */
		    grp->segs[grp->nentries++].name = nasm_strdup(p);
		}
	    }
	}
	return 1;
    }
    if (!strcmp(directive, "uppercase")) {
	obj_uppercase = TRUE;
	return 1;
    }
    return 0;
}

static long obj_segbase (long segment) {
    struct Segment *seg;

    /*
     * Find the segment in our list.
     */
    for (seg = seghead; seg; seg = seg->next)
	if (seg->index == segment-1)
	    break;

    if (!seg)
	return segment;		       /* not one of ours - leave it alone */

    if (seg->align >= SEG_ABS)
	return seg->align;	       /* absolute segment */
    if (seg->grp)
	return seg->grp->index+1;      /* grouped segment */

    return segment;		       /* no special treatment */
}

static void obj_filename (char *inname, char *outname, efunc error) {
    strcpy(obj_infile, inname);
    standard_extension (inname, outname, ".obj", error);
}

static void obj_write_file (void) {
    struct Segment *seg;
    struct Group *grp;
    struct Public *pub;
    struct External *ext;
    struct ObjData *data;
    static char boast[] = "The Netwide Assembler " NASM_VER;
    int lname_idx, rectype;

    /*
     * Write the THEADR module header.
     */
    recptr = record;
    recptr = obj_write_name (recptr, obj_infile);
    obj_record (THEADR, record, recptr);

    /*
     * Write the NASM boast comment.
     */
    recptr = record;
    recptr = obj_write_rword (recptr, 0);   /* comment type zero */
    recptr = obj_write_name (recptr, boast);
    obj_record (COMENT, record, recptr);

    /*
     * Write the first LNAMES record, containing LNAME one, which
     * is null. Also initialise the LNAME counter.
     */
    recptr = record;
    recptr = obj_write_name (recptr, "");
    obj_record (LNAMES, record, recptr);
    lname_idx = 2;

    /*
     * Write the SEGDEF records. Each has an associated LNAMES
     * record.
     */
    for (seg = seghead; seg; seg = seg->next) {
	int new_segdef;		       /* do we use the newer record type? */
	int acbp;
	int sn, cn, on;		       /* seg, class, overlay LNAME idx */

	if (seg->use32 || seg->currentpos >= 0x10000L)
	    new_segdef = TRUE;
	else
	    new_segdef = FALSE;

	recptr = record;
	recptr = obj_write_name (recptr, seg->name);
	sn = lname_idx++;
	if (seg->segclass) {
	    recptr = obj_write_name (recptr, seg->segclass);
	    cn = lname_idx++;
	} else
	    cn = 1;
	if (seg->overlay) {
	    recptr = obj_write_name (recptr, seg->overlay);
	    on = lname_idx++;
	} else
	    on = 1;
	obj_record (LNAMES, record, recptr);

	acbp = (seg->combine << 2);    /* C field */

	if (seg->currentpos >= 0x10000L && !new_segdef)
	    acbp |= 0x02;	       /* B bit */

	if (seg->use32)
	    acbp |= 0x01;	       /* P bit is Use32 flag */

	/* A field */
	if (seg->align >= SEG_ABS)
	    acbp |= 0x00;
	else if (seg->align >= 256) {
	    if (seg->align > 256)
		error(ERR_NONFATAL, "segment `%s' requires more alignment"
		      " than OBJ format supports", seg->name);
	    acbp |= 0x80;
	} else if (seg->align >= 16) {
	    acbp |= 0x60;
	} else if (seg->align >= 4) {
	    acbp |= 0xA0;
	} else if (seg->align >= 2) {
	    acbp |= 0x40;
	} else
	    acbp |= 0x20;

	recptr = record;
	recptr = obj_write_byte (recptr, acbp);
	if (seg->align & SEG_ABS) {
	    recptr = obj_write_word (recptr, seg->align - SEG_ABS);
	    recptr = obj_write_byte (recptr, 0);
	}
	if (new_segdef)
	    recptr = obj_write_dword (recptr, seg->currentpos);
	else
	    recptr = obj_write_word (recptr, seg->currentpos & 0xFFFF);
	recptr = obj_write_index (recptr, sn);
	recptr = obj_write_index (recptr, cn);
	recptr = obj_write_index (recptr, on);
	if (new_segdef)
	    obj_record (SEGDEF+1, record, recptr);
	else
	    obj_record (SEGDEF, record, recptr);
    }

    /*
     * Write some LNAMES for the group names. lname_idx is left
     * alone here - it will catch up when we write the GRPDEFs.
     */
    recptr = record;
    for (grp = grphead; grp; grp = grp->next) {
	recptr = obj_write_name (recptr, grp->name);
	if (recptr - record > 1024) {
	    obj_record (LNAMES, record, recptr);
	    recptr = record;
	}
    }
    if (recptr > record)
	obj_record (LNAMES, record, recptr);

    /*
     * Write the GRPDEF records.
     */
    for (grp = grphead; grp; grp = grp->next) {
	int i;

	if (grp->nindices != grp->nentries) {
	    for (i = grp->nindices; i < grp->nentries; i++) {
		error(ERR_NONFATAL, "group `%s' contains undefined segment"
		      " `%s'", grp->name, grp->segs[i].name);
		nasm_free (grp->segs[i].name);
		grp->segs[i].name = NULL;
	    }
	}
	recptr = record;
	recptr = obj_write_index (recptr, lname_idx++);
	for (i = 0; i < grp->nindices; i++) {
	    recptr = obj_write_byte (recptr, 0xFF);
	    recptr = obj_write_index (recptr, grp->segs[i].index);
	}
	obj_record (GRPDEF, record, recptr);
    }

    /*
     * Write the PUBDEF records: first the ones in the segments,
     * then the far-absolutes.
     */
    for (seg = seghead; seg; seg = seg->next) {
	int any;

	recptr = record;
	recptr = obj_write_index (recptr, seg->grp ? seg->grp->obj_index : 0);
	recptr = obj_write_index (recptr, seg->obj_index);
	any = FALSE;
	if (seg->use32)
	    rectype = PUBDEF+1;
	else
	    rectype = PUBDEF;
	for (pub = seg->pubhead; pub; pub = pub->next) {
	    if (recptr - record + strlen(pub->name) > 1024) {
		if (any)
		    obj_record (rectype, record, recptr);
		recptr = record;
		recptr = obj_write_index (recptr, 0);
		recptr = obj_write_index (recptr, seg->obj_index);
	    }
	    recptr = obj_write_name (recptr, pub->name);
	    if (seg->use32)
		recptr = obj_write_dword (recptr, pub->offset);
	    else
		recptr = obj_write_word (recptr, pub->offset);
	    recptr = obj_write_index (recptr, 0);
	    any = TRUE;
	}
	if (any)
	    obj_record (rectype, record, recptr);
    }
    for (pub = fpubhead; pub; pub = pub->next) {   /* pub-crawl :-) */
	recptr = record;
	recptr = obj_write_index (recptr, 0);   /* no group */
	recptr = obj_write_index (recptr, 0);   /* no segment either */
	recptr = obj_write_word (recptr, pub->segment);
	recptr = obj_write_name (recptr, pub->name);
	recptr = obj_write_word (recptr, pub->offset);
	recptr = obj_write_index (recptr, 0);
	obj_record (PUBDEF, record, recptr);
    }

    /*
     * Write the EXTDEF and COMDEF records, in order.
     */
    recptr = record;
    for (ext = exthead; ext; ext = ext->next) {
	if (ext->commonsize == 0) {
	    recptr = obj_write_name (recptr, ext->name);
	    recptr = obj_write_index (recptr, 0);
	    if (recptr - record > 1024) {
		obj_record (EXTDEF, record, recptr);
		recptr = record;
	    }
	} else {
	    if (recptr > record)
		obj_record (EXTDEF, record, recptr);
	    recptr = record;
	    if (ext->commonsize > 0) {
		recptr = obj_write_name (recptr, ext->name);
		recptr = obj_write_index (recptr, 0);
		recptr = obj_write_byte (recptr, 0x61);/* far communal */
		recptr = obj_write_value (recptr, 1L);
		recptr = obj_write_value (recptr, ext->commonsize);
		obj_record (COMDEF, record, recptr);
	    } else if (ext->commonsize < 0) {
		recptr = obj_write_name (recptr, ext->name);
		recptr = obj_write_index (recptr, 0);
		recptr = obj_write_byte (recptr, 0x62);/* near communal */
		recptr = obj_write_value (recptr, ext->commonsize);
		obj_record (COMDEF, record, recptr);
	    }
	    recptr = record;
	}
    }
    if (recptr > record)
	obj_record (EXTDEF, record, recptr);

    /*
     * Write a COMENT record stating that the linker's first pass
     * may stop processing at this point. Exception is if we're in
     * OS/2 mode and our MODEND record specifies a start point, in
     * which case, according to the OS/2 documentation, this COMENT
     * should be omitted.
     */
    if (!os2 || obj_entry_seg == NO_SEG) {
	recptr = record;
	recptr = obj_write_rword (recptr, 0x40A2);
	recptr = obj_write_byte (recptr, 1);
	obj_record (COMENT, record, recptr);
    }

    /*
     * Write the LEDATA/FIXUPP pairs.
     */
    for (data = datahead; data; data = data->next) {
	if (data->nonempty) {
	    obj_record (data->letype, data->ledata, data->lptr);
	    if (data->fptr != data->fixupp)
		obj_record (data->ftype, data->fixupp, data->fptr);
	}
    }

    /*
     * Write the MODEND module end marker.
     */
    recptr = record;
    rectype = MODEND;
    if (obj_entry_seg != NO_SEG) {
	recptr = obj_write_byte (recptr, 0xC1);
	/*
	 * Find the segment in the segment list.
	 */
	for (seg = seghead; seg; seg = seg->next) {
	    if (seg->index == obj_entry_seg) {
		if (seg->grp) {
		    recptr = obj_write_byte (recptr, 0x10);
		    recptr = obj_write_index (recptr, seg->grp->obj_index);
		} else {
		    recptr = obj_write_byte (recptr, 0x50);
		}
		recptr = obj_write_index (recptr, seg->obj_index);
		if (seg->use32) {
		    rectype = MODEND+1;
		    recptr = obj_write_dword (recptr, obj_entry_ofs);
		} else
		    recptr = obj_write_word (recptr, obj_entry_ofs);
		break;
	    }
	}
	if (!seg)
	    error(ERR_NONFATAL, "entry point is not in this module");
    } else
	recptr = obj_write_byte (recptr, 0);
    obj_record (rectype, record, recptr);
}

static unsigned char *obj_write_data(unsigned char *ptr,
				     unsigned char *data, int len) {
    while (len--)
	*ptr++ = *data++;
    return ptr;
}

static unsigned char *obj_write_byte(unsigned char *ptr, int data) {
    *ptr++ = data;
    return ptr;
}

static unsigned char *obj_write_word(unsigned char *ptr, int data) {
    *ptr++ = data & 0xFF;
    *ptr++ = (data >> 8) & 0xFF;
    return ptr;
}

static unsigned char *obj_write_dword(unsigned char *ptr, long data) {
    *ptr++ = data & 0xFF;
    *ptr++ = (data >> 8) & 0xFF;
    *ptr++ = (data >> 16) & 0xFF;
    *ptr++ = (data >> 24) & 0xFF;
    return ptr;
}

static unsigned char *obj_write_rword(unsigned char *ptr, int data) {
    *ptr++ = (data >> 8) & 0xFF;
    *ptr++ = data & 0xFF;
    return ptr;
}

static unsigned char *obj_write_name(unsigned char *ptr, char *data) {
    *ptr++ = strlen(data);
    if (obj_uppercase) {
	while (*data) {
	    *ptr++ = (unsigned char) toupper(*data);
	    data++;
	}
    } else {
	while (*data)
	    *ptr++ = (unsigned char) *data++;
    }
    return ptr;
}

static unsigned char *obj_write_index(unsigned char *ptr, int data) {
    if (data < 128)
	*ptr++ = data;
    else {
	*ptr++ = 0x80 | ((data >> 8) & 0x7F);
	*ptr++ = data & 0xFF;
    }
    return ptr;
}

static unsigned char *obj_write_value(unsigned char *ptr,
				      unsigned long data) {
    if (data <= 128)
	*ptr++ = data;
    else if (data <= 0xFFFF) {
	*ptr++ = 129;
	*ptr++ = data & 0xFF;
	*ptr++ = (data >> 8) & 0xFF;
    } else if (data <= 0xFFFFFFL) {
	*ptr++ = 132;
	*ptr++ = data & 0xFF;
	*ptr++ = (data >> 8) & 0xFF;
	*ptr++ = (data >> 16) & 0xFF;
    } else {
	*ptr++ = 136;
	*ptr++ = data & 0xFF;
	*ptr++ = (data >> 8) & 0xFF;
	*ptr++ = (data >> 16) & 0xFF;
	*ptr++ = (data >> 24) & 0xFF;
    }
    return ptr;
}

static void obj_record(int type, unsigned char *start, unsigned char *end) {
    unsigned long cksum, len;

    cksum = type;
    fputc (type, ofp);
    len = end-start+1;
    cksum += (len & 0xFF) + ((len>>8) & 0xFF);
    fwriteshort (len, ofp);
    fwrite (start, 1, end-start, ofp);
    while (start < end)
	cksum += *start++;
    fputc ( (-cksum) & 0xFF, ofp);
}

struct ofmt of_obj = {
    "Microsoft MS-DOS 16-bit OMF object files",
    "obj",
    dos_init,
    obj_out,
    obj_deflabel,
    obj_segment,
    obj_segbase,
    obj_directive,
    obj_filename,
    obj_cleanup
};

struct ofmt of_os2 = {
    "OS/2 object files (variant of OMF)",
    "os2",
    os2_init,
    obj_out,
    obj_deflabel,
    obj_segment,
    obj_segbase,
    obj_directive,
    obj_filename,
    obj_cleanup
};

#endif /* OF_OBJ */
