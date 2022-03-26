#
# Include this Makefile in your project to pull in the Nerves versions
# of all of the build tools.
#
# NOTE: If you source nerves-env.sh, then including this script is not
# necessary. Basically, the rule is to do one or the other. Sourcing
# nerves-env.sh has the advantage that the environment is set properly
# on the commandline should you need to run commands manually.
#
NERVES_VERSION:=$(strip $(shell cat VERSION))

NERVES_SYSTEM:=$(abspath $(dir $(lastword $(MAKEFILE_LIST))))
NERVES_TOOLCHAIN=$(NERVES_SYSTEM)/host
NERVES_SDK_IMAGES=$(NERVES_SYSTEM)/images
NERVES_SDK_SYSROOT=$(NERVES_SYSTEM)/staging

# Keep NERVES_ROOT defined for the transition period
NERVES_ROOT=$(NERVES_SYSTEM)

# Check that the base buildroot image has been built
#ifeq ("$(wildcard $(NERVES_SDK_IMAGES)/rootfs.tar)","")
#	$(error Remember to build nerves)
#endif

ERTS_DIR=$(wildcard $(NERVES_SDK_SYSROOT)/usr/lib/erlang/erts-*)
ERL_INTERFACE_DIR=$(wildcard $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib/erl_interface-*)
CROSSCOMPILE=$(subst -gcc,,$(firstword $(wildcard $(NERVES_TOOLCHAIN)/usr/bin/*gcc)))

REBAR_PLT_DIR=$(NERVES_SDK_SYSROOT)/usr/lib/erlang

AR=$(CROSSCOMPILE)-ar
AS=$(CROSSCOMPILE)-as
CC=$(CROSSCOMPILE)-gcc
CXX=$(CROSSCOMPILE)-g++
LD=$(CROSSCOMPILE)-ld
STRIP=$(CROSSCOMPILE)-strip

CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -O2"
CPPFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64"
CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -O2"
LDFLAGS=""
ERL_CFLAGS="-I$(ERTS_DIR)/include -I$(ERL_INTERFACE_DIR)/include"
ERL_LDFLAGS="-L$(ERTS_DIR)/lib -L$(ERL_INTERFACE_DIR)/lib -lei"

# Rebar naming
REBAR_TARGET_ARCH=$(notdir $(CROSSCOMPILE))
ERL_EI_LIBDIR="$(ERL_INTERFACE_DIR)/lib"
ERL_EI_INCLUDE_DIR="$(ERL_INTERFACE_DIR)/include"

# erlang.mk naming
ERTS_INCLUDE_DIR="$(ERTS_DIR)/include"
ERL_INTERFACE_LIB_DIR="$(ERL_EI_LIBDIR)"
ERL_INTERFACE_INCLUDE_DIR="$(ERL_EI_INCLUDE_DIR)"

PKG_CONFIG=$(NERVES_TOOLCHAIN)/usr/bin/pkg-config
PKG_CONFIG_SYSROOT_DIR=/
PKG_CONFIG_LIBDIR=$(NERVES_TOOLCHAIN)/usr/lib/pkgconfig
PKG_CONFIG_PATH=
PERLLIB=$(NERVES_TOOLCHAIN)/usr/lib/perl

# Paths to utilities
NERVES_PATH="$(NERVES_TOOLCHAIN)/bin:$(NERVES_TOOLCHAIN)/sbin:$(NERVES_TOOLCHAIN)/usr/bin:$(NERVES_TOOLCHAIN)/usr/sbin:$(PATH)"
NERVES_LD_LIBRARY_PATH="$(NERVES_TOOLCHAIN)/usr/lib:$(LD_LIBRARY_PATH)"

# Combined environment
NERVES_HOST_MAKE_ENV=PATH=$(NERVES_PATH) \
		     LD_LIBRARY_PATH=$(NERVES_LD_LIBRARY_PATH) \
		     PKG_CONFIG=$(PKG_CONFIG) \
		     PKG_CONFIG_SYSROOT_DIR=$(PKG_CONFIG_SYSROOT_DIR) \
		     PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) \
		     PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
		     NERVES_SYSTEM=$(NERVES_SYSTEM) \
		     NERVES_ROOT=$(NERVES_SYSTEM) \
		     NERVES_TOOLCHAIN=$(NERVES_TOOLCHAIN) \
		     NERVES_SDK_IMAGES=$(NERVES_SDK_IMAGES) \
		     NERVES_SDK_SYSROOT=$(NERVES_SDK_SYSROOT) \
		     CROSSCOMPILE=$(CROSSCOMPILE)

NERVES_ALL_VARS=CC=$(CC) \
		CXX=$(CXX) \
		CFLAGS=$(CFLAGS) \
		CPPFLAGS=$(CPPFLAGS) \
		CXXFLAGS=$(CXXFLAGS) \
		LDFLAGS=$(LDFLAGS) \
		ERL_CFLAGS=$(ERL_CFLAGS) \
		ERL_LDFLAGS=$(ERL_LDFLAGS) \

MIX=$(NERVES_HOST_MAKE_ENV) $(NERVES_ALL_VARS) $(NERVES_TOOLCHAIN)/usr/bin/mix
REBAR=$(NERVES_HOST_MAKE_ENV) $(NERVES_ALL_VARS) $(NERVES_TOOLCHAIN)/usr/bin/rebar
RELX=$(NERVES_HOST_MAKE_ENV) $(NERVES_TOOLCHAIN)/usr/bin/relx --system_libs $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib
REL2FW=$(NERVES_HOST_MAKE_ENV) $(NERVES_SYSTEM)/scripts/rel2fw.sh
