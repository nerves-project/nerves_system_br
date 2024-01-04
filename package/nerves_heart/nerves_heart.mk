#############################################################
#
# nerves_heart
#
#############################################################

NERVES_HEART_VERSION = v2.3.0
NERVES_HEART_SITE = $(call github,nerves-project,nerves_heart,$(NERVES_HEART_VERSION))
NERVES_HEART_LICENSE = Apache-2.0
NERVES_HEART_LICENSE_FILES = LICENSES/Apache-2.0.txt
NERVES_HEART_DEPENDENCIES = erlang
NERVES_HEART_INSTALL_STAGING = YES
NERVES_HEART_INSTALL_TARGET = NO

define NERVES_HEART_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NERVES_HEART_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 $(@D)/heart "$(STAGING_DIR)/usr/lib/erlang/erts-$(ERLANG_ERTS_VSN)/bin/heart"
endef

$(eval $(generic-package))
