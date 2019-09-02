#!/usr/bin/env bash

# This helper script creates a FAT file system with the syslinux special
# files. It should be passed the filename of the image, the size in
# 512 byte blocks, and the path to syslinux.
#
# Inputs:
#   $BASE_DIR   The Buildroot output directory
#   $1          The block offset of the boot partition
#   $2          The size in blocks of the boot partition

set -e

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <bootpart> <bootsize>"
    exit 1
fi

BOOTPART=$1
BOOTSIZE=$2

MKFS_VFAT=$BASE_DIR/host/usr/sbin/mkfs.vfat
if [[ ! -f $MKFS_VFAT ]]; then
    # Use the system mkfs.vfat if the Buildroot one isn't available
    # sudo apt-get install dosfstools
    MKFS_VFAT=mkfs.vfat
fi

SYSLINUX=$BASE_DIR/host/usr/bin/syslinux
if [[ ! -f $SYSLINUX ]]; then
    # Use the system syslinux if the Buildroot one isn't available
    # sudo apt-get install dosfstools
    SYSLINUX=syslinux
fi

# Create the boot partition and run it through syslinux
rm -f "$BOOTPART"
dd if=/dev/zero of="$BOOTPART" count=0 seek="$BOOTSIZE" 2>/dev/null
"$MKFS_VFAT" -F 12 -n BOOT "$BOOTPART" >/dev/null
"$SYSLINUX" -i "$BOOTPART"

