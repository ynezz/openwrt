#
# Copyright (C) 2006-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME := firmware-utils

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/kernel.mk

define cc
	$(HOSTCC) \
		$(HOST_CFLAGS) \
		-Wall -Werror -Wextra \
		-Wno-unused-parameter \
		-include endian.h $(HOST_LDFLAGS) \
		-o $(HOST_BUILD_DIR)/bin/$(firstword $(1)) \
		$(foreach src,$(1),src/$(src).c) \
		$(2)
endef

define Host/Compile
	mkdir -p $(HOST_BUILD_DIR)/bin
	$(call cc,add_header)
	$(call cc,addpattern)
	$(call cc,asustrx)
	$(call cc,buffalo-enc buffalo-lib)
	$(call cc,buffalo-tag buffalo-lib)
	$(call cc,buffalo-tftp buffalo-lib)
	$(call cc,dgfirmware)
	$(call cc,dgn3500sum)
	$(call cc,dns313-header)
	$(call cc,edimax_fw_header)
	$(call cc,encode_crc)
	$(call cc,fix-u-media-header cyg_crc32)
	$(call cc,hcsmakeimage bcmalgo)
	$(call cc,imagetag imagetag_cmdline cyg_crc32)
	$(call cc,jcgimage, -lz)
	$(call cc,lzma2eva,-lz)
	$(call cc,makeamitbin)
	$(call cc,mkbrncmdline)
	$(call cc,mkbrnimg)
	$(call cc,mkbuffaloimg)
	$(call cc,mkcameofw)
	$(call cc,mkcasfw)
	$(call cc,mkchkimg)
	$(call cc,mkcsysimg)
	$(call cc,mkdapimg)
	$(call cc,mkdapimg2)
	$(call cc,mkdhpimg buffalo-lib)
	$(call cc,mkdlinkfw mkdlinkfw-lib, -lz --std=c99)
	$(call cc,mkdniimg)
	$(call cc,mkedimaximg)
	$(call cc,mkfwimage2,-lz)
	$(call cc,mkfwimage,-lz -D_FILE_OFFSET_BITS=64)
	$(call cc,mkheader_gemtek,-lz)
	$(call cc,mkhilinkfw, -lcrypto)
	$(call cc,mkmerakifw-old)
	$(call cc,mkmerakifw sha1)
	$(call cc,mkmylofw)
	$(call cc,mkplanexfw sha1)
	$(call cc,mkporayfw)
	$(call cc,mkrasimage, --std=gnu99)
	$(call cc,mkrtn56uimg, -lz)
	$(call cc,mksenaofw md5, --std=gnu99)
	$(call cc,mksercommfw)
	$(call cc,mktitanimg)
	$(call cc,mktplinkfw2 mktplinkfw-lib md5, -fgnu89-inline)
	$(call cc,mktplinkfw mktplinkfw-lib md5, -fgnu89-inline)
	$(call cc,mkwrggimg md5)
	$(call cc,mkwrgimg md5)
	$(call cc,mkzcfw cyg_crc32)
	$(call cc,mkzynfw)
	$(call cc,motorola-bin)
	$(call cc,nand_ecc)
	$(call cc,nec-enc, --std=gnu99)
	$(call cc,osbridge-crc)
	$(call cc,oseama md5)
	$(call cc,otrx)
	$(call cc,pc1crypt)
	$(call cc,ptgen)
	$(call cc,seama md5)
	$(call cc,spw303v)
	$(call cc,srec2bin)
	$(call cc,tplink-safeloader md5, --std=gnu99)
	$(call cc,trx)
	$(call cc,trx2edips)
	$(call cc,trx2usr)
	$(call cc,wrt400n cyg_crc32)
	$(call cc,xorimage)
	$(call cc,zyimage)
	$(call cc,zyxbcm)
endef

define Host/Install
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/bin/* $(STAGING_DIR_HOST)/bin/
endef

$(eval $(call HostBuild))
