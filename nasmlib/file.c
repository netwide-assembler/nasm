/* SPDX-License-Identifier: BSD-2-Clause */
/* Copyright 1996-2017 The NASM Authors - All Rights Reserved */

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"

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

#ifndef R_OK
# define R_OK 4                 /* Classic Unix constant, same on Windows */
#endif

#ifdef S_ISREG
/* all good */
#elif defined(HAVE_S_ISREG)
/* exists, but not a macro */
# define S_ISREG S_ISREG
#elif defined(S_IFMT) && defined(S_IFREG)
# define S_ISREG(m) (((m) & S_IFMT) == S_IFREG)
#elif defined(_S_IFMT) && defined(_S_IFREG)
# define S_ISREG(m) (((m) & _S_IFMT) == _S_IFREG)
#endif

/*
 * On Windows, we want to use _wfopen(), as fopen() has a much smaller limit
 * on the path length that it supports.
 *
 * Previously we tried to prefix the path name with \\?\ in order to
 * let the Windows kernel know that we are not limited to PATH_MAX
 * characters, but it breaks relative paths among other things, and
 * apparently Windows 10 contains a registry option to override this
 * limit anyway... but only for the wide character interfaces.
 */
#ifdef _WIN32
#include <wchar.h>

typedef wchar_t *os_filename;
typedef wchar_t  os_fopenflag;

static os_filename os_mangle_filename(const char *filename)
{
    size_t wclen;
    wchar_t *buf;

    wclen = MultiByteToWideChar(CP_ACP, MB_ERR_INVALID_CHARS, -1, NULL, 0);
    if (!wclen)
        return NULL;

    /* wclen is in "characters" (UTF-16 code points) */
    buf = nasm_malloc(wclen << 1);

    wclen = MultiByteToWideChar(CP_ACP, MB_ERR_INVALID_CHARS, -1, buf, wclen);
    if (!wclen) {
        nasm_free(buf);
        return NULL;
    }

    return buf;
}

static inline void os_free_filename(os_filename filename)
{
    nasm_free(filename);
}

# define os_fopen  _wfopen
# define os_access _waccess

/*
 * On Win32/64, we have to use the _wstati64() function. Note that
 * we can't use _wstat64() without depending on a needlessly new
 * version os MSVCRT.
 */

typedef struct _stati64 os_struct_stat;

# define os_stat  _wstati64
# define os_fstat _fstati64

static inline void os_set_binary_mode(FILE *f) {
    int ret = _setmode(_fileno(f), _O_BINARY);

    if (ret == -1) {
        nasm_fatalf(ERR_NOFILE, "unable to set file mode to binary: %s",
                    strerror(errno));
    }
}

#else  /* not _WIN32 */

typedef const char *os_filename;
typedef char os_fopenflag;

static inline os_filename os_mangle_filename(const char *filename)
{
    return filename;
}
static inline void os_free_filename(os_filename filename)
{
    (void)filename;             /* Nothing to do */
}

static inline void os_set_binary_mode(FILE *f) {
    (void)f;
}

# define os_fopen  fopen

#if defined(HAVE_FACCESSAT) && defined(AT_EACCESS)
static inline int os_access(os_filename pathname, int mode)
{
    return faccessat(AT_FDCWD, pathname, mode, AT_EACCESS);
}
# define os_access os_access
#elif defined(HAVE_ACCESS)
# define os_access access
#endif

#ifdef HAVE_STRUCT_STAT
typedef struct stat os_struct_stat;
# ifdef HAVE_STAT
#  define os_stat stat
# endif
# ifdef HAVE_FSTAT
#  define os_fstat fstat
# endif
#else
struct dummy_struct_stat {
    int st_mode;
    int st_size;
};
typedef struct dummy_struct_stat os_struct_stat;
#endif

#endif  /* Not _WIN32 */

#ifdef fileno
/* all good */
#elif defined(HAVE_FILENO)
/* exists, but not a macro */
# define fileno fileno
#elif defined(_fileno) || defined(HAVE__FILENO)
# define fileno _fileno
#endif

#ifndef S_ISREG
# undef os_stat
# undef os_fstat
#endif

/* Disable these functions if they don't support something we need */
#ifndef fileno
# undef os_fstat
# undef os_ftruncate
# undef HAVE_MMAP
#endif

/*
 * If we don't have functional versions of these functions,
 * stub them out so we don't need so many #ifndefs
 */
#ifndef os_stat
static inline int os_stat(os_filename osfname, os_struct_stat *st)
{
    (void)osfname;
    (void)st;
    return -1;
}
#endif

#ifndef os_fstat
static inline int os_fstat(int fd, os_struct_stat *st)
{
    (void)fd;
    (void)st;
    return -1;
}
#endif

#ifndef S_ISREG
static inline bool S_ISREG(int m)
{
    (void)m;
    return false;
}
#endif

void nasm_set_binary_mode(FILE *f)
{
	os_set_binary_mode(f);
}

FILE *nasm_open_read(const char *filename, enum file_flags flags)
{
    FILE *f = NULL;
    os_filename osfname;

    osfname = os_mangle_filename(filename);
    if (osfname) {
        os_fopenflag fopen_flags[4];
        memset(fopen_flags, 0, sizeof fopen_flags);

        fopen_flags[0] = 'r';
        fopen_flags[1] = (flags & NF_TEXT) ? 't' : 'b';

#if defined(__GLIBC__) || defined(__linux__)
        /*
         * Try to open this file with memory mapping for speed, unless we are
         * going to do it "manually" with nasm_map_file()
         */
        if (!(flags & NF_FORMAP))
            fopen_flags[2] = 'm';
#endif

        while (true) {
            f = os_fopen(osfname, fopen_flags);
            if (f || errno != EINVAL || !fopen_flags[2])
                break;

            /* We got EINVAL but with 'm'; try again without 'm' */
            fopen_flags[2] = '\0';
        }

        os_free_filename(osfname);
    }

    if (!f && (flags & NF_FATAL))
        nasm_fatalf(ERR_NOFILE, "unable to open input file: `%s': %s",
                    filename, strerror(errno));

    return f;
}

FILE *nasm_open_write(const char *filename, enum file_flags flags)
{
    FILE *f = NULL;
    os_filename osfname;

    osfname = os_mangle_filename(filename);
    if (osfname) {
        os_fopenflag fopen_flags[3];

        fopen_flags[0] = 'w';
        fopen_flags[1] = (flags & NF_TEXT) ? 't' : 'b';
        fopen_flags[2] = '\0';

        f = os_fopen(osfname, fopen_flags);
        os_free_filename(osfname);
    }

    if (!f && (flags & NF_FATAL))
        nasm_fatalf(ERR_NOFILE, "unable to open output file: `%s': %s",
                    filename, strerror(errno));

    switch (flags & NF_BUF_MASK) {
    case NF_IONBF:
        setvbuf(f, NULL, _IONBF, 0);
        break;
    case NF_IOLBF:
        setvbuf(f, NULL, _IOLBF, 0);
        break;
    case NF_IOFBF:
        setvbuf(f, NULL, _IOFBF, 0);
        break;
    default:
        break;
    }

    return f;
}

/* The appropriate "rb" strings for os_fopen() */
static const os_fopenflag fopenflags_rb[3] = { 'r', 'b', 0 };

/*
 * Report the existence of a file
 */
bool nasm_file_exists(const char *filename)
{
#ifndef os_access
    FILE *f;
#endif
    os_filename osfname;
    bool exists;

    osfname = os_mangle_filename(filename);
    if (!osfname)
        return false;

#ifdef os_access
    exists = os_access(osfname, R_OK) == 0;
#else
    f = os_fopen(osfname, fopenflags_rb);
    exists = f != NULL;
    if (f)
        fclose(f);
#endif

    os_free_filename(osfname);
    return exists;
}

/*
 * Report the file size of an open file.  This MAY move the file pointer.
 */
off_t nasm_file_size(FILE *f)
{
    off_t where, end;
    os_struct_stat st;

    if (!os_fstat(fileno(f), &st) && S_ISREG(st.st_mode))
        return st.st_size;

    /* Do it the hard way... this tests for seekability */

    if (fseeko(f, 0, SEEK_CUR))
        goto fail;              /* Not seekable, don't even try */

    where = ftello(f);
    if (where == (off_t)-1)
        goto fail;

    if (fseeko(f, 0, SEEK_END))
        goto fail;

    end = ftello(f);
    if (end == (off_t)-1)
        goto fail;

    /*
     * Move the file pointer back. If this fails, this is probably
     * not a plain file.
     */
    if (fseeko(f, where, SEEK_SET))
        goto fail;

    return end;

fail:
    return -1;
}

/*
 * Report file size given pathname
 */
off_t nasm_file_size_by_path(const char *pathname)
{
    os_filename osfname;
    off_t len = -1;
    os_struct_stat st;
    FILE *fp;

    osfname = os_mangle_filename(pathname);

    if (!os_stat(osfname, &st) && S_ISREG(st.st_mode))
        len = st.st_size;

    fp = os_fopen(osfname, fopenflags_rb);
    if (fp) {
        len = nasm_file_size(fp);
        fclose(fp);
    }

    return len;
}

/*
 * Report the timestamp on a file, returns true if successful
 */
bool nasm_file_time(time_t *t, const char *pathname)
{
#ifdef os_stat
    os_filename osfname;
    os_struct_stat st;
    bool rv = false;

    osfname = os_mangle_filename(pathname);
    if (!osfname)
        return false;

    rv = !os_stat(osfname, &st);
    *t = st.st_mtime;
    os_free_filename(osfname);

    return rv;
#else
    return false;               /* No idea how to do this on this OS */
#endif
}
