/* nasmlib.h	header file for nasmlib.c
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef NASM_NASMLIB_H
#define NASM_NASMLIB_H

/*
 * If this is defined, the wrappers around malloc et al will
 * transform into logging variants, which will cause NASM to create
 * a file called `malloc.log' when run, and spew details of all its
 * memory management into that. That can then be analysed to detect
 * memory leaks and potentially other problems too.
 */
/* #define LOGALLOC */

/*
 * Wrappers around malloc, realloc and free. nasm_malloc will
 * fatal-error and die rather than return NULL; nasm_realloc will
 * do likewise, and will also guarantee to work right on being
 * passed a NULL pointer; nasm_free will do nothing if it is passed
 * a NULL pointer.
 */
#ifdef NASM_NASM_H		       /* need efunc defined for this */
void nasm_set_malloc_error (efunc);
#ifndef LOGALLOC
void *nasm_malloc (size_t);
void *nasm_realloc (void *, size_t);
void nasm_free (void *);
char *nasm_strdup (char *);
char *nasm_strndup (char *, size_t);
#else
void *nasm_malloc_log (char *, int, size_t);
void *nasm_realloc_log (char *, int, void *, size_t);
void nasm_free_log (char *, int, void *);
char *nasm_strdup_log (char *, int, char *);
char *nasm_strndup_log (char *, int, char *, size_t);
#define nasm_malloc(x) nasm_malloc_log(__FILE__,__LINE__,x)
#define nasm_realloc(x,y) nasm_realloc_log(__FILE__,__LINE__,x,y)
#define nasm_free(x) nasm_free_log(__FILE__,__LINE__,x)
#define nasm_strdup(x) nasm_strdup_log(__FILE__,__LINE__,x)
#define nasm_strndup(x,y) nasm_strndup_log(__FILE__,__LINE__,x,y)
#endif
#endif

/*
 * ANSI doesn't guarantee the presence of `stricmp' or
 * `strcasecmp'.
 */
int nasm_stricmp (const char *, const char *);
int nasm_strnicmp (const char *, const char *, int);

/*
 * Convert a string into a number, using NASM number rules. Sets
 * `*error' to TRUE if an error occurs, and FALSE otherwise.
 */
long readnum(char *str, int *error);

/*
 * Convert a character constant into a number. Sets
 * `*warn' to TRUE if an overflow occurs, and FALSE otherwise.
 * str points to and length covers the middle of the string,
 * without the quotes.
 */
long readstrnum(char *str, int length, int *warn);

/*
 * seg_init: Initialise the segment-number allocator.
 * seg_alloc: allocate a hitherto unused segment number.
 */
void seg_init(void);
long seg_alloc(void);

/*
 * many output formats will be able to make use of this: a standard
 * function to add an extension to the name of the input file
 */
#ifdef NASM_NASM_H
void standard_extension (char *inname, char *outname, char *extension,
			 efunc error);
#endif

/*
 * some handy macros that will probably be of use in more than one
 * output format: convert integers into little-endian byte packed
 * format in memory
 */

#define WRITELONG(p,v) \
  do { \
    *(p)++ = (v) & 0xFF; \
    *(p)++ = ((v) >> 8) & 0xFF; \
    *(p)++ = ((v) >> 16) & 0xFF; \
    *(p)++ = ((v) >> 24) & 0xFF; \
  } while (0)

#define WRITESHORT(p,v) \
  do { \
    *(p)++ = (v) & 0xFF; \
    *(p)++ = ((v) >> 8) & 0xFF; \
  } while (0)

/*
 * and routines to do the same thing to a file
 */
void fwriteshort (int data, FILE *fp);
void fwritelong (long data, FILE *fp);

/*
 * Routines to manage a dynamic random access array of longs which
 * may grow in size to be more than the largest single malloc'able
 * chunk.
 */

#define RAA_BLKSIZE 4096	       /* this many longs allocated at once */
#define RAA_LAYERSIZE 1024	       /* this many _pointers_ allocated */

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


struct RAA *raa_init (void);
void raa_free (struct RAA *);
long raa_read (struct RAA *, long);
struct RAA *raa_write (struct RAA *r, long posn, long value);

/*
 * Routines to manage a dynamic sequential-access array, under the
 * same restriction on maximum mallocable block. This array may be
 * written to in two ways: a contiguous chunk can be reserved of a
 * given size, and a pointer returned, or single-byte data may be
 * written. The array can also be read back in the same two ways:
 * as a series of big byte-data blocks or as a list of structures
 * of a given size.
 */

struct SAA {
    /*
     * members `end' and `elem_len' are only valid in first link in
     * list; `rptr' and `rpos' are used for reading
     */
    struct SAA *next, *end, *rptr;
    long elem_len, length, posn, start, rpos;
    char *data;
};

struct SAA *saa_init (long elem_len);  /* 1 == byte */
void saa_free (struct SAA *);
void *saa_wstruct (struct SAA *);      /* return a structure of elem_len */
void saa_wbytes (struct SAA *, void *, long);  /* write arbitrary bytes */
void saa_rewind (struct SAA *);	       /* for reading from beginning */
void *saa_rstruct (struct SAA *);      /* return NULL on EOA */
void *saa_rbytes (struct SAA *, long *);   /* return 0 on EOA */
void saa_rnbytes (struct SAA *, void *, long); /* read a given no. of bytes */
void saa_fread (struct SAA *s, long posn, void *p, long len);   /* fixup */
void saa_fwrite (struct SAA *s, long posn, void *p, long len);   /* fixup */
void saa_fpwrite (struct SAA *, FILE *);

#ifdef NASM_NASM_H
/*
 * Standard scanner.
 */
extern char *stdscan_bufptr;
void stdscan_reset(void);
int stdscan (void *private_data, struct tokenval *tv);
#endif

#ifdef NASM_NASM_H
/*
 * Library routines to manipulate expression data types.
 */
int is_reloc(expr *);
int is_simple(expr *);
int is_really_simple (expr *);
int is_unknown(expr *);
int is_just_unknown(expr *);
long reloc_value(expr *);
long reloc_seg(expr *);
long reloc_wrt(expr *);
#endif

/*
 * Binary search routine. Returns index into `array' of an entry
 * matching `string', or <0 if no match. `array' is taken to
 * contain `size' elements.
 */
int bsi (char *string, char **array, int size);


char *src_set_fname(char *newname);
long src_set_linnum(long newline);
long src_get_linnum(void);
/*
 * src_get may be used if you simply want to know the source file and line.
 * It is also used if you maintain private status about the source location
 * It return 0 if the information was the same as the last time you
 * checked, -1 if the name changed and (new-old) if just the line changed.
 */
int src_get(long *xline, char **xname);

void nasm_quote(char **str);
char *nasm_strcat(char *one, char *two);
void nasmlib_cleanup(void);

void null_debug_routine();
extern struct dfmt null_debug_form;
extern struct dfmt *null_debug_arr[2];
#endif
