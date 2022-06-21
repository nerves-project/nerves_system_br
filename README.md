# nerves_system_br

[![CircleCI](https://circleci.com/gh/nerves-project/nerves_system_br.svg?style=svg)](https://circleci.com/gh/nerves-project/nerves_system_br)
[![Hex version](https://img.shields.io/hexpm/v/nerves_system_br.svg "Hex version")](https://hex.pm/packages/nerves_system_br)

Nerves System BR provides the common logic for building Nerves Systems using
[Buildroot](https://buildroot.org/). If you're new to Nerves, you probably don't
want to look at this repository. Please check out the official
[documentation](https://hexdocs.pm/nerves/getting-started.html).

For examples of using `nerves_system_br`, take a look at the officially
supported hardware systems:

* [Beaglebones](https://github.com/nerves-project/nerves_system_bbb)
* [Raspberry Pi Zero](https://github.com/nerves-project/nerves_system_rpi0)
* [Raspberry Pi Zero, A+, B and B+](https://github.com/nerves-project/nerves_system_rpi)
* [Raspberry Pi 2 Model B](https://github.com/nerves-project/nerves_system_rpi2)
* [Raspberry Pi 3 Model B and B+](https://github.com/nerves-project/nerves_system_rpi3)
* [Raspberry Pi 3 Model A+](https://github.com/nerves-project/nerves_system_rpi3a)
* [Raspberry Pi 4 Model B](https://github.com/nerves-project/nerves_system_rpi4)
* [OSD32MP1](https://github.com/nerves-project/nerves_system_osd32mp1)
* [Generic x86_64](https://github.com/nerves-project/nerves_system_x86_64)
* [GRiSP 2](https://github.com/nerves-project/nerves_system_grisp2)

We only officially support easily obtained hardware, but that doesn't mean that
Nerves only works on these boards. If it's possible to use Buildroot to create a
Linux root filesystem for your hardware, then it's possible that Nerves can be
made to run. The general steps to supporting a new board are the following:

1. Create a minimal Buildroot `defconfig` that boots and runs on the board. This
   doesn't use Nerves at all.
2. If the `defconfig` requires a writable root filesystem, figure out how to
   make it read-only. This should be pretty easy unless you're using `systemd`.
   Since Nerves uses a custom init system, keep in mind for later that `systemd`
   may be helping initialize something on the board that will need to be done
   manually later.
3. Take a look at the Flash memory layout and compare that to the layouts used
   in one of the supported systems. We use
   [fwup](https://github.com/fhunleth/fwup) to create images. There's a lot of
   variety in how one can lay out Flash memory and deal with things like
   failbacks.  At this point, just see if you can get `fwup` to create an image.
4. Clone one of the official systems that seems close for your board. Update
   the `nerves_defconfig` based on the Buildroot `defconfig` that works.
5. Build the system using `mix` or manually by running the `create-build.sh`
   script.

## Non-mix way of using Nerves

It is highly recommended that all users follow the official documentation on
using systems. However, advanced users have found the information to be helpful,
so it hasn't been deleted. This ONLY works on Linux.

After you have manually built Nerves, activate it before running any Elixir or
Erlang build tools on your application.

    source build/nerves-env.sh

In the above line, substitute `build` for whatever directory was used to build
the Nerve System. If you downloaded a pre-built Nerves System, source the
`nerves-env.sh` inside of it. When using a rebuilt system, the crosscompiler
toolchain must also be downloaded. See the
[toolchains project](https://github.com/nerves-project/toolchains).  As stated
before, the Nerves `mix` integration takes care of this for you.

This step has to be done each time you launch a shell. The key environment
settings updated by the script are the `PATH` variable and a set of variables
that direct build tools such as `rebar`, `mix`, `relx`, and other `Makefiles` to
invoke the cross-compiler.

## Enabling a native library or application

Buildroot comes with support for a zillion C libraries and applications. Nerves
enables the minimum number of packages to keep the base system image small.
Examples of packages that you may want to add are things like graphics and UI
frameworks, command line utilities, databases, and file system utilities. To
browse available packages, go to your build directory and run:

    make menuconfig

If you can't find a package, try typing `/` to search for it. After you have
enabled a package, save your changes and exit menuconfig. The changes are saved
to the `.config` file in your build directory. To save them to your system's
`nerves_defconfig` file, run `make savedefconfig`.

Enabling an application or library is only part of the process to getting it to
work. If that package needs to write to the filesystem, it may need to be
configured to write to `/root` or another location since Nerves keeps the root
filesystem readonly.  This is done on purpose to avoid corrupting the root
filesystem.

Be aware that Buildroot caches the root filesystem between builds and that when
you deselect a configuration option, it will not disappear from the Nerves root
file system image until a clean build.

### Enabling a Linux kernel driver

If you have a piece of hardware that requires a special Linux driver that isn't
enabled by default, run:

    make linux-menuconfig

This will let you config kernel options. When done, save and exit. Like before,
the configuration is saved to your build directory. To make the change
permanent, run `make linux-update-defconfig`.

### Enabling simple commandline utilities

If you're looking for many standard commandline utilities like `ls(1)`, `dd(1)`,
`cat(1)`, etc., they'll be in a package called Busybox. Nerves disables most of
them since it uses the Erlang, Elixir, or LFE shells. To enable more of them,
run:

    make busybox-menuconfig

Just like the other configuration menus, when you exit menuconfig, the options
will only be stored in your build directory. To make them permanent, save the
`.config` (see `build/busybox-*/.config`) to your configuration directory. You
will need to run `make menuconfig` to update the location of the Busybox
configuration.
