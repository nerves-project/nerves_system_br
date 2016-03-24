#!/bin/sh

set -e

FWUP_CONFIG=$BR2_EXTERNAL/board/ag150/fwup.conf

# Make sure that the size matches fwup.conf
BOOTSIZE=31232
BOOTPART=$BINARIES_DIR/bootpart.bin

$BR2_EXTERNAL/scripts/mksyslinuxfs.sh $BOOTPART $BOOTSIZE
cp $BR2_EXTERNAL/board/ag150/syslinux.cfg $BINARIES_DIR

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
