# nerves-id

This program looks up a platform-specific identifier and prints it out. This is
useful for generating unique hostnames so that multiple boards containing the
same firmware don't all show up with the same name.

It really seems like someone would have already have written a program that does
this, but I couldn't find it with some google searching. If that program exists
and isn't a bear to integrate into Buildroot, please let me know so that I can
use it instead.

Currently this only works with the Raspberry Pi.
