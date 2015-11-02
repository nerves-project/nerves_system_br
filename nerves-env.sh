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
        echo $(dirname $(readlink -f $BASH_SOURCE))
        exit 0
    fi
done 


if [[ "$SHELL" = "/bin/bash" ]]; then
    if [ "$0" != "bash" -a "$0" != "-bash" -a "$0" != "/bin/bash" ]; then
        echo ERROR: This scripted should be sourced from bash:
        echo
        echo source $BASH_SOURCE
        echo
        return 1
        exit 1
    fi
#elif [[ "$SHELL" = "/bin/zsh" ]]; then
fi

if [ "$BASH_SOURCE" = "" ]; then
    GET_NR_COMMAND="$0 $@ -get-nerves-root"
    NERVES_ROOT=$(bash -c "$GET_NR_COMMAND")
else
    NERVES_ROOT=$(dirname $(readlink -f $BASH_SOURCE))
fi

NERVES_DEFCONFIG=`grep BR2_DEFCONFIG= $NERVES_ROOT/buildroot/.config | sed -e 's/.*"\(.*\)"/\1/'`

source $NERVES_ROOT/scripts/nerves-env-helper.sh $NERVES_ROOT

echo "Shell environment updated for Nerves"
echo
echo "Nerves configuration: $NERVES_DEFCONFIG"
echo "Cross-compiler prefix: `basename $CROSSCOMPILE`"

