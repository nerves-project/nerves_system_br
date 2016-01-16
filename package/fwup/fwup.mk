#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = v0.5.0
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_AUTORECONF = YES
FWUP_DEPENDENCIES = libconfuse libarchive libsodium

$(eval $(autotools-package))
$(eval $(host-autotools-package))
