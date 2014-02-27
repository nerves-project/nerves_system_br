#############################################################
#
# elixir
#
#############################################################

ELIXIR_VERSION = v0.12.4
ELIXIR_SITE = $(call github,elixir-lang,elixir,$(ELIXIR_VERSION))
ELIXIR_LICENSE = Apache-2.0
HOST_ERLANG_ELIXIR_DEPENDENCIES = host-erlang

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# $(eval $(host-generic-package))
