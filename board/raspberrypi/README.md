The Raspberry Pi supports showing the console on either the HDMI output
or the UART pins on the GPIO connector. To use the HDMI port, make sure
to configure the tty to go to tty1. To use the UART pins, set the tty to
ttyAMA0. Run `make menuconfig`, and go to `User-provided options` and then
set the console port in the `nerves-config` section. Alternatively, create
your own erlinit.config file and copy it to the target via the
`Root filesystem overlay directory` feature of Buildroot.
