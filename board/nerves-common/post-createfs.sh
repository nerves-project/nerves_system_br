#!/bin/sh

#
# Post create filesystem hook
#

if [ $# -ne 3 ]; then
    echo "Usage: $0 <Target Directory> <Path to fwtool.config> <Base firmware name>"
    exit 1
fi

TARGETDIR=$1
FWTOOL_CONFIG=$2
BASE_FW_NAME=$3

[ ! -f $FWTOOL_CONFIG ] && { echo "Error: $FWTOOL_CONFIG not found"; exit 1; }

NERVES_ROOT=$TARGETDIR/../../..
NERVES_SDK_ROOT=$TARGETDIR/../host
NERVES_SDK_IMAGES=$TARGETDIR/../images

# Create the firmware images
FWTOOL=$NERVES_SDK_ROOT/usr/bin/fwtool
FW_PATH=$NERVES_SDK_IMAGES/${BASE_FW_NAME}.fw
IMG_PATH=$NERVES_SDK_IMAGES/${BASE_FW_NAME}.img

echo "Building firmware image (`basename $FW_PATH`)..."
PATH=$NERVES_SDK_ROOT/usr/bin:$NERVES_SDK_ROOT/usr/sbin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
	--base_path=$NERVES_ROOT \
	create $FW_PATH

# Build the raw image for the bulk programmer
echo "Building raw memory image (`basename $IMG_PATH`)..."
PATH=$NERVES_SDK_ROOT/usr/bin:$NERVES_SDK_ROOT/usr/sbin:$PATH $FWTOOL \
	-c $FWTOOL_CONFIG \
	-d $IMG_PATH \
	-t complete \
	run $FW_PATH

# Link the fwtool config to the images directory so that
# it can be used to create images based on this one.
ln -sf $FWTOOL_CONFIG $NERVES_SDK_IMAGES
