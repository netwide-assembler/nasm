/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2007 The NASM Authors - All Rights Reserved
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the license given in the file "License"
 *   distributed in the NASM archive.
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

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

/* This is required to get the standard <inttypes.h> macros when compiling
   with a C++ compiler.  This must be defined *before* <inttypes.h> is
   included, directly or indirectly. */
#define __STDC_CONSTANT_MACROS	1
#define __STDC_LIMIT_MACROS	1
#define __STDC_FORMAT_MACROS	1

#ifdef __GNUC__
# if __GNUC__ >= 4
#  define HAVE_GNUC_4
# endif
# if __GNUC__ >= 3
#  define HAVE_GNUC_3
# endif
#endif

#ifdef __GNUC__
# define _unused	__attribute__((unused))
#else
# define _unused
#endif

/* Some versions of MSVC have these only with underscores in front */
#include <stddef.h>
#include <stdarg.h>
#include <stdio.h>

#ifndef HAVE_SNPRINTF
# ifdef HAVE__SNPRINTF
#  define snprintf _snprintf
# else
int snprintf(char *, size_t, const char *, ...);
# endif
#endif

#ifndef HAVE_VSNPRINTF
# ifdef HAVE__VSNPRINT
#  define vsnprintf _vsnprintf
# else
int vsnprintf(char *, size_t, const char *, va_list);
# endif
#endif

#ifndef __cplusplus		/* C++ has false, true, bool as keywords */
# ifdef HAVE_STDBOOL_H
#  include <stdbool.h>
# else
typedef enum { false, true } bool;
# endif
#endif

/* Some misguided platforms hide the defs for these */
#if defined(HAVE_STRCASECMP) && !HAVE_DECL_STRCASECMP
int strcasecmp(const char *, const char *);
#endif

#if defined(HAVE_STRICMP) && !HAVE_DECL_STRICMP
int stricmp(const char *, const char *);
#endif

#if defined(HAVE_STRNCASECMP) && !HAVE_DECL_STRNCASECMP
int strncasecmp(const char *, const char *, size_t);
#endif

#if defined(HAVE_STRNICMP) && !HAVE_DECL_STRNICMP
int strnicmp(const char *, const char *, size_t);
#endif

#if defined(HAVE_STRSEP) && !HAVE_DECL_STRSEP
char *strsep(char **, const char *);
#endif

#endif	/* NASM_COMPILER_H */
