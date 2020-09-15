#----------------------------------------------------------------
# Generated CMake target import file for configuration "RelWithDebInfo".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "libstp_static" for configuration "RelWithDebInfo"
set_property(TARGET libstp_static APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(libstp_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELWITHDEBINFO "C;CXX"
  IMPORTED_LOCATION_RELWITHDEBINFO "/usr/local/lib/libstp.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS libstp_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_libstp_static "/usr/local/lib/libstp.a" )

# Import target "libstp" for configuration "RelWithDebInfo"
set_property(TARGET libstp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(libstp PROPERTIES
  IMPORTED_LINK_INTERFACE_LIBRARIES_RELWITHDEBINFO "/usr/lib/i386-linux-gnu/libboost_program_options.so;/usr/lib/i386-linux-gnu/libboost_system.so"
  IMPORTED_LOCATION_RELWITHDEBINFO "/usr/local/lib/libstp.so"
  IMPORTED_SONAME_RELWITHDEBINFO "libstp.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS libstp )
list(APPEND _IMPORT_CHECK_FILES_FOR_libstp "/usr/local/lib/libstp.so" )

# Import target "stp" for configuration "RelWithDebInfo"
set_property(TARGET stp APPEND PROPERTY IMPORTED_CONFIGURATIONS RELWITHDEBINFO)
set_target_properties(stp PROPERTIES
  IMPORTED_LOCATION_RELWITHDEBINFO "${_IMPORT_PREFIX}/bin/stp"
  )

list(APPEND _IMPORT_CHECK_TARGETS stp )
list(APPEND _IMPORT_CHECK_FILES_FOR_stp "${_IMPORT_PREFIX}/bin/stp" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
