#############################################################
#
# mmccopy
#
#############################################################

MMCCOPY_VERSION = bc3fab8c3c3a58be0535b9782a399f7cd3b9081d
MMCCOPY_SITE = $(call github,fhunleth,mmccopy,$(MMCCOPY_VERSION))
MMCCOPY_LICENSE = MIT
MMCCOPY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
$(eval $(host-autotools-package))
