################################################################################
#
# pigpio
#
################################################################################

PIGPIO_VERSION = 4862a16c9f76f9b2096055c98ef4fbc480dc1878
PIGPIO_SITE = $(call github,joan2937,pigpio,$(PIGPIO_VERSION))
PIGPIO_LICENSE = UNLICENCE
PIGPIO_LICENSE_FILES = UNLICENCE

define PIGPIO_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) VC_DIR=$(STAGING_DIR)/usr -C $(@D) -j4
endef

define PIGPIO_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
