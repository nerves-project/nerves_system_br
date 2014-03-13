#!/bin/sh

#
# Post create filesystem hook
#

TARGETDIR=$1

NERVES_ROOT=$TARGETDIR/../../..
NERVES_SDK_ROOT=$TARGETDIR/../host
NERVES_SDK_IMAGES=$TARGETDIR/../images

FWTOOL_CONFIG=$NERVES_ROOT/board/ag150/fwtool.config
SYSLINUX_CONFIG=$NERVES_ROOT/board/ag150/syslinux.cfg

# Create the firmware images
FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool
#FWTOOL=/home/fhunleth/nerves/fwtool/fwtool

# Build the firmware image
echo Building firmware image...
PATH=$NERVES_SDK_ROOT/usr/bin:$NERVES_SDK_ROOT/usr/sbin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
        --kernel_path=$NERVES_SDK_IMAGES/bzImage \
        --rootfs_path=$NERVES_SDK_IMAGES/rootfs.ext2 \
        --syslinuxcfg_path=$SYSLINUX_CONFIG \
        --mbr_bootstrap_path=$NERVES_SDK_ROOT/usr/share/syslinux/mbr.bin \
	create $NERVES_SDK_IMAGES/nerves-ag150.fw

# Build the raw image for the bulk programmer
echo Building raw firmware image...
PATH=$NERVES_SDK_ROOT/usr/bin:$NERVES_SDK_ROOT/usr/sbin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
	-d $NERVES_SDK_IMAGES/ag150.img \
	-t complete \
	run $NERVES_SDK_IMAGES/nerves-ag150.fw

# Link the fwtool config to the images directory so that
# it can be used to create images based on this one.
ln -sf $FWTOOL_CONFIG $NERVES_SDK_IMAGES
