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
rm -f $TARGETDIR/root/.bash*
rm -f $TARGETDIR/etc/profile

# Remove sys v init configs since we don't use them
rm -fr $TARGETDIR/etc/inittab $TARGETDIR/etc/init.d $TARGETDIR/random-seed $TARGET_DIR/network

# Misc. cleanup of target
rm -fr $TARGETDIR/usr/share/bash-completion

# Fix up multilib
if [ ! -d $TARGETDIR/usr/lib/arm-linux-gnueabihf ]; then
    ln -fs . $TARGETDIR/usr/lib/arm-linux-gnueabihf
fi
