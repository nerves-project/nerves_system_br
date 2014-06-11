#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = 5f2296c0c914cd3d171660f7d983f6c35106daa9
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = COPYING
FWUP_AUTORECONF = YES
FWUP_DEPENDENCIES = libconfuse libarchive

$(eval $(autotools-package))
$(eval $(host-autotools-package))
