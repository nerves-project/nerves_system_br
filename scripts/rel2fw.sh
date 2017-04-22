#!/bin/bash

set -e

BASE_DIR=$(pwd)
PROJECT_DIR=$(basename $BASE_DIR)

SCRIPT_NAME=$0

# Check that we have everything that we need
[[ -z "$NERVES_SYSTEM" ]] && { echo "$SCRIPT_NAME: Source nerves-env.sh and try again."; exit 1; }

usage() {
    echo "Usage: $SCRIPT_NAME [options] <Release directory>"
    echo
    echo "Options:"
    echo "  -a <path to rootfs additions>"
    echo "  -c <fwup.conf>             Default is $NERVES_SDK_IMAGES/fwup.conf"
    echo "  -f <firmware output file>  Default is $PROJECT_DIR.fw"
    echo "  -o <image output file>     Default is $PROJECT_DIR.img"
    echo
    echo "Barring errors, the firmware file is always created. The raw image is only"
    echo "created if specified."
    echo

    echo "Example:"
    echo "$SCRIPT_NAME -f $PROJECT_DIR.fw -o $PROJECT_DIR.img _rel"
}

while getopts ":a:c:f:o:" opt; do
    case $opt in
        a)
            ROOTFS_ADDITIONS=$OPTARG
            ;;
        c)
            FWUP_CONFIG=$OPTARG
            ;;
        f)
            FW_FILENAME=$OPTARG
            ;;
        o)
            IMG_FILENAME=$OPTARG
            ;;
        \?)
            echo "$SCRIPT_NAME: ERROR: Invalid option: -$OPTARG"
            usage
            exit 1
            ;;
        :)
            echo "$SCRIPT_NAME: ERROR: Option -$OPTARG requires an argument."
            usage
            exit 1
            ;;
    esac
done
shift $(($OPTIND-1))

if [[ $# -lt 1 ]]; then
    echo "$SCRIPT_NAME: ERROR: Expecting release directory"
    usage
    exit 1
fi

RELEASE_DIR=$1


# If the toolchain contains a pre-built version of fwup,
# use it; otherwise look for one in the path.
FWUP=$NERVES_TOOLCHAIN/usr/bin/fwup
[[ -e "$FWUP" ]] || FWUP=$(command -v fwup || echo "/usr/bin/fwup")
if [[ ! -e "$FWUP" ]]; then
    echo "$SCRIPT_NAME: ERROR: Please install fwup first"
    echo
    echo "See https://github.com/fhunleth/fwup"
    exit 1
fi

# Check that mksquashfs is in the path. It's needed by
# merge-squashfs.
MKSQUASHFS=$(command -v mksquashfs)
if [[ ! -e "$MKSQUASHFS" ]]; then
    echo "$SCRIPT_NAME: ERROR: Please install mksquashfs first"
    echo
    echo "For example:"
    echo "   sudo apt-get install squashfs-tools"
    echo "   brew install squashfs"
    exit 1
fi

TMP_DIR=$BASE_DIR/_nerves-tmp
rm -fr $TMP_DIR

# Fill in defaults
[[ -z "$FW_FILENAME" ]] && FW_FILENAME=${PROJECT_DIR}.fw
[[ -z "$FWUP_CONFIG" ]] && FWUP_CONFIG=$NERVES_SDK_IMAGES/fwup.conf

# Check that the release directory exists
if [[ ! -d "$RELEASE_DIR" ]]; then
    echo "$SCRIPT_NAME: ERROR: Missing Erlang release directory: ($RELEASE_DIR)"
    exit 1
fi
if [[ ! -d "$RELEASE_DIR/lib" || ! -d "$RELEASE_DIR/releases" ]]; then
    echo "$SCRIPT_NAME: ERROR: Expecting '$RELEASE_DIR' to contain 'lib' and 'releases' subdirectories"
    exit 1
fi

# Make sure that the firmware output directories are there.
mkdir -p $(dirname "$FW_FILENAME")

# Update the file system bundle
echo "Updating base firmware image with Erlang release..."

# Create the directory for all of the files that "overlay" the base squashfs
mkdir -p "$TMP_DIR/rootfs-additions"

# Construct the proper path for the Erlang/OTP release
mkdir -p "$TMP_DIR/rootfs-additions/srv/erlang"
cp -R "$RELEASE_DIR/." "$TMP_DIR/rootfs-additions/srv/erlang"

# Clean up the Erlang release of all the files that we don't need.
$NERVES_SYSTEM/scripts/scrub-otp-release.sh "$TMP_DIR/rootfs-additions/srv/erlang"

# Copy over any rootfs additions from the user
# IMPORTANT: This must be the final step before the merge so that the user can
#            override anything.
if [[ -d "$ROOTFS_ADDITIONS" ]]; then
    cp -Rf "$ROOTFS_ADDITIONS/." "$TMP_DIR/rootfs-additions"
fi

# Merge the Erlang/OTP release onto the base image
$NERVES_SYSTEM/scripts/merge-squashfs "$NERVES_SDK_IMAGES/rootfs.squashfs" "$TMP_DIR/combined.squashfs" "$TMP_DIR/rootfs-additions"

# Build the firmware image
echo "Building $FW_FILENAME..."
ROOTFS="$TMP_DIR/combined.squashfs" $FWUP -c -f "$FWUP_CONFIG" \
	-o "$FW_FILENAME"

if [[ ! -z "$IMG_FILENAME" ]]; then
    # Create the output directory - just in case
    mkdir -p $(dirname "$IMG_FILENAME")

    # Erase the image file in case it exists from a previous build.
    # We use fwup in "programming" mode to create the raw image so it expects there
    # the destination to exist (like an MMC device). This provides the minimum sized image.
    rm -f "$IMG_FILENAME"
    touch "$IMG_FILENAME"

    # Build the raw image for the bulk programmer
    echo "Building $IMG_FILENAME..."
    $FWUP -a -d "$IMG_FILENAME" -t complete -i "$FW_FILENAME"
fi

# Clean up
rm -fr "$TMP_DIR"
