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
 */

#ifndef COMPILER_H
#define COMPILER_H 1

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

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

#endif	/* COMPILER_H */
