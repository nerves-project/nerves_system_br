#!/bin/sh

set -e

#
# Nerves common post-build hook
#

TARGETDIR=$1

../scripts/scrub-target.sh
