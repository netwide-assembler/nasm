/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2017 The NASM Authors - All Rights Reserved */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"

void nasm_read(void *ptr, size_t size, FILE *f)
{
    size_t n = fread(ptr, 1, size, f);
    if (ferror(f)) {
        nasm_fatal("unable to read input: %s", strerror(errno));
    } else if (n != size || feof(f)) {
        nasm_fatal("fatal short read on input");
    }
}

void nasm_write(const void *ptr, size_t size, FILE *f)
{
    size_t n = fwrite(ptr, 1, size, f);
    if (n != size || ferror(f) || feof(f))
        nasm_fatal("unable to write output: %s", strerror(errno));
}

void fwriteint16_t(uint16_t data, FILE * fp)
{
    data = htole16(data);
    nasm_write(&data, 2, fp);
}

void fwriteint32_t(uint32_t data, FILE * fp)
{
    data = htole32(data);
    nasm_write(&data, 4, fp);
}

void fwriteint64_t(uint64_t data, FILE * fp)
{
    data = htole64(data);
    nasm_write(&data, 8, fp);
}

void fwriteaddr(uint64_t data, int size, FILE * fp)
{
    data = htole64(data);
    nasm_write(&data, size, fp);
}

/* Can we adjust the file size without actually writing all the bytes? */

#ifdef HAVE_IO_H
# include <io.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif

#ifdef HAVE__CHSIZE_S
# define os_ftruncate(fd,size)	_chsize_s(fd,size)
#elif defined(HAVE__CHSIZE)
# define os_ftruncate(fd,size)	_chsize(fd,size)
#elif defined(HAVE_FTRUNCATE)
# define os_ftruncate(fd,size)	ftruncate(fd,size)
#endif

void fwritezero(off_t bytes, FILE *fp)
{
    size_t blksize;

#ifdef os_ftruncate
    if (bytes >= BUFSIZ && !ferror(fp) && !feof(fp)) {
	off_t pos = ftello(fp);
	if (pos != (off_t)-1) {
            off_t end = pos + bytes;
	    if (!fflush(fp) && !os_ftruncate(fileno(fp), end)) {
                fseeko(fp, 0, SEEK_END);
                pos = ftello(fp);
                if (pos != (off_t)-1)
                    bytes = end - pos; /* This SHOULD be zero */
            }
	}
    }
#endif

    while (bytes > 0) {
	blksize = (bytes < ZERO_BUF_SIZE) ? bytes : ZERO_BUF_SIZE;

	nasm_write(zero_buffer, blksize, fp);
	bytes -= blksize;
    }
}
