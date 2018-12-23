dnl --------------------------------------------------------------------------
dnl PA_FUNC_ATTRIBUTE(attribute_name)
dnl
dnl See if this compiler supports the equivalent of a specific gcc
dnl attribute on a function, using the __attribute__(()) syntax.
dnl All arguments except the attribute name are optional.
dnl PA_FUNC_ATTRIBUTE(attribute, attribute_opts, return_type,
dnl                   prototype_args, call_args)
dnl --------------------------------------------------------------------------
AC_DEFUN([PA_FUNC_ATTRIBUTE],
[AC_MSG_CHECKING([if $CC supports the $1 function attribute])
 AC_COMPILE_IFELSE([AC_LANG_SOURCE([
AC_INCLUDES_DEFAULT
extern ifelse([$3],[],[void *],[$3])  __attribute__(($1$2))
  bar(ifelse([$4],[],[int],[$4]));
ifelse([$3],[],[void *],[$3]) foo(void);
ifelse([$3],[],[void *],[$3]) foo(void)
{
	ifelse([$3],[void],[],[return])
		bar(ifelse([$5],[],[1],[$5]));
}
 ])],
 [AC_MSG_RESULT([yes])
  AC_DEFINE(PA_SYM([HAVE_FUNC_ATTRIBUTE_],[$1]), 1,
    [Define to 1 if your compiler supports __attribute__(($1)) on functions])],
 [AC_MSG_RESULT([no])])
])
