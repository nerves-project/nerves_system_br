#############################################################
#
# erlang-relx
#
#############################################################

ERLANG_RELX_VERSION = v1.1.0
ERLANG_RELX_SITE = https://github.com/erlware/relx/releases/download/$(ERLANG_RELX_VERSION)
ERLANG_RELX_SOURCE = relx
ERLANG_RELX_LICENSE = Apache-2.0
HOST_ERLANG_RELX_DEPENDENCIES = host-erlang

# Use $(RELX) to build releases for the target
RELX = $(HOST_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/relx --system_libs $(STAGING_DIR)/usr/lib/erlang/lib -o $(@D)/_rel

# Use $(HOST_RELX) for building host releases
HOST_RELX = $(HOST_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/relx -o $(@D)/_rel

define HOST_ERLANG_RELX_EXTRACT_CMDS
	cp $(DL_DIR)/$(ERLANG_RELX_SOURCE) $(@D)
endef

define HOST_ERLANG_RELX_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(ERLANG_RELX_SOURCE) \
		$(HOST_DIR)/usr/bin/relx
endef

$(eval $(host-generic-package))
