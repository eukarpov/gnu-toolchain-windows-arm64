#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../config.sh

echo "::group::Pack toolchain"
    mkdir -p $ARTIFACT_PATH

    if [ "$PACK_TOOLCHAIN" = "true" ]; then
        tar czf $ARTIFACT_PATH/$TOOLCHAIN_PACKAGE_NAME -C $TOOLCHAIN_PATH .
    else
        tar czf $ARTIFACT_PATH/$TOOLCHAIN_PACKAGE_NAME --files-from /dev/null
    fi

echo "::endgroup::"

echo 'Success!'
