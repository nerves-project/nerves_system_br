################################################################################
#
# ply
#
################################################################################

PLY_VERSION = aa5b9ac31307ec1acece818be334ef801c802a12
PLY_SITE = $(call github,iovisor,ply,$(PLY_VERSION))
PLY_LICENSE = GPL-2.0
PLY_LICENSE_FILES = COPYING
PLY_AUTORECONF = YES
PLY_DEPENDENCIES = linux

# Fix missing m4 directory error from aclocal
define PLY_PATCH_M4
	mkdir -p $(@D)/m4
endef
PLY_POST_PATCH_HOOKS += PLY_PATCH_M4

$(eval $(autotools-package))
