################################################################################
#
# rpi-distro-firmware-nonfree
#
################################################################################

RPI_DISTRO_FIRMWARE_NONFREE_VERSION = 99d5c588e95ec9c9b86d7e88d3cf85b4f729d2bc # 20210315-3+rpt4 release
RPI_DISTRO_FIRMWARE_NONFREE_SITE = $(call github,RPi-Distro,firmware-nonfree,$(RPI_DISTRO_FIRMWARE_NONFREE_VERSION))
RPI_DISTRO_FIRMWARE_NONFREE_LICENSE_FILES = debian/config/brcm80211/LICENSE

define RPI_DISTRO_FIRMWARE_NONFREE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	for f in  $(@D)/debian/config/brcm80211/brcm/*; do \
		$(INSTALL) -D -m 0644 "$${f}" "$(TARGET_DIR)/lib/firmware/brcm/$${f##*/}" || exit 1; \
	done
endef

$(eval $(generic-package))
