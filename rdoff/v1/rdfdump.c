#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *infile;

long translatelong(long in) {		/* translate from little endian to
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
  
int translateshort(short in) {
  int r;
  unsigned char *i;

  i = (unsigned char *)&in;
  r = (i[1] << 8) + *i;

  return r;
}
void print_header(long length) {
  char buf[129],t,s,l;
  long o,ll;
  short rs;

  while (length > 0) {
    fread(&t,1,1,infile);
    switch(t) {
    case 1:		/* relocation record */
      fread(&s,1,1,infile);
      fread(&o,4,1,infile);
      fread(&l,1,1,infile);
      fread(&rs,2,1,infile); 
      printf("  relocation: location (%04x:%08lx), length %d, "
	     "referred seg %04x\n",(int)s,translatelong(o),(int)l,
	     translateshort(rs));
      length -= 9;
      break;
    case 2:             /* import record */
      fread(&rs,2,1,infile);
      ll = 0;
      do {
	fread(&buf[ll],1,1,infile);
      } while (buf[ll++]);
      printf("  import: segment %04x = %s\n",translateshort(rs),buf);
      length -= ll + 3;
      break;
    case 3:             /* export record */
      fread(&s,1,1,infile);
      fread(&o,4,1,infile);
      ll = 0;
      do {
	fread(&buf[ll],1,1,infile);
      } while (buf[ll++]);
      printf("  export: (%04x:%08lx) = %s\n",(int)s,translatelong(o),buf);
      length -= ll + 6;
      break;
    case 4:		/* DLL record */
      ll = 0;
      do {
	fread(&buf[ll],1,1,infile);
      } while (buf[ll++]);
      printf("  dll: %s\n",buf);
      length -= ll + 1;
      break;
    case 5:		/* BSS reservation */
      fread(&ll,4,1,infile);
      printf("  bss reservation: %08lx bytes\n",translatelong(ll));
      length -= 5;
      break;
    default:
      printf("  unrecognised record (type %d)\n",(int)t);
      length --;
    }
  }
}

int main(int argc,char **argv) {
  char id[7];
  long l;
  int verbose = 0;
  long offset;

  puts("RDOFF Dump utility v1.1 (C) Copyright 1996 Julian R Hall");

  if (argc < 2) {
    fputs("Usage: rdfdump [-v] <filename>\n",stderr);
    exit(1);
  }

  if (! strcmp (argv[1], "-v") )
  {
    verbose = 1;
    if (argc < 3)
    {
      fputs("required parameter missing\n",stderr);
      exit(1);
    }
    argv++;
  }

  infile = fopen(argv[1],"rb");
  if (! infile) {
    fprintf(stderr,"rdfdump: Could not open %s",argv[1]);
    exit(1);
  }

  fread(id,6,1,infile);
  if (strncmp(id,"RDOFF",5)) {
    fputs("rdfdump: File does not contain valid RDOFF header\n",stderr);
    exit(1);
  }

  printf("File %s: RDOFF version %c\n\n",argv[1],id[5]);
  if (id[5] < '1' || id[5] > '1') {
    fprintf(stderr,"rdfdump: unknown RDOFF version '%c'\n",id[5]);
    exit(1);
  }

  fread(&l,4,1,infile);
  l = translatelong(l);
  printf("Header (%ld bytes):\n",l);
  print_header(l);

  fread(&l,4,1,infile);
  l = translatelong(l);
  printf("\nText segment length = %ld bytes\n",l);
  offset = 0;
  while(l--) {
    fread(id,1,1,infile);
    if (verbose) {
      if (offset % 16 == 0)
	printf("\n%08lx ", offset);
      printf(" %02x",(int) (unsigned char)id[0]);
      offset++;
    }
  }
  if (verbose) printf("\n\n");

  fread(&l,4,1,infile);
  l = translatelong(l);
  printf("Data segment length = %ld bytes\n",l);

  if (verbose)
  {
    offset = 0;
    while (l--) {
      fread(id,1,1,infile);
      if (offset % 16 == 0)
	printf("\n%08lx ", offset);
      printf(" %02x",(int) (unsigned char) id[0]);
      offset++;
    }
    printf("\n");
  }
  fclose(infile);
  return 0;
}
