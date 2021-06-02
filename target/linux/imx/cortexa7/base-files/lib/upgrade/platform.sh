. /lib/imx.sh

RAMFS_COPY_BIN='blkid jffs2reset'

enable_image_metadata_check() {
	case "$(board_name)" in
	technexion,imx7d-pico-pi|\
	toradex,colibri-imx6ull-aster)
		REQUIRE_IMAGE_METADATA=1
		;;
	esac
}
enable_image_metadata_check

platform_check_image() {
	local board=$(board_name)

	case "$board" in
	technexion,imx7d-pico-pi|\
	toradex,colibri-imx6ull-aster)
		return 0
		;;
	esac

	echo "Sysupgrade is not yet supported on $board."
	return 1
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	technexion,imx7d-pico-pi)
		imx_sdcard_do_upgrade "$1"
		;;
	toradex,colibri-imx6ull-aster)
		nand_do_upgrade "$1"
		;;
	esac
}

platform_copy_config() {
	local board=$(board_name)

	case "$board" in
	technexion,imx7d-pico-pi)
		imx_sdcard_copy_config
		;;
	esac
}

platform_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	technexion,imx7d-pico-pi)
		imx_sdcard_pre_upgrade
		;;
	esac
}
