
NERVES_BR_VERSION = 8238e41962daed442394c70f289f92691a1a5750
NERVES_BR_URL = git://git.buildroot.net/buildroot
NERVES_BR_CONFIG ?= nerves_bbb_defconfig

# Optional place to download files to so that they don't need
# to be redownloaded when working a lot with buildroot
NERVES_BR_DL_DIR ?= ~/dl

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

	# If there's a user dl directory, symlink it to avoid
	# the big download
	if [ -d $(NERVES_BR_DL_DIR) ]; then \
		ln -s $(NERVES_BR_DL_DIR) buildroot/dl; \
	fi
	touch .buildroot-patched

buildroot/configs/nerves_defconfig: br-configs/$(NERVES_BR_CONFIG) .buildroot-patched
	cp br-configs/$(NERVES_BR_CONFIG) buildroot/configs/nerves_defconfig
	make -C buildroot nerves_defconfig

br-make: buildroot/configs/nerves_defconfig
	make -C buildroot
	@echo SDK is ready to use. Demo image is in buildroot/output/images.

menuconfig: buildroot/configs/nerves_defconfig
	make -C buildroot menuconfig
	make -C buildroot savedefconfig
	@echo !!! Remember to copy buildroot/defconfig to br-configs to save the new settings.

linux-menuconfig: buildroot/configs/nerves_defconfig
	make -C buildroot linux-menuconfig
	make -C buildroot linux-savedefconfig
	@echo !!! Remember to copy buildroot/output/build/linux-x.y.z/defconfig to boards/.../linux-x.y.config

clean:
	make -C buildroot clean
	-rm -fr buildroot/configs/nerves_defconfig

realclean:
	-rm -fr buildroot .buildroot-patched .buildroot-downloaded
