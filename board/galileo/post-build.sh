#!/bin/sh

set -e

TARGETDIR=$1

# Copy over the grub config to the EFI directory
cp $TARGETDIR/../../../board/galileo/grub.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg

# Run the common post-build processing for nerves
$TARGETDIR/../../../board/nerves-common/post-build.sh $TARGETDIR

