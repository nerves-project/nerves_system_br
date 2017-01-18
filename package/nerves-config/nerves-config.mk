#############################################################
#
# nerves-config
#
#############################################################

# Remember to bump the version when anything changes in this
# directory.
NERVES_CONFIG_SOURCE =
NERVES_CONFIG_VERSION = 0.5

NERVES_CONFIG_DEPENDENCIES = erlinit erlang host-erlang-relx host-fwup openssl

NERVES_CONFIG_PACKAGE_DIR = $(BR2_EXTERNAL_NERVES_PATH)/package/nerves-config
NERVES_CONFIG_ERLANG_RELEASE_DIR = $(TARGET_DIR)/srv/erlang

NERVES_CONFIG_EXTRA_APPS += stdlib
NERVES_CONFIG_ALL_APPS = $(subst $(space),$(comma),$(call qstrip,$(BR2_PACKAGE_NERVES_CONFIG_APPS) $(NERVES_CONFIG_EXTRA_APPS)))

define NERVES_CONFIG_BUILD_CMDS
	# Create the relx configuration file
	m4 -DAPPS="$(NERVES_CONFIG_ALL_APPS)" \
	    $(NERVES_CONFIG_PACKAGE_DIR)/relx.config.m4 > $(@D)/relx.config

	# Create the vm.args file for starting the Erlang runtime
	m4 -DDISTRIBUTION=$(BR2_PACKAGE_NERVES_CONFIG_DISTRIBUTION) \
	    -DSNAME=$(BR2_PACKAGE_NERVES_CONFIG_SNAME) \
	    -DCOOKIE=$(BR2_PACKAGE_NERVES_CONFIG_COOKIE) \
	    $(NERVES_CONFIG_PACKAGE_DIR)/vm.args.m4 > $(@D)/vm.args

	# Run relx to create a sample release. Real projects will have
	# their own relx.config scripts and be in a separate repo, but
	# this release is a good one for playing around with Nerves.
	NERVES_SDK_SYSROOT=$(HOST_DIR) $(RELX) $(NERVES_CONFIG_RELX_LIBDIRS) --vm_args $(@D)/vm.args -c $(@D)/relx.config
endef

ifeq ($(BR2_PACKAGE_NERVES_CONFIG_SPECIFY_ERLINIT_CONF),y)
define NERVES_CONFIG_INSTALL_ERLINIT
	cp $(BR2_PACKAGE_NERVES_CONFIG_ERLINIT_CONF_PATH) $(TARGET_DIR)/etc/erlinit.config
endef
endif

define NERVES_CONFIG_INSTALL_RELEASE
	# Copy the release that starts the shell over to the target
	rm -fr $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
	mkdir -p $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
	cp -r $(@D)/_rel/*/* $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
endef

define NERVES_CONFIG_INSTALL_TARGET_CMDS
	$(NERVES_CONFIG_INSTALL_RELEASE)
	$(NERVES_CONFIG_INSTALL_ERLINIT)
endef

# This is tricky. We want the squashfs created by Buildroot to have everything
# except for the OTP release. The squashfs tools can only append to filesystems,
# so we'll want to append OTP releases frequently. If it were possible to modify
# a squashfs after the fact, then we could skip this part, but this isn't possible
# on non-Linux platforms (i.e. no fakeroot).
ROOTFS_SQUASHFS_ARGS += -e srv

$(eval $(generic-package))
