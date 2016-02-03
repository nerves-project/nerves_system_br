# Include Nerves-specific packages
include $(sort $(wildcard $(BR2_EXTERNAL)/package/*/*.mk))

# Nerves targets

# NERVES_CONFIG is used to reference files in configurations
# relative to wherever the _defconfig is stored.
NERVES_CONFIG=$(dir $(BR2_DEFCONFIG))

# Create a system image for use by Bakeware and for creating
# firmware images without Buildroot
system:
	$(BR2_EXTERNAL)/scripts/mksystem.sh

NERVES_FIRMWARE=$(firstword $(wildcard $(BINARIES_DIR)/*.fw))

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
		sudo $(HOST_DIR)/usr/bin/fwup -a -i $(NERVES_FIRMWARE) -t upgrade --no-eject; \
		sudo $(HOST_DIR)/usr/bin/fwup -y -a -i /tmp/finalize.fw -t on-reboot; \
		sudo rm /tmp/finalize.fw; \
	else \
		echo "ERROR: No firmware found. Check that 'make' completed successfully"; \
		echo "and that a firmware (.fw) file is in $(BINARIES_DIR)."; \
	fi


.PHONY: burn burn-complete burn-upgrade system
