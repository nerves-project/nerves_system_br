# Changelog

## v1.9.1

* Bug fixes
  * Fix regression with CI scripts preventing artifacts from being published.

## v1.9.0

This updates Buildroot to 2019.08. Buildroot release notes are at
http://lists.busybox.net/pipermail/buildroot/2019-September/258136.html.

* Package updates
  * Buildroot 2019.08

## v1.8.6

* Package updates
  * erlinit v1.5.1 - Fix issue where erlinit would stop reaping zombies if they
    were being created too quickly

## v1.8.5

* Package updates
  * rpi-firmware - Bump to latest version to fix framebuffer issue found on
    Raspberry Pi Zeros

* Improvements
  * Export pkg-config paths so that C programs with Makefiles that use
    pkg-config have a better chance of working

## v1.8.4

* Patches
  * Qt 5.13.0 - Fixes compilation errors when building Chromium for arm.

* Package updates
  * Erlang/OTP 22.0.7

## v1.8.3

* Package updates
  * Raspberry Pi firmware updates to support the Raspberry Pi 4
  * Erlang/OTP 22.0.5, 21.3.8.4, and 20.3.8.9
  * Qt 5.13.0 - This fixes compilation errors when building Chromium for x86_64.
    Unfortunately, Raspberry Pi compiles still don't work.
  * Buildroot 2019.05.1 - security and bug fixes to a variety of packages

## v1.8.2

* Package updates
  * Erlang/OTP 22.0.4

## v1.8.1

This release only updates Erlang and erlinit. The erlinit change adds a feature
needed for the upcoming Elixir 1.9 releases (i.e., non-Distillery releases).

* Package updates
  * Erlang/OTP 22.0.3
  * erlinit v1.5.0

## v1.8.0

This updates Buildroot to 2019.05. Buildroot release notes are at
http://buildroot-busybox.2317881.n4.nabble.com/Buildroot-2019-05-released-td224685.html.

* Package updates
  * Buildroot 2019.05
  * erlang 22.0.2

## v1.7.2

This release includes a change to remove absolute paths from compiled .beam
in OTP. This is just one of many changes needed to be able to generate the exact
same output from the same source code. Unfortunately, other changes are needed
(mostly removing timestamps) so at this point Nerves doesn't produce identical
output for identical inputs.

* Package updates
  * erlang 21.3.6

* Bug fixes
  * Remove absolute paths from OTP's .beam files (enable `+deterministic`
    compiler flag)

## v1.7.1

This release provides early access for ordering the rootfs based on the OTP init
script's primload order. With this feature, one can order `.beam` files
contiguously rather than distributed across the file system. This can be a boot
performance optimization on systems with slow I/O since it allows for reads from
the device to pull in multiple `.beam` files into memory at a time. It requires
corresponding updates to `nerves` to pass in the order.

## v1.7.0

This updates Buildroot to 2019.02. Buildroot release notes are at
http://buildroot-busybox.2317881.n4.nabble.com/Buildroot-2019-02-released-td217410.html.

* Package updates
  * Buildroot 2019.02
  * erlang 21.2.7

## v1.6.8

* Package updates
  * erlang 21.2.6

* Bug fixes
  * Bump fwup version in the associated DockerFile
  * Fix Erlang/OTP version check in dev scripts

## v1.6.7

* Package updates
  * erlang 21.2.5
  * fwup 1.3.0 - support expanding the data partition to be as large as possible

With this release, a host version of Erlang is no longer built. This version of
Erlang isn't used except for some very rare cases that don't seem to be used any
longer. This change reduces the build time by minutes.

## v1.6.6

* Package updates
  * erlang 21.2.4
  * boardid 1.5.3

This release also contains some cleanup to the Erlang DNS resolver
configuration. Previously, if the Erlang resolver failed, the system (C library)
resolver would be tried. Since the Erlang and system resolvers were configured
the same, this fallback to the system resolver shouldn't have worked. In the
cleanup, the fallback to the system resolver was removed. See
`board/nerves-common/rootfs_overlay/etc/erl_inetrc` for the new default
configuration.

## v1.6.5

* Package updates
  * OpenSSL 1.1.1a

The associated Docker image (nervesproject/nerves_system_br) now has Erlang
21.2.2 installed on it. Erlang 21.2.2 + OpenSSL 1.1.1a enable more features with
the `:crypto` library like ed25519 support. See the Erlang 21.2.x release notes.

## v1.6.4

* Package updates
  * erlang 21.2.2
  * boardid 1.5.2

## v1.6.3

This release pulls in a bug fix/security release from Buildroot and support for
starting Erlang via the `run_erl` command so that console messages can be logged
using standard OTP tools. Currently none of the official systems are switching
to `run_erl`, but that may happen in the future. It's now feasible to point the
console to `/dev/null` and not miss console messages if you need to lock down
all unauthenticated console access.

* Package updates
  * Buildroot 2018.11.1
  * erlinit 1.4.9
  * boardid 1.5.1
  * rpi-firmware - corresponds with 4.14.78. If you have a custom rpi you may
    want to bump your kernel version especially for the RPi 3 B+ which has an
    Ethernet reliability fix. See `nerves_system_rpi3`.

## v1.6.2

This is a patch release. There's no reason to upgrade unless you've run into the
issues below.

* Package updates
  * erlinit 1.4.8 - improves hostname checks to help avoid setting non-RFC 1123
    compliant names
  * boardid 1.5.0 - adds support for specifying parameters via
    /etc/boardid.config

## v1.6.1

This pulls in a pending patch in Buildroot to update the version of
OpenSSL from 1.0.2 to 1.1.0h. This fixes what appears to be issues with
Erlang using OpenSSL engines. It also enables Erlang crypto algorithms
such as ed25519 that have been added in recent Erlang releases.

* Package updates
  * openssl 1.1.0h
  * erlang 21.2
  * libp11 0.4.9

## v1.6.0

This updates Buildroot to 2018.11. Buildroot release notes are at
http://lists.busybox.net/pipermail/buildroot/2018-December/237402.html.

* Package updates
  * Buildroot 2018.11
  * erlang 21.1.4
  * boardid 1.4.0 - NervesKey serial number support

## v1.5.6

Re-package v1.5.5 on hex.pm to fix archive errors from
https://github.com/hexpm/hex/issues/631

## v1.5.5

* Bug fixes
  * Remove Busybox commands: tc, svok, and i2c tools. These weren't intended to
    be enabled and either don't work with Nerves or have Elixir equivialents
  * Remove Powershell and .script files from firmware for minor firmware size
    reductions

* Package updates
  * Buildroot 2018.08.3 - This is a security/bug fix update
  * erlang 21.1.3
  * boardid 1.3.0 - better ATECC508A support

## v1.5.4

* Bug fixes
  * OTP release scrubber has been fixed to detect libraries and executables that
    were compiled for OSX being included in Nerves releases. This happens with
    stale path dependency builds and can be hard to debug if you're not familiar
    with the issue.

* Package updates
  * Buildroot 2018.08.2 - This is a security patch update to 2018.08
  * nbtty 0.4.1 - Optionally suppress output to the console until the
    user is availabe

## v1.5.3

* Package updates
  * erlang 21.1.1
  * erlinit 1.4.7 - Fixes x86_64 NVME rootfs detection issue
  * fwup 1.2.6

## v1.5.2

* Package updates
  * rpi-firmware - bump to the latest Linux 4.14.71 update to fix flaky USB on
    the Raspberry Pi Zero.

## v1.5.1

* Package updates
  * bborg-overlays - Update to the latest device tree overlay set for the
    Beaglebone platforms
  * boardid - Add preliminary support for pulling serial numbers from the
    ATECC508A crypto chip

## v1.5.0

This version updates Buildroot to 2018.08. If you are using a system with
U-Boot, you may see a compiler error due to the new version of the device tree
compiler. See http://buildroot-busybox.2317881.n4.nabble.com/Buildroot-2018-08-released-td203016.html
for options.

* Package updates
  * Buildroot 2018.08
  * nerves_heart 0.2.0 - Pulls in minor fix from upstream and changes printfs to
    logs that can be captured by the Elixir logger.
  * erlang 21.0.9

* Bug fixes
  * Fixed bizarre slowdown on some Macs due to using chained calls to sed. This
    version converts those calls into one. Thanks to Jason Butterfield for
    finding and fixing this issue.

## v1.4.5

* Bug fixes
  * Updated docker image with better handling for switching user
    in the docker-entrypoint script.
  * Updated patch for erlang 21.0.6

## v1.4.4

Improved the error message presented from scripts/scrub-otp-release.sh
when encountering an executable that was compiled for a different target.

* Package updates
  * erlang 21.0.6

## v1.4.3

* Package updates
  * Qt 5.11.1 - Update from 5.10.1 to get more recent Chromium version
  * erlinit v1.4.6 - Fix permissions issue when running Chromium non-root

## v1.4.2

This release adds experimental support for Erlang/OTP 20 in systems. Official
Nerves Systems do not use this, but it's possible to enable by creating a custom
system, running `make menuconfig` and navigating to the Erlang options to enable
OTP 20.  Please provide feedback if this works so we know that it is sufficient
and worth maintaining going forward.

* Package updates
  * erlang 21.0.5 or 20.3.8.5
  * fwup v1.2.5
  * erlinit v1.4.5

* Bug fixes
  * Fix broken QMAKESPEC path for building Qt projects in Elixir projects
  * Pull in the host-ncurses build patch from upstream Buildroot. This fixes the
    root cause that triggered the Docker update in v1.4.1.

## v1.4.1

The busybox config has been refreshed in this version but should contain no
intentional changes from the previous version.

* Bug Fixes
  * Updated docker image to set user id and group id in entrypoint script.
    This fixes an issue when building packages that require the user has
    a defined user.

## v1.4.0

This release adds experimental support for compiling Qt code that's inside an
Elixir or Erlang project. This lets you build Qt-based UIs without having to
include your Qt/C++ code inside a custom Nerves system.

This release also includes the `rngd` program in all Nerves systems. Nerves
systems almost universally have a lack of entropy on start and this can delay
boot in many cases. The `rngd` utility is part of the solution to supplying more
entropy to the Linux kernel at boot and is a very small binary.

* Package updates
  * Buildroot 2018.05.1 - Bugfix/security updates to many packages
  * erlang 21.0.4
  * fwup v1.2.4

* Bug fixes
  * Override more Make implicit variables. This catches calls to ar, as, and ld
    so that the crosscompiler versions can be used instead.

## v1.3.2

* Bug fixes
  * Fix issue with calling readelf on shell scripts and improve error message.
  * Include patch for QT5WebEngine parallel compile fix.

## v1.3.1

* New features
  * erlinit 1.4.4
  * nbtty 0.4.0

* Bug fixes
  * Removed call to 'file' from OTP release scrubbing script to get rid of a
    warning some users were seeing.

The erlinit version bump fixes the following issues:

  * When running Docker on Nerves targets, Docker would report parse errors when
    detecting filesystems due to erlinit not filling out a field. This fixes
    that.
  * Applications would inherit erlinit's signal mask. This caused confusion, so
    now a default signal mask is passed on to the application.

The nbtty version bump fixes an issue where exiting from Erlang wouldn't be
detected and adds support for specifying tty files. The latter is needed for
those wanting to use configfs to configure the gadget USB interface.

## v1.3.0

* New features
  * Erlang 21.0

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
