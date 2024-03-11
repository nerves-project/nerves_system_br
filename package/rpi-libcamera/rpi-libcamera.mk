################################################################################
#
# rpi-libcamera
#
################################################################################

RPI_LIBCAMERA_VERSION = v0.2.0+rpt20240215
RPI_LIBCAMERA_SITE = $(call github,raspberrypi,libcamera,$(RPI_LIBCAMERA_VERSION))
RPI_LIBCAMERA_DEPENDENCIES = \
	host-openssl \
	host-pkgconf \
	host-python-jinja2 \
	host-python-ply \
	host-python-pyyaml \
	libyaml \
	gnutls
RPI_LIBCAMERA_CONF_OPTS = \
	-Dandroid=disabled \
	-Ddocumentation=disabled \
	-Dtest=false \
	-Dpycamera=disabled \
	-Dwerror=false
RPI_LIBCAMERA_INSTALL_STAGING = YES
RPI_LIBCAMERA_LICENSE = \
	LGPL-2.1+ (library), \
	GPL-2.0+ (utils), \
	MIT (qcam/assets/feathericons), \
	BSD-2-Clause (raspberrypi), \
	GPL-2.0 with Linux-syscall-note or BSD-3-Clause (linux kernel headers), \
	CC0-1.0 (meson build system), \
	CC-BY-SA-4.0 (doc)
RPI_LIBCAMERA_LICENSE_FILES = \
	LICENSES/LGPL-2.1-or-later.txt \
	LICENSES/GPL-2.0-or-later.txt \
	LICENSES/MIT.txt \
	LICENSES/BSD-2-Clause.txt \
	LICENSES/GPL-2.0-only.txt \
	LICENSES/Linux-syscall-note.txt \
	LICENSES/BSD-3-Clause.txt \
	LICENSES/CC0-1.0.txt \
	LICENSES/CC-BY-SA-4.0.txt

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_7),y)
RPI_LIBCAMERA_CXXFLAGS = -faligned-new
endif

ifeq ($(BR2_PACKAGE_RPI_LIBCAMERA_V4L2),y)
RPI_LIBCAMERA_CONF_OPTS += -Dv4l2=true
else
RPI_LIBCAMERA_CONF_OPTS += -Dv4l2=false
endif

RPI_LIBCAMERA_PIPELINES-y += rpi/vc4
RPI_LIBCAMERA_DEPENDENCIES += boost
RPI_LIBCAMERA_PIPELINES-$(BR2_PACKAGE_RPI_LIBCAMERA_PIPELINE_SIMPLE) += simple
RPI_LIBCAMERA_PIPELINES-$(BR2_PACKAGE_RPI_LIBCAMERA_PIPELINE_UVCVIDEO) += uvcvideo

RPI_LIBCAMERA_CONF_OPTS += -Dpipelines=$(subst $(space),$(comma),$(RPI_LIBCAMERA_PIPELINES-y))

# gstreamer-video-1.0, gstreamer-allocators-1.0
ifeq ($(BR2_PACKAGE_GSTREAMER1)$(BR2_PACKAGE_GST1_PLUGINS_BASE),yy)
RPI_LIBCAMERA_CONF_OPTS += -Dgstreamer=enabled
RPI_LIBCAMERA_DEPENDENCIES += gstreamer1 gst1-plugins-base
endif

ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
RPI_LIBCAMERA_CONF_OPTS += -Dqcam=enabled
RPI_LIBCAMERA_DEPENDENCIES += qt5base
ifeq ($(BR2_PACKAGE_QT5TOOLS_LINGUIST_TOOLS),y)
RPI_LIBCAMERA_DEPENDENCIES += qt5tools
endif
else
RPI_LIBCAMERA_CONF_OPTS += -Dqcam=disabled
endif

ifeq ($(BR2_PACKAGE_LIBEVENT),y)
RPI_LIBCAMERA_CONF_OPTS += -Dcam=enabled
RPI_LIBCAMERA_DEPENDENCIES += libevent
else
RPI_LIBCAMERA_CONF_OPTS += -Dcam=disabled
endif

ifeq ($(BR2_PACKAGE_TIFF),y)
RPI_LIBCAMERA_DEPENDENCIES += tiff
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
RPI_LIBCAMERA_CONF_OPTS += -Dudev=enabled
RPI_LIBCAMERA_DEPENDENCIES += udev
else
RPI_LIBCAMERA_CONF_OPTS += -Dudev=disabled
endif

ifeq ($(BR2_PACKAGE_LTTNG_LIBUST),y)
RPI_LIBCAMERA_CONF_OPTS += -Dtracing=enabled
RPI_LIBCAMERA_DEPENDENCIES += lttng-libust
else
RPI_LIBCAMERA_CONF_OPTS += -Dtracing=disabled
endif

ifeq ($(BR2_PACKAGE_LIBEXECINFO),y)
RPI_LIBCAMERA_DEPENDENCIES += libexecinfo
RPI_LIBCAMERA_LDFLAGS = $(TARGET_LDFLAGS) -lexecinfo
endif

# Open-Source IPA shlibs need to be signed in order to be runnable within the
# same process, otherwise they are deemed Closed-Source and run in another
# process and communicate over IPC.
# Buildroot sanitizes RPATH in a post build process. meson gets rid of rpath
# while installing so we don't need to do it manually here.
# Buildroot may strip symbols, so we need to do the same before signing
# otherwise the signature won't match the shlib on the rootfs. Since meson
# install target is signing the shlibs, we need to strip them before.
RPI_LIBCAMERA_STRIP_FIND_CMD = \
	find $(@D)/build/src/ipa \
	$(if $(call qstrip,$(BR2_STRIP_EXCLUDE_FILES)), \
		-not \( $(call findfileclauses,$(call qstrip,$(BR2_STRIP_EXCLUDE_FILES))) \) ) \
	-type f -name 'ipa_*.so' -print0

define RPI_LIBCAMERA_BUILD_STRIP_IPA_SO
	$(RPI_LIBCAMERA_STRIP_FIND_CMD) | xargs --no-run-if-empty -0 $(STRIPCMD)
endef

RPI_LIBCAMERA_POST_BUILD_HOOKS += RPI_LIBCAMERA_BUILD_STRIP_IPA_SO

$(eval $(meson-package))
