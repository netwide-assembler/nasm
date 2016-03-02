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
dnl PA_WORKING_STDBOOL
dnl
dnl See if we have a working <stdbool.h> and bool support; in particular,
dnl OpenWatcom 1.8 has a broken _Bool type that we don't want to use.
dnl --------------------------------------------------------------------------
AC_DEFUN(PA_WORKING_BOOL,
[AC_MSG_CHECKING([if $CC has a working bool type])
 AC_COMPILE_IFELSE([AC_LANG_SOURCE([
#ifndef __cplusplus
#include <stdbool.h>
#endif
int foo(bool x, int y)
{
	return x+y;
}
 ])],
 [AC_MSG_RESULT([yes])
  AC_DEFINE(HAVE_WORKING_BOOL, 1,
    [Define to 1 if your compiler has a correct implementation of bool])],
 [AC_MSG_RESULT([no])])
])

