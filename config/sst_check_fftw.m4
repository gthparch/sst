
AC_DEFUN([SST_CHECK_FFTW], [
  AC_ARG_WITH([fftw],
    [AS_HELP_STRING([--with-fftw@<:@=DIR@:>@],
      [Use FFTW package installed in optionally specified DIR])])

  sst_check_fftw_happy="yes"
  AS_IF([test "$with_fftw" = "no"], [sst_check_fftw_happy="no"])

  CPPFLAGS_saved="$CPPFLAGS"
  LDFLAGS_saved="$LDFLAGS"
  LIBS_saved="$LIBS"

  AS_IF([test ! -z "$with_fftw" -a "$with_fftw" != "yes"],
    [FFTW_CPPFLAGS="-I$with_fftw/include"
     CPPFLAGS="$FFTW_CPPFLAGS $CPPFLAGS"
     FFTW_LDFLAGS="-L$with_fftw/lib"
     LDFLAGS="$FFTW_LDFLAGS $LDFLAGS"],
    [FFTW_CPPFLAGS=
     FFTW_LDFLAGS=])

  AC_LANG_PUSH(C++)
  AC_CHECK_HEADERS([fftw3.h], [], [sst_check_fftw_happy="no"])
  AC_CHECK_LIB([fftw3], [fftw_set_timelimit],
    [FFTW_LIB="-lfftw3"], [sst_check_fftw_happy="no"])
  AC_LANG_POP(C++)

  CPPFLAGS="$CPPFLAGS_saved"
  LDFLAGS="$LDFLAGS_saved"
  LIBS="$LIBS_saved"

  AC_SUBST([FFTW_CPPFLAGS])
  AC_SUBST([FFTW_LDFLAGS])
  AC_SUBST([FFTW_LIB])
  AS_IF([test "$sst_check_fftw_happy" = "yes"],
        [AC_DEFINE([HAVE_FFTW], [1], [Set to 1 if FFTW was found])])

  AS_IF([test "$sst_check_fftw_happy" = "yes"], [$1], [$2])
])
