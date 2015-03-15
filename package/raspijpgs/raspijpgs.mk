################################################################################
#
# raspijpgs
#
################################################################################

RASPIJPGS_VERSION = ddeed781d379f1e146f087981ac18fcdceae678c
RASPIJPGS_SITE = $(call github,fhunleth,raspijpgs,$(RASPIJPGS_VERSION))
RASPIJPGS_LICENSE = BSD-3c
RASPIJPGS_LICENSE_FILES = LICENCE

define RASPIJPGS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) VC_DIR=$(STAGING_DIR)/usr -C $(@D)
endef

define RASPIJPGS_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) INSTALL_PREFIX=$(TARGET_DIR)/usr -C $(@D) install
endef

$(eval $(generic-package))
