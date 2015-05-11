# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/u-boot-sunxi.git"

DESCRIPTION="u-boot for Allwinner sunxi series of SoCs (A10, A13, A10s, and A20)"
HOMEPAGE="https://github.com/linux-sunxi/u-boot-sunxi"

SLOT="0"
KEYWORDS=""
IUSE_SUNXI_BOARD="
	sunxi_board_cubieboard
	sunxi_board_cubieboard2
	sunxi_board_cubietruck
"
IUSE="${IUSE_SUNXI_BOARD}"
REQUIRED_USE="^^ ( ${IUSE_SUNXI_BOARD} )"

src_prepare() {
	emake distclean
}

src_configure() {
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

	emake ${board}_config
}

src_install() {
	insinto "/usr/share/${PF}"
	doins u-boot-sunxi-with-spl.bin
	dodoc doc/README.* "${FILESDIR}/installing-u-boot.txt"
}
