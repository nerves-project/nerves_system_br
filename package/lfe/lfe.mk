#############################################################
#
# LFE
#
#############################################################

LFE_VERSION = v0.9.0
LFE_SITE = $(call github,rvirding,lfe,$(LFE_VERSION))
LFE_LICENSE = Apache-2.0
LFE_LICENSE_FILES = LICENSE

# Technically we only depend on host-erlang to build the lfe
# compiler, but the files built by it only run if erlang is on
# the target.
HOST_LFE_DEPENDENCIES = host-erlang erlang

define HOST_LFE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_LFE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) DESTBINDIR=$(HOST_DIR)/usr/bin install
endef

$(eval $(host-generic-package))
