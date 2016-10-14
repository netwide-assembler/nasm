/* ----------------------------------------------------------------------- *
 *   
 *   Copyright 2007-2016 The NASM Authors - All Rights Reserved
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

/*
 * compiler.h
 *
 * Compiler-specific macros for NASM.  Feel free to add support for
 * other compilers in here.
 *
 * This header file should be included before any other header.
 */

#ifndef NASM_COMPILER_H
#define NASM_COMPILER_H 1

/*
 * At least DJGPP and Cygwin have broken header files if __STRICT_ANSI__
 * is defined.
 */
#ifdef __GNUC__
# undef __STRICT_ANSI__
#endif

/* On Microsoft platforms we support multibyte character sets in filenames */
#define _MBCS 1

#ifdef HAVE_CONFIG_H
# include "config/config.h"
#elif defined(_MSC_VER) && (_MSC_VER >= 1310)
# include "config/msvc.h"
#else
# include "config/unknown.h"
#endif /* Configuration file */

/* This is required to get the standard <inttypes.h> macros when compiling
   with a C++ compiler.  This must be defined *before* <inttypes.h> is
   included, directly or indirectly. */
#define __STDC_CONSTANT_MACROS	1
#define __STDC_LIMIT_MACROS	1
#define __STDC_FORMAT_MACROS	1

#ifdef HAVE_INTTYPES_H
# include <inttypes.h>
#else
# include "nasmint.h"
#endif

#include <stddef.h>
#include <stdarg.h>
#include <stdio.h>

/* Some versions of MSVC have these only with underscores in front */
#ifndef HAVE_SNPRINTF
# ifdef HAVE__SNPRINTF
#  define snprintf _snprintf
# else
int snprintf(char *, size_t, const char *, ...);
# endif
#endif

#ifndef HAVE_VSNPRINTF
# ifdef HAVE__VSNPRINTF
#  define vsnprintf _vsnprintf
# else
int vsnprintf(char *, size_t, const char *, va_list);
# endif
#endif

#if !defined(HAVE_STRLCPY) || !defined(HAVE_DECL_STRLCPY)
size_t strlcpy(char *, const char *, size_t);
#endif

#ifndef __cplusplus		/* C++ has false, true, bool as keywords */
# ifdef HAVE_STDBOOL_H
#  include <stdbool.h>
# elif defined(HAVE__BOOL)
#  typedef _Bool bool
#  define false 0
#  define true 1
# else
/* This is sort of dangerous, since casts will behave different than
   casting to the standard boolean type.  Always use !!, not (bool). */
typedef enum bool { false, true } bool;
# endif
#endif

/* Provide a substitute for offsetof() if we don't have one.  This
   variant works on most (but not *all*) systems... */
#ifndef offsetof
# define offsetof(t,m) ((size_t)&(((t *)0)->m))
#endif

/* The container_of construct: if p is a pointer to member m of
   container class c, then return a pointer to the container of which
   *p is a member. */
#ifndef container_of
# define container_of(p, c, m) ((c *)((char *)(p) - offsetof(c,m)))
#endif

/* Some misguided platforms hide the defs for these */
#if defined(HAVE_STRCASECMP) && !defined(HAVE_DECL_STRCASECMP)
int strcasecmp(const char *, const char *);
#endif

#if defined(HAVE_STRICMP) && !defined(HAVE_DECL_STRICMP)
int stricmp(const char *, const char *);
#endif

#if defined(HAVE_STRNCASECMP) && !defined(HAVE_DECL_STRNCASECMP)
int strncasecmp(const char *, const char *, size_t);
#endif

#if defined(HAVE_STRNICMP) && !defined(HAVE_DECL_STRNICMP)
int strnicmp(const char *, const char *, size_t);
#endif

#if defined(HAVE_STRSEP) && !defined(HAVE_DECL_STRSEP)
char *strsep(char **, const char *);
#endif

/*
 * Define this to 1 for faster performance if this is a littleendian
 * platform which can do unaligned memory references.  It is safe
 * to leave it defined to 0 even if that is true.
 */
#if defined(__386__) || defined(__i386__) || defined(__x86_64__)
# define X86_MEMORY 1
# ifndef WORDS_LITTLEENDIAN
#  define WORDS_LITTLEENDIAN 1
# endif
#else
# define X86_MEMORY 0
#endif

/*
 * Hints to the compiler that a particular branch of code is more or
 * less likely to be taken.
 */
#if defined(__GNUC__) && __GNUC__ >= 3
# define likely(x)	__builtin_expect(!!(x), 1)
# define unlikely(x)	__builtin_expect(!!(x), 0)
#else
# define likely(x)	(!!(x))
# define unlikely(x)	(!!(x))
#endif

/*
 * Hints about malloc-like functions that never return NULL
 */
#if defined(__GNUC__) && __GNUC__ >= 4 /* ? */
# define never_null __attribute__((returns_nonnull))
# define safe_alloc never_null __attribute__((malloc))
# ifdef __has_attribute
#  if __has_attribute(alloc_size)
#   define safe_malloc(s) safe_alloc __attribute__((alloc_size(s)))
#   define safe_malloc2(s1,s2) safe_alloc __attribute__((alloc_size(s1,s2)))
#   define safe_realloc(s) never_null __attribute__((alloc_size(s)))
#  endif
# endif
#endif

#ifndef never_null
# define never_null
#endif
#ifndef safe_alloc
# define safe_alloc
#endif
#ifndef safe_malloc
# define safe_malloc(s) safe_alloc
# define safe_malloc2(s1,s2) save_alloc
# define safe_realloc(s) never_null
#endif

/*
 * How to tell the compiler that a function doesn't return
 */
#ifdef __GNUC__
# define no_return void __attribute__((noreturn))
#else
# define no_return void
#endif

/*
 * How to tell the compiler that a function takes a printf-like string
 */
#ifdef __GNUC__
# define printf_func(fmt, list) __attribute__((format(printf, fmt, list)))
#else
# define printf_func(fmt, list)
#endif

#endif	/* NASM_COMPILER_H */
