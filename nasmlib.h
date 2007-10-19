/* nasmlib.h	header file for nasmlib.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_NASMLIB_H
#define NASM_NASMLIB_H

#include "compiler.h"

#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

/*
 * If this is defined, the wrappers around malloc et al will
 * transform into logging variants, which will cause NASM to create
 * a file called `malloc.log' when run, and spew details of all its
 * memory management into that. That can then be analysed to detect
 * memory leaks and potentially other problems too.
 */
/* #define LOGALLOC */

/*
 * -------------------------
 * Error reporting functions
 * -------------------------
 */

/*
 * An error reporting function should look like this.
 */
typedef void (*efunc) (int severity, const char *fmt, ...);

/*
 * These are the error severity codes which get passed as the first
 * argument to an efunc.
 */

#define ERR_DEBUG	0x00000008      /* put out debugging message */
#define ERR_WARNING	0x00000000      /* warn only: no further action */
#define ERR_NONFATAL	0x00000001      /* terminate assembly after phase */
#define ERR_FATAL	0x00000002      /* instantly fatal: exit with error */
#define ERR_PANIC	0x00000003      /* internal error: panic instantly
                                         * and dump core for reference */
#define ERR_MASK	0x0000000F      /* mask off the above codes */
#define ERR_NOFILE	0x00000010      /* don't give source file name/line */
#define ERR_USAGE	0x00000020      /* print a usage message */
#define ERR_PASS1	0x00000040      /* only print this error on pass one */

/*
 * These codes define specific types of suppressible warning.
 */

#define ERR_WARN_MASK	0x0000FF00      /* the mask for this feature */
#define ERR_WARN_SHR  8			/* how far to shift right */

#define WARN(x) ((x) << ERR_WARN_SHR)

#define ERR_WARN_MNP		WARN(1) /* macro-num-parameters warning */
#define ERR_WARN_MSR		WARN(2) /* macro self-reference */
#define ERR_WARN_OL		WARN(3)	/* orphan label (no colon, and
                                         * alone on line) */
#define ERR_WARN_NOV		WARN(4)	/* numeric overflow */
#define ERR_WARN_GNUELF		WARN(5)	/* using GNU ELF extensions */
#define ERR_WARN_FL_OVERFLOW	WARN(6) /* FP overflow */
#define ERR_WARN_FL_DENORM	WARN(7) /* FP denormal */
#define ERR_WARN_FL_UNDERFLOW	WARN(8)	/* FP underflow */
#define ERR_WARN_FL_TOOLONG	WARN(9) /* FP too many digits */
#define ERR_WARN_MAX	9		/* the highest numbered one */

/*
 * Wrappers around malloc, realloc and free. nasm_malloc will
 * fatal-error and die rather than return NULL; nasm_realloc will
 * do likewise, and will also guarantee to work right on being
 * passed a NULL pointer; nasm_free will do nothing if it is passed
 * a NULL pointer.
 */
void nasm_set_malloc_error(efunc);
#ifndef LOGALLOC
void *nasm_malloc(size_t);
void *nasm_zalloc(size_t);
void *nasm_realloc(void *, size_t);
void nasm_free(void *);
char *nasm_strdup(const char *);
char *nasm_strndup(char *, size_t);
#else
void *nasm_malloc_log(char *, int, size_t);
void *nasm_zalloc_log(char *, int, size_t);
void *nasm_realloc_log(char *, int, void *, size_t);
void nasm_free_log(char *, int, void *);
char *nasm_strdup_log(char *, int, const char *);
char *nasm_strndup_log(char *, int, char *, size_t);
#define nasm_malloc(x) nasm_malloc_log(__FILE__,__LINE__,x)
#define nasm_zalloc(x) nasm_malloc_log(__FILE__,__LINE__,x)
#define nasm_realloc(x,y) nasm_realloc_log(__FILE__,__LINE__,x,y)
#define nasm_free(x) nasm_free_log(__FILE__,__LINE__,x)
#define nasm_strdup(x) nasm_strdup_log(__FILE__,__LINE__,x)
#define nasm_strndup(x,y) nasm_strndup_log(__FILE__,__LINE__,x,y)
#endif

/*
 * ANSI doesn't guarantee the presence of `stricmp' or
 * `strcasecmp'.
 */
#if defined(HAVE_STRCASECMP)
#define nasm_stricmp strcasecmp
#elif defined(HAVE_STRICMP)
#define nasm_stricmp stricmp
#else
int nasm_stricmp(const char *, const char *);
#endif

#if defined(HAVE_STRNCASECMP)
#define nasm_strnicmp strncasecmp
#elif defined(HAVE_STRNICMP)
#define nasm_strnicmp strnicmp
#else
int nasm_strnicmp(const char *, const char *, int);
#endif

#if defined(HAVE_STRSEP)
#define nasm_strsep strsep
#else
char *nasm_strsep(char **stringp, const char *delim);
#endif


/*
 * Convert a string into a number, using NASM number rules. Sets
 * `*error' to true if an error occurs, and false otherwise.
 */
int64_t readnum(char *str, bool *error);

/*
 * Convert a character constant into a number. Sets
 * `*warn' to true if an overflow occurs, and false otherwise.
 * str points to and length covers the middle of the string,
 * without the quotes.
 */
int64_t readstrnum(char *str, int length, bool *warn);

/*
 * seg_init: Initialise the segment-number allocator.
 * seg_alloc: allocate a hitherto unused segment number.
 */
void seg_init(void);
int32_t seg_alloc(void);

/*
 * many output formats will be able to make use of this: a standard
 * function to add an extension to the name of the input file
 */
#ifdef NASM_NASM_H
void standard_extension(char *inname, char *outname, char *extension,
                        efunc error);
#endif

/*
 * some handy macros that will probably be of use in more than one
 * output format: convert integers into little-endian byte packed
 * format in memory
 */

#define WRITECHAR(p,v) \
  do { \
    *(p)++ = (v) & 0xFF; \
  } while (0)

#define WRITESHORT(p,v) \
  do { \
    WRITECHAR(p,v); \
    WRITECHAR(p,(v) >> 8); \
  } while (0)

#define WRITELONG(p,v) \
  do { \
    WRITECHAR(p,v); \
    WRITECHAR(p,(v) >> 8); \
    WRITECHAR(p,(v) >> 16); \
    WRITECHAR(p,(v) >> 24); \
  } while (0)

#define WRITEDLONG(p,v) \
  do { \
    WRITECHAR(p,v); \
    WRITECHAR(p,(v) >> 8); \
    WRITECHAR(p,(v) >> 16); \
    WRITECHAR(p,(v) >> 24); \
    WRITECHAR(p,(v) >> 32); \
    WRITECHAR(p,(v) >> 40); \
    WRITECHAR(p,(v) >> 48); \
    WRITECHAR(p,(v) >> 56); \
  } while (0)

/*
 * and routines to do the same thing to a file
 */
void fwriteint16_t(int data, FILE * fp);
void fwriteint32_t(int32_t data, FILE * fp);
void fwriteint64_t(int64_t data, FILE * fp);

/*
 * Routines to manage a dynamic random access array of int32_ts which
 * may grow in size to be more than the largest single malloc'able
 * chunk.
 */

#define RAA_BLKSIZE	65536	/* this many longs allocated at once */
#define RAA_LAYERSIZE	32768	/* this many _pointers_ allocated */

typedef struct RAA RAA;
typedef union RAA_UNION RAA_UNION;
typedef struct RAA_LEAF RAA_LEAF;
typedef struct RAA_BRANCH RAA_BRANCH;

struct RAA {
    /*
     * Number of layers below this one to get to the real data. 0
     * means this structure is a leaf, holding RAA_BLKSIZE real
     * data items; 1 and above mean it's a branch, holding
     * RAA_LAYERSIZE pointers to the next level branch or leaf
     * structures.
     */
    int layers;
    /*
     * Number of real data items spanned by one position in the
     * `data' array at this level. This number is 1, trivially, for
     * a leaf (level 0): for a level 1 branch it should be
     * RAA_BLKSIZE, and for a level 2 branch it's
     * RAA_LAYERSIZE*RAA_BLKSIZE.
     */
    int32_t stepsize;
    union RAA_UNION {
        struct RAA_LEAF {
            int32_t data[RAA_BLKSIZE];
        } l;
        struct RAA_BRANCH {
            struct RAA *data[RAA_LAYERSIZE];
        } b;
    } u;
};

struct RAA *raa_init(void);
void raa_free(struct RAA *);
int32_t raa_read(struct RAA *, int32_t);
struct RAA *raa_write(struct RAA *r, int32_t posn, int32_t value);

/*
 * Routines to manage a dynamic sequential-access array, under the
 * same restriction on maximum mallocable block. This array may be
 * written to in two ways: a contiguous chunk can be reserved of a
 * given size with a pointer returned OR single-byte data may be
 * written. The array can also be read back in the same two ways:
 * as a series of big byte-data blocks or as a list of structures
 * of a given size.
 */

struct SAA {
    /*
     * members `end' and `elem_len' are only valid in first link in
     * list; `rptr' and `rpos' are used for reading
     */
    size_t elem_len;		/* Size of each element */
    size_t blk_len;		/* Size of each allocation block */
    size_t nblks;		/* Total number of allocated blocks */
    size_t nblkptrs;		/* Total number of allocation block pointers */
    size_t length;		/* Total allocated length of the array */
    size_t datalen;		/* Total data length of the array */
    char **wblk;		/* Write block pointer */
    size_t wpos;		/* Write position inside block */
    size_t wptr;		/* Absolute write position */
    char **rblk;		/* Read block pointer */
    size_t rpos;		/* Read position inside block */
    size_t rptr;		/* Absolute read position */
    char **blk_ptrs;		/* Pointer to pointer blocks */
};

struct SAA *saa_init(size_t elem_len);    /* 1 == byte */
void saa_free(struct SAA *);
void *saa_wstruct(struct SAA *);        /* return a structure of elem_len */
void saa_wbytes(struct SAA *, const void *, size_t);      /* write arbitrary bytes */
void saa_rewind(struct SAA *);  /* for reading from beginning */
void *saa_rstruct(struct SAA *);        /* return NULL on EOA */
const void *saa_rbytes(struct SAA *, size_t *); /* return 0 on EOA */
void saa_rnbytes(struct SAA *, void *, size_t);   /* read a given no. of bytes */
/* random access */
void saa_fread(struct SAA *, size_t, void *, size_t);
void saa_fwrite(struct SAA *, size_t, const void *, size_t);

/* dump to file */
void saa_fpwrite(struct SAA *, FILE *);

/*
 * Binary search routine. Returns index into `array' of an entry
 * matching `string', or <0 if no match. `array' is taken to
 * contain `size' elements.
 *
 * bsi() is case sensitive, bsii() is case insensitive.
 */
int bsi(char *string, const char **array, int size);
int bsii(char *string, const char **array, int size);

char *src_set_fname(char *newname);
int32_t src_set_linnum(int32_t newline);
int32_t src_get_linnum(void);
/*
 * src_get may be used if you simply want to know the source file and line.
 * It is also used if you maintain private status about the source location
 * It return 0 if the information was the same as the last time you
 * checked, -1 if the name changed and (new-old) if just the line changed.
 */
int src_get(int32_t *xline, char **xname);

void nasm_quote(char **str);
char *nasm_strcat(char *one, char *two);

void null_debug_routine(const char *directive, const char *params);
extern struct dfmt null_debug_form;
extern struct dfmt *null_debug_arr[2];

const char *prefix_name(int);

#endif
