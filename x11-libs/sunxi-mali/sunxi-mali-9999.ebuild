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
	mkdir -p "${ED}${DESTTREE}/lib"

	if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
		emake DESTDIR="${D}" install
	fi

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
}
