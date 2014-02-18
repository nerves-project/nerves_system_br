#############################################################
#
# erlang-relsync
#
#############################################################

ERLANG_RELSYNC_VERSION = 5e037e2c67872a7974ac7aa75b8793c7f518cf02
ERLANG_RELSYNC_SITE = $(call github,fhunleth,relsync,$(ERLANG_RELSYNC_VERSION))
ERLANG_RELSYNC_LICENSE = MIT
ERLANG_RELSYNC_LICENSE_FILE = LICENSE.md

HOST_ERLANG_RELSYNC_DEPENDENCIES = host-erlang host-erlang-rebar

define HOST_ERLANG_RELSYNC_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE1) -C $(@D)
endef

define HOST_ERLANG_RELSYNC_INSTALL_CMDS
	cp $(@D)/relsync $(HOST_DIR)/usr/bin
endef

$(eval $(host-generic-package))
