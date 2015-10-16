#############################################################
#
# nerves-config
#
#############################################################

NERVES_CONFIG_SOURCE =
NERVES_CONFIG_VERSION = 0.2

NERVES_CONFIG_DEPENDENCIES = erlinit erlang host-erlang-relx

NERVES_CONFIG_PACKAGE_DIR = $(TOPDIR)/../package/nerves-config
NERVES_CONFIG_ERLANG_RELEASE_DIR = $(TARGET_DIR)/srv/erlang

ifeq ($(BR2_PACKAGE_NERVES_CONFIG_ERLANG),y)
NERVES_CONFIG_EXTRA_APPS += stdlib
endif
ifeq ($(BR2_PACKAGE_NERVES_CONFIG_ELIXIR),y)
NERVES_CONFIG_DEPENDENCIES += host-elixir
NERVES_CONFIG_RELX_LIBDIRS = -l $(HOST_DIR)/usr/lib/elixir/lib/elixir -l $(HOST_DIR)/usr/lib/elixir/lib/iex
NERVES_CONFIG_EXTRA_APPS += iex
endif
ifeq ($(BR2_PACKAGE_NERVES_CONFIG_LFE),y)
NERVES_CONFIG_DEPENDENCIES += lfe host-lfe
NERVES_CONFIG_EXTRA_APPS += lfe
endif
NERVES_CONFIG_ALL_APPS = $(subst $(space),$(comma),$(call qstrip,$(BR2_PACKAGE_NERVES_CONFIG_APPS) $(NERVES_CONFIG_EXTRA_APPS)))

define NERVES_CONFIG_BUILD_CMDS
	# Create the relx configuration file
	m4 -DAPPS="$(NERVES_CONFIG_ALL_APPS)" \
	   -DIS_ELIXIR=$(BR2_PACKAGE_NERVES_CONFIG_ELIXIR) \
	    $(NERVES_CONFIG_PACKAGE_DIR)/relx.config.m4 > $(@D)/relx.config

	# Create the vm.args file for starting the Erlang runtime
	m4 -DIS_ELIXIR=$(BR2_PACKAGE_NERVES_CONFIG_ELIXIR) \
	    -DIS_LFE=$(BR2_PACKAGE_NERVES_CONFIG_LFE) \
	    -DDISTRIBUTION=$(BR2_PACKAGE_NERVES_CONFIG_DISTRIBUTION) \
	    -DSNAME=$(BR2_PACKAGE_NERVES_CONFIG_SNAME) \
	    -DCOOKIE=$(BR2_PACKAGE_NERVES_CONFIG_COOKIE) \
	    $(NERVES_CONFIG_PACKAGE_DIR)/vm.args.m4 > $(@D)/vm.args

	# Run relx to create a sample release. Real projects will have
	# their own relx.config scripts and be in a separate repo, but
	# this release is a good one for playing around with Nerves.
	NERVES_SDK_SYSROOT=$(HOST_DIR) $(RELX) $(NERVES_CONFIG_RELX_LIBDIRS) --vm_args $(@D)/vm.args -c $(@D)/relx.config
endef

define NERVES_CONFIG_INSTALL_TARGET_CMDS
	# Install an erlinit.config script based on the user's configuration
	m4 -DVERBOSE_INIT=$(BR2_PACKAGE_NERVES_CONFIG_VERBOSE_INIT) \
	    -DHANG_ON_EXIT=$(BR2_PACKAGE_NERVES_CONFIG_HANG_ON_EXIT) \
	    -DPORT=$(BR2_PACKAGE_NERVES_CONFIG_PORT) \
	    -DRELEASE_PATHS=$(BR2_PACKAGE_NERVES_CONFIG_RELEASE_PATHS) \
	    -DEXTRA_MOUNTS=$(BR2_PACKAGE_NERVES_CONFIG_EXTRA_MOUNTS) \
	    -DUNIQUEID_PROG=$(BR2_PACKAGE_NERVES_CONFIG_UNIQUEID_PROG) \
	    -DHOSTNAME_PATTERN=$(BR2_PACKAGE_NERVES_CONFIG_HOSTNAME_PATTERN) \
	    $(NERVES_CONFIG_PACKAGE_DIR)/erlinit.config.m4 > $(TARGET_DIR)/etc/erlinit.config

	# Copy the release that starts the shell over to the target
	rm -fr $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
	mkdir -p $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
	cp -r $(@D)/_rel/*/* $(NERVES_CONFIG_ERLANG_RELEASE_DIR)
endef

# This is tricky. We want the squashfs created by Buildroot to have everything
# except for the OTP release. The squashfs tools can only append to filesystems,
# so we'll want to append OTP releases frequently. If it were possible to modify
# a squashfs after the fact, then we could skip this part, but this isn't possible
# on non-Linux platforms (i.e. no fakeroot).
ROOTFS_SQUASHFS_ARGS += -e srv

$(eval $(generic-package))
