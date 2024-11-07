################################################################################
#
# tpm2-tss-engine
#
################################################################################

TPM2_TSS_ENGINE_VERSION = 1.2.0
TPM2_TSS_ENGINE_SITE = https://github.com/tpm2-software/tpm2-tss-engine/releases/download/$(TPM2_TSS_ENGINE_VERSION)
TPM2_TSS_ENGINE_SOURCE = tpm2-tss-engine-$(TPM2_TSS_ENGINE_VERSION).tar.gz
TPM2_TSS_ENGINE_LICENSE = BSD-3-Clause
TPM2_TSS_ENGINE_LICENSE_FILES = LICENSE
TPM2_TSS_ENGINE_INSTALL_STAGING = YES
TPM2_TSS_ENGINE_DEPENDENCIES = host-pkgconf tpm2-tss
TPM2_TSS_ENGINE_AUTORECONF = YES

TPM2_TSS_ENGINE_CONF_OPTS = \
	--disable-digestsign \
	--with-enginesdir="/usr/lib/engines-3"

$(eval $(autotools-package))
