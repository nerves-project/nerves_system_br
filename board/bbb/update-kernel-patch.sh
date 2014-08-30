#!/bin/sh

set -e

# Run this script to update the BBB kernel's patch. You'll need to
# update the KERNEL_VERSION variable based on RCN's latest release.
KERNEL_VERSION=3.8.13-bone64

# Download the master patch file for the RCN kernel
ORIGINAL_DIFF_GZ=patch-$KERNEL_VERSION.diff.gz
rm -f $ORIGINAL_DIFF_GZ
wget http://rcn-ee.net/deb/sid-armhf/v$KERNEL_VERSION/$ORIGINAL_DIFF_GZ

# Expand the compressed diff and filter it through filterdiff.
# Since buildroot uses patch instead of "git am" to apply diffs,
# the diff file needs to be compatible. The git diff from RCN
# is close, but contains one GIT binary diff that causes buildroot
# to fail.
gunzip -c $ORIGINAL_DIFF_GZ | filterdiff > rcn-linux-kernel.patch

echo Updated rcn-linux-kernel.patch. Now rebuild the linux kernel.
