/* rdflib - manipulate RDOFF library files (.rdl) */

/* an rdoff library is simply a sequence of RDOFF object files, each
   preceded by the name of the module, an ASCII string of up to 255
   characters, terminated by a zero.  There may be an optional
   directory placed on the end of the file. The format of the
   directory will be 'RDL' followed by a version number, followed by
   the length of the directory, and then the directory, the format of
   which has not yet been designed. */

#include <stdio.h>
#include <errno.h>
#include <string.h>

/* functions supported:
     create a library	(no extra operands required)
     add a module from a library (requires filename and name to give mod.)
     remove a module from a library (requires given name)
     extract a module from the library (requires given name and filename)
     list modules */

const char *usage = 
   "usage:\n"
   "  rdflib x libname [extra operands]\n\n"
   "  where x is one of:\n"
   "    c - create library\n"
   "    a - add module (operands = filename module-name)\n"
   "    r - remove                (module-name)\n"
   "    x - extract               (module-name filename)\n"
   "    t - list\n";

char **_argv;

#define _ENDIANNESS 0		/* 0 for little, 1 for big */

static void longtolocal(long * l)
{
#if _ENDIANNESS
    unsigned char t;
    unsigned char * p = (unsigned char *) l;

    t = p[0];
    p[0] = p[3];
    p[3] = t;
    t = p[1];
    p[1] = p[2];
    p[2] = p[1];
#endif
}

void copybytes(FILE *fp, FILE *fp2, int n)
{
    int i,t;

    for (i = 0 ; i < n; i++ )
    {
	t = fgetc(fp);
	if (t == EOF)
	{
	    fprintf(stderr,"ldrdf: premature end of file in '%s'\n",
		    _argv[2]);
	    exit(1);
	}
	if (fp2) 
	    if (fputc(t, fp2) == EOF)
	    {
		fprintf(stderr,"ldrdf: write error\n");
		exit(1);
	    }
    }
}

long copylong(FILE *fp, FILE *fp2)
{
    long l;
    int i,t;
    unsigned char * p = (unsigned char *) &l;


    for (i = 0 ; i < 4; i++ )	/* skip magic no */
    {
	t = fgetc(fp);
	if (t == EOF)
	{
	    fprintf(stderr,"ldrdf: premature end of file in '%s'\n",
		    _argv[2]);
	    exit(1);
	}
	if (fp2) 
	    if (fputc(t, fp2) == EOF)
	    {
		fprintf(stderr,"ldrdf: write error\n");
		exit(1);
	    }
	*p++ = t;
    }
    longtolocal (&l);
    return l;
}

int main(int argc, char **argv)
{
    FILE *fp, *fp2;
    char *p, buf[256];
    int i;

    _argv = argv;

    if (argc < 3 || !strncmp(argv[1],"-h",2) || !strncmp(argv[1],"--h",3))
    {
	printf(usage);
	exit(1);
    }

    switch(argv[1][0])
    {
    case 'c':		/* create library */
	fp = fopen(argv[2],"wb");
	if (! fp) {
	    fprintf(stderr,"ldrdf: could not open '%s'\n",argv[2]);
	    perror("ldrdf");
	    exit(1);
	}
	fclose(fp);
	break;

    case 'a':		/* add module */
	if (argc < 5) {
	    fprintf(stderr,"ldrdf: required parameter missing\n");
	    exit(1);
	}
	fp = fopen(argv[2],"ab");
	if (! fp)
	{
	    fprintf(stderr,"ldrdf: could not open '%s'\n",argv[2]);
	    perror("ldrdf");
	    exit(1);
	}
	
	fp2 = fopen(argv[3],"rb");
	if (! fp)
	{
	    fprintf(stderr,"ldrdf: could not open '%s'\n",argv[3]);
	    perror("ldrdf");
	    exit(1);
	}

	p = argv[4];
	do {
	    if ( fputc(*p,fp) == EOF ) {
		fprintf(stderr,"ldrdf: write error\n");
		exit(1);
	    }
	} while (*p++);

	while (! feof (fp2) ) {
	    i = fgetc (fp2);
	    if (i == EOF) {
		break;
	    }

	    if ( fputc(i, fp) == EOF ) {
		fprintf(stderr,"ldrdf: write error\n");
		exit(1);
	    }
	}
	fclose(fp2);
	fclose(fp);
	break;

    case 'x':
	if (argc < 5) {
	    fprintf(stderr,"ldrdf: required parameter missing\n");
	    exit(1);
	}

	fp = fopen(argv[2],"rb");
	if (! fp)
	{
	    fprintf(stderr,"ldrdf: could not open '%s'\n",argv[2]);
	    perror("ldrdf");
	    exit(1);
	}
	
	fp2 = NULL;
	while (! feof(fp) ) {
	    /* read name */
	    p = buf;
	    while( ( *(p++) = (char) fgetc(fp) ) )  
		if (feof(fp)) break;

	    if (feof(fp)) break;

	    /* check against desired name */
	    if (! strcmp(buf,argv[3]) )
	    {
		fp2 = fopen(argv[4],"wb");
		if (! fp2)
		{
		    fprintf(stderr,"ldrdf: could not open '%s'\n", argv[4]);
		    perror("ldrdf");
		    exit(1);
		}
	    }
	    else
		fp2 = NULL;

	    /* step over the RDOFF file, copying it if fp2 != NULL */
	    copybytes(fp,fp2,6);	/* magic number */
	    copybytes(fp,fp2, copylong(fp,fp2));	/* header */
	    copybytes(fp,fp2, copylong(fp,fp2));	/* text */
	    copybytes(fp,fp2, copylong(fp,fp2));	/* data */

	    if (fp2)
		break;
	}
	fclose(fp);
	if (fp2)
	    fclose(fp2);
	else
	{
	    fprintf(stderr,"ldrdf: module '%s' not found in '%s'\n",
		    argv[3],argv[2]);
	    exit(1);
	}
	break;

    default:
	fprintf(stderr,"ldrdf: command '%c' not recognised\n",
		argv[1][0]);
	exit(1);
    }
    return 0;
}

