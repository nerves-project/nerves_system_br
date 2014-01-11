#!/bin/sh

#
# Post create filesystem hook
#

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
NERVES_SDK_ROOT=$TARGETDIR/../host
NERVES_SDK_IMAGES=$TARGETDIR/../images

FWTOOL_CONFIG=$NERVES_ROOT/board/bbb/fwtool.config

# Create the firmware images
FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool

# Build the firmware image
echo Building firmware image...
PATH=$NERVES_SDK_ROOT/usr/bin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
	--mlo_path=$NERVES_SDK_IMAGES/MLO \
	--uboot_path=$NERVES_SDK_IMAGES/u-boot.img \
	--rootfs_path=$NERVES_SDK_IMAGES/rootfs.ext2 \
	create $NERVES_SDK_IMAGES/bbb.fw

# Build the raw image for the bulk programmer
echo Building raw firmware image...
PATH=$NERVES_SDK_ROOT/usr/bin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
	-d $NERVES_SDK_IMAGES/sdcard.img \
	-t complete \
	run $NERVES_SDK_IMAGES/bbb.fw

# Link the fwtool config to the images directory so that
# it can be used to create images based on this one.
ln -sf $FWTOOL_CONFIG $NERVES_SDK_IMAGES
