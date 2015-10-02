
AC_DEFUN([SST_CHECK_BOOST_PROGRAM_OPTIONS],
[
	happy="yes"

	CPPFLAGS_SAVED="$CPPFLAGS"
	LDFLAGS_SAVED="$LDFLAGS"
	LIBS_SAVED="$LIBS"

	CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
	LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"

	AC_MSG_NOTICE([Performing include checks for Boost Program Options...])
	AC_LANG_PUSH([C++])
	AC_CHECK_HEADER([boost/program_options.hpp], [], [happy="no"])
	AC_LANG_POP([C++])

	AC_MSG_NOTICE([Performing linking checks for Boost Program Options...])
	BOOST_PROGRAM_OPTIONS_LIB="-lboost_program_options"
	LIBS="$LIBS_SAVED $BOOST_PROGRAM_OPTIONS_LIB"
	AC_LANG_PUSH([C++])
	AC_LINK_IFELSE([
		AC_LANG_PROGRAM(
		[[#include <iostream>
		#include <boost/program_options.hpp>
		using namespace std;
		namespace po = boost::program_options;
		]],
		[[  		
			try {
			po::options_description desc("Test Options");
			desc.add_options()
				("help", "produce a lengthy help message");
			} catch(...) {
				cerr << "An exception occurred.\n";
			}
		]]
		)], [happy="yes"], [happy="no"])
	AC_LANG_POP([C++])
     AS_IF([test "$happy" = "no"], [
	BOOST_PROGRAM_OPTIONS_LIB="-lboost_program_options-mt"
	LIBS="$LIBS_SAVED $BOOST_PROGRAM_OPTIONS_LIB"
	AC_LANG_PUSH([C++])
	AC_LINK_IFELSE([
		AC_LANG_PROGRAM(
		[[#include <iostream>
		#include <boost/program_options.hpp>
		using namespace std;
		namespace po = boost::program_options;
		]],
		[[  		
			try {
			po::options_description desc("Test Options");
			desc.add_options()
				("help", "produce a lengthy help message");
			} catch(...) {
				cerr << "An exception occurred.\n";
			}
		]]
		)], [happy="yes"], [happy="no"])
	AC_LANG_POP([C++])
])
	AC_SUBST(BOOST_PROGRAM_OPTIONS_LIB)

	LIBS="$LIBS_SAVED"
	CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"

	AS_IF([test "$happy" = "yes"], 
		[AC_MSG_NOTICE([Boost Program Options configuration successful.])], 
		[AC_MSG_ERROR([Boost Program Options configuration failed to compile/link successfully.],[1])])
])
