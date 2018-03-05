#!/bin/bash

set -e

#
# Post create filesystem hook
#
# Inputs:
#   $1  the images directory (where to put the .fw output)
#   $2  the path to fwup.conf
#   $BR2_EXTERNAL_NERVES_PATH the path to the nerves_system_br directory
#   $BASE_DIR     the path to the buildroot output directory
#   $BINARIES_DIR the path to the images directory (normally $BASE_DIR/images)


if [ $# -lt 2 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> [Base firmware name]"
    exit 1
fi

FWUP_CONFIG=$2

[ ! -f $FWUP_CONFIG ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f $FWUP_CONFIG $BINARIES_DIR

# Symlink the nerves scripts to the output directory so that it
# is self-contained.
cp -f $BR2_EXTERNAL_NERVES_PATH/nerves-env.sh $BASE_DIR    # Can't symlink due to readlink -f code
ln -sf $BR2_EXTERNAL_NERVES_PATH/nerves.mk $BASE_DIR
ln -sf $BR2_EXTERNAL_NERVES_PATH/scripts $BASE_DIR

