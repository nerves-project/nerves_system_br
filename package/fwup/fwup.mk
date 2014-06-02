#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = bc5ded1243e103890b471d1b90cf7c389ab29161
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = COPYING
FWUP_AUTORECONF = YES
FWUP_DEPENDENCIES = libconfuse libarchive

$(eval $(autotools-package))
$(eval $(host-autotools-package))
