***************
*** 9,15 ****
   * as acknowledgement is given in an appropriate manner to its authors,
   * with instructions of how to obtain a copy via ftp.
   */
- 
  #ifndef _RDOFF_H
  #define _RDOFF_H "RDOFF2 support routines v0.3"
  
--- 9,15 ----
   * as acknowledgement is given in an appropriate manner to its authors,
   * with instructions of how to obtain a copy via ftp.
   */
+  
  #ifndef _RDOFF_H
  #define _RDOFF_H "RDOFF2 support routines v0.3"
  
***************
*** 48,54 ****
  struct ExportRec {
    byte  type;           /* must be 3 */
    byte	reclen;		/* content length */
-   byte  segment;        /* segment referred to (0/1) */
    long  offset;         /* offset within segment */
    char  label[33];      /* zero terminated as above. max len = 32 chars */
  };
--- 48,54 ----
  struct ExportRec {
    byte  type;           /* must be 3 */
    byte	reclen;		/* content length */
+   byte  segment;        /* segment referred to (0/1/2) */
    long  offset;         /* offset within segment */
    char  label[33];      /* zero terminated as above. max len = 32 chars */
  };
***************
*** 65,70 ****
    long amount;		/* number of bytes BSS to reserve */
  };
  
  /* GenericRec - contains the type and length field, plus a 128 byte
     char array 'data', which will probably never be used! */
  
--- 65,92 ----
    long amount;		/* number of bytes BSS to reserve */
  };
  
+ struct ModRec {
+   byte  type;           /* must be 8 */
+   byte	reclen;		/* content length */
+   char  modname[128];   /* module name */
+ };
+ 
+ #ifdef _MULTBOOT_H
+ 
+ #define	RDFLDRMOVER_SIZE 22
+ 
+ struct MultiBootHdrRec {
+   byte  type;           /* must be 9 */
+   byte	reclen;		/* content length */
+ #ifdef __GNUC__  
+   struct tMultiBootHeader mb __attribute__ ((packed));	/* MultiBoot header */
+ #else
+   struct tMultiBootHeader mb;
+ #endif  
+   byte mover[RDFLDRMOVER_SIZE];			/* Mover of RDF loader */
+ };
+ #endif
+ 
  /* GenericRec - contains the type and length field, plus a 128 byte
     char array 'data', which will probably never be used! */
  
***************
*** 82,87 ****
    struct ExportRec e;		/* type == 3 */
    struct DLLRec d;		/* type == 4 */
    struct BSSRec b;		/* type == 5 */
  } rdfheaderrec;
  
  struct SegmentHeaderRec {
--- 104,113 ----
    struct ExportRec e;		/* type == 3 */
    struct DLLRec d;		/* type == 4 */
    struct BSSRec b;		/* type == 5 */
+   struct ModRec m;              /* type == 8 */
+ #ifdef _MULTBOOT_H
+   struct MultiBootHdrRec mbh;	/* type == 9 */
+ #endif  
  } rdfheaderrec;
  
  struct SegmentHeaderRec {
***************
*** 166,170 ****
  int rdfaddsegment(rdf_headerbuf *h, long seglength);
  int rdfwriteheader(FILE *fp,rdf_headerbuf *h);
  void rdfdoneheader(rdf_headerbuf *h);
  
  #endif		/* _RDOFF_H */
--- 192,199 ----
  int rdfaddsegment(rdf_headerbuf *h, long seglength);
  int rdfwriteheader(FILE *fp,rdf_headerbuf *h);
  void rdfdoneheader(rdf_headerbuf *h);
+ 
+ /* This is needed by linker to write multiboot header record */
+ int membuflength(memorybuffer *b);
  
  #endif		/* _RDOFF_H */
