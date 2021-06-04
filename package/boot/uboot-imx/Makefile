#
# Copyright (C) 2013-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_VERSION:=2021.07-rc3
PKG_RELEASE:=1

PKG_HASH:=1f64505dfb83bf63f3bf335bc4c284d1414caaf0f421d23fe3d9baddae086203

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx
  UBOOT_IMAGE:=u-boot.imx
endef

define U-Boot/apalis_imx6
  NAME:=Toradex Apalis
  UBOOT_IMAGE:=SPL u-boot.img u-boot-with-spl.imx
  UBOOT_MAKE_FLAGS:=SPL u-boot.img u-boot-with-spl.imx
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=toradex_apalis
endef

define U-Boot/colibri-imx6ull
  NAME:=Toradex Colibri iMX6ULL
  UBOOT_IMAGE:=u-boot-nand.imx
  UBOOT_MAKE_FLAGS:=u-boot-nand.imx
  BUILD_SUBTARGET:=cortexa7
  BUILD_DEVICES:=colibri-imx6ull
endef

define U-Boot/mx6cuboxi
  NAME:=SolidRun Cubox-i boards
  UBOOT_IMAGE:=SPL u-boot.img
  UBOOT_MAKE_FLAGS:=SPL u-boot.img
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=solidrun_cubox-i
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=wandboard_dual
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	colibri-imx6ull \
	mx6cuboxi \
	wandboard

UBOOT_MAKE_FLAGS += u-boot.imx

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(foreach img,$(UBOOT_IMAGE), \
		$(CP) $(PKG_BUILD_DIR)/$(img) $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-$(img); \
	)
endef

$(eval $(call BuildPackage/U-Boot))
