#############################################################
#
# erlang-rebar
#
#############################################################

ERLANG_REBAR_VERSION = 2.5.1
ERLANG_REBAR_SITE = https://github.com/rebar/rebar/releases/download/$(ERLANG_REBAR_VERSION)/rebar\#
ERLANG_REBAR_SOURCE = rebar-$(ERLANG_REBAR_VERSION)
ERLANG_REBAR_LICENSE = Apache-2.0
ERLANG_REBAR_LICENSE_FILE = LICENSE

HOST_ERLANG_REBAR_DEPENDENCIES = host-erlang

ERLANG_ERTS_DIR = `ls -d $(STAGING_DIR)/usr/lib/erlang/erts-*`
ERLANG_ERL_INTERFACE_DIR = `ls -d $(STAGING_DIR)/usr/lib/erlang/lib/erl_interface-*`

# Macro for invoking rebar in other packages
REBAR = $(HOST_MAKE_ENV) \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	ERL_CFLAGS="-I$(ERLANG_ERTS_DIR)/include -I$(ERLANG_ERL_INTERFACE_DIR)/include" \
	ERL_LDFLAGS="-L$(ERLANG_ERTS_DIR)/lib -L$(ERLANG_ERL_INTERFACE_DIR)/lib -lerts -lei" \
	REBAR_PLT_DIR="$(STAGING_DIR)/usr/lib/erlang" \
	$(HOST_DIR)/usr/bin/rebar -v

define HOST_ERLANG_REBAR_EXTRACT_CMDS
	cp $(DL_DIR)/$(ERLANG_REBAR_SOURCE) $(@D)
endef

define HOST_ERLANG_REBAR_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(ERLANG_REBAR_SOURCE) \
		$(HOST_DIR)/usr/bin/rebar
endef

$(eval $(host-generic-package))
