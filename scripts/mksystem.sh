#!/bin/bash

#
# This script creates a tarball with everything needed to build
# an application image on another system. It is useful with the
# `bake` utility so that the parts that require Linux can be
# built separately from the parts that can be built on any system.
#
set -e

NERVES_ROOT=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)/..

WORK_DIR=$NERVES_ROOT/tmp-system
ARCHIVE_NAME=system

rm -fr $WORK_DIR
mkdir -p $WORK_DIR/$ARCHIVE_NAME

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
