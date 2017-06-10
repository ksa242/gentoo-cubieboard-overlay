EAPI="5"

inherit eutils savedconfig

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
IUSE="savedconfig ${IUSE_SUNXI_BOARD}"
REQUIRED_USE="^^ ( ${IUSE_SUNXI_BOARD} )"

DEPEND=">=sys-apps/dtc-1.4
		sys-devel/bc"
RDEPEND="~dev-embedded/u-boot-tools-${PV}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	ewarn "The compilation of this package will probably break if compiled"
	ewarn "using DISTCC on machine with different arch. Because of that it is"
	ewarn "recommended to temporarily disable DISTCC."

	epatch_user
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
	restore_config .config

	einfo "Enabling old linux-sunxi kernel support"
	local param
	for param in ARMV7_BOOT_SEC_DEFAULT OLD_SUNXI_KERNEL_COMPAT ; do
		sed -i "s/# CONFIG_${param} is not set/CONFIG_${param}=y/" .config
	done
	emake
}

src_install() {
	insinto "/usr/share/${PF}"
	doins u-boot-sunxi-with-spl.bin
	dodoc doc/README.* "${FILESDIR}/installing-u-boot.txt"
	save_config .config
}

pkg_postinst() {
	einfo "This package has prepared a flashable image suitable for both"
	einfo "mainline kernel and old linux-sunxi kernel."
	einfo
	einfo "If your kernel complains about machine ID mismatch please add"
	einfo "appropriate 'setenv machid 0xXXXXXX' to boot.cmd/boot.scr."
}
