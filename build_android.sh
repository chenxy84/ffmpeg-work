#!/bin/sh
if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi

HOST=darwin-x86_64
API=24
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST/
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-

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

    CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
    CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
    echo "CC=$CC"
    echo "CXX=$CXX"

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
        --cc=$CC \
        --cxx=$CXX \
        --enable-neon \
        --enable-asm \
        --enable-pic \
        --enable-thumb \
        --enable-nonfree \
        --disable-avdevice \
        --disable-postproc \
        --disable-avfilter \
        --disable-everything \
        --enable-mediacodec \
        --enable-jni \
        --enable-decoder=hevc_mediacodec --enable-demuxer=hevc \
        --enable-decoder=h264_mediacodec --enable-demuxer=h264 \
    
     make -j4 && make install


     FF_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
     FF_ASSEMBLER_SUB_DIRS=

     FF_ASSEMBLER_SUB_DIRS="aarch64 neon"


FF_C_OBJ_FILES=
FF_ASM_OBJ_FILES=
for MODULE_DIR in $FF_MODULE_DIRS
do
    C_OBJ_FILES="$build_path/ffmpeg/$MODULE_DIR/*.o"
    echo $C_OBJ_FILES
    if ls $C_OBJ_FILES 1> /dev/null 2>&1; then
        echo "link $build_path/ffmpeg/$MODULE_DIR/*.o"
        FF_C_OBJ_FILES="$FF_C_OBJ_FILES $C_OBJ_FILES"
    fi

    for ASM_SUB_DIR in $FF_ASSEMBLER_SUB_DIRS
    do
        ASM_OBJ_FILES="$build_path/ffmpeg/$MODULE_DIR/$ASM_SUB_DIR/*.o"
        if ls $ASM_OBJ_FILES 1> /dev/null 2>&1; then
            echo "link $build_path/ffmpeg/$MODULE_DIR/$ASM_SUB_DIR/*.o"
            FF_ASM_OBJ_FILES="$FF_ASM_OBJ_FILES $ASM_OBJ_FILES"
        fi
    done
done


FF_ANDROID_PLATFORM=android-24
FF_SYSROOT_ARCH="arch-arm64"
FF_SYSROOT=$ANDROID_NDK/platforms/$FF_ANDROID_PLATFORM/$FF_SYSROOT_ARCH

$CC -lm -lz -shared --sysroot=$FF_SYSROOT -Wl,--no-undefined -Wl,-z,noexecstack $FF_EXTRA_LDFLAGS \
    -Wl,-soname,libijkffmpeg.so \
    $FF_C_OBJ_FILES \
    $FF_ASM_OBJ_FILES \
    $FF_DEP_LIBS \
    -o $prefix/libijkffmpeg.so

}


# build_ffmpeg armv7a
build_ffmpeg armv64