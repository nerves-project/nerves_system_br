#############################################################
#
# erlang-relx
#
#############################################################

ERLANG_RELX_VERSION = 10620765c5028c24d57caba20b8e86b98351e3a5
ERLANG_RELX_SITE = $(call github,erlware,relx,$(ERLANG_RELX_VERSION))
ERLANG_RELX_LICENSE = Apache-2.0
ERLANG_RELX_LICENSE_FILE = LICENSE.md

HOST_ERLANG_RELX_DEPENDENCIES = host-erlang host-erlang-rebar

# Macro for invoking relx in other packages
RELX = $(HOST_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/relx -l $(STAGING_DIR)/usr/lib/erlang/lib

define HOST_ERLANG_RELX_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define HOST_ERLANG_RELX_INSTALL_CMDS
	cp $(@D)/relx $(HOST_DIR)/usr/bin
endef

$(eval $(host-generic-package))
