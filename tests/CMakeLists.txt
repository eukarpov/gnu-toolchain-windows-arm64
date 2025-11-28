set(CMAKE_VERBOSE_MAKEFILE ON)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fopenmp")

cmake_minimum_required(VERSION 3.14)
project(aarch64_mingw_tests)

add_library(def-export SHARED
  def-export.c
  def-export.def
)

add_library(dll-export SHARED
  dll-export.c
)

set(SOURCES
  bigdata-test.c
  chkstk-test.c
  dll-test.c
  large-alignment-test.c
  large-struct-test.c
  gtest_like_c.c
  main.c
  math-test.c
  nested-functions-test.c
  omp-test.c
  printf-double.c
  sjlj-test.c
  sscanf-double.c
  static-constructor.cpp
  static-function-test.c
  static-function.c
  struct-test.c
  varargs-test.c
  weak-references-test.c
  weak-references.c
)

if (UPSTREAM_VALIDATION)
  add_definitions(-DUPSTREAM_VALIDATION)
else()
  list(APPEND SOURCES
    exception-constructor-test.cpp
    exception-chain-test.cpp
    seh-fregp.cpp
    seh-large-func.cpp
    seh-stack-probing.cpp
    unwind-stack-test.c
  )
endif()

add_executable(aarch64-mingw-tests ${SOURCES})

target_link_libraries(
  aarch64-mingw-tests
  def-export
  dll-export
)

set_source_files_properties(large-alignment-test.c PROPERTIES
  COMPILE_OPTIONS "-fno-lto"
)
