#!/bin/sh

set -e

#
# Scrub the target directory for a Nerves image
#
# NOTE: Since this is being called from Buildroot, it
#       is assumed that the working directory is the
#       Buildroot root directory
#

TARGETDIR=$1
[ -d "$TARGETDIR" ] || TARGETDIR=$(pwd)/output/target

# Check that the release directory exists
if [ ! -d "$TARGETDIR" ]; then
    echo "ERROR: Missing target directory: ($TARGETDIR)"
    exit 1
fi

# All of the Erlang libraries get included from the release (/srv/erlang), so
# we don't need anything in here.
rm -fr $TARGETDIR/usr/lib/erlang/lib/*

# Remove all shell scripts. We're trying hard not to ever have to run
# one, so this keeps us honest in the base image.
find $TARGETDIR -type f | xargs file | grep "POSIX shell script" | cut -d : -f 1 | xargs rm -f

# Remove shell script configuration
rm -f $TARGETDIR/root/.bash* $TARGETDIR/etc/profile $TARGETDIR/etc/issue
rm -fr $TARGETDIR/usr/share/bash-completion

# Remove sys v init configs since we don't use them
# NOTE: Can't remove inittab without causing a buildroot error when
# it configures whether to mount to root file system read/write
rm -fr $TARGETDIR/etc/init.d $TARGETDIR/etc/random-seed $TARGET_DIR/etc/network \
    $TARGETDIR/etc/protocols $TARGETDIR/etc/services

# Nerves currently does not use /home at all
rm -fr $TARGETDIR/home

# Remove Erlang binaries that don't make sense on the target
find $TARGETDIR -name ct_run -exec rm "{}" ";"
find $TARGETDIR -name dialyzer -exec rm "{}" ";"
find $TARGETDIR -name erlc -exec rm "{}" ";"
find $TARGETDIR -name escript -exec rm "{}" ";"
find $TARGETDIR -name run_erl -exec rm "{}" ";"
find $TARGETDIR -name to_erl -exec rm "{}" ";"
find $TARGETDIR -name typer -exec rm "{}" ";"

# Remove soft links that aren't used
rm -f $TARGETDIR/usr/bin/erl $TARGETDIR/usr/bin/epmd

# Remove libatomic_ops readme files
rm -fr $TARGETDIR/usr/share/libatomic_ops

# Prune empty directories
find $TARGETDIR/etc -type d -empty -delete
find $TARGETDIR/usr -type d -empty -delete
find $TARGETDIR/var -type d -empty -delete
