#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = 4c6c05d155ac12f721d569c7992ef23a91fe35ed
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = COPYING
FWUP_AUTORECONF = YES
FWUP_DEPENDENCIES = libconfuse libarchive

$(eval $(autotools-package))
$(eval $(host-autotools-package))
