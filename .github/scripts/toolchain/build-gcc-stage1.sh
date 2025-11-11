#!/bin/bash

source `dirname ${BASH_SOURCE[0]}`/../config.sh

GCC_BUILD_PATH=$BUILD_PATH/gcc-stage1

mkdir -p $GCC_BUILD_PATH
cd $GCC_BUILD_PATH

if [[ "$RUN_CONFIG" = 1 ]] || [[ ! -f "$GCC_BUILD_PATH/Makefile" ]]; then
    echo "::group::Configure GCC stage1"
        rm -rf $GCC_BUILD_PATH/*

        if [[ "$DEBUG" = 1 ]]; then
            HOST_OPTIONS="$HOST_OPTIONS \
                --enable-debug"
        else
            HOST_OPTIONS="$HOST_OPTIONS \
                --disable-debug"
            CFLAGS="$CFLAGS -O2"
            CXXFLAGS="$CXXFLAGS -O2"
            LDFLAGS="$LDFLAGS -s"
        fi

       TARGET_OPTIONS="$TARGET_OPTIONS \
            --disable-nls \
            --disable-multilib"

        case "$HOST" in
            *mingw32*)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --without-zstd"

                CFLAGS="$CFLAGS -I$INSTALL_PATH/zlib/$TARGET/include"
                LDFLAGS="$LDFLAGS -Wl,--dynamicbase,--nxcompat,--high-entropy-va $INSTALL_PATH/zlib/$TARGET/lib/libz-static.a"
                ;;
            *)
                HOST_OPTIONS="$HOST_OPTIONS \
                    --with-system-zlib"
                ;;
        esac

        case "$ARCH" in
            x86_64)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --with-arch=nocona \
                    --with-tune=generic"
                ;;
            aarch64)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --with-arch=armv8-a \
                    --with-tune=cortex-a53"
                ;;
        esac

        case "$PLATFORM" in
            *linux*)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --enable-languages=c,lto \
                    --enable-threads=posix"
                ;;
            *cygwin*)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --enable-languages=c,c++,lto \
                    --disable-__cxa_atexit \
                    --enable-threads=posix \
                    --with-dwarf2"
                ;;
            *mingw*)
                TARGET_OPTIONS="$TARGET_OPTIONS \
                    --enable-languages=c \
                    --disable-isl-version-check \
                    --disable-rpath \
                    --disable-win32-registry \
                    --disable-werror \
                    --disable-symvers"
                ;;
        esac

    CFLAGS="$CFLAGS" \
    CXXFLAGS="$CXXFLAGS" \
    LDFLAGS="$LDFLAGS" \
    $SOURCE_PATH/gcc/configure \
        --prefix=$TOOLCHAIN_PATH \
        --build=$BUILD \
        --host=$HOST \
        --target=$TARGET \
        --enable-static \
        --disable-shared \
        --disable-bootstrap \
        --disable-plugins \
        --disable-gcov \
        --disable-libatomic \
        --disable-libgomp \
        --disable-libvtv \
        --disable-libquadmath \
        --disable-libssp \
        --with-gnu-as \
        --with-gnu-ld \
        --without-headers \
        $HOST_OPTIONS \
        $TARGET_OPTIONS
    echo "::endgroup::"
fi

echo "::group::Build GCC stage1"
    make $BUILD_MAKE_OPTIONS
echo "::endgroup::"

if [[ "$RUN_INSTALL" = 1 ]]; then
    echo "::group::Install GCC stage1"
        make install
        if [[ "$DELETE_BUILD" = 1 ]]; then
            rm -rf $GCC_BUILD_PATH
        fi
    echo "::endgroup::"
fi

echo 'Success!'
