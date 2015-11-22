#!/bin/bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this Nerves build.

# If the script is called with the -get-nerves-root flag it just returns the
# Nerves SDK directory. This is so that other shells can execute the script
# without needing to implement the equivalent of $BASH_SOURCE for every shell.
for arg in $*
do
    if [ $arg = "-get-nerves-root" ];
    then
        echo $(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
        exit 0
    fi
done

if [ "$BASH_SOURCE" = "" ]; then
    GET_NR_COMMAND="$0 $@ -get-nerves-root"
    NERVES_ROOT=$(bash -c "$GET_NR_COMMAND")
else
    # Mac note: Don't use "readlink -f" below since it doesn't work on BSD
    NERVES_ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
fi

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


source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT
if [ $? != 0 ]; then
    echo "Shell environment NOT updated for Nerves!"
else
    # Found it. Print out some useful information so that the user can
    # easily figure out whether the wrong nerves installation was used.
    NERVES_DEFCONFIG=$(grep BR2_DEFCONFIG= $NERVES_ROOT/buildroot/.config | sed -e 's/BR2_DEFCONFIG=".*\/\(.*\)"/\1/')

    echo "Shell environment updated for Nerves"
    echo
    echo "Nerves configuration: $NERVES_DEFCONFIG"
    echo "Cross-compiler prefix: `basename $CROSSCOMPILE`"
    echo "Erlang version: $NERVES_TARGET_ERL_VER"
#    echo "Elixir version: $NERVES_TARGET_ELIXIR_VER"
fi
