EAPI=5

inherit autotools git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/libump.git"

DESCRIPTION="Unified Memory Provider (UMP) user-space API"
HOMEPAGE="https://github.com/linux-sunxi/libump"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND=""

DOCS=( README )

src_prepare() {
	eautoreconf
}

src_install() {
	default

	prune_libtool_files --modules

	use static-libs || find "${ED}" -name '*.a' -exec rm -f {} +
}
