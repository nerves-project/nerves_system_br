#!/bin/sh

set -e

TARGETDIR=$1

NERVES_SYSTEM=$TARGETDIR/../../..
FWUP_CONFIG=$NERVES_SYSTEM/board/ag150/fwup.conf
BASE_FW_NAME=nerves-ag150-base

# Make sure that the size matches fwup.conf
BOOTSIZE=31232
BOOTPART=$NERVES_SYSTEM/buildroot/output/images/bootpart.bin
SYSLINUX=$NERVES_SYSTEM/buildroot/output/host/usr/bin/syslinux

$NERVES_SYSTEM/scripts/mksyslinuxfs.sh $NERVES_SYSTEM $BOOTPART $BOOTSIZE $SYSLINUX

# Run the common post-image processing for nerves
$NERVES_SYSTEM/board/nerves-common/post-createfs.sh $TARGETDIR $FWUP_CONFIG $BASE_FW_NAME
