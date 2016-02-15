#!/bin/sh

set -e

# Check that our test rootfs-addition exits
if [ ! -e $TARGET_DIR/etc/test-addition.txt ]; then
    echo "rootfs-additions not added?"
    exit 1
fi

