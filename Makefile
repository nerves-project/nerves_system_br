
BUILDROOT_VERSION = ca5639f8d00aae6427054dee1f0433583ad3041d
BUILDROOT_URL = git://git.buildroot.net/buildroot
BUILDROOT_DL_DIR = ~/dl

all: br-make

br-download:
	git clone $(BUILDROOT)
	cd buildroot && git checkout -b nerves $(BUILDROOT_VERSION)

	# Apply patches not yet in upstream buildroot
	cd buildroot && git am ../patches/*.patch

	# If there's a user dl directory, symlink it to avoid
	# the big download
	if [ -d $(BUILDROOT_DL_DIR) ]; then \
		ln -s $(BUILDROOT_DL_DIR) buildroot/dl \
	fi

br-config:
	cp br-configs/* buildroot/configs
	make -C buildroot nerves_bbb_defconfig

br-make:
	make -C buildroot
