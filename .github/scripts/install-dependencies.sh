#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/config.sh

echo "::group::Install Dependencies"
  if [[ "$BUILD" =~ apple ]]; then
    brew install \
      ccache \
      texinfo
  else
    sudo apt update
    sudo apt install -y \
      autoconf \
      autogen \
      automake \
      autotools-dev \
      binutils-for-build \
      bison \
      build-essential \
      busybox \
      ccache \
      dejagnu \
      docbook2x \
      flex \
      gdc \
      jq \
      libc6-dev-arm64-cross \
      libc6-dev-amd64-cross \
      texinfo \
      xmlto \
      zlib1g-dev \
      zstd
  fi
echo "::endgroup::"

echo 'Success!'
