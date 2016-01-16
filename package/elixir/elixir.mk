#############################################################
#
# elixir
#
#############################################################

ELIXIR_VERSION = v1.2.1
ELIXIR_SITE =
ELIXIR_SOURCE = elixir-$(ELIXIR_VERSION)-Precompiled.zip
ELIXIR_LICENSE = Apache-2.0
ELIXIR_LICENSE_FILES = LICENSE

HOST_ELIXIR_INSTALL_DIR = /usr/lib/elixir

# Since the prebuilt version of Elixir has the generic filename Precompiled.zip,
# this pre-download hook downloads it to the more descriptive $(ELIXIR_SOURCE).
# The DOWNLOAD_INNER method handles the case where the file has already been downloaded.
define HOST_ELIXIR_DOWNLOAD_NAME_HACK
	$(call DOWNLOAD_INNER,"https://github.com/elixir-lang/elixir/releases/download/$(ELIXIR_VERSION)/Precompiled.zip",$(ELIXIR_SOURCE),DOWNLOAD)
endef
HOST_ELIXIR_PRE_DOWNLOAD_HOOKS += HOST_ELIXIR_DOWNLOAD_NAME_HACK

define HOST_ELIXIR_EXTRACT_CMDS
        $(UNZIP) $(DL_DIR)/$(ELIXIR_SOURCE) -d $(@D)
endef

define HOST_ELIXIR_INSTALL_CMDS
	mkdir -p $(HOST_DIR)$(HOST_ELIXIR_INSTALL_DIR)
	cp -r $(@D)/bin $(@D)/lib $(@D)/VERSION $(HOST_DIR)$(HOST_ELIXIR_INSTALL_DIR)
	for p in iex elixir mix; do \
		ln -sf $(HOST_DIR)$(HOST_ELIXIR_INSTALL_DIR)/bin/$$p $(HOST_DIR)/usr/bin/$$p ; \
	done
endef

$(eval $(host-generic-package))
