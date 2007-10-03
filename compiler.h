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

/* Request as many features as we can */
#define _GNU_SOURCE
#define _ISO99_SOURCE
#define _POSIX_SOURCE
#define _POSIX_C_SOURCE		200112L
#define _XOPEN_SOURCE		600
#define _XOPEN_SOURCE_EXTENDED

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

#endif	/* NASM_COMPILER_H */
