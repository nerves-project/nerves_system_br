#!/bin/sh

set -e

FWUP_CONFIG=$BR2_EXTERNAL/board/bbb/fwup.conf

# Create/copy u-boot files to the images directory
$HOST_DIR/usr/bin/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "nerves boot script" -d $BR2_EXTERNAL/board/bbb/uboot-script.cmd $BINARIES_DIR/boot.scr

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
