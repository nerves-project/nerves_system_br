# Currently, make must be called from the NERVES_SYSTEM directory
# or "make -C <dir>" will point it there, so the following is
# guaranteed to work.
NERVES_SYSTEM := $(shell pwd)

# Unreleased version of BR required for Galileo support
NERVES_BR_VERSION = 2016.02-rc1
NERVES_BR_URL = git://git.buildroot.net/buildroot
NERVES_DEFCONFIG = $(shell grep BR2_DEFCONFIG= buildroot/.config | sed -e 's/.*"\(.*\)"/\1/')

# Location to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
#
# NOTE: If you are a heavy Buildroot user and have an alternative location,
#       override this environment variable or symlink this directory.
NERVES_BR_DL_DIR ?= $(HOME)/.nerves/cache/buildroot

# Check the OS and architecture to give more helpful errors
ifneq ($(shell uname -s),Linux)
$(error Nerves system images can only be built using Linux)
endif
ifneq ($(shell uname -m),x86_64)
$(error 64-bit Linux required for supported cross-compilers)
endif

MAKE_BR = make -C buildroot BR2_EXTERNAL=$(NERVES_SYSTEM)
ifneq ($(O),)
    MAKE_BR += O=$(abspath $(O))
endif

all:
	@echo "Run 'make O=<your build directory> DEFCONFIG=<your configuration> config'"

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

config: $(DEFCONFIG) .buildroot-patched
	$(MAKE_BR) NERVES_DEFCONFIG_DIR=$(dir $(abspath $(DEFCONFIG))) \
	    BR2_DEFCONFIG=$(abspath $(DEFCONFIG)) \
	    DEFCONFIG=$(abspath $(DEFCONFIG)) defconfig

clean: realclean
distclean: realclean
realclean:
	-[ ! -d buildroot ] || chmod -R u+w buildroot
	-rm -fr buildroot .buildroot-patched .buildroot-downloaded

.PHONY: all clean
