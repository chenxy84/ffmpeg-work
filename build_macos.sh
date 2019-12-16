#!/bin/sh
if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi

export FF_CFG_COMMON_MODULES=
. modules.sh
echo "FF_CFG_COMMON_MODULES $FF_CFG_COMMON_MODULES"

function build_ffmpeg() {
    build_path="$WORK_DIR/build/macos"
    rm -rf $build_path
    mkdir -p $build_path
    echo "ffmpeg path: $build_path/ffmpeg"
    cp -a $FF_ROOT $build_path/ffmpeg
    pushd $build_path/ffmpeg
    prefix=$build_path/output

    ./configure --prefix=$prefix \
        --enable-gpl \
        --enable-nonfree \
        --enable-version3 \
        --enable-static \
        --disable-shared \
        --disable-doc \
        --disable-postproc \
        --disable-everything \
        $FF_CFG_COMMON_MODULES \
        --enable-sdl2 \
        \
    
     make clean
     make -j8
     make install

}

build_ffmpeg