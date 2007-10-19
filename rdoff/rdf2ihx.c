/*
 * rdf2ihx.c - convert an RDOFF object file to Intel Hex format.
 * This is based on rdf2bin.
 * Note that this program only writes 16-bit HEX.
 */

#include "compiler.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "rdfload.h"
#include "nasmlib.h"
#include "symtab.h"

int32_t origin = 0;
int align = 16;

/* This function writes a single n-byte data record to of.  Maximum value
   for n is 255. */
static int write_data_record(FILE * of, int ofs, int nbytes,
                             uint8_t *data)
{
    int i, iofs;
    unsigned int checksum;

    iofs = ofs;
    fprintf(of, ":%02X%04X00", nbytes, ofs);
    checksum = 0;
    for (i = 0; i < nbytes; i++) {
        fprintf(of, "%02X", data[i]);
        ofs++;
        checksum += data[i];
    }
    checksum = checksum +       /* current checksum */
        nbytes +                /* RECLEN (one byte) */
        ((iofs >> 8) & 0xff) +  /* high byte of load offset */
        (iofs & 0xff);          /* low byte of load offset */
    checksum = ~checksum + 1;
    fprintf(of, "%02X\n", checksum & 0xff);
    return (ofs);
}

int main(int argc, char **argv)
{
    rdfmodule *m;
    bool err;
    FILE *of;
    char *padding;
    uint8_t *segbin[2];
    int pad[2], segn, ofs, i;
    int32_t segaddr;
    unsigned int checksum;
    symtabEnt *s;

    if (argc < 2) {
        puts("Usage: rdf2ihx [-o relocation-origin] [-p segment-alignment] " "input-file  output-file");
        return (1);
    }

    argv++, argc--;

    while (argc > 2) {
        if (strcmp(*argv, "-o") == 0) {
            argv++, argc--;
            origin = readnum(*argv, &err);
            if (err) {
                fprintf(stderr, "rdf2ihx: invalid parameter: %s\n", *argv);
                return 1;
            }
        } else if (strcmp(*argv, "-p") == 0) {
            argv++, argc--;
            align = readnum(*argv, &err);
            if (err) {
                fprintf(stderr, "rdf2ihx: invalid parameter: %s\n", *argv);
                return 1;
            }
        } else
            break;
        argv++, argc--;
    }
    if (argc < 2) {
        puts("rdf2ihx: required parameter missing");
        return -1;
    }
    m = rdfload(*argv);

    if (!m) {
        rdfperror("rdf2ihx", *argv);
        return 1;
    }
    printf("relocating %s: origin=%"PRIx32", align=%d\n", *argv, origin, align);

    m->textrel = origin;
    m->datarel = origin + m->f.seg[0].length;
    if (m->datarel % align != 0) {
        pad[0] = align - (m->datarel % align);
        m->datarel += pad[0];
    } else {
        pad[0] = 0;
    }

    m->bssrel = m->datarel + m->f.seg[1].length;
    if (m->bssrel % align != 0) {
        pad[1] = align - (m->bssrel % align);
        m->bssrel += pad[1];
    } else {
        pad[1] = 0;
    }

    printf("code: %08"PRIx32"\ndata: %08"PRIx32"\nbss:  %08"PRIx32"\n",
           m->textrel, m->datarel, m->bssrel);

    rdf_relocate(m);

    argv++;

    of = fopen(*argv, "w");
    if (!of) {
        fprintf(stderr, "rdf2ihx: could not open output file %s\n", *argv);
        return (1);
    }

    padding = malloc(align);
    if (!padding) {
        fprintf(stderr, "rdf2ihx: out of memory\n");
        return (1);
    }

    /* write extended segment address record */
    fprintf(of, ":02000002");   /* Record mark, reclen, load offset & rectyp
                                   fields for ext. seg. address record */
    segaddr = ((origin >> 16) & 0xffff);        /* segment address */
    fprintf(of, "%04X", (unsigned int)(segaddr & 0xffff));
    checksum = 0x02 +           /* reclen */
        0x0000 +                /* Load Offset */
        0x02 +                  /* Rectyp */
        (segaddr & 0xff) +      /* USBA low */
        ((segaddr >> 8) & 0xff);        /* USBA high */
    checksum = ~checksum + 1;   /* two's-complement the checksum */
    fprintf(of, "%02X\n", checksum & 0xff);

    /* See if there's a '_main' symbol in the symbol table */
    if ((s = symtabFind(m->symtab, "_main")) == NULL) {
        printf
            ("No _main symbol found, no start segment address record added\n");
    } else {
        printf("_main symbol found at %04x:%04x\n", s->segment,
               (unsigned int)(s->offset & 0xffff));
        /* Create a start segment address record for the _main symbol. */
        segaddr = ((s->segment & 0xffff) << 16) + ((s->offset) & 0xffff);
        fprintf(of, ":04000003");       /* Record mark, reclen, load offset & rectyp
                                           fields for start seg. addr. record */
        fprintf(of, "%08"PRIX32"", segaddr);  /* CS/IP field */
        checksum = 0x04 +       /* reclen */
            0x0000 +            /* load offset */
            0x03 +              /* Rectyp */
            (segaddr & 0xff) +  /* low-low byte of segaddr */
            ((segaddr >> 8) & 0xff) +   /* low-high byte of segaddr */
            ((segaddr >> 16) & 0xff) +  /* high-low byte of segaddr */
            ((segaddr >> 24) & 0xff);   /* high-high byte of segaddr */
        checksum = ~checksum + 1;       /* two's complement */
        fprintf(of, "%02X\n", checksum & 0xff);
    }

    /* Now it's time to write data records from the code and data segments in.
       This current version doesn't check for segment overflow; proper behavior
       should be to output a segment address record for the code and data
       segments.  Something to do. */
    ofs = 0;
    segbin[0] = m->t;
    segbin[1] = m->d;
    for (segn = 0; segn < 2; segn++) {
        int mod, adr;

        if (m->f.seg[segn].length == 0)
            continue;
        for (i = 0; i + 15 < m->f.seg[segn].length; i += 16) {
            ofs = write_data_record(of, ofs, 16, &segbin[segn][i]);
        }
        if ((mod = m->f.seg[segn].length & 0x000f) != 0) {
            adr = m->f.seg[segn].length & 0xfff0;
            ofs = write_data_record(of, ofs, mod, &segbin[segn][adr]);
        }
    }
    /* output an end of file record */
    fprintf(of, ":00000001FF\n");

    fclose(of);
    return 0;
}
