define Device/Default
  PROFILES := Default
  FILESYSTEMS := squashfs ext4
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := zImage
  KERNEL := kernel-bin | uImage none
  KERNEL_LOADADDR := 0x80008000
  IMAGES :=
endef


define Device/toradex_colibri-imx6ull-aster
  DEVICE_VENDOR := Toradex
  DEVICE_MODEL := Colibri iMX6ULL Aster
  DEVICE_DTS := imx6ull-colibri-aster
  DEVICE_PACKAGES := \
	kmod-can kmod-can-flexcan kmod-can-raw \
	kmod-leds-gpio kmod-gpio-button-hotplug \
	kmod-pps-gpio kmod-rtc-ds1307
  FILESYSTEMS := squashfs
  KERNEL = kernel-bin | fit none $$(DTS_DIR)/$$(DEVICE_DTS).dtb
  KERNEL_SUFFIX := -fit-zImage.itb
  KERNEL_INITRAMFS := kernel-bin | gzip | \
	fit gzip $$(DTS_DIR)/$$(DEVICE_DTS).dtb with-initrd
  PAGESIZE := 2048
  BLOCKSIZE := 128k
  KERNEL_SIZE := 4096k
  KERNEL_IN_UBI := 1
  IMAGES := factory.bin sysupgrade.tar
  IMAGE/sysupgrade.tar := sysupgrade-tar | append-metadata
  IMAGE/factory.bin := append-ubi
  SUPPORTED_DEVICES := toradex,colibri-imx6ull-aster
endef
TARGET_DEVICES += toradex_colibri-imx6ull-aster
