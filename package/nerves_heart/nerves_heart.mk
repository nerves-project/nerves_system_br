#############################################################
#
# nerves_heart
#
#############################################################

NERVES_HEART_VERSION = v0.3.0
NERVES_HEART_SITE = $(call github,nerves-project,nerves_heart,$(NERVES_HEART_VERSION))
NERVES_HEART_LICENSE = MIT
NERVES_HEART_LICENSE_FILES = LICENSE
NERVES_HEART_DEPENDENCIES = erlang

define NERVES_HEART_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NERVES_HEART_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/heart $(TARGET_DIR)/usr/lib/erlang/erts-*/bin/heart
endef

$(eval $(generic-package))
