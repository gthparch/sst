AC_DEFUN([SST_CHECK_SSTMACRO],
[
  happy="yes"

  AC_ARG_WITH([sstmacro],
    [AS_HELP_STRING([--with-sstmacro@<:@=DIR@:>@],
      [Use SST Macro package installed in optionally specified DIR])])

  AS_IF([test "$with_sstmacro" = "no"], [happy="no"])

  CPPFLAGS_saved="$CPPFLAGS"
  LDFLAGS_saved="$LDFLAGS"

  AS_IF([test "$happy" = "yes"], [
    AS_IF([test ! -z "$with_sstmacro" -a "$with_sstmacro" != "yes"],
      [SSTMACRO_PATH="$with_sstmacro/bin/:$PATH"
       SSTMACRO_CPPFLAGS="-I$with_sstmacro/include -I$with_sstmacro/include/sstmac $BOOST_CPPFLAGS"
       CPPFLAGS="$SSTMACRO_CPPFLAGS $CPPFLAGS"
       SSTMACRO_LDFLAGS="-L$with_sstmacro/lib"
       LDFLAGS="$SSTMACRO_LDFLAGS $SSTMACRO_LDFLAGS $LDFLAGS -lm"],
      [SSTMACRO_CPPFLAGS=
       SSTMACRO_LDFLAGS=])])
  
  AC_PATH_PROG([SSTMACRO_CONFIG_TOOL],[sstmacro-config],[],[$SSTMACRO_PATH])

  AC_LANG_PUSH([C++])
  AC_CHECK_HEADER([sstmac/sstmacro.h], [], [happy="no"])
  AC_LANG_POP([C++])

  AS_IF([test "x$SSTMACRO_CONFIG_TOOL" = "x"],
		[happy="no"])

  CPPFLAGS="$CPPFLAGS_saved"
  LDFLAGS="$LDFLAGS_saved"

  AC_SUBST([SSTMACRO_CPPFLAGS])
  AC_SUBST([SSTMACRO_LDFLAGS])
  AC_SUBST([SSTMACRO_CONFIG_TOOL])
  AC_SUBST([SSTMACRO_PATH])
  AM_CONDITIONAL([USE_SSTMACRO], [test "$happy" = "yes"])

  AC_MSG_CHECKING([for SST Macro library])
  AC_MSG_RESULT([$happy])
  AS_IF([test "$happy" = "no" -a ! -z "$with_sstmacro" -a "$with_sstmacro" != "no"], [$3])
  AS_IF([test "$happy" = "yes"], [$1], [$2])
])
