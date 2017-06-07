# Include Nerves-specific packages
include $(sort $(wildcard $(BR2_EXTERNAL_NERVES_PATH)/package/*/*.mk))

# Nerves targets

# NERVES_DEFCONFIG_DIR is used to reference files in configurations
# relative to wherever the _defconfig is stored.
NERVES_DEFCONFIG_DIR = $(dir $(call qstrip,$(BR2_DEFCONFIG)))
export NERVES_DEFCONFIG_DIR

# Pull in any configuration-specific packages
-include $(NERVES_DEFCONFIG_DIR)/external.mk

# Create a system image for use by Bakeware and for creating
# firmware images without Buildroot
NERVES_ARTIFACT_NAME ?= $(BR2_NERVES_SYSTEM_NAME)
system:
	$(BR2_EXTERNAL_NERVES_PATH)/scripts/mksystem.sh $(NERVES_ARTIFACT_NAME)

# It is common task to copy files to the images directory
# so that they can be included in a system image. Add this
# logic here so that a post-createfs script isn't required.
ifneq ($(call qstrip,$(BR2_NERVES_ADDITIONAL_IMAGE_FILES)),)
define NERVES_COPY_ADDITIONAL_IMAGE_FILES
	cp $(call qstrip,$(BR2_NERVES_ADDITIONAL_IMAGE_FILES)) $(BINARIES_DIR)
endef
TARGET_FINALIZE_HOOKS += NERVES_COPY_ADDITIONAL_IMAGE_FILES
endif

NERVES_FIRMWARE=$(BINARIES_DIR)/$(BR2_NERVES_SYSTEM_NAME).fw

# Replace everything on the SDCard with new bits
burn-complete: burn
burn:
	@if [ -e "$(NERVES_FIRMWARE)" ]; then \
		echo "Burning $(NERVES_FIRMWARE)..."; \
		sudo $(HOST_DIR)/usr/bin/fwup -a -i $(NERVES_FIRMWARE) -t complete; \
	else \
		echo "ERROR: No firmware found. Check that 'make' completed successfully"; \
		echo "and that a firmware (.fw) file is in $(BINARIES_DIR)."; \
	fi

# Upgrade the image on the SDCard (app data won't be removed)
# This is usually the fastest way to update an SDCard that's already
# been programmed. It won't update bootloaders, so if something is
# really messed up, burn-complete may be better.
burn-upgrade:
	@if [ -e "$(NERVES_FIRMWARE)" ]; then \
		echo "Upgrading $(NERVES_FIRMWARE)..."; \
		sudo $(HOST_DIR)/usr/bin/fwup -a -i $(NERVES_FIRMWARE) -t upgrade; \
	else \
		echo "ERROR: No firmware found. Check that 'make' completed successfully"; \
		echo "and that a firmware (.fw) file is in $(BINARIES_DIR)."; \
	fi

nerves-help:
	@echo "Nerves System Help"
	@echo "------------------"
	@echo
	@echo "This build directory is configured to create the system described in:"
	@echo
	@echo "$(BR2_DEFCONFIG)"
	@echo
	@echo "Building:"
	@echo "  all                           - Build the current configuration"
	@echo "  burn                          - Burn the most recent build to an SDCard"
	@echo "                                  (requires sudo)"
	@echo "  system                        - Build the system tarball"
	@echo "  clean                         - Clean everything"
	@echo
	@echo "Configuration:"
	@echo "  menuconfig                    - Run Buildroot's menuconfig"
	@echo "  linux-menuconfig              - Run menuconfig on the Linux kernel"
	@echo "  busybox-menuconfig            - Run menuconfig on Busybox to enable shell"
	@echo "                                  commands and more"
	@echo
	@echo "For much more information about the targets in this Makefile, run"
	@echo "'make buildroot-help' and see the Buildroot documentation."
	@echo "---------------------------------------------------------------------------"
	@echo
	@echo "Buildroot Help"
	@echo "--------------"

.PHONY: burn burn-complete burn-upgrade system nerves-help
