/* ----------------------------------------------------------------------- *
 *
 *   Copyright 1996-2017 The NASM Authors - All Rights Reserved
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

#ifndef NASMLIB_FILE_H
#define NASMLIB_FILE_H

#include "compiler.h"
#include "nasmlib.h"
#include "error.h"

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

/*
 * On Win32, stat has a 32-bit file size but _stati64 has a 64-bit file
 * size.  However, as "stat" is already a macro, don't confuse the situation
 * further by redefining it, instead we create our own.
 */
#ifdef HAVE__STATI64
# define nasm_stat _stati64
#elif defined(HAVE_STAT)
# define nasm_stat stat
#endif

#ifdef HAVE_FILENO
# ifdef HAVE__FSTATI64
#  define nasm_fstat _fstati64
# elif defined(HAVE_FSTAT)
#  define nasm_fstat fstat
# endif
#endif

#endif /* NASMLIB_FILE_H */
