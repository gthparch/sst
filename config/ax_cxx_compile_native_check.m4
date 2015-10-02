AC_DEFUN([AX_CXX_COMPILE_NATIVE_CHECK], [

  AC_CACHE_CHECK([if C++ aggressive native platform optimization is permitted by the compiler],
  ax_cv_cxx_compile_native_check,
  [AC_LANG_SAVE
  AC_LANG_CPLUSPLUS
  save_CXXFLAGS="$CXXFLAGS"
  CXXFLAGS="$CXXFLAGS -march=native -mtune=native"
  AC_TRY_LINK([@%:@include <iostream>],
                       [[const int n = 1024;
			double* thearray = (double*) malloc(sizeof(double) * n);
			int c;
			double sum = 0;
			for(c = 0; c < n; ++c)
				thearray[c] = 1 + c;
			for(c = 0; c < n; ++c) 
				sum += thearray[c];

			std::cout << "total is: " << sum << std::endl;]],
  ax_cv_cxx_compile_native_check=yes, ax_cv_cxx_compile_native_check=no)
  CXXFLAGS="$save_CXXFLAGS"
  AC_LANG_RESTORE
  ])

  AS_IF( [test "$ax_cv_cxx_compile_native_check" = "yes"], [CXXFLAGS="$CXXFLAGS -march=native -mtune=native"] )
])
