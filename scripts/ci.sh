#!/bin/bash

export DEFCONFIG_NAME="nerves_${NERVES_CONFIG}_defconfig"
export LD_LIBRARY_PATH=

# Configure platform
make --silent $DEFCONFIG_NAME

# Build the SDK

# The watchdog logic to make Travis happy is courtesy of the Buildroot project. See
# https://github.com/buildroot/buildroot-defconfig-testing/blob/master/.travis.yml
while true ; do echo "Still building" ; sleep 60 ; done &
watchdogpid=$!
make > >(tee build.log | grep '>>>') 2>&1
kill ${watchdogpid}
echo 'Display end of log'
tail -500 build.log

# Create a system image
BRANCH_OR_TAG=$(git describe --exact-match 2>/dev/null || git rev-parse --abbrev-ref HEAD)
SYSTEM_ARCHIVE_NAME=nerves-system-$NERVES_CONFIG_NAME-$BRANCH_OR_TAG
scripts/mksystem.sh $SYSTEM_ARCHIVE_NAME

# Save the artifacts
rm -fr artifacts
mkdir artifacts
cp $SYSTEM_ARCHIVE_NAME.tar.gz artifacts
cp buildroot/output/images/*.fw artifacts/$NERVES_CONFIG_NAME-$BRANCH_OR_TAG.fw # only one .fw file in images
