dnl -*- Autoconf -*-

AC_DEFUN([SST_CONFIGURE_ELEMENTS], [
  m4_ifdef([sst_elemlib_list], [],
    [m4_fatal([Could not find element library list - rerun autogen.sh])])

  AC_ARG_ENABLE([elements],
    [AC_HELP_STRING([--disable-elements],[Disable building all element libraries.  Build framework only.])],
    [AS_IF([test "$enable_elements" = "no"],
        [AC_DEFINE([__SST_BUILD_CORE_ONLY__], [1],
                   [Define to signify SST Core is being built by with no element libraries])])],
    [enable_elements="yes"])


  # list of all element library directories that should be included in
  # dist
  dist_elemlibs=
  # list of all element library directories that should be built
  active_elemlibs=
  # libltdl-magic formed string of all element libraries that are
  # going to be built, to support disabling dynamic loading.
  active_ltlibs=

  m4_foreach(sst_elemlib, 
    [sst_elemlib_list], 
    [AS_IF([test ! -f [${srcdir}/sst/elements/]sst_elemlib[/.nodist]],
           [dist_elemlibs="$dist_elemlibs sst_elemlib"])
     SST_CONFIGURE_ELEMLIB(sst_elemlib,
       [active_elemlibs="$active_elemlibs sst_elemlib"
        AS_IF([test "sst_elemlib" != "include"],
              [active_ltlibs="$active_ltlibs "'-dlopen [$(top_builddir)/sst/elements/]sst_elemlib[/lib]sst_elemlib[.la']])
        AS_IF([test -f [${srcdir}/sst/elements/]sst_elemlib[/.nodist]],
              [AC_MSG_WARN([Element library ]sst_elemlib[ will build but not be distributed.])])])])

  AS_IF([test "$enable_elements" = "yes"],
    [],
    [dist_elemlibs=""
     active_elemlibs=""
     active_ltlibs=""
    ])

  SST_DIST_ELEMLIBS="$dist_elemlibs"
  SST_ACTIVE_ELEMLIBS="$active_elemlibs"
  SST_LTLIBS_ELEMLIBS="$active_ltlibs"

  AC_SUBST(SST_DIST_ELEMLIBS)
  AC_SUBST(SST_ACTIVE_ELEMLIBS)
  AC_SUBST(SST_LTLIBS_ELEMLIBS)
])


AC_DEFUN([SST_CONFIGURE_ELEMLIB], [
  AC_MSG_NOTICE([Element library $1])

  m4_ifdef([SST_]$1[_CONFIG],
           [SST_$1_CONFIG([should_build=1], [should_build=0])],
           [should_build=1])

  AC_MSG_CHECKING([if $1 can build])
  AS_IF([test $should_build -eq 1],
        [AC_MSG_RESULT([yes])
         $2], 
        [AC_MSG_RESULT([no])
         $3])

  AC_CONFIG_FILES([sst/elements/]$1[/Makefile])
])
