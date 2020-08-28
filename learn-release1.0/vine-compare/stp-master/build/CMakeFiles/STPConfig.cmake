# Config file for the installed STP Package
# It defines the following variables
#  STP_INCLUDE_DIRS - include directories for STP
#  STP_STATIC_LIBRARY - static library target (empty if not built)
#  STP_SHARED_LIBRARY - dynamic library target (empty if not built)
#  STP_EXECUTABLE   - the stp executable

# Compute paths
get_filename_component(STP_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(STP_INCLUDE_DIRS "/usr/local/include")

# Our library dependencies (contains definitions for IMPORTED targets)
include("${STP_CMAKE_DIR}/STPTargets.cmake")

# These are IMPORTED targets created by STPTargets.cmake
set(STP_EXECUTABLE stp)

set(STP_STATIC_LIBRARY libstp_static)
set(STP_SHARED_LIBRARY libstp)
