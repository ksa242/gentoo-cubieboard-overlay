# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

EGIT_REPO_URI="git://gitorious.org/lima/lima.git"

DESCRIPTION="Free software graphics driver for the ARM Mali GPUs"
HOMEPAGE="https://gitorious.org/lima/lima/"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/sunxi-mali"

DOCS=()

src_prepare() {
	epatch "${FILESDIR}/${PN}-gentoo-chost.patch"
	epatch "${FILESDIR}/${PN}-tests-makefile.patch"
}

src_compile() {
	emake "CROSS_COMPILE=${CHOST}-"
}

src_install() {
	mkdir -p "${ED}${DESTTREE}/bin" "${ED}${DESTTREE}/include" "${ED}${DESTTREE}/lib"
	emake DESTDIR="${D}" install
}
