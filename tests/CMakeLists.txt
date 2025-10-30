set(CMAKE_VERBOSE_MAKEFILE ON)

if (NOT DEFINED ENV{TARGET}) 
  set(ENV{TARGET} "aarch64-w64-mingw32") 
endif()

set(CMAKE_C_COMPILER "$ENV{TARGET}-gcc")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fopenmp")

set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

cmake_minimum_required(VERSION 3.14)
project(aarch64_mingw_tests)

enable_testing()

add_library(simple-dll SHARED dll.c)

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
  simple-dll
)

set_source_files_properties(large-alignment-test.c PROPERTIES COMPILE_OPTIONS "-fno-lto")
set_target_properties(simple-dll PROPERTIES SUFFIX ".dll")
set_target_properties(simple-dll PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set_target_properties(aarch64-mingw-tests PROPERTIES SUFFIX ".exe")
set_target_properties(aarch64-mingw-tests PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
