#include <stdio.h>
#include <stdlib.h>

#include "rdoff.h"
#include "rdlib.h"

int rdl_error = 0;

char *rdl_errors[3] = {
    "no error","could not open file", "invalid file structure",
};

int rdl_searchlib (struct librarynode * lib,
		   const char * label, rdffile * f)
{
    char		buf[257];
    int			i;
    void *		hdr;
    rdfheaderrec	* r;

    rdl_error = 0;
    lib->referenced ++;

    if (! lib->fp)
    {
	lib->fp = fopen(lib->name,"rb");
	
	if (! lib->fp) {
	    rdl_error = 1;
	    return 0;
	}
    }
    else
	rewind(lib->fp);

    while (! feof(lib->fp) )
    {
	i = 1;
	while (fread(buf + i,1,1,lib->fp) == 1 && buf[i] && i < 257)
	    i++;
	buf[0] = ':';

	if (feof(lib->fp)) break;

	if ( rdfopenhere(f,lib->fp,&lib->referenced,buf) ) {
	    rdl_error = 2;
	    return 0;
	}
	
	hdr = malloc(f->header_len);
	rdfloadseg(f,RDOFF_HEADER,hdr);
	
	while ((r = rdfgetheaderrec(f)))
	{
	    if (r->type != 3)	/* not an export */
		continue;

	    if (! strcmp(r->e.label, label) )	/* match! */
	    {
		free(hdr);			/* reset to 'just open' */
		f->header_loc = NULL;		/* state... */
		f->header_fp = 0;
		return 1;
	    }
	}

	/* find start of next module... */
	i = f->data_ofs + f->data_len;
	rdfclose(f);
	fseek(lib->fp,i,SEEK_SET);
    }

    lib->referenced --;
    if (! lib->referenced)
    {
	fclose(lib->fp);
	lib->fp = NULL;
    }
    return 0;
}

void rdl_perror(const char *apname, const char *filename)
{
    fprintf(stderr,"%s:%s:%s\n",apname,filename,rdl_errors[rdl_error]);
}



