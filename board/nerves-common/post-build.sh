#!/bin/sh

set -e

#
# Nerves common post-build hook
#

$BR2_EXTERNAL_NERVES_PATH/scripts/scrub-target.sh $1
