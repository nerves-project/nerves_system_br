#!/bin/sh

#
# Pre create filesystem hook
#

TARGETDIR=$1

# Run the common post-build processing for nerves
$TARGETDIR/../../../board/nerves-common/post-build.sh $TARGETDIR

# Fix up multilib
if [ ! -d $TARGETDIR/usr/lib/arm-linux-gnueabihf ]; then
    ln -fs . $TARGETDIR/usr/lib/arm-linux-gnueabihf
fi
