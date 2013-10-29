#!/bin/sh

#
# Post create filesystem hook
#  - Create the firmware images

TARGETDIR=$1
NERVES_SDK_DIR=$TARGETDIR/../../..

BOARDDIR=$NERVES_SDK_DIR/board/bbb
IMAGESDIR=$TARGETDIR/../images
FWTOOL=$TARGETDIR/../host/usr/bin/fwtool

# Build the firmware image
$FWTOOL -c $BOARDDIR/fwtool.config \
	--mlo_path=$IMAGESDIR/MLO \
	--uboot_path=$IMAGESDIR/u-boot.img \
	--rootfs_path=$IMAGESDIR/rootfs.ext2 \
	create $IMAGESDIR/bbb.fw 

# Build the raw image for the bulk programmer
$FWTOOL -d $IMAGESDIR/bbb-sdcard.img \
	-t complete \
	run $IMAGESDIR/bbb.fw 

