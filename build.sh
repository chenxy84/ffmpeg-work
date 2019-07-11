#!/bin/sh
FF_VERSION=4.1.4
export WORK_DIR=$(cd $(dirname $0); pwd)
export FF_ROOT=$WORK_DIR/ffmpeg-$FF_VERSION

export XCODE=""
export EMSDK="$HOME/Workspace/SDK/emsdk"


pushd $WORK_DIR
# check ffmpeg repo
if [ ! -d $FF_ROOT ]; then
    if [ ! -f $FF_ROOT.tar.bz2 ]; then
        echo "Download ffmpeg version: $FF_VERSION"
        curl -O "https://ffmpeg.org/releases/ffmpeg-$FF_VERSION.tar.bz2"
    fi
    tar zxvf $FF_ROOT.tar.bz2 -C $WORK_DIR
fi

sh $WORK_DIR/build_android.sh $*
