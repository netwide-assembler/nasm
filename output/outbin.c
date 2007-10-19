/* outbin.c output routines for the Netwide Assembler to produce
 *    flat-form binary files
 *
 * The Netwide Assembler is copyright (C) 1996 Simon Tatham and
 * Julian Hall. All rights reserved. The software is
 * redistributable under the licence given in the file "Licence"
 * distributed in the NASM archive.
 */

/* This is the extended version of NASM's original binary output
 * format.  It is backward compatible with the original BIN format,
 * and contains support for multiple sections and advanced section
 * ordering.
 *
 * Feature summary:
 *
 * - Users can create an arbitrary number of sections; they are not
 *   limited to just ".text", ".data", and ".bss".
 *
 * - Sections can be either progbits or nobits type.
 *
 * - You can specify that they be aligned at a certian boundary
 *   following the previous section ("align="), or positioned at an
 *   arbitrary byte-granular location ("start=").
 *
 * - You can specify a "virtual" start address for a section, which
 *   will be used for the calculation for all address references
 *   with respect to that section ("vstart=").
 *
 * - The ORG directive, as well as the section/segment directive
 *   arguments ("align=", "start=", "vstart="), can take a critical
 *   expression as their value.  For example: "align=(1 << 12)".
 *
 * - You can generate map files using the 'map' directive.
 *
 */

/* Uncomment the following define if you want sections to adapt
 * their progbits/nobits state depending on what type of
 * instructions are issued, rather than defaulting to progbits.
 * Note that this behavior violates the specification.

#define ABIN_SMART_ADAPT

*/

#include "compiler.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <inttypes.h>

#include "nasm.h"
#include "nasmlib.h"
#include "stdscan.h"
#include "labels.h"
#include "eval.h"
#include "outform.h"

#ifdef OF_BIN

struct ofmt *bin_get_ofmt();    /* Prototype goes here since no header file. */

static FILE *fp, *rf = NULL;
static efunc error;

/* Section flags keep track of which attributes the user has defined. */
#define START_DEFINED       0x001
#define ALIGN_DEFINED       0x002
#define FOLLOWS_DEFINED     0x004
#define VSTART_DEFINED      0x008
#define VALIGN_DEFINED      0x010
#define VFOLLOWS_DEFINED    0x020
#define TYPE_DEFINED        0x040
#define TYPE_PROGBITS       0x080
#define TYPE_NOBITS         0x100

/* This struct is used to keep track of symbols for map-file generation. */
static struct bin_label {
    char *name;
    struct bin_label *next;
} *no_seg_labels, **nsl_tail;

static struct Section {
    char *name;
    struct SAA *contents;
    int64_t length;                /* section length in bytes */

/* Section attributes */
    int flags;                  /* see flag definitions above */
    uint64_t align;        /* section alignment */
    uint64_t valign;       /* notional section alignment */
    uint64_t start;        /* section start address */
    uint64_t vstart;       /* section virtual start address */
    char *follows;              /* the section that this one will follow */
    char *vfollows;             /* the section that this one will notionally follow */
    int32_t start_index;           /* NASM section id for non-relocated version */
    int32_t vstart_index;          /* the NASM section id */

    struct bin_label *labels;   /* linked-list of label handles for map output. */
    struct bin_label **labels_end;      /* Holds address of end of labels list. */
    struct Section *ifollows;   /* Points to previous section (implicit follows). */
    struct Section *next;       /* This links sections with a defined start address. */

/* The extended bin format allows for sections to have a "virtual"
 * start address.  This is accomplished by creating two sections:
 * one beginning at the Load Memory Address and the other beginning
 * at the Virtual Memory Address.  The LMA section is only used to
 * define the section.<section_name>.start label, but there isn't
 * any other good way for us to handle that label.
 */

} *sections, *last_section;

static struct Reloc {
    struct Reloc *next;
    int32_t posn;
    int32_t bytes;
    int32_t secref;
    int32_t secrel;
    struct Section *target;
} *relocs, **reloctail;

extern char *stdscan_bufptr;

static uint8_t format_mode;       /* 0 = original bin, 1 = extended bin */
static int32_t current_section;    /* only really needed if format_mode = 0 */
static uint64_t origin;
static int origin_defined;

/* Stuff we need for map-file generation. */
#define MAP_ORIGIN       1
#define MAP_SUMMARY      2
#define MAP_SECTIONS     4
#define MAP_SYMBOLS      8
static int map_control = 0;
static char *infile, *outfile;

static const char *bin_stdmac[] = {
    "%define __SECT__ [section .text]",
    "%imacro org 1+.nolist",
    "[org %1]",
    "%endmacro",
    "%macro __NASM_CDecl__ 1",
    "%endmacro",
    NULL
};

static void add_reloc(struct Section *s, int32_t bytes, int32_t secref,
                      int32_t secrel)
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
        if (!strcmp(s->name, name))
            break;
    return s;
}

static struct Section *find_section_by_index(int32_t index)
{
    struct Section *s;

    for (s = sections; s; s = s->next)
        if ((index == s->vstart_index) || (index == s->start_index))
            break;
    return s;
}

static struct Section *create_section(char *name)
{                               /* Create a new section. */
    last_section->next = nasm_malloc(sizeof(struct Section));
    last_section->next->ifollows = last_section;
    last_section = last_section->next;
    last_section->labels = NULL;
    last_section->labels_end = &(last_section->labels);

    /* Initialize section attributes. */
    last_section->name = nasm_strdup(name);
    last_section->contents = saa_init(1L);
    last_section->follows = last_section->vfollows = 0;
    last_section->length = 0;
    last_section->flags = 0;
    last_section->next = NULL;

    /* Register our sections with NASM. */
    last_section->vstart_index = seg_alloc();
    last_section->start_index = seg_alloc();
    return last_section;
}

static void bin_cleanup(int debuginfo)
{
    struct Section *g, **gp;
    struct Section *gs = NULL, **gsp;
    struct Section *s, **sp;
    struct Section *nobits = NULL, **nt;
    struct Section *last_progbits;
    struct bin_label *l;
    struct Reloc *r;
    uint64_t pend;
    int h;

    (void)debuginfo;      /* placate optimizers */

#ifdef DEBUG
    fprintf(stdout,
            "bin_cleanup: Sections were initially referenced in this order:\n");
    for (h = 0, s = sections; s; h++, s = s->next)
        fprintf(stdout, "%i. %s\n", h, s->name);
#endif

    /* Assembly has completed, so now we need to generate the output file.
     * Step 1: Separate progbits and nobits sections into separate lists.
     * Step 2: Sort the progbits sections into their output order.
     * Step 3: Compute start addresses for all progbits sections.
     * Step 4: Compute vstart addresses for all sections.
     * Step 5: Apply relocations.
     * Step 6: Write the sections' data to the output file.
     * Step 7: Generate the map file.
     * Step 8: Release all allocated memory.
     */

    /* To do: Smart section-type adaptation could leave some empty sections
     * without a defined type (progbits/nobits).  Won't fix now since this
     * feature will be disabled.  */

    /* Step 1: Split progbits and nobits sections into separate lists. */

    nt = &nobits;
    /* Move nobits sections into a separate list.  Also pre-process nobits
     * sections' attributes. */
    for (sp = &sections->next, s = sections->next; s; s = *sp) {        /* Skip progbits sections. */
        if (s->flags & TYPE_PROGBITS) {
            sp = &s->next;
            continue;
        }
        /* Do some special pre-processing on nobits sections' attributes. */
        if (s->flags & (START_DEFINED | ALIGN_DEFINED | FOLLOWS_DEFINED)) {     /* Check for a mixture of real and virtual section attributes. */
            if (s->
                flags & (VSTART_DEFINED | VALIGN_DEFINED |
                         VFOLLOWS_DEFINED))
                error(ERR_FATAL,
                      "cannot mix real and virtual attributes"
                      " in nobits section (%s)", s->name);
            /* Real and virtual attributes mean the same thing for nobits sections. */
            if (s->flags & START_DEFINED) {
                s->vstart = s->start;
                s->flags |= VSTART_DEFINED;
            }
            if (s->flags & ALIGN_DEFINED) {
                s->valign = s->align;
                s->flags |= VALIGN_DEFINED;
            }
            if (s->flags & FOLLOWS_DEFINED) {
                s->vfollows = s->follows;
                s->flags |= VFOLLOWS_DEFINED;
                s->flags &= ~FOLLOWS_DEFINED;
            }
        }
        /* Every section must have a start address. */
        if (s->flags & VSTART_DEFINED) {
            s->start = s->vstart;
            s->flags |= START_DEFINED;
        }
        /* Move the section into the nobits list. */
        *sp = s->next;
        s->next = NULL;
        *nt = s;
        nt = &s->next;
    }

    /* Step 2: Sort the progbits sections into their output order. */

    /* In Step 2 we move around sections in groups.  A group
     * begins with a section (group leader) that has a user-
     * defined start address or follows section.  The remainder
     * of the group is made up of the sections that implicitly
     * follow the group leader (i.e., they were defined after
     * the group leader and were not given an explicit start
     * address or follows section by the user). */

    /* For anyone attempting to read this code:
     * g (group) points to a group of sections, the first one of which has
     *   a user-defined start address or follows section.
     * gp (g previous) holds the location of the pointer to g.
     * gs (g scan) is a temp variable that we use to scan to the end of the group.
     * gsp (gs previous) holds the location of the pointer to gs.
     * nt (nobits tail) points to the nobits section-list tail.
     */

    /* Link all 'follows' groups to their proper position.  To do
     * this we need to know three things: the start of the group
     * to relocate (g), the section it is following (s), and the
     * end of the group we're relocating (gs). */
    for (gp = &sections, g = sections; g; g = gs) {     /* Find the next follows group that is out of place (g). */
        if (!(g->flags & FOLLOWS_DEFINED)) {
            while (g->next) {
                if ((g->next->flags & FOLLOWS_DEFINED) &&
                    strcmp(g->name, g->next->follows))
                    break;
                g = g->next;
            }
            if (!g->next)
                break;
            gp = &g->next;
            g = g->next;
        }
        /* Find the section that this group follows (s). */
        for (sp = &sections, s = sections;
             s && strcmp(s->name, g->follows);
             sp = &s->next, s = s->next) ;
        if (!s)
            error(ERR_FATAL, "section %s follows an invalid or"
                  " unknown section (%s)", g->name, g->follows);
        if (s->next && (s->next->flags & FOLLOWS_DEFINED) &&
            !strcmp(s->name, s->next->follows))
            error(ERR_FATAL, "sections %s and %s can't both follow"
                  " section %s", g->name, s->next->name, s->name);
        /* Find the end of the current follows group (gs). */
        for (gsp = &g->next, gs = g->next;
             gs && (gs != s) && !(gs->flags & START_DEFINED);
             gsp = &gs->next, gs = gs->next) {
            if (gs->next && (gs->next->flags & FOLLOWS_DEFINED) &&
                strcmp(gs->name, gs->next->follows)) {
                gsp = &gs->next;
                gs = gs->next;
                break;
            }
        }
        /* Re-link the group after its follows section. */
        *gsp = s->next;
        s->next = g;
        *gp = gs;
    }

    /* Link all 'start' groups to their proper position.  Once
     * again we need to know g, s, and gs (see above).  The main
     * difference is we already know g since we sort by moving
     * groups from the 'unsorted' list into a 'sorted' list (g
     * will always be the first section in the unsorted list). */
    for (g = sections, sections = NULL; g; g = gs) {    /* Find the section that we will insert this group before (s). */
        for (sp = &sections, s = sections; s; sp = &s->next, s = s->next)
            if ((s->flags & START_DEFINED) && (g->start < s->start))
                break;
        /* Find the end of the group (gs). */
        for (gs = g->next, gsp = &g->next;
             gs && !(gs->flags & START_DEFINED);
             gsp = &gs->next, gs = gs->next) ;
        /* Re-link the group before the target section. */
        *sp = g;
        *gsp = s;
    }

    /* Step 3: Compute start addresses for all progbits sections. */

    /* Make sure we have an origin and a start address for the first section. */
    if (origin_defined)
        switch (sections->flags & (START_DEFINED | ALIGN_DEFINED)) {
        case START_DEFINED | ALIGN_DEFINED:
        case START_DEFINED:
            /* Make sure this section doesn't begin before the origin. */
            if (sections->start < origin)
                error(ERR_FATAL, "section %s begins"
                      " before program origin", sections->name);
            break;
        case ALIGN_DEFINED:
            sections->start = ((origin + sections->align - 1) &
                               ~(sections->align - 1));
            break;
        case 0:
            sections->start = origin;
    } else {
        if (!(sections->flags & START_DEFINED))
            sections->start = 0;
        origin = sections->start;
    }
    sections->flags |= START_DEFINED;

    /* Make sure each section has an explicit start address.  If it
     * doesn't, then compute one based its alignment and the end of
     * the previous section. */
    for (pend = sections->start, g = s = sections; g; g = g->next) {    /* Find the next section that could cause an overlap situation
                                                                         * (has a defined start address, and is not zero length). */
        if (g == s)
            for (s = g->next;
                 s && ((s->length == 0) || !(s->flags & START_DEFINED));
                 s = s->next) ;
        /* Compute the start address of this section, if necessary. */
        if (!(g->flags & START_DEFINED)) {      /* Default to an alignment of 4 if unspecified. */
            if (!(g->flags & ALIGN_DEFINED)) {
                g->align = 4;
                g->flags |= ALIGN_DEFINED;
            }
            /* Set the section start address. */
            g->start = (pend + g->align - 1) & ~(g->align - 1);
            g->flags |= START_DEFINED;
        }
        /* Ugly special case for progbits sections' virtual attributes:
         *   If there is a defined valign, but no vstart and no vfollows, then
         *   we valign after the previous progbits section.  This case doesn't
         *   really make much sense for progbits sections with a defined start
         *   address, but it is possible and we must do *something*.
         * Not-so-ugly special case:
         *   If a progbits section has no virtual attributes, we set the
         *   vstart equal to the start address.  */
        if (!(g->flags & (VSTART_DEFINED | VFOLLOWS_DEFINED))) {
            if (g->flags & VALIGN_DEFINED)
                g->vstart = (pend + g->valign - 1) & ~(g->valign - 1);
            else
                g->vstart = g->start;
            g->flags |= VSTART_DEFINED;
        }
        /* Ignore zero-length sections. */
        if (g->start < pend)
            continue;
        /* Compute the span of this section. */
        pend = g->start + g->length;
        /* Check for section overlap. */
        if (s) {
            if (g->start > s->start)
                error(ERR_FATAL, "sections %s ~ %s and %s overlap!",
                      gs->name, g->name, s->name);
            if (pend > s->start)
                error(ERR_FATAL, "sections %s and %s overlap!",
                      g->name, s->name);
        }
        /* Remember this section as the latest >0 length section. */
        gs = g;
    }

    /* Step 4: Compute vstart addresses for all sections. */

    /* Attach the nobits sections to the end of the progbits sections. */
    for (s = sections; s->next; s = s->next) ;
    s->next = nobits;
    last_progbits = s;
    /* Scan for sections that don't have a vstart address.  If we find one we'll
     * attempt to compute its vstart.  If we can't compute the vstart, we leave
     * it alone and come back to it in a subsequent scan.  We continue scanning
     * and re-scanning until we've gone one full cycle without computing any
     * vstarts. */
    do {                        /* Do one full scan of the sections list. */
        for (h = 0, g = sections; g; g = g->next) {
            if (g->flags & VSTART_DEFINED)
                continue;
            /* Find the section that this one virtually follows.  */
            if (g->flags & VFOLLOWS_DEFINED) {
                for (s = sections; s && strcmp(g->vfollows, s->name);
                     s = s->next) ;
                if (!s)
                    error(ERR_FATAL,
                          "section %s vfollows unknown section (%s)",
                          g->name, g->vfollows);
            } else if (g->ifollows != NULL)
                for (s = sections; s && (s != g->ifollows); s = s->next) ;
            /* The .bss section is the only one with ifollows = NULL.  In this case we
             * implicitly follow the last progbits section.  */
            else
                s = last_progbits;

            /* If the section we're following has a vstart, we can proceed. */
            if (s->flags & VSTART_DEFINED) {    /* Default to virtual alignment of four. */
                if (!(g->flags & VALIGN_DEFINED)) {
                    g->valign = 4;
                    g->flags |= VALIGN_DEFINED;
                }
                /* Compute the vstart address. */
                g->vstart =
                    (s->vstart + s->length + g->valign - 1) & ~(g->valign -
                                                                1);
               g->flags |= VSTART_DEFINED;
                h++;
                /* Start and vstart mean the same thing for nobits sections. */
                if (g->flags & TYPE_NOBITS)
                    g->start = g->vstart;
            }
        }
    } while (h);

    /* Now check for any circular vfollows references, which will manifest
     * themselves as sections without a defined vstart. */
    for (h = 0, s = sections; s; s = s->next) {
        if (!(s->flags & VSTART_DEFINED)) {     /* Non-fatal errors after assembly has completed are generally a
                                                 * no-no, but we'll throw a fatal one eventually so it's ok.  */
            error(ERR_NONFATAL, "cannot compute vstart for section %s",
                  s->name);
            h++;
        }
    }
    if (h)
        error(ERR_FATAL, "circular vfollows path detected");

#ifdef DEBUG
    fprintf(stdout,
            "bin_cleanup: Confirm final section order for output file:\n");
    for (h = 0, s = sections; s && (s->flags & TYPE_PROGBITS);
         h++, s = s->next)
        fprintf(stdout, "%i. %s\n", h, s->name);
#endif

    /* Step 5: Apply relocations. */

    /* Prepare the sections for relocating. */
    for (s = sections; s; s = s->next)
        saa_rewind(s->contents);
    /* Apply relocations. */
    for (r = relocs; r; r = r->next) {
        uint8_t *p, *q, mydata[8];
        int64_t l;

        saa_fread(r->target->contents, r->posn, mydata, r->bytes);
        p = q = mydata;
        l = *p++;

        if (r->bytes > 1) {
            l += ((int64_t)*p++) << 8;
            if (r->bytes >= 4) {
                l += ((int64_t)*p++) << 16;
                l += ((int64_t)*p++) << 24;
            }
            if (r->bytes == 8) {
                l += ((int64_t)*p++) << 32;
                l += ((int64_t)*p++) << 40;
                l += ((int64_t)*p++) << 48;
                l += ((int64_t)*p++) << 56;
            }
        }

        s = find_section_by_index(r->secref);
        if (s) {
            if (r->secref == s->start_index)
                l += s->start;
            else
                l += s->vstart;
        }
        s = find_section_by_index(r->secrel);
        if (s) {
            if (r->secrel == s->start_index)
                l -= s->start;
            else
                l -= s->vstart;
        }

        if (r->bytes >= 4)
            WRITEDLONG(q, l);
        else if (r->bytes == 2)
            WRITESHORT(q, l);
        else
            *q++ = (uint8_t)(l & 0xFF);
        saa_fwrite(r->target->contents, r->posn, mydata, r->bytes);
    }

    /* Step 6: Write the section data to the output file. */

    /* Write the progbits sections to the output file. */
    for (pend = origin, s = sections; s && (s->flags & TYPE_PROGBITS); s = s->next) {   /* Skip zero-length sections. */
        if (s->length == 0)
            continue;
        /* Pad the space between sections. */
        for (h = s->start - pend; h; h--)
            fputc('\0', fp);
        /* Write the section to the output file. */
        if (s->length > 0)
            saa_fpwrite(s->contents, fp);
        pend = s->start + s->length;
    }
    /* Done writing the file, so close it. */
    fclose(fp);

    /* Step 7: Generate the map file. */

    if (map_control) {
        const char *not_defined = { "not defined" };

        /* Display input and output file names. */
        fprintf(rf, "\n- NASM Map file ");
        for (h = 63; h; h--)
            fputc('-', rf);
        fprintf(rf, "\n\nSource file:  %s\nOutput file:  %s\n\n",
                infile, outfile);

        if (map_control & MAP_ORIGIN) { /* Display program origin. */
            fprintf(rf, "-- Program origin ");
            for (h = 61; h; h--)
                fputc('-', rf);
            fprintf(rf, "\n\n%08"PRIX64"\n\n", origin);
        }
        /* Display sections summary. */
        if (map_control & MAP_SUMMARY) {
            fprintf(rf, "-- Sections (summary) ");
            for (h = 57; h; h--)
                fputc('-', rf);
            fprintf(rf, "\n\nVstart            Start             Stop              "
                    "Length    Class     Name\n");
            for (s = sections; s; s = s->next) {
                fprintf(rf, "%16"PRIX64"  %16"PRIX64"  %16"PRIX64"  %08"PRIX64"  ",
                        s->vstart, s->start, s->start + s->length,
                        s->length);
                if (s->flags & TYPE_PROGBITS)
                    fprintf(rf, "progbits  ");
                else
                    fprintf(rf, "nobits    ");
                fprintf(rf, "%s\n", s->name);
            }
            fprintf(rf, "\n");
        }
        /* Display detailed section information. */
        if (map_control & MAP_SECTIONS) {
            fprintf(rf, "-- Sections (detailed) ");
            for (h = 56; h; h--)
                fputc('-', rf);
            fprintf(rf, "\n\n");
            for (s = sections; s; s = s->next) {
                fprintf(rf, "---- Section %s ", s->name);
                for (h = 65 - strlen(s->name); h; h--)
                    fputc('-', rf);
                fprintf(rf, "\n\nclass:     ");
                if (s->flags & TYPE_PROGBITS)
                    fprintf(rf, "progbits");
                else
                    fprintf(rf, "nobits");
                fprintf(rf, "\nlength:    %16"PRIX64"\nstart:     %16"PRIX64""
                        "\nalign:     ", s->length, s->start);
                if (s->flags & ALIGN_DEFINED)
                    fprintf(rf, "%16"PRIX64"", s->align);
                else
                    fprintf(rf, not_defined);
                fprintf(rf, "\nfollows:   ");
                if (s->flags & FOLLOWS_DEFINED)
                    fprintf(rf, "%s", s->follows);
                else
                    fprintf(rf, not_defined);
                fprintf(rf, "\nvstart:    %16"PRIX64"\nvalign:    ", s->vstart);
                if (s->flags & VALIGN_DEFINED)
                    fprintf(rf, "%16"PRIX64"", s->valign);
                else
                    fprintf(rf, not_defined);
                fprintf(rf, "\nvfollows:  ");
                if (s->flags & VFOLLOWS_DEFINED)
                    fprintf(rf, "%s", s->vfollows);
                else
                    fprintf(rf, not_defined);
                fprintf(rf, "\n\n");
            }
        }
        /* Display symbols information. */
        if (map_control & MAP_SYMBOLS) {
            int32_t segment, offset;

            fprintf(rf, "-- Symbols ");
            for (h = 68; h; h--)
                fputc('-', rf);
            fprintf(rf, "\n\n");
            if (no_seg_labels) {
                fprintf(rf, "---- No Section ");
                for (h = 63; h; h--)
                    fputc('-', rf);
                fprintf(rf, "\n\nValue     Name\n");
                for (l = no_seg_labels; l; l = l->next) {
                    lookup_label(l->name, &segment, &offset);
                    fprintf(rf, "%08"PRIX32"  %s\n", offset, l->name);
                }
                fprintf(rf, "\n\n");
            }
            for (s = sections; s; s = s->next) {
                if (s->labels) {
                    fprintf(rf, "---- Section %s ", s->name);
                    for (h = 65 - strlen(s->name); h; h--)
                        fputc('-', rf);
                    fprintf(rf, "\n\nReal              Virtual           Name\n");
                    for (l = s->labels; l; l = l->next) {
                        lookup_label(l->name, &segment, &offset);
                        fprintf(rf, "%16"PRIX64"  %16"PRIX64"  %s\n",
                                s->start + offset, s->vstart + offset,
                                l->name);
                    }
                    fprintf(rf, "\n");
                }
            }
        }
    }

    /* Close the report file. */
    if (map_control && (rf != stdout) && (rf != stderr))
        fclose(rf);

    /* Step 8: Release all allocated memory. */

    /* Free sections, label pointer structs, etc.. */
    while (sections) {
        s = sections;
        sections = s->next;
        saa_free(s->contents);
        nasm_free(s->name);
        if (s->flags & FOLLOWS_DEFINED)
            nasm_free(s->follows);
        if (s->flags & VFOLLOWS_DEFINED)
            nasm_free(s->vfollows);
        while (s->labels) {
            l = s->labels;
            s->labels = l->next;
            nasm_free(l);
        }
        nasm_free(s);
    }

    /* Free no-section labels. */
    while (no_seg_labels) {
        l = no_seg_labels;
        no_seg_labels = l->next;
        nasm_free(l);
    }

    /* Free relocation structures. */
    while (relocs) {
        r = relocs->next;
        nasm_free(relocs);
        relocs = r;
    }
}

static void bin_out(int32_t segto, const void *data, uint32_t type,
                    int32_t segment, int32_t wrt)
{
    uint8_t *p, mydata[8];
    struct Section *s;
    int32_t realbytes;


    if (wrt != NO_SEG) {
        wrt = NO_SEG;           /* continue to do _something_ */
        error(ERR_NONFATAL, "WRT not supported by binary output format");
    }

    /* Handle absolute-assembly (structure definitions). */
    if (segto == NO_SEG) {
        if ((type & OUT_TYPMASK) != OUT_RESERVE)
            error(ERR_NONFATAL, "attempt to assemble code in"
                  " [ABSOLUTE] space");
        return;
    }

    /* Find the segment we are targeting. */
    s = find_section_by_index(segto);
    if (!s)
        error(ERR_PANIC, "code directed to nonexistent segment?");

    /* "Smart" section-type adaptation code. */
    if (!(s->flags & TYPE_DEFINED)) {
        if ((type & OUT_TYPMASK) == OUT_RESERVE)
            s->flags |= TYPE_DEFINED | TYPE_NOBITS;
        else
            s->flags |= TYPE_DEFINED | TYPE_PROGBITS;
    }

    if ((s->flags & TYPE_NOBITS) && ((type & OUT_TYPMASK) != OUT_RESERVE))
        error(ERR_WARNING, "attempt to initialize memory in a"
              " nobits section: ignored");

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
        if (s->flags & TYPE_PROGBITS) {
            if (segment != NO_SEG)
                add_reloc(s, type & OUT_SIZMASK, segment, -1L);
            p = mydata;
            if ((type & OUT_SIZMASK) == 4)
                WRITELONG(p, *(int32_t *)data);
            else if ((type & OUT_SIZMASK) == 8)
                WRITEDLONG(p, *(int64_t *)data);
            else
                WRITESHORT(p, *(int32_t *)data);
            saa_wbytes(s->contents, mydata, type & OUT_SIZMASK);
        }
        s->length += type & OUT_SIZMASK;
    } else if ((type & OUT_TYPMASK) == OUT_RAWDATA) {
        type &= OUT_SIZMASK;
        if (s->flags & TYPE_PROGBITS)
            saa_wbytes(s->contents, data, type);
        s->length += type;
    } else if ((type & OUT_TYPMASK) == OUT_RESERVE) {
        type &= OUT_SIZMASK;
        if (s->flags & TYPE_PROGBITS) {
            error(ERR_WARNING, "uninitialized space declared in"
                  " %s section: zeroing", s->name);
            saa_wbytes(s->contents, NULL, type);
        }
        s->length += type;
    } else if ((type & OUT_TYPMASK) == OUT_REL2ADR ||
               (type & OUT_TYPMASK) == OUT_REL4ADR) {
        realbytes = (type & OUT_TYPMASK);
        if (realbytes == OUT_REL2ADR)
            realbytes = 2;
        else
            realbytes = 4;
        if (segment != NO_SEG && !find_section_by_index(segment)) {
            if (segment % 2)
                error(ERR_NONFATAL, "binary output format does not support"
                      " segment base references");
            else
                error(ERR_NONFATAL, "binary output format does not support"
                      " external references");
            segment = NO_SEG;
        }
        if (s->flags & TYPE_PROGBITS) {
            add_reloc(s, realbytes, segment, segto);
            p = mydata;
            if (realbytes == 4)
                WRITELONG(p, *(int32_t *)data - realbytes - s->length);
            else
                WRITESHORT(p, *(int32_t *)data - realbytes - s->length);
            saa_wbytes(s->contents, mydata, realbytes);
        }
        s->length += realbytes;
    }
}

static void bin_deflabel(char *name, int32_t segment, int32_t offset,
                         int is_global, char *special)
{
    (void)segment;              /* Don't warn that this parameter is unused */
    (void)offset;               /* Don't warn that this parameter is unused */

    if (special)
        error(ERR_NONFATAL, "binary format does not support any"
              " special symbol types");
    else if (name[0] == '.' && name[1] == '.' && name[2] != '@')
        error(ERR_NONFATAL, "unrecognised special symbol `%s'", name);
    else if (is_global == 2)
        error(ERR_NONFATAL, "binary output format does not support common"
              " variables");
    else {
        struct Section *s;
        struct bin_label ***ltp;

        /* Remember label definition so we can look it up later when
         * creating the map file. */
        s = find_section_by_index(segment);
        if (s)
            ltp = &(s->labels_end);
        else
            ltp = &nsl_tail;
        (**ltp) = nasm_malloc(sizeof(struct bin_label));
        (**ltp)->name = name;
        (**ltp)->next = NULL;
        *ltp = &((**ltp)->next);
    }

}

/* These constants and the following function are used
 * by bin_secname() to parse attribute assignments. */

enum { ATTRIB_START, ATTRIB_ALIGN, ATTRIB_FOLLOWS,
    ATTRIB_VSTART, ATTRIB_VALIGN, ATTRIB_VFOLLOWS,
    ATTRIB_NOBITS, ATTRIB_PROGBITS
};

static int bin_read_attribute(char **line, int *attribute,
                              uint64_t *value)
{
    expr *e;
    int attrib_name_size;
    struct tokenval tokval;
    char *exp;

    /* Skip whitespace. */
    while (**line && isspace(**line))
        (*line)++;
    if (!**line)
        return 0;

    /* Figure out what attribute we're reading. */
    if (!nasm_strnicmp(*line, "align=", 6)) {
        *attribute = ATTRIB_ALIGN;
        attrib_name_size = 6;
    } else if (format_mode) {
        if (!nasm_strnicmp(*line, "start=", 6)) {
            *attribute = ATTRIB_START;
            attrib_name_size = 6;
        } else if (!nasm_strnicmp(*line, "follows=", 8)) {
            *attribute = ATTRIB_FOLLOWS;
            *line += 8;
            return 1;
        } else if (!nasm_strnicmp(*line, "vstart=", 7)) {
            *attribute = ATTRIB_VSTART;
            attrib_name_size = 7;
        } else if (!nasm_strnicmp(*line, "valign=", 7)) {
            *attribute = ATTRIB_VALIGN;
            attrib_name_size = 7;
        } else if (!nasm_strnicmp(*line, "vfollows=", 9)) {
            *attribute = ATTRIB_VFOLLOWS;
            *line += 9;
            return 1;
        } else if (!nasm_strnicmp(*line, "nobits", 6) &&
                   (isspace((*line)[6]) || ((*line)[6] == '\0'))) {
            *attribute = ATTRIB_NOBITS;
            *line += 6;
            return 1;
        } else if (!nasm_strnicmp(*line, "progbits", 8) &&
                   (isspace((*line)[8]) || ((*line)[8] == '\0'))) {
            *attribute = ATTRIB_PROGBITS;
            *line += 8;
            return 1;
        } else
            return 0;
    } else
        return 0;

    /* Find the end of the expression. */
    if ((*line)[attrib_name_size] != '(') {
        /* Single term (no parenthesis). */
        exp = *line += attrib_name_size;
        while (**line && !isspace(**line))
            (*line)++;
        if (**line) {
            **line = '\0';
            (*line)++;
        }
    } else {
        char c;
        int pcount = 1;

        /* Full expression (delimited by parenthesis) */
        exp = *line += attrib_name_size + 1;
        while (1) {
            (*line) += strcspn(*line, "()'\"");
            if (**line == '(') {
                ++(*line);
                ++pcount;
            }
            if (**line == ')') {
                ++(*line);
                --pcount;
                if (!pcount)
                    break;
            }
            if ((**line == '"') || (**line == '\'')) {
                c = **line;
                while (**line) {
                    ++(*line);
                    if (**line == c)
                        break;
                }
                if (!**line) {
                    error(ERR_NONFATAL,
                          "invalid syntax in `section' directive");
                    return -1;
                }
                ++(*line);
            }
            if (!**line) {
                error(ERR_NONFATAL, "expecting `)'");
                return -1;
            }
        }
        *(*line - 1) = '\0';    /* Terminate the expression. */
    }

    /* Check for no value given. */
    if (!*exp) {
        error(ERR_WARNING, "No value given to attribute in"
              " `section' directive");
        return -1;
    }

    /* Read and evaluate the expression. */
    stdscan_reset();
    stdscan_bufptr = exp;
    tokval.t_type = TOKEN_INVALID;
    e = evaluate(stdscan, NULL, &tokval, NULL, 1, error, NULL);
    if (e) {
        if (!is_really_simple(e)) {
            error(ERR_NONFATAL, "section attribute value must be"
                  " a critical expression");
            return -1;
        }
    } else {
        error(ERR_NONFATAL, "Invalid attribute value"
              " specified in `section' directive.");
        return -1;
    }
    *value = (uint64_t)reloc_value(e);
    return 1;
}

static void bin_assign_attributes(struct Section *sec, char *astring)
{
    int attribute, check;
    uint64_t value;
    char *p;

    while (1) {                 /* Get the next attribute. */
        check = bin_read_attribute(&astring, &attribute, &value);
        /* Skip bad attribute. */
        if (check == -1)
            continue;
        /* Unknown section attribute, so skip it and warn the user. */
        if (!check) {
            if (!*astring)
                break;          /* End of line. */
            else {
                p = astring;
                while (*astring && !isspace(*astring))
                    astring++;
                if (*astring) {
                    *astring = '\0';
                    astring++;
                }
                error(ERR_WARNING, "ignoring unknown section attribute:"
                      " \"%s\"", p);
            }
            continue;
        }

        switch (attribute) {    /* Handle nobits attribute. */
        case ATTRIB_NOBITS:
            if ((sec->flags & TYPE_DEFINED)
                && (sec->flags & TYPE_PROGBITS))
                error(ERR_NONFATAL,
                      "attempt to change section type"
                      " from progbits to nobits");
            else
                sec->flags |= TYPE_DEFINED | TYPE_NOBITS;
            continue;

            /* Handle progbits attribute. */
        case ATTRIB_PROGBITS:
            if ((sec->flags & TYPE_DEFINED) && (sec->flags & TYPE_NOBITS))
                error(ERR_NONFATAL, "attempt to change section type"
                      " from nobits to progbits");
            else
                sec->flags |= TYPE_DEFINED | TYPE_PROGBITS;
            continue;

            /* Handle align attribute. */
        case ATTRIB_ALIGN:
            if (!format_mode && (!strcmp(sec->name, ".text")))
                error(ERR_NONFATAL, "cannot specify an alignment"
                      " to the .text section");
            else {
                if (!value || ((value - 1) & value))
                    error(ERR_NONFATAL, "argument to `align' is not a"
                          " power of two");
                else {          /* Alignment is already satisfied if the previous
                                 * align value is greater. */
                    if ((sec->flags & ALIGN_DEFINED)
                        && (value < sec->align))
                        value = sec->align;

                    /* Don't allow a conflicting align value. */
                    if ((sec->flags & START_DEFINED)
                        && (sec->start & (value - 1)))
                        error(ERR_NONFATAL,
                              "`align' value conflicts "
                              "with section start address");
                    else {
                        sec->align = value;
                        sec->flags |= ALIGN_DEFINED;
                    }
                }
            }
            continue;

            /* Handle valign attribute. */
        case ATTRIB_VALIGN:
            if (!value || ((value - 1) & value))
                error(ERR_NONFATAL, "argument to `valign' is not a"
                      " power of two");
            else {              /* Alignment is already satisfied if the previous
                                 * align value is greater. */
                if ((sec->flags & VALIGN_DEFINED) && (value < sec->valign))
                    value = sec->valign;

                /* Don't allow a conflicting valign value. */
                if ((sec->flags & VSTART_DEFINED)
                    && (sec->vstart & (value - 1)))
                    error(ERR_NONFATAL,
                          "`valign' value conflicts "
                          "with `vstart' address");
                else {
                    sec->valign = value;
                    sec->flags |= VALIGN_DEFINED;
                }
            }
            continue;

            /* Handle start attribute. */
        case ATTRIB_START:
            if (sec->flags & FOLLOWS_DEFINED)
                error(ERR_NONFATAL, "cannot combine `start' and `follows'"
                      " section attributes");
            else if ((sec->flags & START_DEFINED) && (value != sec->start))
                error(ERR_NONFATAL, "section start address redefined");
            else {
                sec->start = value;
                sec->flags |= START_DEFINED;
                if (sec->flags & ALIGN_DEFINED) {
                    if (sec->start & (sec->align - 1))
                        error(ERR_NONFATAL, "`start' address conflicts"
                              " with section alignment");
                    sec->flags ^= ALIGN_DEFINED;
                }
            }
            continue;

            /* Handle vstart attribute. */
        case ATTRIB_VSTART:
            if (sec->flags & VFOLLOWS_DEFINED)
                error(ERR_NONFATAL,
                      "cannot combine `vstart' and `vfollows'"
                      " section attributes");
            else if ((sec->flags & VSTART_DEFINED)
                     && (value != sec->vstart))
                error(ERR_NONFATAL,
                      "section virtual start address"
                      " (vstart) redefined");
            else {
                sec->vstart = value;
                sec->flags |= VSTART_DEFINED;
                if (sec->flags & VALIGN_DEFINED) {
                    if (sec->vstart & (sec->valign - 1))
                        error(ERR_NONFATAL, "`vstart' address conflicts"
                              " with `valign' value");
                    sec->flags ^= VALIGN_DEFINED;
                }
            }
            continue;

            /* Handle follows attribute. */
        case ATTRIB_FOLLOWS:
            p = astring;
            astring += strcspn(astring, " \t");
            if (astring == p)
                error(ERR_NONFATAL, "expecting section name for `follows'"
                      " attribute");
            else {
                *(astring++) = '\0';
                if (sec->flags & START_DEFINED)
                    error(ERR_NONFATAL,
                          "cannot combine `start' and `follows'"
                          " section attributes");
                sec->follows = nasm_strdup(p);
                sec->flags |= FOLLOWS_DEFINED;
            }
            continue;

            /* Handle vfollows attribute. */
        case ATTRIB_VFOLLOWS:
            if (sec->flags & VSTART_DEFINED)
                error(ERR_NONFATAL,
                      "cannot combine `vstart' and `vfollows'"
                      " section attributes");
            else {
                p = astring;
                astring += strcspn(astring, " \t");
                if (astring == p)
                    error(ERR_NONFATAL,
                          "expecting section name for `vfollows'"
                          " attribute");
                else {
                    *(astring++) = '\0';
                    sec->vfollows = nasm_strdup(p);
                    sec->flags |= VFOLLOWS_DEFINED;
                }
            }
            continue;
        }
    }
}

static void bin_define_section_labels(void)
{
    static int labels_defined = 0;
    struct Section *sec;
    char *label_name;
    size_t base_len;

    if (labels_defined)
        return;
    for (sec = sections; sec; sec = sec->next) {
        base_len = strlen(sec->name) + 8;
        label_name = nasm_malloc(base_len + 8);
        strcpy(label_name, "section.");
        strcpy(label_name + 8, sec->name);

        /* section.<name>.start */
        strcpy(label_name + base_len, ".start");
        define_label(label_name, sec->start_index, 0L,
                     NULL, 0, 0, bin_get_ofmt(), error);

        /* section.<name>.vstart */
        strcpy(label_name + base_len, ".vstart");
        define_label(label_name, sec->vstart_index, 0L,
                     NULL, 0, 0, bin_get_ofmt(), error);

        nasm_free(label_name);
    }
    labels_defined = 1;
}

static int32_t bin_secname(char *name, int pass, int *bits)
{
    char *p;
    struct Section *sec;

    /* bin_secname is called with *name = NULL at the start of each
     * pass.  Use this opportunity to establish the default section
     * (default is BITS-16 ".text" segment).
     */
    if (!name) {                /* Reset ORG and section attributes at the start of each pass. */
        origin_defined = 0;
        for (sec = sections; sec; sec = sec->next)
            sec->flags &= ~(START_DEFINED | VSTART_DEFINED |
                            ALIGN_DEFINED | VALIGN_DEFINED);

        /* Define section start and vstart labels. */
        if (format_mode && (pass != 1))
            bin_define_section_labels();

        /* Establish the default (.text) section. */
        *bits = 16;
        sec = find_section_by_name(".text");
        sec->flags |= TYPE_DEFINED | TYPE_PROGBITS;
        current_section = sec->vstart_index;
        return current_section;
    }

    /* Attempt to find the requested section.  If it does not
     * exist, create it. */
    p = name;
    while (*p && !isspace(*p))
        p++;
    if (*p)
        *p++ = '\0';
    sec = find_section_by_name(name);
    if (!sec) {
        sec = create_section(name);
        if (!strcmp(name, ".data"))
            sec->flags |= TYPE_DEFINED | TYPE_PROGBITS;
        else if (!strcmp(name, ".bss")) {
            sec->flags |= TYPE_DEFINED | TYPE_NOBITS;
            sec->ifollows = NULL;
        } else if (!format_mode) {
            error(ERR_NONFATAL, "section name must be "
                  ".text, .data, or .bss");
            return current_section;
        }
    }

    /* Handle attribute assignments. */
    if (pass != 1)
        bin_assign_attributes(sec, p);

#ifndef ABIN_SMART_ADAPT
    /* The following line disables smart adaptation of
     * PROGBITS/NOBITS section types (it forces sections to
     * default to PROGBITS). */
    if ((pass != 1) && !(sec->flags & TYPE_DEFINED))
        sec->flags |= TYPE_DEFINED | TYPE_PROGBITS;
#endif

    /* Set the current section and return. */
    current_section = sec->vstart_index;
    return current_section;
}

static int bin_directive(char *directive, char *args, int pass)
{
    /* Handle ORG directive */
    if (!nasm_stricmp(directive, "org")) {
        struct tokenval tokval;
        uint64_t value;
        expr *e;

        stdscan_reset();
        stdscan_bufptr = args;
        tokval.t_type = TOKEN_INVALID;
        e = evaluate(stdscan, NULL, &tokval, NULL, 1, error, NULL);
        if (e) {
            if (!is_really_simple(e))
                error(ERR_NONFATAL, "org value must be a critical"
                      " expression");
            else {
                value = reloc_value(e);
                /* Check for ORG redefinition. */
                if (origin_defined && (value != origin))
                    error(ERR_NONFATAL, "program origin redefined");
                else {
                    origin = value;
                    origin_defined = 1;
                }
            }
        } else
            error(ERR_NONFATAL, "No or invalid offset specified"
                  " in ORG directive.");
        return 1;
    }

    /* The 'map' directive allows the user to generate section
     * and symbol information to stdout, stderr, or to a file. */
    else if (format_mode && !nasm_stricmp(directive, "map")) {
        char *p;

        if (pass != 1)
            return 1;
        args += strspn(args, " \t");
        while (*args) {
            p = args;
            args += strcspn(args, " \t");
            if (*args != '\0')
                *(args++) = '\0';
            if (!nasm_stricmp(p, "all"))
                map_control |=
                    MAP_ORIGIN | MAP_SUMMARY | MAP_SECTIONS | MAP_SYMBOLS;
            else if (!nasm_stricmp(p, "brief"))
                map_control |= MAP_ORIGIN | MAP_SUMMARY;
            else if (!nasm_stricmp(p, "sections"))
                map_control |= MAP_ORIGIN | MAP_SUMMARY | MAP_SECTIONS;
            else if (!nasm_stricmp(p, "segments"))
                map_control |= MAP_ORIGIN | MAP_SUMMARY | MAP_SECTIONS;
            else if (!nasm_stricmp(p, "symbols"))
                map_control |= MAP_SYMBOLS;
            else if (!rf) {
                if (!nasm_stricmp(p, "stdout"))
                    rf = stdout;
                else if (!nasm_stricmp(p, "stderr"))
                    rf = stderr;
                else {          /* Must be a filename. */
                    rf = fopen(p, "wt");
                    if (!rf) {
                        error(ERR_WARNING, "unable to open map file `%s'",
                              p);
                        map_control = 0;
                        return 1;
                    }
                }
            } else
                error(ERR_WARNING, "map file already specified");
        }
        if (map_control == 0)
            map_control |= MAP_ORIGIN | MAP_SUMMARY;
        if (!rf)
            rf = stdout;
        return 1;
    }
    return 0;
}

static void bin_filename(char *inname, char *outname, efunc error)
{
    standard_extension(inname, outname, "", error);
    infile = inname;
    outfile = outname;
}

static int32_t bin_segbase(int32_t segment)
{
    return segment;
}

static int bin_set_info(enum geninfo type, char **val)
{
    (void)type;
    (void)val;
    return 0;
}

static void bin_init(FILE * afp, efunc errfunc, ldfunc ldef, evalfunc eval)
{
    fp = afp;
    error = errfunc;

    (void)eval;                 /* Don't warn that this parameter is unused. */
    (void)ldef;                 /* Placate optimizers. */

    maxbits = 64;               /* Support 64-bit Segments */
    relocs = NULL;
    reloctail = &relocs;
    origin_defined = 0;
    no_seg_labels = NULL;
    nsl_tail = &no_seg_labels;
    format_mode = 1;            /* Extended bin format
                                 * (set this to zero for old bin format). */

    /* Create default section (.text). */
    sections = last_section = nasm_malloc(sizeof(struct Section));
    last_section->next = NULL;
    last_section->name = nasm_strdup(".text");
    last_section->contents = saa_init(1L);
    last_section->follows = last_section->vfollows = 0;
    last_section->ifollows = NULL;
    last_section->length = 0;
    last_section->flags = TYPE_DEFINED | TYPE_PROGBITS;
    last_section->labels = NULL;
    last_section->labels_end = &(last_section->labels);
    last_section->start_index = seg_alloc();
    last_section->vstart_index = current_section = seg_alloc();
}

struct ofmt of_bin = {
    "flat-form binary files (e.g. DOS .COM, .SYS)",
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

/* This is needed for bin_define_section_labels() */
struct ofmt *bin_get_ofmt(void)
{
    return &of_bin;
}

#endif                          /* #ifdef OF_BIN */
