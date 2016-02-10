#!/bin/sh

set -e

#
# Nerves common post-build hook
#

TARGETDIR=$1

$BR2_EXTERNAL/scripts/scrub-target.sh $TARGETDIR
