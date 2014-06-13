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

src_install() {
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

	# udev rules to get the right ownership/permission for /dev/cedar_dev and /dev/disp
    insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-sunxi-cedar-disp.rules
}

pkg_postinst() {
	elog "You must be in video group to use VDPAU video acceleration."
	elog
	elog "To enable VDPAU, set VDPAU_DRIVER environment variable to 'sunxi'."
	elog "To enable VDPAU OSD, set VDPAU_OSD environment variable to '1'."
}
