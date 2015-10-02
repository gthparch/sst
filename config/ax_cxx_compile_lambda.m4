
AC_DEFUN([SST_CXX_COMPILE_LAMBDA], [

  AC_CACHE_CHECK(if C++ supports C++11 Lambda Functions,
  ax_cv_cxx_compile_cxx11_lambda,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  savedCXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS $SST_CXX0X_FLAGS"
  AC_TRY_COMPILE([
	auto func = []() { return 4; };
        int j = func();
   ],,
  ax_cv_cxx_compile_cxx11_lambda=yes, ax_cv_cxx_compile_cxx11_lambda=no)
  CXXFLAGS="$savedCXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF([test "x$ax_cv_cxx_compile_cxx11_lambda" = "xyes"], 
  	[AC_DEFINE(HAVE_STDCXX_LAMBDAS, [1], [Define if C++ supports C++11 features.])] )
  AM_CONDITIONAL([HAVE_STDCXX_LAMBDAS], [test "x$ax_cv_cxx_compile_cxx11_lambda" = "xyes"])
])

