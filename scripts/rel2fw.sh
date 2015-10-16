#!/bin/sh

set -e

BASE_DIR=`pwd`
PROJECT_DIR=`basename $BASE_DIR`

SCRIPT_NAME=$0

if [ $# -lt 1 ]; then
    echo "Usage: $SCRIPT_NAME <Release directory> [Firmware output path] [Image output path]"
    echo
    echo "Example:"
    echo "$SCRIPT_NAME _rel $PROJECT_DIR.fw $PROJECT_DIR.img"
    exit 1
fi

RELEASE_DIR=$1
FW_FILENAME=$2
IMG_FILENAME=$3

FWUP=$NERVES_SDK_ROOT/usr/bin/fwup
FWUP_CONFIG=$NERVES_SDK_IMAGES/fwup.conf

TMP_DIR=$BASE_DIR/_nerves-tmp
rm -fr $TMP_DIR

# Check that we have everything that we need
[ -z "$NERVES_ROOT" ] && { echo "$SCRIPT_NAME: Source nerves-env.sh and try again."; exit 1; }
# The RELEASE_DIR can be missing in the case of non-Erlang debug configurations like bbb_linux_defconfig
[ -z "$FW_FILENAME" ] && FW_FILENAME=${PROJECT_DIR}.fw
[ -z "$IMG_FILENAME" ] && IMG_FILENAME=`basename $FW_FILENAME .fw`.img

# Make sure that the firmware and image output directories are there.
mkdir -p `dirname $FW_FILENAME`
mkdir -p `dirname $IMG_FILENAME`

# Update the file system bundle
echo Updating base firmware image with Erlang release...
$NERVES_ROOT/scripts/create-fs.sh \
	$NERVES_SDK_IMAGES/rootfs.squashfs \
	$RELEASE_DIR \
	$TMP_DIR/rootfs-additions \
	$TMP_DIR/combined.squashfs

# Build the firmware image
echo Building $FW_FILENAME...
ROOTFS=$TMP_DIR/combined.squashfs $FWUP -c -f $FWUP_CONFIG \
	-o $FW_FILENAME

# Erase the image file in case it exists from a previous build.
# We use fwup in "programming" mode to create the raw image so it expects there
# to the destination to exist (like a MMC device). This provides the minimum image.
rm -f $IMG_FILENAME
touch $IMG_FILENAME

# Build the raw image for the bulk programmer
echo Building $IMG_FILENAME...
$FWUP -a -d $IMG_FILENAME -t complete -i $FW_FILENAME

# Clean up
#rm -fr $TMP_DIR
