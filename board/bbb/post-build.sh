#!/bin/sh

TARGETDIR=$1

# Run the common post-build processing for nerves
$BR2_EXTERNAL/board/nerves-common/post-build.sh $TARGETDIR

