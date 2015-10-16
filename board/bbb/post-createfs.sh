#!/bin/sh

TARGETDIR=$1
HOSTDIR=$TARGETDIR/../host
IMAGEDIR=$TARGETDIR/../images
NERVES_ROOT=$TARGETDIR/../../..

FWUP_CONFIG=$NERVES_ROOT/board/bbb/fwup.conf
BASE_FW_NAME=nerves-bbb-base

# Create u-boot script
$HOSTDIR/usr/bin/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "nerves boot script" -d $NERVES_ROOT/board/bbb/uboot-script.cmd $IMAGEDIR/boot.scr

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME

