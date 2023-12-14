################################################################################
#
# rpi-distro-bluez-firmware
#
################################################################################

RPI_DISTRO_BLUEZ_FIRMWARE_VERSION = d9d4741caba7314d6500f588b1eaa5ab387a4ff5 # 1.2-9+rpt2
RPI_DISTRO_BLUEZ_FIRMWARE_SITE = $(call github,RPi-Distro,bluez-firmware,$(RPI_DISTRO_BLUEZ_FIRMWARE_VERSION))
RPI_DISTRO_BLUEZ_FIRMWARE_LICENSE_FILES = debian/copyright

# Notes
# 1. The symlinks come from debian/bluez-firmware.links
define RPI_DISTRO_BLUEZ_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p "$(TARGET_DIR)/lib/firmware/brcm"
	mkdir -p "$(TARGET_DIR)/lib/firmware/synaptics"
	cp -dpf "$(@D)/debian/firmware/broadcom/BCM43430A1.hcd" "$(TARGET_DIR)/lib/firmware/brcm"
	cp -dpf "$(@D)/debian/firmware/broadcom/BCM43430B0.hcd" "$(TARGET_DIR)/lib/firmware/brcm"
	cp -dpf "$(@D)/debian/firmware/broadcom/BCM4345C0.hcd" "$(TARGET_DIR)/lib/firmware/brcm"
	cp -dpf "$(@D)/debian/firmware/broadcom/BCM4345C5.hcd" "$(TARGET_DIR)/lib/firmware/brcm"
	cp -dpfr "$(@D)/debian/firmware/synaptics" "$(TARGET_DIR)/lib/firmware"
	ln -sf /lib/firmware/brcm/BCM43430A1.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM43430A1.raspberrypi,3-model-b.hcd"
	ln -sf /lib/firmware/brcm/BCM43430A1.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM43430A1.raspberrypi,model-zero-w.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C0.raspberrypi,3-model-a-plus.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C0.raspberrypi,3-model-b-plus.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C0.raspberrypi,4-compute-module.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C0.raspberrypi,4-model-b.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C0.raspberrypi,5-model-b.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C5.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C5.raspberrypi,4-compute-module.hcd"
	ln -sf /lib/firmware/brcm/BCM4345C5.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM4345C5.raspberrypi,400.hcd"
	ln -sf /lib/firmware/synaptics/SYN43430A1.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM43430A1.raspberrypi,model-zero-2-w.hcd"
	ln -sf /lib/firmware/synaptics/SYN43430B0.hcd "$(TARGET_DIR)/lib/firmware/brcm/BCM43430B0.raspberrypi,model-zero-2-w.hcd"
endef

$(eval $(generic-package))
