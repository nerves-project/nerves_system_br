# Custom U-Boot startup script for Nerves

# This script is invoked from the default AM335x build script
# in "<uboot>/include/configs/am335x_evm.h". In the default build
# script, look for `mmcboot` and its invocation of `loadbootscript`.

# It has been simplified to just support the Nerves use cases.
# Most importantly, it will not fallback to the alternate boot location
# like the default script. If you have it installed on the eMMC
# and you want to boot from the SDCard, you must hold down the USER/BOOT
# button. I usually wipe out the eMMC image when working with SDCard
# images to avoid this issue.

echo "Running Nerves U-Boot script"

# Kernel arguments and arguments to erlinit are passed here
# The erlinit arguments can just be tacked on to the end.
# For example, add "-v" to the end to put erlinit into verbose
# mode.

# When debugging, create a uEnv.txt file in the BOOT partition
# to override these arguments. For example, if you want the
# kernel debug messages, put this in a uEnv.txt:
#   optargs="capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN uio_pruss.extram_pool_sz=0x100000"

env set optargs "quiet capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN uio_pruss.extram_pool_sz=0x100000"

# Allow the user to override the kernel/erlinit arguments
# via a "uEnv.txt" file in the FAT partition.
if load mmc ${mmcdev}:1 ${loadaddr} uEnv.txt; then
    echo "uEnv.txt found. Overriding environment."
    env import -t -r ${loadaddr} ${filesize}

    # Check if the user provided a set of commands to run
    if test -n $uenvcmd; then
        echo "Running uenvcmd..."
        run uenvcmd
    fi
fi

# Determine the boot arguments
#
# Note the root filesystem specification. In Linux, /dev/mmcblk0 is always
# the boot device. In uboot, mmc 0 is the SDCard and mmc 1 is the eMMC.
# Therefore, we hardcode root=/dev/mmcblk0p2 since we always want to mount
# the root partition off the same device that ran u-boot and supplied
# zImage.
setenv bootargs console=${console} ${optargs} root=/dev/mmcblk0p2 rootfstype=squashfs ro rootwait

# Load the kernel
load mmc ${mmcdev}:1 ${loadaddr} zImage

# Load the DT. On the BBB, fdtfile=am335x-boneblack.dtb
load mmc ${mmcdev}:1 ${fdtaddr} ${fdtfile}

# Boot!!
bootz ${loadaddr} - ${fdtaddr}

echo "Nerves boot failed!"
