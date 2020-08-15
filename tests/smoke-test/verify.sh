#!/bin/sh

set -e

# Check that our test package exists
if [ ! -e $TARGET_DIR/usr/bin/my-package ]; then
    echo "my-package not found?"
    exit 1
fi

# Check that our test rootfs_overlay file exists
if [ ! -e $TARGET_DIR/etc/test-addition.txt ]; then
    echo "rootfs_overlay not added?"
    exit 1
fi

