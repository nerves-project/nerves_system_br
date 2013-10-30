#!/bin/bash

# Source this script to setup your environment to cross-compile
# and build Erlang apps for this nerves-sdk build.

NERVES_ROOT=$(dirname $(readlink -f $0))
NERVES_SDK_ROOT=$NERVES_ROOT/buildroot/output/host
NERVES_SDK_IMAGES=$NERVES_ROOT/buildroot/output/images
NERVES_SDK_SYSROOT=$NERVES_ROOT/buildroot/output/staging

# Check that the base buildroot image has been built
[ -d "$NERVES_ROOT/buildroot/output" ] || { echo "Run \"make br-make\" first to build the nerves SDK."; exit 1; }

# Past the checks, so export variables
export NERVES_ROOT
export NERVES_SDK_ROOT
export NERVES_SDK_IMAGES
export NERVES_SDK_SYSROOT

# Rebar environment variables
PLATFORM_DIR=$NERVES_ROOT/sdk/$NERVES_PLATFORM

ERTS_DIR=`ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/erts-*`
ERL_INTERFACE_DIR=`ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/lib/erl_interface-*`
CROSSCOMPILE=$NERVES_SDK_ROOT/usr/bin/arm-linux-gnueabihf

export REBAR_PLT_DIR=$NERVES_SDK_SYSROOT/usr/lib/erlang
export CC=$CROSSCOMPILE-gcc
export CXX=$CROSSCOMPILE-g++
export CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
export CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
export LDFLAGS=""
export ERL_CFLAGS="-I$ERTS_DIR/include -I$ERL_INTERFACE_DIR/include"
export ERL_LDFLAGS="-L$ERTS_DIR/lib -L$ERL_INTERFACE_DIR/lib -lerts -lei"

export PKG_CONFIG=$NERVES_SDK_ROOT/usr/bin/pkg-config
export PKG_CONFIG_SYSROOT_DIR=/
export PKG_CONFIG_LIBDIR=$NERVES_SDK_ROOT/usr/lib/pkgconfig
export PERLLIB=$NERVES_SDK_ROOT/usr/lib/perl

pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

ldlibrarypathadd() {
    if [ -d "$1" ] && [[ ":$LD_LIBRARY_PATH:" != *":$1:"* ]]; then
        LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"
    fi
}

pathadd $NERVES_SDK_ROOT/usr/bin
pathadd $NERVES_SDK_ROOT/bin
ldlibrarypathadd $NERVES_SDK_ROOT/usr/lib

echo Nerves environment updated for this session
