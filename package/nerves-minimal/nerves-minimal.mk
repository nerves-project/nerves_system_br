#############################################################
#
# nerves-minimal
#
#############################################################

NERVES_MINIMAL_VERSION = ab6883fb9bdfa7d6d0eb63025e6aa047cc4805bd
NERVES_MINIMAL_SITE = $(call github,nerves-project,nerves-minimal,$(NERVES_MINIMAL_VERSION))
NERVES_MINIMAL_LICENSE = MIT
NERVES_MINIMAL_INSTALL_DIR = $(TARGET_DIR)/srv/erlang

NERVES_MINIMAL_DEPENDENCIES = erlang host-erlang-rebar host-erlang-relx

define NERVES_MINIMAL_BUILD_CMDS
	(cd $(@D); $(REBAR) get-deps compile && NERVES_SDK_SYSROOT=$(HOST_DIR) $(RELX))
endef

define NERVES_MINIMAL_INSTALL_TARGET_CMDS
	mkdir -p $(NERVES_MINIMAL_INSTALL_DIR)
	cp -r $(@D)/_rel/* $(NERVES_MINIMAL_INSTALL_DIR)
endef

$(eval $(generic-package))
