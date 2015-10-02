AC_DEFUN([AX_CXX_COMPILE_UNKNOWN_PRAGMA_WARN_CHECK], [

  AC_CACHE_CHECK([if C++ unknown pragmas warnings can be disabled],
  ax_cv_cxx_compile_no_unknown_pragmas_check,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS -Wno-unknown-pragmas"
  AC_TRY_COMPILE([], [],
  ax_cv_cxx_compile_no_unknown_pragmas_check=yes, ax_cv_cxx_compile_no_unknown_pragmas_check=no)
  CXXFLAGS="$save_CXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF( [test "$ax_cv_cxx_compile_no_unknown_pragmas_check" = "yes"], [CXXFLAGS="$CXXFLAGS -Wno-unknown-pragmas"] )
])
