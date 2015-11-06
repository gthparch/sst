# -*- Autoconf -*-
#
#

dnl Init Autoconf/Automake

AC_INIT([SST], [trunk], [sst-users@sst-simulator.org])

AC_PREREQ([2.59])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([config])
AM_INIT_AUTOMAKE([1.9.6 foreign dist-bzip2 subdir-objects no-define tar-ustar])
# If Automake supports silent rules, enable them.
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
m4_pattern_allow([LT_LIBEXT])

dnl information on the package
AC_CONFIG_HEADER([sst/sst_config.h])

AC_ARG_ENABLE(picky, 
    AC_HELP_STRING([--enable-picky],
                   [enable developer-level compiler pickyness when building (default: disabled)]))
if test -z "$enable_picky" && test -d .svn -o -d .hg ; then
    echo "--> developer override: enable picky compiler by default"
    enable_picky=yes
fi

dnl Don't auto-add -finline if user set flags...
AS_IF([test -z "$CXXFLAGS"], [cxxflags_set_by_user=0], [cxxflags_set_by_user=1])
AS_IF([test -z "$LDFLAGS"], [ldflags_set_by_user=0], [ldflags_set_by_user=1])

dnl checks for programs
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_CC_C99
AC_C_INLINE

AC_PROG_CXX
AC_CACHE_SAVE
AC_CHECK_PROG([DOXYGEN], [doxygen], [doxygen])
AM_CONDITIONAL([HAVE_DOXYGEN], [test "$DOXYGEN" = "doxygen"])

dnl Check for C++11 and C++14 features
AC_CXX_COMPILE_STDCXX_1Y
AC_CXX_COMPILE_STDCXX_0X

dnl Set the appropriate flags which have been discovered by the compiler detection
AS_IF([test "x$found_cxx1y" = "xyes"],
	[CXXFLAGS="$CXXFLAGS $SST_CXX1Y_FLAGS"],
	[CXXFLAGS="$CXXFLAGS $SST_CXX0X_FLAGS"])

dnl Check for the vendor of the compiler
AX_CXX_COMPILE_DETECT

dnl Check for C++11 lambda support
SST_CXX_COMPILE_LAMBDA

dnl Check for compiler options to improve C++ inlining and code generation
AS_IF([test $cxxflags_set_by_user -eq 0], [AX_CXX_COMPILE_NATIVE_CHECK])
AS_IF([test $cxxflags_set_by_user -eq 0], [AX_CXX_COMPILE_UNROLL_CHECK])
AS_IF([test $cxxflags_set_by_user -eq 0], [AX_CXX_COMPILE_INLINE_CHECK])
AS_IF([test $cxxflags_set_by_user -eq 0], [SST_CXX_COMPILE_TEMPLATE_DEPTH_CHECK])

AC_SUBST([RPATH_PREFIX])

if test "$enable_picky" = "yes" -a "$GCC" = "yes" ; then
  CFLAGS="$CFLAGS -Wall -Wno-long-long -Wmissing-prototypes -Wstrict-prototypes -Wcomment"
fi

if test "$enable_picky" = "yes" -a "$GXX" = "yes" ; then
  CXXFLAGS="$CXXFLAGS -Wall -Wno-long-long"
fi

dnl Check for any warnings that we need by pragma, GCC and clang are not compatible
AS_IF([test $cxxflags_set_by_user -eq 0], [AX_CXX_COMPILE_UNKNOWN_PRAGMA_WARN_CHECK])

dnl checks for libraries
SST_CHECK_MPI([], [AC_MSG_ERROR([Could not find MPI package])])

AC_PROG_CPP
AC_CANONICAL_HOST

AX_BOOST_BASE([1.53])
AX_BOOST_SERIALIZATION([],[AC_MSG_ERROR([SST requires Boost::Serialization])])
SST_CHECK_BOOST_PROGRAM_OPTIONS([], [AC_MSG_ERROR[SST requires Boost::Program_options])])
SST_CHECK_BOOST_POLYMORPHIC_TYPE([uint64_t], [want_polymorphic=1], [want_polymorphic=0])
SST_CHECK_BOOST_POLYMORPHIC_TYPE([long long], [], [want_polymorphic=0])
AC_DEFINE_UNQUOTED([SST_WANT_POLYMORPHIC_ARCHIVE], [$want_polymorphic],
  [defined to 1 if want boost polymorphic serialization archives])

AC_DEFINE_UNQUOTED([BOOST_LIBDIR], ["$BOOST_LIBDIR"], [Defines the location of the Boost libraries as an SST header definition] )
AC_DEFINE_UNQUOTED([BOOST_CPPFLAGS], ["$BOOST_CPPFLAGS"], [Defines the location of the Boost header files as an SST define] )
AC_DEFINE_UNQUOTED([SST_INSTALL_PREFIX], ["$prefix"], [Defines the location SST will be installed in])

SST_CHECK_MEM_POOL()
SST_CHECK_PARAM_WARNINGS()
SST_ENABLE_DEBUG_OUTPUT()
SST_ENABLE_DEBUG_EVENT_TRACKING()
SST_ENABLE_CORE_PROFILE()
SST_CHECK_OSX()
SST_CHECK_TCMALLOC()
SST_CHECK_LIBZ()
SST_CHECK_PYTHON([have_python=1],
        [have_python=0],
        [AC_MSG_ERROR([Python is needed for GEM5])])


dnl need to use MPI wrapper compilers to make these checks work correctly
SST_CHECK_USING_MPI([
  CC_save="$CC"
  CC="$MPICC"
  CPP_save="$CPP"
  CPP="$MPICPP"])
SST_CHECK_ZOLTAN([have_zoltan=1],[have_zoltan=0],[AC_MSG_ERROR([Zoltan requested but not found])])
AS_IF([test "$have_zoltan" = 1], [AC_DEFINE([HAVE_ZOLTAN], [1], [Define if you have the Zoltan library.])])
AM_CONDITIONAL([HAVE_ZOLTAN], [test "$have_zoltan" = 1])
SST_CHECK_USING_MPI([
   CC="$CC_save"
   CPP="$CPP_save"])

SST_CHECK_LIBRT([have_librt=1], [have_librt=0], [])
SST_CHECK_FFTW([have_fftw=1], [have_fftw=0], [])
SST_CHECK_METIS([have_metis=1], [have_metis=0], [])

AC_CACHE_SAVE

dnl checks for header files
AC_HEADER_TIME
AC_CHECK_HEADERS([c_asm.h dlfcn.h intrinsics.h mach/mach_time.h sys/time.h sys/stat.h sys/types.h unistd.h])
AX_CREATE_STDINT_H([sst/sst_stdint.h])


dnl checks for types
AC_CHECK_TYPE([hrtime_t],[AC_DEFINE(HAVE_HRTIME_T, 1, [Define to 1 if hrtime_t is defined in <sys/time.h>])],,[#if HAVE_SYS_TIME_H
#include <sys/time.h>
#endif])


dnl checks for structures
AC_CACHE_CHECK([whether stat has an st_flags element],
			   [sst_cv_stat_st_flags],
			   [AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]],
							   [[struct stat a; a.st_flags = 0;]])],
							   [sst_cv_stat_st_flags="yes"],
							   [sst_cv_stat_st_flags="no"])])
AC_CACHE_CHECK([whether stat has an st_gen element],
			   [sst_cv_stat_st_gen],
			   [AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]],
							   [[struct stat a; a.st_gen = 0;]])],
							   [sst_cv_stat_st_gen="yes"],
							   [sst_cv_stat_st_gen="no"])])
AC_CACHE_CHECK([whether stat has an st_atimespec element],
			   [sst_cv_stat_st_atimespec],
			   [AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]],
							   [[struct stat a; a.st_atimespec.tv_sec = 0;]])],
							   [sst_cv_stat_st_atimespec="yes"],
							   [sst_cv_stat_st_atimespec="no"])])
AC_CACHE_CHECK([whether stat has an st_mtimespec element],
			   [sst_cv_stat_st_mtimespec],
			   [AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]],
							   [[struct stat a; a.st_mtimespec.tv_sec = 0;]])],
							   [sst_cv_stat_st_mtimespec="yes"],
							   [sst_cv_stat_st_mtimespec="no"])])
AC_CACHE_CHECK([whether stat has an st_ctimespec element],
			   [sst_cv_stat_st_ctimespec],
			   [AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]],
							   [[struct stat a; a.st_ctimespec.tv_sec = 0;]])],
							   [sst_cv_stat_st_ctimespec="yes"],
							   [sst_cv_stat_st_ctimespec="no"])])
AS_IF([test "x$sst_cv_stat_st_flags" == "xyes"],
	  [AC_DEFINE([HAVE_STAT_ST_FLAGS], [1], [define if stat has an st_flags field])])
AS_IF([test "x$sst_cv_stat_st_gen" == "xyes"],
	  [AC_DEFINE([HAVE_STAT_ST_GEN], [1], [define if stat has an st_gen field])])
AS_IF([test "x$sst_cv_stat_st_atimespec" == "xyes"],
	  [AC_DEFINE([HAVE_STAT_ST_ATIMESPEC], [1], [define if stat has an st_atimespec field])])
AS_IF([test "x$sst_cv_stat_st_mtimespec" == "xyes"],
	  [AC_DEFINE([HAVE_STAT_ST_MTIMESPEC], [1], [define if stat has an st_mtimespec field])])
AS_IF([test "x$sst_cv_stat_st_ctimespec" == "xyes"],
	  [AC_DEFINE([HAVE_STAT_ST_CTIMESPEC], [1], [define if stat has an st_ctimespec field])])
SST_HASH_SETS([],[AC_MSG_ERROR([C++ compiler MUST provide a hash map of some kind])])

dnl checks for compiler characteristics
AC_C_BIGENDIAN

AC_DEFINE([__STDC_FORMAT_MACROS], [1], [define to enable C99 PRI and SCN codes in C++])

dnl checks for library functions
AC_CHECK_FUNCS([gethrtime read_real_time time_base_to_time clock_gettime mach_absolute_time])

dnl Cray UNICOS _rtc() (real-time clock) intrinsic
AC_MSG_CHECKING([for _rtc intrinsic])
rtc_ok=yes
AC_TRY_LINK([#ifdef HAVE_INTRINSICS_H
#include <intrinsics.h>
#endif], [_rtc()], [AC_DEFINE(HAVE__RTC,1,[Define if you have the UNICOS _rtc() intrinsic.])], [rtc_ok=no])
AC_MSG_RESULT($rtc_ok)

dnl Init Libtool

dnl Unfortunately, some MPI implementations provide libltdl as part of
dnl their library (I'm looking at you, LAM/MPI and Open MPI).  Open
dnl MPI fixes the problem of conflicts in 1.3.4 by setting the symbol
dnl visibility to hidden for libltdl, which seems to allow us to run
dnl two instances of libltdl side-by-side.  If there's already a
dnl lt_dlinit in our stack that is too old, fail.
SST_CHECK_USING_MPI([
  CC_save="$CC"
  CC="$MPICC"
  AC_CHECK_FUNC([lt_dlinit], [previous_ltdl=1], [previous_ltdl=0])
  AC_CHECK_FUNC([lt_dladvise_init], [previous_ltdl2=1], [previous_ltdl2=0])
  CC="$CC_save"
  AS_IF([test $previous_ltdl -eq 0 -o $previous_ltdl2 -eq 1],[],
      [AC_MSG_ERROR([Your MPI exposes a version of libltdl too old for us to use.])])
])

LT_CONFIG_LTDL_DIR([sst/core/libltdl])
LT_INIT([shared disable-static dlopen])
LTDL_INIT([recursive])
# The lt_dladvise_init symbol was added with libtool-2.2
if test "x$with_included_ltdl" != "xyes"; then
   save_CFLAGS="$CFLAGS"
   save_LDFLAGS="$LDFLAGS"
   save_LIBS="$LIBS"
   CFLAGS="$CFLAGS $LTDLINCL"
   LDFLAGS="$LDFLAGS $LIBLTDL"
   AC_CHECK_LIB([ltdl], [lt_dladvise_init],
                 [],
                 [AC_MSG_ERROR([installed libltdl is too old])])
   LIBS="$save_LIBS"
   LDFLAGS="$save_LDFLAGS"
   CFLAGS="$save_CFLAGS"
fi
AC_SUBST([LTDLINCL])
AC_SUBST([LIBLTDL])

dnl Fix flags - seems to be only way to make libltdl play nice
CPPFLAGS='-I$(top_builddir) -I$(top_srcdir)'" $CPPFLAGS"

dnl Get install directory.  Make an ac_subst so that our install
dnl directory can change without changing sst_config.h.  $exec_prefix
dnl defaults to NONE, which AC uses as a sentinal to indicate to fall
dnl back to $prefix.  $prefix defaults to NONE, which AC uses as a
dnl sentinal to indicate to fall back to ac_default_prefix.  As far as
dnl I know, $ac_default_prefix is always something rational.  Expand
dnl exec_prefix accordingly until we get something rational.
exec_prefix_save=$exec_prefix
test "x$exec_prefix" = xNONE && exec_prefix=${prefix}
test "x$exec_prefix" = xNONE && exec_prefix=${ac_default_prefix}
eval SST_ELEMLIB_DIR=${libdir}/sst
exec_prefix=$exec_prefix_save
AC_SUBST(SST_ELEMLIB_DIR)

AC_CACHE_SAVE


dnl Configure sub-components
SST_CONFIGURE_ELEMENTS

dnl Do this after configuring elements.  They might not test linking using libtool
AS_IF([test "$enable_static" = "yes" -a "$enable_shared" = "no"],
      [LDFLAGS="-static-libtool-libs $LDFLAGS"],
      [])

dnl Final output

dnl Cause Automake to delete emacs-turds
CLEANFILES="*~"
AC_SUBST(CLEANFILES)

dnl last minute checks to allow "make distcheck" to work
DISTCHECK_CONFIGURE_FLAGS=
if test -n "$with_boost" ; then
  DISTCHECK_CONFIGURE_FLAGS="$DISTCHECK_CONFIGURE_FLAGS --with-boost=${with_boost}"
fi
if test -n "$with_parmetis" ; then
  DISTCHECK_CONFIGURE_FLAGS="$DISTCHECK_CONFIGURE_FLAGS --with-parmetis=${with_parmetis}"
fi
if test -n "$with_zoltan" ; then
  DISTCHECK_CONFIGURE_FLAGS="$DISTCHECK_CONFIGURE_FLAGS --with-zoltan=${with_zoltan}"
fi
AC_SUBST(DISTCHECK_CONFIGURE_FLAGS)

AC_MSG_CHECKING([for SST Subversion revision number])
if test -d ".svn" ; then
	SST_SVN_REVISION="r"`svn info . | grep "Revision:" | cut -d " " -f 2`
	AC_MSG_RESULT([${SST_SVN_REVISION}])
else
	SST_SVN_REVISION="${PACKAGE_VERSION}"
	AC_MSG_RESULT([${PACKAGE_VERSION}])
fi

AC_SUBST(SST_SVN_REVISION)
AC_DEFINE_UNQUOTED([SST_SVN_REVISION], ["$SST_SVN_REVISION"], [SST SVN Revision])

AC_DEFINE_UNQUOTED([SST_CPPFLAGS], ["$CPPFLAGS"], [C Preprocessor Flags used for SST])
AC_DEFINE_UNQUOTED([SST_CFLAGS], ["$CFLAGS"], [C Flags used for SST])
AC_DEFINE_UNQUOTED([SST_CXXFLAGS], ["$CXXFLAGS"], [C++ Flags used for SST])
AC_DEFINE_UNQUOTED([SST_CC], ["$CC"], [C Compiler used for SST])
AC_DEFINE_UNQUOTED([SST_CXX], ["$CXX"], [C++ Compiler used for SST])
AC_DEFINE_UNQUOTED([SST_MPICC], ["$MPICC"], [MPI C Compiler used for SST])
AC_DEFINE_UNQUOTED([SST_MPICXX], ["$MPICXX"], [MPI C++ Compiler used for SST])
AC_DEFINE_UNQUOTED([SST_LD], ["$LD"], [Linker used for SST])
AC_DEFINE_UNQUOTED([SST_LDFLAGS], ["$LDFLAGS"], [Linker Flags used for SST])

AC_CONFIG_FILES([
  Makefile
  doc/Makefile
  doc/Doxyfile
  sst/Makefile
  sst/SST-${PACKAGE_VERSION}.pc:sst/sst.pc.in
  sst/core/build_info.h
  sst/core/Makefile
  sst/core/libltdl/Makefile
  sst/elements/Makefile
])
AC_OUTPUT

echo ""
echo "-------------------------------------------------------"
echo "SST Configuration completed."
echo "-------------------------------------------------------"
echo "Build Environment:"
echo ""
printf "%38s : %s\n" "Preprocessor" "$CPP"
printf "%38s : %s\n" "C++ Compiler" "$CXX"
printf "%38s : %s\n" "C Compiler" "$CC"
printf "%38s : %s\n" "MPI C Compiler" "$MPICC"
printf "%38s : %s\n" "MPI C++ Compiler" "$MPICXX"
printf "%38s : %s\n" "Linker" "$LD"
printf "%38s : %s\n" "Preprocessor Options" "$CPPFLAGS"
printf "%38s : %s\n" "C Compiler Options" "$CFLAGS"
printf "%38s : %s\n" "C++ Compiler Options" "$CXXFLAGS"

if test "x$found_cxx1y" = "xyes"; then
printf "%38s : %s\n" "C++ Standard Compliance" "C++1Y/14"
else
printf "%38s : %s\n" "C++ Standard Compliance" "C++11"
fi

printf "%38s : %s\n" "Linker Options" "$LDFLAGS"
printf "%38s : %s\n" "Boost Library Preprocessor" "$BOOST_CPPFLAGS"
printf "%38s : %s\n" "Boost Library Linker Options" "$BOOST_LDFLAGS"
echo "-------------------------------------------------------"
echo "Configuration Information (Dependencies):"
echo ""

if test "x$sst_check_metis_happy" = "xyes"; then
    printf "%38s : YES\n" "METIS Partitioner Library"
else
    printf "%38s : No\n" "METIS Partitioner Library"
fi

if test "x$sst_check_dramsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "DRAMSim Memory Simulation Library"
else
    printf "%38s : No\n" "DRAMSim Memory Simulation Library"
fi

if test "x$sst_check_hybridsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "HybridSim"
else
    printf "%38s : No\n" "HybridSim"
fi

if test "x$sst_check_pintool_happy" = "xyes" ; then
    printf "%38s : YES\n" "PIN Tool"
else
    printf "%38s : No\n" "PIN Tool"
fi

if test "x$sst_check_glpk_happy" = "xyes" ; then
    printf "%38s : YES\n" "GLPK Optimization Library"
else
    printf "%38s : No\n" "GLPK Optimization Library"
fi

if test "x$sst_check_tcmalloc_happy" = "xyes" ; then
    printf "%38s : YES\n" "TC-Malloc"
else
    printf "%38s : No\n" "TC-Malloc"
fi

if test "x$sst_check_zoltan_happy" = "xyes" ; then
    printf "%38s : YES\n" "Zoltan Partitioner"
else
    printf "%38s : No\n" "Zoltan Partitioner"
fi

if test "x$sst_check_dumpi_happy" = "xyes" ; then
    printf "%38s : YES\n" "DUMPI"
else
    printf "%38s : No\n" "DUMPI"
fi

if test "x$sst_check_otf_happy" = "xyes" ; then
    printf "%38s : YES\n" "OTF"
else
    printf "%38s : No\n" "OTF"
fi

if test "x$sst_check_otf2_happy" = "xyes"; then
    printf "%38s : YES\n" "OTF-2"
else
    printf "%38s : YES\n" "OTF-2"
fi

if test "x$sst_gem5_happy" = "xyes" ; then
    printf "%38s : YES\n" "Gem5"
else
    printf "%38s : No\n" "Gem5"
fi

if test "x$sst_check_qsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "QSim"
else
    printf "%38s : No\n" "QSim"
fi

if test "x$sst_checkgoblin_hmcsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "GOBLIN HMC Sim"
else
    printf "%38s : No\n" "GOBLIN HMC Sim"
fi

if test "x$sst_check_nvdimmsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "NVDIMM Sim"
else
    printf "%38s : No\n" "NVDIMM Sim"
fi

if test "x$sst_check_fdsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "FlashDIMM Sim"
else
    printf "%38s : No\n" "FlashDIMM Sim"
fi

if test "x$sst_check_systemc_happy" = "xyes" ; then
    printf "%38s : YES\n" "SystemC Runtime"
else
    printf "%38s : No\n" "SystemC Runtime"
fi

if test "x$sst_micron_hmcsim_happy" = "xyes" ; then
    printf "%38s : YES\n" "Micron HMC Sim"
else
    printf "%38s : No\n" "Micron HMC Sim"
fi

echo "-------------------------------------------------------" 
echo "Configuration Information (SST will build the following elements):"
echo ""
#for e in $active_elemlibs ; do echo "        $e" ; done
list=$(echo "sst_elemlib_list" | tr ',' ' ')
for e in $list
do
    echo "$active_elemlibs" | grep "$e" >/dev/null
    if test $? -eq 0 ; then
        msg="YES"
    else
        msg="no"
    fi
    printf "%38s : $msg\n" "$e"
done

echo "-------------------------------------------------------"
echo ""
