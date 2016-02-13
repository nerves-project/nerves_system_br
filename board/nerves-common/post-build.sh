#!/bin/sh

set -e

#
# Nerves common post-build hook
#

$BR2_EXTERNAL/scripts/scrub-target.sh $1
