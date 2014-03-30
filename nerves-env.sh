#!/bin/bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this nerves-sdk build.

if [ "$SHELL" != "/bin/bash" ]; then
    echo ERROR: This script currently only works from bash.
    exit 1
fi

if [ "$0" != "bash" -a "$0" != "-bash" -a "$0" != "/bin/bash" ]; then
    echo ERROR: This scripted should be sourced from bash:
    echo
    echo source $BASH_SOURCE
    return 1
    exit 1
fi

NERVES_ROOT=$(dirname $(readlink -f $BASH_SOURCE))

source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT

echo Shell environment updated for nerves
echo Cross-compiler prefix: `basename $CROSSCOMPILE`
