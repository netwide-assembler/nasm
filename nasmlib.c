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

void nasm_set_malloc_error (efunc error) {
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

int nasm_stricmp (char *s1, char *s2) {
    while (*s1 && toupper(*s1) == toupper(*s2))
	s1++, s2++;
    if (!*s1 && !*s2)
	return 0;
    else if (toupper(*s1) < toupper(*s2))
	return -1;
    else
	return 1;
}

int nasm_strnicmp (char *s1, char *s2, int n) {
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

long readnum (char *str, int *error) {
    char *r = str, *q;
    long radix;
    long result;

    *error = FALSE;

    while (isspace(*r)) r++;	       /* find start of number */
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

    result = 0;
    while (*r && r < q) {
	if (*r<'0' || (*r>'9' && *r<'A') || numvalue(*r)>=radix) {
	    *error = TRUE;
	    return 0;
	}
	result = radix * result + numvalue(*r);
	r++;
    }
    return result;
}

static long next_seg;

void seg_init(void) {
    next_seg = 0;
}

long seg_alloc(void) {
    return (next_seg += 2) - 2;
}

void fwriteshort (int data, FILE *fp) {
    fputc ((int) (data & 255), fp);
    fputc ((int) ((data >> 8) & 255), fp);
}

void fwritelong (long data, FILE *fp) {
    fputc ((int) (data & 255), fp);
    fputc ((int) ((data >> 8) & 255), fp);
    fputc ((int) ((data >> 16) & 255), fp);
    fputc ((int) ((data >> 24) & 255), fp);
}

void standard_extension (char *inname, char *outname, char *extension,
			 efunc error) {
    char *p, *q;

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

#define RAA_BLKSIZE 4096	       /* this many longs allocated at once */
#define RAA_LAYERSIZE 1024	       /* this many _pointers_ allocated */

typedef struct RAA RAA;
typedef union RAA_UNION RAA_UNION;
typedef struct RAA_LEAF RAA_LEAF;
typedef struct RAA_BRANCH RAA_BRANCH;

struct RAA {
    int layers;
    long stepsize;
    union RAA_UNION {
	struct RAA_LEAF {
	    long data[RAA_BLKSIZE];
	} l;
	struct RAA_BRANCH {
	    struct RAA *data[RAA_LAYERSIZE];
	} b;
    } u;
};

#define LEAFSIZ (sizeof(RAA)-sizeof(RAA_UNION)+sizeof(RAA_LEAF))
#define BRANCHSIZ (sizeof(RAA)-sizeof(RAA_UNION)+sizeof(RAA_BRANCH))

#define LAYERSIZ(r) ( (r)->layers==0 ? RAA_BLKSIZE : RAA_LAYERSIZE )

static struct RAA *real_raa_init (int layers) {
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
	r->stepsize = 1L;
	while (layers--)
	    r->stepsize *= RAA_LAYERSIZE;
    }
    return r;
}

struct RAA *raa_init (void) {
    return real_raa_init (0);
}

void raa_free (struct RAA *r) {
    if (r->layers == 0)
	nasm_free (r);
    else {
	struct RAA **p;
	for (p = r->u.b.data; p - r->u.b.data < RAA_LAYERSIZE; p++)
	    if (*p)
		raa_free (*p);
    }
}

long raa_read (struct RAA *r, long posn) {
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

struct RAA *raa_write (struct RAA *r, long posn, long value) {
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

struct SAA {
    /*
     * members `end' and `elem_len' are only valid in first link in
     * list; `rptr' and `rpos' are used for reading
     */
    struct SAA *next, *end, *rptr;
    long elem_len, length, posn, start, rpos;
    char *data;
};

struct SAA *saa_init (long elem_len) {
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

void saa_free (struct SAA *s) {
    struct SAA *t;

    while (s) {
	t = s->next;
	nasm_free (s->data);
	nasm_free (s);
	s = t;
    }
}

void *saa_wstruct (struct SAA *s) {
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

void saa_wbytes (struct SAA *s, void *data, long len) {
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

void saa_rewind (struct SAA *s) {
    s->rptr = s;
    s->rpos = 0L;
}

void *saa_rstruct (struct SAA *s) {
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

void *saa_rbytes (struct SAA *s, long *len) {
    void *p;

    if (!s->rptr)
	return NULL;

    p = s->rptr->data + s->rpos;
    *len = s->rptr->posn - s->rpos;
    s->rptr = s->rptr->next;
    s->rpos = 0L;
    return p;
}

void saa_rnbytes (struct SAA *s, void *data, long len) {
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

void saa_fread (struct SAA *s, long posn, void *data, long len) {
    struct SAA *p;
    long pos;
    char *cdata = data;

    if (!s->rptr || posn > s->rptr->start + s->rpos)
	saa_rewind (s);
    while (posn >= s->rptr->start + s->rptr->posn) {
	s->rptr = s->rptr->next;
	if (!s->rptr)
	    return;		       /* what else can we do?! */
    }

    p = s->rptr;
    pos = posn - s->rptr->start;
    while (len) {
	long l = s->rptr->posn - pos;
	if (l > len)
	    l = len;
	memcpy (cdata, s->rptr->data+pos, l);
	len -= l;
	cdata += l;
	p = p->next;
	if (!p)
	    return;
	pos = 0L;
    }
}

void saa_fwrite (struct SAA *s, long posn, void *data, long len) {
    struct SAA *p;
    long pos;
    char *cdata = data;

    if (!s->rptr || posn > s->rptr->start + s->rpos)
	saa_rewind (s);
    while (posn >= s->rptr->start + s->rptr->posn) {
	s->rptr = s->rptr->next;
	if (!s->rptr)
	    return;		       /* what else can we do?! */
    }

    p = s->rptr;
    pos = posn - s->rptr->start;
    while (len) {
	long l = s->rptr->posn - pos;
	if (l > len)
	    l = len;
	memcpy (s->rptr->data+pos, cdata, l);
	len -= l;
	cdata += l;
	p = p->next;
	if (!p)
	    return;
	pos = 0L;
    }
}

void saa_fpwrite (struct SAA *s, FILE *fp) {
    char *data;
    long len;

    saa_rewind (s);
    while ( (data = saa_rbytes (s, &len)) )
	fwrite (data, 1, len, fp);
}
