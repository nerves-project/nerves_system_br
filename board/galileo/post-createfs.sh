#!/bin/sh

set -e

FWUP_CONFIG=$NERVES_SYSTEM/board/galileo/fwup.conf

# Run the common post-image processing for nerves
$NERVES_SYSTEM/board/nerves-common/post-createfs.sh $TARGET_DIR $FWUP_CONFIG
