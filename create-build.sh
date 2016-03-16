#!/bin/bash

#
# Create and initialize a directory for building nerves-system-br.
#
# Inputs:
#   $1 = the path to the configuration file (a _defconfig file)
#   $2 = the build directory
#
# Output:
#   An initialized build directory on success
#

set -e

NERVES_BR_VERSION=20160316

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
        echo "`pwd -P`/$filename"
    fi
}

if [[ -z $DEFCONFIG || -z $BUILD_DIR ]]; then
    echo "Usage:"
    echo
    echo "  $0 <defconfig> <build directory>"
    exit 1
fi

# Create the build directory if it doesn't already exist
mkdir -p $BUILD_DIR

# Normalize paths that were specified
NERVES_DEFCONFIG=$(readlink_f $DEFCONFIG)
NERVES_DEFCONFIG_DIR=$(dirname $NERVES_DEFCONFIG)
NERVES_BUILD_DIR=$(readlink_f $BUILD_DIR)

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

if [[ $HOST_ARCH != "x86_64" ]]; then
    echo "ERROR: 64-bit Linux required for running cross-compilers built by nerves-toolchain"
    exit 1
fi

# Determine the NERVES_SYSTEM source directory
NERVES_SYSTEM=$(dirname $(readlink_f "${BASH_SOURCE[0]}"))
if [[ ! -e $NERVES_SYSTEM ]]; then
    echo "ERROR: Can't determine script directory!"
    exit 1
fi

# Location to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
#
# NOTE: If you are a heavy Buildroot user and have an alternative location,
#       override this environment variable or symlink this directory.
if [[ -z $NERVES_BR_DL_DIR ]]; then
    NERVES_BR_DL_DIR=$HOME/.nerves/cache/buildroot
fi
mkdir -p $NERVES_BR_DL_DIR

NERVES_BR_PATCHED_FILE=$NERVES_SYSTEM/buildroot-$NERVES_BR_VERSION/.nerves-patched
if [[ ! -e $NERVES_BR_PATCHED_FILE ]]; then
    # Clean up any old versions of Buildroot
    rm -fr $NERVES_SYSTEM/buildroot*

    # Download and extract Buildroot
    $NERVES_SYSTEM/scripts/download-buildroot.sh $NERVES_BR_VERSION $NERVES_BR_DL_DIR $NERVES_SYSTEM

    # Apply Nerves-specific patches
    $NERVES_SYSTEM/buildroot/support/scripts/apply-patches.sh $NERVES_SYSTEM/buildroot $NERVES_SYSTEM/patches

    # Symlink Buildroot's dl directory so that it can be cached between builds
    ln -sf $NERVES_BR_DL_DIR $NERVES_SYSTEM/buildroot/dl

    touch $NERVES_BR_PATCHED_FILE
fi

# Configure the build directory - finally!
make -C $NERVES_SYSTEM/buildroot BR2_EXTERNAL=$NERVES_SYSTEM O=$NERVES_BUILD_DIR \
    NERVES_DEFCONFIG_DIR=$NERVES_DEFCONFIG_DIR \
    BR2_DEFCONFIG=$NERVES_DEFCONFIG \
    DEFCONFIG=$NERVES_DEFCONFIG \
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
echo "IMPORTANT: If you update nerves-system-br, you should rerun this script."
