#############################################################
#
# blstrobe
#
#############################################################

BLSTROBE_VERSION = v0.1.1
BLSTROBE_SITE = $(call github,fhunleth,blstrobe,$(BLSTROBE_VERSION))
BLSTROBE_LICENSE = Apache-2.0
BLSTROBE_LICENSE_FILES = COPYING
BLSTROBE_AUTORECONF = YES

$(eval $(autotools-package))
