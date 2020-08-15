#
# Include this in your project's Makefile as a quick way of
# building a Nerves project
#

ifeq ($(NERVES_SYSTEM),)
    $(error Make sure that you source nerves-env.sh first)
endif

ERL_LIB = $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib
REL2FW = $(NERVES_SYSTEM)/scripts/rel2fw.sh

# This should get the one built by nerves assuming that the Nerves
# environment is loaded.
FWUP ?= $(shell which fwup)

ELIXIR_APP_NAME ?= $(shell basename $(shell pwd))

all: elixir-first-time-setup deps compile release

help:
	@echo '-------------------------------------------------'
	@echo '$(ELIXIR_APP_NAME) help'
	@echo '-------------------------------------------------'
	@echo
	@echo 'Targets:'
	@echo '  all                    - Build everything'
	@echo '  deps                   - Run mix deps.get'
	@echo '  compile                - Run mix compile'
	@echo '  release                - Run mix release and package the firmware'
	@echo '  burn                   - Burn the most recent build to an SDCard (requires sudo)'
	@echo '  clean                  - Clean up the release and build directories'
	@echo '  distclean              - Clean up everything'
	@echo

release:
	rm -fr rel/$(ELIXIR_APP_NAME) # Clean up unused apps
	mix release
	$(REL2FW) -f _images/$(ELIXIR_APP_NAME).fw -a rel/rootfs_overlay rel/$(ELIXIR_APP_NAME)
	@echo
	@echo The firmware is in the _images directory and can be loaded onto the target.
	@echo E.g., run \"make burn\" to program the image to an SDCard.

compile:
	mix compile

deps:
	mix deps.get

# Replace everything on the SDCard with new bits
burn:
	sudo $(FWUP) -a -i $(firstword $(wildcard _images/*.fw)) -t complete
burn-complete: burn

# Upgrade the image on the SDCard (app data won't be removed)
# This is usually the fastest way to update an SDCard that's already
# been programmed. It won't update bootloaders, so if something is
# really messed up, do a "make burn".
burn-upgrade:
	sudo $(FWUP) -a -i $(firstword $(wildcard _images/*.fw)) -t upgrade
	if [ -e /tmp/finalize.fw ]; then \
	    sudo $(FWUP) -y -a -i /tmp/finalize.fw -t on-reboot; \
	    sudo rm /tmp/finalize.fw; \
	fi

# Helper tasks for creating a base set of files needed to build Nerves
# images. If they already exist, they aren't overwritten.
elixir-first-time-setup: rel/relx.config rel/vm.args rel/nerves_system_libs
	@if ! grep nerves .gitignore >/dev/null ; then \
	    echo "_images" >> .gitignore ; \
	    echo "rel/nerves_system_libs" >> .gitignore ; \
	    echo "rel/$(ELIXIR_APP_NAME)" >> .gitignore ; \
	fi

rel/vm.args rel/relx.config:
	@echo $@ not found. Creating a default version...
	@mkdir -p rel
	@sed "s/APP_NAME/$(ELIXIR_APP_NAME)/" \
	    < $(NERVES_SYSTEM)/scripts/project-skel/elixir/$@ > $@

rel/nerves_system_libs:
	rm -f $@
	ln -s $(ERL_LIB) $@

clean:
	mix clean; rm -fr _build _images rel/$(ELIXIR_APP_NAME)

distclean: clean
	-rm -fr ebin deps

.PHONY: deps burn burn-complete burn-upgrade clean distclean all elixir-first-time-setup compile release help

