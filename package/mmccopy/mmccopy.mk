#############################################################
#
# mmccopy
#
#############################################################

MMCCOPY_VERSION = 1.0.0
MMCCOPY_SITE = $(call github,fhunleth,mmccopy,$(MMCCOPY_VERSION))
MMCCOPY_LICENSE = MIT
MMCCOPY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
