#############################################################
#
# nerves-config
#
#############################################################

# Remember to bump the version when anything changes in this
# directory.
NERVES_CONFIG_SOURCE =
NERVES_CONFIG_VERSION = 0.7

NERVES_CONFIG_DEPENDENCIES = erlinit erlang host-fwup fwup ncurses nerves_heart uboot-tools boardid openssl rng-tools

# This is tricky. We want the squashfs created by Buildroot to have everything
# except for the OTP release. The squashfs tools can only append to
# filesystems, so we'll want to append OTP releases frequently. If it were
# possible to modify a squashfs after the fact, then we could skip this part,
# but this isn't possible on non-Linux platforms (i.e. no fakeroot).
ROOTFS_SQUASHFS_ARGS += -e srv

define NERVES_CONFIG_INSTALL_TARGET_CMDS
	cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(HOST_DIR)/opt/ext-toolchain/bin/echo-gcc-args
	cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(HOST_DIR)/opt/ext-toolchain/bin/echo-gcc-args$(TOOLCHAIN_EXTERNAL_SUFFIX)
	ln -sf toolchain-wrapper $(HOST_DIR)/bin/echo-gcc-args
	$(HOST_DIR)/bin/echo-gcc-args > $(BINARIES_DIR)/buildroot-gcc-args
endef

$(eval $(generic-package))
