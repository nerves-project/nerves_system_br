#!/bin/sh

TARGETDIR=$1
HOSTDIR=$TARGETDIR/../host
IMAGEDIR=$TARGETDIR/../images
NERVES_ROOT=$TARGETDIR/../../..

# Run the common post-build processing for nerves
$NERVES_ROOT/board/nerves-common/post-build.sh $TARGETDIR

