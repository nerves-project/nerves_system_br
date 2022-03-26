#############################################################
#
# nerves_heart
#
#############################################################

NERVES_HEART_VERSION = v1.0.0
NERVES_HEART_SITE = $(call github,nerves-project,nerves_heart,$(NERVES_HEART_VERSION))
NERVES_HEART_LICENSE = MIT
NERVES_HEART_LICENSE_FILES = LICENSE
NERVES_HEART_DEPENDENCIES = erlang
NERVES_HEART_INSTALL_STAGING = YES

define NERVES_HEART_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NERVES_HEART_INSTALL_TARGET_CMDS
	ERTS_BIN=$(ls $(TARGET_DIR)/usr/lib/erlang/erts-*/bin);\
	if -e "$(ERTS_BIN)"; then $(INSTALL) -D -m 755 $(@D)/heart $(ERTS_BIN)/heart; fi
endef

define NERVES_HEART_INSTALL_STAGING_CMDS
	ERTS_BIN=$(ls $(STAGING_DIR)/usr/lib/erlang/erts-*/bin);\
	if -e "$(ERTS_BIN)"; then $(INSTALL) -D -m 755 $(@D)/heart $(ERTS_BIN)/heart; fi
endef

$(eval $(generic-package))
