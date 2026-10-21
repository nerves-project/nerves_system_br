#############################################################
#
# nerves2-config
#
#############################################################

# Remember to bump the version when anything changes in this
# directory.
NERVES2_CONFIG_SOURCE =
NERVES2_CONFIG_VERSION = 0.7

NERVES2_CONFIG_DEPENDENCIES = erlinit erlang host-fwup fwup ncurses nerves_heart uboot-tools boardid openssl

define NERVES2_CONFIG_INSTALL_TARGET_CMDS
	cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(HOST_DIR)/opt/ext-toolchain/bin/echo-gcc-args
	cp -f $(BR2_EXTERNAL)/package/nerves-config/echo-gcc-args $(HOST_DIR)/opt/ext-toolchain/bin/echo-gcc-args$(TOOLCHAIN_EXTERNAL_SUFFIX)
	ln -sf toolchain-wrapper $(HOST_DIR)/bin/echo-gcc-args
	$(HOST_DIR)/bin/echo-gcc-args > $(BINARIES_DIR)/buildroot-gcc-args
endef

$(eval $(generic-package))
