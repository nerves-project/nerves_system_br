#############################################################
#
# elixir
#
#############################################################

ELIXIR_VERSION = v0.12.4
ELIXIR_SITE = $(call github,elixir-lang,elixir,$(ELIXIR_VERSION))
ELIXIR_LICENSE = Apache-2.0

HOST_ELIXIR_DEPENDENCIES = host-erlang

define HOST_ELIXIR_CONFIGURE_CMDS
	# Elixir has no configure script so no Configuring needed
endef

define HOST_ELIXIR_INSTALL_CMDS
	cd $(@D); make PREFIX=/usr DESTDIR=$(HOST_DIR) install
endef

$(eval $(host-autotools-package))
#$(eval $(autotools-package))
