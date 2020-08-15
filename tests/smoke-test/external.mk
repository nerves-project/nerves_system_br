# Include custom packages
include $(sort $(wildcard $(NERVES_DEFCONFIG_DIR)/package/*/*.mk))
