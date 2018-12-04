#
# Copyright (C) 2006-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libgpiod
PKG_VERSION:=1.2
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/
PKG_HASH:=0e26acb2294e55001fd30cc194a7a1ace9bc7211231a8b8c88112ca51f71f647

PKG_MAINTAINER:=Petr Štetiar <ynezz@true.cz>
PKG_LICENSE:=LGPL-2.1+
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:libgpiod_project:libgpiod

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

DISABLE_NLS:=

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=C library for interacting with the linux GPIO character device
  URL:=https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git
endef

define Package/$(PKG_NAME)-tools
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Set of tools from libgpiod for interacting with the GPIO char device
  URL:=https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git
  DEPENDS:=+libgpiod
endef

define Package/$(PKG_NAME)/description
  Since linux 4.8 the GPIO sysfs interface is deprecated. User space should use
  the character device instead. This library encapsulates the ioctl calls and
  data structures behind a straightforward API.

  The new character device interface guarantees all allocated resources are
  freed after closing the device file descriptor and adds several new features
  that are not present in the obsolete sysfs interface (like event polling,
  setting/reading multiple values at once or open-source and open-drain GPIOs).

  Unfortunately interacting with the linux device file can no longer be done
  using only standard command-line tools. This is the reason for creating a
  library encapsulating the cumbersome, ioctl-based kernel-userspace interaction
  in a set of convenient functions and opaque data structures.
endef

define Package/$(PKG_NAME)-tools/description
  $(call Package/$(PKG_NAME)/description)

  Additionally this project contains a set of command-line tools that should
  allow an easy conversion of user scripts to using the character device.
endef

CONFIGURE_ARGS += \
	--enable-tools

MAKE_FLAGS += \
	CFLAGS="$(TARGET_CFLAGS)"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgpiod.{la,a,so}* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libgpiod.pc $(1)/usr/lib/pkgconfig/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libgpiod.so* $(1)/usr/lib/
endef

define Package/$(PKG_NAME)-tools/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin/
endef

$(eval $(call BuildPackage,libgpiod))
$(eval $(call BuildPackage,libgpiod-tools))
