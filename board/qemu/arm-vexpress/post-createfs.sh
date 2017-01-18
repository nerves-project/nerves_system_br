#!/bin/sh

set -e

FWUP_CONFIG=$BR2_EXTERNAL_NERVES_PATH/board/qemu/arm-vexpress/fwup.conf

# Run the common post-image processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
