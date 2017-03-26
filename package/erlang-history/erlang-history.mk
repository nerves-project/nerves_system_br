#############################################################
#
# erlang-history
#
#############################################################

ERLANG_HISTORY_VERSION = b7d436aac1ec37e88b7d455a44e15af36c36ef67
ERLANG_HISTORY_SITE = $(call github,ferd,erlang-history,$(ERLANG_HISTORY_VERSION))
ERLANG_HISTORY_DEPENDENCIES = erlang host-erlang
ERLANG_HISTORY_INSTALL_STAGING = YES
ERLANG_HISTORY_INSTALL_TARGET = NO

define ERLANG_HISTORY_BUILD_CMDS
	cd $(@D) && $(HOST_DIR)/usr/bin/erl -make
endef

ERLANG_KERNEL_VSN = $(firstword $(patsubst $(HOST_DIR)/usr/lib/erlang/lib/kernel-%,%,$(wildcard $(HOST_DIR)/usr/lib/erlang/lib/kernel-*)))
ERLANG_KERNEL_DIR = usr/lib/erlang/lib/kernel-$(ERLANG_KERNEL_VSN)

# Install to staging to make erlang-history available to
# Erlang release generation tools
define ERLANG_HISTORY_INSTALL_STAGING_CMDS
	cd $(@D) && $(HOST_DIR)/usr/bin/escript install.escript \
	    $(STAGING_DIR)/$(ERLANG_KERNEL_DIR)/ebin $(ERLANG_KERNEL_VSN)
endef

define ERLANG_HISTORY_INSTALL_TARGET_CMDS
	cd $(@D) && $(HOST_DIR)/usr/bin/escript install.escript \
	    $(TARGET_DIR)/$(ERLANG_KERNEL_DIR)/ebin $(ERLANG_KERNEL_VSN)
endef

$(eval $(generic-package))
