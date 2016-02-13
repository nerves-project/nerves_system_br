#!/bin/sh

set -e

# TARGET_DIR=$1 # TARGET_DIR is always passed as the first argument
FWUP_CONFIG=$2

BASE_FW_NAME=nerves-rpi-base

# Process the kernel if using device tree
if [ -e $BR2_EXTERNAL/host/usr/bin/mkknlimg ]; then
    $BR2_EXTERNAL/host/usr/bin/mkknlimg \
        $BINARIES_DIR/zImage $BINARIES_DIR/zImage.mkknlimg
fi

# Copy the boot config files over
cp $BR2_EXTERNAL/board/raspberrypi/config.txt $BINARIES_DIR
cp $BR2_EXTERNAL/board/raspberrypi/cmdline.txt $BINARIES_DIR
cp $FWUP_CONFIG $BINARIES_DIR/fwup.conf

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG $BASE_FW_NAME
