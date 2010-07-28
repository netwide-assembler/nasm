/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2010 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *     
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

/*
 * nasmlib.c	library routines for the Netwide Assembler
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
static vefunc nasm_verror;	/* Global error handling function */

#ifdef LOGALLOC
static FILE *logfp;
#endif

/* Uninitialized -> all zero by C spec */
const uint8_t zero_buffer[ZERO_BUF_SIZE];

/*
 * Prepare a table of tolower() results.  This avoids function calls
 * on some platforms.
 */

unsigned char nasm_tolower_tab[256];

void tolower_init(void)
{
    int i;

    for (i = 0; i < 256; i++)
	nasm_tolower_tab[i] = tolower(i);
}

void nasm_set_verror(vefunc ve)
{
    nasm_verror = ve;
}

void nasm_error(int severity, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    nasm_verror(severity, fmt, ap);
    va_end(ap);
}

void nasm_init_malloc_error(void)
{
#ifdef LOGALLOC
    logfp = fopen("malloc.log", "w");
    if (logfp) {
        setvbuf(logfp, NULL, _IOLBF, BUFSIZ);
    } else {
        nasm_error(ERR_NONFATAL | ERR_NOFILE, "Unable to open %s", logfp);
        logfp = stderr;
    }
    fprintf(logfp, "null pointer is %p\n", NULL);
#endif
}

#ifdef LOGALLOC
void *nasm_malloc_log(const char *file, int line, size_t size)
#else
void *nasm_malloc(size_t size)
#endif
{
    void *p = malloc(size);
    if (!p)
        nasm_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d malloc(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void *nasm_zalloc_log(const char *file, int line, size_t size)
#else
void *nasm_zalloc(size_t size)
#endif
{
    void *p = calloc(size, 1);
    if (!p)
        nasm_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d calloc(%ld, 1) returns %p\n",
                file, line, (long)size, p);
#endif
    return p;
}

#ifdef LOGALLOC
void *nasm_realloc_log(const char *file, int line, void *q, size_t size)
#else
void *nasm_realloc(void *q, size_t size)
#endif
{
    void *p = q ? realloc(q, size) : malloc(size);
    if (!p)
        nasm_error(ERR_FATAL | ERR_NOFILE, "out of memory");
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
void nasm_free_log(const char *file, int line, void *q)
#else
void nasm_free(void *q)
#endif
{
    if (q) {
#ifdef LOGALLOC
        fprintf(logfp, "%s %d free(%p)\n", file, line, q);
#endif
        free(q);
    }
}

#ifdef LOGALLOC
char *nasm_strdup_log(const char *file, int line, const char *s)
#else
char *nasm_strdup(const char *s)
#endif
{
    char *p;
    int size = strlen(s) + 1;

    p = malloc(size);
    if (!p)
        nasm_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d strdup(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    strcpy(p, s);
    return p;
}

#ifdef LOGALLOC
char *nasm_strndup_log(const char *file, int line, const char *s, size_t len)
#else
char *nasm_strndup(const char *s, size_t len)
#endif
{
    char *p;
    int size = len + 1;

    p = malloc(size);
    if (!p)
        nasm_error(ERR_FATAL | ERR_NOFILE, "out of memory");
#ifdef LOGALLOC
    else
        fprintf(logfp, "%s %d strndup(%ld) returns %p\n",
                file, line, (long)size, p);
#endif
    strncpy(p, s, len);
    p[len] = '\0';
    return p;
}

no_return nasm_assert_failed(const char *file, int line, const char *msg)
{
    nasm_error(ERR_FATAL, "assertion %s failed at %s:%d", msg, file, line);
    exit(1);
}

#ifndef nasm_stricmp
int nasm_stricmp(const char *s1, const char *s2)
{
    unsigned char c1, c2;
    int d;

    while (1) {
	c1 = nasm_tolower(*s1++);
	c2 = nasm_tolower(*s2++);
	d = c1-c2;

	if (d)
	    return d;
	if (!c1)
	    break;
    }
    return 0;
}
#endif

#ifndef nasm_strnicmp
int nasm_strnicmp(const char *s1, const char *s2, size_t n)
{
    unsigned char c1, c2;
    int d;

    while (n--) {
	c1 = nasm_tolower(*s1++);
	c2 = nasm_tolower(*s2++);
	d = c1-c2;

	if (d)
	    return d;
	if (!c1)
	    break;
    }
    return 0;
}
#endif

int nasm_memicmp(const char *s1, const char *s2, size_t n)
{
    unsigned char c1, c2;
    int d;

    while (n--) {
	c1 = nasm_tolower(*s1++);
	c2 = nasm_tolower(*s2++);
	d = c1-c2;
	if (d)
	    return d;
    }
    return 0;
}

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


#define lib_isnumchar(c)   (nasm_isalnum(c) || (c) == '$' || (c) == '_')
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

    while (nasm_isspace(*r))
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
     * `checklimit' must be 2**64 / radix. We can't do that in
     * 64-bit arithmetic, which we're (probably) using, so we
     * cheat: since we know that all radices we use are even, we
     * can divide 2**63 by radix/2 instead.
     */
    checklimit = UINT64_C(0x8000000000000000) / (radix >> 1);

    /*
     * Calculate the highest allowable value for the last digit of a
     * 64-bit constant... in radix 10, it is 6, otherwise it is 0
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
        nasm_error(ERR_WARNING | ERR_PASS1 | ERR_WARN_NOV,
		   "numeric constant %s does not fit in 64 bits",
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
            if (charconst & UINT64_C(0xFF00000000000000))
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

#ifdef WORDS_LITTLEENDIAN

void fwriteint16_t(uint16_t data, FILE * fp)
{
    fwrite(&data, 1, 2, fp);
}

void fwriteint32_t(uint32_t data, FILE * fp)
{
    fwrite(&data, 1, 4, fp);
}

void fwriteint64_t(uint64_t data, FILE * fp)
{
    fwrite(&data, 1, 8, fp);
}

void fwriteaddr(uint64_t data, int size, FILE * fp)
{
    fwrite(&data, 1, size, fp);
}

#else /* not WORDS_LITTLEENDIAN */

void fwriteint16_t(uint16_t data, FILE * fp)
{
    char buffer[2], *p = buffer;
    WRITESHORT(p, data);
    fwrite(buffer, 1, 2, fp);
}

void fwriteint32_t(uint32_t data, FILE * fp)
{
    char buffer[4], *p = buffer;
    WRITELONG(p, data);
    fwrite(buffer, 1, 4, fp);
}

void fwriteint64_t(uint64_t data, FILE * fp)
{
    char buffer[8], *p = buffer;
    WRITEDLONG(p, data);
    fwrite(buffer, 1, 8, fp);
}

void fwriteaddr(uint64_t data, int size, FILE * fp)
{
    char buffer[8], *p = buffer;
    WRITEADDR(p, data, size);
    fwrite(buffer, 1, size, fp);
}

#endif

size_t fwritezero(size_t bytes, FILE *fp)
{
    size_t count = 0;
    size_t blksize;
    size_t rv;

    while (bytes) {
	blksize = (bytes < ZERO_BUF_SIZE) ? bytes : ZERO_BUF_SIZE;

	rv = fwrite(zero_buffer, 1, blksize, fp);
	if (!rv)
	    break;

	count += rv;
	bytes -= rv;
    }

    return count;
}

void standard_extension(char *inname, char *outname, char *extension)
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
            nasm_error(ERR_WARNING | ERR_NOFILE,
		       "file name already ends in `%s': "
		       "output will be in `nasm.out'", extension);
        else
            nasm_error(ERR_WARNING | ERR_NOFILE,
		       "file name already has no extension: "
		       "output will be in `nasm.out'");
        strcpy(outname, "nasm.out");
    } else
        strcpy(p, extension);
}

/*
 * Common list of prefix names
 */
static const char *prefix_names[] = {
    "a16", "a32", "a64", "asp", "lock", "o16", "o32", "o64", "osp",
    "rep", "repe", "repne", "repnz", "repz", "times", "wait"
};

const char *prefix_name(int token)
{
    unsigned int prefix = token-PREFIX_ENUM_START;
    if (prefix >= ARRAY_SIZE(prefix_names))
	return NULL;

    return prefix_names[prefix];
}

/*
 * Binary search.
 */
int bsi(const char *string, const char **array, int size)
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

int bsii(const char *string, const char **array, int size)
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

char *nasm_strcat(const char *one, const char *two)
{
    char *rslt;
    int l1 = strlen(one);
    rslt = nasm_malloc(l1 + strlen(two) + 1);
    strcpy(rslt, one);
    strcpy(rslt + l1, two);
    return rslt;
}

/* skip leading spaces */
char *nasm_skip_spaces(const char *p)
{
    if (p)
        while (*p && nasm_isspace(*p))
            p++;
    return (char *)p;
}

/* skip leading non-spaces */
char *nasm_skip_word(const char *p)
{
    if (p)
        while (*p && !nasm_isspace(*p))
            p++;
    return (char *)p;
}

/* zap leading spaces with zero */
char *nasm_zap_spaces_fwd(char *p)
{
    if (p)
        while (*p && nasm_isspace(*p))
            *p++ = 0x0;
    return p;
}

/* zap spaces with zero in reverse order */
char *nasm_zap_spaces_rev(char *p)
{
    if (p)
        while (*p && nasm_isspace(*p))
            *p-- = 0x0;
    return p;
}

/* zap leading and trailing spaces */
char *nasm_trim_spaces(char *p)
{
    p = nasm_zap_spaces_fwd(p);
    nasm_zap_spaces_fwd(nasm_skip_word(p));

    return p;
}

/*
 * return the word extracted from a stream
 * or NULL if nothing left
 */
char *nasm_get_word(char *p, char **tail)
{
    char *word = nasm_skip_spaces(p);
    char *next = nasm_skip_word(word);

    if (word && *word) {
        if (*next)
            *next++ = '\0';
    } else
        word = next = NULL;

    /* NOTE: the tail may start with spaces */
    *tail = next;

    return word;
}

/*
 * Extract "opt=val" values from the stream and
 * returns "opt"
 *
 * Exceptions:
 * 1) If "=val" passed the NULL returned though
 *    you may continue handling the tail via "next"
 * 2) If "=" passed the NULL is returned and "val"
 *    is set to NULL as well
 */
char *nasm_opt_val(char *p, char **val, char **next)
{
    char *q, *opt, *nxt;

    opt = *val = *next = NULL;

    p = nasm_get_word(p, &nxt);
    if (!p)
        return NULL;

    q = strchr(p, '=');
    if (q) {
        if (q == p)
            p = NULL;
        *q++='\0';
        if (*q) {
            *val = q;
        } else {
            q = nasm_get_word(q + 1, &nxt);
            if (q)
                *val = q;
        }
    } else {
        q = nasm_skip_spaces(nxt);
        if (q && *q == '=') {
            q = nasm_get_word(q + 1, &nxt);
            if (q)
                *val = q;
        }
    }

    *next = nxt;
    return p;
}

/*
 * initialized data bytes length from opcode
 */
int idata_bytes(int opcode)
{
    int ret;
    switch (opcode) {
    case I_DB:
        ret = 1;
        break;
    case I_DW:
        ret = 2;
        break;
    case I_DD:
        ret = 4;
        break;
    case I_DQ:
        ret = 8;
        break;
    case I_DT:
        ret = 10;
        break;
    case I_DO:
        ret = 16;
        break;
    case I_DY:
        ret = 32;
        break;
    case I_none:
        ret = -1;
        break;
    default:
        ret = 0;
        break;
    }
    return ret;
}
