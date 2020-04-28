

message(STATUS "Crc32c linkage will be static from a package")
set (CRC32C_CMAKE_SCRIPT "${GCS_THRDPARTYHOME}/crc32c/build/crc32c_interfaces.cmake.in" CACHE INTERNAL "")
message(STATUS "using CRC32C_CMAKE_SCRIPT: ${CRC32C_CMAKE_SCRIPT}")

include(${CRC32C_CMAKE_SCRIPT})
add_library(Crc32c::crc32c ALIAS crc32c_lib)
