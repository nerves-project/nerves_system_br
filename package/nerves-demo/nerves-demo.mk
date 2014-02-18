#############################################################
#
# nerves-demo
#
#############################################################

NERVES_DEMO_VERSION = 523490942eff906ed32a1f886c14b2ac1eda88a0
NERVES_DEMO_SITE = $(call github,nerves-project,nerves-demo,$(NERVES_DEMO_VERSION))
NERVES_DEMO_LICENSE = MIT
NERVES_DEMO_INSTALL_DIR = $(TARGET_DIR)/srv/erlang

NERVES_DEMO_DEPENDENCIES = erlang host-erlang-rebar host-erlang-relx

define NERVES_DEMO_BUILD_CMDS
	(cd $(@D); $(REBAR) get-deps compile && NERVES_SDK_SYSROOT=$(HOST_DIR) $(RELX))
endef

define NERVES_DEMO_INSTALL_TARGET_CMDS
	mkdir -p $(NERVES_DEMO_INSTALL_DIR)
	cp -r $(@D)/_rel/* $(NERVES_DEMO_INSTALL_DIR)
endef

$(eval $(generic-package))
