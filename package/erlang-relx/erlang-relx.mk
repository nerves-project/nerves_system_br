#############################################################
#
# erlang-relx
#
#############################################################

ERLANG_RELX_VERSION = v0.6.0
ERLANG_RELX_SITE = https://github.com/erlware/relx/releases/download/$(ERLANG_RELX_VERSION)
ERLANG_RELX_SOURCE = relx
ERLANG_RELX_LICENSE = Apache-2.0
HOST_ERLANG_RELX_DEPENDENCIES = host-erlang

# Macro for invoking relx in other packages
RELX = $(HOST_MAKE_ENV) \
	$(HOST_DIR)/usr/bin/relx -l $(STAGING_DIR)/usr/lib/erlang/lib

define HOST_ERLANG_RELX_EXTRACT_CMDS
	cp $(DL_DIR)/$(ERLANG_RELX_SOURCE) $(@D)
endef

define HOST_ERLANG_RELX_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(ERLANG_RELX_SOURCE) \
		$(HOST_DIR)/usr/bin/relx
endef

$(eval $(host-generic-package))
