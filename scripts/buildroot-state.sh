#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2016 Frank Hunleth
# SPDX-FileCopyrightText: 2019 Matt Ludwigs
# SPDX-FileCopyrightText: 2026 Ben Youngblood
#
# SPDX-License-Identifier: GPL-2.0-or-later
#

#
# Print information about the state of the Buildroot tree.
#
# Inputs:
#   $1   The Buildroot version
#   $2   The directory containing patches for Buildroot
#
# Outputs:
#   Text describing the Buildroot tree
#

set -e
export LC_ALL=C

BR_VERSION=$1
shift
BR_PATCH_DIRS=("$@")

usage() {
    echo "buildroot-state.sh <BR version> <patch directory> [patch directory...]"
}

for patch_dir in "${BR_PATCH_DIRS[@]}"; do
    if [[ ! -d $patch_dir ]]; then
        echo "ERROR: Buildroot patch directory '$patch_dir' invalid"
        exit 1
    fi
done

if [[ -z $BR_VERSION || -z "${BR2_PATCH_DIRS[0]}" ]]; then
    usage
    exit 1
fi

for patch_dir in "${BR_PATCH_DIRS[@]}"; do
    if [[ ! -d $patch_dir ]]; then
        echo "ERROR: Buildroot patch directory '$patch_dir' invalid"
        exit 1
    fi
done

# Trust the passed in version
echo "Buildroot: $BR_VERSION"

index=0
for patch_dir in "${BR_PATCH_DIRS[@]}"; do
    index=$((index + 1))
    echo "Patch directory $index:"

    pushd "$patch_dir" >/dev/null
    find . -name "*.patch" | sort | while IFS= read -r patch; do
        sha256sum "$patch"
    done
    popd >/dev/null
done
