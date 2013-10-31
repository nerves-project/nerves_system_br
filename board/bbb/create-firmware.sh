#!/bin/sh

#
# create-firmware.sh <TARGETDIR>
#
# Expected environment variables:
#  NERVES_ROOT
#  NERVES_SDK_IMAGES
#  NERVES_SDK_ROOT

TARGETDIR=$1

FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool

# Build the firmware image
$FWTOOL -c $NERVES_ROOT/board/bbb/fwtool.config \
	--mlo_path=$NERVES_SDK_IMAGES/MLO \
	--uboot_path=$NERVES_SDK_IMAGES/u-boot.img \
	--rootfs_path=$NERVES_SDK_IMAGES/rootfs.ext2 \
	create $NERVES_SDK_IMAGES/bbb.fw

# Build the raw image for the bulk programmer
$FWTOOL -c $NERVES_ROOT/board/bbb/fwtool.config \
	-d $NERVES_SDK_IMAGES/bbb-sdcard.img \
	-t complete \
	run $NERVES_SDK_IMAGES/bbb.fw
