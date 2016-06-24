#############################################################
#
# bborg-overlays
#
#############################################################

BBORG_OVERLAYS_VERSION = 25cf610eda61a323048bd46a458fe8bf6d1c6af5
BBORG_OVERLAYS_SITE = $(call github,beagleboard,bb.org-overlays,$(BBORG_OVERLAYS_VERSION))
BBORG_OVERLAYS_LICENSE = GPLv2
BBORG_OVERLAYS_DEPENDENCIES = host-dtc

# See https://github.com/beagleboard/bb.org-overlays/blob/master/Makefile
# for preprocessing logic before invoking dtc
define BBORG_OVERLAYS_BUILD_CMDS
	for filename in $(@D)/src/arm/*.dts; do \
	    $(CPP) -I$(@D)/include -I$(@D)/src/arm -nostdinc -undef -D__DTS__ -x assembler-with-cpp $$filename | \
	      $(HOST_DIR)/usr/bin/dtc -@ -I dts -O dtb -b 0 -o $${filename%.dts}.dtbo || exit 1; \
	done
endef

define BBORG_OVERLAYS_INSTALL_TARGET_CMDS
	cp $(@D)/src/arm/*.dtbo $(TARGET_DIR)/lib/firmware
endef

$(eval $(generic-package))
