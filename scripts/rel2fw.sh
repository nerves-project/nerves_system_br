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

$NERVES_SDK_IMAGES/create-firmware.sh $OUTPUT_DIR

# Clean up
rm -f $OUTPUT_DIR/rootfs.ext2
