# Install script for directory: /home/ppi/dbt/pattern-dbt/vine-compare/stp-master/lib

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RelWithDebInfo")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libstp.a")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE STATIC_LIBRARY FILES "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/libstp.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libstp.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libstp.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libstp.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libstp.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/libstp.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libstp.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libstp.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libstp.so")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/stp/c_interface.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/stp" TYPE FILE FILES "/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/include/stp/c_interface.h")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Globals/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/AST/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/AbsRefineCounterExample/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Simplifier/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Printer/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Parser/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Interface/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/extlib-abc/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/extlib-constbv/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/STPManager/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/ToSat/cmake_install.cmake")
  include("/home/ppi/dbt/pattern-dbt/vine-compare/stp-master/build/lib/Sat/cmake_install.cmake")

endif()

