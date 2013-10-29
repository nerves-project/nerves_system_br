#!/bin/sh

set -e

RELEASE_DIR=$1
NERVES_DIR=`dirname $0`
OUTPUT_DIR=`pwd`/_images

# Check that we have everything that we need
[ -z "$NERVES_PLATFORM" ] && { echo "Need to set NERVES_PLATFORM"; exit 1; }
[ -z "$RELEASE_DIR" ] && { echo "Pass the path to the your app's release directory"; exit 1; }
command -v fakeroot >/dev/null 2>&1 || { echo "This script requires fakeroot." >&2; exit 1; }

PLATFORM_DIR=$NERVES_DIR/sdk/$NERVES_PLATFORM

mkdir -p $OUTPUT_DIR

# Update the file system bundle
fakeroot $NERVES_DIR/scripts/create-fs.sh $PLATFORM_DIR \
	$PLATFORM_DIR/images/rootfs.tar.gz \
	$RELEASE_DIR \
	$OUTPUT_DIR/tmp \
	$OUTPUT_DIR/rootfs.ext2 

$NERVES_DIR/configs/$NERVES_PLATFORM/post-createfs.sh $PLATFORM_DIR $OUTPUT_DIR

# Clean up
rm -f $OUTPUT_DIR/rootfs.ext2
