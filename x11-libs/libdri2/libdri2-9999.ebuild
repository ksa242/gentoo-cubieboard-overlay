# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 autotools

EGIT_REPO_URI="git://github.com/robclark/libdri2.git"

DESCRIPTION="DRI2 extension to the X Window System"
HOMEPAGE="https://github.com/robclark/libdri2"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-base/xorg-server
	x11-libs/libXext
	x11-proto/xextproto
	x11-libs/libdrm"

DOCS=( COPYING README )

src_prepare() {
	eautoreconf
}
