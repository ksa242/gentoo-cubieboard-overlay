
EAPI="5"

MY_P="u-boot-${PV/_/-}"
DESCRIPTION="Das U-Boot (mainline variant)"
HOMEPAGE="http://www.denx.de/wiki/U-Boot/WebHome"
SRC_URI="ftp://ftp.denx.de/pub/u-boot/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE_SUNXI_BOARD="
	sunxi_board_cubieboard
	sunxi_board_cubieboard2
	sunxi_board_cubietruck
"
IUSE="${IUSE_SUNXI_BOARD}"
REQUIRED_USE="^^ ( ${IUSE_SUNXI_BOARD} )"

RDEPEND="~dev-embedded/u-boot-tools-${PV}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	einfo "The compilation of this package will probably break if compiled"
	einfo "using DISTCC on machine with different arch. Because of that it is"
	einfo "recommended to temporary disable DISTCC."

	emake distclean
}

src_compile() {
	# Unset a few KBUILD variables. Bug #540476
	unset KBUILD_OUTPUT KBUILD_SRC

	local board
	if use sunxi_board_cubieboard; then
		board="Cubieboard"
	elif use sunxi_board_cubieboard2; then
		board="Cubieboard2"
	elif use sunxi_board_cubietruck; then
		board="Cubietruck"
	else
		die "Please choose your board."
	fi

	emake ${board}_defconfig

	einfo "Building u-boot for mainline kernel."
	emake
	mv u-boot-sunxi-with-spl.bin u-boot-sunxi-with-spl_mainline-kernel.bin

	einfo "Building u-boot for old linux-sunxi kernel."
	local param
	for param in ARMV7_BOOT_SEC_DEFAULT OLD_SUNXI_KERNEL_COMPAT ; do
		sed -i "s/# CONFIG_${param} is not set/CONFIG_${param}=y/" .config
	done
	emake
	mv u-boot-sunxi-with-spl.bin u-boot-sunxi-with-spl_sunxi-kernel.bin
}

src_install() {
	insinto "/usr/share/${PF}"
	doins u-boot-sunxi-with-spl_mainline-kernel.bin
	doins u-boot-sunxi-with-spl_sunxi-kernel.bin
	dodoc doc/README.* "${FILESDIR}/installing-u-boot.txt"
}

pkg_postinst() {
	einfo "This package has prepared two flashable images. Please use"
	einfo "the one corresponding to your kernel."
	einfo
	einfo "If your kernel complain about machine ID mismatch please"
	einfo "add appropriate 'setenv machid 0xXXXXXX' to boot.cmd/boot.scr."
}
