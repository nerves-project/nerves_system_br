#############################################################
#
# LFE
#
#############################################################

LFE_VERSION = 0.9.0
LFE_SITE = $(call github,rvirding,lfe,v$(LFE_VERSION))
LFE_LICENSE = Apache-2.0
LFE_LICENSE_FILES = LICENSE
LFE_INSTALL_STAGING = YES

LFE_PROGRAMS = lfe lfec lfescript

define TARGET_LFE_INSTALL_PROGRAMS
	for bin in $(LFE_PROGRAMS) ; do \
		ln -sf $(TARGET_DIR)/usr/lib/erlang/lib/lfe-$(LFE_VERSION)/bin/$${bin} $(HOST_DIR)/usr/bin ; \
	done
endef
HOST_LFE_POST_TARGET_INSTALL_HOOKS += TARGET_LFE_INSTALL_PROGRAMS

define HOST_LFE_INSTALL_PROGRAMS
	for bin in $(LFE_PROGRAMS) ; do \
		ln -sf $(HOST_DIR)/usr/lib/erlang/lib/lfe-$(LFE_VERSION)/bin/$${bin} $(HOST_DIR)/usr/bin ; \
	done
endef
HOST_LFE_POST_INSTALL_HOOKS += HOST_LFE_INSTALL_PROGRAMS

$(eval $(rebar-package))
$(eval $(host-rebar-package))
