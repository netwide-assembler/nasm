/* ldrdf.c	RDOFF Object File linker/loader main program
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

/* TODO: Make the system skip a module (other than the first) if none
 * of the other specified modules contain a reference to it.
 * May require the system to make an extra pass of the modules to be
 * loaded eliminating those that aren't required.
 *
 * Support all the existing documented options...
 *
 * Support libaries (.a files - requires a 'ranlib' type utility)
 *		(I think I've got this working, so I've upped the version)
 *
 * -s option to strip resolved symbols from exports. (Could make this an
 * external utility)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdoff.h"
#include "nasmlib.h"
#include "symtab.h"
#include "collectn.h"
#include "rdlib.h"

#define LDRDF_VERSION "0.30"

/* global variables - those to set options: */

int 	verbose = 0;	/* reflects setting of command line switch */
int	align = 16;
int	errors = 0;	/* set by functions to cause halt after current
			   stage of processing */

/* the linked list of modules that must be loaded & linked */

struct modulenode {
    rdffile	f;	/* the file */
    long	coderel;	/* module's code relocation factor */
    long	datarel;	/* module's data relocation factor */
    long	bssrel;		/* module's bss data reloc. factor */
    void *	header;		/* header location, if loaded */
    char *	name;		/* filename */
    struct modulenode *next;
};

#define newstr(str) strcpy(malloc(strlen(str) + 1),str)
#define newstrcat(s1,s2) strcat(strcpy(malloc(strlen(s1)+strlen(s2)+1),s1),s2)


struct modulenode *modules = NULL,*lastmodule = NULL;

/* the linked list of libraries to be searched for missing imported
   symbols */

struct librarynode * libraries = NULL, * lastlib = NULL;

void *symtab;	/* The symbol table */

rdf_headerbuf * newheader ;	/* New header to be written to output */

/* loadmodule - find the characteristics of a module and add it to the
 *		list of those being linked together			*/

void loadmodule(char *filename)
{
  struct modulenode *prev;
  if (! modules) {
    modules = malloc(sizeof(struct modulenode));
    lastmodule = modules;
    prev = NULL;
  }
  else {
    lastmodule->next = malloc(sizeof(struct modulenode));
    prev = lastmodule;
    lastmodule = lastmodule->next;
  }

  if (! lastmodule) {
    fputs("ldrdf: not enough memory\n",stderr);
    exit(1);
  }

  if (rdfopen(&lastmodule->f,filename)) {
    rdfperror("ldrdf",filename);
    exit(1);
  }

  lastmodule->header = NULL;	/* header hasn't been loaded */
  lastmodule->name = filename;
  lastmodule->next = NULL;

  if (prev) {
    lastmodule->coderel = prev->coderel + prev->f.code_len;
    if (lastmodule->coderel % align != 0)
      lastmodule->coderel += align - (lastmodule->coderel % align);
    lastmodule->datarel = prev->datarel + prev->f.data_len;
    if (lastmodule->datarel % align != 0)
      lastmodule->datarel += align - (lastmodule->datarel % align);
  }
  else {
    lastmodule->coderel = 0;
    lastmodule->datarel = 0;
  }

  if (verbose)
    printf("%s code = %08lx (+%04lx), data = %08lx (+%04lx)\n",filename,
	   lastmodule->coderel,lastmodule->f.code_len,
	   lastmodule->datarel,lastmodule->f.data_len);

  lastmodule->header = malloc(lastmodule->f.header_len);
  if (!lastmodule->header) {
      fprintf(stderr,"ldrdf: out of memory\n");
      exit(1);
  }

  if (rdfloadseg(&lastmodule->f,RDOFF_HEADER,lastmodule->header))
  {
      rdfperror("ldrdf",filename);
      exit(1);
  }
}

/* load_library		add a library to list of libraries to search
 *                      for undefined symbols
 */

void load_library(char * name)
{
    if (verbose)
	printf("adding library %s to search path\n",name);
	
    if (! lastlib) {
	lastlib = libraries = malloc(sizeof(struct librarynode));
    }
    else
    {
	lastlib->next = malloc(sizeof(struct librarynode));
	lastlib = lastlib->next;
    }

    if (! lastlib) {
	fprintf(stderr, "ldrdf: out of memory\n");
	exit(1);
    }
    strcpy (lastlib->name = malloc (1+strlen(name)), name);
    lastlib->fp = NULL;
    lastlib->referenced = 0;
    lastlib->next = NULL;
}


/* build_symbols()	step through each module's header, and locate
 *			exported symbols, placing them in a global table
 */

long bsslength;

void mod_addsymbols(struct modulenode * mod)
{
    rdfheaderrec *r;
    symtabEnt e;
    long cbBss;

    mod->bssrel = bsslength;
    cbBss = 0;
    rdfheaderrewind(&mod->f);
    while ((r = rdfgetheaderrec(&mod->f)))
    {

	if (r->type == 5)		/* Allocate BSS */
	    cbBss += r->b.amount;

	if (r->type != 3) continue;	/* ignore all but export recs */

	e.segment = r->e.segment;
	e.offset = r->e.offset + 
	    (e.segment == 0 ? mod->coderel : /* 0 -> code */
	     e.segment == 1 ? mod->datarel : /* 1 -> data */
	     mod->bssrel) ; /* 2 -> bss  */
	
	e.flags = 0;
	e.name = malloc(strlen(r->e.label) + 1);
	if (! e.name)
	{
	    fprintf(stderr,"ldrdf: out of memory\n");
	    exit(1);
	}
	strcpy(e.name,r->e.label);
	symtabInsert(symtab,&e);
    }
    bsslength += cbBss;
}

void build_symbols()
{
  struct modulenode *mod;

  if (verbose) printf("building global symbol table:\n");
  newheader = rdfnewheader();

  symtab = symtabNew();
  bsslength = 0;		  /* keep track of location of BSS symbols */

  for (mod = modules; mod; mod = mod->next)
  {
      mod_addsymbols( mod );
  }
  if (verbose)
  {
      symtabDump(symtab,stdout);
      printf("BSS length = %ld bytes\n\n",bsslength);
  }
}


/* scan_libraries()	search through headers of modules for undefined
 *			symbols, and scan libraries for those symbols,
 *			adding library modules found to list of modules
 *			to load.					*/

void scan_libraries(void)
{
    struct modulenode 	* mod, * nm;
    struct librarynode	* lib;
    rdfheaderrec	* r;
    int			found;
    char		* tmp;

    if (verbose) printf("Scanning libraries for unresolved symbols...\n");

    mod = modules;

    while (mod)
    {
	rdfheaderrewind(&mod->f);

	while ((r = rdfgetheaderrec(&mod->f)))
	{
	    if (r->type != 2) continue;	/* not an import record */
	    if ( symtabFind (symtab,r->i.label) )
		continue;		/* symbol already defined */
	    
	    /* okay, we have an undefined symbol... step through
	       the libraries now */
	    if (verbose >= 2) {
		printf("undefined symbol '%s'...",r->i.label);
		fflush(stdout);
	    }

	    lib = libraries;
	    found = 0;

	    tmp = newstr(r->i.label);
	    while (! found && lib)
	    {
		/* move this to an outer loop...! */
		nm = malloc(sizeof(struct modulenode));

		if (rdl_searchlib(lib,tmp,&nm->f))
		{	/* found a module in the library */

		    /* create a modulenode for it */

		    if (! nm) {
			fprintf(stderr,"ldrdf: out of memory\n");
			exit(1);
		    }

		    nm->name = newstrcat(lib->name,nm->f.name);
		    if (verbose >= 2) printf("found in '%s'\n",nm->name);

		    nm->coderel = lastmodule->coderel + lastmodule->f.code_len;
		    if (nm->coderel % align != 0)
			nm->coderel += align - (nm->coderel % align);

		    nm->datarel = lastmodule->datarel + lastmodule->f.data_len;
		    if (nm->datarel % align != 0)
			nm->datarel += align - (nm->datarel % align);

		    nm->header = malloc(nm->f.header_len);
		    if (! nm->header)
		    {
			fprintf(stderr,"ldrdf: out of memory\n");
			exit(1);
		    }

		    if (rdfloadseg(&nm->f,RDOFF_HEADER,nm->header))
		    {
			rdfperror("ldrdf",nm->name);
			exit(1);
		    }

		    nm->next = NULL;
		    found = 1;
		    lastmodule->next = nm;
		    lastmodule = nm;

		    if (verbose)
			printf("%s code = %08lx (+%04lx), data = %08lx "
			       "(+%04lx)\n",lastmodule->name,
			       lastmodule->coderel,lastmodule->f.code_len,
			       lastmodule->datarel,lastmodule->f.data_len);

		    /* add the module's info to the symbol table */
		    mod_addsymbols(nm);
		}
		else
		{
		    if (rdl_error) {
			rdl_perror("ldrdf",lib->name);
			exit(1);
		    }
		    free(nm);
		}
		lib = lib->next;
	    }
	    free(tmp);
	    if (!found && verbose >= 2) printf("not found\n");
	}
	mod = mod->next;
    }
}

/* load_segments()	allocates memory for & loads the code & data segs
 *			from the RDF modules
 */

char *text,*data;
long textlength,datalength;

void load_segments(void)
{
  struct modulenode *mod;

  if (!modules) {
    fprintf(stderr,"ldrdf: nothing to do\n");
    exit(0);
  }
  if (!lastmodule) {
    fprintf(stderr,"ldrdf: panic: module list exists, but lastmodule=NULL\n");
    exit(3);
  }

  if (verbose)
    printf("loading modules into memory\n");

  /* The following stops 16 bit DOS from crashing whilst attempting to
     work using segments > 64K */
  if (sizeof(int) == 2) { /* expect a 'code has no effect' warning on 32 bit
			    platforms... */
    if (lastmodule->coderel + lastmodule->f.code_len > 65535 ||
	lastmodule->datarel + lastmodule->f.data_len > 65535) {
      fprintf(stderr,"ldrdf: segment length has exceeded 64K; use a 32 bit "
	      "version.\nldrdf: code size = %05lx, data size = %05lx\n",
	      lastmodule->coderel + lastmodule->f.code_len,
	      lastmodule->datarel + lastmodule->f.data_len);
      exit(1);
    }
  }

  text = malloc(textlength = lastmodule->coderel + lastmodule->f.code_len);
  data = malloc(datalength = lastmodule->datarel + lastmodule->f.data_len);

  if (!text || !data) {
    fprintf(stderr,"ldrdf: out of memory\n");
    exit(1);
  }

  mod = modules;
  while (mod) {		/* load the segments for each module */
      if (verbose >= 2) printf("  loading %s\n",mod->name);
      if (rdfloadseg(&mod->f,RDOFF_CODE,&text[mod->coderel]) ||
	  rdfloadseg(&mod->f,RDOFF_DATA,&data[mod->datarel])) {
	  rdfperror("ldrdf",mod->name);
	  exit(1);
      }
      rdfclose(&mod->f);	/* close file; segments remain */
      mod = mod->next;
  }
}
    
/* link_segments()	step through relocation records in each module's
 *			header, fixing up references.
 */

void link_segments(void)
{
  struct modulenode	*mod;
  Collection		imports;
  symtabEnt		*s;
  long 			rel,relto;
  char 			*seg;
  rdfheaderrec		*r;
  int			bRelative;

  if (verbose) printf("linking segments\n");

  collection_init(&imports);

  for (mod = modules; mod; mod = mod->next) {
    if (verbose >= 2) printf("* processing %s\n",mod->name);
    rdfheaderrewind(&mod->f);
    while((r = rdfgetheaderrec(&mod->f))) {
	if (verbose >= 3) printf("record type: %d\n",r->type);
	switch(r->type) {
	case 1:		/* relocation record */
	    if (r->r.segment >= 64) {     	/* Relative relocation; */
		bRelative = 1;		/* need to find location relative */
		r->r.segment -= 64;		/* to start of this segment */
		relto = r->r.segment == 0 ? mod->coderel : mod->datarel;
	    }
	    else
	    {
		bRelative = 0;		/* non-relative - need to relocate
					 * at load time			*/
		relto = 0;	       /* placate optimiser warnings */
	    }

	    /* calculate absolute offset of reference, not rel to beginning of
	       segment */
	    r->r.offset += r->r.segment == 0 ? mod->coderel : mod->datarel;

	    /* calculate the relocation factor to apply to the operand -
	       the base address of one of this modules segments if referred
	       segment is 0 - 2, or the address of an imported symbol
	       otherwise. */

	    if (r->r.refseg == 0) rel = mod->coderel;
	    else if (r->r.refseg == 1) rel = mod->datarel;
	    else if (r->r.refseg == 2) rel = mod->bssrel;
	    else {		/* cross module link - find reference */
		s = *colln(&imports,r->r.refseg - 2);
		if (!s) {
		    fprintf(stderr,"ldrdf: link to undefined segment %04x in"
			    " %s:%d\n", r->r.refseg,mod->name,r->r.segment);
		    errors = 1;
		    break;
		}
		rel = s->offset;
	  
		r->r.refseg = s->segment;	/* change referred segment, 
						   so that new header is
						   correct */
	    }

	    if (bRelative)	/* Relative - subtract current segment start */
		rel -= relto; 
	    else  
	    {			/* Add new relocation header */
		rdfaddheader(newheader,r);
	    }
	    
	    /* Work out which segment we're making changes to ... */
	    if (r->r.segment == 0) seg = text;
	    else if (r->r.segment == 1) seg = data;
	    else {
		fprintf(stderr,"ldrdf: relocation in unknown segment %d in "
			"%s\n", r->r.segment,mod->name);
		errors = 1;
		break;
	    }

	    /* Add the relocation factor to the datum specified: */

	    if (verbose >= 3)
		printf("  - relocating %d:%08lx by %08lx\n",r->r.segment,
		       r->r.offset,rel);

	    /**** The following code is non-portable. Rewrite it... ****/
	    switch(r->r.length) {
	    case 1:
		seg[r->r.offset] += (char) rel;
		break;
	    case 2:
		*(int16 *)(seg + r->r.offset) += (int16) rel;
		break;
	    case 4:
		*(long *)(seg + r->r.offset) += rel;
		break;
	    }
	    break;

	case 2:		/* import record */
	    s = symtabFind(symtab, r->i.label);
	    if (s == NULL) {
		/* Need to add support for dynamic linkage */
		fprintf(stderr,"ldrdf: undefined symbol %s in module %s\n",
			r->i.label,mod->name);
		errors = 1;
	    }
	    else 
	    {
		*colln(&imports,r->i.segment - 2) = s;
		if (verbose >= 2)
		    printf("imported %s as %04x\n", r->i.label, r->i.segment);
	    }
	    break;

	case 3:		/* export; dump to output new version */
	    s = symtabFind(symtab, r->e.label);
	    if (! s) {
		fprintf(stderr,"ldrdf: internal error - undefined symbol %s "
			"exported in header of '%s'\n",r->e.label,mod->name);
		continue;
	    }
	    r->e.offset = s->offset;
	    rdfaddheader(newheader,r);
	    break;

	case 4:		/* DLL record */
	    rdfaddheader(newheader,r);		/* copy straight to output */
	    break;
	}
    }
    if (rdf_errno != 0) {
	rdfperror("ldrdf",mod->name);
	exit(1);
    }
    collection_reset(&imports);
  }
}
    
/* write_output()	write linked program out to a file */

void write_output(char *filename)
{
    FILE		* fp;
    rdfheaderrec	r;

    if (verbose) printf("writing output to '%s'\n",filename);

    fp = fopen(filename,"wb");
    if (! fp)
    {
	fprintf(stderr,"ldrdf: could not open '%s' for writing\n",filename);
	exit(1);
    }
  
    
    /* add BSS length count to header... */
    if (bsslength)
    {
	r.type = 5;
	r.b.amount = bsslength;
	rdfaddheader(newheader,&r);
    }

    /* Write header */
    rdfwriteheader(fp,newheader);
    rdfdoneheader(newheader);
    newheader = NULL;

    /* Write text */
    if (fwrite(&textlength,1,4,fp) != 4
	|| fwrite(text,1,textlength,fp) !=textlength)
    {
	fprintf(stderr,"ldrdf: error writing %s\n",filename);
	exit(1);
    }

    /* Write data */
    if (fwrite(&datalength,1,4,fp) != 4 ||
	fwrite(data,1,datalength,fp) != datalength)
    {
	fprintf (stderr,"ldrdf: error writing %s\n", filename);
	exit(1);
    }
    fclose(fp);
}


/* main program: interpret command line, and pass parameters on to
 * individual module loaders & the linker
 *
 * Command line format:
 * ldrdf [-o outfile | -x] [-r xxxx] [-v] [--] infile [infile ...]
 *
 * Default action is to output a file named 'aout.rdx'. -x specifies
 * that the linked object program should be executed, rather than
 * written to a file. -r specifies that the object program should
 * be prelocated at address 'xxxx'. This option cannot be used
 * in conjunction with -x.
 */

const char *usagemsg = "usage:\n"
" ldrdf [-o outfile | -x] [-a x] [-v] [-p x] [--] infile [infile ...]\n"
"       [-l<libname> ...]\n\n"
" ldrdf -h	displays this message\n"
" ldrdf -r	displays version information\n\n"
"   -o selects output filename (default is aout.rdx)\n"
"   -x causes ldrdx to link & execute rather than write to file\n"
"   -a x causes object program to be statically relocated to address 'x'\n"
"   -v turns on verbose mode\n"
"   -p x causes segments to be aligned (padded) to x byte boundaries\n"
"      (default is 16 bytes)\n"
"   -l<name> causes 'name' to be linked in as a library. Note no search is\n"
"      performed - the entire pathname MUST be specified.\n";

void usage(void)
{
  fputs(usagemsg,stderr);
}

int main(int argc,char **argv)
{
  char	*ofilename = "aout.rdx";
  long	relocateaddr = -1;	/* -1 if no relocation is to occur */
  int	execute = 0;		/* 1 to execute after linking, 0 otherwise */
  int	procsw = 1;		/* set to 0 by '--' */
  int	tmp;

  if (argc == 1) {
    usage();
    exit(1);
  }

  /* process command line switches, and add modules specified to linked list
     of modules, keeping track of total memory required to load them */

  while(argv++,--argc) {
    if (procsw && !strcmp(*argv,"-h")) {	/* Help command */
      usage(); exit(1);
    }
    else if (procsw && !strcmp(*argv,"-r")) {
      printf("ldrdf version %s (%s) (%s)\n",LDRDF_VERSION,_RDOFF_H,
	     sizeof(int) == 2 ? "16 bit" : "32 bit");
      exit(1);
    }
    else if (procsw && !strcmp(*argv,"-o")) {
      ofilename = *++argv;
      --argc;
      if (execute) {
	fprintf(stderr,"ldrdf: -o and -x switches incompatible\n");
	exit(1);
      }
      if (verbose > 1) printf("output filename set to '%s'\n",ofilename);
    }
    else if (procsw && !strcmp(*argv,"-x")) {
      execute++;
      if (verbose > 1) printf("will execute linked object\n");
    }
    else if (procsw && !strcmp(*argv,"-a")) {
      relocateaddr = readnum(*++argv,&tmp);
      --argc;
      if (tmp) {
	fprintf(stderr,"ldrdf: error in parameter to '-a' switch: '%s'\n",
		*argv);
	exit(1);
      }
      if (execute) {
	fprintf(stderr,"ldrdf: -a and -x switches incompatible\n");
	exit(1);
      }
      if (verbose) printf("will relocate to %08lx\n",relocateaddr);
    }
    else if (procsw && !strcmp(*argv,"-v")) {
      verbose++;
      if (verbose == 1) printf("verbose mode selected\n");
    }
    else if (procsw && !strcmp(*argv,"-p")) {
      align = readnum(*++argv,&tmp);
      --argc;
      if (tmp) {
	fprintf(stderr,"ldrdf: error in parameter to '-p' switch: '%s'\n",
		*argv);
	exit(1);
      }
      if (align != 1 && align != 2 && align != 4 && align != 8 && align != 16
	  && align != 32 && align != 256) {
	fprintf(stderr,"ldrdf: %d is an invalid alignment factor - must be"
		"1,2,4,8,16 or 256\n",align);
	exit(1);
      }
      if (verbose > 1) printf("alignment %d selected\n",align);
    }
    else if (procsw && !strncmp(*argv,"-l",2)) {
	load_library(*argv + 2);
    }
    else if (procsw && !strcmp(*argv,"--")) {
      procsw = 0;
    }
    else {					/* is a filename */
      if (verbose > 1) printf("processing module %s\n",*argv);
      loadmodule(*argv);
    }
  }

  /* we should be scanning for unresolved references, and removing
     unreferenced modules from the list of modules here, so that
     we know about the final size once libraries have been linked in */

  build_symbols();	/* build a global symbol table...           */

  scan_libraries();	/* check for imported symbols not in table,
			   and ensure the relevant library modules
			   are loaded */

  load_segments();	/* having calculated size of reqd segments, load
			   each rdoff module's segments into memory */

  link_segments();	/* step through each module's header, and resolve
			   references to the global symbol table.
			   This also does local address fixups. */

  if (errors) {
    fprintf(stderr,"ldrdf: there were errors - aborted\n");
    exit(errors);
  }
  if (execute) {
    fprintf(stderr,"ldrdf: module execution not yet supported\n");
    exit(1);
  }
  if (relocateaddr != -1) {
    fprintf(stderr,"ldrdf: static relocation not yet supported\n");
    exit(1);
  }

  write_output(ofilename);
  return 0;
}
