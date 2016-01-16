#!/bin/bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this Nerves build.

# "readlink -f" implementation for BSD
# This code was extracted from the Elixir shell scripts
readlink_f () {
    cd "$(dirname "$1")" > /dev/null
    filename="$(basename "$1")"
    if [ -h "$filename" ]; then
        readlink_f "$(readlink "$filename")"
    else
        echo "`pwd -P`/$filename"
    fi
}

SELF=$(readlink_f "$0")
NERVES_SYSTEM=$(dirname "$SELF")

# Detect if this script has been run directly rather than sourced, since
# that won't work.
if [[ "$SHELL" = "/bin/bash" ]]; then
    if [ "$0" != "bash" -a "$0" != "-bash" -a "$0" != "/bin/bash" ]; then
        echo ERROR: This scripted should be sourced from bash:
        echo
        echo source $BASH_SOURCE
        echo
        exit 1
    fi
#elif [[ "$SHELL" = "/bin/zsh" ]]; then
# TODO: Figure out how to detect this error from other shells.
fi

source $NERVES_SYSTEM/scripts/nerves-env-helper.sh $NERVES_SYSTEM
if [ $? != 0 ]; then
    echo "Shell environment NOT updated for Nerves!"
else
    # Found it. Print out some useful information so that the user can
    # easily figure out whether the wrong nerves installation was used.
    NERVES_DEFCONFIG=$(grep BR2_DEFCONFIG= $NERVES_SYSTEM/buildroot/.config | sed -e 's/BR2_DEFCONFIG=".*\/\(.*\)"/\1/')
    NERVES_VERSION=$(grep NERVES_VERSION:= $NERVES_SYSTEM/nerves.mk | sed -e 's/NERVES_VERSION\:=\(.*\)/\1/')
    NERVES_ELIXIR_VERSION_FILE=$(dirname $(readlink_f $(which iex)))/../VERSION

    echo "Shell environment updated for Nerves"
    echo
    echo "Nerves version: $NERVES_VERSION"
    echo "Nerves configuration: $NERVES_DEFCONFIG"
    echo "Cross-compiler prefix: $(basename $CROSSCOMPILE)"
    echo "Erlang/OTP release on target: $NERVES_TARGET_ERL_VER"
    if [ -e $NERVES_ELIXIR_VERSION_FILE ]; then
        echo "Elixir version: $(cat $NERVES_ELIXIR_VERSION_FILE)"
    fi
fi
