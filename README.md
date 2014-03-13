# Nerves SDK
[![Build Status](https://travis-ci.org/nerves-project/nerves-sdk.png?branch=master)](https://travis-ci.org/nerves-project/nerves-sdk)

Build the cross-compiler, various tools, and the base root filesystem
for creating embedded firmware images from Erlang/OTP releases. This
project uses [Buildroot](http://buildroot.net/) to do all of the hard
work. It just provides a configuration and a few helper scripts and
patches to customize Buildroot for Erlang/OTP embedded projects.

Currently, the BeagleBone Black is the only supported platform. This
can be changed by adding new configurations to the `configs` directory and
referencing them from the Makefile.

## First time build

Before building the SDK, it is important to have a few build tools
already installed. Buildroot provides a lot, but it does depend on
a few host programs. If using Ubuntu, run the following:

    sudo apt-get install git g++ libssl-dev bc

    # If your system is 64-bit, also run this
	sudo apt-get install libc6:i386 libstdc++6:i386 zlib1g:i386 gcc-multilib

From there, change to the nerves-sdk directory and run:

    make

The first time build takes a while since it has to download and
build lot of code. For the most part, you will not need to rebuild
the SDK unless you require a library or other application that
cannot be pulled in by `rebar`.

## Using the SDK

In order to use the cross-compiler and the version of Erlang built by
Buildroot, you'll need to source a shell script to update various
environment settings.

    source ./nerves-env.sh

This step has to be done each time you launch a shell. If you use
the SDK regularly, it may be convenient to add this to your `.bashrc`.

The key environment settings updated by the script are the `PATH`
variable and a set of variables that direct `rebar` to invoke the
cross-compiler.

## Updating the SDK

If it turns out that you need another library or application on
your target that can't be pulled in with `rebar`, you'll need
to update the Buildroot configuration. Luckily, Buildroot comes
with recipes for cross-compiling tons of packages. To change the
configuration, first run the Buildroot configuration utility from
the nerves-sdk directory:

    make menuconfig

You'll probably be interested in the "Package Selection for the target"
menu option. After you're done, run `make` to rebuild the SDK. If you
want to save your set of options permanently, you'll need to copy
`buildroot/defconfig` to the `configs` directory.

Be aware that Buildroot caches the root filesystem between builds
and that when you unselect a configuration option, it will not
disappear from the Nerves SDK root file system image until a clean
build.

## Built-in SDK Configurations

Nerves comes with several configurations out of the box. These can be
used directly or just as an examples for your own custom configuration.

### nerves_bbb_defconfig

This is the default configuration for building images on the Beaglebone
Black. It is a minimal image intended for applications that do not require
a lot of hardware or C library support.

### bbb_linux_defconfig

This configuration produces a Linux image. It is not useful for Erlang
development, but it can be helpful when getting unfamiliar hardware to work.
I use it to debug Linux kernel issues since most documentation and
developers expect a traditional shell-based environment.

### nerves_camera_defconfig

This is the configuration that I'm using for my camera project. Normally
it wouldn't be a part of the Nerves SDK, but it may be useful to others as
an example. It requires a custom cape for the BeagleBone Black and uses the
AM3359's PRU for the hard real-time parts of the project. Erlang is used
for the rest.

### nerves_bbb_wifi_defconfig

This configuration is a work-in-progress to support wifi within the Nerves
environment. It is currently setup to support a Rosewill RNX-N150UBE (Realtek
rtl8712 driver). To test, try run the following programs:

```
modprobe musb_dsps
ip link set wlan0 up
iwlist wlan0 scan
[use wpa_passphrase to generate a configuration for the wpa_supplicant]
wpa_supplicant -i wlan0 -c /tmp/wifi.conf
ip addr add 192.168.1.40/24 dev wlan0
```

