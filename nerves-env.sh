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

NERVES_ROOT=$(dirname $(readlink -f $BASH_SOURCE))
NERVES_DEFCONFIG=`cat $NERVES_ROOT/.nerves-defconfig`

source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT

echo "Shell environment updated for Nerves"
echo
echo "Nerves configuration: $NERVES_DEFCONFIG"
echo "Cross-compiler prefix: `basename $CROSSCOMPILE`"
if ! diff $NERVES_ROOT/configs/$NERVES_DEFCONFIG $NERVES_ROOT/buildroot/defconfig >/dev/null; then
    echo
    echo "----------------------------------------------------------------------------"
    echo "Your Nerves configuation (configs/$NERVES_DEFCONFIG) does not match"
    echo "$NERVES_ROOT/buildroot/defconfig!"
    echo "This means that you may have unsaved changes. This is ok if you're"
    echo "experimenting with Buildroot, but be sure to save or revert your changes"
    echo "when you are done."
    echo
    echo "Changes:"
    diff $NERVES_ROOT/configs/$NERVES_DEFCONFIG $NERVES_ROOT/buildroot/defconfig
    echo "----------------------------------------------------------------------------"
    echo
fi
