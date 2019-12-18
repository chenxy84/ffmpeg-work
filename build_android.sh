#!/bin/sh

# more info
# https://developer.android.com/ndk/guides/other_build_systems

# HOST_TAG
#macOS darwin-x86_64
#Linux   linux-x86_64
#32-bit Windows  windows
#64-bit Windows  windows-x86_64

# $ export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
# $ export AR=$TOOLCHAIN/bin/aarch64-linux-android-ar
# $ export AS=$TOOLCHAIN/bin/aarch64-linux-android-as
# $ export CC=$TOOLCHAIN/bin/aarch64-linux-android21-clang
# $ export CXX=$TOOLCHAIN/bin/aarch64-linux-android21-clang++
# $ export LD=$TOOLCHAIN/bin/aarch64-linux-android-ld
# $ export RANLIB=$TOOLCHAIN/bin/aarch64-linux-android-ranlib
# $ export STRIP=$TOOLCHAIN/bin/aarch64-linux-android-strip

# ABI
# armeabi-v7a armv7a-linux-androideabi
# arm64-v8a   aarch64-linux-android
# x86 i686-linux-android
# x86-64  x86_64-linux-android

if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi

HOST=darwin-x86_64
API=24
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST
ABI=


export FF_CFG_COMMON_MODULES=
. modules.sh
echo "FF_CFG_COMMON_MODULES $FF_CFG_COMMON_MODULES"

FF_CFG_ARCH=
FF_MODULE_DIRS="compat libavcodec libavfilter libavformat libavutil libswresample libswscale"
FF_ASSEMBLER_SUB_DIRS=


function build_ffmpeg() {
    build_path="$WORK_DIR/build/android/$1"
    rm -rf $build_path
    mkdir -p $build_path
    echo "ffmpeg path: $build_path/ffmpeg"
    cp -a $FF_ROOT $build_path/ffmpeg
    pushd $build_path/ffmpeg
    prefix=$build_path/output

    if [ "$1" = "armv7a" ]; then
        ABI=armv7a-linux-androideabi
        FF_CFG_ARCH=arm
        FF_ASSEMBLER_SUB_DIRS="arm neon"
    elif [ "$1" = "arm64" ]; then
        ABI=aarch64-linux-android
        FF_CFG_ARCH=aarch64
        FF_ASSEMBLER_SUB_DIRS="aarch64 neon"
    else 
        echo "Unknown arch [$1]"
        exit
    fi

    CC=$TOOLCHAIN/bin/$ABI$API-clang
    CXX=$TOOLCHAIN/bin/$ABI$API-clang++
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
        --enable-cross-compile \
        --target-os=android \
        --arch=$FF_CFG_ARCH \
        --cc=$CC \
        --cxx=$CXX \
        --enable-neon \
        --enable-asm \
        --enable-pic \
        --enable-thumb \
        --disable-avdevice \
        --disable-postproc \
        --disable-everything \
        --enable-mediacodec \
        --enable-jni \
        $FF_CFG_COMMON_MODULES \
        --enable-decoder=hevc_mediacodec \
        --enable-decoder=h264_mediacodec \
        \
        
    
     make clean
     make -j8
     make install

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

    $CC -lm -lz -shared -target $ABI$API -Wl,--no-undefined -Wl,-z,noexecstack $FF_EXTRA_LDFLAGS \
        -Wl,-soname,libijkffmpeg.so \
        $FF_C_OBJ_FILES \
        $FF_ASM_OBJ_FILES \
        $FF_DEP_LIBS \
        -o $prefix/libijkffmpeg.so

    popd
}

build_ffmpeg armv7a
build_ffmpeg arm64