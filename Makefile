
NERVES_BR_VERSION = 3749143418a2a735ceaed63667a8b3ef66bba9e5
NERVES_BR_URL = git://git.buildroot.net/buildroot
NERVES_BR_CONFIG ?= nerves_bbb_defconfig

# Optional place to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
NERVES_BR_DL_DIR ?= ~/dl

TOPDIR := $(shell pwd)
MAKE_BR = make -C buildroot BR2_EXTERNAL=$(TOPDIR)

all: br-make

.buildroot-downloaded:
	git clone $(NERVES_BR_URL)
	cd buildroot && git checkout -b nerves $(NERVES_BR_VERSION)

	touch .buildroot-downloaded

.buildroot-patched: .buildroot-downloaded
	# Apply patches not yet in upstream buildroot
	cd buildroot; \
	for p in `ls ../patches/*.patch` ; do \
		echo Applying $$p; \
		patch -p1 < $$p; \
	done
	touch .buildroot-patched

	# If there's a user dl directory, symlink it to avoid
	# the big download
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
	$(MAKE_BR) $(NERVES_BR_CONFIG)

br-make: buildroot/.config
	$(MAKE_BR) 
	@echo SDK is ready to use. Demo image is in buildroot/output/images.

menuconfig: buildroot/.config
	$(MAKE_BR) menuconfig
	$(MAKE_BR) savedefconfig
	@echo !!! Remember to copy buildroot/defconfig to the configs directory to save the new settings.

linux-menuconfig: buildroot/.config
	$(MAKE_BR) linux-menuconfig
	$(MAKE_BR) linux-savedefconfig
	@echo !!! Remember to copy buildroot/output/build/linux-x.y.z/defconfig to boards/.../linux-x.y.config

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
	@echo
	@echo 'Nerves default configuration: $(NERVES_BR_CONFIG)'
