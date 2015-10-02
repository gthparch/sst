
AC_DEFUN([SST_CHECK_PARAM_WARNINGS], [
  use_paramwarn="yes"

  AC_ARG_ENABLE([param-warn], [AS_HELP_STRING([--disable-param-warn],
      [Disable missing parameter and port definition warnings within the SST core.])])

  AS_IF([test "x$enable_param_warn" = "xno"], [use_paramwarn="no"])
 
  AS_IF([test "$use_paramwarn" = "yes"], [AC_DEFINE([USE_PARAM_WARNINGS], [1], 
	[Set to 1 to use missing parameter and port definition warnings in the SST core]) ])
])
