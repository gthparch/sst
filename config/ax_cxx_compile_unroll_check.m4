AC_DEFUN([AX_CXX_COMPILE_UNROLL_CHECK], [

  AC_CACHE_CHECK([if C++ aggressive loop unroll optimization is permitted by the compiler],
  ax_cv_cxx_compile_unroll_check,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS -funroll-loops"
  AC_TRY_COMPILE([], [],
  ax_cv_cxx_compile_unroll_check=yes, ax_cv_cxx_compile_unroll_check=no)
  CXXFLAGS="$save_CXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF( [test "$ax_cv_cxx_compile_unroll_check" = "yes"], [CXXFLAGS="$CXXFLAGS -funroll-loops"] )
])
