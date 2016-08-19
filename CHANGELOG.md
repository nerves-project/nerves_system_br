# Changelog

## v0.6.2-dev

  * Bug fixes
    * Fix false positive from scrubber when checking executable formats due to
      C++ template instantiations. Ignores SYSV vs. GNU/Linux ABI difference.

## v0.6.1

  * Package updates
    * fwup 0.8.2

  * Bug fixes
    * Updates default `erl_inetrc` to fix `:nxdomain` errors from DNS resolver
    * Remove .img file from system images (reduces system tarball size)
    * Redirect Buildroot download in case buildroot.net goes down
    * Support statically linked executables in OTP releases

The Raspberry Pi and Beaglebone `board` directories have been moved to
`nerves_system_rpi*` and `nerves_system_bbb` respectively. Further development
and maintenance for those platforms will happen there for future releases.

## v0.6.0

  * Package updates
    * Erlang OTP 19
    * Elixir 1.3.1
    * fwup 0.8.0
    * erlinit 0.7.3
    * bborg-overlays (pull in I2C typo fix from upstream)

  * Bug fixes
    * Synchronize file system kernel configs across all platforms

Note: Files in the `board` directory are being moved to their corresponding
system images. This has been completed for the LinkIt Smart and Lego EV3.
The transition should be complete by next release.

## v0.5.2

  * Enhancements
    * Enabled USB Printer kernel mod. Needs to be loaded with `modprobe` to use

  * Bug Fixes(raspberry pi)
    * Enabled multicast in linux config for rpi/rpi2/rpi3/ev3

## v0.5.1

  * Bug Fixes(nerves-env)
    * Added include paths to CFLAGS and CXXFLAGS
    * Pass sysroot to LDFLAGS

## v0.5.0

Important: If you use the BBB, a significant change to the device tree overlay
interface was made. This is part of the 3.8 to 4.4.9 kernel upgrade change. This
will affect user code. Additionally, the boot partition size of increased on the
BBB. If you want neither of these changes, you can create a custom system image
that points to the 3.8 kernel and has the old partition sizes in the fwup.conf.

  * New features
    * WiFi drivers enabled by default on RPi2 and RPi3
    * Include wireless regulatory database in Linux kernel by default
      on WiFi-enabled platforms. Since kernel/rootfs are read-only and
      coupled together for firmware updates, the normal CRDA/udev approach
      isn't necessary.
    * Upgraded the default BeagleBone Black kernel from 3.8 to 4.4.9. The
      standard BBB device tree overlays are included by default even though the
      upstream kernel patches no longer include them.
    * Change all fwup configurations from two step upgrades to one step
      upgrades. If you used the base fwup.conf files to upgrade, you no
      longer need to finalize the upgrade. If not, there's no change.

## v0.4.1

  * Bug fixes
    * syslinux fails to boot when compiled on some gcc 5 systems
    * Fixed regression when booting off eMMC on the BBB

  * Package updates
    * Erlang 18.3
    * Elixir 1.2.5

## v0.4.0

Important: The repository changed names to `nerves_system_br`. Previously it
had used hyphens. This was done as part of the `mix` integration so that the
repository's name didn't have to be quoted. Please update all links.

  * New features
    * Major updates to the configuration process to support storing configs more
      easily outside of `nerves_system_br`. This enables reference board
      configurations as Hex packages or as their own git repos. Our supported
      configs are pulled in via git submodules so they can still be built
      by travis.
    * Support building out-of-tree
    * Added more checks for compiler mismatches when building releases
    * Extract nerves-id code to boardid project; add BBB and some x86 support
    * Basic RPi 3 support and experimental Lego EV3, Alix, AG150, and qemu
      configs
    * Enable Busybox ntpd and date to work around lack of Elixir package for
      setting the system time

  * Bug fixes
    * Enable ADCs in Beaglebone Black configuration

  * Package updates
    * Buildroot 2016.02
    * Elixir 1.2.4

## v0.3.3

  * Bug fixes
    * Re-enable CONFIG_LEDS_GPIO in Raspberry Pi kernel

  * Package updates
    * Elixir 1.2.3

## v0.3.2

  * New features
    * Updated Linux kernel to 4.1 on Raspberry Pi platforms. The Raspberry Pi
      Zero now works. This is not thoroughly tested.
    * Enable WiFi on Raspberry Pi. Application support is needed, so this is
      only one step to getting WiFi working out of the box.
    * Update buildroot to 2016.02-rc1 to pull in current Raspberry Pi support.
    * Switch default DNS resolver to use Erlang's internal support

  * Bug fixes
    * Remove exrm check from nerves-elixir.mk since it's also possible to
      use the nerves application to package the release

  * Package updates
    * fwup v0.6.0
    * Many others from the Buildroot update

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
