#
# Include this Makefile in your project to pull in the Nerves versions
# of all of the build tools.
#

NERVES_ROOT:=$(abspath $(dir $(lastword $(MAKEFILE_LIST))))
NERVES_SDK_ROOT=$(NERVES_ROOT)/buildroot/output/host
NERVES_SDK_IMAGES=$(NERVES_ROOT)/buildroot/output/images
NERVES_SDK_SYSROOT=$(NERVES_ROOT)/buildroot/output/staging

# Check that the base buildroot image has been built
#ifeq ("$(wildcard $(NERVES_SDK_IMAGES)/rootfs.tar)","")
#	$(error Remember to build nerves)
#endif

ERTS_DIR=$(wildcard $(NERVES_SDK_SYSROOT)/usr/lib/erlang/erts-*)
ERL_INTERFACE_DIR=$(wildcard $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib/erl_interface-*)
CROSSCOMPILE=$(subst -gcc,,$(firstword $(wildcard $(NERVES_SDK_ROOT)/usr/bin/*gcc)))

REBAR_PLT_DIR=$(NERVES_SDK_SYSROOT)/usr/lib/erlang
CC=$(CROSSCOMPILE)-gcc
CXX=$(CROSSCOMPILE)-g++
CFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
CXXFLAGS="-D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -pipe -Os"
LDFLAGS=""
ERL_CFLAGS="-I$(ERTS_DIR)/include -I$(ERL_INTERFACE_DIR)/include"
ERL_LDFLAGS="-L$(ERTS_DIR)/lib -L$(ERL_INTERFACE_DIR)/lib -lerts -lerl_interface -lei"
ERL_EI_LIBDIR="$(ERL_INTERFACE_DIR)/lib"
STRIP=$(CROSSCOMPILE)-strip

PKG_CONFIG=$(NERVES_SDK_ROOT)/usr/bin/pkg-config
PKG_CONFIG_SYSROOT_DIR=/
PKG_CONFIG_LIBDIR=$(NERVES_SDK_ROOT)/usr/lib/pkgconfig
PERLLIB=$(NERVES_SDK_ROOT)/usr/lib/perl

# Paths to utilities
NERVES_PATH="$(NERVES_SDK_ROOT)/bin:$(NERVES_SDK_ROOT)/sbin:$(NERVES_SDK_ROOT)/usr/bin:$(NERVES_SDK_ROOT)/usr/sbin:$(PATH)"
NERVES_LD_LIBRARY_PATH="$(NERVES_SDK_ROOT)/usr/lib:$(LD_LIBRARY_PATH)"

# Combined environment
NERVES_HOST_MAKE_ENV=PATH=$(NERVES_PATH) \
		     LD_LIBRARY_PATH=$(NERVES_LD_LIBRARY_PATH) \
		     PKG_CONFIG=$(PKG_CONFIG) \
		     PKG_CONFIG_SYSROOT_DIR=$(PKG_CONFIG_SYSROOT_DIR) \
		     PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) \
		     NERVES_ROOT=$(NERVES_ROOT) \
		     NERVES_SDK_ROOT=$(NERVES_SDK_ROOT) \
		     NERVES_SDK_IMAGES=$(NERVES_SDK_IMAGES) \
		     NERVES_SDK_SYSROOT=$(NERVES_SDK_SYSROOT) \
		     CROSSCOMPILE=$(CROSSCOMPILE)

NERVES_ALL_VARS=CC=$(CC) \
		CXX=$(CXX) \
		CFLAGS=$(CFLAGS) \
		CXXFLAGS=$(CXXFLAGS) \
		LDFLAGS=$(LDFLAGS) \
		ERL_CFLAGS=$(ERL_CFLAGS) \
		ERL_LDFLAGS=$(ERL_LDFLAGS) \

MIX=$(NERVES_HOST_MAKE_ENV) $(NERVES_ALL_VARS) $(NERVES_SDK_ROOT)/usr/bin/mix
REBAR=$(NERVES_HOST_MAKE_ENV) $(NERVES_ALL_VARS) $(NERVES_ROOT)/usr/bin/rebar
RELX=$(NERVES_HOST_MAKE_ENV) $(NERVES_SDK_ROOT)/usr/bin/relx --system_libs $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib
REL2FW=$(NERVES_HOST_MAKE_ENV) $(NERVES_ROOT)/scripts/rel2fw.sh


