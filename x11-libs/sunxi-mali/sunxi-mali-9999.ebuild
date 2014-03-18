# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/sunxi-mali.git"

DESCRIPTION="Sunxi Mali-400 support libraries"
HOMEPAGE="https://github.com/linux-sunxi/sunxi-mali"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/libdri2"

DOCS=( README ${FILESDIR}/99-sunxi-mali.rules )

src_prepare() {
	git submodule init
	git submodule update
}

src_configure() {
	emake config
}

src_compile() {
	emake "CC=${CHOST}-gcc"
}

src_install() {
    mali_prefix=/usr/lib/opengl/mali/

	into ${mali_prefix}
	dodir "${DESTTREE}/lib" "${DESTTREE}/include" "${DESTTREE}/extensions"

	if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
		emake "DESTDIR=${D}" "prefix=${mali_prefix}/" install
	fi

	dosym ../../xorg-x11/lib/libGL.so "${DESTTREE}/lib/libGL.so"
	dosym ../../xorg-x11/lib/libGL.so "${DESTTREE}/lib/libGL.so.1"
	dosym ../../xorg-x11/include/GL "${DESTTREE}/include/GL"

	if ! declare -p DOCS &>/dev/null ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES \
			THANKS BUGS FAQ CREDITS CHANGELOG ; do
			[[ -s "${d}" ]] && dodoc "${d}"
		done
	elif [[ $(declare -p DOCS) == "declare -a "* ]] ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi

	elog "Run 'eselect opengl set mali' manually to use the installed libs."
	elog "Do not forget to switch back to xorg-x11 before emerging x11-apps/mesa-progs!"
}
