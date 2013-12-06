# Nerves SDK

Build the cross-compiler, various tools, and the base root filesystem
for creating embedded firmware images from Erlang/OTP releases. This
project uses [Buildroot](http://buildroot.net/) to do all of the hard
work. It just provides a configuration and a few helper scripts and
patches to customize Buildroot for Erlang/OTP embedded projects.

Currently, the BeagleBone Black is the only supported platform. This
can me changed by adding new configurations to the br-configs and
referencing them from the Makefile.

## First time build

Before building the SDK, it is important to have a few build tools
already installed. Buildroot provides a lot, but it does depend on
a few host programs. If using Ubuntu, run the following:

    sudo apt-get install git g++ libssl-dev

    # If your system is 64-bit, also run this
	sudo apt-get install libc6:i386 libstdc++6:i386 zlib1g:i386

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
`buildroot/defconfig` to the `br-configs` directory.

Be aware that Buildroot caches the root filesystem between builds
and that when you unselect a configuration option, it will not
disappear from the Nerves SDK root file system image until a clean
build.
