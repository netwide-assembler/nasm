/* nasmlib.c	library routines for the Netwide Assembler
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

static efunc nasm_malloc_error;

#ifdef LOGALLOC
static FILE *logfp;
#endif

void nasm_set_malloc_error (efunc error) 
{
    nasm_malloc_error = error;
#ifdef LOGALLOC
    logfp = fopen ("malloc.log", "w");
    setvbuf (logfp, NULL, _IOLBF, BUFSIZ);
    fprintf (logfp, "null pointer is %p\n", NULL);
#endif
}

#ifdef LOGALLOC
void *nasm_malloc_log (char *file, int line, size_t size)
#else
void *nasm_malloc (size_t size)
#endif
{
    void *p = malloc(size);
    if (!p)
	nasm_malloc_error (ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
	fprintf(logfp, "%s %d malloc(%ld) returns %p\n",
		file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void *nasm_realloc_log (char *file, int line, void *q, size_t size)
#else
void *nasm_realloc (void *q, size_t size)
#endif
{
    void *p = q ? realloc(q, size) : malloc(size);
    if (!p)
	nasm_malloc_error (ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else if (q)
	fprintf(logfp, "%s %d realloc(%p,%ld) returns %p\n",
		file, line, q, (long)size, p);
    else
	fprintf(logfp, "%s %d malloc(%ld) returns %p\n",
		file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void nasm_free_log (char *file, int line, void *q)
#else
void nasm_free (void *q)
#endif
{
    if (q) {
	free (q);
#ifdef LOGALLOC
	fprintf(logfp, "%s %d free(%p)\n",
		file, line, q);
#endif
    }
}

#ifdef LOGALLOC
char *nasm_strdup_log (char *file, int line, char *s)
#else
char *nasm_strdup (char *s)
#endif
{
    char *p;
    int size = strlen(s)+1;

    p = malloc(size);
    if (!p)
	nasm_malloc_error (ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
	fprintf(logfp, "%s %d strdup(%ld) returns %p\n",
		file, line, (long)size, p);
#endif
    strcpy (p, s);
    return p;
}

#ifdef LOGALLOC
char *nasm_strndup_log (char *file, int line, char *s, size_t len)
#else
char *nasm_strndup (char *s, size_t len)
#endif
{
    char *p;
    int size = len+1;

    p = malloc(size);
    if (!p)
	nasm_malloc_error (ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
	fprintf(logfp, "%s %d strndup(%ld) returns %p\n",
		file, line, (long)size, p);
#endif
    strncpy (p, s, len);
    p[len] = '\0';
    return p;
}

int nasm_stricmp (const char *s1, const char *s2) 
{
    while (*s1 && toupper(*s1) == toupper(*s2))
	s1++, s2++;
    if (!*s1 && !*s2)
	return 0;
    else if (toupper(*s1) < toupper(*s2))
	return -1;
    else
	return 1;
}

int nasm_strnicmp (const char *s1, const char *s2, int n) 
{
    while (n > 0 && *s1 && toupper(*s1) == toupper(*s2))
	s1++, s2++, n--;
    if ((!*s1 && !*s2) || n==0)
	return 0;
    else if (toupper(*s1) < toupper(*s2))
	return -1;
    else
	return 1;
}

#define lib_isnumchar(c)   ( isalnum(c) || (c) == '$')
#define numvalue(c)  ((c)>='a' ? (c)-'a'+10 : (c)>='A' ? (c)-'A'+10 : (c)-'0')

long readnum (char *str, int *error) 
{
    char *r = str, *q;
    long radix;
    unsigned long result, checklimit;
    int digit, last;
    int warn = FALSE;
    int sign = 1;

    *error = FALSE;

    while (isspace(*r)) r++;	       /* find start of number */

    /*
     * If the number came from make_tok_num (as a result of an %assign), it
     * might have a '-' built into it (rather than in a preceeding token).
     */
    if (*r == '-')
    {
	r++;
	sign = -1;
    }

    q = r;

    while (lib_isnumchar(*q)) q++;     /* find end of number */

    /*
     * If it begins 0x, 0X or $, or ends in H, it's in hex. if it
     * ends in Q, it's octal. if it ends in B, it's binary.
     * Otherwise, it's ordinary decimal.
     */
    if (*r=='0' && (r[1]=='x' || r[1]=='X'))
	radix = 16, r += 2;
    else if (*r=='$')
	radix = 16, r++;
    else if (q[-1]=='H' || q[-1]=='h')
	radix = 16 , q--;
    else if (q[-1]=='Q' || q[-1]=='q')
	radix = 8 , q--;
    else if (q[-1]=='B' || q[-1]=='b')
	radix = 2 , q--;
    else
	radix = 10;

    /*
     * If this number has been found for us by something other than
     * the ordinary scanners, then it might be malformed by having
     * nothing between the prefix and the suffix. Check this case
     * now.
     */
    if (r >= q) {
	*error = TRUE;
	return 0;
    }

    /*
     * `checklimit' must be 2**32 / radix. We can't do that in
     * 32-bit arithmetic, which we're (probably) using, so we
     * cheat: since we know that all radices we use are even, we
     * can divide 2**31 by radix/2 instead.
     */
    checklimit = 0x80000000UL / (radix>>1);

    /*
     * Calculate the highest allowable value for the last digit
     * of a 32 bit constant... in radix 10, it is 6, otherwise it is 0
     */
    last = (radix == 10 ? 6 : 0);

    result = 0;
    while (*r && r < q) {
	if (*r<'0' || (*r>'9' && *r<'A') || (digit = numvalue(*r)) >= radix) 
	{
	    *error = TRUE;
	    return 0;
	}
	if (result > checklimit ||
	    (result == checklimit && digit >= last))
	{
	    warn = TRUE;
	}

	result = radix * result + digit;
	r++;
    }

    if (warn)
	nasm_malloc_error (ERR_WARNING | ERR_PASS1 | ERR_WARN_NOV,
			   "numeric constant %s does not fit in 32 bits",
			   str);

    return result*sign;
}

long readstrnum (char *str, int length, int *warn) 
{
    long charconst = 0;
    int i;

    *warn = FALSE;

    str += length;
    for (i=0; i<length; i++) {
	if (charconst & 0xff000000UL) {
	    *warn = TRUE;
	}
	charconst = (charconst<<8) + (unsigned char) *--str;
    }
    return charconst;
}

static long next_seg;

void seg_init(void) 
{
    next_seg = 0;
}

long seg_alloc(void) 
{
    return (next_seg += 2) - 2;
}

void fwriteshort (int data, FILE *fp) 
{
    fputc ((int) (data & 255), fp);
    fputc ((int) ((data >> 8) & 255), fp);
}

void fwritelong (long data, FILE *fp) 
{
    fputc ((int) (data & 255), fp);
    fputc ((int) ((data >> 8) & 255), fp);
    fputc ((int) ((data >> 16) & 255), fp);
    fputc ((int) ((data >> 24) & 255), fp);
}

void standard_extension (char *inname, char *outname, char *extension,
			 efunc error) 
{
    char *p, *q;

    if (*outname)		       /* file name already exists, */
	return;			       /* so do nothing */
    q = inname;
    p = outname;
    while (*q) *p++ = *q++;	       /* copy, and find end of string */
    *p = '\0';			       /* terminate it */
    while (p > outname && *--p != '.');/* find final period (or whatever) */
    if (*p != '.') while (*p) p++;     /* go back to end if none found */
    if (!strcmp(p, extension)) {       /* is the extension already there? */
	if (*extension)
	    error(ERR_WARNING | ERR_NOFILE,
		  "file name already ends in `%s': "
		  "output will be in `nasm.out'",
		  extension);
	else
	    error(ERR_WARNING | ERR_NOFILE,
		  "file name already has no extension: "
		  "output will be in `nasm.out'");
	strcpy(outname, "nasm.out");
    } else
	strcpy(p, extension);
}

#define LEAFSIZ (sizeof(RAA)-sizeof(RAA_UNION)+sizeof(RAA_LEAF))
#define BRANCHSIZ (sizeof(RAA)-sizeof(RAA_UNION)+sizeof(RAA_BRANCH))

#define LAYERSIZ(r) ( (r)->layers==0 ? RAA_BLKSIZE : RAA_LAYERSIZE )

static struct RAA *real_raa_init (int layers) 
{
    struct RAA *r;

    if (layers == 0) {
	r = nasm_malloc (LEAFSIZ);
	memset (r->u.l.data, 0, sizeof(r->u.l.data));
	r->layers = 0;
	r->stepsize = 1L;
    } else {
	r = nasm_malloc (BRANCHSIZ);
	memset (r->u.b.data, 0, sizeof(r->u.b.data));
	r->layers = layers;
	r->stepsize = RAA_BLKSIZE;
	while (--layers)
	    r->stepsize *= RAA_LAYERSIZE;
    }
    return r;
}

struct RAA *raa_init (void) 
{
    return real_raa_init (0);
}

void raa_free (struct RAA *r) 
{
    if (r->layers == 0)
	nasm_free (r);
    else {
	struct RAA **p;
	for (p = r->u.b.data; p - r->u.b.data < RAA_LAYERSIZE; p++)
	    if (*p)
		raa_free (*p);
    }
}

long raa_read (struct RAA *r, long posn) 
{
    if (posn > r->stepsize * LAYERSIZ(r))
	return 0L;
    while (r->layers > 0) {
	ldiv_t l;
	l = ldiv (posn, r->stepsize);
	r = r->u.b.data[l.quot];
	posn = l.rem;
	if (!r)			       /* better check this */
	    return 0L;
    }
    return r->u.l.data[posn];
}

struct RAA *raa_write (struct RAA *r, long posn, long value) 
{
    struct RAA *result;

    if (posn < 0)
	nasm_malloc_error (ERR_PANIC, "negative position in raa_write");

    while (r->stepsize * LAYERSIZ(r) < posn) {
	/*
	 * Must go up a layer.
	 */
	struct RAA *s;

	s = nasm_malloc (BRANCHSIZ);
	memset (s->u.b.data, 0, sizeof(r->u.b.data));
	s->layers = r->layers + 1;
	s->stepsize = RAA_LAYERSIZE * r->stepsize;
	s->u.b.data[0] = r;
	r = s;
    }

    result = r;

    while (r->layers > 0) {
	ldiv_t l;
	struct RAA **s;
	l = ldiv (posn, r->stepsize);
	s = &r->u.b.data[l.quot];
	if (!*s)
	    *s = real_raa_init (r->layers - 1);
	r = *s;
	posn = l.rem;
    }

    r->u.l.data[posn] = value;

    return result;
}

#define SAA_MAXLEN 8192

struct SAA *saa_init (long elem_len) 
{
    struct SAA *s;

    if (elem_len > SAA_MAXLEN)
	nasm_malloc_error (ERR_PANIC | ERR_NOFILE, "SAA with huge elements");

    s = nasm_malloc (sizeof(struct SAA));
    s->posn = s->start = 0L;
    s->elem_len = elem_len;
    s->length = SAA_MAXLEN - (SAA_MAXLEN % elem_len);
    s->data = nasm_malloc (s->length);
    s->next = NULL;
    s->end = s;

    return s;
}

void saa_free (struct SAA *s) 
{
    struct SAA *t;

    while (s) {
	t = s->next;
	nasm_free (s->data);
	nasm_free (s);
	s = t;
    }
}

void *saa_wstruct (struct SAA *s) 
{
    void *p;

    if (s->end->length - s->end->posn < s->elem_len) {
	s->end->next = nasm_malloc (sizeof(struct SAA));
	s->end->next->start = s->end->start + s->end->posn;
	s->end = s->end->next;
	s->end->length = s->length;
	s->end->next = NULL;
	s->end->posn = 0L;
	s->end->data = nasm_malloc (s->length);
    }

    p = s->end->data + s->end->posn;
    s->end->posn += s->elem_len;
    return p;
}

void saa_wbytes (struct SAA *s, void *data, long len) 
{
    char *d = data;

    while (len > 0) {
	long l = s->end->length - s->end->posn;
	if (l > len)
	    l = len;
	if (l > 0) {
	    if (d) {
		memcpy (s->end->data + s->end->posn, d, l);
		d += l;
	    } else
		memset (s->end->data + s->end->posn, 0, l);
	    s->end->posn += l;
	    len -= l;
	}
	if (len > 0) {
	    s->end->next = nasm_malloc (sizeof(struct SAA));
	    s->end->next->start = s->end->start + s->end->posn;
	    s->end = s->end->next;
	    s->end->length = s->length;
	    s->end->next = NULL;
	    s->end->posn = 0L;
	    s->end->data = nasm_malloc (s->length);
	}
    }
}

void saa_rewind (struct SAA *s) 
{
    s->rptr = s;
    s->rpos = 0L;
}

void *saa_rstruct (struct SAA *s) 
{
    void *p;

    if (!s->rptr)
	return NULL;

    if (s->rptr->posn - s->rpos < s->elem_len) {
	s->rptr = s->rptr->next;
	if (!s->rptr)
	    return NULL;	       /* end of array */
	s->rpos = 0L;
    }

    p = s->rptr->data + s->rpos;
    s->rpos += s->elem_len;
    return p;
}

void *saa_rbytes (struct SAA *s, long *len) 
{
    void *p;

    if (!s->rptr)
	return NULL;

    p = s->rptr->data + s->rpos;
    *len = s->rptr->posn - s->rpos;
    s->rptr = s->rptr->next;
    s->rpos = 0L;
    return p;
}

void saa_rnbytes (struct SAA *s, void *data, long len) 
{
    char *d = data;

    while (len > 0) {
	long l;

	if (!s->rptr)
	    return;

	l = s->rptr->posn - s->rpos;
	if (l > len)
	    l = len;
	if (l > 0) {
	    memcpy (d, s->rptr->data + s->rpos, l);
	    d += l;
	    s->rpos += l;
	    len -= l;
	}
	if (len > 0) {
	    s->rptr = s->rptr->next;
	    s->rpos = 0L;
	}
    }
}

void saa_fread (struct SAA *s, long posn, void *data, long len) 
{
    struct SAA *p;
    long pos;
    char *cdata = data;

    if (!s->rptr || posn < s->rptr->start)
	saa_rewind (s);
    p = s->rptr;
    while (posn >= p->start + p->posn) {
	p = p->next;
	if (!p)
	    return;		       /* what else can we do?! */
    }

    pos = posn - p->start;
    while (len) {
	long l = p->posn - pos;
	if (l > len)
	    l = len;
	memcpy (cdata, p->data+pos, l);
	len -= l;
	cdata += l;
	p = p->next;
	if (!p)
	    return;
	pos = 0L;
    }
    s->rptr = p;
}

void saa_fwrite (struct SAA *s, long posn, void *data, long len) 
{
    struct SAA *p;
    long pos;
    char *cdata = data;

    if (!s->rptr || posn < s->rptr->start)
	saa_rewind (s);
    p = s->rptr;
    while (posn >= p->start + p->posn) {
	p = p->next;
	if (!p)
	    return;		       /* what else can we do?! */
    }

    pos = posn - p->start;
    while (len) {
	long l = p->posn - pos;
	if (l > len)
	    l = len;
	memcpy (p->data+pos, cdata, l);
	len -= l;
	cdata += l;
	p = p->next;
	if (!p)
	    return;
	pos = 0L;
    }
    s->rptr = p;
}

void saa_fpwrite (struct SAA *s, FILE *fp) 
{
    char *data;
    long len;

    saa_rewind (s);
    while ( (data = saa_rbytes (s, &len)) )
	fwrite (data, 1, len, fp);
}

/*
 * Register, instruction, condition-code and prefix keywords used
 * by the scanner.
 */
#include "names.c"
static char *special_names[] = {
    "byte", "dword", "far", "long", "near", "nosplit", "qword",
    "short", "to", "tword", "word"
};
static char *prefix_names[] = {
    "a16", "a32", "lock", "o16", "o32", "rep", "repe", "repne",
    "repnz", "repz", "times"
};


/*
 * Standard scanner routine used by parser.c and some output
 * formats. It keeps a succession of temporary-storage strings in
 * stdscan_tempstorage, which can be cleared using stdscan_reset.
 */
static char **stdscan_tempstorage = NULL;
static int stdscan_tempsize = 0, stdscan_templen = 0;
#define STDSCAN_TEMP_DELTA 256

static void stdscan_pop(void) 
{
    nasm_free (stdscan_tempstorage[--stdscan_templen]);
}

void stdscan_reset(void) 
{
    while (stdscan_templen > 0)
	stdscan_pop();
}

/*
 * Unimportant cleanup is done to avoid confusing people who are trying
 * to debug real memory leaks
 */
void nasmlib_cleanup (void) 
{
    stdscan_reset();
    nasm_free (stdscan_tempstorage);
}

static char *stdscan_copy(char *p, int len) 
{
    char *text;

    text = nasm_malloc(len+1);
    strncpy (text, p, len);
    text[len] = '\0';

    if (stdscan_templen >= stdscan_tempsize) {
	stdscan_tempsize += STDSCAN_TEMP_DELTA;
	stdscan_tempstorage = nasm_realloc(stdscan_tempstorage,
					   stdscan_tempsize*sizeof(char *));
    }
    stdscan_tempstorage[stdscan_templen++] = text;

    return text;
}

char *stdscan_bufptr = NULL;
int stdscan (void *private_data, struct tokenval *tv) 
{
    char ourcopy[MAX_KEYWORD+1], *r, *s;

    (void) private_data;  /* Don't warn that this parameter is unused */

    while (isspace(*stdscan_bufptr)) stdscan_bufptr++;
    if (!*stdscan_bufptr)
	return tv->t_type = 0;

    /* we have a token; either an id, a number or a char */
    if (isidstart(*stdscan_bufptr) ||
	(*stdscan_bufptr == '$' && isidstart(stdscan_bufptr[1]))) {
	/* now we've got an identifier */
	int i;
	int is_sym = FALSE;

	if (*stdscan_bufptr == '$') {
	    is_sym = TRUE;
	    stdscan_bufptr++;
	}

 	r = stdscan_bufptr++;
	while (isidchar(*stdscan_bufptr)) stdscan_bufptr++;
	tv->t_charptr = stdscan_copy(r, stdscan_bufptr - r);

	if (is_sym || stdscan_bufptr-r > MAX_KEYWORD)
	    return tv->t_type = TOKEN_ID;/* bypass all other checks */
    
	for (s=tv->t_charptr, r=ourcopy; *s; s++)
	    *r++ = tolower (*s);
	*r = '\0';
	/* right, so we have an identifier sitting in temp storage. now,
	 * is it actually a register or instruction name, or what? */
	if ((tv->t_integer=bsi(ourcopy, reg_names,
			       elements(reg_names)))>=0) {
	    tv->t_integer += EXPR_REG_START;
	    return tv->t_type = TOKEN_REG;
	} else if ((tv->t_integer=bsi(ourcopy, insn_names,
				      elements(insn_names)))>=0) {
	    return tv->t_type = TOKEN_INSN;
	}
	for (i=0; i<elements(icn); i++)
	    if (!strncmp(ourcopy, icn[i], strlen(icn[i]))) {
		char *p = ourcopy + strlen(icn[i]);
		tv->t_integer = ico[i];
		if ((tv->t_inttwo=bsi(p, conditions,
					 elements(conditions)))>=0)
		    return tv->t_type = TOKEN_INSN;
	    }
	if ((tv->t_integer=bsi(ourcopy, prefix_names,
				  elements(prefix_names)))>=0) {
	    tv->t_integer += PREFIX_ENUM_START;
	    return tv->t_type = TOKEN_PREFIX;
	}
	if ((tv->t_integer=bsi(ourcopy, special_names,
				  elements(special_names)))>=0)
	    return tv->t_type = TOKEN_SPECIAL;
	if (!strcmp(ourcopy, "seg"))
	    return tv->t_type = TOKEN_SEG;
	if (!strcmp(ourcopy, "wrt"))
	    return tv->t_type = TOKEN_WRT;
	return tv->t_type = TOKEN_ID;
    } else if (*stdscan_bufptr == '$' && !isnumchar(stdscan_bufptr[1])) {
	/*
	 * It's a $ sign with no following hex number; this must
	 * mean it's a Here token ($), evaluating to the current
	 * assembly location, or a Base token ($$), evaluating to
	 * the base of the current segment.
	 */
	stdscan_bufptr++;
	if (*stdscan_bufptr == '$') {
	    stdscan_bufptr++;
	    return tv->t_type = TOKEN_BASE;
	}
	return tv->t_type = TOKEN_HERE;
    } else if (isnumstart(*stdscan_bufptr)) {  /* now we've got a number */
	int rn_error;

	r = stdscan_bufptr++;
	while (isnumchar(*stdscan_bufptr))
	    stdscan_bufptr++;

	if (*stdscan_bufptr == '.') {
	    /*
	     * a floating point constant
	     */
	    stdscan_bufptr++;
	    while (isnumchar(*stdscan_bufptr) ||
		   ((stdscan_bufptr[-1] == 'e' || stdscan_bufptr[-1] == 'E')
		    && (*stdscan_bufptr == '-' || *stdscan_bufptr == '+')) ) 
	    {
		stdscan_bufptr++;
	    }
	    tv->t_charptr = stdscan_copy(r, stdscan_bufptr - r);
	    return tv->t_type = TOKEN_FLOAT;
	}
	r = stdscan_copy(r, stdscan_bufptr - r);
	tv->t_integer = readnum(r, &rn_error);
	stdscan_pop();
	if (rn_error)
	    return tv->t_type = TOKEN_ERRNUM;/* some malformation occurred */
	tv->t_charptr = NULL;
	return tv->t_type = TOKEN_NUM;
    } else if (*stdscan_bufptr == '\'' ||
	       *stdscan_bufptr == '"') {/* a char constant */
    	char quote = *stdscan_bufptr++, *r;
	int rn_warn;
	r = tv->t_charptr = stdscan_bufptr;
	while (*stdscan_bufptr && *stdscan_bufptr != quote) stdscan_bufptr++;
	tv->t_inttwo = stdscan_bufptr - r;      /* store full version */
	if (!*stdscan_bufptr)
	    return tv->t_type = TOKEN_ERRNUM;       /* unmatched quotes */
	stdscan_bufptr++;			/* skip over final quote */
	tv->t_integer = readstrnum(r, tv->t_inttwo, &rn_warn);
	/* FIXME: rn_warn is not checked! */
	return tv->t_type = TOKEN_NUM;
    } else if (*stdscan_bufptr == ';') {  /* a comment has happened - stay */
	return tv->t_type = 0;
    } else if (stdscan_bufptr[0] == '>' && stdscan_bufptr[1] == '>') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_SHR;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '<') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_SHL;
    } else if (stdscan_bufptr[0] == '/' && stdscan_bufptr[1] == '/') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_SDIV;
    } else if (stdscan_bufptr[0] == '%' && stdscan_bufptr[1] == '%') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_SMOD;
    } else if (stdscan_bufptr[0] == '=' && stdscan_bufptr[1] == '=') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_EQ;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '>') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_NE;
    } else if (stdscan_bufptr[0] == '!' && stdscan_bufptr[1] == '=') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_NE;
    } else if (stdscan_bufptr[0] == '<' && stdscan_bufptr[1] == '=') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_LE;
    } else if (stdscan_bufptr[0] == '>' && stdscan_bufptr[1] == '=') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_GE;
    } else if (stdscan_bufptr[0] == '&' && stdscan_bufptr[1] == '&') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_DBL_AND;
    } else if (stdscan_bufptr[0] == '^' && stdscan_bufptr[1] == '^') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_DBL_XOR;
    } else if (stdscan_bufptr[0] == '|' && stdscan_bufptr[1] == '|') {
	stdscan_bufptr += 2;
	return tv->t_type = TOKEN_DBL_OR;
    } else			       /* just an ordinary char */
    	return tv->t_type = (unsigned char) (*stdscan_bufptr++);
}

/*
 * Return TRUE if the argument is a simple scalar. (Or a far-
 * absolute, which counts.)
 */
int is_simple (expr *vect) 
{
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type)
	return 1;
    if (vect->type != EXPR_SIMPLE)
	return 0;
    do {
	vect++;
    } while (vect->type && !vect->value);
    if (vect->type && vect->type < EXPR_SEGBASE+SEG_ABS) return 0;
    return 1;
}

/*
 * Return TRUE if the argument is a simple scalar, _NOT_ a far-
 * absolute.
 */
int is_really_simple (expr *vect) 
{
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type)
	return 1;
    if (vect->type != EXPR_SIMPLE)
	return 0;
    do {
	vect++;
    } while (vect->type && !vect->value);
    if (vect->type) return 0;
    return 1;
}

/*
 * Return TRUE if the argument is relocatable (i.e. a simple
 * scalar, plus at most one segment-base, plus possibly a WRT).
 */
int is_reloc (expr *vect) 
{
    while (vect->type && !vect->value) /* skip initial value-0 terms */
    	vect++;
    if (!vect->type)		       /* trivially return TRUE if nothing */
	return 1;		       /* is present apart from value-0s */
    if (vect->type < EXPR_SIMPLE)      /* FALSE if a register is present */
	return 0;
    if (vect->type == EXPR_SIMPLE) {   /* skip over a pure number term... */
	do {
	    vect++;
	} while (vect->type && !vect->value);
	if (!vect->type)	       /* ...returning TRUE if that's all */
	    return 1;
    }
    if (vect->type == EXPR_WRT) {      /* skip over a WRT term... */
	do {
	    vect++;
	} while (vect->type && !vect->value);
	if (!vect->type)	       /* ...returning TRUE if that's all */
	    return 1;
    }
    if (vect->value != 0 && vect->value != 1)
	return 0;		       /* segment base multiplier non-unity */
    do {			       /* skip over _one_ seg-base term... */
	vect++;
    } while (vect->type && !vect->value);
    if (!vect->type)		       /* ...returning TRUE if that's all */
	return 1;
    return 0;			       /* And return FALSE if there's more */
}

/*
 * Return TRUE if the argument contains an `unknown' part.
 */
int is_unknown(expr *vect) 
{
    while (vect->type && vect->type < EXPR_UNKNOWN)
	vect++;
    return (vect->type == EXPR_UNKNOWN);
}

/*
 * Return TRUE if the argument contains nothing but an `unknown'
 * part.
 */
int is_just_unknown(expr *vect) 
{
    while (vect->type && !vect->value)
	vect++;
    return (vect->type == EXPR_UNKNOWN);
}

/*
 * Return the scalar part of a relocatable vector. (Including
 * simple scalar vectors - those qualify as relocatable.)
 */
long reloc_value (expr *vect) 
{
    while (vect->type && !vect->value)
    	vect++;
    if (!vect->type) return 0;
    if (vect->type == EXPR_SIMPLE)
	return vect->value;
    else
	return 0;
}

/*
 * Return the segment number of a relocatable vector, or NO_SEG for
 * simple scalars.
 */
long reloc_seg (expr *vect) 
{
    while (vect->type && (vect->type == EXPR_WRT || !vect->value))
    	vect++;
    if (vect->type == EXPR_SIMPLE) {
	do {
	    vect++;
	} while (vect->type && (vect->type == EXPR_WRT || !vect->value));
    }
    if (!vect->type)
	return NO_SEG;
    else
	return vect->type - EXPR_SEGBASE;
}

/*
 * Return the WRT segment number of a relocatable vector, or NO_SEG
 * if no WRT part is present.
 */
long reloc_wrt (expr *vect) 
{
    while (vect->type && vect->type < EXPR_WRT)
    	vect++;
    if (vect->type == EXPR_WRT) {
	return vect->value;
    } else
	return NO_SEG;
}

/*
 * Binary search.
 */
int bsi (char *string, char **array, int size) 
{
    int i = -1, j = size;	       /* always, i < index < j */
    while (j-i >= 2) {
	int k = (i+j)/2;
	int l = strcmp(string, array[k]);
	if (l<0)		       /* it's in the first half */
	    j = k;
	else if (l>0)		       /* it's in the second half */
	    i = k;
	else			       /* we've got it :) */
	    return k;
    }
    return -1;			       /* we haven't got it :( */
}

static char *file_name = NULL;
static long line_number = 0;

char *src_set_fname(char *newname) 
{
    char *oldname = file_name;
    file_name = newname;
    return oldname;
}

long src_set_linnum(long newline) 
{
    long oldline = line_number;
    line_number = newline;
    return oldline;
}

long src_get_linnum(void) 
{
    return line_number;
}

int src_get(long *xline, char **xname) 
{
    if (!file_name || !*xname || strcmp(*xname, file_name)) 
    {
	nasm_free(*xname);
	*xname = file_name ? nasm_strdup(file_name) : NULL;
	*xline = line_number;
	return -2;
    }
    if (*xline != line_number) 
    {
	long tmp = line_number - *xline;
	*xline = line_number;
	return tmp;
    }
    return 0;
}

void nasm_quote(char **str) 
{
    int ln=strlen(*str);
    char q=(*str)[0];
    char *p;
    if (ln>1 && (*str)[ln-1]==q && (q=='"' || q=='\''))
	return;
    q = '"';
    if (strchr(*str,q))
	q = '\'';
    p = nasm_malloc(ln+3);
    strcpy(p+1, *str);
    nasm_free(*str);
    p[ln+1] = p[0] = q;
    p[ln+2] = 0;
    *str = p;
}
    
char *nasm_strcat(char *one, char *two) 
{
    char *rslt;
    int l1=strlen(one);
    rslt = nasm_malloc(l1+strlen(two)+1);
    strcpy(rslt, one);
    strcpy(rslt+l1, two);
    return rslt;
}

void null_debug_routine()
{
}
struct dfmt null_debug_form = {
    "Null debug format",
    "null",
    null_debug_routine,
    null_debug_routine,
    null_debug_routine,
    null_debug_routine,
    null_debug_routine,
    null_debug_routine,
    null_debug_routine,
};

struct dfmt *null_debug_arr[2] = { &null_debug_form, NULL };
