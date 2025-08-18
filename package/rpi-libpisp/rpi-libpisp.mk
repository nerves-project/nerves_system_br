################################################################################
#
# rpi-libpisp
#
################################################################################

RPI_LIBPISP_VERSION = v1.2.1
RPI_LIBPISP_SITE = $(call github,raspberrypi,libpisp,$(RPI_LIBPISP_VERSION))
RPI_LIBPISP_DEPENDENCIES = json-for-modern-cpp
RPI_LIBPISP_CONF_OPTS = -Dlogging=disabled
RPI_LIBPISP_INSTALL_STAGING = YES
RPI_LIBPISP_LICENSE = \
	GPL-2.0+ (utils), \
	MIT, \
	BSD-2-Clause (raspberrypi), \
	GPL-2.0 with Linux-syscall-note (linux kernel headers), \
	CC0-1.0 (meson build system)
RPI_LIBPISP_LICENSE_FILES = \
	LICENSES/GPL-2.0-or-later.txt \
	LICENSES/MIT.txt \
	LICENSES/BSD-2-Clause.txt \
	LICENSES/GPL-2.0-only.txt \
	LICENSES/Linux-syscall-note.txt \
	LICENSES/CC0-1.0.txt

$(eval $(meson-package))
