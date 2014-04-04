#!/bin/sh

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
FWTOOL_CONFIG=$NERVES_ROOT/board/raspberrypi/fwtool.config
BASE_FW_NAME=nerves-rpi-base

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWTOOL_CONFIG $BASE_FW_NAME

