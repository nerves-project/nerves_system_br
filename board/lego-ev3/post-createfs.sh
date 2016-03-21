#!/bin/sh

set -e

FWUP_CONFIG=$BR2_EXTERNAL/board/lego-ev3/fwup.conf

# Run the common post-image processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
