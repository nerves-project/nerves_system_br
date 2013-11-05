#!/bin/sh

#
# Pre create filesystem hook
#  - Prune out files that we don't need

TARGETDIR=$1

# All of the Erlang libraries get included from
# the release, so we don't need anything in here.
rm -fr $TARGETDIR/usr/lib/erlang/lib/*

# Clean up the release
find $TARGETDIR/srv/erlang -name "*~" -type f -exec rm "{}" ";"
find $TARGETDIR/srv/erlang -name "src" -type d -exec rm -fr "{}" ";"
find $TARGETDIR/srv/erlang -name "include" -type d -exec rm -fr "{}" ";"
find $TARGETDIR/srv/erlang -name "obj" -type d -exec rm -fr "{}" ";"
rm -fr $TARGETDIR/srv/erlang/bin srv/erlang/erts-*

# Fix up multilib
if [ ! -d $TARGETDIR/usr/lib/arm-linux-gnueabihf ]; then
    ln -fs . $TARGETDIR/usr/lib/arm-linux-gnueabihf
fi
