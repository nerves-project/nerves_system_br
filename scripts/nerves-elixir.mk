#
# Include this in your project's Makefile as a quick way of
# building a Nerves project
#

ifeq ($(NERVES_ROOT),)
    $(error Make sure that you source nerves-env.sh first)
endif

ifeq ($(shell grep exrm mix.exs),)
    $(error Please add '{ :exrm, "~> 0.15.0" }' to the deps in mix.exs)
endif

ERL_LIB = $(NERVES_SDK_SYSROOT)/usr/lib/erlang/lib
REL2FW = $(NERVES_ROOT)/scripts/rel2fw.sh

# This should get the one built by nerves assuming that the Nerves
# environment is loaded.
FWUP ?= $(shell which fwup)

ELIXIR_APP_NAME ?= $(shell basename $(shell pwd))

all: elixir-first-time-setup deps
	mix compile
	mix release
	$(REL2FW) rel/$(ELIXIR_APP_NAME)
	@echo
	@echo The firmware is in the _images directory and can be loaded onto the target.
	@echo E.g., run \"make burn-complete\" or \"make burn-upgrade\" to program
	@echo the image to an SDCard.

deps:
	mix deps.get

# Replace everything on the SDCard with new bits
burn-complete:
	sudo $(FWUP) -a -i $(firstword $(wildcard _images/*.fw)) -t complete

# Upgrade the image on the SDCard (app data won't be removed)
# This is usually the fastest way to update an SDCard that's already
# been programmed. It won't update bootloaders, so if something is
# really messed up, do a burn-complete.
burn-upgrade:
	sudo $(FWUP) -a -i $(firstword $(wildcard _images/*.fw)) -t upgrade
	sudo $(FWUP) -y -a -i /tmp/finalize.fw -t on-reboot
	sudo rm /tmp/finalize.fw

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
	    < $(NERVES_ROOT)/scripts/project-skel/elixir/$@ > $@

rel/nerves_system_libs:
	ln -sfT $(ERL_LIB) $@

clean:
	mix clean; rm -fr _build _images rel/$(ELIXIR_APP_NAME)

distclean: clean
	-rm -fr ebin deps

.PHONY: deps burn-complete burn-upgrade clean distclean all elixir-first-time-setup

