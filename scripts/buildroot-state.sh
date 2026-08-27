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
#   $2+  The directories containing patches for Buildroot
#
# Outputs:
#   Text describing the Buildroot tree
#

set -euo pipefail
export LC_ALL=C

BR_VERSION=${1-}
shift || true
BR_PATCH_DIRS=("$@")

usage() {
    echo "buildroot-state.sh <BR version> <patch directory> [patch directory...]"
}

if [[ -z $BR_VERSION || ${#BR_PATCH_DIRS[@]} -eq 0 ]]; then
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

    # sha256sum over all the files in sorted order. Hidden files/dirs are excluded
    # because apply-patches.sh won't apply them. Don't limit to just .patch files
    # since apply-patches.sh will apply series files, patch tarballs, etc. Skip
    # empty directories as well.
    files=$(find . -type f -not -path '*/.*' | sort)
    if [[ -n $files ]]; then
        echo "$files" | xargs sha256sum
    fi

    popd >/dev/null
done
