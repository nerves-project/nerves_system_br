#!/bin/sh

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

# All of the Erlang libraries get included from the release (/srv/erlang), so
# we don't need anything in here.
rm -fr $TARGET_DIR/usr/lib/erlang/lib/*

# Remove all shell scripts. We're trying hard not to ever have to run
# one, so this keeps us honest in the base image.
find $TARGET_DIR -type f | xargs file | grep "POSIX shell script" | cut -d : -f 1 | xargs rm -f

# Remove shell script configuration
rm -f $TARGET_DIR/root/.bash* $TARGET_DIR/etc/profile $TARGET_DIR/etc/issue
rm -fr $TARGET_DIR/usr/share/bash-completion

# Remove sys v init configs since we don't use them
# NOTE: Can't remove inittab without causing a buildroot error when
# it configures whether to mount to root file system read/write
rm -fr $TARGET_DIR/etc/init.d $TARGET_DIR/etc/random-seed $TARGET_DIR/etc/network \
    $TARGET_DIR/etc/protocols $TARGET_DIR/etc/services

# Nerves currently does not use /home at all
rm -fr $TARGET_DIR/home

# Remove Erlang binaries that don't make sense on the target
find $TARGET_DIR -name ct_run -exec rm "{}" ";"
find $TARGET_DIR -name dialyzer -exec rm "{}" ";"
find $TARGET_DIR -name erlc -exec rm "{}" ";"
find $TARGET_DIR -name escript -exec rm "{}" ";"
find $TARGET_DIR -name run_erl -exec rm "{}" ";"
find $TARGET_DIR -name to_erl -exec rm "{}" ";"
find $TARGET_DIR -name typer -exec rm "{}" ";"

# Remove soft links that aren't used
rm -f $TARGET_DIR/usr/bin/erl $TARGET_DIR/usr/bin/epmd

# Remove libatomic_ops readme files
rm -fr $TARGET_DIR/usr/share/libatomic_ops

# Prune empty directories
find $TARGET_DIR/etc -type d -empty -delete
find $TARGET_DIR/usr -type d -empty -delete
find $TARGET_DIR/var -type d -empty -delete
