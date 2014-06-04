#!/bin/sh

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
FWUP_CONFIG=$NERVES_ROOT/board/bbb/fwup.conf
BASE_FW_NAME=nerves-bbb-base

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME

