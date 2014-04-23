#############################################################
#
# mmccopy
#
#############################################################

MMCCOPY_VERSION = v1.1.0
MMCCOPY_SITE = $(call github,fhunleth,mmccopy,$(MMCCOPY_VERSION))
MMCCOPY_LICENSE = MIT
MMCCOPY_LICENSE_FILES = COPYING
MMCCOPY_AUTORECONF = YES

define HOST_MMCCOPY_INSTALL_SUDO_HELPER
	$(INSTALL) -D -m 755 ../package/mmccopy/sudo-mmccopy $(HOST_DIR)/usr/bin/sudo-mmccopy
endef

HOST_MMCCOPY_POST_INSTALL_HOOKS += HOST_MMCCOPY_INSTALL_SUDO_HELPER

$(eval $(autotools-package))
$(eval $(host-autotools-package))
