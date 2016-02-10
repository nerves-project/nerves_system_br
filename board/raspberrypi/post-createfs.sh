#!/bin/sh

TARGETDIR=$1
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
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME
