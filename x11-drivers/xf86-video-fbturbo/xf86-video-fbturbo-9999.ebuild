# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2 git-r3

EGIT_REPO_URI="git://github.com/ssvb/xf86-video-fbturbo.git"

DESCRIPTION="Xorg DDX driver for Allwinner A10/A13 and other ARM devices"
HOMEPAGE="https://github.com/ssvb/xf86-video-fbturbo"

KEYWORDS=""
IUSE=""

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xf86driproto
	x11-proto/xproto
	x11-libs/libdrm
	x11-libs/pixman"

DOCS=( COPYING README xorg.conf )
