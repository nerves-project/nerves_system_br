#!/bin/sh

set -e

# Run this script to update the BBB kernel patches. See the bottom
# of the script for setting the versions.

update_kernel_patch() {
  local KERNEL_VERSION=$1
  local OUTPUT_PATCH=$2

  # Download the master patch file for the RCN kernel
  local ORIGINAL_DIFF_GZ=patch-$KERNEL_VERSION.diff.gz
  rm -f $ORIGINAL_DIFF_GZ
  wget http://rcn-ee.net/deb/sid-armhf/v$KERNEL_VERSION/$ORIGINAL_DIFF_GZ

  # Expand the compressed diff and filter it through filterdiff.
  # Since buildroot uses patch instead of "git am" to apply diffs,
  # the diff file needs to be compatible. The git diff from RCN
  # is close, but contains one GIT binary diff that causes buildroot
  # to fail.
  gunzip -c $ORIGINAL_DIFF_GZ | filterdiff > $OUTPUT_PATCH

  # Clean up
  rm -f $ORIGINAL_DIFF_GZ
}

KERNEL_VERSION=3.8.13-bone64
update_kernel_patch 3.8.13-bone64 rcn-linux-kernel-3.8.patch
update_kernel_patch 3.14.17-bone8 rcn-linux-kernel-3.14.patch

echo Updated patches. Now rebuild the linux kernel.
