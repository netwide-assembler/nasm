/* outbin.c output routines for the Netwide Assembler to produce
 *    flat-form binary files
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

/*
 * version with multiple sections support
 *
 * sections go in order defined by their org's if present
 * if no org present, sections go in sequence they appear.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "nasm.h"
#include "nasmlib.h"
#include "outform.h"

#ifdef OF_BIN

static FILE *fp;
static efunc error;

static struct Section {
    struct Section *next;
    struct SAA *contents;
    long length;
    long org;                  /* assigned org */
    long pos;                  /* file position of section ?? */
    long pad;                  /* padding bytes to next section in file */
    long index;                /* the NASM section id */
    long align;                /* section alignment, cannot be absolute addr */
    char *name;
} *sections, **sectail;

static struct Reloc {
    struct Reloc *next;
    long posn;
    long bytes;
    long secref;
    long secrel;
    struct Section *target;
} *relocs, **reloctail;

static long current_section;

static void add_reloc (struct Section *s, long bytes, long secref,
             long secrel)
{
    struct Reloc *r;

    r = *reloctail = nasm_malloc(sizeof(struct Reloc));
    reloctail = &r->next;
    r->next = NULL;
    r->posn = s->length;
    r->bytes = bytes;
    r->secref = secref;
    r->secrel = secrel;
    r->target = s;
}

static struct Section *find_section_by_name(const char *name)
{
   struct Section *s;

   for (s = sections; s; s = s->next)
      if (!strcmp(s->name,name))
         break;

   return s;
}

static struct Section *find_section_by_index(long index)
{
   struct Section *s;

   for (s = sections; s; s = s->next)
      if ( s->index == index )
         break;

   return s;
}

static struct Section *alloc_section(char *name)
{
   struct Section *s;

   s = find_section_by_name(name);
   if(s)
      error(ERR_PANIC, "section %s re-defined", name);

   s = nasm_malloc(sizeof(struct Section));
   *sectail    = s;
   sectail     = &s->next;
   s->next     = NULL;

   s->contents = saa_init(1L);
   s->length   = 0;
   s->pos      = 0;
   s->org      = -1; /* default org is -1 because we want
                      * to adjust sections one after another
                      */
   s->index    = seg_alloc();
   s->align    = 4;
   s->pad      = 0;
   s->name     = nasm_strdup(name);

   return s;
}

static void bin_init (FILE *afp, efunc errfunc, ldfunc ldef, evalfunc eval)
{
    fp = afp;
    error = errfunc;

    (void) eval;   /* Don't warn that this parameter is unused */
    (void) ldef;            /* placate optimisers */

    current_section = -1L;
    relocs    = NULL;
    reloctail = &relocs;
    sections  = NULL;
    sectail   = &sections;
}

static void bin_cleanup (int debuginfo)
{
   struct Section *outsections, **outstail;
   struct Section *s, *o, *ls, *lo;
   struct Reloc *r;
   long least_org;

   (void) debuginfo;

   /* sort sections by their orgs
    * sections without org follow their natural order
    * after the org'd sections
    */
   outsections = NULL;
   outstail = &outsections;

   while( 1 )
   {
      least_org = 0x7fffffff;

      ls = lo = NULL;
      for( s = sections, o = NULL; s; o = s, s = s->next )
         if( s->org != -1 && s->org < least_org )
         {
            least_org = s->org;
            ls = s;
            lo = o;
         }

      if(ls) /* relink to outsections */
      {
#ifdef DEBUG
         fprintf(stdout, "bin_cleanup: relinking section %s org %ld\n", ls->name, ls->org);
#endif
         /* unlink from sections */
         if(lo)
            lo->next = ls->next;
         else
            if(ls == sections)
               sections = ls->next;

         /* link in to outsections */
         if( ls->length > 0 )
         {
            *outstail   = ls;
            outstail    = &ls->next;
            ls->next    = NULL;
         }
      }
      else
         break;
   }

   /* link outsections at start of sections */
   *outstail = sections;
   sections = outsections;

   /* calculate sections positions */
   for(s = sections, o = NULL; s; s = s->next)
   {
      if(!strcmp(s->name,".bss")) continue; /* don't count .bss yet */

      if(o)
      {
         /* if section doesn't have its
          * own org, align from prev section
          */
         if( s->org == -1 )
            s->org = o->org + o->length;

         /* check orgs */
         if( s->org - o->org < o->length )
            error( ERR_PANIC, "sections %s and %s overlap!", o->name, s->name );

         /* align previous section */
         o->pad = ((o->pos + o->length + o->align-1) & ~(o->align-1)) - (o->pos + o->length);

         if( s->org - o->org > o->length )
         {
#ifdef DEBUG
            fprintf(stdout, "forced padding: %ld\n", s->org - o->org - o->length);
#endif
            o->pad = s->org - o->org - o->length;
         }

         s->pos += o->pos + o->length + o->pad;
         s->org = s->pos + sections->org;
      }

#ifdef DEBUG
      fprintf(stdout, "bin_cleanup: section %s at %ld(%lx) org %ld(%lx) prev <pos %ld(%lx)+size %ld(%lx)+pad %ld(%lx)> size %ld(%lx) align %ld(%lx)\n",
              s->name, s->pos, s->pos, s->org, s->org, o?o->pos:0, o?o->pos:0,
              o?o->length:0, o?o->length:0, o?o->pad:0, o?o->pad:0, s->length, s->length,
              s->align, s->align);
#endif

      /* prepare for relocating by the way */
      saa_rewind( s->contents );

      o = s;
   }

   /* adjust .bss */
   s = find_section_by_name(".bss");
   if(s)
   {
      s->org = o->org + o->length + o->pad;

#ifdef DEBUG
      fprintf(stdout, "bin_cleanup: section %s at %ld org %ld prev (pos %ld+size %ld+pad %ld) size %ld align %ld\n",
              s->name, s->pos, s->org, o?o->pos:0, o?o->length:0, o?o->pad:0, s->length, s->align);
#endif
   }

   /* apply relocations */
   for (r = relocs; r; r = r->next)
   {
      unsigned char *p, *q, mydata[4];
      long l;

      saa_fread (r->target->contents, r->posn, mydata, r->bytes);
      p = q = mydata;
      l = *p++;

      if (r->bytes > 1) {
         l += ((long)*p++) << 8;
         if (r->bytes == 4) {
            l += ((long)*p++) << 16;
            l += ((long)*p++) << 24;
         }
      }

      s = find_section_by_index(r->secref);
      if(s)
         l += s->org;

      s = find_section_by_index(r->secrel);
      if(s)
         l -= s->org;

      if (r->bytes == 4)
          WRITELONG(q, l);
      else if (r->bytes == 2)
          WRITESHORT(q, l);
      else
          *q++ = l & 0xFF;
      saa_fwrite (r->target->contents, r->posn, mydata, r->bytes);
   }

   /* write sections to file */
   for(s = outsections; s; s = s->next)
   {
      if(s->length > 0 && strcmp(s->name,".bss"))
      {
#ifdef DEBUG
         fprintf(stdout, "bin_cleanup: writing section %s\n", s->name);
#endif
         saa_fpwrite (s->contents, fp);
         if( s->next )
            while( s->pad-- > 0 )
               fputc('\0', fp);
               /* could pad with nops, since we don't
                * know if this is code section or not
                */
      }
   }

   fclose (fp);

   while (relocs) {
      r = relocs->next;
      nasm_free (relocs);
      relocs = r;
   }

   while (outsections) {
      s = outsections->next;
      saa_free  (outsections->contents);
      nasm_free (outsections->name);
      nasm_free (outsections);
      outsections = s;
   }
}

static void bin_out (long segto, const void *data, unsigned long type,
           long segment, long wrt)
{
    unsigned char *p, mydata[4];
    struct Section *s, *sec;
    long realbytes;

    if (wrt != NO_SEG) {
   wrt = NO_SEG;            /* continue to do _something_ */
   error (ERR_NONFATAL, "WRT not supported by binary output format");
    }

    /*
     * handle absolute-assembly (structure definitions)
     */
    if (segto == NO_SEG) {
   if ((type & OUT_TYPMASK) != OUT_RESERVE)
       error (ERR_NONFATAL, "attempt to assemble code in [ABSOLUTE]"
         " space");
   return;
    }

    /*
     * Find the segment we are targetting.
     */
    s = find_section_by_index(segto);
    if (!s)
   error (ERR_PANIC, "code directed to nonexistent segment?");

    if (!strcmp(s->name, ".bss")) {         /* BSS */
   if ((type & OUT_TYPMASK) != OUT_RESERVE)
       error(ERR_WARNING, "attempt to initialise memory in the"
        " BSS section: ignored");
   s = NULL;
    }

   if ((type & OUT_TYPMASK) == OUT_ADDRESS) {

      if (segment != NO_SEG && !find_section_by_index(segment)) {
          if (segment % 2)
         error(ERR_NONFATAL, "binary output format does not support"
               " segment base references");
          else
         error(ERR_NONFATAL, "binary output format does not support"
               " external references");
          segment = NO_SEG;
      }

      if (s) {
         if (segment != NO_SEG)
            add_reloc (s, type & OUT_SIZMASK, segment, -1L);
         p = mydata;
         if ((type & OUT_SIZMASK) == 4)
            WRITELONG (p, *(long *)data);
         else
            WRITESHORT (p, *(long *)data);
         saa_wbytes (s->contents, mydata, type & OUT_SIZMASK);
         s->length += type & OUT_SIZMASK;
      } else {
         sec = find_section_by_name(".bss");
         if(!sec)
            error(ERR_PANIC, ".bss section is not present");
         sec->length += type & OUT_SIZMASK;
      }

   } else if ((type & OUT_TYPMASK) == OUT_RAWDATA) {
      type &= OUT_SIZMASK;
      if (s) {
          saa_wbytes (s->contents, data, type);
          s->length += type;
      } else {
         sec = find_section_by_name(".bss");
         if(!sec)
            error(ERR_PANIC, ".bss section is not present");
         sec->length += type;
      }

   } else if ((type & OUT_TYPMASK) == OUT_RESERVE) {
      if (s) {
          error(ERR_WARNING, "uninitialised space declared in"
           " %s section: zeroing", s->name);
      }
      type &= OUT_SIZMASK;
      if (s) {
          saa_wbytes (s->contents, NULL, type);
          s->length += type;
      } else {
         sec = find_section_by_name(".bss");
         if(!sec)
            error(ERR_PANIC, ".bss section is not present");
         sec->length += type;
      }
   }
   else if ((type & OUT_TYPMASK) == OUT_REL2ADR ||
        (type & OUT_TYPMASK) == OUT_REL4ADR)
   {
      realbytes = ((type & OUT_TYPMASK) == OUT_REL4ADR ? 4 : 2);

      if (segment != NO_SEG && !find_section_by_index(segment)) {
          if (segment % 2)
         error(ERR_NONFATAL, "binary output format does not support"
               " segment base references");
          else
         error(ERR_NONFATAL, "binary output format does not support"
               " external references");
          segment = NO_SEG;
      }

      if (s) {
         add_reloc (s, realbytes, segment, segto);
         p = mydata;
         if (realbytes == 4)
            WRITELONG (p, *(long*)data - realbytes - s->length);
         else
            WRITESHORT (p, *(long*)data - realbytes - s->length);
         saa_wbytes (s->contents, mydata, realbytes);
         s->length += realbytes;
      } else {
         sec = find_section_by_name(".bss");
         if(!sec)
            error(ERR_PANIC, ".bss section is not present");
         sec->length += realbytes;
      }
   }
}

static void bin_deflabel (char *name, long segment, long offset,
           int is_global, char *special)
{
    (void) segment;   /* Don't warn that this parameter is unused */
    (void) offset;    /* Don't warn that this parameter is unused */

    if (special)
   error (ERR_NONFATAL, "binary format does not support any"
          " special symbol types");

    if (name[0] == '.' && name[1] == '.' && name[2] != '@') {
   error (ERR_NONFATAL, "unrecognised special symbol `%s'", name);
   return;
    }

    if (is_global == 2) {
   error (ERR_NONFATAL, "binary output format does not support common"
          " variables");
    }
}

static long bin_secname (char *name, int pass, int *bits)
{
    int sec_index;
    long *sec_align;
    char *p;
    struct Section *sec;

    (void) pass;   /* Don't warn that this parameter is unused */

    /*
     * Default is 16 bits .text segment
     */
   if (!name)
   {
      *bits = 16;
      sec = find_section_by_name(".text");
      if(!sec) sec = alloc_section(".text");
      sec->org = 0; /* default .text org */
      current_section = sec->index;
      return sec->index;
   }

   p = name;
   while (*p && !isspace(*p)) p++;
   if (*p) *p++ = '\0';
   if (!strcmp(name, ".text")) {
      sec = find_section_by_name(".text");
      if(!sec) sec = alloc_section(".text");
      sec_index = sec->index;
      sec_align = NULL;
   } else {
      sec = find_section_by_name(name);
      if(!sec) sec = alloc_section(name);
      sec_index = sec->index;
      sec_align = &sec->align;
   }

    if (*p) {
   if (!nasm_strnicmp(p,"align=",6)) {
       if (sec_align == NULL)
      error(ERR_NONFATAL, "cannot specify an alignment to"
            " the .text section");
       else if (p[6+strspn(p+6,"0123456789")])
      error(ERR_NONFATAL, "argument to `align' is not numeric");
       else {
      unsigned int align = atoi(p+6);
      if (!align || ((align-1) & align))
          error(ERR_NONFATAL, "argument to `align' is not a"
           " power of two");
      else
          *sec_align = align;
       }
    }
   }

   current_section = sec->index;
   return sec_index;
}

static long bin_segbase (long segment)
{
    return segment;
}

static int bin_directive (char *directive, char *value, int pass)
{
   struct Section *s;
   int rn_error;

   (void) pass;   /* Don't warn that this parameter is unused */

   if (!nasm_stricmp(directive, "org")) {
      if(current_section == -1)
         error(ERR_PANIC, "org of cosmic space specified");

      s = find_section_by_index(current_section);
      if(!s)
         error(ERR_PANIC, "current_section points nowhere");

      s->org = readnum (value, &rn_error);
      if (rn_error)
          error (ERR_NONFATAL, "argument to ORG should be numeric");
      return 1;
   }

   return 0;
}

static void bin_filename (char *inname, char *outname, efunc error)
{
    standard_extension (inname, outname, "", error);
}

static const char *bin_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%imacro org 1+.nolist",
    "[org %1]",
    "%endmacro",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static int bin_set_info(enum geninfo type, char **val)
{
    return 0;
}

struct ofmt of_bin = {
    "flat-form binary files (e.g. DOS .COM, .SYS) multisection support test",
    "bin",
    NULL,
    null_debug_arr,
    &null_debug_form,
    bin_stdmac,
    bin_init,
    bin_set_info,
    bin_out,
    bin_deflabel,
    bin_secname,
    bin_segbase,
    bin_directive,
    bin_filename,
    bin_cleanup
};

#endif /* OF_BIN */
