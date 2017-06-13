################################################################################
#
# pigpio
#
################################################################################

PIGPIO_VERSION = 4862a16c9f76f9b2096055c98ef4fbc480dc1878
PIGPIO_SITE = $(call github,joan2937,pigpio,$(PIGPIO_VERSION))
PIGPIO_LICENSE = Unlicense
PIGPIO_LICENSE_FILES = UNLICENCE
PIGPIO_INSTALL_STAGING = YES

define PIGPIO_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) VC_DIR=$(STAGING_DIR)/usr -C $(@D)
endef

define PIGPIO_INSTALL_STAGING_CMDS
        $(MAKE) $(TARGET_CONFIGURE_OPTS) prefix=/usr DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define PIGPIO_INSTALL_TARGET_CMDS
        $(MAKE) $(TARGET_CONFIGURE_OPTS) prefix=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
