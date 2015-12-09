#!/bin/bash

#
# This script creates a tarball with everything needed to build
# an application image on another system. It is useful with the
# `bake` utility so that the parts that require Linux can be
# built separately from the parts that can be built on any system.
#
set -e

# The first parameter can be the output archive name. If it's not set
# we'll create one.
ARCHIVE_NAME=$1

NERVES_ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/..
NERVES_DEFCONFIG=$(grep BR2_DEFCONFIG= $NERVES_ROOT/buildroot/.config | sed -e 's/BR2_DEFCONFIG=".*\/\(.*\)"/\1/')

# Strip the _defconfig off the configuration name for the image name
NERVES_CONFIG_NAME=$(echo $NERVES_DEFCONFIG | sed -e 's/\(.*\)_defconfig$/\1/')

WORK_DIR=$NERVES_ROOT/tmp-system
[ -z $ARCHIVE_NAME ] && ARCHIVE_NAME=nerves-system-$NERVES_CONFIG_NAME

rm -fr $WORK_DIR
mkdir -p $WORK_DIR/$ARCHIVE_NAME

# Save a tag to the archive in case we need it for debug
git describe --dirty >$WORK_DIR/$ARCHIVE_NAME/nerves-system.tag

# Add some help text for the curious
cat << EOT > $WORK_DIR/$ARCHIVE_NAME/README.md
# Nerves system image

This is an automatically generated archive created by \`nerves-sdk\`. It is
useful for building embedded Elixir projects without worrying too much
about the cross-compiler and Linux parts. See http://nerves-project.org
for more information.

## Build information

Configuration: $NERVES_DEFCONFIG
git: $(git describe --always --dirty)
EOT

# Copy common nerves shell scripts over
cp $NERVES_ROOT/nerves-env.sh $WORK_DIR/$ARCHIVE_NAME
cp $NERVES_ROOT/nerves.mk $WORK_DIR/$ARCHIVE_NAME
cp -r $NERVES_ROOT/scripts $WORK_DIR/$ARCHIVE_NAME

# Copy the built configuration over
mkdir -p $WORK_DIR/$ARCHIVE_NAME/buildroot
cp $NERVES_ROOT/buildroot/.config $WORK_DIR/$ARCHIVE_NAME/buildroot

# Copy the staging and images directories over
mkdir -p $WORK_DIR/$ARCHIVE_NAME/buildroot/output/images
mkdir -p $WORK_DIR/$ARCHIVE_NAME/buildroot/output/staging
cp -r $NERVES_ROOT/buildroot/output/images/* $WORK_DIR/$ARCHIVE_NAME/buildroot/output/images
cp -r $NERVES_ROOT/buildroot/output/staging/* $WORK_DIR/$ARCHIVE_NAME/buildroot/output/staging

tar c -z -f $NERVES_ROOT/$ARCHIVE_NAME.tar.gz -C $WORK_DIR $ARCHIVE_NAME

rm -fr $WORK_DIR
