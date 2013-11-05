#!/bin/sh

set -e

RELEASE_DIR=$1
OUTPUT_DIR=`pwd`/_images

# Check that we have everything that we need
[ -z "$NERVES_ROOT" ] && { echo "Need to source nerves-env.sh"; exit 1; }
[ -z "$RELEASE_DIR" ] && { echo "Pass the path to the your app's release directory"; exit 1; }
command -v fakeroot >/dev/null 2>&1 || { echo "This script requires fakeroot." >&2; exit 1; }

mkdir -p $OUTPUT_DIR

# Update the file system bundle
fakeroot $NERVES_ROOT/scripts/create-fs.sh \
	$NERVES_SDK_IMAGES/rootfs.tar.gz \
	$RELEASE_DIR \
	$OUTPUT_DIR/tmp \
	$OUTPUT_DIR/rootfs.ext2

FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool
FWTOOL_CONFIG=$NERVES_SDK_IMAGES/fwtool.config

# Build the firmware image
$FWTOOL -c $FWTOOL_CONFIG \
	--mlo_path=$NERVES_SDK_IMAGES/MLO \
	--uboot_path=$NERVES_SDK_IMAGES/u-boot.img \
	--rootfs_path=$OUTPUT_DIR/rootfs.ext2 \
	create $OUTPUT_DIR/bbb.fw

# Build the raw image for the bulk programmer
$FWTOOL -c $FWTOOL_CONFIG \
	-d $OUTPUT_DIR/sdcard.img \
	-t complete \
	run $OUTPUT_DIR/bbb.fw

# Clean up
rm -f $OUTPUT_DIR/rootfs.ext2
