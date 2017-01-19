################################################################################
#
# python-pigpio
#
################################################################################

PYTHON_PIGPIO_VERSION = 4862a16c9f76f9b2096055c98ef4fbc480dc1878
PYTHON_PIGPIO_SITE = $(call github,joan2937,pigpio,$(PIGPIO_VERSION))
PYTHON_PIGPIO_LICENSE = unlicense.org
PYTHON_PIGPIO_LICENSE_FILES = UNLICENCE
PYTHON_PIGPIO_SETUP_TYPE = distutils

$(eval $(python-package))
