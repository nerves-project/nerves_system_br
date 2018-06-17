# Changelog

## v1.2.2

* New features
  * boardid 1.1.1
  * fwup 1.2.1
  * Erlang 20.3.8

The new boardid version fixes an issue with using empty serial numbers from
the U-Boot environment block. The new behavior is to fall back to use other IDs
if the saved serial number is blank.

The new fwup version improves the meta-uuid implementation so that firmware
update servers can determine with a high degree of confidence what's running on
a device without users needing be accurate with version numbers or needing to
inject a version control ID into their fwup.conf scripts.

## v1.2.1

* Bug fixes
  * Patched regression in Buildroot 2018.05 that made it impossible to enable
    QtWebEngine

## v1.2.0

* New features
  * Buildroot 2018.05
  * boardid 1.1.0
  * bborg-overlays (latest SHA)

Buildroot 2018.05 contains the normal set of minor version bumps throughout. It
let us remove 8 patches that we had been carrying around. See the [Buildroot
announcement](http://lists.busybox.net/pipermail/buildroot/2018-June/222697.html)
for details.

The `boardid` bump improves about the U-boot environment block support by
simplifying the configuration needed in the `erlinit.config` script.

The bborg-overlays project has had several improvements since we last took a
snapshot of it. Some of these are needed for the upcoming device tree overlay
support in `nerves_system_bbb` that uses the new U-boot overlay support.

## v1.1.0

* New features
  * Erlang 20.3.6
  * Qt5 5.10.1
  * boardid 1.0.0
  * erlinit 1.4.1

The Qt5 version bump pulls in a newer version of Chromium for those users making
kiosks.

The `boardid` update adds support for pulling serial numbers from U-boot
environment blocks. This is very useful if you assign serial numbers to boards
on the manufacturing line and would like hostnames, node names and mDNS to use
your serial numbers.

## v1.0.1

Note: Versioning on `nerves_system_br` doesn't follow semver. This particular
release is low-risk, but it is recommended that Nerves systems specify the
`nerves_system_br` version explicitly and review the change notes here to ensure
that a version bump of one of the included projects is non-breaking.

* New features
  * Erlang 20.3.5
  * pigpio V67
  * Buildroot 2018.02.2. This is a bugfix/security patch release to 2018.02.1
  * fwup 1.1.0

* Bug fixes
  * Fixed PKG_CONFIG environment variables to point to staging (target) versions
    of packages. This is needed for cmake and Makefile projects that use
    pkg-config.

* Removed packages
  * erlang-relx - This version of relx hadn't been used in a long time. Since it
    was also out-of-date, the choice was made to remove it.

## v1.0.0

* Bug Fixes
  * Include buildroot patch for enabling widechar for host ncurses to fix issues
    with `make linux-menuconfig` rendering a lot of `@?`characters.

## v1.0.0-rc.4

* New features
  * Buildroot 2018.02.1 patch release integrated. This removes the need for two
    patches that we had been maintaining and includes a few minor version bugs
    bug fixes.
  * Refactor the rootfs_overlay merge logic to support multiple rootfs_overlays.
    To use this in your programs, a corresponding update is required in the
    `nerves` project. See [nerves PR #269](https://github.com/nerves-project/nerves/pull/269).

* Bug fixes
  * Prevent the scrubber from erasing /etc/services and /etc/protocol if the
    user provides their own versions.

## v1.0.0-rc.3

* New features
  * Erlang 20.3.2
  * Pull in BR patches required to support the Raspberry Pi 3 B+

* Bug fixes
  * Updated the release scrubber to call `readelf` instead of `file` for
    checking whether an executable was made for the right system. This makes the
    check more portable. While doing this the Linux kernel header check was
    removed. This check was too conservative and disallowed Rust and Go binaries
    that were fine.

## v1.0.0-rc.2

* New features
  * Erlang 20.3.1
  * Nerves replacement to `heart`. This addresses a minor issue with calling
    reboot with the default `heart` and re-adds integration with hardware
    watchdogs.

## v1.0.0-rc.1

* New features
  * Buildroot 2018.02

* Bug fixes
  * Removed trivial .fw creation to remove need to build rebar. The reason for
    the removal was that it sometimes triggered compiler errors. Since only one
    person used the .fw file (to our knowledge), it seemed easier to skip
    building it. This requires a change to CI scripts in systems that publish
    the .fw file.
  * Reduced ANSI window polling over serial ports (nbtty). This makes viewing
    logs a little faster and reduces the chance of stray ANSI sequences
    corrupting the terminal.

## v1.0.0-rc.0

* New features
  * [erlinit v1.4.0](https://github.com/nerves-project/erlinit/releases/tag/v1.4.0)

## v0.17.0

System tarballs no longer use the ustar format due to the 99 character path
limitation. This means that they can't be untar'd with Erlang's built-in tar
file support.

* New features
  * [fwup v1.0.0](https://github.com/fhunleth/fwup/releases/tag/v1.0.0)
  * Buildroot 2017.11.2 - security patch release
  * Enable selection of rpi-firmware to support Raspberry Pi ports that want
    to use Linux 4.9 rather than 4.4

## v0.16.4

* Bug fix
  * Fix undeterministic build break for Erlang due to missing host-autoconf
    dependency.

## v0.16.3

Drop build metadata for now due to publish errors from hex.pm.

* Bug fix
  * Force Erlang to use Buildroot's version of autoconf rather than the
    host OS's version

## v0.16.2+2017-11

* New features
  * Erlang 20.2.1

## v0.16.1-2017-11

* New features
  * [fwup v0.19.0](https://github.com/fhunleth/fwup/releases/tag/v0.19.0)

* Bug fixes
  * A couple obscure new Busybox commands crept into the default config due to
    the Buildroot version bump in the v0.16.0. These have been disabled.

## v0.16.0-2017-11

Since Nerves systems can become highly dependent on Buildroot releases, we've
decided to append the Buildroot version number to the end of the version string.
This makes it possible for us to release `nerves_system_br` with different
target Buildroot versions. While it is generally good to track Buildroot
releases to obtain security fixes and improvements, this can cause unwelcome
work on a stable product. It is also critical to know when you're upgrading
Buildroot versions since many C-based packages will be updated that could result
in regressions. Buildroot does provide long term support releases
that only contain security patches so users may want to transition to those
branches to minimize upgrade risk.

* New features
  * Buildroot 2017.11

* Bug fixes
  * Fixed locale warnings in Docker for some users.
    Developers can upgrade by running `docker pull nervesproject/nerves_system_br`

## v0.15.1

* New features
  * [erlinit v1.3.1](https://github.com/nerves-project/erlinit/releases/tag/v1.3.1)

## v0.15.0

* New features
  * Erlang 20.1
  * [fwup v0.18.0](https://github.com/fhunleth/fwup/releases/tag/v0.18.0)
  * [erlinit v1.3.0](https://github.com/nerves-project/erlinit/releases/tag/v1.3.0)
  * Added QT5 webengine patches for chromium support
  * moved nerves.exs to mix.exs for nerves v0.8.0

## v0.14.1

* Bug fixes
  * Buildroot 2017.08.1 - This brings in the KRACK and dnsmasq vulnerability
    fixes among a few other small patches.
  * Added back missing /etc/resolv.conf

## v0.14.0

* New features
  * Buildroot 2017.08 - Primarily minor package updates throughout, but
    a change to how the rootfs skeleton is maintained affects all systems.
    Systems now need to specify a custom skeleton or receive an error. The
    error message has details.
  * fwup v0.17.0 - This includes an exit handshake feature that can be used by
    nerves_firmware_ssh to avoid a race condition when reporting update
    errors.
  * erlinit 1.2.0 - support Elixir's protocol consolidation
  * nbtty - a non-blocking terminal passthrough to fix an issue with routing
    the IEx prompt through a gadget serial port
  * Added a patch to e2fsprogs to avoid hanging on a lack of entropy during
    system startup when formating the application partition

## v0.13.9

* Enhancements
  * If a rootfs_overlay is specified and doesn't exist, throw an error.
  * Bump version of fwup to v0.16.0 (no major updates for Nerves)
  * Limit the Buildroot patches to only the patches/buildroot directory.
    This makes way for supporting the Buildroot global patch directory
    in nerves_system_br. This isn't used yet.

## v0.13.8

* Fix SHA256 hashes for rpi-firmware and rpi-userland. See
  [Issue 109](https://github.com/nerves-project/nerves_system_br/issues/109).

## v0.13.7

* Bump version to work around [hex issue 404](https://github.com/hexpm/hex/issues/404)

## v0.13.6

The default directory for downloading tarballs for Buildroot is now
"~/.nerves/dl". This was done to facilitate sharing of downloaded tarballs with
other Nerves components.

Please erase or move the files in your `~/.nerves/cache/buildroot` to the new
location.

## v0.13.5

* Bump version to work around [hex issue 404](https://github.com/hexpm/hex/issues/404)

## v0.13.4

* Enhancements
  * Fix deprecation warnings for Elixir 1.5
  * fwup 0.15.4 - Changed signing keys to be base64 encoded. Added commandline parameters for passing public and private keys via commandline arguments
  * Improved error messaging for when a toolchain is not found when requiring nerves_env.exs

## v0.13.3

* Renaming
  * Per Buildroot convention, the rootfs-additions directory is being renamed
    to rootfs_overlay. A symlink is put in its place to avoid breaking any
    systems.
  * Remove qemu configurations. They always should be in the system, so this
    forces it. (Technically this is a breaking change, but the qemu system is
    currently not a particularly usable system.)

* Bug fixes
  * erlinit 1.1.4 - Fixes a hang when rebooting when using the gadget serial
    port on Beaglebone platforms
  * erlang-history - removed package. It is not useful with OTP 20 and was a
    no-op in the past patch releases.
  * Replace partial lookup table in merge-squashfs with logic that handles all
    permission types (thanks to radu for this fix)

## v0.13.2

* Bug fixes
  * fwup v0.15.3 - Fix segfault on targets with 1 TB drives. This should have
    hit targets with smaller Flash sizes - possibly down to 16 GB. The
    regression was introduced in fwup v0.15.0.

## v0.13.1

* Bug fixes
  * erlinit 1.1.3 - Fix hang when gracefully shutting down that was reported
    on an RPi3 project

## v0.13.0

* New features
  * Erlang/OTP 20
  * fwup v0.15.2 - caching improvements; improved error messages; new
    metadata fields for storing miscellaneous user application info

* Bug fixes
  * erlinit 1.1.2 - Fix blocking I/O issue that was found when using USB
    gadget mode.

## v0.12.1

* New features
  * fwup v0.15.0 - much improved caching, support for TRIM, u-boot
    improvements
  * erlinit 1.1.1 - fixed problem with reaping zombie orphans (processes)
  * busybox - Added dd, find, grep, and a few other utilities now that
    Nerves.Runtime.Shell is available

## v0.12.0

* New features
  * Buildroot 2017.05 - Primary minor package updates, but has improved
    Raspberry Pi firmware support and an overlay-supporting dtc compiler for
    the BBB.
  * pigpio - New package for Raspberry Pi targets
  * erlinit 1.1.0 - support for modifying the graceful shutdown timer

* Removals
  * raspijpgs - Removed package. See [picam](https://github.com/electricshaman/picam)
    for MJPEG streaming on Raspberry Pis now.

## v0.11.1

* Bug fixes
  * erlinit 1.0.1 - fix Erlang VM exit detection bug introduced by graceful
    shutdown feature
  * Lock down which .fw file is burned in `make burn` - only affects Linux
    users that run manual builds

## v0.11.0

* New features
  * erlinit 1.0 - new graceful shutdown feature may break existing code.
    Shutdowns are no longer immediate. Code should call :init.stop after
    calling reboot, poweroff or halt.
  * fwup 0.14.2 - contains many consistency and validation checks that
    may detect corruption that wasn't detected before, so there may be new
    failures
  * rpi-userland and rpi-firmware version bumps to correspond with Raspbian
    Linux 4.4 updates.

* Bug fixes
  * Trim out BusyBox utilities that were automatically added on version
    updates. The new utilities were pretty useless on Nerves systems and
    ended up adding about 50KB bloat to all images.

## v0.10.1

* Bug fixes
  * Fix quoting in scripts so that paths with spaces and + signs work.

## v0.10.0

* New features
  * Bump Buildroot version to 2017.02
  * Bump Erlang/OTP to 19.3
  * Update Raspberry Pi projects to support the Raspberry Pi Zero W

## v0.9.4

* Bug fixes
  * The Musl C library fix in v0.9.3 wasn't completely fixed. It worked if you
    built Nerves systems using `make` locally, but not `mix`. The check logic
    turned out to be looking for a file that may or may not exist depending on
    build order.

## v0.9.3

* New features
  * Bump fwup to v0.13.0 - contains a fix for sending progress updates through
    Erlang ports

* Bug fixes
  * Fix Musl C library systems by fixing a symlink. Without this fix the
    system will boot and kernel panic when loading `/sbin/init`.

## v0.9.2

IMPORTANT: This includes a kernel bump to 4.4.43 and bumps for rpi-userland and
rpi-firmware. Most importantly, kernels no longer need to be marked that
use device tree, so the kernel marking logic has been removed. This will
break systems, but those systems should upgrade their kernels to avoid
any mismatches between kernel patches and rpi-firmware.

## v0.9.1

* Bug Fixes
  * Include `external.desc` in hex package

## v0.9.0

IMPORTANT: All Nerves Systems will need all references to the `BR2_EXTERNAL`
environment variable updated to `BR2_EXTERNAL_NERVES_PATH`.

* New features
  * Bump Buildroot version to 2016.11.1
  * Update Erlang/OTP to 19.2
  * Update erlinit v0.8.0 (multi-boot script support)
  * Update fwup to v0.12.1

## v0.8.2

* Bug Fixes
  * raise exceptions in nerves-env with Mix.raise instead of Nerves.Env.Exception
  * pull the version info from VERSION instead of assuming git

## v0.8.1

* Enhancements
  * Added System env variables for configuring distillery

## v0.8.0

* Enhancements
  * Moved Config for Alix, Galileo, and AG150 to nerves_system_* repos
  * Support for nerves 0.4.0 package compiler

## v0.7.0

* Package updates
  * Buildroot 2016.08

* Bug fixes
  * Many packages were removed. These include Elixir and LFE since neither are
    actually used. Both are added as part of the user build step, so no
    functionality is lost. The most visible result is that the system images
    are smaller and the test .fw file boots to the Erlang prompt.
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
