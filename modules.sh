export FF_CFG_COMMON_MODULES=

export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-decoder=aac"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-decoder=mp3"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-decoder=h264"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-decoder=hevc"

export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-filter=aresample"

export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=aac"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=mp3"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=h264"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=hevc"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=mpeg*"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=flv"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=mov"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=m4v"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-demuxer=matroska"

export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-protocol=http"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-protocol=file"
export FF_CFG_COMMON_MODULES="$FF_CFG_COMMON_MODULES --enable-protocol=rtmp"