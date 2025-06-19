################################################################################
#
# rpicam-apps
#
################################################################################

RPICAM_APPS_VERSION = 1.7.0
RPICAM_APPS_SITE = $(call github,raspberrypi,rpicam-apps,v$(RPICAM_APPS_VERSION))
RPICAM_APPS_LICENSE = BSD-2-Clause
RPICAM_APPS_LICENSE_FILES = license.txt
RPICAM_APPS_DEPENDENCIES = \
	host-pkgconf \
	boost \
	jpeg \
	rpi-libcamera \
	libexif \
	libpng \
	tiff

RPICAM_APPS_CONF_OPTS = \
	-Denable_opencv=disabled \
	-Denable_tflite=disabled

ifeq ($(BR2_PACKAGE_LIBDRM),y)
RPICAM_APPS_DEPENDENCIES += libdrm
RPICAM_APPS_CONF_OPTS += -Denable_drm=enabled
else
RPICAM_APPS_CONF_OPTS += -Denable_drm=disabled
endif

ifeq ($(BR2_PACKAGE_FFMPEG)$(BR2_PACKAGE_LIBDRM),yy)
RPICAM_APPS_DEPENDENCIES += ffmpeg libdrm
RPICAM_APPS_CONF_OPTS += -Denable_libav=enabled
else
RPICAM_APPS_CONF_OPTS += -Denable_libav=disabled
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
RPICAM_APPS_DEPENDENCIES += \
	$(if $(BR2_PACKAGE_LIBEPOXY),libepoxy) \
	$(if $(BR2_PACKAGE_XLIB_LIBX11),xlib_libX11)
endif

ifeq ($(BR2_PACKAGE_QT5),y)
RPICAM_APPS_DEPENDENCIES += qt5base
RPICAM_APPS_CONF_OPTS += -Denable_qt=enabled
else
RPICAM_APPS_CONF_OPTS += -Denable_qt=disabled
endif

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
#RPICAM_APPS_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

$(eval $(meson-package))
