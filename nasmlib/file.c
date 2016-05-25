/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2016 The NASM Authors - All Rights Reserved
 *   See the file AUTHORS included with the NASM distribution for
 *   the specific copyright holders.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following
 *   conditions are met:
 *
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above
 *     copyright notice, this list of conditions and the following
 *     disclaimer in the documentation and/or other materials provided
 *     with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ----------------------------------------------------------------------- */

#include "compiler.h"
#include "nasmlib.h"

#include <errno.h>

#ifdef HAVE_IO_H
# include <io.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif

/* Missing fseeko/ftello */
#ifndef HAVE_FSEEKO
# undef off_t                   /* Just in case it is a macro */
# ifdef HAVE__FSEEKI64
#  define fseeko _fseeki64
#  define ftello _ftelli64
#  define off_t  int64_t
# else
#  define fseeko fseek
#  define ftello ftell
#  define off_t  long
# endif
#endif

/* Can we adjust the file size without actually writing all the bytes? */
#ifdef HAVE_FILENO		/* Useless without fileno() */
# ifdef HAVE__CHSIZE_S
#  define nasm_ftruncate(fd,size) _chsize_s(fd,size)
# elif defined(HAVE__CHSIZE)
#  define nasm_ftruncate(fd,size) _chsize(fd,size)
# elif defined(HAVE_FTRUNCATE)
#  define nasm_ftruncate(fd,size) ftruncate(fd,size)
# endif
#endif

void nasm_write(const void *ptr, size_t size, FILE *f)
{
    size_t n = fwrite(ptr, 1, size, f);
    if (n != size || ferror(f) || feof(f))
        nasm_fatal(0, "unable to write output: %s", strerror(errno));
}

#ifdef WORDS_LITTLEENDIAN

void fwriteint16_t(uint16_t data, FILE * fp)
{
    nasm_write(&data, 2, fp);
}

void fwriteint32_t(uint32_t data, FILE * fp)
{
    nasm_write(&data, 4, fp);
}

void fwriteint64_t(uint64_t data, FILE * fp)
{
    nasm_write(&data, 8, fp);
}

void fwriteaddr(uint64_t data, int size, FILE * fp)
{
    nasm_write(&data, size, fp);
}

#else /* not WORDS_LITTLEENDIAN */

void fwriteint16_t(uint16_t data, FILE * fp)
{
    char buffer[2], *p = buffer;
    WRITESHORT(p, data);
    nasm_write(buffer, 2, fp);
}

void fwriteint32_t(uint32_t data, FILE * fp)
{
    char buffer[4], *p = buffer;
    WRITELONG(p, data);
    nasm_write(buffer, 4, fp);
}

void fwriteint64_t(uint64_t data, FILE * fp)
{
    char buffer[8], *p = buffer;
    WRITEDLONG(p, data);
    nasm_write(buffer, 8, fp);
}

void fwriteaddr(uint64_t data, int size, FILE * fp)
{
    char buffer[8], *p = buffer;
    WRITEADDR(p, data, size);
    nasm_write(buffer, size, fp);
}

#endif


void fwritezero(size_t bytes, FILE *fp)
{
    size_t blksize;

#ifdef nasm_ftruncate
    if (bytes >= BUFSIZ && !ferror(fp) && !feof(fp)) {
	off_t pos = ftello(fp);
	if (pos >= 0) {
	    if (!fflush(fp) &&
		!nasm_ftruncate(fileno(fp), pos + bytes) &&
		!fseeko(fp, pos+bytes, SEEK_SET))
		    return;
	}
    }
#endif

    while (bytes) {
	blksize = (bytes < ZERO_BUF_SIZE) ? bytes : ZERO_BUF_SIZE;

	nasm_write(zero_buffer, blksize, fp);
	bytes -= blksize;
    }
}

#ifdef __GLIBC__
/* If we are using glibc, attempt to mmap the files for speed */
# define READ_TEXT_FILE "rtm"
# define READ_BIN_FILE  "rbm"
#else
# define READ_TEXT_FILE "rt"
# define READ_BIN_FILE  "rb"
#endif
#define WRITE_TEXT_FILE "wt"
#define WRITE_BIN_FILE  "wb"

FILE *nasm_open_read(const char *filename, enum file_flags flags)
{
    FILE *f;

    f = fopen(filename, (flags & NF_TEXT) ? READ_TEXT_FILE : READ_BIN_FILE);
    if (!f && (flags & NF_FATAL))
        nasm_fatal(ERR_NOFILE, "unable to open input file: `%s': %s",
                   filename, strerror(errno));

    return f;
}

FILE *nasm_open_write(const char *filename, enum file_flags flags)
{
    FILE *f;

    f = fopen(filename, (flags & NF_TEXT) ? WRITE_TEXT_FILE : WRITE_BIN_FILE);
    if (!f && (flags & NF_FATAL))
        nasm_fatal(ERR_NOFILE, "unable to open output file: `%s': %s",
                   filename, strerror(errno));

    return f;
}
