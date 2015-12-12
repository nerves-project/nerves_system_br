TOPDIR := $(shell pwd)

NERVES_BR_VERSION = 2015.11.1
NERVES_BR_URL = git://git.buildroot.net/buildroot
NERVES_DEFCONFIG = $(shell grep BR2_DEFCONFIG= buildroot/.config | sed -e 's/.*"\(.*\)"/\1/')

# Location to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
#
# NOTE: If you are a heavy Buildroot user and have an alternative location,
#       override this environment variable or symlink this directory.
NERVES_BR_DL_DIR ?= $(HOME)/.nerves/cache/buildroot

MAKE_BR = make -C buildroot BR2_EXTERNAL=$(TOPDIR)

all: br-make

.buildroot-downloaded:
	@echo "Caching downloaded files in $(NERVES_BR_DL_DIR)."
	@[ -e $(NERVES_BR_DL_DIR) ] || mkdir -p $(NERVES_BR_DL_DIR)
	@echo "Downloading Buildroot..."
	@scripts/clone_or_dnload.sh $(NERVES_BR_URL) $(NERVES_BR_VERSION) $(NERVES_BR_DL_DIR)

	@touch .buildroot-downloaded

# Apply our patches that either haven't been submitted or merged upstream yet
.buildroot-patched: .buildroot-downloaded
	buildroot/support/scripts/apply-patches.sh buildroot patches || exit 1
	touch .buildroot-patched

	# Symlink Buildroot's dl directory so that it can be cached between builds
	if [ -d $(NERVES_BR_DL_DIR) -a ! -e buildroot/dl ]; then \
		ln -sf $(NERVES_BR_DL_DIR) buildroot/dl; \
	fi

reset-buildroot: .buildroot-downloaded
	# Reset buildroot to a pristine condition so that the
	# patches can be applied again.
	cd buildroot && git clean -fdx && git reset --hard
	rm -f .buildroot-patched

update-patches: reset-buildroot .buildroot-patched

%_defconfig: $(TOPDIR)/configs/%_defconfig .buildroot-patched
	$(MAKE_BR) $@

buildroot/.config: .buildroot-patched
	@echo
	@echo 'ERROR: Please choose a Nerves SDK configuration and run'
	@echo '       "make <platform>_defconfig"'
	@echo
	@echo 'Run "make help" or look in the configs directory for options'
	@false

br-make: buildroot/.config
	$(MAKE_BR)
	@echo
	@echo SDK is ready to use. Demo images are in buildroot/output/images.

system: br-make
	scripts/mksystem.sh

# Replace everything on the SDCard with new bits
burn-complete:
	sudo buildroot/output/host/usr/bin/fwup -a -i $(firstword $(wildcard buildroot/output/images/*.fw)) -t complete

# Upgrade the image on the SDCard (app data won't be removed)
# This is usually the fastest way to update an SDCard that's already
# been programmed. It won't update bootloaders, so if something is
# really messed up, burn-complete may be better.
burn-upgrade:
	sudo buildroot/output/host/usr/bin/fwup -a -i $(firstword $(wildcard buildroot/output/images/*.fw)) -t upgrade
	sudo buildroot/output/host/usr/bin/fwup -y -a -i /tmp/finalize.fw -t on-reboot
	sudo rm /tmp/finalize.fw

menuconfig: buildroot/.config
	$(MAKE_BR) menuconfig
	@echo
	@echo "!!! Important !!!"
	@echo "1. $(subst $(shell pwd)/,,$(NERVES_DEFCONFIG)) has NOT been updated."
	@echo "   Changes will be lost if you run 'make distclean'."
	@echo "   Run 'make savedefconfig' to update."
	@echo "2. Buildroot normally requires you to run 'make clean' and 'make' after"
	@echo "   changing the configuration. You don't technically have to do this,"
	@echo "   but if you're new to Buildroot, it's best to be safe."

savedefconfig: buildroot/.config
	$(MAKE_BR) savedefconfig

linux-menuconfig: buildroot/.config
	$(MAKE_BR) linux-menuconfig
	$(MAKE_BR) linux-savedefconfig
	@echo
	@echo Going to update your boards/.../linux-x.y.config. If you do not have one,
	@echo you will get an error shortly. You will then have to make one and update,
	@echo your buildroot configuration to use it.
	$(MAKE_BR) linux-update-defconfig

busybox-menuconfig: buildroot/.config
	$(MAKE_BR) busybox-menuconfig
	@echo
	@echo Going to update your boards/.../busybox-x.y.config. If you do not have one,
	@echo you will get an error shortly. You will then have to make one and update
	@echo your buildroot configuration to use it.
	$(MAKE_BR) busybox-update-config

clean: realclean
distclean: realclean
realclean:
	-[ ! -d buildroot ] || chmod -R u+w buildroot
	-rm -fr buildroot .buildroot-patched .buildroot-downloaded

help:
	@echo 'Nerves SDK Help'
	@echo '---------------'
	@echo
	@echo 'Targets:'
	@echo '  all                           - Build the current configuration'
	@echo '  burn-complete                 - Burn the most recent build to an SDCard (requires sudo)'
	@echo '  burn-upgrade                  - Upgrade the contents an SDCard (requires sudo)'
	@echo '  system                        - Build a system image for use with bake'
	@echo '  clean                         - Clean everything - run make xyz_defconfig after this'
	@echo
	@echo 'Configuration:'
	@echo "  menuconfig                    - Run Buildroot's menuconfig"
	@echo '  linux-menuconfig              - Run menuconfig on the Linux kernel'
	@echo
	@echo 'Nerves built-in configs:'
	@$(foreach b, $(sort $(notdir $(wildcard configs/*_defconfig))), \
	  printf "  %-29s - Build for %s\\n" $(b) $(b:_defconfig=);)

.PHONY: all burn-complete burn-upgrade system clean menuconfig linux-menuconfig
