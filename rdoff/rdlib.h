/* rdlib.h	Functions for manipulating librarys of RDOFF object files */


struct librarynode {
    char	* name;
    FILE	* fp;		/* initialised to NULL - always check*/
    int		referenced;	/* & open if required. Close afterwards */
    struct librarynode * next;  /* if ! referenced. */
};


extern int rdl_error;

int rdl_searchlib (struct librarynode * lib,
		   const char * label, rdffile * f);
void rdl_perror(const char *apname, const char *filename);


