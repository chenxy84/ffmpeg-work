#!/bin/sh
FF_VERSION=4.1.4
export WORK_DIR=$(cd $(dirname $0); pwd)
export FF_ROOT=$WORK_DIR/ffmpeg

export XCODE=""
export EMSDK="$HOME/Workspace/SDK/emsdk"


sh $WORK_DIR/build_android.sh $*
