/* rdoff.c   	library of routines for manipulating rdoff files
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
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

/* ========================================================================
 * Code for memory buffers (for delayed writing of header until we know
 * how long it is).
 * ======================================================================== */


memorybuffer * newmembuf(){
  memorybuffer * t;

  t = malloc(sizeof(memorybuffer));

  t->length = 0;
  t->next = NULL;
  return t;
}

void membufwrite(memorybuffer *b, void *data, int bytes) {
  int16 w;
  long l;

  if (b->next) {        /* memory buffer full - use next buffer */
    membufwrite(b->next,data,bytes);
    return;
  }
  if ((bytes < 0 && b->length - bytes > BUF_BLOCK_LEN)
      || (bytes > 0 && b->length + bytes > BUF_BLOCK_LEN)) {
    
    /* buffer full and no next allocated... allocate and initialise next
     * buffer */

    b->next = newmembuf();
    membufwrite(b->next,data,bytes);
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

long translatelong(long in) {           /* translate from little endian to
                                           local representation */
  long r;
  unsigned char *i;

  i = (unsigned char *)&in;
  r = i[3];
  r = (r << 8) + i[2];
  r = (r << 8) + i[1];
  r = (r << 8) + *i;

  return r;
}

const char *RDOFFId = "RDOFF1"; /* written to the start of RDOFF files */

const char *rdf_errors[7] = {
  "no error occurred","could not open file","invalid file format",
  "error reading file","unknown error","header not read",
  "out of memory"};

int rdf_errno = 0;

/* ========================================================================
   The library functions
   ======================================================================== */

int rdfopen(rdffile *f, const char *name)
{
    FILE * fp;

    fp = fopen(name,"rb");
    if (!fp) return rdf_errno = 1;		/* error 1: file open error */

    return rdfopenhere(f,fp,NULL,"");
}

int rdfopenhere(rdffile *f, FILE *fp, int *refcount, char *name)
{
  char buf[8];
  long initpos;

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
    return rdf_errno = 2; 	/* error 2: invalid file format */
  }

  if (fread(&f->header_len,1,4,f->fp) != 4) {
    fclose(f->fp);
    return rdf_errno = 3;	/* error 3: file read error */
  }

  f->header_ofs = ftell(f->fp);

  if (fseek(f->fp,f->header_len,SEEK_CUR)) {
    fclose(f->fp);
    return rdf_errno = 2;	/* seek past end of file...? */
  }

  if (fread(&f->code_len,1,4,f->fp) != 4) {
    fclose(f->fp);
    return rdf_errno = 3;
  }

  f->code_ofs = ftell(f->fp);
  if (fseek(f->fp,f->code_len,SEEK_CUR)) {
    fclose(f->fp);
    return rdf_errno = 2;
  }

  if (fread(&f->data_len,1,4,f->fp) != 4) {
    fclose(f->fp);
    return rdf_errno = 3;
  }

  f->data_ofs = ftell(f->fp);
  fseek(f->fp,initpos,SEEK_SET);
  f->header_loc = NULL;

  f->name = newstr(name);
  f->refcount = refcount;
  if (refcount) (*refcount)++;
  return 0;
}

int rdfclose(rdffile *f)
{
    if (! f->refcount || ! *--f->refcount)
	fclose(f->fp);
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

int rdfloadseg(rdffile *f,int segment,void *buffer)
{
  long fpos;
  long slen;

  switch(segment) {
  case RDOFF_HEADER:
    fpos = f->header_ofs;
    slen = f->header_len;
    f->header_loc = (char *)buffer;
    f->header_fp = 0;
    break;
  case RDOFF_CODE:
    fpos = f->code_ofs;
    slen = f->code_len;
    break;
  case RDOFF_DATA:
    fpos = f->data_ofs;
    slen = f->data_len;
    break;
  default:
    fpos = 0;
    slen = 0;
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
  switch(r.type) {
  case 1:	/* Relocation record */
    RI8(r.r.segment);
    RI32(r.r.offset);
    RI8(r.r.length);
    RI16(r.r.refseg);
    break;

  case 2:	/* Imported symbol record */
    RI16(r.i.segment);
    RS(r.i.label,32);
    break;

  case 3:	/* Exported symbol record */
    RI8(r.e.segment);
    RI32(r.e.offset);
    RS(r.e.label,32);
    break;

  case 4:	/* DLL record */
    RS(r.d.libname,127);
    break;

  case 5:	/* BSS reservation record */
    RI32(r.b.amount);
    break;

  default:
    rdf_errno = 2; /* invalid file */
    return NULL;
  }
  return &r;
}
    
void rdfheaderrewind(rdffile *f)
{
  f->header_fp = 0;
}


rdf_headerbuf * rdfnewheader(void)
{
    return newmembuf();
}

int rdfaddheader(rdf_headerbuf * h, rdfheaderrec * r)
{
    switch (r->type)
    {
    case 1:
	membufwrite(h,&r->type,1);
	membufwrite(h,&r->r.segment,1);
	membufwrite(h,&r->r.offset,-4);
	membufwrite(h,&r->r.length,1);
	membufwrite(h,&r->r.refseg,-2);    /* 9 bytes written */
	break;

    case 2:				/* import */
	membufwrite(h,&r->type,1);
	membufwrite(h,&r->i.segment,-2);
	membufwrite(h,&r->i.label,strlen(r->i.label) + 1);
	break ;

    case 3:				/* export */
	membufwrite(h,&r->type,1);
	membufwrite(h,&r->e.segment,1);
	membufwrite(h,&r->e.offset,-4);
	membufwrite(h,&r->e.label,strlen(r->e.label) + 1);
	break ;

    case 4:				/* DLL */
	membufwrite(h,&r->type,1);
	membufwrite(h,&r->d.libname,strlen(r->d.libname) + 1);
	break ;

    case 5:				/* BSS */
	membufwrite(h,&r->type,1);
	membufwrite(h,&r->b.amount,-4);
	break ;

    default:
	return (rdf_errno = 2);
    }
    return 0;
}

int rdfwriteheader(FILE * fp, rdf_headerbuf * h)
{
    long		l;

    fwrite (RDOFFId, 1, strlen(RDOFFId), fp) ;

    l = translatelong ( membuflength (h) );
    fwrite (&l, 4, 1, fp);

    membufdump(h, fp);

    return 0;		/* no error handling in here... CHANGE THIS! */
}

void rdfdoneheader(rdf_headerbuf * h)
{
    freemembuf(h);
}
