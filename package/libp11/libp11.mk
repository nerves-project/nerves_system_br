################################################################################
#
# libp11
#
################################################################################

LIBP11_VERSION = libp11-0.4.9
LIBP11_SITE = $(call github,OpenSC,libp11,$(LIBP11_VERSION))
LIBP11_LICENSE = LGPL-2.1
LIBP11_LICENSE_FILES = COPYING
LIBP11_DEPENDENCIES = openssl
LIBP11_AUTORECONF = YES

$(eval $(autotools-package))
