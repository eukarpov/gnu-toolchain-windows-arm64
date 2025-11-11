#!/bin/bash
# This script downloads and configures packages, 
# builds and installs the Windows on ARM64 GNU Toolchain.

set -e # exit on error
set -x # echo on

RUN_BOOTSTRAP=${RUN_BOOTSTRAP:-1}
UPDATE_SOURCES=${UPDATE_SOURCES:-1}

RUN_BOOTSTRAP=$RUN_BOOTSTRAP UPDATE_SOURCES=$UPDATE_SOURCES .github/scripts/build.sh

if [[ " $* " == *" --native-toolchain "* ]]; then
  echo "Build the native toolchain"
  TOOLCHAIN_PATH=$(source .github/scripts/config.sh; echo $TOOLCHAIN_PATH)
  PATH_EXT=$TOOLCHAIN_PATH/lib/ccache:$TOOLCHAIN_PATH/bin:$PATH
  PATH=$PATH_EXT .github/scripts/zlib/build.sh
  PATH=$PATH_EXT HOST=aarch64-w64-mingw32 .github/scripts/build.sh
fi

echo 'Success!'
