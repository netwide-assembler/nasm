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
 AC_MSG_RESULT([yes]),
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
dnl PA_REPLACE_FUNC
dnl
dnl Look for a function and possible alternatives, unlike AC_REPLACE_FUNCS
dnl this will only add *one* replacement to LIBOBJS if no alternative is
dnl found.
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_REPLACE_FUNC_WITH,
[pa_replace_func__$2_missing=true
AC_CHECK_FUNCS([$1], [pa_replace_func__$2_missing=false], [])
if $pa_replace_func__$2_missing; then
  AC_LIBOBJ([$2])
fi])

AC_DEFUN(PA_REPLACE_FUNC,
[PA_REPLACE_FUNC_WITH([$1], m4_car(m4_unquote(m4_split(m4_normalize[$1]))))])
