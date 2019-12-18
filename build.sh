#!/bin/sh
export WORK_DIR=$(cd $(dirname $0); pwd)
export FF_ROOT=$WORK_DIR/ffmpeg

export XCODE=""
export EMSDK="$HOME/Workspace/SDK/emsdk"

echo "Build $1 start ..."

if [ "$1" = "iOS" ]; then
	sh $WORK_DIR/build_ios.sh $*
elif [ "$1" = "Android" ]; then
	sh $WORK_DIR/build_android.sh $*
else
	sh $WORK_DIR/build_macos.sh $*
fi

echo "Build $1 finished"

