# ===========================================================================
#             http://autoconf-archive.cryp.to/ax_boost_base.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_BOOST_BASE([MINIMUM-VERSION])
#
# DESCRIPTION
#
#   Test for the Boost C++ libraries of a particular version (or newer)
#
#   If no path to the installed boost library is given the macro searchs
#   under /usr, /usr/local, /opt and /opt/local and evaluates the
#   $BOOST_ROOT environment variable. Further documentation is available at
#   <http://randspringer.de/boost/index.html>.
#
#   This macro calls:
#
#     AC_SUBST(BOOST_CPPFLAGS) / AC_SUBST(BOOST_LDFLAGS)
#
#   And sets:
#
#     HAVE_BOOST
#
# LICENSE
#
#   Copyright (c) 2008 Thomas Porschberg <thomas@randspringer.de>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved.

AC_DEFUN([AX_BOOST_BASE],
[AC_ARG_WITH([boost],
             [AS_HELP_STRING([--with-boost@<:@=DIR@:>@],
                             [use boost (default is yes) - it is possible to
                              specify the root directory for boost
                              (optional)])],
             [AS_IF([test "$withval" = "no"],
                    [want_boost="no"],
                    [AS_IF([test "$withval" = "yes"],
                           [want_boost="yes"
                            ac_boost_path=""],
                           [want_boost="yes"
                            ac_boost_path="$withval"])])],
             [want_boost="yes"])


AC_ARG_WITH([boost-libdir],
            [AS_HELP_STRING([--with-boost-libdir=LIB_DIR],
                            [Force given directory for boost libraries. Note
                             that this will overwrite library path detection,
                             so use this parameter only if default library
                             detection fails and you know exactly where your
                             boost libraries are located.])],
            [AS_IF([test -d $withval],
                   [ac_boost_lib_path="$withval"],
                   [AC_MSG_ERROR(--with-boost-libdir expected directory name)])],
            [ac_boost_lib_path=""])

AS_IF([test "x$want_boost" = "xyes"],
      [boost_lib_version_req=ifelse([$1], ,1.20.0,$1)
       boost_lib_version_req_shorten=`expr $boost_lib_version_req : '\([[0-9]]*\.[[0-9]]*\)'`
       boost_lib_version_req_major=`expr $boost_lib_version_req : '\([[0-9]]*\)'`
       boost_lib_version_req_minor=`expr $boost_lib_version_req : '[[0-9]]*\.\([[0-9]]*\)'`
       boost_lib_version_req_sub_minor=`expr $boost_lib_version_req : '[[0-9]]*\.[[0-9]]*\.\([[0-9]]*\)'`
       AS_IF([test "x$boost_lib_version_req_sub_minor" = "x"],
             [boost_lib_version_req_sub_minor="0"])
       WANT_BOOST_VERSION=`expr $boost_lib_version_req_major \* 100000 \+  $boost_lib_version_req_minor \* 100 \+ $boost_lib_version_req_sub_minor`
       AC_MSG_CHECKING(for boostlib >= $boost_lib_version_req)
       succeeded=no

       dnl first we check the system location for boost libraries
       dnl this location ist chosen if boost libraries are installed with the --layout=system option
       dnl or if you install boost with RPM
       AS_IF([test "$ac_boost_path" != ""],
             [AX_FIND_LIBDIR([BOOST_LIBDIR],[$ac_boost_path], [libboost_])
              BOOST_LDFLAGS="-L$BOOST_LIBDIR"
              BOOST_CPPFLAGS="-I$ac_boost_path/include"],
             [for ac_boost_path_tmp in /usr /usr/local /opt /opt/local ; do
                AS_IF([test -d "$ac_boost_path_tmp/include/boost" && test -r "$ac_boost_path_tmp/include/boost"],
                      [AX_FIND_LIBDIR([BOOST_LIBDIR], [$ac_boost_path_tmp], [libboost_])
                       BOOST_LDFLAGS="-L$BOOST_LIBDIR"
                       BOOST_CPPFLAGS="-I$ac_boost_path_tmp/include"
                       break])
              done])

       dnl overwrite ld flags if we have required special directory with
       dnl --with-boost-libdir parameter
       AS_IF([test "$ac_boost_lib_path" != ""],
             [BOOST_LIBDIR="$ac_boost_lib_path"
              BOOST_LDFLAGS="-L$ac_boost_lib_path"])

       CPPFLAGS_SAVED="$CPPFLAGS"
       CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
       export CPPFLAGS

       LDFLAGS_SAVED="$LDFLAGS"
       LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"
       export LDFLAGS

       AC_LANG_PUSH([C++])
       AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <boost/version.hpp>]],
                                          [[
                               #if BOOST_VERSION >= $WANT_BOOST_VERSION
                               // Everything is okay
                               #else
                               #  error Boost version is too old
                               #endif
                               ]])],
                         [AC_MSG_RESULT(yes)
                          succeeded=yes
                          found_system=yes])
       AC_LANG_POP([C++])



       dnl if we found no boost with system layout we search for boost libraries
       dnl built and installed without the --layout=system option or for a staged(not installed) version
       AS_IF([test "x$succeeded" != "xyes"],
             [_version=0
              AS_IF([test "$ac_boost_path" != ""],
                    [AS_IF([test -d "$ac_boost_path" && test -r "$ac_boost_path"],
                           [for i in `ls -d $ac_boost_path/include/boost-* 2>/dev/null`; do
                            _version_tmp=`echo $i | sed "s#$ac_boost_path##" | sed 's/\/include\/boost-//' | sed 's/_/./'`
                            V_CHECK=`expr $_version_tmp \> $_version`
                            AS_IF([test "$V_CHECK" = "1"],
                                  [_version=$_version_tmp])
                            VERSION_UNDERSCORE=`echo $_version | sed 's/\./_/'`
                            BOOST_CPPFLAGS="-I$ac_boost_path/include/boost-$VERSION_UNDERSCORE"
                        done])],
                        [for ac_boost_path in /usr /usr/local /opt /opt/local ; do
                         AS_IF([test -d "$ac_boost_path" && test -r "$ac_boost_path"],
                               [for i in `ls -d $ac_boost_path/include/boost-* 2>/dev/null`; do
                                _version_tmp=`echo $i | sed "s#$ac_boost_path##" | sed 's/\/include\/boost-//' | sed 's/_/./'`
                                V_CHECK=`expr $_version_tmp \> $_version`
                                AS_IF([test "$V_CHECK" = "1"],
                                      [_version=$_version_tmp
                                       best_path=$ac_boost_path])
                                done])
                         done

                         VERSION_UNDERSCORE=`echo $_version | sed 's/\./_/'`
                         BOOST_CPPFLAGS="-I$best_path/include/boost-$VERSION_UNDERSCORE"
                         AS_IF([test "x$ac_boost_lib_path" = "x"],
                               [AX_FIND_LIBDIR([BOOST_LIBDIR], [$best_path], [libboost_])
                                BOOST_LDFLAGS="-L$BOOST_LIBDIR"])

                         AS_IF([test "x$BOOST_ROOT" != "x"],
                               [AS_IF([test -d "$BOOST_ROOT" && test -r "$BOOST_ROOT" && test -d "$BOOST_ROOT/stage/lib" && test -r "$BOOST_ROOT/stage/lib"],
                                      [version_dir=`expr //$BOOST_ROOT : '.*/\(.*\)'`
                                       stage_version=`echo $version_dir | sed 's/boost_//' | sed 's/_/./g'`
                                       stage_version_shorten=`expr $stage_version : '\([[0-9]]*\.[[0-9]]*\)'`
                                       V_CHECK=`expr $stage_version_shorten \>\= $_version`
                                       AS_IF([test "$V_CHECK" = "1" -a "x$ac_boost_lib_path" = "x"],
                                             [AC_MSG_NOTICE(We will use a staged boost library from $BOOST_ROOT)
                                             BOOST_CPPFLAGS="-I$BOOST_ROOT"
                                             AX_FIND_LIBDIR([BOOST_LIBDIR], [$BOOST_ROOT/stage], [libboost_])
                                             BOOST_LDFLAGS="-L$BOOST_LIBDIR"])])])
       ])

        CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
        export CPPFLAGS
        LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"
        export LDFLAGS

        AC_LANG_PUSH(C++)
        AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
                           @%:@include <boost/version.hpp>
                           ]], [[
                                #if BOOST_VERSION >= $WANT_BOOST_VERSION
                                // Everything is okay
                                #else
                                #  error Boost version is too old
                                #endif
                                ]])],[
                                      AC_MSG_RESULT(yes)
                                      succeeded=yes
                                      found_system=yes
                                      ],[
                                         ])
        AC_LANG_POP([C++])
        ])

    AS_IF([test "$succeeded" != "yes"],
          [AS_IF([test "$_version" = "0"],
                 [AC_MSG_ERROR([[We could not detect the boost libraries (version $boost_lib_version_req_shorten or higher). If you have a staged boost library (still not installed) please specify \$BOOST_ROOT in your environment and do not give a PATH to --with-boost option.  If you are sure you have boost installed, then check your version number looking in <boost/version.hpp>. See http://randspringer.de/boost for more documentation.]])],
                 [AC_MSG_ERROR([Your boost libraries seems to old (version $_version).])])],
                 [AC_SUBST(BOOST_CPPFLAGS)
                 AC_SUBST(BOOST_LDFLAGS)
		 AC_SUBST(BOOST_LIBDIR)
                 AC_DEFINE(HAVE_BOOST,,[define if the Boost library is available])])

    CPPFLAGS="$CPPFLAGS_SAVED"
    LDFLAGS="$LDFLAGS_SAVED"
    ])

])

AC_DEFUN([AX_FIND_LIBDIR],
[AC_REQUIRE([AX_PROG_FIND])
 $1="$2/lib" # basic default; may be wrong
 for detect_boost_libdir in lib64 lib ; do # prefer lib64, just in case both are available
     tmp_libs=$($FIND $2/$detect_boost_libdir -name $3\* -print -quit 2>/dev/null)
     AS_IF([test "x$tmp_libs" != "x"],
           [$1="$2/$detect_boost_libdir"
            break])
 done
])
