#############################################################
#
# bborg-overlays
#
#############################################################

BBORG_OVERLAYS_VERSION = 12aa4c04d69f5bbfb1bb7e4ad1aef9cd3d269c44
BBORG_OVERLAYS_SITE = $(call github,beagleboard,bb.org-overlays,$(BBORG_OVERLAYS_VERSION))
BBORG_OVERLAYS_LICENSE = GPLv2
BBORG_OVERLAYS_DEPENDENCIES = host-dtc

# See https://github.com/beagleboard/bb.org-overlays/blob/master/Makefile
# for preprocessing logic before invoking dtc
define BBORG_OVERLAYS_BUILD_CMDS
	for filename in $(@D)/src/arm/*.dts; do \
	    $(CPP) -I$(@D)/include -I$(@D)/src/arm -nostdinc -undef -D__DTS__ -x assembler-with-cpp $$filename | \
	      $(HOST_DIR)/usr/bin/dtc -Wno-unit_address_vs_reg -@ -I dts -O dtb -b 0 -o $${filename%.dts}.dtbo || exit 1; \
	done
endef

define BBORG_OVERLAYS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(BR2_PACKAGE_BBORG_INSTALL_PATH)
	cp $(@D)/src/arm/*.dtbo $(TARGET_DIR)$(BR2_PACKAGE_BBORG_INSTALL_PATH)
endef

$(eval $(generic-package))
