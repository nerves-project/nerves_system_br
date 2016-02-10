#!/bin/bash

set -e

#
# Post create filesystem hook
#
# Inputs:
#   $1  the images directory (where to put the .fw output)
#   $2  the path to fwup.conf
#   $3  the base name for the firmware
# $BR2_EXTERNAL the path to the nerves-system-br directory
# $BASE_DIR     the path to the buildroot output directory
# $TARGET_DIR   the path to the target directory (normally $BASE_DIR/target)
# $BINARIES_DIR the path to the images directory (normally $BASE_DIR/images)


if [ $# -ne 3 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> <Base firmware name>"
    exit 1
fi

FWUP_CONFIG=$2
BASE_FW_NAME=$3

[ ! -f $FWUP_CONFIG ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f $FWUP_CONFIG $BINARIES_DIR

# Symlink the nerves scripts to the output directory so that it
# is self-contained.
cp -f $BR2_EXTERNAL/nerves-env.sh $BASE_DIR    # Can't symlink due to readlink -f code
ln -sf $BR2_EXTERNAL/nerves.mk $BASE_DIR
ln -sf $BR2_EXTERNAL/scripts $BASE_DIR

# Use the rel2fw.sh tool to create the demo images
OLD_DIR=$(pwd)
(cd $BINARIES_DIR && \
 source $BASE_DIR/scripts/nerves-env-helper.sh $BASE_DIR && \
 $BASE_DIR/scripts/rel2fw.sh $TARGET_DIR/srv/erlang ${BASE_FW_NAME}.fw ${BASE_FW_NAME}.img) \
 || (cd $OLD_DIR; echo rel2fw.sh failed; exit 1)

