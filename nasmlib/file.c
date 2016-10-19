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

#ifdef HAVE_FCNTL_H
# include <fcntl.h>
#endif
#ifdef HAVE_SYS_STAT_H
# include <sys/stat.h>
#endif
#ifdef HAVE_IO_H
# include <io.h>
#endif
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
#ifdef HAVE_SYS_MMAN_H
# include <sys/mman.h>
#endif

#if !defined(HAVE_FILENO) && defined(HAVE__FILENO)
# define HAVE_FILENO 1
# define fileno _fileno
#endif

#if !defined(HAVE_ACCESS) && defined(HAVE__ACCESS)
# define HAVE_ACCESS 1
# define access _access
#endif
#ifndef R_OK
# define R_OK 4                 /* Classic Unix constant, same on Windows */
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

#ifdef HAVE__STATI64
# define HAVE_STAT 1
# define stat _stati64
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


void fwritezero(off_t bytes, FILE *fp)
{
    size_t blksize;

#ifdef nasm_ftruncate
    if (bytes >= BUFSIZ && !ferror(fp) && !feof(fp)) {
	off_t pos = ftello(fp);
	if (pos >= 0) {
            pos += bytes;
	    if (!fflush(fp) &&
		!nasm_ftruncate(fileno(fp), pos) &&
		!fseeko(fp, pos, SEEK_SET))
		    return;
	}
    }
#endif

    while (bytes > 0) {
	blksize = (bytes < ZERO_BUF_SIZE) ? bytes : ZERO_BUF_SIZE;

	nasm_write(zero_buffer, blksize, fp);
	bytes -= blksize;
    }
}

FILE *nasm_open_read(const char *filename, enum file_flags flags)
{
    FILE *f;
    bool again = true;

#ifdef __GLIBC__
    /*
     * Try to open this file with memory mapping for speed, unless we are
     * going to do it "manually" with nasm_map_file()
     */
    if (!(flags & NF_FORMAP)) {
        f = fopen(filename, (flags & NF_TEXT) ? "rtm" : "rbm");
        again = (!f) && (errno == EINVAL); /* Not supported, try without m */
    }
#endif

    if (again)
        f = fopen(filename, (flags & NF_TEXT) ? "rt" : "rb");

    if (!f && (flags & NF_FATAL))
        nasm_fatal(ERR_NOFILE, "unable to open input file: `%s': %s",
                   filename, strerror(errno));

    return f;
}

FILE *nasm_open_write(const char *filename, enum file_flags flags)
{
    FILE *f;

    f = fopen(filename, (flags & NF_TEXT) ? "wt" : "wb");

    if (!f && (flags & NF_FATAL))
        nasm_fatal(ERR_NOFILE, "unable to open output file: `%s': %s",
                   filename, strerror(errno));

    return f;
}

/*
 * Report the existence of a file
 */
bool nasm_file_exists(const char *filename)
{
#if defined(HAVE_FACCESSAT) && defined(AT_EACCESS)
    return faccessat(AT_FDCWD, filename, R_OK, AT_EACCESS) == 0;
#elif defined(HAVE_ACCESS)
    return access(filename, R_OK) == 0;
#else
    FILE *f;

    f = fopen(filename, "rb");
    if (f) {
        fclose(f);
        return true;
    } else {
        return false;
    }
#endif
}

/*
 * Report file size.  This MAY move the file pointer.
 */
off_t nasm_file_size(FILE *f)
{
#if defined(HAVE_FILENO) && defined(HAVE__FILELENGTHI64)
    return _filelengthi64(fileno(f));
#elif defined(HAVE_FILENO) && defined(HAVE_FSTAT)
    struct stat st;

    if (fstat(fileno(f), &st))
        return (off_t)-1;

    return st.st_size;
#else
    if (fseeko(f, 0, SEEK_END))
        return (off_t)-1;

    return ftello(f);
#endif
}

/*
 * Report file size given pathname
 */
off_t nasm_file_size_by_path(const char *pathname)
{
#ifdef HAVE_STAT
    struct stat st;

    if (stat(pathname, &st))
        return (off_t)-1;

    return st.st_size;
#else
    FILE *fp;
    off_t len;

    fp = nasm_open_read(pathname, NF_BINARY);
    if (!fp)
        return (off_t)-1;

    len = nasm_file_size(fp);
    fclose(fp);

    return len;
#endif
}

/*
 * System page size
 */

/* File scope since not all compilers like static data in inline functions */
static size_t nasm_pagemask;

static size_t get_pagemask(void)
{
    size_t ps = 0;

# if defined(HAVE_SYSCONF) && defined(_SC_PAGESIZE)
    ps = sysconf(_SC_PAGESIZE);
# elif defined(HAVE_GETPAGESIZE)
    ps = getpagesize();
# endif

    nasm_pagemask = ps = is_power2(ps) ? (ps - 1) : 0;
    return ps;
}

static inline size_t pagemask(void)
{
    size_t pm = nasm_pagemask;

    if (unlikely(!pm))
        return get_pagemask();

    return pm;
}

/*
 * Try to map an input file into memory
 */
const void *nasm_map_file(FILE *fp, off_t start, off_t len)
{
#if defined(HAVE_FILENO) && defined(HAVE_MMAP)
   const char *p;
    off_t  astart;              /* Aligned start */
    size_t salign;              /* Amount of start adjustment */
    size_t alen;                /* Aligned length */
    const size_t page_mask = pagemask();

    if (unlikely(!page_mask))
        return NULL;            /* Page size undefined? */

    if (unlikely(!len))
        return NULL;            /* Mapping nothing... */

    if (unlikely(len != (off_t)(size_t)len))
        return NULL;            /* Address space insufficient */

    astart = start & ~(off_t)page_mask;
    salign = start - astart;
    alen = (len + salign + page_mask) & ~page_mask;

    p = mmap(NULL, alen, PROT_READ, MAP_SHARED, fileno(fp), astart);
    return unlikely(p == MAP_FAILED) ? NULL : p + salign;
#else
    /* XXX: add Windows support? */
    return NULL;
#endif
}

/*
 * Unmap an input file
 */
void nasm_unmap_file(const void *p, size_t len)
{
#if defined(HAVE_FILENO) && defined(HAVE_MMAP)
    const size_t page_mask = pagemask();
    uintptr_t astart;
    size_t salign;
    size_t alen;

    if (unlikely(!page_mask))
        return;

    astart = (uintptr_t)p & ~(uintptr_t)page_mask;
    salign = (uintptr_t)p - astart;
    alen = (len + salign + page_mask) & ~page_mask;

    munmap((void *)astart, alen);
#endif
}
