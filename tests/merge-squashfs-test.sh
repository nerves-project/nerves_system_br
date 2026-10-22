#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 Edgar Andrés Margffoy Tuay
#
# SPDX-License-Identifier: Apache-2.0
#
# Merges an overlay into a small squashfs with scripts/merge-squashfs and
# checks the result: the base image's modes, owners, device nodes and
# symlinks survive, overlay files are added as root with their own modes,
# and the overlay replaces base files. Needs only squashfs-tools; it takes a
# few seconds, so it runs before the full build in run_tests.sh.

set -e

SCRIPTS_DIR="$(cd "$(dirname "$0")/../scripts" && pwd)"
MERGE_SQUASHFS="${MERGE_SQUASHFS:-$SCRIPTS_DIR/merge-squashfs}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
umask 022

# Device nodes in the base image only as root: merge-squashfs unpacks the
# base, and unsquashfs can't create them otherwise. (Nerves systems' images
# have none; /dev is devtmpfs.)
DEVICES=()
if [[ $EUID -eq 0 ]]; then
    DEVICES=(-p "/dev/null c 666 0 0 1 3"
             -p "/dev/tty0 c 620 0 5 4 0"
             -p "/dev/mmcblk0 b 660 0 6 179 0")
else
    echo "Not root: skipping device nodes"
fi

# The base image as a system provides it: owned by root, with special modes,
# set by pseudo definitions (-all-root would also clear the device groups)
mkdir -p "$WORK/base/bin" "$WORK/base/etc" "$WORK/base/tmp" "$WORK/base/dev" \
    "$WORK/base/dir with spaces"
echo base > "$WORK/base/etc/hostname"
echo su > "$WORK/base/bin/su"
echo sh > "$WORK/base/bin/sh"
echo spaced > "$WORK/base/dir with spaces/a file"
ln -s sh "$WORK/base/bin/ash"
cat > "$WORK/base.pseudo" << 'PSEUDO'
/bin m 755 0 0
/bin/sh m 755 0 0
/bin/su m 4755 0 0
/bin/ash m 777 0 0
/dev m 755 0 0
/etc m 755 0 0
/etc/hostname m 644 0 0
/tmp m 1777 0 0
/dir\ with\ spaces m 755 0 0
/dir\ with\ spaces/a\ file m 644 0 0
PSEUDO
mksquashfs "$WORK/base" "$WORK/base.squashfs" -noappend -quiet \
    -pf "$WORK/base.pseudo" "${DEVICES[@]}" > /dev/null

# The overlay, as rel2fw.sh stages it: owned by whoever builds the firmware
mkdir -p "$WORK/overlay/srv/erlang" "$WORK/overlay/etc"
echo overlay > "$WORK/overlay/etc/hostname"
echo app > "$WORK/overlay/srv/erlang/run me"
chmod 750 "$WORK/overlay/srv/erlang/run me"
echo config > "$WORK/overlay/srv/erlang/sys.config"
chmod 640 "$WORK/overlay/srv/erlang/sys.config"
ln -s "run me" "$WORK/overlay/srv/erlang/start"
touch "$WORK/priorities"

"$MERGE_SQUASHFS" "$WORK/base.squashfs" "$WORK/merged.squashfs" "$WORK/overlay" "$WORK/priorities"

LISTING="$(unsquashfs -n -lln "$WORK/merged.squashfs")"
FAILED=0

# expect <path> <mode string> <uid/gid>
expect() {
    local line found=""
    while IFS= read -r line; do
        case "$line" in
            *" squashfs-root$1" | *" squashfs-root$1 -> "*) found="$line" ;;
        esac
    done <<< "$LISTING"

    if [[ -z "$found" ]]; then
        echo "FAIL: $1 is missing"
        FAILED=1
        return
    fi
    read -r mode owner _ <<< "$found"
    if [[ "$mode" != "$2" || "$owner" != "$3" ]]; then
        echo "FAIL: $1 is $mode $owner, expected $2 $3"
        FAILED=1
    fi
}

# From the base image
expect "/bin/su" "-rwsr-xr-x" "0/0"
expect "/bin/ash" "lrwxrwxrwx" "0/0"
expect "/tmp" "drwxrwxrwt" "0/0"
if [[ $EUID -eq 0 ]]; then
    expect "/dev/null" "crw-rw-rw-" "0/0"
    expect "/dev/tty0" "crw--w----" "0/5"
    expect "/dev/mmcblk0" "brw-rw----" "0/6"
fi
expect "/dir with spaces/a file" "-rw-r--r--" "0/0"

# From the overlay
expect "/srv/erlang" "drwxr-xr-x" "0/0"
expect "/srv/erlang/run me" "-rwxr-x---" "0/0"
expect "/srv/erlang/sys.config" "-rw-r-----" "0/0"
expect "/srv/erlang/start" "lrwxrwxrwx" "0/0"
expect "/etc/hostname" "-rw-r--r--" "0/0"

# The overlay's file replaces the base's
unsquashfs -n -q -d "$WORK/out" "$WORK/merged.squashfs" /etc/hostname > /dev/null
if [[ "$(cat "$WORK/out/etc/hostname")" != "overlay" ]]; then
    echo "FAIL: /etc/hostname wasn't replaced by the overlay's"
    FAILED=1
fi

if [[ $FAILED -ne 0 ]]; then
    echo "merge-squashfs test failed"
    exit 1
fi
echo "merge-squashfs test passed"
