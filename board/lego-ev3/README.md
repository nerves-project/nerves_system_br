# Lego EV3 Support

This port is based off [ev3dev](http://http://www.ev3dev.org) and pulls in
patches to Buildroot from the [ev3dev buildroot](https://github.com/ev3dev/buildroot).

## modprobe

The following kernel modules must be loaded:

```
modprobe suart_emu
modprobe legoev3_ports
modprobe snd_legoev3
modprobe legoev3_battery
modprobe legoev3_bluetooth
```

## SDCard vs. internal NAND Flash

The EV3 brick has a 16 MB NAND Flash inside it that's connected to SPI bus 0.
It doesn't look like the ev3dev project has included support for it yet except
in their version of u-boot. The means that it can only be programmed using the
Lego supplied tools. The 16 MB NAND Flash also has a couple other issues. First,
it appears to be super slow. This leads to them copying the whole image to
DRAM instead of reading it as needed. It appears that this uses up 10 MB of
DRAM compared to running off the SDCard. This is significant when you consider
that the board only has 64 MB total DRAM. On the other hand, programming the
internal NAND Flash is cool and the direction that we'd prefer to go on
production systems.

Currently, the u-boot in the internal NAND Flash that's supplied by Lego and the
ev3dev project expects the `uImage` in the first VFAT partition. Ideally, it
would extract it out of the rootfs so that we could implement more atomic
firmware updates. To avoid the need to reflash the firmware to use Nerves, I'm
staying with the existing mechanism.

## Console access

The EV3 brick provides console access via Port 1. This shows up as `/dev/ttyS1`
on the device. To access it, you'll need a "Lego FTDI adapter" like the one at
http://www.mindsensors.com/ev3-and-nxt/40-console-adapter-for-ev3. If you have
extra cables and an 3.3V FTDI cable, then you can make your own. See
http://botbench.com/blog/2013/08/15/ev3-creating-console-cable/.

It is important to check the file `/etc/modprobe.d/ev3.conf` to disable port 1.
If you don't do this, when you `modprobe` the `legoev3_ports` driver, port 1
will stop being the console. The important line in the file is:

    options legoev3_ports disable_in_port=1

## Wired Ethernet

If you have a USB Ethernet adapter, find the driver for it on your PC. For
example, plug it in and check `dmesg` and `lsmod` to see which driver it loads.
In my case, I have an adapter that loads the `asix` driver. Make sure that your
driver is compiled in as a module to the Linux kernel in Nerves and then
manually load the driver via `modprobe asix`.
