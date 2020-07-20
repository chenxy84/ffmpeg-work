#!/bin/sh

CWD=`pwd`

HOST=darwin-x86_64
API=21
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST

CONFIG_SETTING="--host=arm --target=android --enable-static --disable-shared"

function build() {
	if [ "$1" = "armv7a" ]; then
        ABI=armv7a-linux-androideabi
        TOOLCHAIN_PREFIX=arm-linux-androideabi
    elif [ "$1" = "arm64" ]; then
        ABI=aarch64-linux-android
        TOOLCHAIN_PREFIX=${ABI}
    else 
        echo "Unknown arch [$1]"
        exit
    fi

	export CC=${TOOLCHAIN}/bin/${ABI}${API}-clang
	export CXX=${TOOLCHAIN}/bin/${ABI}${API}-clang++

	export AR=${TOOLCHAIN}/bin/${TOOLCHAIN_PREFIX}-ar
	export LD=${TOOLCHAIN}/bin/${TOOLCHAIN_PREFIX}-ld
	export AS=${TOOLCHAIN}/bin/${TOOLCHAIN_PREFIX}-as
	export RANLIB=${TOOLCHAIN}/bin/${TOOLCHAIN_PREFIX}-ranlib


	export LDFLAGS=$EXTRA_LDFLAGS
	PREFIX=${CWD}/output/android/$1

	mkdir -p $PREFIX

	make clean

	./autogen.sh

	./configure ${CONFIG_SETTING} \
    	--prefix=${PREFIX} \

	make -j$(nproc) && make install

}

build arm64
build armv7a