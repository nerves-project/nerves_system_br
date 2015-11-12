#!/bin/bash

# Helper script to setup the Nerves environment. This shouldn't be called
# directly. See $NERVES_ROOT/nerves-env.sh.

NERVES_ROOT=$1

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

if [ -e $NERVES_ROOT/buildroot/output/host ]; then
    # This is a Linux Buildroot build, so use tools as
    # provided by Buildroot
    NERVES_TOOLCHAIN=$NERVES_ROOT/buildroot/output/host
    ALL_CROSSCOMPILE=`ls $NERVES_TOOLCHAIN/usr/bin/*gcc | sed -e s/-gcc//`

    # For Buildroot builds, use the Buildroot provided versions of pkg-config
    # and perl.
    export PKG_CONFIG=$NERVES_TOOLCHAIN/usr/bin/pkg-config
    export PKG_CONFIG_SYSROOT_DIR=/
    export PKG_CONFIG_LIBDIR=$NERVES_TOOLCHAIN/usr/lib/pkgconfig
    export PERLLIB=$NERVES_TOOLCHAIN/usr/lib/perl

    pathadd $NERVES_TOOLCHAIN/usr/bin
    pathadd $NERVES_TOOLCHAIN/usr/sbin
    pathadd $NERVES_TOOLCHAIN/bin
    ldlibrarypathadd $NERVES_TOOLCHAIN/usr/lib
else
    # This is a pre-built toolchain + system build
    if [ -z $NERVES_TOOLCHAIN ]; then
        # Try to guess the location based on the platform
        if [ $(uname -s) = "Darwin" ]; then
            NERVES_TOOLCHAIN=/Volumes/nerves-toolchain
        else
            NERVES_TOOLCHAIN=$NERVES_ROOT/../nerves-toolchain
        fi
    fi
    ALL_CROSSCOMPILE=`ls $NERVES_TOOLCHAIN/bin/*gcc | sed -e s/-gcc//`

    pathadd $NERVES_TOOLCHAIN/bin
fi

# Verify that a crosscompiler was found.
if [ "$ALL_CROSSCOMPILE" = "" ]; then
    echo "ERROR: Can't find cross-compiler. Is this the path to the toolchain? $NERVES_TOOLCHAIN"
    return 1
fi

NERVES_SDK_IMAGES=$NERVES_ROOT/buildroot/output/images
NERVES_SDK_SYSROOT=$NERVES_ROOT/buildroot/output/staging # Check that the base buildroot image has been built
[ -d "$NERVES_ROOT/buildroot/output" ] || { echo "ERROR: Run \"make\" first to build the nerves SDK."; return 1; }

# Past the checks, so export variables
export NERVES_ROOT
export NERVES_TOOLCHAIN
export NERVES_SDK_IMAGES
export NERVES_SDK_SYSROOT

# Rebar environment variables
PLATFORM_DIR=$NERVES_ROOT/sdk/$NERVES_PLATFORM

ERTS_DIR=`ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/erts-*`
ERL_INTERFACE_DIR=`ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/lib/erl_interface-*`
# We usually just have one crosscompiler, but the buildroot toolchain symlinks
# to the crosscompiler, so two entries show up. The logic below picks the first
# crosscompiler by default or the one with buildroot in its name.
CROSSCOMPILE=`echo $ALL_CROSSCOMPILE | head -n 1`
for i in $ALL_CROSSCOMPILE; do
    case `basename $i` in
        *buildroot* )
            CROSSCOMPILE=$i
            ;;
        * )
            ;;
    esac
done

export CROSSCOMPILE
export REBAR_PLT_DIR=$NERVES_SDK_SYSROOT/usr/lib/erlang
export CC=$CROSSCOMPILE-gcc
export CXX=$CROSSCOMPILE-g++
export CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
export CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
export LDFLAGS=""
export ERL_CFLAGS="-I$ERTS_DIR/include -I$ERL_INTERFACE_DIR/include"
export ERL_LDFLAGS="-L$ERTS_DIR/lib -L$ERL_INTERFACE_DIR/lib -lerts -lerl_interface -lei"
export ERL_EI_LIBDIR="$ERL_INTERFACE_DIR/lib"
export STRIP=$CROSSCOMPILE-strip


# Since it is so important that the host and target Erlang installs
# match, check it here.
NERVES_HOST_ERL_VER=$(cat $(dirname $(which erl))/../lib/erlang/releases/*/OTP_VERSION)
NERVES_TARGET_ERL_VER=$(cat $NERVES_SDK_SYSROOT/usr/lib/erlang/releases/*/OTP_VERSION)
if [ "$NERVES_HOST_ERL_VER" != "$NERVES_TARGET_ERL_VER" ]; then
    echo "ERROR: Version mismatch between host and target Erlang versions"
    echo "    Host version: $NERVES_HOST_ERL_VER"
    echo "    Target version: $NERVES_TARGET_ERL_VER"
    return 1
fi

return 0
