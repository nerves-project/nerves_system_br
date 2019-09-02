#!/usr/bin/env bash

# Not using "set -e" due to watchdog clean code below (FIXME)

# This script is invoked by the CI system to build a nerves_system_br configuration.

# The following environment variables should be set:
#  CI_DEFCONFIG_DIR - the name of the directory under configs
#  CI_DEFCONFIG     - the part of the filename that comes before _defconfig
#
# For example, to build configs/nerves_system_bbb/elixir_defconfig, the above variables
# are:
#  CI_DEFCONFIG_DIR=nerves_system_bbb
#  CI_DEFCONFIG=elixir
#

# Buildroot doesn't like LD_LIBRARY_PATH set
export LD_LIBRARY_PATH=

# Run build in a subdirectory so that we're testing out of tree builds
mkdir -p ci
cd ci || exit

# Configure platform
../create-build.sh "../configs/${CI_DEFCONFIG_DIR}/${CI_DEFCONFIG}_defconfig" out || exit 1

# Build the SDK

# The watchdog logic to make Travis happy is courtesy of the Buildroot project. See
# https://github.com/buildroot/buildroot-defconfig-testing/blob/master/.travis.yml
while true ; do echo "Still building" ; sleep 60 ; done &
watchdogpid=$!
make -C out > >(tee build.log | grep '>>>') 2>&1
RC=$?
kill $watchdogpid
if [ $RC -ne 0 ]; then
    exit 1
fi

# Create a system image
echo "Creating system image..."
make -C out system || exit 1
