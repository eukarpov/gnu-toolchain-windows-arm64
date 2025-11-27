#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../config.sh

cd $ROOT_PATH/tests

if [[ "$RUN_CONFIG" = 1 ]] || [[ ! -f "build/Makefile" ]]; then
  echo "::group::Configure AArch64 Tests"
    rm -rf build

    if [[ "$DEBUG" = 1 ]]; then
        HOST_OPTIONS="$HOST_OPTIONS \
            -DCMAKE_BUILD_TYPE=Debug"
    fi

    if [[ "$UPSTREAM_VALIDATION" = 1 ]]; then
        HOST_OPTIONS="$HOST_OPTIONS \
            -DUPSTREAM_VALIDATION=1"
    fi

    HOST_OPTIONS=" \
      $HOST_OPTIONS \
      -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE"

    cmake -S . \
      -B build \
      $HOST_OPTIONS

  echo "::endgroup::"
fi

echo "::group::Build AArch64 tests"
  cmake --build build
echo "::endgroup::"
