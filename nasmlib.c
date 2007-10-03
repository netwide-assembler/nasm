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


#define lib_isnumchar(c)   ( isalnum(c) || (c) == '$')
#define numvalue(c)  ((c)>='a' ? (c)-'a'+10 : (c)>='A' ? (c)-'A'+10 : (c)-'0')

int64_t readnum(char *str, int *error)
{
    char *r = str, *q;
    int32_t radix;
    uint64_t result, checklimit;
    int digit, last;
    int warn = FALSE;
    int sign = 1;

    *error = FALSE;

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

    /*
     * If it begins 0x, 0X or $, or ends in H, it's in hex. if it
     * ends in Q, it's octal. if it ends in B, it's binary.
     * Otherwise, it's ordinary decimal.
     */
    if (*r == '0' && (r[1] == 'x' || r[1] == 'X'))
        radix = 16, r += 2;
    else if (*r == '$')
        radix = 16, r++;
    else if (q[-1] == 'H' || q[-1] == 'h')
        radix = 16, q--;
    else if (q[-1] == 'Q' || q[-1] == 'q' || q[-1] == 'O' || q[-1] == 'o')
        radix = 8, q--;
    else if (q[-1] == 'B' || q[-1] == 'b')
        radix = 2, q--;
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
        if (*r < '0' || (*r > '9' && *r < 'A')
            || (digit = numvalue(*r)) >= radix) {
            *error = TRUE;
            return 0;
        }
        if (result > checklimit || (result == checklimit && digit >= last)) {
            warn = TRUE;
        }

        result = radix * result + digit;
        r++;
    }

    if (warn)
        nasm_malloc_error(ERR_WARNING | ERR_PASS1 | ERR_WARN_NOV,
                          "numeric constant %s does not fit in 32 bits",
                          str);

    return result * sign;
}

int64_t readstrnum(char *str, int length, int *warn)
{
    int64_t charconst = 0;
    int i;

    *warn = FALSE;

    str += length;
    if (globalbits == 64) {
        for (i = 0; i < length; i++) {
            if (charconst & 0xFF00000000000000ULL)
                *warn = TRUE;
            charconst = (charconst << 8) + (uint8_t)*--str;
        }
    } else {
        for (i = 0; i < length; i++) {
            if (charconst & 0xFF000000UL)
                *warn = TRUE;
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

#define SAA_MAXLEN 8192

struct SAA *saa_init(int32_t elem_len)
{
    struct SAA *s;

    if (elem_len > SAA_MAXLEN)
        nasm_malloc_error(ERR_PANIC | ERR_NOFILE,
                          "SAA with huge elements");

    s = nasm_malloc(sizeof(struct SAA));
    s->posn = s->start = 0L;
    s->elem_len = elem_len;
    s->length = SAA_MAXLEN - (SAA_MAXLEN % elem_len);
    s->data = nasm_malloc(s->length);
    s->next = NULL;
    s->end = s;

    return s;
}

void saa_free(struct SAA *s)
{
    struct SAA *t;

    while (s) {
        t = s->next;
        nasm_free(s->data);
        nasm_free(s);
        s = t;
    }
}

void *saa_wstruct(struct SAA *s)
{
    void *p;

    if (s->end->length - s->end->posn < s->elem_len) {
        s->end->next = nasm_malloc(sizeof(struct SAA));
        s->end->next->start = s->end->start + s->end->posn;
        s->end = s->end->next;
        s->end->length = s->length;
        s->end->next = NULL;
        s->end->posn = 0L;
        s->end->data = nasm_malloc(s->length);
    }

    p = s->end->data + s->end->posn;
    s->end->posn += s->elem_len;
    return p;
}

void saa_wbytes(struct SAA *s, const void *data, int32_t len)
{
    const char *d = data;

    while (len > 0) {
        int32_t l = s->end->length - s->end->posn;
        if (l > len)
            l = len;
        if (l > 0) {
            if (d) {
                memcpy(s->end->data + s->end->posn, d, l);
                d += l;
            } else
                memset(s->end->data + s->end->posn, 0, l);
            s->end->posn += l;
            len -= l;
        }
        if (len > 0) {
            s->end->next = nasm_malloc(sizeof(struct SAA));
            s->end->next->start = s->end->start + s->end->posn;
            s->end = s->end->next;
            s->end->length = s->length;
            s->end->next = NULL;
            s->end->posn = 0L;
            s->end->data = nasm_malloc(s->length);
        }
    }
}

void saa_rewind(struct SAA *s)
{
    s->rptr = s;
    s->rpos = 0L;
}

void *saa_rstruct(struct SAA *s)
{
    void *p;

    if (!s->rptr)
        return NULL;

    if (s->rptr->posn - s->rpos < s->elem_len) {
        s->rptr = s->rptr->next;
        if (!s->rptr)
            return NULL;        /* end of array */
        s->rpos = 0L;
    }

    p = s->rptr->data + s->rpos;
    s->rpos += s->elem_len;
    return p;
}

void *saa_rbytes(struct SAA *s, int32_t *len)
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

void saa_rnbytes(struct SAA *s, void *data, int32_t len)
{
    char *d = data;

    while (len > 0) {
        int32_t l;

        if (!s->rptr)
            return;

        l = s->rptr->posn - s->rpos;
        if (l > len)
            l = len;
        if (l > 0) {
            memcpy(d, s->rptr->data + s->rpos, l);
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

void saa_fread(struct SAA *s, int32_t posn, void *data, int32_t len)
{
    struct SAA *p;
    int64_t pos;
    char *cdata = data;

    if (!s->rptr || posn < s->rptr->start)
        saa_rewind(s);
    p = s->rptr;
    while (posn >= p->start + p->posn) {
        p = p->next;
        if (!p)
            return;             /* what else can we do?! */
    }

    pos = posn - p->start;
    while (len) {
        int64_t l = p->posn - pos;
        if (l > len)
            l = len;
        memcpy(cdata, p->data + pos, l);
        len -= l;
        cdata += l;
        p = p->next;
        if (!p)
            return;
        pos = 0LL;
    }
    s->rptr = p;
}

void saa_fwrite(struct SAA *s, int32_t posn, void *data, int32_t len)
{
    struct SAA *p;
    int64_t pos;
    char *cdata = data;

    if (!s->rptr || posn < s->rptr->start)
        saa_rewind(s);
    p = s->rptr;
    while (posn >= p->start + p->posn) {
        p = p->next;
        if (!p)
            return;             /* what else can we do?! */
    }

    pos = posn - p->start;
    while (len) {
        int64_t l = p->posn - pos;
        if (l > len)
            l = len;
        memcpy(p->data + pos, cdata, l);
        len -= l;
        cdata += l;
        p = p->next;
        if (!p)
            return;
        pos = 0LL;
    }
    s->rptr = p;
}

void saa_fpwrite(struct SAA *s, FILE * fp)
{
    char *data;
    int32_t len;

    saa_rewind(s);
//    while ((data = saa_rbytes(s, &len)))
    for (; (data = saa_rbytes(s, &len));)
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
