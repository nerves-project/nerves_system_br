#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = 0.6.0
# Use the official release tarball
FWUP_SITE = https://github.com/fhunleth/fwup/releases/download/v$(FWUP_VERSION)
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_DEPENDENCIES = libconfuse libarchive libsodium

# help2man doesn't work when cross compiling
FWUP_CONF_ENV = ac_cv_path_HELP2MAN=''

$(eval $(autotools-package))
$(eval $(host-autotools-package))
