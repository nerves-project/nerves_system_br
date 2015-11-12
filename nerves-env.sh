#!/bin/bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this Nerves build.

if [ "$SHELL" != "/bin/bash" ]; then
    echo ERROR: This script currently only works from bash.
    exit 1
fi

if [ "$0" != "bash" -a "$0" != "-bash" -a "$0" != "/bin/bash" ]; then
    echo ERROR: This scripted should be sourced from bash:
    echo
    echo source $BASH_SOURCE
    echo
    return 1
    exit 1
fi

# We need to find the path to this script file, since all of our
# data files are relative to it.
#
# Mac note: Don't use "readlink -f" below since it doesn't work on BSD
NERVES_ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
NERVES_DEFCONFIG=`grep BR2_DEFCONFIG= $NERVES_ROOT/buildroot/.config | sed -e 's/.*"\(.*\)"/\1/'`

source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT
if [ $? != 0 ]; then
    echo "Shell environment NOT updated for Nerves!"
else
    echo "Shell environment updated for Nerves"
    echo
    echo "Nerves configuration: $NERVES_DEFCONFIG"
    echo "Cross-compiler prefix: `basename $CROSSCOMPILE`"
    echo "Erlang version: $NERVES_TARGET_ERL_VER"
#    echo "Elixir version: $NERVES_TARGET_ELIXIR_VER"
fi
