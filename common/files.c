/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 2026 The NASM Authors - All Rights Reserved */

#include "compiler.h"
#include "files.h"
#include "error.h"

static const char * const filename_names[FN_NFILES] = {
    "input",
    "output",
    "error",
    "list",
    "dependency"
};

const char *_filenames[FN_NFILES];

const char *copy_filename(enum filenames fn, const char *src)
{
    return set_filename(fn, nasm_strdup(src));
}

const char *set_filename(enum filenames fn, char *src)
{
    const char **dstp, *dst;
    nasm_assert((size_t)fn < ARRAY_SIZE(_filenames));

    dstp = &_filenames[fn];
    dst = *dstp;

    if (dst) {
        nasm_fatal("more than one %s file specified: %s and %s",
                   filename_names[fn], dst, src);
    }

    return *dstp = src;
}

void check_overwrite_files(void)
{
    enum filenames fn;
    const char *inname = get_filename(FN_INFILE);

    if (!inname)
        return;

    for (fn = FN_INFILE+1; fn < FN_NFILES; fn++) {
        const char *outname = get_filename(fn);
        if (outname && !strcmp(inname, outname)) {
            nasm_fatal("%s file would overwrite input file",
                       filename_names[fn]);
        }
    }
}

void cleanup_filenames(void)
{
    enum filenames fn;

    for (fn = 0; fn < FN_NFILES; fn++) {
        nasm_free((char *)_filenames[fn]);
        _filenames[fn] = NULL;
    }
}
