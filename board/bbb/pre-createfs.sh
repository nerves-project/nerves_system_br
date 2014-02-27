#!/bin/sh

#
# Pre create filesystem hook
#  - Prune out files that we don't need

TARGETDIR=$1

# All of the Erlang libraries get included from
# the release, so we don't need anything in here.
rm -fr $TARGETDIR/usr/lib/erlang/lib/*

# Clean up the Erlang release
find $TARGETDIR/srv/erlang -name "*~" -type f -exec rm "{}" ";"
find $TARGETDIR/srv/erlang -name "src" -type d -exec rm -fr "{}" ";"
find $TARGETDIR/srv/erlang -name "include" -type d -exec rm -fr "{}" ";"
find $TARGETDIR/srv/erlang -name "obj" -type d -exec rm -fr "{}" ";"
rm -fr $TARGETDIR/srv/erlang/bin srv/erlang/erts-*

# Remove all shell scripts. We're trying hard not to ever have to run
# one, so this will hopefully keep us honest.
find $TARGETDIR -type f | xargs file | grep "POSIX shell script" | cut -d : -f 1 | xargs rm
rm -f $TARGETDIR/root/.bash* $TARGETDIR/etc/profile $TARGETDIR/etc/issue

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

# Remove sys v init configs since we don't use them
# NOTE: Can't remove inittab without causing a buildroot error when
# it configures whether to mount to root file system read/write
rm -fr $TARGETDIR/etc/init.d $TARGETDIR/etc/random-seed $TARGET_DIR/etc/network \
    $TARGETDIR/etc/protocols $TARGETDIR/etc/services

# Prune empty directories
find $TARGETDIR/etc -type d -empty -delete
find $TARGETDIR/usr -type d -empty -delete
find $TARGETDIR/var -type d -empty -delete
rm -fr $TARGETDIR/home

# Misc. cleanup of target
rm -fr $TARGETDIR/usr/share/bash-completion

# Fix up multilib
if [ ! -d $TARGETDIR/usr/lib/arm-linux-gnueabihf ]; then
    ln -fs . $TARGETDIR/usr/lib/arm-linux-gnueabihf
fi
