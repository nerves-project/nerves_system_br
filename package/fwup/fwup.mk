#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = 0.5.2
# Use the official release tarball
FWUP_SITE = https://github.com/fhunleth/fwup/releases/download/v$(FWUP_VERSION)
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_DEPENDENCIES = libconfuse libarchive libsodium

$(eval $(autotools-package))
$(eval $(host-autotools-package))
