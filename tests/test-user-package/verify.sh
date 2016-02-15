#!/bin/sh

set -e

# Check that our test rootfs-addition exits
if [ ! -e $TARGET_DIR/usr/bin/my-package ]; then
    echo "my-package not found?"
    exit 1
fi

