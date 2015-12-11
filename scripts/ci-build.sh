#!/bin/bash

# This script is invoked by the CI system to build a nerves-sdk configuration.

# The following environment variables should be set:
#  NERVES_CONFIG - e.g. nerves_bbb

# Buildroot doesn't like LD_LIBRARY_PATH set
export LD_LIBRARY_PATH=

# Configure platform
make --silent ${NERVES_CONFIG}_defconfig || exit 1

# Build the SDK

# The watchdog logic to make Travis happy is courtesy of the Buildroot project. See
# https://github.com/buildroot/buildroot-defconfig-testing/blob/master/.travis.yml
while true ; do echo "Still building" ; sleep 60 ; done &
watchdogpid=$!
make > >(tee build.log | grep '>>>') 2>&1
RC=$?
kill ${watchdogpid}
if [ $RC -ne 0 ]; then
    exit 1
fi

# Create a system image
echo "Creating system image..."
scripts/mksystem.sh nerves-system || exit 1
