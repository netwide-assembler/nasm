/* rdoff.h	RDOFF Object File manipulation routines header file
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

#ifndef _RDOFF_H
#define _RDOFF_H "RDOFF1 support routines v0.1"

typedef short int16;    /* not sure if this will be required to be altered
                           at all... best to typedef it just in case */

/* the records that can be found in the RDOFF header */

struct RelocRec {
  char  type;           /* must be 1 */
  char  segment;        /* only 0 for code, or 1 for data supported,
			   but add 64 for relative refs (ie do not require
			   reloc @ loadtime, only linkage) */
  long  offset;         /* from start of segment in which reference is loc'd */
  char  length;         /* 1 2 or 4 bytes */
  int16 refseg;         /* segment to which reference refers to */
};

struct ImportRec {
  char  type;           /* must be 2 */
  int16 segment;        /* segment number allocated to the label for reloc
                           records - label is assumed to be at offset zero
                           in this segment, so linker must fix up with offset
                           of segment and of offset within segment */
  char  label[33];      /* zero terminated... should be written to file until
                           the zero, but not after it - max len = 32 chars */
};

struct ExportRec {
  char  type;           /* must be 3 */
  char  segment;        /* segment referred to (0/1) */
  long  offset;         /* offset within segment */
  char  label[33];      /* zero terminated as above. max len = 32 chars */
};

struct DLLRec {
  char  type;           /* must be 4 */
  char  libname[128];   /* name of library to link with at load time */
};

struct BSSRec {
  char type;		/* must be 5 */
  long amount;		/* number of bytes BSS to reserve */
};
  
typedef union RDFHeaderRec {
  char type;			/* invariant throughout all below */
  struct RelocRec r;		/* type == 1 */
  struct ImportRec i;		/* type == 2 */
  struct ExportRec e;		/* type == 3 */
  struct DLLRec d;		/* type == 4 */
  struct BSSRec b;		/* type == 5 */
} rdfheaderrec;

typedef struct RDFFileInfo {
  FILE *fp;		/* file descriptor; must be open to use this struct */
  int rdoff_ver;	/* should be 1; any higher => not guaranteed to work */
  long header_len;
  long code_len;
  long data_len;
  long header_ofs; 
  long code_ofs;
  long data_ofs;
  char *header_loc;	/* keep location of header */
  long header_fp;	/* current location within header for reading */
  char *name;		/* name of module in libraries */
  int  *refcount;       /* pointer to reference count on file, or NULL */
} rdffile;

#define BUF_BLOCK_LEN 4088              /* selected to match page size (4096)
                                         * on 80x86 machines for efficiency */
typedef struct memorybuffer {
  int length;
  char buffer[BUF_BLOCK_LEN];
  struct memorybuffer *next;
} memorybuffer;

typedef memorybuffer rdf_headerbuf;

/* segments used by RDOFF, understood by rdoffloadseg */
#define RDOFF_CODE 0
#define RDOFF_DATA 1
#define RDOFF_HEADER -1
/* mask for 'segment' in relocation records to find if relative relocation */
#define RDOFF_RELATIVEMASK 64
/* mask to find actual segment value in relocation records */
#define RDOFF_SEGMENTMASK 63

extern int rdf_errno;

/* RDOFF file manipulation functions */
int rdfopen(rdffile *f,const char *name);
int rdfopenhere(rdffile *f, FILE *fp, int *refcount, char *name);
int rdfclose(rdffile *f);
int rdfloadseg(rdffile *f,int segment,void *buffer);
rdfheaderrec *rdfgetheaderrec(rdffile *f);   /* returns static storage */
void rdfheaderrewind(rdffile *f);	     /* back to start of header */
void rdfperror(const char *app,const char *name);

/* functions to write a new RDOFF header to a file -
   use rdfnewheader to allocate a header, rdfaddheader to add records to it,
   rdfwriteheader to write 'RDOFF1', length of header, and the header itself
   to a file, and then rdfdoneheader to dispose of the header */

rdf_headerbuf *rdfnewheader(void);
int rdfaddheader(rdf_headerbuf *h,rdfheaderrec *r);
int rdfwriteheader(FILE *fp,rdf_headerbuf *h);
void rdfdoneheader(rdf_headerbuf *h);

#endif		/* _RDOFF_H */
