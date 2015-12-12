#!/bin/sh

TARGETDIR=$1
HOSTDIR=$TARGETDIR/../host
IMAGEDIR=$TARGETDIR/../images
NERVES_SYSTEM=$TARGETDIR/../../..

# Run the common post-build processing for nerves
$NERVES_SYSTEM/board/nerves-common/post-build.sh $TARGETDIR

