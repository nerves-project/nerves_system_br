# Changelog

## v0.3.1

  * New features
    * Basic Intel Galileo support
    * erlang.mk support (thanks to mdsebald)
    * To burn a firmware image, you can just run `make burn`. `make
      burn-complete` is aliased to `make burn`.
    * Improved host/target Erlang version checking

  * Bug fixes
    * `nerves_xxx_defconfig` config naming and docs have been cleaned up. With
      the recent changes many had become out of date.
    * Enforce 64-bit system for build since 32-bit systems can't run the Nerves
      toolchains

  * Package updates
    * erlang 18.2.1
    * elixir 1.2.1
    * erlinit v0.7.0
    * nerves-toolchain v0.6.0
    * fwup v0.5.0

## v0.3.0

This release updates many packages and Buildroot to later versions. Most
platforms have been changed to use custom crosscompilers from
`nerves-toolchain`, so that it is possible to compile much of a project
locally on non-Linux systems (Macs are the first priority).

The project has also changed names from `nerves-sdk` to `nerves-system-br`. This
reflects its use as a system image builder for Nerves. In Nerves terminology, a
toolchain + a system + your Elixir, Erlang, or LFE app = a firmware image.
Buildroot is the initial system image builder, but other system builders are
possible in the future.

  * New features
    * Use squashfs instead of ext4 for rootfs (smaller roots; enables firmware
      assembly on OSX since `fakeroot` isn't needed for handling special files)
    * Many bash-isms and Linux-isms removed from scripts to support `zsh` and
      BSD builds.
    * Use cross-compiler toolchains from `nerves-toolchains`
    * Upgrade Erlang to 18.1
    * Upgrade Elixir to 1.1.1
    * Upgrade fwup to 0.4.2 (backwards incompatible firmware upgrade change from
      Nerves v0.2.3)

## v0.2.3

This release captures the state of the Nerves master branch before some major
changes to support integration with `bake` and building applications locally on
non-Linux platforms.

  * Recent changes
    * Raspberry Pi configs default to HDMI rather than UART
    * Elixir version 1.0.5
