# -*- Autoconf -*-
#
# SYNOPSIS
#
#   SST_CHECK_PARMETIS
#
# DESCRIPTION
#
# LICENSE
#

AC_DEFUN([SST_CHECK_PARMETIS],
[
  sst_check_parmetis_happy="yes"

  AC_ARG_WITH([parmetis],
    [AS_HELP_STRING([--with-parmetis@<:@=DIR@:>@],
      [Use Parmetis package installed in optionally specified DIR])])

  AS_IF([test "$with_parmetis" = "no"], [sst_check_parmetis_happy="no"])

  CPPFLAGS_saved="$CPPFLAGS"
  LDFLAGS_saved="$LDFLAGS"

  AS_IF([test ! -z "$with_parmetis" -a "$with_parmetis" != "yes"],
    [PARMETIS_CPPFLAGS="-I$with_parmetis/include"
     CPPFLAGS="$PARMETIS_CPPFLAGS $CPPFLAGS"
     PARMETIS_LDFLAGS="-L$with_parmetis/lib"
     LDFLAGS="$PARMETIS_LDFLAGS $LDFLAGS"],
    [PARMETIS_CPPFLAGS=
     PARMETIS_LDFLAGS=])

  AC_CHECK_HEADERS([parmetis.h], [], [sst_check_parmetis_happy="no"])
  AC_CHECK_LIB([parmetis], [ParMETIS_NodeND], 
    [PARMETIS_LIB="-lparmetis -lmetis -lm"], [sst_check_parmetis_happy="no"], [-lmetis -lm $MPILIBS])

  CPPFLAGS="$CPPFLAGS_saved"
  LDFLAGS="$LDFLAGS_saved"

  AC_SUBST([PARMETIS_CPPFLAGS])
  AC_SUBST([PARMETIS_LDFLAGS])
  AC_SUBST([PARMETIS_LIB])

  AC_MSG_CHECKING([for Parmetis package])
  AC_MSG_RESULT([$sst_check_parmetis_happy])
  AS_IF([test "$sst_check_parmetis_happy" = "yes"], [$1], [$2])
])
