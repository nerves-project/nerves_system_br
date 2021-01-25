#############################################################
#
# nerves_initramfs
#
#############################################################

NERVES_INITRAMFS_VERSION = v0.5.0
NERVES_INITRAMFS_SITE = https://github.com/nerves-project/nerves_initramfs/releases/download/$(NERVES_INITRAMFS_VERSION)
NERVES_INITRAMFS_LICENSE = Apache-2.0
NERVES_INITRAMFS_INSTALL_IMAGES = YES

define NERVES_INITRAMFS_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 644 $(@D)/nerves_initramfs_$(BR2_ARCH).xz $(BINARIES_DIR)
	$(INSTALL) -D -m 644 $(@D)/nerves_initramfs_$(BR2_ARCH).gz $(BINARIES_DIR)
	$(INSTALL) -D -m 755 $(@D)/file-to-cpio.sh $(BINARIES_DIR)
endef

$(eval $(generic-package))
