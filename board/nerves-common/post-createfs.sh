#!/bin/bash

set -e

#
# Post create filesystem hook
#

if [ $# -ne 3 ]; then
    echo "Usage: $0 <BR images directory> <Path to fwup.conf> <Base firmware name>"
    exit 1
fi

NERVES_SDK_IMAGES=$1
FWUP_CONFIG=$2
BASE_FW_NAME=$3

[ ! -f $FWUP_CONFIG ] && { echo "Error: $FWUP_CONFIG not found"; exit 1; }

TARGETDIR=$NERVES_SDK_IMAGES/../target
NERVES_SYSTEM=$NERVES_SDK_IMAGES/../../..
NERVES_SDK_ROOT=$NERVES_SDK_IMAGES/../host

# Copy the fwup config to the images directory so that
# it can be used to create images based on this one.
cp -f $FWUP_CONFIG $NERVES_SDK_IMAGES

# Use the rel2fw.sh tool to create the demo images
OLD_DIR=`pwd`
(cd $NERVES_SDK_IMAGES && \
 source $NERVES_SYSTEM/scripts/nerves-env-helper.sh $NERVES_SYSTEM && \
 $NERVES_SYSTEM/scripts/rel2fw.sh $TARGETDIR/srv/erlang ${BASE_FW_NAME}.fw ${BASE_FW_NAME}.img) \
 || (cd $OLD_DIR; echo rel2fw.sh failed; exit 1)

cd $OLD_DIR

