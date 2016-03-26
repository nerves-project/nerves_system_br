This will build an image that can be run on an ARM Versatile Express. It requires
further configuration of qemu to be useful especially regarding networking.

This may get you started if you are interested in this configuration before
we can provide better instructions:

qemu-system-arm -M vexpress-a9 -smp 1 -m 256 -kernel images/zImage -dtb images/vexpress-v2p-ca9.dtb -drive file=images/rootfs.ext2,if=sd,format=raw -append "console=ttyAMA0,115200 root=/dev/mmcblk0" -serial stdio -net nic,model=lan9118 -net user

