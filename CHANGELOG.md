# Changelog

This project does NOT follow semantic versioning. The version increases as
follows:

1. Major version updates are breaking updates to the build infrastructure.
   These should be very rare.
2. Minor version updates are made for every major Buildroot release. Buildroot
   makes four releases a year. Major Erlang/OTP updates are held off until the
   next Buildroot release.
3. Patch version updates are made for Buildroot minor releases and Erlang/OTP
   minor and patch releases. They're also made to fix bugs and add features to
   the build infrastructure.

## v1.27.2

* Package updates
  * [Erlang/OTP 26.2.5](https://erlang.org/download/OTP-26.2.5.README)

## v1.27.1

This is a security/bug fix update for 1.27.0.

* Package updates
  * [Buildroot 2024.02.1](https://lore.kernel.org/buildroot/87jzlp9u5e.fsf@48ers.dk/T/)
  * [Erlang/OTP 26.2.4](https://erlang.org/download/OTP-26.2.4.README)

## v1.27.0

This update pulls in Buildroot 2024.02. This is a major Buildroot update.

Nerves systems need the following updates:

1. For Raspberry Pi systems using libcamera, the version that comes with Raspberry
   Pi OS has diverged from upstream libcamera. To use it, replace
   `BR2_PACKAGE_LIBCAMERA_*=y` with `BR2_PACKAGE_RPI_LIBCAMERA_*=y`.
2. The Raspberry Pi applications for libcamera also changed. Replace
   `BR2_PACKAGE_LIBCAMERA_APPS=y` with `BR2_PACKAGE_RPICAM_APPS=y`. The upstream
   package is called `rpicam_apps`. `libcamera_apps` was the old name.

* Fixes
  * Add explicit check for `$TMPDIR` to fix a regression on MacOS 13 with
    v1.26.1. Thanks to @schrockwell.

* Package updates
  * [Buildroot 2024.02](https://lore.kernel.org/buildroot/87msrczp4z.fsf@48ers.dk/)
  * [Erlang/OTP 26.2.3](https://erlang.org/download/OTP-26.2.3.README)

## v1.26.1

This is a security/bug fix update for 1.26.0.

* Fixes
  * Update calls to mktemp to honor $TMPDIR so that it can be redirected to a
    case sensitive filesystem on MacOS.

* Package updates
  * [Erlang/OTP 26.2.2](https://erlang.org/download/OTP-26.2.2.README)

## v1.26.0

This update pulls in Buildroot 2023.11.1. This is a major Buildroot update from
v1.25.3.

Nerves systems need the following updates:

1. For Raspberry Pi systems using libcamera, change
   `BR2_PACKAGE_LIBCAMERA_PIPELINE_RASPBERRYPI=y` to
   `BR2_PACKAGE_LIBCAMERA_PIPELINE_RPI_VC4=y`
3. If using a RISC-V processor, the ISA options changed. This involves changing
   `BR2_RISCV_ISA_CUSTOM_RVM=y` to `BR2_RISCV_ISA_RVM=y`, etc.

* Fixes
  * Fix change to `find` on recent MacOS versions that caused the release
    scrubber to fail.

* Package updates
  * [Buildroot 2023.11.1](https://lore.kernel.org/buildroot/87cyu2k2gu.fsf@48ers.dk/T/)

## v1.25.3

This is a security/bug fix update for 1.25.2.

* Package updates
  * [Erlang/OTP 26.2.1](https://erlang.org/download/OTP-26.2.1.README)
  * [nerves_heart 2.3.0](https://github.com/nerves-project/nerves_heart/releases/tag/v2.3.0)

## v1.25.2

This is a security/bug fix update for v1.25.1 that also adds support for the
Raspberry Pi 5's WiFi and Bluetooth module.

* Changes
  * Update the RPi WiFi firmware to support the module on the RPi 5. This also
    brings in about 2 years worth of updates to the firmware so it might help
    other RPi's.
  * Add `rpi-distro-bluez-firmware` package to supply Bluetooth firmware for the
    RPi 5 and other RPi's.

* Package updates
  * [Buildroot 2023.08.4](https://lore.kernel.org/buildroot/87o7f6t7fs.fsf@48ers.dk/T/)

## v1.25.1

This is a patch update to v1.25.0.

The `erlinit` update will start saving and restoring random number seeds to
`/root/seedrng`. Failures are logged, but ignored.

* Package updates
  * [erlinit 1.13.0](https://github.com/nerves-project/erlinit/releases/tag/v1.13.0)
  * pppd 2.5.0 - fixes a build issue with pppd 2.4.9 and GCC 13

## v1.25.0

This update pulls in Buildroot 2023.08.2. This is a major Buildroot update from
v1.24.1 with possibly the biggest change for Nerves users being the update from
OpenSSL 1.1.1 to OpenSSL 3.

Nerves systems need the following updates:

1. Buildroot 2023.08 updated the default GCC version to GCC 13. Since Nerves
   systems and toolchains are mostly on GCC 12 which was the default, the
   `nerves_defconfig` will need to be updated to select GCC 12. Add
   `BR2_TOOLCHAIN_EXTERNAL_GCC_12=y` to `nerves_defconfig`.
2. Buildroot's toolchain feature detection is better. OpenMP and Fortan support
   are autodetect and checked against toolchain features specified in
   `nerves_defconfig`. To fix the warnings, add
   `BR2_TOOLCHAIN_EXTERNAL_FORTRAN=y` and `BR2_TOOLCHAIN_EXTERNAL_OPENMP=y` to
   `nerves_defconfig`.
3. If using a RISC-V processor, you may need to enable the atomic instructions
   in the target selection. If you get build errors with Erlang concerning
   atomics, this is likely the issue.

* Package updates
  * [Buildroot 2023.08.2](https://lore.kernel.org/buildroot/87edhvuioc.fsf@48ers.dk/)
  * [Erlang/OTP 26.1.2](https://erlang.org/download/OTP-26.1.2.README)

## v1.24.1

This is a security/bug fix update for v1.24.0.

* Package updates
  * [Erlang/OTP 26.1.1](https://erlang.org/download/OTP-26.1.1.README)
  * [Buildroot 2023.05.3](https://lore.kernel.org/buildroot/87h6ngup34.fsf@48ers.dk/T/)

## v1.24.0

This update pulls in Erlang/OTP 26.1 and Buildroot 2023.05.2. For the Buildroot
portion, most projects that work with `nerves_system_br` v1.23.x shouldn't need
any changes with this update, but please review the Buildroot release notes.

* Package updates
  * [Erlang/OTP 26.1](https://erlang.org/download/OTP-26.1.README)
  * [Buildroot 2023.05.2](https://lore.kernel.org/buildroot/87ledrkrpp.fsf@48ers.dk/T/)
    See the release notes for [Buildroot 2023.05](https://lore.kernel.org/buildroot/87r0qn2c77.fsf@48ers.dk/T/)
    and [Buildroot 2023.05.1](https://lore.kernel.org/buildroot/87351m8qm4.fsf@48ers.dk/T/).

## v1.23.3

* Fixes
  * Include upstream Erlang aarch64 div/rem JIT patch to fix a math error on
    aarch64 devices that affects the `atecc508a` library. This library is used
    to authenticate connections to NervesHub and other cloud services. See
    https://github.com/erlang/otp/pull/7567 for details.
  * Remove acknowledgement when a clean build might be needed when called from
    non-interactive terminals

## v1.23.2

This is a security/bug fix update for v1.23.1.

* Fixes
  * Patch Erlang to make CTRL-R work over ssh. See
    [OTP PR 7499](https://github.com/erlang/otp/pull/7499)

* Package updates
  * [Buildroot 2023.02.3](https://lore.kernel.org/buildroot/87y1je6wva.fsf@48ers.dk/T/)
  * [Fwup 1.10.1](https://github.com/fwup-home/fwup/releases/tag/v1.10.1)

## v1.23.1

This is a security/bug fix release for v1.23.0. The patch in 1.23.0 to remove
the multiline editor code in OTP 26 has been removed since the issue with ssh
has been fixed in OTP 26.0.2.

* Updates
  * Allow error messages from merge-squashfs to be propogated to help debug
    squashfs packaging issues.

* Package updates
  * [Buildroot 2023.02.2](https://lore.kernel.org/buildroot/87wn03ifbl.fsf@48ers.dk/T/)
  * [Erlang/OTP 26.0.2](https://erlang.org/download/OTP-26.0.2.README). Also see
    [Erlang/OTP 26.0.1](https://erlang.org/download/OTP-26.0.1.README).

## v1.23.0

This update pulls in Erlang/OTP 26.0 and Buildroot 2023.02.1. For the Buildroot
portion, most projects that work with `nerves_system_br` v1.22.x shouldn't need
any changes with this update, but please review the Buildroot release notes.

* Upgrade notes
  * The default TERM setting changed from vt100 to xterm-256color. In the past,
    this didn't really matter. With OTP 26, the TERM setting starts being used
    so applications that use the terminal may change how they render.
  * OTP 26.0 comes with a multiline editor. At the time of this release
    multiline editing didn't work with ssh so it's currently disabled.

* Package updates
  * [Erlang/OTP 26.0](https://erlang.org/download/OTP-26.0.README)
  * [Buildroot 2023.02.1](https://lore.kernel.org/buildroot/87mt2c5t7t.fsf@dell.be.48ers.dk/T/).
    See the release notes for [Buildroot 2023.02](https://lore.kernel.org/buildroot/87pm9dy9kb.fsf@dell.be.48ers.dk/T/)
    as well.
  * [erlinit 1.12.3](https://github.com/nerves-project/erlinit/releases/tag/v1.12.3)

## v1.22.8

* Package updates
  * [boardid 1.14.0](https://github.com/nerves-project/boardid/releases/tag/v1.14.0)

## v1.22.7

This is a security/bug fix release for v1.22.6.

* Fixes
  * Remove hardcoded OPTEE filename for use with U-Boot. This is needed for
    BeaglePlay/TI AM625 support.

* Package updates
  * [Erlang/OTP 25.3.2](https://erlang.org/download/OTP-25.3.2.README)

## v1.22.6

This update contains an update to Nerves Heart to support "snoozing" of hardware
watchdog and heart-related reboots to assist debugging heart issues. No other
updates were made.

* Package updates
  * [nerves_heart 2.2.0](https://github.com/nerves-project/nerves_heart/releases/tag/v2.2.0)

## v1.22.5

This is a security/bug fix release for v1.22.4.

We switched from Docker Hub to the GitHub Container Registry for new official
system images. Existing Docker Hub images are not going away. However, new ones
will be at
[ghcr.io/nerves-project/nerves_system_br](https://github.com/nerves-project/nerves_system_br/pkgs/container/nerves_system_br).
This change should not affect anyone unless you manually fetch the images.

* Package updates
  * [Buildroot 2022.11.3](https://lore.kernel.org/buildroot/878rfuxbxx.fsf@dell.be.48ers.dk/T/)
  * [Fwup 1.10.0](https://github.com/fwup-home/fwup/releases/tag/v1.10.0)

## v1.22.4

This is a security/bug fix release for v1.22.3.

* Package updates
  * [Buildroot 2022.11.2](https://lore.kernel.org/buildroot/87ilfkfmla.fsf@dell.be.48ers.dk/T/)
  * [Erlang/OTP 25.3](https://erlang.org/download/OTP-25.3.README)

## v1.22.3

This is a security/bug fix release for v1.22.2.

* Fixes
  * Emit warnings rather than error out when stripping executables fails on the
    firmware image packing step. These can happen when using precompiled Rust
    executables. They still work. The more important architecture checks are
    not impacted by this change.

* Package updates
  * [Erlang/OTP 25.2.3](https://erlang.org/download/OTP-25.2.3.README)

 ## v1.22.2

This is a security/bug fix release for v1.22.1.

* Package updates
  * [Buildroot 2022.11.1](https://lore.kernel.org/buildroot/87ilh4dvax.fsf@dell.be.48ers.dk/T/#u)
  * [Erlang/OTP 25.2.2](https://erlang.org/download/OTP-25.2.2.README). Also see
    [Erlang/OTP 25.2.1](https://erlang.org/download/OTP-25.2.1.README).

## v1.22.1

This is a trivial update to v1.22.0 that allows better debug output control of
Nerves Heart. No other changes were made.

* Package updates
  * [nerves_heart 2.1.0](https://github.com/nerves-project/nerves_heart/releases/tag/v2.1.0)

## v1.22.0

This update pulls in Buildroot 2022.11. Most projects that work with
nerves_system_br v1.21.x shouldn't need any changes with this update, but please
review the Buildroot release notes.

* Updates
  * Support Crosstool-NG-built RISC-V glibc toolchains

* Package updates
  * [Buildroot 2022.11](http://lists.busybox.net/pipermail/buildroot/2022-December/656980.html)

## v1.21.6

* Fixes
  * Revert RTL8723DS driver update due to an incompatibility with the Allwinner
    D1 Linux 5.19 branch. It works with Linux 6.1 and these patches are included
    in Buildroot 2022.11, so upgrading Allwinner D1 systems will eventually be
    required.

* Package updates
  * [Erlang/OTP 25.2](https://erlang.org/download/OTP-25.2.README)

## v1.21.5

This is a security/bug fix release for v1.21.4.

* Fixes
  * Pull in RTL8723DS driver updates so that it compiles on Linux 6.1. This
    fixes an issue building the latest Allwinner D1 (RISC-V) kernel updates.

* Package updates
  * [Buildroot 2022.08.3](https://lore.kernel.org/buildroot/87r0x7z5cw.fsf@dell.be.48ers.dk/T/#u)

## v1.21.4

This is a security/bug fix release for v1.21.3.

* Fixes
  * Fixes guarded poweroff via Nerves Heart to poweroff instead of halt

* Package updates
  * [Buildroot 2022.08.2](http://lists.busybox.net/pipermail/buildroot/2022-November/656121.html)
  * [nerves_heart 2.0.2](https://github.com/nerves-project/nerves_heart/releases/tag/v2.0.2)

## v1.21.3

This release updates Nerves Heart to 2.0.1. This is technically a backwards
incompatible version, but only if you use Nerves Heart statistics reports in
your code. Nerves Heart 2.0 has several improvements to address rare issues and
provide better information. The `nerves_runtime` library has updates to use
these new features.

* Package updates
  * [nerves_heart 2.0.1](https://github.com/nerves-project/nerves_heart/releases/tag/v2.0.1)
  * [erlinit 1.12.2](https://github.com/nerves-project/erlinit/releases/tag/v1.12.2)

## v1.21.2

This is a security/bug fix release for v1.21.1.

* Updates
  * Use `MIX_BUILD_PATH` if specified for build products

* Package updates
  * [Erlang/OTP 25.1.2](https://erlang.org/download/OTP-25.1.2.README)
  * [boardid 1.13.1](https://github.com/nerves-project/boardid/releases/tag/v1.13.1)

## v1.21.1

This is a security/bug fix release for v1.21.0.

* Updates
  * Fix nerves-env.sh use with Bash

* Package updates
  * [Buildroot 2022.08.1](http://lists.busybox.net/pipermail/buildroot/2022-October/652816.html)
  * [Erlang/OTP 25.1.1](https://erlang.org/download/OTP-25.1.1.README)

## v1.21.0

This is a major update that pulls in Buildroot 2022.08. Most projects that work
with nerves_system_br v1.20 shouldn't need any changes with this update, but
please review the release notes.

* Updates
  * Use OTP 25.1's new deterministic builds flag
  * Many shellcheck fixes to nerves_system_br shell scripts

* Package updates
  * [Buildroot 2022.08](http://lists.busybox.net/pipermail/buildroot/2022-September/650852.html):
  * [Erlang/OTP 25.1](https://erlang.org/download/OTP-25.1.README)

## v1.20.6

This release reverts an update to `libp11` in `v1.20.5` that currently breaks
the OpenSSL engine integration with ATECC cryptographic chips (like NervesKeys).
It has no other changes.

## v1.20.5

This is a security/bug fix release for v1.20.4.

* Package updates
  * [Buildroot 2022.05.2](http://lists.busybox.net/pipermail/buildroot/2022-August/650546.html)
  * Also see [Buildroot 2022.05.1 changes](http://lists.busybox.net/pipermail/buildroot/2022-July/647814.html)
  * [Erlang/OTP 25.0.4](https://erlang.org/download/OTP-25.0.4.README)

## v1.20.4

* Updates
  * Support aarch64 builds with Docker (Thanks to @doawoo)

* Package updates
  * [Erlang/OTP 25.0.3](https://erlang.org/download/OTP-25.0.3.README)

## v1.20.3

* Fixes
  * Fix sysroot setting when building C/C++ code in Elixir and Erlang libraries.
    This fixes an issue found with RISC-V, Musl C, and aggressive warnings as
    error settings.

* Updates
  * Support enabling the vector instruction extension on RISC-V processors.

## v1.20.2

* Fixes
  * Set `CMAKE_SYSTEM_PROCESSOR` for cmake builds. This fixes a build issue with
    `xnnpack` and possibly other libraries. Thanks to @cocoa-xu for this fix.

* Package updates
  * [Erlang/OTP 25.0.2](https://erlang.org/download/OTP-25.0.2.README)

## v1.20.1

* Fixes
  * Fixes an issue where the Raspberry Pi Zero 2W's WiFi module's firmware
    wouldn't load with Linux 5.15

* Package updates
  * [boardid 1.13.0](https://github.com/nerves-project/boardid/releases/tag/v1.13.0)

## v1.20.0

This is a major update that pulls in Buildroot 2022.05. Most projects shouldn't
need any changes with this update, but please review the release notes.

* Package updates
  * [Buildroot 2022.05](http://lists.busybox.net/pipermail/buildroot/2022-June/644349.html)
  * [Erlang/OTP 25.0.1](https://erlang.org/download/OTP-25.0.1.README)
  * [nerves_heart 1.1.0](https://github.com/nerves-project/nerves_heart/releases/tag/v1.1.0)

## v1.19.1

This is a bug fix release for v1.19.0.

* Package updates
  * [erlinit 1.12.1](https://github.com/nerves-project/erlinit/releases/tag/v1.12.1)
  * Raspberry Pi WiFi firmware - 20210315-3+rpt5 + Zero 2W fix

## v1.19.0

This is a major update that pulls in Buildroot 2022.02.1 and Erlang/OTP 25.

* Package updates
  * [Buildroot 2022.02.1](http://lists.busybox.net/pipermail/buildroot/2022-April/640712.html).
    Also see [Buildroot 2022.02](http://lists.busybox.net/pipermail/buildroot/2022-March/638160.html)
  * [Erlang/OTP 25.0](https://erlang.org/download/OTP-25.0.README)
  * [erlinit 1.12.0](https://github.com/nerves-project/erlinit/releases/tag/v1.12.0)

* Updates
  * No longer install ERTS to the release. This means that the Mix release
    generator needs to install ERTS, but it had been doing this and it had been
    ignored. No changes to your project are needed. ERTS will be under `/srv`
    now on the device rather than `/usr`.
  * It's now possible to use the `start.boot` boot script. It's no longer
    scrubbed from the release.
  * Build a host version of Erlang so that the host and target Erlang definitely
    match. This had been removed to speed up builds in the past. However, it did
    not work when compiling the new JIT. This is the "safe" option since
    mismatched host and target Erlang versions could cause problems.

## v1.18.6

* Package updates
  * [Erlang/OTP 24.3.2](https://erlang.org/download/OTP-24.3.2.README). See
    [Erlang/OTP 24.3.1](https://erlang.org/download/OTP-24.3.1.README) and
    [Erlang/OTP 24.3](https://erlang.org/download/OTP-24.3.README) for other
    changes.

## v1.18.5

This is mostly a Buildroot and Erlang bug fix release. It should be safe to
upgrade to from `v1.18.4`.

* Changes
  * boardid: Support reading serial numbers from the GRiSP2 EEPROM
  * bborg-overlays: Support changing the directory where Beaglebone device tree
    overlays get installed. Default remains the same (/lib/firmware).

* Package updates
  * [Buildroot 2021.11.2](https://lists.buildroot.org/pipermail/buildroot/2022-February/637876.html)
  * [Erlang/OTP 24.2.2](https://erlang.org/download/OTP-24.2.2.README)
  * [boardid 1.12.0](https://github.com/nerves-project/boardid/releases/tag/v1.12.0)

## v1.18.4

This is a Buildroot and Erlang bug fix release. It should be safe to upgrade to
from `v1.18.3`.

* Changes
  * Buildroot's gcc argument settings are now recorded to Nerves systems in the
    `buildroot-gcc-args` file. This includes flags that enable CPU features that
    may not be enabled by default in the toolchain. This file can be used for
    the new `TARGET_GCC_FLAGS` variable that can be set in the Nerves System's
    `mix.exs` package definition.

* Package updates
  * [Buildroot 2021.11.1](http://lists.busybox.net/pipermail/buildroot/2022-January/635208.html)
  * [Erlang/OTP 24.2.1](https://erlang.org/download/OTP-24.2.1.README)

## v1.18.3

* Changes
  * Add `cmake` support via the `CMAKE_TOOLCHAIN_FILE` environment variable.
    Pass `-D CMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}` when configuring
    a CMake project to use. Thanks to @cocoa-xu for this.

* Fixes
  * Prepend host tools to `PATH` rather than append them. Since
    `LD_LIBRARY_PATH` is set, there was a possibility of using a system-supplied
    program with a Nerves-supplied shared library. This makes this less
    possible. Thanks to @ejc123 for tracking this down.

## v1.18.2

* Fixes
  * Fix issue creating SBOM information (`make legal-info`) for the RPi WiFi
    firmware.

## v1.18.1

This is a minor update to v1.18.0.

* Changes
  * Include host freetype and host libjpeg to fix compilation errors with
    qt5webengine. Thanks to @wzin for tracking this down and working with the
    Buildroot devs. The patch will be here until an upstream fix is released.
  * Update WiFi firmware for all Raspberry Pi platforms. This brings in a number
    of fixes that were released over the past year. See
    [changelog](https://github.com/RPi-Distro/firmware-nonfree/blob/bullseye/debian/changelog).

## v1.18.0

This is a major update that pulls in Buildroot 2021.11. Please review the
Buildroot release notes in addition to the following:

1. Add `BR2_LINUX_KERNEL_NEEDS_HOST_OPENSSL=y` to the `nerves_defconfig`. Even
   if the kernel required host openssl, it was sometimes possible to build
   successfully without the option. This changed, so now the option is required.
2. For Raspberry Pi systems, the firmware options changed. Here's what you need
   to do:
   * Remove `BR2_PACKAGE_RPI_FIRMWARE_X=y`
   * Add `BR2_PACKAGE_RPI_FIRMWARE_BOOTCODE_BIN=y`
   * Add `BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI=y` for the default firmware OR
   * Add `BR2_PACKAGE_RPI_FIRMWARE_VARIANT_PI_X=y` for the extended firmware.
     This is what the official Nerves systems use. If you do this, you must
     change the `fwup.conf`.
   * If you've copied and customized `fwup.conf` (usually in `config/fwup.conf`)
     then you need to update the firmware filenames. You only need to do this if
     you're using the extended firmware. In the `on-resource` blocks, change the
     `start.elf` resource to load from `start_x.elf` and the `fixup.dat`
     resource to load from `fixup_x.dat`. You'll get an error building the
     firmware about not being able to find `start.elf` if you don't do this.

If in doubt, check out the differences that we made to the official systems on
GitHub or on Hex.pm (e.g. the [full nerves_system_rpi4
change](https://diff.hex.pm/diff/nerves_system_rpi4/1.17.3..1.18.0) and [partial
nerves_system_rpi4
change](https://github.com/nerves-project/nerves_system_rpi4/commit/59b8a65a54222dfedf08e1767977156fafb88ca8)).

* Package updates
  * [Buildroot 2021.11](http://lists.busybox.net/pipermail/buildroot/2021-December/629911.html)
  * [Erlang/OTP 24.2](https://erlang.org/download/OTP-24.2.README)

* Fixes
  * The S3 bucket that was being used as an backup download site is no
    longer available to us. The new backup site is
    https://dl.nerves-project.org/

## v1.17.4

* Package updates
  * [Buildroot 2021.08.2](http://lists.busybox.net/pipermail/buildroot/2021-November/628323.html)
  * [Erlang/OTP 24.1.7](https://erlang.org/download/OTP-24.1.7.README). Also see
    [Erlang/OTP 24.1.6 changes](https://erlang.org/download/OTP-24.1.6.README)
    and [Erlang/OTP 24.1.5 changes](https://erlang.org/download/OTP-24.1.5.README)

## v1.17.3

* Package updates
  * [Erlang/OTP 24.1.4](https://erlang.org/download/OTP-24.1.4.README). Also see
    [Erlang/OTP 24.1.3 changes](https://erlang.org/download/OTP-24.1.3.README)

## v1.17.2

* Package updates
  * [nerves_heart 1.0.0](https://github.com/nerves-project/nerves_heart/releases/tag/v1.0.0)

## v1.17.1

* Package updates
  * [Buildroot 2021.08.1](http://lists.busybox.net/pipermail/buildroot/2021-October/625642.html)
  * [Erlang/OTP 24.1.2](https://erlang.org/download/OTP-24.1.2.README)

## v1.17.0

This is a major update to Buildroot 2021.08. Please review the Buildroot release
notification below in addition to the following.

1. Buildroot's default version of GCC changed, so add the following to your
   `nerves_defconfig`:

   ```
   BR2_TOOLCHAIN_EXTERNAL_GCC_10=y
   ```

* Package updates
  * [Buildroot 2021.08](http://lists.busybox.net/pipermail/buildroot/2021-September/622072.html)
  * [Erlang/OTP 24.1](https://erlang.org/download/OTP-24.1.README)

## v1.16.5

* Improvements
  * Make shell script shebang lines consistently call `/usr/bin/env` to find
    `bash`. This fixes an issue with NixOS and possibly other setups. Thanks to
    @mayl for this change.
  * Resync Busybox configuration. This removes the `mim` and `base32` applets
    that were turned on by default on a update.

## v1.16.4

This is primarily a bug fix release for Buildroot and Erlang/OTP. The Erlinit
update brings in beta support for including a
[`runtime.exs`](https://hexdocs.pm/mix/1.12.2/Mix.Tasks.Release.html#module-runtime-configuration)
in your project. This support is new and may lead to reboot loops if you have
not configured your system to revert to previous firmware loads on failures.

* Package updates
  * [Buildroot 2021.05.1](http://lists.busybox.net/pipermail/buildroot/2021-August/620721.html)
  * [Erlang/OTP 24.0.5](https://erlang.org/download/OTP-24.0.5.README)
  * [erlinit 1.11.0](https://github.com/nerves-project/erlinit/releases/tag/v1.11.0)

## v1.16.3

* Package updates
  * [Erlang/OTP 24.0.4](https://erlang.org/download/OTP-24.0.4.README)

* Improvements
  * Adds a default `/etc/sysctl.conf` file to support setting kernel parameters
    on initialization. This requires a `nerves_runtime` `v0.11.5` or later. The
    current default only enables non-root use of ICMP. This simplifies use of
    ICMP in Erlang and Elixir.

* Bug fixes
  * Fixes an issue on MacOS where if you had `/home` in your `$PATH`, `mix
    firmware` could go from taking 10 seconds to many minutes to run due to the
    `merge-squashfs` script. Thanks to Jonathan Palley for some serious
    detective work to narrow this issue down.
  * Fixes an issue on MacOS with exclusing files from the scrubber.

## v1.16.2

* Package updates
  * [fwup 1.9.0](https://github.com/fhunleth/fwup/releases/tag/v1.9.0)

* Improvements
  * Software Bill of Materials (SBOM) information from Buildroot can now be
    packaged with Nerves systems. The system needs to add `pkg-stats` and/or
    `legal-info` to the make targets to use. This is an experimental update and
    will likely be changed and improved. Note that SBOM info has always been
    available, but it just hasn't been convenient. We're trying to make it more
    accessible.
  * It's now possible to build on aarch64 Linux machines.

## v1.16.1

* Package updates
  * [Erlang/OTP 24.0.3](https://erlang.org/download/OTP-24.0.3.README)
  * [erlinit 1.10.0](https://github.com/nerves-project/erlinit/releases/tag/v1.10.0)
  * [boardid 1.11.1](https://github.com/nerves-project/boardid/releases/tag/v1.11.1)
  * bborg-overlays: bump to latest SHA (device tree updates for BBB)

## v1.16.0

This is a major update to Buildroot 2021.05. Please review the Buildroot release
notification below in addition to the following.

1. The `wpa_supplicant` options in Buildroot changed. If you're using
   `vintage_net_wifi`, you'll need to make sure that the control interface is
   enabled now.  Add the following to your `nerves_defconfig`:

   ```
   BR2_PACKAGE_WPA_SUPPLICANT_CTRL_IFACE=y
   ```

* Package updates
  * [Buildroot 2021.05](http://lists.busybox.net/pipermail/buildroot/2021-June/311946.html)
  * [Erlang/OTP 24.0.2](https://erlang.org/download/OTP-24.0.2.README)
  * Broadcom WiFi firmware for Raspberry Pis 1:20190114-1+rpt11. Despite the
    version number, this is the latest from Raspberry Pi OS.

* Improvements
  * Build Nerves on RISC-V platforms. RISC-V is not officially supported, but
    experiments are ongoing as low cost hardware becomes available.

## v1.15.2

This is a security/bugfix release for Buildroot and Erlang.

* Package updates
  * [Buildroot 2021.02.2](http://lists.busybox.net/pipermail/buildroot/2021-May/310003.html)
  * [Erlang/OTP 23.3.4](https://erlang.org/download/OTP-23.3.4.README)

* Improvements
  * Various shellcheck warning fixes that make paths with spaces work in more
    places. Thanks to @pojiro for this.

## v1.15.1

This is a security/bugfix release for Buildroot and Erlang.

* Package updates
  * [Buildroot 2021.02.1](http://lists.busybox.net/pipermail/buildroot/2021-April/307970.html)
  * [Erlang/OTP 23.3.1](https://erlang.org/download/OTP-23.3.1.README)

## v1.15.0

This is a major update to Buildroot 2021.02. Please review the Buildroot release
notification below in addition to the following. The following changes affect
all systems:

1. The `rngd` daemon's jitter entropy option changed defaults. This daemon feeds
   values from a hardware random number generator to the Linux kernel's entropy
   pool. Without it, you can experience long boot delays as programs wait for
   enough entropy to get good random numbers. Jitter entropy is a way of
   gathering entropy from the CPU without any special random number generation
   hardware. It's not necessary with most hardware with Nerves and it adds a
   boot-time delay as the CPU is measured. Previously it defaulted to off. Now
   you need to add the following to your `nerves_defconfig`:

   ```
   # BR2_PACKAGE_RNG_TOOLS_JITTERENTROPY_LIBRARY is not set
   ```

2. Buildroot changed how it computes hashes over projects downloaded from
   version control systems. If you have made a custom system and added your own
   packages, you may need to update the `.hash` files to `-br1` versions. The
   files are different so the existing checksums will not match. See [buildroot
   5b95a5d](https://git.busybox.net/buildroot/commit/?id=5b95a5dc27c0d8002c00bda1c867ddea9218087e)
   for more info.

3. The `nervesproject/nerves_system_br` Docker image that corresponds to this
   release has been updated from Ubunto 18.04 LTS to Ubuntu 20.04 LTS. This
   fixed an internal compiler error that was seen, but resulted in some package
   changes (no more Python 2, for example) that might affect scripts using it.

* Improvements
  * It's now possible to include executable files for other CPU architectures in
    the root filesystem without have the scrubber find them and report an error.
    To use this feature, add the file `.noscrub` to the directory with the files.

* Package updates
  * [Buildroot 2021.02](http://lists.busybox.net/pipermail/buildroot/2021-March/305168.html)
  * [Erlang/OTP 23.2.7](https://erlang.org/download/OTP-23.2.7.README)

## v1.14.5

This release is a security and bug fix release for Buildroot and Erlang/OTP.

* Improvements
  * Add `CPPFLAGS` for projects that only use the C preprocessor
  * Clear out `PKG_CONFIG_PATH` to avoid confusion with host settings

* Package updates
  * [Buildroot 2020.11.3](http://lists.busybox.net/pipermail/buildroot/2021-February/304041.html)
  * [Erlang/OTP 23.2.5](https://erlang.org/download/OTP-23.2.5.README)

## v1.14.4

This release is primarily a security fix release for Buildroot and Erlang/OTP.

* Package updates
  * [Buildroot 2020.11.2](http://lists.busybox.net/pipermail/buildroot/2021-January/302574.html)
  * [Erlang/OTP 23.2.4](https://erlang.org/download/OTP-23.2.4.README)
  * [boardid 1.11.0](https://github.com/nerves-project/boardid/releases/tag/v1.11.0)

## v1.14.3

* Package updates
  * [nerves_initramfs 0.5.0](https://github.com/nerves-project/nerves_initramfs/releases/tag/v0.5.0)

## v1.14.2

* Package updates
  * [Erlang/OTP 23.2.3](https://erlang.org/download/OTP-23.2.3.README)

## v1.14.1

This is a security fix release that pulls in fixes from Buildroot 2020.11.1 and
Erlang/OTP 23.2.2.

* Package updates
  * [Buildroot 2020.11.1](http://lists.busybox.net/pipermail/buildroot/2020-December/299452.html)
  * [Erlang/OTP 23.2.2](https://erlang.org/download/OTP-23.2.2.README)

## v1.14.0

This is a major update to Buildroot 2020.11. Please review the Buildroot changes
in the release announcement below. Due to a change in how Buildroot handles
U-Boot environment options, all Nerves systems will need to update their
`nerves_defconfig` as follows:

```
-BR2_TARGET_UBOOT_ENVIMAGE=y
-BR2_TARGET_UBOOT_ENVIMAGE_SOURCE="${NERVES_DEFCONFIG_DIR}/uboot/uboot.env"
-BR2_TARGET_UBOOT_ENVIMAGE_SIZE="131072"
BR2_PACKAGE_HOST_UBOOT_TOOLS=y
+BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE=y
+BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SOURCE="${NERVES_DEFCONFIG_DIR}/uboot/uboot.env"
+BR2_PACKAGE_HOST_UBOOT_TOOLS_ENVIMAGE_SIZE="131072"
```

* Package updates
  * [Buildroot 2020.11](http://lists.busybox.net/pipermail/buildroot/2020-December/297705.html)
  * [Erlang/OTP 23.2.1](https://erlang.org/download/OTP-23.2.1.README)

## v1.13.7

* Bug fixes
  * Fix issue where files from Buildroot with spaces in them were not being
    included in SquashFS images. These were reported in the build output, but
    ignored.

## v1.13.6

This is a patch release to bump Erlang and fwup to their latest patch releases.

* Package updates
  * [Erlang/OTP 23.1.5](https://erlang.org/download/OTP-23.1.5.README)
  * [fwup 1.8.3](https://github.com/fhunleth/fwup/releases/tag/v1.8.3)

## v1.13.5

* Bug fixes
  * rpi-userland is now available for Raspberry Pi's in 64-bit mode. This fixes
    pullup/pulldown support in `circuits_gpio` on the RPi4.
  * The Raspberry Pi WiFi firmware is now sourced from the Raspberry Pi OS. This
    fixes a 5 GHz issue that was seen in Japan. It is likely this fixes other
    issues since the Raspberry Pi OS firmware was years newer than the previous
    one.

* New features
  * `erlinit` has an experimental feature for using an overlay filesystem for
    making the root filesystem writable. This makes some hot code update
    experiments possible. See `erlinit` for details.

* Package updates
  * [erlinit 1.9.0](https://github.com/nerves-project/erlinit/releases/tag/v1.9.0)
  * [Buildroot 2020.08.2](http://lists.busybox.net/pipermail/buildroot/2020-November/296830.html)

## v1.13.4

This updates Erlang/OTP to the latest upstream patch release. The `boardid`
update brings in support for ATECCx08A improvements.

* Package updates
  * [Erlang/OTP 23.1.4](https://erlang.org/download/OTP-23.1.4.README)
  * [boardid 1.10.0](https://github.com/nerves-project/boardid/releases/tag/v1.10.0)

## v1.13.3

This release contains a patch update to Buildroot. If you haven't updated to
v1.13.0 yet, please see the `BR2_TOOLCHAIN_EXTERNAL_GCC_9` note before updating
to this release.

The Raspberry Pi support has been updated. This contains an important change to
the `rpi-firmware` package to allow systems to set it appropriately based on
what Linux kernel is in use. Our guidance is to use an `rpi-firmware` version
with the same tag name as the Linux kernel that you're using or to pick a tag
that's close in time. The reason for this is that the `rpi-firmware` package
contains files that seem to be kernel version dependent and subtle things fail
when they're out of sync. See [commit 1da5838
](https://github.com/nerves-project/nerves_system_br/commit/1da5838df34e963c29f1d1d262a490bbb083806e).

* Package updates
  * [Buildroot 2020.08.1](http://lists.busybox.net/pipermail/buildroot/2020-October/294407.html)
  * Raspberry Pi firmware and userland

## v1.13.2

* Package updates
  * [Erlang/OTP 23.1.1](https://erlang.org/download/OTP-23.1.1.README)
  * [erlinit 1.8.0](https://github.com/nerves-project/erlinit/releases/tag/v1.8.0)

## v1.13.1

* Package updates
  * [Erlang/OTP 23.1](https://erlang.org/download/OTP-23.1.README)

* New features
  * Support `*_FOR_BUILD` environment variables. For example `Makefile`s used in
    Elixir projects can reference `CC_FOR_BUILD` to use the host's C compiler
    rather than the crosscompiler. This makes it possible to make build tools
    without hardcoding references to `gcc`, etc. These are the same names as
    those used by autotools.

## v1.13.0

This is a major update to Buildroot 2020.08. Please review the Buildroot change
notes for updated libraries and system programs. In particular, a change to the
gcc version default requires that most Nerves system update their
`nerves_defconfig` files with the following line:

```
BR2_TOOLCHAIN_EXTERNAL_GCC_9=y
```

* Package updates
  * [Buildroot 2020.08](http://lists.busybox.net/pipermail/buildroot/2020-September/290797.html)
  * [Erlang/OTP 23.0.4](https://erlang.org/download/OTP-23.0.4.README)

## v1.12.4

This release starts the migration from using `/root` and the writable
application directory to using `/data`. Currently `/data` is a symlink to
`/root`. Users are encourage to update paths in their programs to `/data` as
makes sense.

* Package updates
  * nerves_heart 0.3.0 - Supports configuration of the watchdog device path via
    `HEART_WATCHDOG_PATH`

## v1.12.3

* Package updates
  * [Buildroot 2020.05.1](http://lists.busybox.net/pipermail/buildroot/2020-July/287824.html)

## v1.12.2

* Package updates
  * [Erlang/OTP 23.0.3](https://erlang.org/download/OTP-23.0.3.README)

* Bug fixes
  * Fixed references to using the `-Os` optimization flag for compiling C and
    C++ code. Nerves uses `-O2` by default everywhere else, so this makes it
    consistent. This will affect the optimization setting for code compiled by
    `elixir_make` unless a project has overridden it.

## v1.12.1

* New packages
  * nerves_initramfs 0.4.0 - Support for failing back to known good firmware
    images and complicated rootfs mounting procedures for devices with limited
    bootloaders.

* Package updates
  * boardid 1.9.0 - Support reading serial numbers from redundant U-Boot
    environment blocks
  * erlinit 1.7.1 - Set $HOME based on `/etc/passwd`. This does not affect most
    Nerves devices.

## v1.12.0

This is a major update that includes Erlang/OTP 23.0.2 and Buildroot 2020.05. If
you cannot upgrade to OTP 23, it is possible to continue using OTP 22 (22.3.4.1)
by creating a custom system with the `BR2_PACKAGE_ERLANG_22` in the Buildroot
configuration.

* Package updates
  * [Buildroot 2020.05](http://lists.busybox.net/pipermail/buildroot/2020-June/283817.html)
  * [Erlang/OTP 23.0.2](https://erlang.org/download/OTP-23.0.2.README)
  * Qt 5.14.2 - This is an update from 5.14.1 that may affect webengine kiosk
    users
  * bb.org overlays - The device tree overlays for the Beaglebone boards has
    been bumped to the latest. This adds support for new Beaglebone boards and
    peripherals.
  * [Raspberry Pi firmware](https://github.com/raspberrypi/firmware/tree/1.20200601) - This
    has been bumped to the 1.2020601 branch. If you have a custom Raspberry Pi
    system, you're encouraged to bump your Linux kernel to the same tag.

## v1.11.3

This is a minor update that bumps Erlang/OTP to 22.3.3 and fwup to 1.7.0. The
fwup update changes the default write behavior to verify every write. This may
detect some rare, but recoverable, MicroSD failures earlier.

* Package updates
  * Erlang/OTP 22.3.3
  * fwup 1.7.0 - verified write support
  * Busybox - include brctl utility (~ 5 KB) to support bridge creation with
    VintageNet

* Bug fixes
  * `:os_mon`'s disk usage monitoring works now. If you're using the Phoenix
    LiveDashboard, disk usage monitoring will show up now.

## v1.11.2

This is a minor update that brings in a patch update to Erlang/OTP (22.3.1) and
initial support for applying delta firmware updates. Delta firmware updates
significantly reduce Nerves firmware images sizes for small code changes. This
contains the building blocks for delta firmware updates. The current process
for creating patches is manual and tooling is not available yet.

* Package updates
  * Erlang/OTP 22.3.1
  * erlinit 1.7.0 - tty initialization support
  * fwup 1.6.0 - xdelta3/VCDIFF patch support

* Improvements
  * Support for the `NERVES_MKSQUASHFS_FLAGS` variable to adjust SquashFS
    filesystem creation to reduce patch size when using `fwup 1.6.0`'s delta
    firmware update support.

## v1.11.1

This release updates Erlang/OTP to the latest official release. It also includes
an update to `fwup` that removes a dependency on `libsodium`. Unless another
package requires it, the `libsodium` shared libraries will no longer be
installed in firmware images. If you are using `libsodium`, double check that
it's enabled in your configuration.

* Package updates
  * Erlang/OTP 22.3
  * erlinit 1.6.1 - Fix for /dev/rootdisk symlink issue on some x86 and
    eMMC-using systems
  * fwup 1.5.2 - Footprint reduction

## v1.11.0

This release updates Buildroot to 2020.02. Buildroot release notes are at
http://lists.busybox.net/pipermail/buildroot/2020-March/276231.html.

* Package updates
  * Erlang/OTP 22.2.8
  * rpi-firmware 1.20200212 - Raspberry Pi-based systems are encouraged to upgrade their Linux kernels to the 1.20200212 versions to match.
  * boardid 1.8.0 - Support for nVidia Jetson Nano and similar boards

* Improvements
  * The default Busybox configuration contains the `mknod` now.
  * The new default Busybox configuration filename is `busybox.config`. The old
    name `busybox-1.22.config` still works, but is a symlink.

## v1.10.3

This release updates Qt so that kiosk projects using Qt Webengine can use a more
recent chromium build. Qt 5.14.1 requires gcc 9.2 (See [Nerves toolchain release
1.3.0](https://github.com/nerves-project/toolchains/releases/tag/v1.3.0)) to get
past an internal compiler error.

* Package updates
  * Erlang/OTP 22.2.6
  * Qt 5.14.1

## v1.10.2

This release fixes a warning and startup delay that was introduced with the
rng-tools update in Buildroot. In v1.10.0, rngd would try jitterentropy even if
the platform has a hwrng. Additionally jitterentropy's sanity checks fail on
platforms like the Raspberry Pi Zero and print error messages to the console.
With this update, jitterentropy must be manually enabled, but this behavior will
change depending of the outcome of
https://bugs.busybox.net/show_bug.cgi?id=12511.

* Package updates
  * Erlang/OTP 22.2.4
  * boardid 1.7.0 - Support for hardcoded serial number prefixes

## v1.10.1

This release pulls in security and bug fixes from Buildroot and Erlang.

* Package updates
  * Buildroot 2019.11.1
  * Erlang/OTP 22.2.3
  * erlinit 1.6.0 - Feature update to support Yocto so no changes for Nerves
    users.
  * boardid 1.6.0 - Support serial numbers stored in DMI/BIOS on x86
  * mesa3d - Experimental update to support the Raspberry Pi 4's V3D driver

## v1.10.0

This release updates Buildroot to 2019.11. Buildroot release notes are at
http://lists.busybox.net/pipermail/buildroot/2019-December/267603.html.

The second major change is to enable dnsd, udhcpd and ifconfig in the default
Busybox configuration. Due to some cleanup, Busybox's footprint actual shrank
this release. However, the new utilities that were enabled make it possible to
support the new
[`vintage_net`](https://github.com/nerves-networking/vintage_net) and
[`vintage_net_wizard`](https://github.com/nerves-networking/vintage_net_wizard)
out of the box.

* Package updates
  * Buildroot 2019.11
  * Erlang/OTP 22.1.8
  * fwup 1.5.1

* Improvements
  * Busybox - Clean default configuration and enable dnsd, udhcpd, and ifconfig

## v1.9.5

This release pulls in security and bug fixes from Buildroot and Erlang.

* Package updates
  * Buildroot 2019.08.2
  * Erlang/OTP 22.1.7
  * fwup 1.5.0 - GPT support, experimental filesystem encryption
  * erlinit 1.5.3 - Bug fix to support Erlang slave nodes

## v1.9.4

* Package updates
  * wpa_supplicant v2.9 - This pull in several security fixes and addresses a
    WPA-EAP crash on Raspberry Pis.
  * bborg-overlays - Update to latest device tree overlays for Beaglebone
    boards.

## v1.9.3

This updates Buildroot to 2019.08.1 which is a security and bug fix update to
2019.08.

* Package updates
  * Buildroot 2019.08.1
  * Erlang/OTP 22.1.1

## v1.9.2

* Bug fixes
  * Fix path length issue when building qt5webengine/chromium on CircleCI

* Package updates
  * erlinit v1.5.2 - Reproducible build support

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
