include $(TOPDIR)/rules.mk

PKG_NAME:=usbgadget
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/usbgadget
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Utility for USB gadgets configuration
endef

define Package/usbgadget/conffiles
/etc/config/usbgadget
endef

define Package/usbgadget/description
 This package contains a small script which could be used for
 configuration of USB gadgets over configfs kernel interface.
endef

define Build/Compile
endef

define Package/usbgadget/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/usbgadget.init $(1)/etc/init.d/usbgadget
	$(INSTALL_DATA) ./files/usbgadget.config $(1)/etc/config/usbgadget
endef

$(eval $(call BuildPackage,usbgadget))
