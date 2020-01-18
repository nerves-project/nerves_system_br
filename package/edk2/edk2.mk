#############################################################
#
# edk2
#
#############################################################

EDK2_VERSION = edk2-stable201911
EDK2_SITE = https://github.com/tianocore/edk2/releases/download/$(EDK2_VERSION)
EDK2_SOURCE = ShellBinPkg.zip
EDK2_INSTALL_TARGET = NO
EDK2_INSTALL_IMAGES = YES

define EDK2_EXTRACT_CMDS
        $(UNZIP) -d $(@D) $(EDK2_DL_DIR)/$(EDK2_SOURCE)
        mv $(@D)/ShellBinPkg/* $(@D)
        $(RM) -r $(@D)/ShellBinPkg
endef

define EDK2_INSTALL_IMAGES_CMDS
	cp $(@D)/MinUefiShell/X64/Shell.efi $(BINARIES_DIR)/efi-part
endef

$(eval $(generic-package))
