#!/usr/bin/env bash

set -e

#
# Scrub the target directory for a Nerves image
#
# NOTE: Since this is being called from Buildroot, it
#       is assumed that the working directory is the
#       Buildroot root directory
#

# Check that the release directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Missing target directory: ($TARGET_DIR)"
    exit 1
fi

# Remove all shell scripts. We're trying hard not to ever have to run
# one, so this keeps us honest in the base image.
# COMMENT OUT THE NEXT LINE TO SUPPORT config-pin ON THE BBB. WE DIDN'T START
# NERVES TO CONTINUE PROGRAMMING WITH SHELL SCRIPTS, BUT SIGH...
#find $TARGET_DIR -type f | xargs file | grep "POSIX shell script" | cut -d : -f 1 | xargs rm -f

# Remove shell script configuration
rm -f "$TARGET_DIR"/root/.bash* "$TARGET_DIR/etc/profile" "$TARGET_DIR/etc/issue"
rm -fr "$TARGET_DIR/usr/share/bash-completion"

# Remove sys v init configs since Nerves doesn't run Busybox init
# NOTE: Can't remove inittab without causing a buildroot error when
# it configures whether to mount to root file system read/write
rm -fr "$TARGET_DIR/etc/init.d" "$TARGET_DIR/etc/random-seed" "$TARGET_DIR/etc/network"

# Remove the Buildroot default wpa_supplicant.conf since it is
# wrong and confusing. The wpa_supplicant.conf file must be
# dynamically created based on the regulatory domain, so it
# shouldn't be in a root filesystem anyway.
rm -f "$TARGET_DIR/etc/wpa_supplicant.conf"

# Remove the Buildroot default fstab since it isn't used.
# erlinit mounts the pseudo filesystems automatically and it
# has parameters to do a best-effort mount attempt on real
# partitions. Erlang/Elixir applications need to handle
# anything complicated.
rm -f "$TARGET_DIR/etc/fstab"

# Remove libatomic_ops readme files
rm -fr "$TARGET_DIR/usr/share/libatomic_ops"

# Prune empty directories
find "$TARGET_DIR/etc" -type d -empty -delete
find "$TARGET_DIR/usr" -type d -empty -delete
echo 'If the next line fails, add the following to nerves_defconfig and build clean (sorry):'
echo '  BR2_ROOTFS_SKELETON_CUSTOM=y'
# shellcheck disable=SC2016
echo '  BR2_ROOTFS_SKELETON_CUSTOM_PATH="${BR2_EXTERNAL_NERVES_PATH}/board/nerves-common/skeleton"'
find "$TARGET_DIR/var" -type d -empty -delete
