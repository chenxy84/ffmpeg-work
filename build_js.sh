#!/bin/sh
if [ "$WORK_DIR" = "" -o "$FF_ROOT" = "" ]; then
    echo "Please use build.sh"
    exit 1
fi
