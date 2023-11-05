#############################################################
#
# erlinit
#
#############################################################

ERLINIT_VERSION = v1.13.0
ERLINIT_SITE = $(call github,nerves-project,erlinit,$(ERLINIT_VERSION))
ERLINIT_LICENSE = MIT
ERLINIT_LICENSE_FILES = LICENSE

# Make sure erlinit gets installed after busybox init so that
# erlinit's /sbin/init is the one that is used
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
ERLINIT_DEPENDENCIES += busybox
endif

define ERLINIT_BUILD_CMDS
	$(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define ERLINIT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/erlinit $(TARGET_DIR)/sbin/init
endef

$(eval $(generic-package))
