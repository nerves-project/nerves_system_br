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
echo Updating base firmware image with Erlang release...

# fakeroot note: Since fakeroot intercepts system calls via
# LD_PRELOAD, it will fail to wrap 32-bit executables on 64-bit
# machines. Some toolchains ship pre-built 32-bit executables and
# if any of these are called, you'll get a warning in the log. This
# isn't a problem as the only tool that gets called is strip and if
# it falls out of the fakeroot environment, that's ok.
fakeroot $NERVES_ROOT/scripts/create-fs.sh \
	$NERVES_SDK_IMAGES/rootfs.tar.gz \
	$RELEASE_DIR \
	$OUTPUT_DIR/tmp \
    $OUTPUT_DIR/rootfs.ext2 2>&1 | (grep -v "LD_PRELOAD cannot be preloaded" || true)

FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool
FWTOOL_CONFIG=$NERVES_SDK_IMAGES/fwtool.config

# Build the firmware image
echo Building $OUTPUT_DIR/bbb.fw...
$FWTOOL -c $FWTOOL_CONFIG \
        --base_path=$NERVES_ROOT \
	--rootfs_path=$OUTPUT_DIR/rootfs.ext2 \
	create $OUTPUT_DIR/bbb.fw

# Build the raw image for the bulk programmer
echo Building $OUTPUT_DIR/sdcard.img...
$FWTOOL -c $FWTOOL_CONFIG \
	-d $OUTPUT_DIR/sdcard.img \
	-t complete \
	run $OUTPUT_DIR/bbb.fw

# Clean up
rm -f $OUTPUT_DIR/rootfs.ext2
