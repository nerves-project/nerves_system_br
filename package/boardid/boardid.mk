#############################################################
#
# boardid
#
#############################################################

BOARDID_VERSION = v1.14.0
BOARDID_SITE = $(call github,nerves-project,boardid,$(BOARDID_VERSION))
BOARDID_LICENSE = Apache-2.0
BOARDID_LICENSE_FILES = LICENSES/Apache-2.0.txt

define BOARDID_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define BOARDID_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/boardid $(TARGET_DIR)/usr/bin/boardid
endef

$(eval $(generic-package))
