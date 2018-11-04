################################################################################
#
# nbtty
#
################################################################################

NBTTY_VERSION = v0.4.1
NBTTY_SITE = $(call github,fhunleth,nbtty,$(NBTTY_VERSION))
NBTTY_LICENSE = GPL-2.0+
NBTTY_LICENSE_FILES = COPYING
NBTTY_AUTORECONF = YES

$(eval $(autotools-package))
