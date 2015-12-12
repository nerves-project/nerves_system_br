#!/bin/sh

set -e

BASE_DIR=`pwd`
PROJECT_DIR=`basename $BASE_DIR`

SCRIPT_NAME=$0

if [ $# -lt 1 ]; then
    echo "Usage: $SCRIPT_NAME <Release directory> [Firmware output path] [Image output path]"
    echo
    echo "Barring errors, the firmware file is always created. The raw image is only"
    echo "created if specified."
    echo
    echo "Example:"
    echo "$SCRIPT_NAME _rel $PROJECT_DIR.fw $PROJECT_DIR.img"
    exit 1
fi

RELEASE_DIR=$1
FW_FILENAME=$2
IMG_FILENAME=$3

FWUP_CONFIG=$NERVES_SDK_IMAGES/fwup.conf

# If the toolchain contains a pre-built version of fwup,
# use it; otherwise look for one in the path.
FWUP=$NERVES_TOOLCHAIN/usr/bin/fwup
[ -e "$FWUP" ] || FWUP=$(command -v fwup || echo "/usr/bin/fwup")
if [ ! -e "$FWUP" ]; then
    echo "$SCRIPT_NAME: ERROR: Please install fwup first"
    exit 1
fi

# If the toolchain contains a pre-built version of mksquashfs,
# use it; otherwise look for one in the path.
MKSQUASHFS=$NERVES_TOOLCHAIN/usr/bin/mksquashfs
[ -e "$MKSQUASHFS" ] || MKSQUASHFS=$(command -v mksquashfs || echo "/usr/bin/mksquashfs")
if [ ! -e "$MKSQUASHFS" ]; then
    echo "$SCRIPT_NAME: ERROR: Please install mksquashfs first"
    echo
    echo "For example:"
    echo "   sudo apt-get install squashfs"
    echo "   brew install squashfs"
    exit 1
fi

TMP_DIR=$BASE_DIR/_nerves-tmp
rm -fr $TMP_DIR

# Check that we have everything that we need
[ -z "$NERVES_SYSTEM" ] && { echo "$SCRIPT_NAME: Source nerves-env.sh and try again."; exit 1; }
# The RELEASE_DIR can be missing in the case of non-Erlang debug configurations like bbb_linux_defconfig
[ -z "$FW_FILENAME" ] && FW_FILENAME=${PROJECT_DIR}.fw

# Check that the release directory exists
if [ ! -d "$RELEASE_DIR" ]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang release directory: ($RELEASE_DIR)"
    exit 1
fi
if [ ! -d "$RELEASE_DIR/lib" -o ! -d "$RELEASE_DIR/releases" ]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

# Make sure that the firmware output directories are there.
mkdir -p `dirname $FW_FILENAME`

# Update the file system bundle
echo Updating base firmware image with Erlang release...

# Create the directory for all of the files that "overlay" the base squashfs
mkdir -p $TMP_DIR/rootfs-additions

# Construct the proper path for the Erlang/OTP release
mkdir -p $TMP_DIR/rootfs-additions/srv/erlang
cp -r $RELEASE_DIR/* $TMP_DIR/rootfs-additions/srv/erlang

# Clean up the Erlang release of all the files that we don't need.
$NERVES_SYSTEM/scripts/clean-release.sh $TMP_DIR/rootfs-additions/srv/erlang

# Append the Erlang/OTP release onto the base image.
cp "$NERVES_SDK_IMAGES/rootfs.squashfs" "$TMP_DIR/combined.squashfs"
$MKSQUASHFS "$TMP_DIR/rootfs-additions" "$TMP_DIR/combined.squashfs" -no-recovery -no-progress -root-owned >/dev/null

# Build the firmware image
echo Building $FW_FILENAME...
ROOTFS=$TMP_DIR/combined.squashfs $FWUP -c -f $FWUP_CONFIG \
	-o $FW_FILENAME

if [ ! -z "$IMG_FILENAME" ]; then
    # Create the output directory - just in case
    mkdir -p `dirname $IMG_FILENAME`

    # Erase the image file in case it exists from a previous build.
    # We use fwup in "programming" mode to create the raw image so it expects there
    # the destination to exist (like an MMC device). This provides the minimum sized image.
    rm -f $IMG_FILENAME
    touch $IMG_FILENAME

    # Build the raw image for the bulk programmer
    echo Building $IMG_FILENAME...
    $FWUP -a -d $IMG_FILENAME -t complete -i $FW_FILENAME
fi

# Clean up
rm -fr $TMP_DIR
