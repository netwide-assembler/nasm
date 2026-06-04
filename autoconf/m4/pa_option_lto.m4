dnl --------------------------------------------------------------------------
dnl PA_OPTION_LTO(default)
dnl
dnl  Try to enable link-time optimization. Enable it by default if
dnl  the "default" argument is set to "yes"; currently the default is "no",
dnl  but that could change in the future -- to force disabled by default,
dnl  set to "no".
dnl --------------------------------------------------------------------------
AC_DEFUN([PA_OPTION_LTO],
[
dnl Careful here: AR or RANLIB may already have already been probed for.
dnl If not, do it now to prevent it from getting down further down.
dnl Do it unconditionally to avoid inconsistent behavior with or
dnl without --enable-lto.
AS_IF([test -z "$AR"], [AC_CHECK_TOOL(AR, ar)])
AS_IF([test -z "$RANLIB"], [AC_CHECK_TOOL(RANLIB, ranlib, :)])

PA_ARG_BOOL([lto],
 [Try to enable link-time optimization for this compiler],
 [m4_default([$1],[no])],
 [PA_FIND_FLAGS([-flto=auto],[-flto])
  PA_FIND_FLAGS([-ffat-lto-objects])
  PA_FIND_FLAGS([-fuse-linker-plugin])

  dnl Add here if there are any other toolchains that need special magic
  AS_IF([test x$ac_compiler_gnu = xyes],
  [AC_CHECK_TOOL(CC_AR, gcc-ar)
   AR="${CC_AR:-$AR}"
   AC_CHECK_TOOL(CC_RANLIB, gcc-ranlib)
   RANLIB="${CC_RANLIB:-$RANLIB}"])])])
