#############################################################
#
# edk2
#
#############################################################

EDK2_VERSION = 315d9d08fd77db1024ccc5307823da8aaed85e2f
EDK2_SITE = $(call github,tianocore,edk2,$(EDK2_VERSION))
EDK2_INSTALL_TARGET = NO
EDK2_INSTALL_IMAGES = YES

define EDK2_INSTALL_IMAGES_CMDS
	cp $(@D)/ShellBinPkg/UefiShell/X64/Shell.efi $(BINARIES_DIR)
endef

$(eval $(generic-package))
