dnl Process this file with autoconf 2.63 or later to produce
dnl a configure script.
AC_PREREQ(2.63)
AC_INIT(config/config.h.in)
AC_CONFIG_HEADERS(config/config.h)

AC_PREFIX_PROGRAM(nasm)

dnl Checks for programs.
dnl Consider AC_USE_SYSTEM_EXTENSIONS if autoconf 2.61 is OK in the future
AC_USE_SYSTEM_EXTENSIONS
AC_SYS_LARGEFILE
AC_PROG_CC
AC_PROG_CC_STDC
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_INSTALL

dnl For gcc, at lest, use -O3
PA_ADD_CFLAGS([-O3])

dnl Check for library extension
PA_LIBEXT

dnl Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_C_RESTRICT
AC_TYPE_SIZE_T
AC_C_BIGENDIAN(AC_DEFINE(WORDS_BIGENDIAN),AC_DEFINE(WORDS_LITTLEENDIAN),,)
AH_TEMPLATE(WORDS_BIGENDIAN,
[Define to 1 if your processor stores words with the most significant
byte first (like Motorola and SPARC, unlike Intel and VAX).])
AH_TEMPLATE(WORDS_LITTLEENDIAN,
[Define to 1 if your processor stores words with the least significant
byte first (like Intel and VAX, unlike Motorola and SPARC).])

dnl Force gcc and gcc-compatible compilers treat signed integers
dnl as 2's complement
PA_ADD_CFLAGS([-fwrapv])

dnl Some environments abuse __STRICT_ANSI__ to disable some
dnl function declarations
PA_ADD_CFLAGS([-U__STRICT_ANSI__])

dnl Don't put things in common if we can avoid it.  We don't want to
dnl assume all compilers support common, and this will help find those
dnl problems.  This also works around an OSX linker problem.
PA_ADD_CFLAGS([-fno-common])

dnl Look for programs...
AC_CHECK_PROGS(NROFF,    nroff,    false)
AC_CHECK_PROGS(ASCIIDOC, asciidoc, false)
AC_CHECK_PROGS(XMLTO,    xmlto,    false)
AC_CHECK_PROGS(ACRODIST, acrodist, false)
AC_CHECK_PROGS(PS2PDF,   ps2pdf,   false)
AC_CHECK_PROGS(PSTOPDF,  pstopdf,  false)

dnl Check for progs needed for manpage generation
if test $ASCIIDOC = false; then
  AC_MSG_WARN([No asciidoc package found])
fi
if test $XMLTO = false; then
  AC_MSG_WARN([No xmlto package found])
fi

dnl Check for host compiler tools
AC_CHECK_TOOL(AR, ar)
AC_CHECK_TOOL(RANLIB, ranlib, :)
AC_CHECK_TOOL(STRIP, strip)

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(inttypes.h)
AC_CHECK_HEADERS(strings.h)
AC_HEADER_STDBOOL
AC_CHECK_HEADERS(stdnoreturn.h)
AC_CHECK_HEADERS(io.h)
AC_CHECK_HEADERS(fcntl.h)
AC_CHECK_HEADERS(unistd.h)
AC_CHECK_HEADERS(sys/param.h)
AC_CHECK_HEADERS(sys/mman.h)
AC_CHECK_HEADERS(sys/stat.h)
AC_CHECK_HEADERS(sys/types.h)

dnl Checks for library functions.
AC_CHECK_FUNCS(strcasecmp stricmp)
AC_CHECK_FUNCS(strncasecmp strnicmp)
AC_CHECK_FUNCS(strsep)
AC_CHECK_FUNCS(strnlen)

AC_CHECK_FUNCS(getuid)
AC_CHECK_FUNCS(getgid)

AC_CHECK_FUNCS(realpath)
AC_CHECK_FUNCS(canonicalize_file_name)
AC_CHECK_FUNCS(_fullpath)
AC_CHECK_FUNCS(pathconf)

AC_FUNC_FSEEKO
AC_CHECK_FUNCS([_fseeki64])
AC_CHECK_FUNCS([ftruncate _chsize _chsize_s])
AC_CHECK_FUNCS([fileno _fileno])

AC_CHECK_FUNCS(_filelengthi64)
AC_CHECK_FUNCS([stat _stati64])
AC_CHECK_FUNCS(fstat)
AC_FUNC_MMAP
AC_CHECK_FUNCS(getpagesize)
AC_CHECK_FUNCS(sysconf)

AC_CHECK_FUNCS([access _access faccessat])

PA_HAVE_FUNC(__builtin_clz, (0U))
PA_HAVE_FUNC(__builtin_clzl, (0UL))
PA_HAVE_FUNC(__builtin_clzll, (0ULL))
PA_HAVE_FUNC(__builtin_expect, (1,1))

dnl Functions for which we have replacements available in lib/
AC_CHECK_FUNCS([vsnprintf _vsnprintf])
AC_CHECK_FUNCS([snprintf _snprintf])
AC_CHECK_FUNCS([strlcpy])

dnl Check for functions that might not be declared in the headers for
dnl various idiotic reasons (mostly because of library authors
dnl abusing the meaning of __STRICT_ANSI__)
AC_CHECK_DECLS(strcasecmp)
AC_CHECK_DECLS(stricmp)
AC_CHECK_DECLS(strncasecmp)
AC_CHECK_DECLS(strnicmp)
AC_CHECK_DECLS(strsep)
AC_CHECK_DECLS(strlcpy)
AC_CHECK_DECLS(strnlen)

dnl Check for missing types
AC_TYPE_UINTPTR_T

dnl
dnl Check for supported gcc attributes; some compilers (e.g. Sun CC)
dnl support these, but don't define __GNUC__ as they don't support
dnl some other features of gcc.
dnl
PA_ADD_CFLAGS([-Werror=attributes])
PA_FUNC_ATTRIBUTE(noreturn)
PA_FUNC_ATTRIBUTE(returns_nonnull)
PA_FUNC_ATTRIBUTE(malloc)
PA_FUNC_ATTRIBUTE(alloc_size, (1))
PA_FUNC_ATTRIBUTE(format, [(printf,1,2)], int, [const char *, ...], ["%d",1])
PA_FUNC_ATTRIBUTE(const)
PA_FUNC_ATTRIBUTE(pure)
PA_FUNC_ATTRIBUTE_ERROR

dnl
dnl support ccache
dnl
AC_ARG_ENABLE([ccache],
[AC_HELP_STRING([--enable-ccache], [compile with ccache])],
[CC="ccache $CC"],
[])

dnl
dnl support LTO
dnl
AC_ARG_ENABLE([lto],
[AC_HELP_STRING([--enable-lto], [compile with gcc link time optimization])],
[PA_ADD_CLDFLAGS([-flto])
dnl Note: we use _PROG rather than _TOOL since we are prepending the full
dnl CC name which ought to already contain the host triplet if needed
ccbase=`echo "$CC" | awk '{ print $1; }'`
AC_CHECK_PROG(CC_AR, [${ccbase}-ar], [${ccbase}-ar], [$ac_cv_prog_AR])
AR="$CC_AR"
AC_CHECK_PROG(CC_RANLIB, [${ccbase}-ranlib], [${ccbase}-ranlib], [$ac_cv_prog_RANLIB])
RANLIB="$CC_RANLIB"
], [])

dnl If we have gcc, add appropriate code cleanliness options
PA_ADD_CFLAGS([-W])
PA_ADD_CFLAGS([-Wall])
PA_ADD_CFLAGS([-pedantic])
dnl LLVM doesn't error out on invalid -W options unless this option is
dnl specified first.  Enable this so this script can actually discover
dnl which -W options are possible for this compiler.
PA_ADD_CFLAGS([-Werror=unknown-warning-option])
dnl Suppress format warning on Windows targets due to their <inttypes.h>
PA_ADD_CFLAGS([-Wpedantic-ms-format],[-Wno-pedantic-ms-format])
PA_ADD_CFLAGS([-Wc90-c99-compat])
PA_ADD_CFLAGS([-Wlong-long],[-Wno-long-long])
dnl PA_ADD_CFLAGS([-Wwrite-strings])
AC_ARG_ENABLE([werror],
[AC_HELP_STRING([--enable-werror],
[compile with -Werror to error out on any warning])],
[], [enable_werror=no])
AS_IF([test x"$enable_werror" != xno],
[PA_ADD_CFLAGS([-Werror])],
[PA_ADD_CFLAGS([-Werror=implicit])
PA_ADD_CFLAGS([-Werror=missing-braces])
PA_ADD_CFLAGS([-Werror=return-type])
PA_ADD_CFLAGS([-Werror=trigraphs])
PA_ADD_CFLAGS([-Werror=pointer-arith])
PA_ADD_CFLAGS([-Werror=strict-prototypes])
PA_ADD_CFLAGS([-Werror=missing-prototypes])
PA_ADD_CFLAGS([-Werror=missing-declarations])
PA_ADD_CFLAGS([-Werror=comment])
PA_ADD_CFLAGS([-Werror=vla])])

AC_OUTPUT_COMMANDS([mkdir -p config nasmlib nsis output stdlib x86 asm disasm])
AC_OUTPUT(Makefile rdoff/Makefile doc/Makefile)
