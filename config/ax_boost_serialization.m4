# ===========================================================================
#         http://autoconf-archive.cryp.to/ax_boost_serialization.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_BOOST_SERIALIZATION
#
# DESCRIPTION
#
#   Test for Serialization library from the Boost C++ libraries. The macro
#   requires a preceding call to AX_BOOST_BASE. Further documentation is
#   available at <http://randspringer.de/boost/index.html>.
#
#   This macro calls:
#
#     AC_SUBST(BOOST_SERIALIZATION_LIB)
#
#   And sets:
#
#     HAVE_BOOST_SERIALIZATION
#
# LICENSE
#
#   Copyright (c) 2008 Thomas Porschberg <thomas@randspringer.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.
#
# Modified to be more functional by Kyle Wheeler <kbwheel@sandia.gov>

AC_DEFUN([AX_BOOST_SERIALIZATION],
[AC_REQUIRE([AX_BOOST_BASE])
 AC_ARG_WITH([boost-serialization],
             [AS_HELP_STRING([--with-boost-serialization@<:@=special-lib@:>@],
                             [use the Serialization library from boost - it is
                              possible to specify a certain library for the
                              linker e.g.
                              --with-boost-serialization=boost_serialization-gcc-mt-d-1_33_1
                              ])],
             [AS_IF([test "$withval" = "no"],
                    [want_boost="no"],
                    [AS_IF([test "$withval" = "yes"],
                           [want_boost="yes"
                            ax_boost_user_serialization_lib=""],
                           [want_boost="yes"
                            ax_boost_user_serialization_lib="$withval"])])],
             [want_boost="yes"])

 AS_IF([test "x$want_boost" = "xyes"],
       [AC_REQUIRE([AC_PROG_CXX])
        AC_CACHE_CHECK([whether the Boost::Serialization headers are available],
                       [ax_cv_boost_serialization],
                       [AC_LANG_PUSH([C++])
                        CPPFLAGS_boost_saved="$CPPFLAGS"
                        CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
                        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <fstream>
                                                             @%:@include <boost/archive/text_oarchive.hpp>
                                                             @%:@include <boost/archive/text_iarchive.hpp>]],
                                                           [[std::ofstream ofs("filename");
                                                             boost::archive::text_oarchive oa(ofs);
                                                             return 0;]])],
                                          [ax_cv_boost_serialization=yes],
                                          [ax_cv_boost_serialization=no])
                        CPPFLAGS="$CPPFLAGS_boost_saved"
                        AC_LANG_POP([C++])])
        AS_IF([test "x$ax_cv_boost_serialization" = "xyes"],
              [AC_DEFINE([HAVE_BOOST_SERIALIZATION],[1],[define if the Boost::Serialization headers are available])
               AX_BOOST_FINDLIB([boost_serialization],
                                [BOOST_SERIALIZATION_LIB],
                                [$ax_boost_user_serialization_lib],
                                [Boost::Serialization])])
        AS_IF([test "$ax_cv_boost_serialization" = yes],
              [$1],
              [$2])
        ])
])
# vim:expandtab ft=config
