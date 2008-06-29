/* nasmlib.c	library routines for the Netwide Assembler
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the license given in the file "LICENSE"
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
#ifdef LOGALLOC
        fprintf(logfp, "%s %d free(%p)\n", file, line, q);
#endif
        free(q);
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
    checklimit = 0x8000000000000000ULL / (radix >> 1);

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
        nasm_malloc_error(ERR_WARNING | ERR_PASS1 | ERR_WARN_NOV,
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
    if (prefix > elements(prefix_names))
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
void null_debug_deflabel(char *name, int32_t segment, int64_t offset,
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
