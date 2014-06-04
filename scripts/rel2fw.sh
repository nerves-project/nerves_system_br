#!/bin/sh

set -e

BASE_DIR=`pwd`
PROJECT_DIR=`basename $BASE_DIR`

SCRIPT_NAME=$0

if [ $# -lt 1 ]; then
    echo "Usage: $SCRIPT_NAME <Release directory> [Firmware filename] [Image filename]"
    echo
    echo "Example:"
    echo "$SCRIPT_NAME _rel $PROJECT_DIR.fw $PROJECT_DIR.img"
    exit 1
fi

RELEASE_DIR=$1
FW_FILENAME=$2
IMG_FILENAME=$3

OUTPUT_DIR=$BASE_DIR/_images

# Check that we have everything that we need
[ -z "$NERVES_ROOT" ] && { echo "$SCRIPT_NAME: Source nerves-env.sh and try again."; exit 1; }
[ ! -d "$RELEASE_DIR" ] && { echo "$SCRIPT_NAME: Check that your app's release directory exists. ($RELEASE_DIR)"; exit 1; }
[ -z "$FW_FILENAME" ] && FW_FILENAME=${PROJECT_DIR}.fw
[ -z "$IMG_FILENAME" ] && IMG_FILENAME=`basename $FW_FILENAME .fw`.img

command -v fakeroot >/dev/null 2>&1 || { echo "$SCRIPT_NAME: This script requires fakeroot." >&2; exit 1; }

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
	$NERVES_SDK_IMAGES/rootfs.tar \
	$RELEASE_DIR \
	$OUTPUT_DIR/rootfs \
    $OUTPUT_DIR/rootfs.ext2 2>&1 | (grep -v "LD_PRELOAD cannot be preloaded" || true)

FWUP=$NERVES_SDK_ROOT/usr/bin/fwup
FWUP_CONFIG=$NERVES_SDK_IMAGES/fwup.conf

# Build the firmware image
echo Building $OUTPUT_DIR/$FW_FILENAME...
echo ROOTFS=$OUTPUT_DIR/rootfs.ext2 $FWUP -c -f $FWUP_CONFIG \
	-o $OUTPUT_DIR/$FW_FILENAME
ROOTFS=$OUTPUT_DIR/rootfs.ext2 $FWUP -c -f $FWUP_CONFIG \
	-o $OUTPUT_DIR/$FW_FILENAME

# Erase the image file in case it exists from a previous build.
# We use fwup in "programming" mode to create the raw image so it expects there
# to the destination to exist (like a MMC device). This provides the minimum image.
rm -f $OUTPUT_DIR/$IMG_FILENAME
touch $OUTPUT_DIR/$IMG_FILENAME

# Build the raw image for the bulk programmer
echo Building $OUTPUT_DIR/$IMG_FILENAME...
$FWUP -a -d $OUTPUT_DIR/$IMG_FILENAME -t complete -i $OUTPUT_DIR/$FW_FILENAME

# Clean up
rm -f $OUTPUT_DIR/rootfs.ext2
