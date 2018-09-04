#!/usr/bin/env bash

# Helper script to setup the Nerves environment. This shouldn't be called
# directly. See $NERVES_SYSTEM/nerves-env.sh.

# NERVES_SYSTEM is the new name for NERVES_ROOT. Define both in this period
# of transition.
NERVES_SYSTEM=$1
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

if [ -e $NERVES_SYSTEM/host ]; then
    # This is a Linux Buildroot build, so use tools as
    # provided by Buildroot
    NERVES_TOOLCHAIN=$NERVES_SYSTEM/host
    ALL_CROSSCOMPILE=$(ls "$NERVES_TOOLCHAIN"/usr/bin/*gcc | sed -e s/-gcc//)

    # For Buildroot builds, use the Buildroot provided versions of pkg-config
    # and perl.
    export PKG_CONFIG=$NERVES_TOOLCHAIN/usr/bin/pkg-config
    export PKG_CONFIG_SYSROOT_DIR=$NERVES_SYSTEM/staging
    export PKG_CONFIG_LIBDIR=$NERVES_SYSTEM/staging/usr/lib/pkgconfig

    export PERLLIB=$NERVES_TOOLCHAIN/usr/lib/perl

    pathadd "$NERVES_TOOLCHAIN/usr/bin"
    pathadd "$NERVES_TOOLCHAIN/usr/sbin"
    pathadd "$NERVES_TOOLCHAIN/bin"
    ldlibrarypathadd "$NERVES_TOOLCHAIN/usr/lib"
else
    # The user is using a prebuilt toolchain and system. Usually NERVES_TOOLCHAIN will be defined,
    # but guess it just in case it isn't.
    if [ -z $NERVES_TOOLCHAIN ]; then
        NERVES_TOOLCHAIN=$NERVES_SYSTEM/../nerves-toolchain
    fi
    ALL_CROSSCOMPILE=$(ls "$NERVES_TOOLCHAIN"/bin/*gcc | sed -e s/-gcc//)

    pathadd "$NERVES_TOOLCHAIN/bin"
fi

# Verify that a crosscompiler was found.
if [ "$ALL_CROSSCOMPILE" = "" ]; then
    echo "ERROR: Can't find cross-compiler."
    echo "    Is this the path to the toolchain? $NERVES_TOOLCHAIN"
    echo
    echo "    You may also set the NERVES_TOOLCHAIN environment variable before"
    echo "    calling this script. Be sure that \$NERVES_TOOLCHAIN/bin/ contains"
    echo "    the right cross-compiler, though."
    return 1
fi

NERVES_SDK_IMAGES=$NERVES_SYSTEM/images
NERVES_SDK_SYSROOT=$NERVES_SYSTEM/staging

# Check that the base buildroot image has been built
if [ ! -d "$NERVES_SDK_IMAGES" ]; then
    echo "ERROR: It looks like the system hasn't been built!"
    echo "    Expected to find the $NERVES_SDK_IMAGES directory, but didn't."
    return 1
fi

# Past the checks, so export variables
export NERVES_SYSTEM
export NERVES_ROOT
export NERVES_TOOLCHAIN
export NERVES_SDK_IMAGES
export NERVES_SDK_SYSROOT

# Rebar environment variables
#PLATFORM_DIR=$NERVES_ROOT/sdk/$NERVES_PLATFORM # Update when this is determined

ERTS_DIR=$(ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/erts-*)
ERL_INTERFACE_DIR=$(ls -d $NERVES_SDK_SYSROOT/usr/lib/erlang/lib/erl_interface-*)
# We usually just have one crosscompiler, but the buildroot toolchain symlinks
# to the crosscompiler, so two entries show up. The logic below picks the first
# crosscompiler by default or the one with buildroot in its name.
CROSSCOMPILE=$(echo "$ALL_CROSSCOMPILE" | head -n 1)
for i in $ALL_CROSSCOMPILE; do
    case $(basename $i) in
        *buildroot* )
            CROSSCOMPILE=$i
            ;;
        * )
            ;;
    esac
done

# Export environment variables used by Elixir, Erlang, C/C++ and other tools
# so that they use Nerves toolchain parameters and not the host's.
#
# This list is built up partially by adding environment variables from project
# as issues are identified since there's not a fixed convention for how these
# are used. The Rebar project source code for compiling C ports was very helpful
# initially.
export CROSSCOMPILE
export REBAR_PLT_DIR=$NERVES_SDK_SYSROOT/usr/lib/erlang
export CC=$CROSSCOMPILE-gcc
export CXX=$CROSSCOMPILE-g++
export CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os -I$NERVES_SDK_SYSROOT/usr/include"
export CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os -I$NERVES_SDK_SYSROOT/usr/include"
export LDFLAGS="--sysroot=$NERVES_SDK_SYSROOT"
export STRIP=$CROSSCOMPILE-strip
export ERL_CFLAGS="-I$ERTS_DIR/include -I$ERL_INTERFACE_DIR/include"
export ERL_LDFLAGS="-L$ERTS_DIR/lib -L$ERL_INTERFACE_DIR/lib -lerts -lerl_interface -lei"
export REBAR_TARGET_ARCH="$(basename "$CROSSCOMPILE")"

# Qt/QMake
if [ -e "$NERVES_SDK_SYSROOT/mkspecs/devices/linux-buildroot-g++" ]; then
    export QMAKESPEC=$NERVES_SDK_SYSROOT/mkspecs/devices/linux-buildroot-g++
fi

# Rebar naming
export ERL_EI_LIBDIR="$ERL_INTERFACE_DIR/lib"
export ERL_EI_INCLUDE_DIR="$ERL_INTERFACE_DIR/include"

# erlang.mk naming
export ERTS_INCLUDE_DIR="$ERTS_DIR/include"
export ERL_INTERFACE_LIB_DIR="$ERL_INTERFACE_DIR/lib"
export ERL_INTERFACE_INCLUDE_DIR="$ERL_INTERFACE_DIR/include"

# Since it is so important that the host and target Erlang installs
# match, check it here.
NERVES_HOST_ERL_MAJOR_VER_RAW=$(erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell)
NERVES_HOST_ERL_MAJOR_VER=${NERVES_HOST_ERL_MAJOR_VER_RAW//\"}       # Trim double quotes
NERVES_HOST_ERL_MAJOR_VER=${NERVES_HOST_ERL_MAJOR_VER//[[:space:]]/} # Trim whitespace

# The OTP_VERSION file's location depends on where erl is located. Try both locations
ERL_DIR=$(dirname "$(command -v erl)")
HOST_OTP_VERSION_PATH=$ERL_DIR/../lib/erlang/releases/$NERVES_HOST_ERL_MAJOR_VER/OTP_VERSION
[ -e "$HOST_OTP_VERSION_PATH" ] || HOST_OTP_VERSION_PATH=$ERL_DIR/../../releases/$NERVES_HOST_ERL_MAJOR_VER/OTP_VERSION

NERVES_HOST_ERL_VER=$(cat $HOST_OTP_VERSION_PATH)
NERVES_TARGET_ERL_VER=$(cat $NERVES_SDK_SYSROOT/usr/lib/erlang/releases/*/OTP_VERSION)
NERVES_TARGET_ERL_MAJOR_VER=${NERVES_TARGET_ERL_VER%%.*}
if [ "$NERVES_HOST_ERL_MAJOR_VER" != "$NERVES_TARGET_ERL_MAJOR_VER" ]; then
    echo "ERROR: Major version mismatch between host and target Erlang/OTP versions"
    echo "    Host version: $NERVES_HOST_ERL_VER"
    echo "    Target version: $NERVES_TARGET_ERL_VER"
    echo
    echo "This will likely cause Erlang code compiled for the target to fail in"
    echo "unexpected ways. Install an Erlang OTP release that matches the target"
    echo "version before continuing."
    echo
    echo "Upgrading the target is most likely what you want to do. Sometimes,"
    echo "for whatever reason, it may not be an option for you. With that in mind,"
    echo "another option is to use a different version of the nerves system for"
    echo "your target, one that uses the Erlang OTP version you have on your host."
    echo
    echo "Example:"
    echo "  Your host has Erlang OTP 20 and your target is a rpi0."
    echo "  The latest version of \`nerves_system_rpi0\` is say, \`v1.2.0\` and it"
    echo "  uses Erlang OTP 21. You can try downgrading a release, to \`v1.1.1\` where"
    echo "  the Erlang OTP version is 20."
    echo
    return 1
fi
if [ "$NERVES_HOST_ERL_VER" != "$NERVES_TARGET_ERL_VER" ]; then
    echo "WARNING: Minor version mismatch between host and target Erlang/OTP versions"
    echo "    Host version: $NERVES_HOST_ERL_VER"
    echo "    Target version: $NERVES_TARGET_ERL_VER"
    echo
    echo "It is good practice to use the same Erlang OTP release on the host (this"
    echo "computer) and target to ensure reproduceable builds. Differences in"
    echo "minor versions should still work, though."
    echo
fi

return 0
