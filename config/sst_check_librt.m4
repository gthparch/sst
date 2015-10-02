dnl -*- Autoconf -*-

AC_DEFUN([SST_CHECK_LIBRT], [

  happy="yes"


  # Check for -lrt link time option, we need this on Linux but not on Mac
  # since it is included in the default System framework
  AC_CHECK_LIB([rt], [shm_open], [SST_RT_LIB="-lrt"], [SST_RT_LIB=""])
  AM_CONDITIONAL([HAVE_RT_LIB], [test "$SST_RT_LIB" = "-lrt"])
  AC_SUBST([SST_RT_LIB])

  AC_MSG_CHECKING([if librt can be used])
  AS_IF([test "$SST_RT_LIB" = "-lrt"], [AC_MSG_RESULT(["yes"])], [AC_MSG_RESULT(["no"])])
  AS_IF([test "$happy" = "yes"], [$1], [$2])

])
