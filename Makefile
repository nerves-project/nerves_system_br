
BUILDROOT_VERSION = ca5639f8d00aae6427054dee1f0433583ad3041d
BUILDROOT_URL = git://git.buildroot.net/buildroot
BUILDROOT_CONFIG = nerves_bbb_defconfig

# Optional place to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
BUILDROOT_DL_DIR = ~/dl

all: br-make

.buildroot-downloaded:
	git clone $(BUILDROOT_URL)
	cd buildroot && git checkout -b nerves $(BUILDROOT_VERSION)

	touch .buildroot-downloaded

.buildroot-patched: .buildroot-downloaded
	# Apply patches not yet in upstream buildroot
	cd buildroot; \
	for p in `ls ../patches/*.patch` ; do \
		echo Applying $$p; \
		patch -p1 < $$p; \
	done

	# If there's a user dl directory, symlink it to avoid
	# the big download
	if [ -d $(BUILDROOT_DL_DIR) ]; then \
		ln -s $(BUILDROOT_DL_DIR) buildroot/dl; \
	fi
	touch .buildroot-patched

buildroot/configs/$(BUILDROOT_CONFIG): br-configs/$(BUILDROOT_CONFIG) .buildroot-patched
	cp br-configs/$(BUILDROOT_CONFIG) buildroot/configs
	make -C buildroot $(BUILDROOT_CONFIG)

br-make: buildroot/configs/$(BUILDROOT_CONFIG)
	make -C buildroot
	@echo SDK is ready to use. Demo image is in buildroot/output/images.

clean:
	make -C buildroot clean

realclean:
	rm -fr buildroot
