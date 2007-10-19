/*
 * rdf2bin.c - convert an RDOFF object file to flat binary
 */

#include "compiler.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "rdfload.h"
#include "nasmlib.h"

int32_t origin = 0;
int align = 16;

char *getfilename(char *pathname)
{
    char *lastslash = pathname - 1;
    char *i = pathname;

    while (*i) {
        if (*i == '/')
            lastslash = i;
        i++;
    }
    return lastslash + 1;
}

int main(int argc, char **argv)
{
    rdfmodule *m;
    bool err;
    FILE *of;
    char *padding;
    int codepad, datapad, bsspad = 0;

    if (argc < 2) {
        puts("Usage: rdf2bin [-o relocation-origin] [-p segment-alignment] " "input-file  output-file");
        puts("       rdf2com [-p segment-alignment] input-file output-file");
        return 1;
    }

    if (!nasm_stricmp(getfilename(*argv), "rdf2com")) {
        origin = 0x100;
    }
    argv++, argc--;

    while (argc > 2) {
        if (!strcmp(*argv, "-o")) {
            argv++, argc--;
            origin = readnum(*argv, &err);
            if (err) {
                fprintf(stderr, "rdf2bin: invalid parameter: %s\n", *argv);
                return 1;
            }
        } else if (!strcmp(*argv, "-p")) {
            argv++, argc--;
            align = readnum(*argv, &err);
            if (err) {
                fprintf(stderr, "rdf2bin: invalid parameter: %s\n", *argv);
                return 1;
            }
        } else if (!strcmp(*argv, "-b")) {
            argv++, argc--;
            bsspad = readnum(*argv, &err);
            if (err) {
                fprintf(stderr, "rdf2bin: invalid parameter: %s\n", *argv);
                return 1;
            }
        } else
            break;

        argv++, argc--;
    }
    if (argc < 2) {
        puts("rdf2bin: required parameter missing");
        return -1;
    }
    m = rdfload(*argv);

    if (!m) {
        rdfperror("rdf2bin", *argv);
        return 1;
    }
    printf("relocating %s: origin=%"PRIx32", align=%d\n", *argv, origin, align);

    m->textrel = origin;
    m->datarel = origin + m->f.seg[0].length;
    if (m->datarel % align != 0) {
        codepad = align - (m->datarel % align);
        m->datarel += codepad;
    } else
        codepad = 0;

    m->bssrel = m->datarel + m->f.seg[1].length;
    if (m->bssrel % align != 0) {
        datapad = align - (m->bssrel % align);
        m->bssrel += datapad;
    } else
        datapad = 0;

    printf("code: %08"PRIx32"\ndata: %08"PRIx32"\nbss:  %08"PRIx32"\n",
           m->textrel, m->datarel, m->bssrel);

    rdf_relocate(m);

    argv++;

    of = fopen(*argv, "wb");
    if (!of) {
        fprintf(stderr, "rdf2bin: could not open output file %s\n", *argv);
        return 1;
    }

    padding = malloc(align);
    if (!padding) {
        fprintf(stderr, "rdf2bin: out of memory\n");
        return 1;
    }

    if (fwrite(m->t, 1, m->f.seg[0].length, of) != m->f.seg[0].length ||
        fwrite(padding, 1, codepad, of) != codepad ||
        fwrite(m->d, 1, m->f.seg[1].length, of) != m->f.seg[1].length) {
        fprintf(stderr, "rdf2bin: error writing to %s\n", *argv);
        return 1;
    }

    if (bsspad) {
        void *p = calloc(bsspad -= (m->bssrel - origin), 1);
        fwrite(p, 1, bsspad, of);
    }

    fclose(of);
    return 0;
}
