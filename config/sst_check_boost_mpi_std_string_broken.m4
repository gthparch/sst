AC_DEFUN([SST_CHECK_BOOST_MPI_STD_STRING_BROKEN],
[
# check if BOOST_CLASS_EXPORT and Boost.MPI play nice with std::string
AC_CACHE_CHECK([whether Boost.MPI and std::string are broken],
  [sst_cv_boost_mpi_std_string_broken],
  [AC_LANG_PUSH([C++])
CXX_save="$CXX"
CXX="$MPICXX"
CPPFLAGS_save="$CPPFLAGS"
CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <string>
#include <boost/serialization/string.hpp>
#include <boost/serialization/export.hpp>
#include <boost/mpi.hpp>
class Test {
public:
    std::string tst;
    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & tst;
    }
};
BOOST_CLASS_EXPORT(Test)
]],[[]])],
  [sst_cv_boost_mpi_std_string_broken="no"],
  [sst_cv_boost_mpi_std_string_broken="yes"])
CPPFLAGS="$CPPFLAGS_save"
CXX="$CXX_save"
AC_LANG_POP([C++])])
AS_IF([test "$sst_cv_boost_mpi_std_string_broken" = "yes"], [$1], [$2])
])
