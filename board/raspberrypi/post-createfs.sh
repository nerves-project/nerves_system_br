#!/bin/sh

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
FWUP_CONFIG=$NERVES_ROOT/board/raspberrypi/fwup.conf
BASE_FW_NAME=nerves-rpi-base

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME

