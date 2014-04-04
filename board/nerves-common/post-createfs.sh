#!/bin/bash

set -e

#
# Post create filesystem hook
#

if [ $# -ne 3 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwtool.config> <Base firmware name>"
    exit 1
fi

NERVES_SDK_IMAGES=$1
FWTOOL_CONFIG=$2
BASE_FW_NAME=$3

[ ! -f $FWTOOL_CONFIG ] && { echo "Error: $FWTOOL_CONFIG not found"; exit 1; }

TARGETDIR=$NERVES_SDK_IMAGES/../target
NERVES_ROOT=$NERVES_SDK_IMAGES/../../..
NERVES_SDK_ROOT=$NERVES_SDK_IMAGES/../host

# Link the fwtool config to the images directory so that
# it can be used to create images based on this one.
ln -sf $FWTOOL_CONFIG $NERVES_SDK_IMAGES

# Use the rel2fw.sh tool to create the demo images
OLD_DIR=`pwd`
(cd $NERVES_SDK_IMAGES && \
 source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT && \
 $NERVES_ROOT/scripts/rel2fw.sh $TARGETDIR/srv/erlang ${BASE_FW_NAME}.fw ${BASE_FW_NAME}.img && \
 mv _images/*.fw . && \
 mv _images/*.img . && \
 rm -fr _images) || (cd $OLD_DIR; echo rel2fw.sh failed; exit 1)
cd $OLD_DIR

