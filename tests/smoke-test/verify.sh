#!/usr/bin/env bash

set -e

# Check that our test package exists
if [ ! -e "$TARGET_DIR/usr/bin/my-package" ]; then
    echo "my-package not found?"
    exit 1
fi

# Check that our test rootfs_overlay file exists
if [ ! -e "$TARGET_DIR/etc/test-addition.txt" ]; then
    echo "rootfs_overlay not added?"
    exit 1
fi

# Check that our x86_64 (not ARM) executable wasn't scrubbed
if [ ! -e "$TARGET_DIR/srv/erlang/lib/test-0.1.0/priv/other_arch/xeyes" ]; then
    echo "what happened to xeyes?"
    exit 1
fi

if file "$TARGET_DIR/srv/erlang/lib/test-0.1.0/priv/same_arch/boardid" | grep "not stripped"; then
    echo "Expecting the scrubber to strip boardid, but it didn't?"
    exit 1
fi
