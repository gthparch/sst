# Copyright 2012-2015 Sandia Corporation. Under the terms
# of Contract DE-AC04-94AL85000 with Sandia Corporation, the U.S.
# Government retains certain rights in this software.
# 
# Copyright (c) 2012-2015, Sandia Corporation
# All rights reserved.
# 
# This file is part of the SST software package. For license
# information, see the LICENSE file in the top level directory of the
# distribution.
#
#

AC_DEFUN([AX_ADD_TO_FLAGS],
[already_present=0
 for flag in $$1 ; do
     AS_IF([test $flag = "$2"],
           [already_present=1
            break])
 done
 AS_IF([test $already_present -eq 0],
       [$1="$$1 $2"])
])

AC_DEFUN([AX_PROG_FIND],
[AC_PATH_PROG([find],[find],[AC_MSG_ERROR([Need the 'find' tool to configure Boost])])
 FIND="$ac_cv_path_find"])

AC_DEFUN([AX_BOOST_FINDLIB],
[
 AC_LANG_PUSH([C++])
 AS_IF([test "x$3" = "x"],
       [AC_REQUIRE([AX_PROG_FIND])
        AC_REQUIRE([AC_PROG_SED])
        ax_boost_findlib_saved_LDFLAGS="$LDFLAGS"
        ax_boost_findlib_saved_LIBS="$LIBS"
        potential_libs=$($FIND "$BOOST_LIBDIR" -name lib$1.so\* -o -name lib$1-mt.so\* -o -name lib$1.a\* -o -name lib$1-mt.a\* -o -name lib$1.dylib -o -name lib$1-mt.dylib 2>/dev/null)
        for plib in $potential_libs ; do
          ax_lib=$(echo "$plib" | $SED 's,.*/,,' | $SED -e 's;^lib\('$1'.*\)\.so.*$;\1;' -e 's;^lib\('$1'.*\)\.a*$;\1;' -e 's;^lib\('$1'.*\)\.dylib*$;\1;')
          ax_libdir=$(echo "$plib" | $SED 's,\(.*\)/lib'${ax_lib}'.*,\1,')
          LDFLAGS="$ax_boost_findlib_saved_LDFLAGS -L$ax_libdir"
          LIBS="-l$ax_lib"
          AC_LINK_IFELSE([AC_LANG_PROGRAM([], [return 0;])],
                         [$2="-l$ax_lib"
                          AX_ADD_TO_FLAGS([BOOST_LDFLAGS],["-L$ax_libdir"])
                          happy="yes"
                          break],
                         [happy="no"])
        done
        AS_IF([test "x$happy" != "xyes"],
              [potential_libs=$($FIND "$BOOST_LIBDIR" -name $1\*.dll\* -o -name $1\*.a\* 2>/dev/null)
               for plib in $potential_libs ; do
                 ax_lib=$(echo $plib | $SED 's,.*/,,' | $SED -e 's;^\($1.*\)\.so.*$;\1;' -e 's;^\($1.*\)\.a*$;\1;')
                 ax_libdir=$(echo $plib | $SED "s,\(.*\)/${ax_lib}.*,\1,")
                 LDFLAGS="$ax_boost_findlib_saved_LDFLAGS -L$ax_libdir"
                 AC_LINK_IFELSE([AC_LANG_PROGRAM([], [return 0;])],
                                [$2="-l$ax_lib"
                                 BOOST_LDFLAGS="$BOOST_LDFLAGS -L$ax_libdir"
                                 happy="yes"
                                 break],
                                [happy="no"])
               done])
        LDFLAGS="$ax_boost_findlib_saved_LDFLAGS"
        LIBS="$ax_boost_findlib_saved_LIBS"],
       [for ax_lib in $3 $1-$3; do
          AC_CHECK_LIB([$ax_lib], [exit],
                       [$2="-l$ax_lib"
                        happy="yes"
                        break],
                       [happy="no"])
        done])
 AC_LANG_POP([C++])
AC_CACHE_CHECK([whether the $4 library is available],
                [ax_cv_$1_lib],
                [ax_cv_$1_lib=$happy])
 AC_SUBST([$2])
 AS_IF([test "x$ax_cv_$1_lib" != "xyes"],
       [AS_IF([test "x$BOOST_LIBDIR" = "x"],
              [AC_MSG_ERROR([Could not find a $4 library to link against! Probably need to use --with-boost-libdir])],
              [AC_MSG_ERROR([Could not find a $4 library to link against! (Looking in $BOOST_LIBDIR)])])])
])
# vim:expandtab ft=config
