#!/bin/sh
if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi

export FF_CFG_COMMON_MODULES=
. modules.sh
echo "FF_CFG_COMMON_MODULES $FF_CFG_COMMON_MODULES"

function build_ffmpeg() {
    build_path="$WORK_DIR/build/ios"
    rm -rf $build_path
    mkdir -p $build_path
    echo "ffmpeg path: $build_path/ffmpeg"
    cp -a $FF_ROOT $build_path/ffmpeg
    pushd $build_path/ffmpeg
    prefix=$build_path/output

    FF_CFG_ARCH="arm64"
    DEPLOYMENT_TARGET="9.0"

    CC="xcrun -sdk iphoneos clang -arch arm64 -v"
    CFLAGS="$CFLAGS -mios-version-min=$DEPLOYMENT_TARGET -fembed-bitcode"
    LDFLAGS="$CFLAGS"
    EXPORT="GASPP_FIX_XCODE5=1"
    AS="$WORK_DIR/gas-preprocessor.pl -arch aarch64 -- $CC"
    echo "CC=$CC"
    echo "AS=$AS"

    ./configure --prefix=$prefix \
        --enable-gpl \
        --enable-nonfree \
        --enable-version3 \
        --enable-static \
        --disable-shared \
        --disable-runtime-cpudetect \
        --disable-programs \
        --disable-doc \
        --enable-cross-compile \
        --target-os=darwin \
        --arch=$FF_CFG_ARCH \
        --cc="$CC" \
        --as="$AS" \
        --extra-cflags="$CFLAGS" \
        --extra-ldflags="$LDFLAGS" \
        --enable-neon \
        --enable-asm \
        --enable-pic \
        --enable-thumb \
        --disable-avdevice \
        --disable-postproc \
        --disable-everything \
        $FF_CFG_COMMON_MODULES \
        \
        
     make clean
     make -j8 $EXPORT
     make install

     popd
}

build_ffmpeg