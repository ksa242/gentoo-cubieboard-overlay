# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ETYPE=sources
K_DEFCONFIG="sun7i_defconfig"
K_SECURITY_UNSUPPORTED=1
EXTRAVERSION="-${PN}/-*"

inherit kernel-2

detect_version
detect_arch

inherit git-r3 versionator

EGIT_REPO_URI="git://github.com/linux-sunxi/linux-sunxi.git"
EGIT_BRANCH="sunxi-$(get_version_component_range 1-2)"
EGIT_CHECKOUT_DIR="$S"

DESCRIPTION="Linux source for Allwinner/Boxchip F20 (sun3i), A10 (sun4i), A12/A13/A10S (sun5i) and A20 (sun7i) SoCs"
HOMEPAGE="https://github.com/linux-sunxi/linux-sunxi"

KEYWORDS="~arm"

src_unpack()
{
	git-r3_src_unpack
	unpack_set_extraversion
}
