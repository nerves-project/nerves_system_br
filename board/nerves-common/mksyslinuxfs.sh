#!/bin/sh

# This helper script creates a FAT file system with the syslinux special
# files. It should be passed the filename of the image, the size in
# 512 byte blocks, and the path to syslinux.

set -e

if [ $# -lt 4 ]; then
    echo "Usage: $0 <nerves_root> <bootpart> <bootsize> <syslinux path>"
    exit 1
fi

NERVES_SYSTEM=$1
BOOTPART=$2
BOOTSIZE=$3
SYSLINUX=$4

# Create the boot partition and run it through syslinux
rm -f $BOOTPART
dd if=/dev/zero of=$BOOTPART count=0 seek=$BOOTSIZE 2>/dev/null
$NERVES_SYSTEM/buildroot/output/host/usr/sbin/mkfs.vfat -F 12 -n BOOT $BOOTPART >/dev/null
$SYSLINUX -i $BOOTPART

