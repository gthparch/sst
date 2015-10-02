# ===========================================================================
#         http://autoconf-archive.cryp.to/ax_boost_mpi.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_BOOST_MPI
#
# DESCRIPTION
#
#   Test for MPI library from the Boost C++ libraries. The macro
#   requires a preceding call to AX_BOOST_BASE. Further documentation is
#   available at <http://randspringer.de/boost/index.html>.
#
#   This macro calls:
#
#     AC_SUBST(BOOST_MPI_LIB)
#
#   And sets:
#
#     HAVE_BOOST_MPI
#
# LICENSE
#
#   Copyright (c) 2008 Thomas Porschberg <thomas@randspringer.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.

# Modified to be more functional by Kyle Wheeler <kbwheel@sandia.gov>

AC_DEFUN([AX_BOOST_MPI],
[AC_REQUIRE([AX_BOOST_BASE])
 AC_ARG_WITH([boost-mpi],
             [AS_HELP_STRING([--with-boost-mpi@<:@=special-lib@:>@],
                             [use the MPI library from boost - it is
                              possible to specify a certain library for the
                              linker e.g.
                              --with-boost-mpi=boost_mpi-gcc-mt-d-1_33_1 ])],
             [AS_IF([test "$withval" = "no"],
                    [want_boost="no"],
                    [AS_IF([test "$withval" = "yes"],
                           [want_boost="yes"
                            ax_boost_user_mpi_lib=""],
                           [want_boost="yes"
                            ax_boost_user_mpi_lib="$withval"])])],
             [want_boost="yes"])

 OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
 export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BOOST_LIBDIR

 AS_IF([test "x$want_boost" = "xyes"],
       [AC_REQUIRE([AC_PROG_CXX])
        AC_CACHE_CHECK([whether the Boost::MPI headers are available],
                       [ax_cv_boost_mpi],
                       [AC_LANG_PUSH([C++])
                        CPPFLAGS_boost_saved="$CPPFLAGS"
                        CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
                        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <fstream>
                                                             @%:@include <boost/archive/text_oarchive.hpp>
                                                             @%:@include <boost/archive/text_iarchive.hpp>]],
                                                           [[std::ofstream ofs("filename");
                                                             boost::archive::text_oarchive oa(ofs);
                                                             return 0;]])],
                                          [ax_cv_boost_mpi=yes],
                                          [ax_cv_boost_mpi=no])
                        CPPFLAGS="$CPPFLAGS_boost_saved"
                        AC_LANG_POP([C++])])
        AS_IF([test "x$ax_cv_boost_mpi" = "xyes"],
              [AC_DEFINE([HAVE_BOOST_MPI],[1],[define if the Boost::MPI headers are available])
               CXX_boost_mpi_save="$CXX"
               CXX="$MPICXX"
               AX_BOOST_FINDLIB([boost_mpi],[BOOST_MPI_LIB],[$ax_boost_user_mpi_lib],
                                [Boost::MPI])
               CXX="$CXX_boost_mpi_save"])
        AS_IF([test "$ax_cv_boost_mpi" = yes],
              [$1],
              [$2])
    ])

 export LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH
])
# vim:expandtab ft=config
