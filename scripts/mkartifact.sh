#!/bin/bash

#
# This script creates a tarball with everything needed to build
# an application image on another system. It is useful with the
# `bake` utility so that the parts that require Linux can be
# built separately from the parts that can be built on any system.
# It is intended to be called from Buildroot's Makefiles so that
# the environment is set up properly.
#
# Inputs:
#   $1 = the archive name (if not passed, we'll make up a name)
#   BASE_DIR = the build directory (aka, the future $NERVES_SYSTEM directory)
#   PWD = the buildroot directory
#
# Outputs:
#   Archive tarball
#

set -e

ARCHIVE_NAME=$1
BR2_EXTERNAL=$PWD/..

echo $ARCHIVE_NAME

if [ -z $ARCHIVE_NAME ]; then
    echo "ERROR: Please specify an archive name"
    exit 1
fi

# Check the working directory
if [ ! -f $PWD/package/pkg-generic.mk ]; then
    echo "ERROR: mkartifact.sh must be run from the buildroot directory"
    exit 1
fi

# Check BASE_DIR
if [ -z $BASE_DIR ]; then
    echo "ERROR: BASE_DIR undefined? Script should be called from Buildroot."
    exit 1
fi

NERVES_DEFCONFIG=$(grep BR2_DEFCONFIG= $BASE_DIR/.config | sed -e 's/BR2_DEFCONFIG=".*\/\(.*\)"/\1/')

WORK_DIR=$BASE_DIR/tmp-system
rm -fr $WORK_DIR
mkdir -p $WORK_DIR/$ARCHIVE_NAME \
  $WORK_DIR/$ARCHIVE_NAME/images \
  $WORK_DIR/$ARCHIVE_NAME/staging \
  $WORK_DIR/$ARCHIVE_NAME/artifact

# Save a tag to the archive in case we need it for debug
TAG=$(git -C $BR2_EXTERNAL describe --always --dirty)
echo $TAG >$WORK_DIR/$ARCHIVE_NAME/artifact/$ARCHIVE_NAME.tag

# Add some help text for the curious
cat << EOT > $WORK_DIR/$ARCHIVE_NAME/artifact/README.md
# Nerves system image

This is an automatically generated archive created by \`nerves_system_br\`. It is
useful for building embedded Elixir projects without worrying too much
about the cross-compiler and Linux parts. See http://nerves-project.org
for more information.

## Build information

Configuration: $NERVES_DEFCONFIG
nerves_system_br: $TAG
artifact_name: $ARCHIVE_NAME
EOT

cp -R $BASE_DIR/images/* $WORK_DIR/$ARCHIVE_NAME/images
cp -R $BASE_DIR/staging/* $WORK_DIR/$ARCHIVE_NAME/staging

# Clean up extra files that were copied over and aren't needed
rm -f $WORK_DIR/$ARCHIVE_NAME/images/*.fw
rm -f $WORK_DIR/$ARCHIVE_NAME/images/nerves*.img
rm -f $WORK_DIR/$ARCHIVE_NAME/images/rootfs.squashfs

# The --format=ustar makes it possible for erl_tar to extract these archives
mv $WORK_DIR/$ARCHIVE_NAME/images/rootfs.tar.gz $WORK_DIR/$ARCHIVE_NAME/artifact
tar c -z -f $WORK_DIR/$ARCHIVE_NAME/artifact/staging.tar.gz -C $WORK_DIR/$ARCHIVE_NAME --format=ustar staging
tar c -z -f $WORK_DIR/$ARCHIVE_NAME/artifact/images.tar.gz -C $WORK_DIR/$ARCHIVE_NAME --format=ustar images
tar c -z -f $BASE_DIR/$ARCHIVE_NAME.tar.gz -C $WORK_DIR/$ARCHIVE_NAME/artifact --format=ustar staging.tar.gz images.tar.gz rootfs.tar.gz README.md $ARCHIVE_NAME.tag
