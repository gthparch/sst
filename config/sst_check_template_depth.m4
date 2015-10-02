AC_DEFUN([SST_CXX_COMPILE_TEMPLATE_DEPTH_CHECK], [

  AC_CACHE_CHECK([if C++ template depth can be set in the compiler],
  ax_cv_cxx_compile_template_depth_check,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS -ftemplate-depth-512"
  AC_TRY_COMPILE([], [],
  ax_cv_cxx_compile_template_depth_check=yes, ax_cv_cxx_compile_template_depth_check=no)
  CXXFLAGS="$save_CXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF( [test "$ax_cv_cxx_compile_template_depth_check" = "yes"], [CXXFLAGS="$CXXFLAGS -ftemplate-depth-512"] )
])
