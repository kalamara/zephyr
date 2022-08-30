# SPDX-License-Identifier: Apache-2.0

cmake_minimum_required(VERSION 3.20.0)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(external_lib)

target_sources(app PRIVATE src/main.c)

# The external static library that we are linking with does not know
# how to build for this platform so we export all the flags used in
# this zephyr build to the external build system.
#
# Other external build systems may be self-contained enough that they
# do not need any build information from zephyr. Or they may be
# incompatible with certain zephyr options and need them to be
# filtered out.

zephyr_get_include_directories_for_lang(       C includes)
zephyr_get_system_include_directories_for_lang(C system_includes)
zephyr_get_compile_definitions_for_lang(       C definitions)
zephyr_get_compile_options_for_lang(           C options)

set(external_project_cflags
  "${includes} ${definitions} ${options} ${system_includes}"
  )
message("includes=${includes}")	
message("system_includes=${system_includes}")
message("options=${options}")	
message("definitions=${definitions}")

#include(ExternalProject)

# Add an external project to be able download and build the third
# party library. In this case downloading is not necessary as it has
# been committed to the repository.
set(mylib_src_dir   ${CMAKE_CURRENT_SOURCE_DIR}/mylib)
set(mylib_build_dir ${CMAKE_CURRENT_BINARY_DIR})

set(MYLIB_LIB_DIR     ${mylib_build_dir}/lib)
set(MYLIB_INCLUDE_DIR ${mylib_src_dir}/../include)

#add_subdirectory(${mylib_src_dir} ${MYLIB_LIB_DIR})
include(${mylib_src_dir}/mylib.cmake)

target_compile_options(mylib
    PUBLIC ${definitions}
    PUBLIC ${options}
)

#target_include_directories(mylib
        #PUBLIC ${system_includes}
        #PUBLIC ${includes}
#)

# Create a wrapper CMake library that our app can link with
add_library(mylib_lib STATIC IMPORTED GLOBAL)

add_dependencies(
  mylib_lib
  mylib
  )

set_target_properties(mylib_lib PROPERTIES IMPORTED_LOCATION             ${mylib_build_dir}/libmylib.a)
set_target_properties(mylib PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${MYLIB_INCLUDE_DIR})

target_link_libraries(app PUBLIC mylib_lib)
