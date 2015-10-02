
AC_DEFUN([SST_CHECK_TCMALLOC], [
  AC_ARG_WITH([tcmalloc],
    [AS_HELP_STRING([--with-tcmalloc@<:@=DIR@:>@],
      [Use tcmalloc package installed in optionally specified DIR])])

  sst_check_tcmalloc_happy="yes"
  AS_IF([test "$with_tcmalloc" = "no"], [sst_check_tcmalloc_happy="no"])

  CPPFLAGS_saved="$CPPFLAGS"
  LDFLAGS_saved="$LDFLAGS"
  LIBS_saved="$LIBS"

  AS_IF([test ! -z "$with_tcmalloc" -a "$with_tcmalloc" != "yes"],
    [TCMALLOC_CPPFLAGS="-I$with_tcmalloc/include"
     CPPFLAGS="$TCMALLOC_CPPFLAGS $CPPFLAGS"
     TCMALLOC_LDFLAGS="-L$with_tcmalloc/lib"
     LDFLAGS="$TCMALLOC_LDFLAGS $LDFLAGS"],
    [TCMALLOC_CPPFLAGS=
     TCMALLOC_LDFLAGS=])

  AC_LANG_PUSH(C++)
  AC_CHECK_LIB([tcmalloc], [malloc],
    [TCMALLOC_LIB="-ltcmalloc"], [sst_check_tcmalloc_happy="no"])

  AC_MSG_CHECKING(for tcmalloc version >= 2.1.0)
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <gperftools/tcmalloc.h>]],
           [[
               #if TC_VERSION_MAJOR >= 2
                 #if TC_VERSION_MINOR >= 1
                   // Everything is okay
                 #else
                   #error tcmalloc version is too old
                 #endif
               #else
                 #error tcmalloc version is too old
               #endif
            ]])],
            [AC_MSG_RESULT(yes)],
            [AC_MSG_RESULT(no)
            sst_check_tcmalloc_happy="no"])
  AC_LANG_POP([C++])
  AS_IF([test "$sst_check_tcmalloc_happy" = "no"], [TCMALLOC_LIB=""])

  CPPFLAGS="$CPPFLAGS_saved"
  LDFLAGS="$LDFLAGS_saved"
  LIBS="$LIBS_saved"

  AC_SUBST([TCMALLOC_CPPFLAGS])
  AC_SUBST([TCMALLOC_LDFLAGS])
  AC_SUBST([TCMALLOC_LIB])

  AM_CONDITIONAL([HAVE_TCMALLOC], [test "$sst_check_tcmalloc_happy" = "yes"])
  AS_IF([test "$sst_check_tcmalloc_happy" = "yes"],
        [AC_DEFINE([HAVE_TCMALLOC], [1], [Set to 1 if tcmalloc was found])])

  AS_IF([test ! -z "$with_tcmalloc" -a "$with_tcmalloc" != "no" -a "$sst_check_tcmalloc_happy" = "no"],
	[AC_MSG_ERROR([Error unable to find or configure tcmalloc])])

  AS_IF([test "$sst_check_tcmalloc_happy" = "yes"], [$1], [$2])
])
