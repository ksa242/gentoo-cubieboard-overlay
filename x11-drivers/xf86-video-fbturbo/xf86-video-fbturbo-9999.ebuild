EAPI=5

inherit xorg-2 git-r3

EGIT_REPO_URI="git://github.com/ssvb/xf86-video-fbturbo.git"

DESCRIPTION="Xorg DDX driver for Allwinner A10/A13/A20 and other ARM devices"
HOMEPAGE="https://github.com/ssvb/xf86-video-fbturbo"

KEYWORDS=""
IUSE="gles1 gles2 -mali-r3p2"

use mali-r3p2 && EGIT_BRANCH="mali-r3p2-support"

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	gles1? ( x11-libs/sunxi-mali )
	gles2? ( x11-libs/sunxi-mali )
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xf86driproto
	x11-proto/xproto
	x11-libs/libdrm
	x11-libs/pixman"

DOCS=( COPYING README xorg.conf "${FILESDIR}"/99-sunxi-g2d.rules )

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

	# udev rules to get the right ownership/permission for /dev/g2d.
	# Required for VDPAU OSD to work.
    insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-sunxi-g2d.rules
}

pkg_postinst() {
	elog "You must be in the video group to have VDPAU OSD enabled."
}
