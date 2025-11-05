#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

echo "::group::Install libraries"

    # Download and install packages
    cd $SOURCE_PATH/gcc
    ./contrib/download_prerequisites

    # Patch older ISL config version that does not recognize arm64
    if [[ "$BUILD" =~ arm64-apple ]] && ! grep -q "arm64-*" isl/config.sub; then
        sed -i '.bak' 's/ arm-\*/ arm-* | arm64-*/' isl/config.sub
    fi

    # Symbolic links for binutils dependencies
    cd $SOURCE_PATH/binutils
    ln -sf $SOURCE_PATH/gcc/gmp gmp
    ln -sf $SOURCE_PATH/gcc/mpfr mpfr

echo "::endgroup::"

echo 'Success!'
