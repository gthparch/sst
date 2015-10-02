AC_DEFUN([AX_CXX_COMPILE_INLINE_CHECK], [
	AX_CXX_COMPILE_DETECT

	AC_CACHE_CHECK([if C++ aggressive inlining and compile time optimizations can be enabled],
		ax_cv_cxx_compile_inline_check, [
	AC_LANG_SAVE
	AC_LANG_CPLUSPLUS
	save_CXXFLAGS="$CXXFLAGS"
	CXXFLAGS="$CXXFLAGS -finline-functions"
	
	AC_TRY_COMPILE([], [],
	ax_cv_cxx_compile_inline_check=yes, ax_cv_cxx_compile_inline_check=no)
	CXXFLAGS="$save_CXXFLAGS"
	AC_LANG_RESTORE
	])

	AS_IF( [test "$ax_cv_cxx_compile_detect" != "clang" -a "$ax_cv_cxx_compile_inline_check" = "yes"], [CXXFLAGS="$CXXFLAGS -finline-functions"] )
])
