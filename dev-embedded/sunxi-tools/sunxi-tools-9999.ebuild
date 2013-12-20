# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/sunxi-tools.git"
[[ ${PV} == *9999* ]] || EGIT_BRANCH="v${PV/.0/}"

DESCRIPTION="Tools to help hacking Allwinner A10 devices"
HOMEPAGE="https://github.com/linux-sunxi/sunxi-tools http://linux-sunxi.org/"

SLOT="0"
[[ ${PV} == *9999* ]] || KEYWORDS="~arm"
IUSE=""

src_compile() {
	emake "CC=${CHOST}-gcc"
}

src_install() {
	dobin fexc bin2fex fex2bin bootinfo fel pio nand-part
	dodoc COPYING README
}
