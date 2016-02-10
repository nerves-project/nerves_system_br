#!/bin/sh

TARGETDIR=$1

IMAGESDIR=$TARGETDIR/../images
FWUP_CONFIG=$NERVES_SYSTEM/board/galileo/fwup.conf
BASE_FW_NAME=nerves-galileo-base

# Run the common post-image processing for nerves
$NERVES_SYSTEM/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME
