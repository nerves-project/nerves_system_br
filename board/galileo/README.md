# Intel Galileo Gen 2

The Intel Galileo Gen 2 is a Intel Quark X1000 board with a Arduino-style connector. The X1000 is a single
core, single thread x86 processor running at 400 MHz.

After the board boots, you must load several kernel modules to use the peripherals:

```
:os.cmd('modprobe intel_qrk_gip')
:os.cmd('modprobe gpio-pca953x')
:os.cmd('modprobe pca9685')
:os.cmd('modprobe adc1x8s102')
```

If you have an Intel Galileo Gen 1, it may work but is untested. Try loading the following:

```
:os.cmd('modprobe intel_qrk_gip')
:os.cmd('modprobe cy8c9540a')
:os.cmd('modprobe ad7298')
```

## Processor bug

The X1000 has a bug on the lock prefix requiring that prefix must be stripped at build time.
It is important that the following parameter is passed to `gcc` to do this:

    -Wa,-momit-lock-prefix=yes

Buildroot does this automatically, but Nerves doesn't pass the parameter around yet.
