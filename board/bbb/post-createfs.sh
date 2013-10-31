#!/bin/sh

#
# Post create filesystem hook
#

TARGETDIR=$1
CREATE_FIRMWARE=$(dirname $0)/create-firmware.sh

# Create the firmware images
NERVES_ROOT=$TARGETDIR/../../.. NERVES_SDK_ROOT=$TARGETDIR/../host NERVES_SDK_IMAGES=$TARGETDIR/../images $CREATE_FIRMWARE $TARGETDIR

# Copy the firmware creation script to the images directory
# so that it can be used later.
cp $CREATE_FIRMWARE $TARGETDIR/../images
