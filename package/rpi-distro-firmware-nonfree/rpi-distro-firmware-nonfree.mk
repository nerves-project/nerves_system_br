################################################################################
#
# rpi-distro-firmware-nonfree
#
################################################################################

RPI_DISTRO_FIRMWARE_NONFREE_VERSION = 4db8c5d80daf2220d7824cfa6052f0bb108612ea # 20210315-3+rpt5 + RPI Zero 2W update
RPI_DISTRO_FIRMWARE_NONFREE_SITE = $(call github,RPi-Distro,firmware-nonfree,$(RPI_DISTRO_FIRMWARE_NONFREE_VERSION))
RPI_DISTRO_FIRMWARE_NONFREE_LICENSE_FILES = debian/config/brcm80211/copyright

# Notes
# 1. The brcmfmac43436f-sdio symlinks come from the firmware-brcm80211.postinst script
# 2. The cyfmac43455-sdio-minimal firmware isn't used. It's for increasing the number
#    of supported clients in AP mode by removing functionality.
define RPI_DISTRO_FIRMWARE_NONFREE_INSTALL_TARGET_CMDS
	mkdir -p "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/brcm" "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/cypress" "$(TARGET_DIR)/lib/firmware"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/cyfmac43455-sdio-minimal.bin"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/README.txt"
	ln -sf brcmfmac43436f-sdio.bin "$(TARGET_DIR)/lib/firmware/brcm/brcmfmac43436-sdio.bin"
	ln -sf brcmfmac43436f-sdio.txt "$(TARGET_DIR)/lib/firmware/brcm/brcmfmac43436-sdio.txt"
endef

$(eval $(generic-package))
