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
	emake DESTDIR="${D}" install

	dodoc ${DOCS}

	# udev rules to get the right ownership/permission for /dev/cedar_dev and /dev/disp
	insinto "${ROOT%/}lib/udev/rules.d"
	doins "${FILESDIR}"/99-sunxi-cedar-disp.rules
}

pkg_postinst() {
	elog
	elog "You must be in video group to use VDPAU video acceleration."
	elog
	elog "To enable VDPAU, set VDPAU_DRIVER environment variable to 'sunxi'."
	elog "To enable VDPAU OSD, set VDPAU_OSD environment variable to '1'."
	elog
}
