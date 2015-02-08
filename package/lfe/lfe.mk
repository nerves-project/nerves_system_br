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
LFE_INSTALL_TARGET = NO

# LFE contains a platform-specific shared library, so the usual
# configuration will have one built for the host and one for
# the target. Project that use LFE should be careful to use the
# host version to run lfe scripts and the target beam files when
# making releases.
LFE_DEPENDENCIES = host-erlang erlang host-lfe
HOST_LFE_DEPENDENCIES = host-erlang host-erlang-rebar

LFE_INSTALL_DIR_OFFSET = usr/lib/erlang/lib/lfe-$(LFE_VERSION)

define LFE_BUILD_CMDS
	(cd $(@D) && $(REBAR) compile)
endef

# Install the target LFE to staging. Projects that depend on LFE
# should reference this staging directory when making releases.
define LFE_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/$(LFE_INSTALL_DIR_OFFSET)
	for dir in bin ebin priv ; do \
	    cp -r $(@D)/$${dir} $(STAGING_DIR)/$(LFE_INSTALL_DIR_OFFSET) ; \
	done
endef

define HOST_LFE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

# The LFE Makefile installs symlinks to its binaries in /usr/bin.
# This is not convenient for packaging tools that need to reference
# LFE's .beam files, so install everything to /usr/lib/lfe
define HOST_LFE_INSTALL_CMDS
	$(INSTALL) -d $(HOST_DIR)/$(LFE_INSTALL_DIR_OFFSET)
	for dir in bin ebin priv ; do \
	    cp -r $(@D)/$${dir} $(HOST_DIR)/$(LFE_INSTALL_DIR_OFFSET) ; \
	done
	$(INSTALL) -d $(HOST_DIR)/usr/lib/lfe
	for bin in lfe lfec lfescript ; do \
		ln -sf $(HOST_DIR)/$(LFE_INSTALL_DIR_OFFSET)/bin/$${bin} $(HOST_DIR)/usr/bin ; \
	done
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
