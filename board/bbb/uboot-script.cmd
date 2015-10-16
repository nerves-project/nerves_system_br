env set loadfdt "load mmc 0:1 ${fdtaddr} ${fdtfile}"
env set loadimage "load mmc 0:1 ${loadaddr} ${bootfile}"
env set mmcroot "/dev/mmcblk0p2 ro"
env set mmcrootfstype "squashfs rootwait"
env set optargs "quiet capemgr.disable_partno=BB-BONELT-HDMI,BB-BONELT-HDMIN uio_pruss.extram_pool_sz=0x100000"

