#!/usr/bin/env bash

#
# Create and initialize a directory for building nerves_system_br.
#
# Inputs:
#   $1 = the path to the configuration file (a _defconfig file)
#   $2 = the build directory
#
# Output:
#   An initialized build directory on success
#

set -e

NERVES_BR_VERSION=2024.02.1

DEFCONFIG=$1
BUILD_DIR=$2

# "readlink -f" implementation for BSD
# This code was extracted from the Elixir shell scripts
readlink_f () {
    cd "$(dirname "$1")" > /dev/null
    filename="$(basename "$1")"
    if [[ -h "$filename" ]]; then
        readlink_f "$(readlink "$filename")"
    else
        echo "$(pwd -P)/$filename"
    fi
}

if [[ -z $DEFCONFIG ]]; then
    echo "Usage:"
    echo
    echo "  $0 <defconfig> [build directory]"
    exit 1
fi

if [[ -z $BUILD_DIR ]]; then
    BUILD_DIR=o/$(basename -s _defconfig "$DEFCONFIG")
fi

# Create the build directory if it doesn't already exist
mkdir -p "$BUILD_DIR"

# Normalize paths that were specified
NERVES_DEFCONFIG=$(readlink_f "$DEFCONFIG")
NERVES_DEFCONFIG_DIR=$(dirname "$NERVES_DEFCONFIG")
NERVES_BUILD_DIR=$(readlink_f "$BUILD_DIR")

if [[ ! -f $NERVES_DEFCONFIG ]]; then
    echo "ERROR: Can't find $NERVES_DEFCONFIG. Please check that it exists."
    exit 1
fi

# Check that the system is compatible with building Nerves systems
HOST_OS=$(uname -s)
HOST_ARCH=$(uname -m)
if [[ $HOST_OS != "Linux" ]]; then
    echo "ERROR: Nerves system images can only be built using Linux"
    exit 1
fi

if [[ $HOST_ARCH != "x86_64" ]] && [[ $HOST_ARCH != "aarch64" ]]; then
    echo "ERROR: 64-bit Linux required for running cross-compilers built by nerves-toolchain"
    exit 1
fi

# Determine the NERVES_SYSTEM source directory
NERVES_SYSTEM=$(dirname "$(readlink_f "${BASH_SOURCE[0]}")")
if [[ ! -e $NERVES_SYSTEM ]]; then
    echo "ERROR: Can't determine script directory!"
    exit 1
fi

# If a Config.in doesn't exist, make it as a convenience. This
# is required since KConfig doesn't support optional Config.in
# files.
if [[ ! -e $NERVES_DEFCONFIG_DIR/Config.in ]]; then
    cat >"$NERVES_DEFCONFIG_DIR/Config.in" <<EOF
# Add project-specific packages for Buildroot here
#
# If these are non-proprietary, please consider contributing them back to
# Nerves or Buildroot.
EOF
fi

# Location to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
#
# NOTE: If you are a heavy Buildroot user and have an alternative location,
#       override this environment variable or symlink this directory.
if [[ -z $NERVES_BR_DL_DIR ]]; then
    NERVES_BR_DL_DIR=$HOME/.nerves/dl
fi
mkdir -p "$NERVES_BR_DL_DIR"

if [[ -e $HOME/.nerves/cache/buildroot ]]; then
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "The download directory for Nerves is changing to '~/.nerves/dl'."
    echo "However, you still have '~/.nerves/cache/buildroot'. Feel free"
    echo "to delete this directory but it might also be used by projects"
    echo "using older versions of Nerves."
    echo
    echo "NERVES_BR_DL_DIR=$NERVES_BR_DL_DIR"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi

NERVES_BR_STATE_FILE=$NERVES_SYSTEM/buildroot-$NERVES_BR_VERSION/.nerves-br-state
NERVES_BR_EXPECTED_STATE_FILE=$BUILD_DIR/.nerves-expected-br-state
"$NERVES_SYSTEM/scripts/buildroot-state.sh" $NERVES_BR_VERSION "$NERVES_SYSTEM/patches" > "$NERVES_BR_EXPECTED_STATE_FILE"

create_buildroot_dir() {
    # Clean up any old versions of Buildroot
    rm -fr "$NERVES_SYSTEM"/buildroot*

    # Download and extract Buildroot
    "$NERVES_SYSTEM/scripts/download-buildroot.sh" $NERVES_BR_VERSION "$NERVES_BR_DL_DIR" "$NERVES_SYSTEM"

    # Apply Nerves-specific patches
    "$NERVES_SYSTEM/buildroot/support/scripts/apply-patches.sh" "$NERVES_SYSTEM/buildroot" "$NERVES_SYSTEM/patches/buildroot"

    # Symlink Buildroot's dl directory so that it can be cached between builds
    ln -sf "$NERVES_BR_DL_DIR" "$NERVES_SYSTEM/buildroot/dl"

    cp "$NERVES_BR_EXPECTED_STATE_FILE" "$NERVES_BR_STATE_FILE"
}

if [[ ! -e $NERVES_BR_STATE_FILE ]]; then
    create_buildroot_dir
elif ! diff "$NERVES_BR_STATE_FILE" "$NERVES_BR_EXPECTED_STATE_FILE" >/dev/null; then
    echo "Detected a difference in the Buildroot source tree either due"
    echo "to an change in Buildroot or a change in the patches that Nerves"
    echo "applies to Buildroot. The Buildroot source tree will be updated."
    echo
    echo "It is highly recommended to rebuild clean."
    echo "To do this, go to $BUILD_DIR, and run 'make clean'."
    echo

    if [ -t 0 ]; then
        echo "Press return to acknowledge or CTRL-C to stop"
        read -r
    else
	echo "WARNING: Detected non-interactive terminal. Blindly continuing..."
	sleep 5
    fi

    create_buildroot_dir
fi

# Configure the build directory - finally!
make -C "$NERVES_SYSTEM/buildroot" BR2_EXTERNAL="$NERVES_SYSTEM" O="$NERVES_BUILD_DIR" \
    NERVES_DEFCONFIG_DIR="$NERVES_DEFCONFIG_DIR" \
    BR2_DEFCONFIG="$NERVES_DEFCONFIG" \
    DEFCONFIG="$NERVES_DEFCONFIG" \
    defconfig

echo "------------"
echo
echo "Build directory successfully created."
echo
echo "Configuration: $NERVES_DEFCONFIG"
echo
echo "Next, do the following:"
echo "   1. cd $NERVES_BUILD_DIR"
echo "   2. make"
echo
echo "For additional options, run 'make help' in the build directory."
echo
echo "IMPORTANT: If you update nerves_system_br, you should rerun this script."

