# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/libvdpau-sunxi.git"

DESCRIPTION="Experimental VDPAU for Allwinner sunxi SoCs"
HOMEPAGE="https://github.com/linux-sunxi/libvdpau-sunxi"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libvdpau"

DOCS=( README ${FILESDIR}/99-sunxi-cedar-disp.rules )

src_compile() {
	emake "CC=${CHOST}-gcc" "CFLAGS=${CFLAGS}"
}
