AC_DEFUN([AX_CXX_COMPILE_DETECT], [
	AC_CACHE_CHECK([if C++ compiler vendor],
		ax_cv_cxx_compile_detect, [

	AC_LANG_SAVE
	AC_LANG_CPLUSPLUS

	ax_cv_cxx_compile_is_clang="no"
	ax_cv_cxx_compile_is_gnu="no"

	AC_TRY_COMPILE([
	#ifndef __clang__
	#error "The compiler is not clang"
	#endif
	],,
	ax_cv_cxx_compile_detect="clang", ax_cv_cxx_compile_detect="unknown")

	AS_IF( [test "$ax_cv_cxx_compile_detect" = "unknown"], 
	[
		AC_TRY_COMPILE(
		[#ifndef __GNU__
		#error "The compiler is not GNU"
		#endif
		],,
  		ax_cv_cxx_compile_detect="gnu", ax_cv_cxx_compile_is_clang="unknown")
	])

	])
])
