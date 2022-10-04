#!/usr/bin/env bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this Nerves build.

# "readlink -f" implementation for BSD
# This code was extracted from the Elixir shell scripts
readlink_f () {
    # shellcheck disable=SC2164
    cd "$(dirname "$1")" > /dev/null
    filename="$(basename "$1")"
    if [ -h "$filename" ]; then
        readlink_f "$(readlink "$filename")"
    else
        echo "$(pwd -P)/$filename"
    fi
}

# If the script is called with the -get-nerves-root flag it just returns the
# Nerves system directory. This is so that other shells can execute the script
# without needing to implement the equivalent of $BASH_SOURCE for every shell.
for arg in "$@"
do
    if [ "$arg" = "-get-nerves-root" ];
    then
        dirname "$(readlink_f "${BASH_SOURCE[0]}")"
        exit 0
    fi
done

if [ "${BASH_SOURCE[0]}" = "" ]; then
    GET_NR_COMMAND="$0 $* -get-nerves-root"
    SCRIPT_DIR=$(bash -c "$GET_NR_COMMAND")
else
    SCRIPT_DIR=$(dirname "$(readlink_f "${BASH_SOURCE[0]}")")
fi

# Detect if this script has been run directly rather than sourced, since
# that won't work.
if [[ "$SHELL" = "/bin/bash" ]]; then
    if [[ "$0" != "bash" && "$0" != "-bash" && "$0" != "/bin/bash" ]]; then
        echo ERROR: This scripted should be sourced from bash:
        echo
        echo source "${BASH_SOURCE[@]}"
        echo
        exit 1
    fi
#elif [[ "$SHELL" = "/bin/zsh" ]]; then
# TODO: Figure out how to detect this error from other shells.
fi

# Determine the location of the NERVES_SYSTEM directory. This script is
# either being sourced from the directory or from the base of nerves_system_br.
# If it's the latter, then point the helper script at the appropriate place.
if [ -e "$SCRIPT_DIR/.config" ]; then
    NERVES_SYSTEM=$SCRIPT_DIR
elif [ -e "$SCRIPT_DIR/buildroot/output" ]; then
    NERVES_SYSTEM=$SCRIPT_DIR/buildroot/output
else
    echo "ERROR: Can't find Nerves system directory. Has Nerves been built?"
    echo " If sourcing from the nerves_system_br directory, then the build products"
    echo " aren't in the default location. The new way is to source nerves-env.sh"
    echo " from nerves_system_br's output directory."
    return 1
fi

# shellcheck source=/dev/null
if ! source "$SCRIPT_DIR/scripts/nerves-env-helper.sh" "$NERVES_SYSTEM"; then
    echo "Shell environment NOT updated for Nerves!"
    return 1
else
    # Found it. Print out some useful information so that the user can
    # easily figure out whether the wrong nerves installation was used.
    NERVES_DEFCONFIG=$(grep BR2_DEFCONFIG= "$NERVES_SYSTEM"/.config | sed -e 's/BR2_DEFCONFIG="\(.*\)"/\1/')
    GCC_VERSION=$("$CROSSCOMPILE"-gcc --version | head -1)

    echo "Shell environment updated for Nerves"
    echo
    echo "Nerves configuration: $NERVES_DEFCONFIG"
    echo "Cross-compiler: $GCC_VERSION"
    echo "Erlang/OTP release on target: $NERVES_TARGET_ERL_VER"
    if [ -n "$(which elixir)" ]; then
        NERVES_ELIXIR_VERSION=$(elixir -v | grep lixir | cut -d' ' -f2-)
        echo "Elixir version (from path): $NERVES_ELIXIR_VERSION"
    else
        echo "WARNING: Elixir not found on host"
    fi
fi
