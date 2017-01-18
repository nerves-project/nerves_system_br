#!/bin/sh

set -e

# Run the common post-build processing for nerves
$BR2_EXTERNAL_NERVES_PATH/board/nerves-common/post-build.sh $1
