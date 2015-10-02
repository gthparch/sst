AC_DEFUN([AX_CXX_COMPILE_RPATH_CHECK], [

  AC_ARG_ENABLE([rpath-link], 
	[AS_HELP_STRING([--disable-rpath-link],
      		[Disables rpath directory linking if configure detects this is possible.])])

  AC_CACHE_CHECK([if rpath link time option can be used],
  ax_cv_cxx_compile_rpath_check,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS -Wl,-rpath,."
  AC_TRY_COMPILE([], [],
  ax_cv_cxx_compile_rpath_check=yes, ax_cv_cxx_compile_rpath_check=no)
  CXXFLAGS="$save_CXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF( [test "x$enable_rpath_link" != "xno" -a "$ax_cv_cxx_compile_rpath_check" = "yes"],
	[RPATH_PREFIX="-Wl,-rpath,"],
	[RPATH_PREFIX=""] )
  AC_MSG_CHECKING([whether to enable rpath linking for SST])
  AS_IF( [test "x$enable_rpath_link" != "xno" -a "$ax_cv_cxx_compile_rpath_check" = "yes"],
	[AC_MSG_RESULT([yes])],
	[AC_MSG_RESULT([no])] )
])
