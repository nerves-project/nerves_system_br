################################################################################
#
# rpi-distro-firmware-nonfree
#
################################################################################

RPI_DISTRO_FIRMWARE_NONFREE_VERSION = 9794282eb9f4a2de1f23b41a738926740e975d83 # 1:20250410-2+rpt1
RPI_DISTRO_FIRMWARE_NONFREE_SITE = $(call github,RPi-Distro,firmware-nonfree,$(RPI_DISTRO_FIRMWARE_NONFREE_VERSION))
RPI_DISTRO_FIRMWARE_NONFREE_LICENSE_FILES = debian/copyright

# Notes
# 1. The cyfmac43455-sdio.bin symlink comes from the firmware-brcm80211.postinst script
# 2. The cyfmac43455-sdio-minimal firmware isn't used. It's for increasing the number
#    of supported clients in AP mode by removing functionality.
# 3. The rpi-brcmfmac.conf file has parameter settings that reportedly fix a
#    stability issue seen upstream. Busybox modprobe uses /etc/modprobe.d and
#    libkmod uses /lib/modprobe.d, so install in both.
define RPI_DISTRO_FIRMWARE_NONFREE_INSTALL_TARGET_CMDS
	mkdir -p "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/brcm" "$(TARGET_DIR)/lib/firmware"
	cp -dpfr "$(@D)/debian/config/brcm80211/cypress" "$(TARGET_DIR)/lib/firmware"
	$(INSTALL) -D -m 0644 "$(@D)/debian/rpi-brcmfmac.conf" "$(TARGET_DIR)/lib/modprobe.d/rpi-brcmfmac.conf"
	mkdir -p "$(TARGET_DIR)/etc/modprobe.d"
	ln -sf ../../lib/modprobe.d/rpi-brcmfmac.conf "$(TARGET_DIR)/etc/modprobe.d/rpi-brcmfmac.conf"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/cyfmac43455-sdio-minimal.bin"
	rm -f "$(TARGET_DIR)/lib/firmware/cypress/README.txt"
	ln -sf cyfmac43455-sdio-standard.bin "$(TARGET_DIR)/lib/firmware/cypress/cyfmac43455-sdio.bin"
endef

$(eval $(generic-package))
