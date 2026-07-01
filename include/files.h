/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 2026 The NASM Authors - All Rights Reserved */

#ifndef NASM_FILES_H
#define NASM_FILES_H 1

#include "compiler.h"
#include "nasmlib.h"            /* For nasm_assert() */

/*
 * Primary file names set on the command line etc.
 * Wrapped in accessors to make them as constant as possible.
 */
enum filenames {
    /* These two entries must be first, in this order */
    FN_INFILE,                  /* Primary input file */
    FN_MAPPED_INFILE,           /* Debug mapped input file */
    FN_OUTFILE,                 /* Primary output file */

    FN_ERRFILE,                 /* Error message file */
    FN_LISTFILE,                /* Listing file */
    FN_DEPENDFILE,              /* Dependency file */
    FN_MAPFILE,                 /* Map file (outbin) */
    FN_NFILES
};

extern const char *_filenames[FN_NFILES];

static inline const char *get_filename(enum filenames fn)
{
    nasm_assert((size_t)fn < ARRAY_SIZE(_filenames));
    return _filenames[fn];
}

/*
 * copy_filename() makes a private copy for the files subsystem,
 * set_nocopy() expects an allocated string for the files subsystem to
 * take over.
 */
const char *copy_filename(enum filenames fn, const char *src);
const char *set_filename(enum filenames fn, char *src);
void check_overwrite_files(void);
void cleanup_filenames(void);

#endif /* NASM_FILES_H */
