EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/sunxi-mali.git"

DESCRIPTION="Sunxi Mali-400 support libraries"
HOMEPAGE="https://github.com/linux-sunxi/sunxi-mali"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/sunxi-libump
	x11-libs/libdri2"

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
    mali_root=${DESTTREE}/lib/opengl/mali/

	dodir "${mali_root}/lib" "${mali_root}/include" "${mali_root}/extensions"

	if [[ -f Makefile || -f GNUmakefile || -f makefile ]] ; then
		emake "DESTDIR=${D}" "prefix=${mali_root}/" install
	fi

	dosym ../../xorg-x11/lib/libGL.so "${mali_root}/lib/libGL.so"
	dosym ../../xorg-x11/lib/libGL.so "${mali_root}/lib/libGL.so.1"
	dosym ../../xorg-x11/include/GL "${mali_root}/include/GL"

	dosym "${mali_root}/lib/libMali.so" "${DESTTREE}/lib/libMali.so"

	if [[ $(declare -p DOCS) == "declare -a "* ]] ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi

	elog "Run 'eselect opengl set mali' manually to use the installed libs."
	elog "Do not forget to switch back to xorg-x11 before emerging x11-apps/mesa-progs!"
}
