#############################################################
#
# mmccopy
#
#############################################################

MMCCOPY_VERSION = v1.0.2
MMCCOPY_SITE = $(call github,fhunleth,mmccopy,$(MMCCOPY_VERSION))
MMCCOPY_LICENSE = MIT
MMCCOPY_LICENSE_FILES = COPYING
MMCCOPY_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
