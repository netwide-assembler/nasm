/* rdoff.c   	library of routines for manipulating rdoff files
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 *
 * Permission to use this file in your own projects is granted, as long
 * as acknowledgement is given in an appropriate manner to its authors,
 * with instructions of how to obtain a copy via ftp.
 */

/* TODO:	The functions in this module assume they are running
 *		on a little-endian machine. This should be fixed to
 *		make it portable.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "rdoff.h"

#define newstr(str) strcpy(malloc(strlen(str) + 1),str)
#define newstrcat(s1,s2) strcat(strcpy(malloc(strlen(s1) + strlen(s2) + 1), \
                                       s1),s2)

/*
 * Comment this out to allow the module to read & write header record types
 * that it isn't aware of. With this defined, unrecognised header records
 * will generate error number 8, reported as 'unknown extended header record'.
 */

#define STRICT_ERRORS

/* ========================================================================
 * Code for memory buffers (for delayed writing of header until we know
 * how long it is).
 * ======================================================================== */


memorybuffer * newmembuf()
{
    memorybuffer * t;

    t = malloc(sizeof(memorybuffer));
    if (!t) return NULL;

    t->length = 0;
    t->next = NULL;
    return t;
}

void membufwrite(memorybuffer *const b, void *data, int bytes)
{
    int16 w;
    long l;

    if (b->next) {        /* memory buffer full - use next buffer */
	membufwrite(b->next,data,bytes);
	return;
    }

    if ((bytes < 0 && b->length - bytes > BUF_BLOCK_LEN)
	|| (bytes > 0 && b->length + bytes > BUF_BLOCK_LEN)) 
    {
    
	/* buffer full and no next allocated... allocate and initialise next
	 * buffer */
	b->next = newmembuf();
	membufwrite(b->next,data,bytes);
	return;
    }

    switch(bytes) {
    case -4:              /* convert to little-endian */
	l = * (long *) data ;
	b->buffer[b->length++] = l & 0xFF;
	l >>= 8 ;
	b->buffer[b->length++] = l & 0xFF;
	l >>= 8 ;
	b->buffer[b->length++] = l & 0xFF;
	l >>= 8 ;
	b->buffer[b->length++] = l & 0xFF;
	break;

    case -2:
	w = * (int16 *) data ;
	b->buffer[b->length++] = w & 0xFF;
	w >>= 8 ;
	b->buffer[b->length++] = w & 0xFF;
	break;

    default:
	while(bytes--) {
	    b->buffer[b->length++] = *(* (unsigned char **) &data);
	    
	    (* (unsigned char **) &data)++ ;
	}
	break;
    }
}

void membufdump(memorybuffer *b,FILE *fp)
{
    if (!b) return;

    fwrite (b->buffer, 1, b->length, fp);
  
    membufdump(b->next,fp);
}

int membuflength(memorybuffer *b)
{
    if (!b) return 0;
    return b->length + membuflength(b->next);
}

void freemembuf(memorybuffer *b)
{
    if (!b) return;
    freemembuf(b->next);
    free(b);
}

/* =========================================================================
   General purpose routines and variables used by the library functions
   ========================================================================= */

/* 
 * translatelong() and translateshort()
 *
 * translate from little endian to local representation 
 */
long translatelong(long in) 
{
    long r;
    unsigned char *i;

    i = (unsigned char *)&in;
    r = i[3];
    r = (r << 8) + i[2];
    r = (r << 8) + i[1];
    r = (r << 8) + *i;

    return r;
}

int16 translateshort(int16 in) 
{
    int16 r;
    unsigned char * i;
    
    i = (unsigned char *)&in;
    r = (i[1] << 8) + i[0];

    return r;
}

const char *RDOFFId = "RDOFF2"; /* written to the start of RDOFF files */

const char *rdf_errors[11] = {
  "no error occurred","could not open file","invalid file format",
  "error reading file","unknown error","header not read",
  "out of memory", "RDOFF v1 not supported",
  "unknown extended header record", 
  "header record of known type but unknown length",
  "no such segment"};

int rdf_errno = 0;

/* ========================================================================
   The library functions
   ======================================================================== */

int rdfopen(rdffile *f, const char *name)
{
    FILE * fp;

    fp = fopen(name,"rb");
    if (!fp) return rdf_errno = 1;		/* error 1: file open error */

    return rdfopenhere(f,fp,NULL,name);
}

int rdfopenhere(rdffile *f, FILE *fp, int *refcount, const char *name)
{
  char buf[8];
  long initpos;
  long l;
  int16 s;

  if (translatelong(0x01020304) != 0x01020304)
  {					/* fix this to be portable! */
    fputs("*** this program requires a little endian machine\n",stderr);
    fprintf(stderr,"01020304h = %08lxh\n",translatelong(0x01020304));
    exit(3);
  }

  f->fp = fp;
  initpos = ftell(fp);

  fread(buf,6,1,f->fp);		/* read header */
  buf[6] = 0;

  if (strcmp(buf,RDOFFId)) {
    fclose(f->fp);
    if (!strcmp(buf,"RDOFF1"))
	return rdf_errno = 7;	/* error 7: RDOFF 1 not supported */
    return rdf_errno = 2; 	/* error 2: invalid file format */
  }

  if (fread(&l,1,4,f->fp) != 4 ||
      fread(&f->header_len,1,4,f->fp) != 4) {
    fclose(f->fp);
    return rdf_errno = 3;	/* error 3: file read error */
  }

  f->header_ofs = ftell(f->fp);
  f->eof_offset = f->header_ofs + translatelong(l) - 4;

  if (fseek(f->fp,f->header_len,SEEK_CUR)) {
    fclose(f->fp);
    return rdf_errno = 2;	/* seek past end of file...? */
  }

  if (fread(&s,1,2,f->fp) != 2) {
      fclose(f->fp);
      return rdf_errno = 3;
  }

  f->nsegs = 0;

  while (s != 0)
  {
      f->seg[f->nsegs].type = s;
      if (fread(&f->seg[f->nsegs].number,1,2,f->fp) != 2 ||
	  fread(&f->seg[f->nsegs].reserved,1,2,f->fp) != 2 ||
	  fread(&f->seg[f->nsegs].length,1,4,f->fp) != 4)
      {
	  fclose(f->fp);
	  return rdf_errno = 3;
      }

      f->seg[f->nsegs].offset = ftell(f->fp);
      if (fseek(f->fp,f->seg[f->nsegs].length,SEEK_CUR)) {
	  fclose(f->fp);
	  return rdf_errno = 2;
      }
      f->nsegs++;

      if (fread(&s,1,2,f->fp) != 2) {
	  fclose(f->fp);
	  return rdf_errno = 3;
      }
  }

  if (f->eof_offset != ftell(f->fp) + 8)  /* +8 = skip null segment header */
  {
      fprintf(stderr, "warning: eof_offset [%ld] and actual eof offset "
	      "[%ld] don't match\n", f->eof_offset, ftell(f->fp) + 8);
  }
  fseek(f->fp,initpos,SEEK_SET);
  f->header_loc = NULL;

  f->name = newstr(name);
  f->refcount = refcount;
  if (refcount) (*refcount)++;
  return 0;
}

int rdfclose(rdffile *f)
{
    if (! f->refcount || ! --(*f->refcount))
     {
      fclose(f->fp);
      f->fp = NULL;
     }
    free(f->name);

    return 0;
}

void rdfperror(const char *app,const char *name)
{
  fprintf(stderr,"%s:%s: %s\n",app,name,rdf_errors[rdf_errno]);
  if (rdf_errno == 1 || rdf_errno == 3)
  {
      perror(app);
  }

}

int rdffindsegment(rdffile * f, int segno)
{
    int i;
    for (i = 0; i < f->nsegs; i++)
	if (f->seg[i].number == segno) return i;
    return -1;
}

int rdfloadseg(rdffile *f,int segment,void *buffer)
{
  long fpos;
  long slen;

  switch(segment) {
  case RDOFF_HEADER:
      fpos = f->header_ofs;
      slen = f->header_len;
      f->header_loc = (byte *)buffer;
      f->header_fp = 0;
      break;
  default:
      if (segment < f->nsegs) {
	  fpos = f->seg[segment].offset;
	  slen = f->seg[segment].length;
	  f->seg[segment].data = (byte *)buffer;
      }
      else {
	  return rdf_errno = 10; /* no such segment */
      }
  }

  if (fseek(f->fp,fpos,SEEK_SET))
    return rdf_errno = 4;	
    
  if (fread(buffer,1,slen,f->fp) != slen)
    return rdf_errno = 3;

  return 0;
}

/* Macros for reading integers from header in memory */

#define RI8(v) v = f->header_loc[f->header_fp++]
#define RI16(v) { v = (f->header_loc[f->header_fp] + \
		       (f->header_loc[f->header_fp+1] << 8)); \
		  f->header_fp += 2; }

#define RI32(v) { v = (f->header_loc[f->header_fp] + \
		       (f->header_loc[f->header_fp+1] << 8) + \
		       (f->header_loc[f->header_fp+2] << 16) + \
		       (f->header_loc[f->header_fp+3] << 24)); \
		  f->header_fp += 4; }

#define RS(str,max) { for(i=0;i<max;i++){\
  RI8(str[i]); if (!str[i]) break;} str[i]=0; }

rdfheaderrec *rdfgetheaderrec(rdffile *f)
{
  static rdfheaderrec r;
  int i;

  if (!f->header_loc) {
    rdf_errno = 5;
    return NULL;
  }

  if (f->header_fp >= f->header_len) return 0;

  RI8(r.type);
  RI8(r.g.reclen);

  switch(r.type) {
  case RDFREC_RELOC:		/* Relocation record */
  case RDFREC_SEGRELOC:
      if (r.r.reclen != 8) {
	  rdf_errno = 9;
	  return NULL;
      }
    RI8(r.r.segment);
    RI32(r.r.offset);
    RI8(r.r.length);
    RI16(r.r.refseg);
    break;

  case RDFREC_IMPORT:		/* Imported symbol record */
  case RDFREC_FARIMPORT:
    RI16(r.i.segment);
    RS(r.i.label,32);
    break;

  case RDFREC_GLOBAL:		/* Exported symbol record */
    RI8(r.e.flags);
    RI8(r.e.segment);
    RI32(r.e.offset);
    RS(r.e.label,32);
    break;

  case RDFREC_DLL:		/* DLL record */
    RS(r.d.libname,127);
    break;

  case RDFREC_BSS:		/* BSS reservation record */
      if (r.r.reclen != 4) {
	  rdf_errno = 9;
	  return NULL;
      }
    RI32(r.b.amount);
    break;

  case RDFREC_MODNAME:		/* Module name record */
    RS(r.m.modname,127);
    break;

  case RDFREC_COMMON:		/* Common variable */
    RI16(r.c.segment);
    RI32(r.c.size);
    RI16(r.c.align);
    RS(r.c.label,32);
    break;
    
  default:
#ifdef STRICT_ERRORS
    rdf_errno = 8; /* unknown header record */
    return NULL;
#else
    for (i = 0; i < r.g.reclen; i++)
	RI8(r.g.data[i]);
#endif
  }
  return &r;
}
    
void rdfheaderrewind(rdffile *f)
{
  f->header_fp = 0;
}


rdf_headerbuf * rdfnewheader(void)
{
    rdf_headerbuf * hb = malloc(sizeof(rdf_headerbuf));
    if (hb == NULL) return NULL;

    hb->buf = newmembuf();
    hb->nsegments = 0;
    hb->seglength = 0;

    return hb;
}

int rdfaddheader(rdf_headerbuf * h, rdfheaderrec * r)
{
#ifndef STRICT_ERRORS
    int i;
#endif
    membufwrite(h->buf,&r->type,1);
    membufwrite(h->buf,&r->g.reclen,1);

    switch (r->type)
    {
    case RDFREC_GENERIC:			/* generic */
    	membufwrite(h->buf, &r->g.data, r->g.reclen);
	break;
    case RDFREC_RELOC:
    case RDFREC_SEGRELOC:
	membufwrite(h->buf,&r->r.segment,1);
	membufwrite(h->buf,&r->r.offset,-4);
	membufwrite(h->buf,&r->r.length,1);
	membufwrite(h->buf,&r->r.refseg,-2);    /* 9 bytes written */
	break;

    case RDFREC_IMPORT:				/* import */
    case RDFREC_FARIMPORT:
	membufwrite(h->buf,&r->i.segment,-2);
	membufwrite(h->buf,&r->i.label,strlen(r->i.label) + 1);
	break ;

    case RDFREC_GLOBAL:				/* export */
    	membufwrite(h->buf,&r->e.flags,1);
	membufwrite(h->buf,&r->e.segment,1);
	membufwrite(h->buf,&r->e.offset,-4);
	membufwrite(h->buf,&r->e.label,strlen(r->e.label) + 1);
	break ;

    case RDFREC_DLL:				/* DLL */
	membufwrite(h->buf,&r->d.libname,strlen(r->d.libname) + 1);
	break ;

    case RDFREC_BSS:				/* BSS */
	membufwrite(h->buf,&r->b.amount,-4);
	break ;

    case RDFREC_MODNAME:			/* Module name */
	membufwrite(h->buf,&r->m.modname,strlen(r->m.modname) + 1);
	break ;
	
    default:
#ifdef STRICT_ERRORS
	return (rdf_errno = 8);
#else
	for (i = 0; i < r->g.reclen; i++)
	    membufwrite(h->buf, r->g.data[i], 1);
#endif
    }
    return 0;
}

int rdfaddsegment(rdf_headerbuf *h, long seglength)
{
    h->nsegments ++;
    h->seglength += seglength;
    return 0;
}

int rdfwriteheader(FILE * fp, rdf_headerbuf * h)
{
    long		l, l2;

    fwrite (RDOFFId, 1, strlen(RDOFFId), fp) ;

    l = membuflength (h->buf);
    l2 = l + 14 + 10*h->nsegments + h->seglength;
    l = translatelong(l);
    l2 = translatelong(l2);
    fwrite (&l2, 4, 1, fp);	/* object length */
    fwrite (&l, 4, 1, fp);	/* header length */

    membufdump(h->buf, fp);

    return 0;		/* no error handling in here... CHANGE THIS! */
}

void rdfdoneheader(rdf_headerbuf * h)
{
    freemembuf(h->buf);
    free(h);
}

