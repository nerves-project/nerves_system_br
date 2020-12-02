################################################################################
#
# rpi-distro-firmware-nonfree
#
################################################################################

RPI_DISTRO_FIRMWARE_NONFREE_VERSION = b66ab26cebff689d0d3257f56912b9bb03c20567 # 1:20190114-1+rpt10 release
RPI_DISTRO_FIRMWARE_NONFREE_SITE = $(call github,RPi-Distro,firmware-nonfree,$(RPI_DISTRO_FIRMWARE_NONFREE_VERSION))
RPI_DISTRO_FIRMWARE_NONFREE_LICENSE_FILES = LICENCE.broadcom_bcm43xx LICENCE.cypress

define RPI_DISTRO_FIRMWARE_NONFREE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/firmware/brcm
	for f in  $(@D)/brcm/*; do \
		$(INSTALL) -D -m 0644 "$${f}" "$(TARGET_DIR)/lib/firmware/brcm/$${f##*/}" || exit 1; \
	done
endef

$(eval $(generic-package))
