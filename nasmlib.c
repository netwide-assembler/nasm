/* nasmlib.c	library routines for the Netwide Assembler
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
#include "insns.h"

int globalbits = 0;    /* defined in nasm.h, works better here for ASM+DISASM */
efunc nasm_malloc_error;	/* Exported for the benefit of vsnprintf.c */

#ifdef LOGALLOC
static FILE *logfp;
#endif

void nasm_set_malloc_error(efunc error)
{
    nasm_malloc_error = error;
#ifdef LOGALLOC
    logfp = fopen("malloc.log", "w");
    setvbuf(logfp, NULL, _IOLBF, BUFSIZ);
    fprintf(logfp, "null pointer is %p\n", NULL);
#endif
}

#ifdef LOGALLOC
void *nasm_malloc_log(char *file, int line, size_t size)
#else
void *nasm_malloc(size_t size)
#endif
{
    void *p = malloc(size);
    if (!p)
        nasm_malloc_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d malloc(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void *nasm_zalloc_log(char *file, int line, size_t size)
#else
void *nasm_zalloc(size_t size)
#endif
{
    void *p = calloc(size, 1);
    if (!p)
        nasm_malloc_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d calloc(%ld, 1) returns %p\n",
                file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void *nasm_realloc_log(char *file, int line, void *q, size_t size)
#else
void *nasm_realloc(void *q, size_t size)
#endif
{
    void *p = q ? realloc(q, size) : malloc(size);
    if (!p)
        nasm_malloc_error(ERR_FATAL | ERR_NOFILE, "out of memory");
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
void nasm_free_log(char *file, int line, void *q)
#else
void nasm_free(void *q)
#endif
{
    if (q) {
        free(q);
#ifdef LOGALLOC
        fprintf(logfp, "%s %d free(%p)\n", file, line, q);
#endif
    }
}

#ifdef LOGALLOC
char *nasm_strdup_log(char *file, int line, const char *s)
#else
char *nasm_strdup(const char *s)
#endif
{
    char *p;
    int size = strlen(s) + 1;

    p = malloc(size);
    if (!p)
        nasm_malloc_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d strdup(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    strcpy(p, s);
    return p;
}

#ifdef LOGALLOC
char *nasm_strndup_log(char *file, int line, char *s, size_t len)
#else
char *nasm_strndup(char *s, size_t len)
#endif
{
    char *p;
    int size = len + 1;

    p = malloc(size);
    if (!p)
        nasm_malloc_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d strndup(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    strncpy(p, s, len);
    p[len] = '\0';
    return p;
}

#ifndef nasm_stricmp
int nasm_stricmp(const char *s1, const char *s2)
{
    while (*s1 && tolower(*s1) == tolower(*s2))
        s1++, s2++;
    if (!*s1 && !*s2)
        return 0;
    else if (tolower(*s1) < tolower(*s2))
        return -1;
    else
        return 1;
}
#endif

#ifndef nasm_strnicmp
int nasm_strnicmp(const char *s1, const char *s2, int n)
{
    while (n > 0 && *s1 && tolower(*s1) == tolower(*s2))
        s1++, s2++, n--;
    if ((!*s1 && !*s2) || n == 0)
        return 0;
    else if (tolower(*s1) < tolower(*s2))
        return -1;
    else
        return 1;
}
#endif

#ifndef nasm_strsep
char *nasm_strsep(char **stringp, const char *delim)
{
        char *s = *stringp;
        char *e;

        if (!s)
                return NULL;

        e = strpbrk(s, delim);
        if (e)
                *e++ = '\0';

        *stringp = e;
        return s;
}
#endif


#define lib_isnumchar(c)   (isalnum(c) || (c) == '$' || (c) == '_')
#define numvalue(c)  ((c)>='a' ? (c)-'a'+10 : (c)>='A' ? (c)-'A'+10 : (c)-'0')

static int radix_letter(char c)
{
    switch (c) {
    case 'b': case 'B':
    case 'y': case 'Y':
	return 2;		/* Binary */
    case 'o': case 'O':
    case 'q': case 'Q':
	return 8;		/* Octal */
    case 'h': case 'H':
    case 'x': case 'X':
	return 16;		/* Hexadecimal */
    case 'd': case 'D':
    case 't': case 'T':
	return 10;		/* Decimal */
    default:
	return 0;		/* Not a known radix letter */
    }
}

int64_t readnum(char *str, bool *error)
{
    char *r = str, *q;
    int32_t pradix, sradix, radix;
    int plen, slen, len;
    uint64_t result, checklimit;
    int digit, last;
    bool warn = false;
    int sign = 1;

    *error = false;

    while (isspace(*r))
        r++;                    /* find start of number */

    /*
     * If the number came from make_tok_num (as a result of an %assign), it
     * might have a '-' built into it (rather than in a preceeding token).
     */
    if (*r == '-') {
        r++;
        sign = -1;
    }

    q = r;

    while (lib_isnumchar(*q))
        q++;                    /* find end of number */

    len = q-r;
    if (!len) {
	/* Not numeric */
	*error = true;
	return 0;
    }

    /*
     * Handle radix formats:
     *
     * 0<radix-letter><string>
     * $<string>		(hexadecimal)
     * <string><radix-letter>
     */
    pradix = sradix = 0;
    plen = slen = 0;

    if (len > 2 && *r == '0' && (pradix = radix_letter(r[1])) != 0)
	plen = 2;
    else if (len > 1 && *r == '$')
	pradix = 16, plen = 1;

    if (len > 1 && (sradix = radix_letter(q[-1])) != 0)
	slen = 1;

    if (pradix > sradix) {
	radix = pradix;
	r += plen;
    } else if (sradix > pradix) {
	radix = sradix;
	q -= slen;
    } else {
	/* Either decimal, or invalid -- if invalid, we'll trip up
	   further down. */
	radix = 10;
    }

    /*
     * `checklimit' must be 2**(32|64) / radix. We can't do that in
     * 32/64-bit arithmetic, which we're (probably) using, so we
     * cheat: since we know that all radices we use are even, we
     * can divide 2**(31|63) by radix/2 instead.
     */
    if (globalbits == 64)
        checklimit = 0x8000000000000000ULL / (radix >> 1);
    else
        checklimit = 0x80000000UL / (radix >> 1);

    /*
     * Calculate the highest allowable value for the last digit of a
     * 32-bit constant... in radix 10, it is 6, otherwise it is 0
     */
    last = (radix == 10 ? 6 : 0);

    result = 0;
    while (*r && r < q) {
	if (*r != '_') {
	    if (*r < '0' || (*r > '9' && *r < 'A')
		|| (digit = numvalue(*r)) >= radix) {
		*error = true;
		return 0;
	    }
	    if (result > checklimit ||
		(result == checklimit && digit >= last)) {
		warn = true;
	    }

	    result = radix * result + digit;
	}
        r++;
    }

    if (warn)
        nasm_malloc_error(ERR_WARNING | ERR_PASS1 | ERR_WARN_NOV,
                          "numeric constant %s does not fit in 32 bits",
                          str);

    return result * sign;
}

int64_t readstrnum(char *str, int length, bool *warn)
{
    int64_t charconst = 0;
    int i;

    *warn = false;

    str += length;
    if (globalbits == 64) {
        for (i = 0; i < length; i++) {
            if (charconst & 0xFF00000000000000ULL)
                *warn = true;
            charconst = (charconst << 8) + (uint8_t)*--str;
        }
    } else {
        for (i = 0; i < length; i++) {
            if (charconst & 0xFF000000UL)
                *warn = true;
            charconst = (charconst << 8) + (uint8_t)*--str;
        }
    }
    return charconst;
}

static int32_t next_seg;

void seg_init(void)
{
    next_seg = 0;
}

int32_t seg_alloc(void)
{
    return (next_seg += 2) - 2;
}

void fwriteint16_t(int data, FILE * fp)
{
    fputc((int)(data & 255), fp);
    fputc((int)((data >> 8) & 255), fp);
}

void fwriteint32_t(int32_t data, FILE * fp)
{
    fputc((int)(data & 255), fp);
    fputc((int)((data >> 8) & 255), fp);
    fputc((int)((data >> 16) & 255), fp);
    fputc((int)((data >> 24) & 255), fp);
}

void fwriteint64_t(int64_t data, FILE * fp)
{
    fputc((int)(data & 255), fp);
    fputc((int)((data >> 8) & 255), fp);
    fputc((int)((data >> 16) & 255), fp);
    fputc((int)((data >> 24) & 255), fp);
    fputc((int)((data >> 32) & 255), fp);
    fputc((int)((data >> 40) & 255), fp);
    fputc((int)((data >> 48) & 255), fp);
    fputc((int)((data >> 56) & 255), fp);
}

void standard_extension(char *inname, char *outname, char *extension,
                        efunc error)
{
    char *p, *q;

    if (*outname)               /* file name already exists, */
        return;                 /* so do nothing */
    q = inname;
    p = outname;
    while (*q)
        *p++ = *q++;            /* copy, and find end of string */
    *p = '\0';                  /* terminate it */
    while (p > outname && *--p != '.') ;        /* find final period (or whatever) */
    if (*p != '.')
        while (*p)
            p++;                /* go back to end if none found */
    if (!strcmp(p, extension)) {        /* is the extension already there? */
        if (*extension)
            error(ERR_WARNING | ERR_NOFILE,
                  "file name already ends in `%s': "
                  "output will be in `nasm.out'", extension);
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

static struct RAA *real_raa_init(int layers)
{
    struct RAA *r;
    int i;

    if (layers == 0) {
        r = nasm_zalloc(LEAFSIZ);
        r->stepsize = 1L;
    } else {
        r = nasm_malloc(BRANCHSIZ);
        r->layers = layers;
        for (i = 0; i < RAA_LAYERSIZE; i++)
            r->u.b.data[i] = NULL;
        r->stepsize = RAA_BLKSIZE;
        while (--layers)
            r->stepsize *= RAA_LAYERSIZE;
    }
    return r;
}

struct RAA *raa_init(void)
{
    return real_raa_init(0);
}

void raa_free(struct RAA *r)
{
    if (r->layers == 0)
        nasm_free(r);
    else {
        struct RAA **p;
        for (p = r->u.b.data; p - r->u.b.data < RAA_LAYERSIZE; p++)
            if (*p)
                raa_free(*p);
    }
}

int32_t raa_read(struct RAA *r, int32_t posn)
{
    if (posn >= r->stepsize * LAYERSIZ(r))
        return 0;               /* Return 0 for undefined entries */
    while (r->layers > 0) {
        ldiv_t l;
        l = ldiv(posn, r->stepsize);
        r = r->u.b.data[l.quot];
        posn = l.rem;
        if (!r)
            return 0;           /* Return 0 for undefined entries */
    }
    return r->u.l.data[posn];
}

struct RAA *raa_write(struct RAA *r, int32_t posn, int32_t value)
{
    struct RAA *result;

    if (posn < 0)
        nasm_malloc_error(ERR_PANIC, "negative position in raa_write");

    while (r->stepsize * LAYERSIZ(r) <= posn) {
        /*
         * Must add a layer.
         */
        struct RAA *s;
        int i;

        s = nasm_malloc(BRANCHSIZ);
        for (i = 0; i < RAA_LAYERSIZE; i++)
            s->u.b.data[i] = NULL;
        s->layers = r->layers + 1;
        s->stepsize = LAYERSIZ(r) * r->stepsize;
        s->u.b.data[0] = r;
        r = s;
    }

    result = r;

    while (r->layers > 0) {
        ldiv_t l;
        struct RAA **s;
        l = ldiv(posn, r->stepsize);
        s = &r->u.b.data[l.quot];
        if (!*s)
            *s = real_raa_init(r->layers - 1);
        r = *s;
        posn = l.rem;
    }

    r->u.l.data[posn] = value;

    return result;
}

/* Aggregate SAA components smaller than this */
#define SAA_BLKLEN 65536

struct SAA *saa_init(size_t elem_len)
{
    struct SAA *s;
    char *data;

    s = nasm_zalloc(sizeof(struct SAA));

    if (elem_len >= SAA_BLKLEN)
	s->blk_len = elem_len;
    else
	s->blk_len = SAA_BLKLEN - (SAA_BLKLEN % elem_len);

    s->elem_len = elem_len;
    s->length = s->blk_len;
    data = nasm_malloc(s->blk_len);
    s->nblkptrs = s->nblks = 1;
    s->blk_ptrs = nasm_malloc(sizeof(char *));
    s->blk_ptrs[0] = data;
    s->wblk = s->rblk = &s->blk_ptrs[0];

    return s;
}

void saa_free(struct SAA *s)
{
    char **p;
    size_t n;

    for (p = s->blk_ptrs, n = s->nblks; n; p++, n--)
	nasm_free(*p);

    nasm_free(s->blk_ptrs);
    nasm_free(s);
}

/* Add one allocation block to an SAA */
static void saa_extend(struct SAA *s)
{
    size_t blkn = s->nblks++;

    if (blkn >= s->nblkptrs) {
	size_t rindex = s->rblk - s->blk_ptrs;
	size_t windex = s->wblk - s->blk_ptrs;

	s->nblkptrs <<= 1;
	s->blk_ptrs = nasm_realloc(s->blk_ptrs, s->nblkptrs*sizeof(char *));

	s->rblk = s->blk_ptrs + rindex;
	s->wblk = s->blk_ptrs + windex;
    }

    s->blk_ptrs[blkn] = nasm_malloc(s->blk_len);
    s->length += s->blk_len;
}

void *saa_wstruct(struct SAA *s)
{
    void *p;

    if (s->wpos % s->elem_len)
	    nasm_malloc_error(ERR_PANIC|ERR_NOFILE,
			      "misaligned wpos in saa_wstruct");

    if (s->wpos + s->elem_len > s->blk_len) {
	if (s->wpos != s->blk_len)
	    nasm_malloc_error(ERR_PANIC|ERR_NOFILE,
			      "unfilled block in saa_wstruct");

	if (s->wptr + s->elem_len > s->length)
	    saa_extend(s);
	s->wblk++;
	s->wpos = 0;
    }

    p = *s->wblk + s->wpos;
    s->wpos += s->elem_len;
    s->wptr += s->elem_len;

    if (s->wptr > s->datalen)
	s->datalen = s->wptr;

    return p;
}

void saa_wbytes(struct SAA *s, const void *data, size_t len)
{
    const char *d = data;

    while (len) {
        size_t l = s->blk_len - s->wpos;
        if (l > len)
            l = len;
        if (l) {
            if (d) {
                memcpy(*s->wblk + s->wpos, d, l);
                d += l;
            } else
                memset(*s->wblk + s->wpos, 0, l);
            s->wpos += l;
	    s->wptr += l;
            len -= l;

	    if (s->datalen < s->wptr)
		s->datalen = s->wptr;
        }
        if (len) {
	    if (s->wptr >= s->length)
		saa_extend(s);
	    s->wblk++;
	    s->wpos = 0;
	}
    }
}

void saa_rewind(struct SAA *s)
{
    s->rblk = s->blk_ptrs;
    s->rpos = s->rptr = 0;
}

void *saa_rstruct(struct SAA *s)
{
    void *p;

    if (s->rptr + s->elem_len > s->datalen)
	return NULL;

    if (s->rpos % s->elem_len)
	    nasm_malloc_error(ERR_PANIC|ERR_NOFILE,
			      "misaligned rpos in saa_rstruct");

    if (s->rpos + s->elem_len > s->blk_len) {
	s->rblk++;
	s->rpos = 0;
    }

    p = *s->rblk + s->rpos;
    s->rpos += s->elem_len;
    s->rptr += s->elem_len;

    return p;
}

const void *saa_rbytes(struct SAA *s, size_t *lenp)
{
    const void *p;
    size_t len;

    if (s->rptr >= s->datalen) {
	*lenp = 0;
	return NULL;
    }

    if (s->rpos >= s->blk_len) {
	s->rblk++;
	s->rpos = 0;
    }

    len = *lenp;
    if (len > s->datalen - s->rptr)
	len = s->datalen - s->rptr;
    if (len > s->blk_len - s->rpos)
	len = s->blk_len - s->rpos;

    *lenp = len;
    p = *s->rblk + s->rpos;

    s->rpos += len;
    s->rptr += len;

    return p;
}

void saa_rnbytes(struct SAA *s, void *data, size_t len)
{
    char *d = data;

    if (s->rptr + len > s->datalen) {
	nasm_malloc_error(ERR_PANIC|ERR_NOFILE, "overrun in saa_rnbytes");
	return;
    }

    while (len) {
        size_t l;
	const void *p;

	l = len;
	p = saa_rbytes(s, &l);

	memcpy(d, p, l);
	d   += l;
	len -= l;
    }
}

/* Same as saa_rnbytes, except position the counter first */
void saa_fread(struct SAA *s, size_t posn, void *data, size_t len)
{
    size_t ix;

    if (posn+len > s->datalen) {
	nasm_malloc_error(ERR_PANIC|ERR_NOFILE, "overrun in saa_fread");
	return;
    }

    ix = posn / s->blk_len;
    s->rptr = posn;
    s->rpos = posn % s->blk_len;
    s->rblk = &s->blk_ptrs[ix];

    saa_rnbytes(s, data, len);
}

/* Same as saa_wbytes, except position the counter first */
void saa_fwrite(struct SAA *s, size_t posn, const void *data, size_t len)
{
    size_t ix;

    if (posn > s->datalen) {
	/* Seek beyond the end of the existing array not supported */
	nasm_malloc_error(ERR_PANIC|ERR_NOFILE, "overrun in saa_fwrite");
	return;
    }

    ix = posn / s->blk_len;
    s->wptr = posn;
    s->wpos = posn % s->blk_len;
    s->wblk = &s->blk_ptrs[ix];

    if (!s->wpos) {
	s->wpos = s->blk_len;
	s->wblk--;
    }

    saa_wbytes(s, data, len);
}

void saa_fpwrite(struct SAA *s, FILE * fp)
{
    const char *data;
    size_t len;

    saa_rewind(s);
    while (len = s->datalen, (data = saa_rbytes(s, &len)) != NULL)
        fwrite(data, 1, len, fp);
}

/*
 * Common list of prefix names
 */
static const char *prefix_names[] = {
    "a16", "a32", "lock", "o16", "o32", "rep", "repe", "repne",
    "repnz", "repz", "times"
};

const char *prefix_name(int token)
{
    unsigned int prefix = token-PREFIX_ENUM_START;
    if (prefix > sizeof prefix_names / sizeof(const char *))
	return NULL;

    return prefix_names[prefix];
}

/*
 * Binary search.
 */
int bsi(char *string, const char **array, int size)
{
    int i = -1, j = size;       /* always, i < index < j */
    while (j - i >= 2) {
        int k = (i + j) / 2;
        int l = strcmp(string, array[k]);
        if (l < 0)              /* it's in the first half */
            j = k;
        else if (l > 0)         /* it's in the second half */
            i = k;
        else                    /* we've got it :) */
            return k;
    }
    return -1;                  /* we haven't got it :( */
}

int bsii(char *string, const char **array, int size)
{
    int i = -1, j = size;       /* always, i < index < j */
    while (j - i >= 2) {
        int k = (i + j) / 2;
        int l = nasm_stricmp(string, array[k]);
        if (l < 0)              /* it's in the first half */
            j = k;
        else if (l > 0)         /* it's in the second half */
            i = k;
        else                    /* we've got it :) */
            return k;
    }
    return -1;                  /* we haven't got it :( */
}

static char *file_name = NULL;
static int32_t line_number = 0;

char *src_set_fname(char *newname)
{
    char *oldname = file_name;
    file_name = newname;
    return oldname;
}

int32_t src_set_linnum(int32_t newline)
{
    int32_t oldline = line_number;
    line_number = newline;
    return oldline;
}

int32_t src_get_linnum(void)
{
    return line_number;
}

int src_get(int32_t *xline, char **xname)
{
    if (!file_name || !*xname || strcmp(*xname, file_name)) {
        nasm_free(*xname);
        *xname = file_name ? nasm_strdup(file_name) : NULL;
        *xline = line_number;
        return -2;
    }
    if (*xline != line_number) {
        int32_t tmp = line_number - *xline;
        *xline = line_number;
        return tmp;
    }
    return 0;
}

void nasm_quote(char **str)
{
    int ln = strlen(*str);
    char q = (*str)[0];
    char *p;
    if (ln > 1 && (*str)[ln - 1] == q && (q == '"' || q == '\''))
        return;
    q = '"';
    if (strchr(*str, q))
        q = '\'';
    p = nasm_malloc(ln + 3);
    strcpy(p + 1, *str);
    nasm_free(*str);
    p[ln + 1] = p[0] = q;
    p[ln + 2] = 0;
    *str = p;
}

char *nasm_strcat(char *one, char *two)
{
    char *rslt;
    int l1 = strlen(one);
    rslt = nasm_malloc(l1 + strlen(two) + 1);
    strcpy(rslt, one);
    strcpy(rslt + l1, two);
    return rslt;
}

void null_debug_init(struct ofmt *of, void *id, FILE * fp, efunc error)
{
	(void)of;
	(void)id;
	(void)fp;
	(void)error;
}
void null_debug_linenum(const char *filename, int32_t linenumber, int32_t segto)
{
	(void)filename;
	(void)linenumber;
	(void)segto;
}
void null_debug_deflabel(char *name, int32_t segment, int32_t offset,
                         int is_global, char *special)
{
	(void)name;
	(void)segment;
	(void)offset;
	(void)is_global;
	(void)special;
}
void null_debug_routine(const char *directive, const char *params)
{
	(void)directive;
	(void)params;
}
void null_debug_typevalue(int32_t type)
{
	(void)type;
}
void null_debug_output(int type, void *param)
{
	(void)type;
	(void)param;
}
void null_debug_cleanup(void)
{
}

struct dfmt null_debug_form = {
    "Null debug format",
    "null",
    null_debug_init,
    null_debug_linenum,
    null_debug_deflabel,
    null_debug_routine,
    null_debug_typevalue,
    null_debug_output,
    null_debug_cleanup
};

struct dfmt *null_debug_arr[2] = { &null_debug_form, NULL };
