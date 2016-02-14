#!/bin/sh

set -e

FWUP_CONFIG=$BR2_EXTERNAL/board/alix/fwup.conf

# Make sure that the size matches fwup.conf
BOOTSIZE=31232
BOOTPART=$BINARIES_DIR/bootpart.bin
SYSLINUX=$HOST_DIR/usr/bin/syslinux

$BR2_EXTERNAL/scripts/mksyslinuxfs.sh $BR2_EXTERNAL $BOOTPART $BOOTSIZE $SYSLINUX

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
