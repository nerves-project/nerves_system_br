This directory contains nerves configurations that have not been updated
and won't build or run without some effort. They may be of use to some
one so that weren't deleted.

### ag150_defconfig and alix_defconfig

These are 32-bit x86 platforms. The ag150 is Intel Atom-based and the Alix uses
an AMD Geode CPU. Both are minimal system configurations that use Syslinux
as the bootloader.

If you need to run on an x86-based platform, please contact us about putting
together a cross-compiler so that we can support it similar to other systems.

### nerves_camera_defconfig

This is the configuration that I'm using for my camera project. Normally
it wouldn't be a part of Nerves, but it may be useful to others as
an example. It requires a custom cape for the BeagleBone Black and uses the
AM3359's PRU for the hard real-time parts of the project. Erlang is used
for the rest.

### nerves_rpi_elixirbot_defconfig

This configuration was used for Frank Hunleth's Erlang Factory 2015
presentation. See https://github.com/fhunleth/elixirbot.

### nerves_bbb_wifi_defconfig

This configuration is a work-in-progress to support wifi within the Nerves
environment. It is currently setup to support a Rosewill RNX-N150UBE (Realtek
rtl8712 driver). To test, try run the following programs (using `os:cmd/1`):

```
modprobe musb_dsps
ip link set wlan0 up
iwlist wlan0 scan
[use wpa_passphrase to generate a configuration for the wpa_supplicant]
wpa_supplicant -i wlan0 -c /tmp/wifi.conf
ip addr add 192.168.1.40/24 dev wlan0
```