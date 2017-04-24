dnl --------------------------------------------------------------------------
dnl PA_ADD_CFLAGS()
dnl
dnl Attempt to add the given option to CFLAGS, if it doesn't break compilation
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_ADD_CFLAGS,
[AC_MSG_CHECKING([if $CC accepts $1])
 pa_add_cflags__old_cflags="$CFLAGS"
 CFLAGS="$CFLAGS $1"
 AC_TRY_LINK(AC_INCLUDES_DEFAULT,
 [printf("Hello, World!\n");],
 [AC_MSG_RESULT([yes])
  CFLAGS="$pa_add_cflags__old_cflags ifelse([$2],[],[$1],[$2])"],
 [AC_MSG_RESULT([no])
  CFLAGS="$pa_add_cflags__old_cflags"])])

dnl --------------------------------------------------------------------------
dnl PA_ADD_CLDFLAGS()
dnl
dnl Attempt to add the given option to CFLAGS and LDFLAGS,
dnl if it doesn't break compilation
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_ADD_CLDFLAGS,
[AC_MSG_CHECKING([if $CC accepts $1])
 pa_add_cldflags__old_cflags="$CFLAGS"
 CFLAGS="$CFLAGS $1"
 pa_add_cldflags__old_ldflags="$LDFLAGS"
 LDFLAGS="$LDFLAGS $1"
 AC_TRY_LINK(AC_INCLUDES_DEFAULT,
 [printf("Hello, World!\n");],
 [AC_MSG_RESULT([yes])
  CFLAGS="$pa_add_cldflags__old_cflags ifelse([$2],[],[$1],[$2])"
  LDFLAGS="$pa_add_cldflags__old_ldflags ifelse([$2],[],[$1],[$2])"],
 [AC_MSG_RESULT([no])
  CFLAGS="$pa_add_cldflags__old_cflags"
  LDFLAGS="$pa_add_cldflags__old_ldflags"])])

dnl --------------------------------------------------------------------------
dnl PA_HAVE_FUNC
dnl
dnl Look for a function with the specified arguments which could be
dnl a builtin/intrinsic function.
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_HAVE_FUNC,
[AC_MSG_CHECKING([for $1])
AC_TRY_LINK([], [(void)$1$2;],
AC_MSG_RESULT([yes])
AC_DEFINE(m4_toupper([HAVE_$1]), [1],
  [Define to 1 if you have the `$1' intrinsic function.]),
AC_MSG_RESULT([no]))])

dnl --------------------------------------------------------------------------
dnl PA_LIBEXT
dnl
dnl Guess the library extension based on the object extension
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_LIBEXT,
[AC_MSG_CHECKING([for suffix of library files])
if test x"$LIBEXT" = x; then
  case "$OBJEXT" in
    obj )
      LIBEXT=lib
      ;;
    *)
      LIBEXT=a
      ;;
  esac
fi
AC_MSG_RESULT([$LIBEXT])
AC_SUBST([LIBEXT])])

dnl --------------------------------------------------------------------------
dnl PA_FUNC_ATTRIBUTE
dnl
dnl See if this compiler supports the equivalent of a specific gcc
dnl attribute on a function, using the __attribute__(()) syntax.
dnl All arguments except the attribute name are optional.
dnl PA_FUNC_ATTRIBUTE(attribute, attribute_opts, return_type,
dnl                   prototype_args, call_args)
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_FUNC_ATTRIBUTE,
[AC_MSG_CHECKING([if $CC supports the $1 function attribute])
 AC_COMPILE_IFELSE([AC_LANG_SOURCE([
#include <stdarg.h>
extern ifelse([$3],[],[void *],[$3])  __attribute__(($1$2))
  bar(ifelse([$4],[],[int],[$4]));
void *foo(void);
void *foo(void)
{
	return bar(ifelse([$5],[],[1],[$5]));
}
 ])],
 [AC_MSG_RESULT([yes])
  AC_DEFINE(m4_toupper([HAVE_FUNC_ATTRIBUTE_$1]), 1,
    [Define to 1 if your compiler supports __attribute__(($1)) on functions])],
 [AC_MSG_RESULT([no])])
])

dnl --------------------------------------------------------------------------
dnl PA_FUNC_ATTRIBUTE_ERROR
dnl
dnl See if this compiler supports __attribute__((error("foo")))
dnl The generic version of this doesn't work as it makes the compiler
dnl throw an error by design.
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_FUNC_ATTRIBUTE_ERROR,
[AC_MSG_CHECKING([if $CC supports the error function attribute])
 AC_COMPILE_IFELSE([AC_LANG_SOURCE([
#include <stdarg.h>
extern void __attribute__((error("message"))) barf(void);
void foo(void);
void foo(void)
{
	if (0)
		barf();
}
 ])],
 [AC_MSG_RESULT([yes])
  AC_DEFINE(m4_toupper([HAVE_FUNC_ATTRIBUTE_ERROR]), 1,
    [Define to 1 if your compiler supports __attribute__((error)) on functions])],
 [AC_MSG_RESULT([no])])
])

dnl --------------------------------------------------------------------------
dnl PA_ARG_ENABLED
dnl PA_ARG_DISABLED
dnl
dnl  Simpler-to-use versions of AC_ARG_ENABLED, that include the
dnl  test for $enableval and the AS_HELP_STRING definition
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_ARG_ENABLED,
[AC_ARG_ENABLE([$1], [AS_HELP_STRING([--enable-$1],[$2])], [], [enableval=no])
 AS_IF([test x"$enableval" != xno], [$3], [$4])
])

AC_DEFUN(PA_ARG_DISABLED,
[AC_ARG_ENABLE([$1],[AS_HELP_STRING([--disable-$1],[$2])], [], [enableval=yes])
 AS_IF([test x"$enableval" = xno], [$3], [$4])
])
