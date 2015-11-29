# Changelog

## v0.3.0-dev

This release updates many packages and Buildroot to later versions. Most
platforms have been changed to use custom crosscompilers from
`nerves-toolchain`, so that it is possible to compile much of a project
locally on non-Linux systems (Macs are the first priority).

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
