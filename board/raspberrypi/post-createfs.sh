#!/bin/sh

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
IMAGESDIR=$TARGETDIR/../images
FWUP_CONFIG=$NERVES_ROOT/board/raspberrypi/fwup.conf
BASE_FW_NAME=nerves-rpi-base

# Process the kernel if using device tree
if [ -e $NERVES_ROOT/buildroot/output/host/usr/bin/mkknlimg ]; then
    $NERVES_ROOT/buildroot/output/host/usr/bin/mkknlimg \
        $IMAGESDIR/zImage $IMAGESDIR/zImage.mkknlimg
fi

# Copy the boot config files over
cp $NERVES_ROOT/board/raspberrypi/config.txt $IMAGESDIR
cp $NERVES_ROOT/board/raspberrypi/cmdline.txt $IMAGESDIR

# Run the common post-image processing for nerves
$NERVES_ROOT/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME
