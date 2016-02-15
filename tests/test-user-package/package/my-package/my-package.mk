################################################################################
#
# my-package
#
################################################################################

# See the Buildroot documentation for how to add packages. The Buildroot
# repository has a zillion examples as well.

MY_PACKAGE_SOURCE =
MY_PACKAGE_VERSION = 0.1
MY_PACKAGE_LICENSE = GPLv2

define MY_PACKAGE_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		$(NERVES_DEFCONFIG_DIR)/package/my-package/main.c \
		-o $(@D)/my-package
endef

define MY_PACKAGE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/my-package $(TARGET_DIR)/usr/bin/my-package
endef

$(eval $(generic-package))
