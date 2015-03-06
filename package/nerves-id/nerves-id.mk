################################################################################
#
# nerves-id
#
################################################################################

NERVES_ID_SOURCE =
NERVES_ID_VERSION = 0.1
NERVES_ID_LICENSE = GPLv2

define NERVES_ID_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		../package/nerves-id/raspi-id.c \
		-o $(@D)/nerves-id
endef

define NERVES_ID_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/nerves-id $(TARGET_DIR)/usr/bin/nerves-id
endef

$(eval $(generic-package))
