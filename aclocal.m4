dnl --------------------------------------------------------------------------
dnl PA_ADD_CFLAGS()
dnl
dnl Attempt to add the given option to CFLAGS, if it doesn't break compilation
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_ADD_CFLAGS,
[AC_MSG_CHECKING([if $CC accepts $1])
 pa_add_cflags__old_cflags="$CFLAGS"
 CFLAGS="$CFLAGS $1"
 AC_TRY_LINK([#include <stdio.h>],
 [printf("Hello, World!\n");],
 AC_MSG_RESULT([yes])
 CFLAGS="$pa_add_cflags__old_cflags ifelse([$2],[],[$1],[$2])",
 AC_MSG_RESULT([no])
 CFLAGS="$pa_add_cflags__old_cflags")])

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
