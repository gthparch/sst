
AC_DEFUN([SST_CHECK_BOOST_FILESYSTEM],
[
	happy="yes"

	CPPFLAGS_SAVED="$CPPFLAGS"
	LDFLAGS_SAVED="$LDFLAGS"
	LIBS_SAVED="$LIBS"

	CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
	LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"

	AC_MSG_NOTICE([Performing include checks for Boost Filesystem...])
	AC_LANG_PUSH([C++])
	AC_CHECK_HEADER([boost/filesystem.hpp], [], [happy="no"])
	AC_LANG_POP([C++])

	AC_MSG_NOTICE([Performing linking checks for Boost Filesystem...])
	BOOST_FILESYSTEM_LIB="-lboost_filesystem -lboost_system"
	LIBS="$LIBS_SAVED $BOOST_FILESYSTEM_LIB"
	AC_LANG_PUSH([C++])
	AC_LINK_IFELSE([
		AC_LANG_PROGRAM(
		[[#include <iostream>
		#include <boost/filesystem.hpp>
		using namespace std;
		using namespace boost::filesystem;
		]],
		[[  		
		path p ("/tmp/myfile");

		// Call the Boost exists function
  		if (exists(p))
  		{
			return 0;
		}
		]]
		)], [happy="yes"], [happy="no"])
	AC_LANG_POP([C++])
     AS_IF([test "$happy" = "no"], [
	BOOST_FILESYSTEM_LIB="-lboost_filesystem-mt -lboost_system-mt"
	LIBS="$LIBS_SAVED $BOOST_FILESYSTEM_LIB"
	AC_LANG_PUSH([C++])
	AC_LINK_IFELSE([
		AC_LANG_PROGRAM(
		[[#include <iostream>
		#include <boost/filesystem.hpp>
		using namespace std;
		using namespace boost::filesystem;
		]],
		[[  		
		path p ("/tmp/myfile");

		// Call the Boost exists function
  		if (exists(p))
  		{
			return 0;
		}
		]]
		)], [happy="yes"], [happy="no"])
	AC_LANG_POP([C++])
])

	AC_SUBST(BOOST_FILESYSTEM_LIB)

	LIBS="$LIBS_SAVED"
	CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"

	AS_IF([test "$happy" = "yes"], 
		[AC_MSG_NOTICE([Boost Filesystem configuration successful.])], 
		[AC_MSG_ERROR([Boost Filesystem configuration failed to compile/link successfully.],[1])])
])
