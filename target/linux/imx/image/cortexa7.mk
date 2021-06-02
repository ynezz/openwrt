DEVICE_VARS += UBOOT

include common.mk

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

define Device/technexion_imx7d-pico-pi
  DEVICE_VENDOR := TechNexion
  DEVICE_MODEL := PICO-PI-IMX7D
  UBOOT := pico-pi-imx7d
  DEVICE_DTS := imx7d-pico-pi
  DEVICE_PACKAGES := kmod-sound-core kmod-sound-soc-imx kmod-sound-soc-imx-sgtl5000 \
	kmod-can kmod-can-flexcan kmod-can-raw kmod-leds-gpio \
	kmod-input-touchscreen-edt-ft5x06 kmod-usb-hid kmod-btsdio \
	kmod-brcmfmac cypress-firmware-4339-sdio cypress-nvram-4339-pico-pi-imx7d
  FILESYSTEMS := squashfs
  IMAGES := combined.bin sysupgrade.bin
  IMAGE/combined.bin := append-rootfs | pad-extra 128k | imx-sdcard-raw-uboot
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += technexion_imx7d-pico-pi

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
