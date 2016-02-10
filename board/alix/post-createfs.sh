#!/bin/sh

set -e

TARGETDIR=$1

FWUP_CONFIG=$BR2_EXTERNAL/board/alix/fwup.conf
BASE_FW_NAME=nerves-alix-base

# Make sure that the size matches fwup.conf
BOOTSIZE=31232
BOOTPART=$BINARIES_DIR/bootpart.bin
SYSLINUX=$HOST_DIR/usr/bin/syslinux

$BR2_EXTERNAL/scripts/mksyslinuxfs.sh $BR2_EXTERNAL $BOOTPART $BOOTSIZE $SYSLINUX

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME
