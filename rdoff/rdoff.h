/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 1996-2009 The NASM Authors - All Rights Reserved
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
 * rdoff.h	RDOFF Object File manipulation routines header file
 */

#ifndef RDOFF_RDOFF_H
#define RDOFF_RDOFF_H 1

#include <inttypes.h>

/*
 * RDOFF definitions. They are used by RDOFF utilities and by NASM's
 * 'outrdf2.c' output module.
 */

/* RDOFF format revision (currently used only when printing the version) */
#define RDOFF2_REVISION		"0.6.1"

/* RDOFF2 file signature */
#define RDOFF2_SIGNATURE	"RDOFF2"

/* Maximum size of an import/export label (including trailing zero) */
#define EXIM_LABEL_MAX		256

/* Maximum size of library or module name (including trailing zero) */
#define MODLIB_NAME_MAX		128

/* Maximum number of segments that we can handle in one file */
#define RDF_MAXSEGS		64

/* Record types that may present the RDOFF header */
#define RDFREC_GENERIC		0
#define RDFREC_RELOC		1
#define RDFREC_IMPORT		2
#define RDFREC_GLOBAL		3
#define RDFREC_DLL		4
#define RDFREC_BSS		5
#define RDFREC_SEGRELOC		6
#define RDFREC_FARIMPORT	7
#define RDFREC_MODNAME		8
#define RDFREC_COMMON		10

/*
 * Generic record - contains the type and length field, plus a 128 byte
 * array 'data'
 */
struct GenericRec {
    uint8_t type;
    uint8_t reclen;
    char data[128];
};

/*
 * Relocation record
 */
struct RelocRec {
    uint8_t type;                  /* must be 1 */
    uint8_t reclen;                /* content length */
    uint8_t segment;               /* only 0 for code, or 1 for data supported,
                                   but add 64 for relative refs (ie do not require
                                   reloc @ loadtime, only linkage) */
    int32_t offset;                /* from start of segment in which reference is loc'd */
    uint8_t length;                /* 1 2 or 4 bytes */
    uint16_t refseg;              /* segment to which reference refers to */
};

/*
 * Extern/import record
 */
struct ImportRec {
    uint8_t type;                  /* must be 2 */
    uint8_t reclen;                /* content length */
    uint8_t flags;                 /* SYM_* flags (see below) */
    uint16_t segment;             /* segment number allocated to the label for reloc
                                   records - label is assumed to be at offset zero
                                   in this segment, so linker must fix up with offset
                                   of segment and of offset within segment */
    char label[EXIM_LABEL_MAX]; /* zero terminated, should be written to file
                                   until the zero, but not after it */
};

/*
 * Public/export record
 */
struct ExportRec {
    uint8_t type;                  /* must be 3 */
    uint8_t reclen;                /* content length */
    uint8_t flags;                 /* SYM_* flags (see below) */
    uint8_t segment;               /* segment referred to (0/1/2) */
    int32_t offset;                /* offset within segment */
    char label[EXIM_LABEL_MAX]; /* zero terminated as in import */
};

/*
 * DLL record
 */
struct DLLRec {
    uint8_t type;                  /* must be 4 */
    uint8_t reclen;                /* content length */
    char libname[MODLIB_NAME_MAX];      /* name of library to link with at load time */
};

/*
 * BSS record
 */
struct BSSRec {
    uint8_t type;                  /* must be 5 */
    uint8_t reclen;                /* content length */
    int32_t amount;                /* number of bytes BSS to reserve */
};

/*
 * Module name record
 */
struct ModRec {
    uint8_t type;                  /* must be 8 */
    uint8_t reclen;                /* content length */
    char modname[MODLIB_NAME_MAX];      /* module name */
};

/*
 * Common variable record
 */
struct CommonRec {
    uint8_t type;                  /* must be 10 */
    uint8_t reclen;                /* equals 7+label length */
    uint16_t segment;             /* segment number */
    int32_t size;                  /* size of common variable */
    uint16_t align;               /* alignment (power of two) */
    char label[EXIM_LABEL_MAX]; /* zero terminated as in import */
};

/* Flags for ExportRec */
#define SYM_DATA	1
#define SYM_FUNCTION	2
#define SYM_GLOBAL	4
#define SYM_IMPORT	8

/*** The following part is used only by the utilities *************************/

#ifdef RDOFF_UTILS

/* Some systems don't define this automatically */
#if !defined(strdup)
extern char *strdup(const char *);
#endif

typedef union RDFHeaderRec {
    char type;                  /* invariant throughout all below */
    struct GenericRec g;        /* type 0 */
    struct RelocRec r;          /* type == 1 / 6 */
    struct ImportRec i;         /* type == 2 / 7 */
    struct ExportRec e;         /* type == 3 */
    struct DLLRec d;            /* type == 4 */
    struct BSSRec b;            /* type == 5 */
    struct ModRec m;            /* type == 8 */
    struct CommonRec c;         /* type == 10 */
} rdfheaderrec;

struct SegmentHeaderRec {
    /* information from file */
    uint16_t type;
    uint16_t number;
    uint16_t reserved;
    int32_t length;

    /* information built up here */
    int32_t offset;
    uint8_t *data;                 /* pointer to segment data if it exists in memory */
};

typedef struct RDFFileInfo {
    FILE *fp;                   /* file descriptor; must be open to use this struct */
    int rdoff_ver;              /* should be 1; any higher => not guaranteed to work */
    int32_t header_len;
    int32_t header_ofs;

    uint8_t *header_loc;           /* keep location of header */
    int32_t header_fp;             /* current location within header for reading */

    struct SegmentHeaderRec seg[RDF_MAXSEGS];
    int nsegs;

    int32_t eof_offset;            /* offset of the first uint8_t beyond the end of this
                                   module */

    char *name;                 /* name of module in libraries */
    int *refcount;              /* pointer to reference count on file, or NULL */
} rdffile;

#define BUF_BLOCK_LEN 4088      /* selected to match page size (4096)
                                 * on 80x86 machines for efficiency */
typedef struct memorybuffer {
    int length;
    uint8_t buffer[BUF_BLOCK_LEN];
    struct memorybuffer *next;
} memorybuffer;

typedef struct {
    memorybuffer *buf;          /* buffer containing header records */
    int nsegments;              /* number of segments to be written */
    int32_t seglength;             /* total length of all the segments */
} rdf_headerbuf;

/* segments used by RDOFF, understood by rdoffloadseg */
#define RDOFF_CODE	0
#define RDOFF_DATA	1
#define RDOFF_HEADER	-1
/* mask for 'segment' in relocation records to find if relative relocation */
#define RDOFF_RELATIVEMASK 64
/* mask to find actual segment value in relocation records */
#define RDOFF_SEGMENTMASK 63

extern int rdf_errno;

/* rdf_errno can hold these error codes */
enum {
    /* 0 */ RDF_OK,
    /* 1 */ RDF_ERR_OPEN,
    /* 2 */ RDF_ERR_FORMAT,
    /* 3 */ RDF_ERR_READ,
    /* 4 */ RDF_ERR_UNKNOWN,
    /* 5 */ RDF_ERR_HEADER,
    /* 6 */ RDF_ERR_NOMEM,
    /* 7 */ RDF_ERR_VER,
    /* 8 */ RDF_ERR_RECTYPE,
    /* 9 */ RDF_ERR_RECLEN,
    /* 10 */ RDF_ERR_SEGMENT
};

/* utility functions */
int32_t translateint32_t(int32_t in);
uint16_t translateint16_t(uint16_t in);
char *translatesegmenttype(uint16_t type);

/* RDOFF file manipulation functions */
int rdfopen(rdffile * f, const char *name);
int rdfopenhere(rdffile * f, FILE * fp, int *refcount, const char *name);
int rdfclose(rdffile * f);
int rdffindsegment(rdffile * f, int segno);
int rdfloadseg(rdffile * f, int segment, void *buffer);
rdfheaderrec *rdfgetheaderrec(rdffile * f);     /* returns static storage */
void rdfheaderrewind(rdffile * f);      /* back to start of header */
void rdfperror(const char *app, const char *name);

/* functions to write a new RDOFF header to a file -
   use rdfnewheader to allocate a header, rdfaddheader to add records to it,
   rdfaddsegment to notify the header routines that a segment exists, and
   to tell it how int32_t the segment will be.
   rdfwriteheader to write the file id, object length, and header
   to a file, and then rdfdoneheader to dispose of the header */

rdf_headerbuf *rdfnewheader(void);
int rdfaddheader(rdf_headerbuf * h, rdfheaderrec * r);
int rdfaddsegment(rdf_headerbuf * h, int32_t seglength);
int rdfwriteheader(FILE * fp, rdf_headerbuf * h);
void rdfdoneheader(rdf_headerbuf * h);

#endif                          /* RDOFF_UTILS */

#endif                          /* RDOFF_RDOFF_H */
