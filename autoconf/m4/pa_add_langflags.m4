dnl --------------------------------------------------------------------------
dnl PA_ADD_LANGFLAGS(flag...)
dnl
dnl Attempt to add the option in the given list to each compiler flags
dnl (CFLAGS, CXXFLAGS, ...), if it doesn't break compilation.
dnl --------------------------------------------------------------------------
m4_defun([_PA_LANGFLAG_VAR],
[m4_case([$1],
 [C], [CFLAGS],
 [C++], [CXXFLAGS],
 [Fortran 77], [FFLAGS],
 [Fortran], [FCFLAGS],
 [Erlang], [ERLCFLAGS],
 [Objective C], [OBJCFLAGS],
 [Objective C++], [OBJCXXFLAGS],
 [Go], [GOFLAGS],
 [m4_fatal([PA_ADD_LANGFLAGS: Unknown language: $1])])])

AC_DEFUN([PA_ADD_LANGFLAGS],
[m4_set_foreach(PA_LANG_SEEN_SET, [lang],
 [_pa_flag_found=no
  m4_foreach_w([flag], [$1],
  [AS_IF([test $_pa_flag_found = no],
   [PA_ADD_FLAGS(_PA_LANGFLAG_VAR(lang),flag,[],[_pa_flag_found=yes])])
   ])])])
