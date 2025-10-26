#!/bin/bash
# This script downloads and configures packages, 
# builds and installs the Windows on ARM64 GNU Toolchain.

set -e # exit on error
set -x # echo on

export RUN_BOOTSTRAP=${RUN_BOOTSTRAP:-1}
export UPDATE_SOURCES=${UPDATE_SOURCES:-1}

.github/scripts/build.sh

echo 'Success!'
