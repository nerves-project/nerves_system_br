#############################################################
#
# erlang-elixir
#
#############################################################

ERLANG_ELIXIR_VERSION = v0.12.4
ERLANG_ELIXIR_SITE = $(call github,elixir-lang,elixir,$(ERLANG_ELIXIR_VERSION))
ERLANG_ELIXIR_LICENSE = Apache-2.0
HOST_ERLANG_ELIXIR_DEPENDENCIES = host-erlang

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# $(eval $(host-generic-package))
