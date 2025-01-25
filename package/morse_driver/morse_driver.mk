################################################################################
#
# morse_driver
#
################################################################################

MORSE_DRIVER_VERSION = 1.14.1
MORSE_DRIVER_SITE = https://github.com/MorseMicro/morse_driver
MORSE_DRIVER_SITE_METHOD = git
MORSE_DRIVER_GIT_SUBMODULES = YES
MORSE_DRIVER_LICENSE = GPL-2.0
MORSE_DRIVER_LICENSE_FILES = LICENSE

MORSE_DRIVER_MODULE_MAKE_OPTS = \
        CC=$(TARGET_CC) \
	CONFIG_WLAN_VENDOR_MORSE=m \
	CONFIG_MORSE_SDIO=y \
	CONFIG_MORSE_USER_ACCESS=y \
	CONFIG_MORSE_VENDOR_COMMAND=y

$(eval $(kernel-module))
$(eval $(generic-package))
