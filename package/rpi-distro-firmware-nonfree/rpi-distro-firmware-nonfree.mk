################################################################################
#
# rpi-distro-firmware-nonfree
#
################################################################################

RPI_DISTRO_FIRMWARE_NONFREE_VERSION = c9d3ae6584ab79d19a4f94ccf701e888f9f87a53 # 1:20240709-2~bpo12+1+rpt3
RPI_DISTRO_FIRMWARE_NONFREE_SITE = $(call github,RPi-Distro,firmware-nonfree,$(RPI_DISTRO_FIRMWARE_NONFREE_VERSION))
RPI_DISTRO_FIRMWARE_NONFREE_LICENSE_FILES = debian/copyright

# Notes
# 1. The cyfmac43455-sdio.bin symlink comes from the firmware-brcm80211.postinst script
# 2. The cyfmac43455-sdio-minimal firmware isn't used. It's for increasing the number
#    of supported clients in AP mode by removing functionality.
define RPI_DISTRO_FIRMWARE_NONFREE_INSTALL_TARGET_CMDS
	mkdir -p "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/brcm" "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/cypress" "$(TARGET_DIR)/lib/firmware"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/cyfmac43455-sdio-minimal.bin"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/README.txt"
	ln -sf cyfmac43455-sdio-standard.bin "$(TARGET_DIR)/lib/firmware/cypress/cyfmac43455-sdio.bin"
endef

$(eval $(generic-package))
