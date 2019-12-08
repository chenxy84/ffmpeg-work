#!/bin/sh
if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi

NDK="$ANDROID_NDK"
NDK_HOST=darwin-x86_64
NDK_API=24

function configure_ffmpeg() {

    abi='armeabi'
    cpu='arm'
    arch='arm'
    android='androideabi'

}

function build_ffmpeg() {
    build_path="$WORK_DIR/build/android/$1"
    rm -rf $build_path
    mkdir -p $build_path
    echo "ffmpeg path: $build_path/ffmpeg"
    cp -a $FF_ROOT $build_path/ffmpeg
    pushd $build_path/ffmpeg

    if [ $1 = "armv7a" ]; then
        abi='armeabi'
        cpu='armv7a'
        arch='arm'
        toolchain_arch="arm"
        android='androideabi'
    else
        abi='arm64-v8a'
        cpu='aarch64'
        arch='arm64'
        toolchain_arch="aarch64"
        android='android'
    fi

    prefix=$build_path/output

    cc=$NDK/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi24-clang
    echo "cc=$cc"

    ./configure --prefix=$prefix \
        --enable-gpl \
        --enable-nonfree \
        --enable-version3 \
        --enable-static \
        --disable-shared \
        --disable-runtime-cpudetect \
        --disable-programs \
        --disable-doc \
        --disable-avdevice \
        --enable-cross-compile \
        --target-os=android \
        --arch=$arch \
        --cc=$cc \
        --cross-prefix=$NDK/toolchains/$toolchain_arch-linux-$android- \
        --sysroot=$NDK/sysroot \
        --enable-neon \
        --enable-asm \
        --enable-pic \
        --enable-thumb \
        --enable-mediacodec \
        # --enable-jni
    # --extra-cflags="-fpic -mfpu=neon -mcpu=cortex-a8 -mfloat-abi=softfp -marm -march=armv7-a"

    # make -j4 && make install

        $NDK/toolchains/$toolchain_arch-linux-$android-ld \
        -rpath-link=$NDK/sysroot/usr/lib \
        -L$NDK/sysroot/usr/lib \
        -L$prefix/usr/lib \
        -soname libffmpeg.so \
        -shared -nostdlib -Bsymbolic --whole-archive --no-undefined \
        -o $prefix/libffmpeg.so \
        libavcodec/libavcodec.a \
        libavfilter/libavfilter.a \
        libswresample/libswresample.a \
        libavformat/libavformat.a \
        libavutil/libavutil.a \
        libswscale/libswscale.a \
        libpostproc/libpostproc.a \
        -lc -lm -lz -ldl -llog \
        --dynamic-linker=/system/bin/linker \
        $toolchain/lib/$toolchain_arch-linux-$android/4.9.x/libgcc.a

}

build_ffmpeg armv7a
# build_ffmpeg armv64
