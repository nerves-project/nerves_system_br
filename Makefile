TOPDIR := $(shell pwd)

NERVES_BR_VERSION = ac7f60d87266c30753cb45b820dc48ec834941c6
NERVES_BR_URL = git://git.buildroot.net/buildroot

# Optional place to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
# Try the default directory first and if that doesn't work, use
# a directory in the Nerves folder..
OLD_DEFAULT_DL_DIR = $(HOME)/dl
DEFAULT_DL_DIR = $(HOME)/.nerves-cache
IN_TREE_DL_DIR = $(TOPDIR)/dl
NERVES_BR_DL_DIR ?= $(if $(wildcard $(DEFAULT_DL_DIR)), $(DEFAULT_DL_DIR), $(if $(wildcard $(OLD_DEFAULT_DL_DIR)), $(OLD_DEFAULT_DL_DIR), $(IN_TREE_DL_DIR)))

MAKE_BR = make -C buildroot BR2_EXTERNAL=$(TOPDIR)

all: br-make

.buildroot-downloaded:
	@echo "Caching downloaded files in $(NERVES_BR_DL_DIR)."
	@mkdir -p $(NERVES_BR_DL_DIR)
	@echo "Downloading Buildroot..."
	@scripts/clone_or_dnload.sh $(NERVES_BR_URL) $(NERVES_BR_VERSION) $(NERVES_BR_DL_DIR)

	@touch .buildroot-downloaded

# Apply our patches that either haven't been submitted or merged upstream yet
.buildroot-patched: .buildroot-downloaded
	buildroot/support/scripts/apply-patches.sh buildroot patches || exit 1
	touch .buildroot-patched

	# If there's a user dl directory, symlink it to avoid the big download
	if [ -d $(NERVES_BR_DL_DIR) -a ! -e buildroot/dl ]; then \
		ln -s $(NERVES_BR_DL_DIR) buildroot/dl; \
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

menuconfig: buildroot/.config
	$(MAKE_BR) menuconfig
	$(MAKE_BR) savedefconfig
	@echo
	@echo "!!! Important !!!"
	@echo "1. Remember to copy buildroot/defconfig to the configs directory to save"
	@echo "   the new settings."
	@echo "2. Buildroot normally requires you to run 'make clean' and 'make' after"
	@echo "   changing the configuration. You don't technically have to do this,"
	@echo "   but if you're new to Buildroot, it's best to be safe."

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

clean:
	$(MAKE_BR) clean

distclean: realclean
realclean:
	-rm -fr buildroot .buildroot-patched .buildroot-downloaded

help:
	@echo 'Nerves SDK Help'
	@echo '---------------'
	@echo
	@echo 'Cleaning:'
	@echo '  clean				- clean Buildroot directory and config'
	@echo '  realclean			- Clean up everything'
	@echo
	@echo 'Build:'
	@echo '  all				- build everything [default target]'
	@echo
	@echo 'Configuration:'
	@echo '  menuconfig			- run buildroots menuconfig'
	@echo '  linux-menuconfig		- run menuconfig on the Linux kernel'
	@echo
	@echo 'Nerves built-in configs:'
	@$(foreach b, $(sort $(notdir $(wildcard configs/*_defconfig))), \
	  printf "  %-29s - Build for %s\\n" $(b) $(b:_defconfig=);)
