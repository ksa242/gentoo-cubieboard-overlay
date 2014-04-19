EAPI=5

inherit autotools git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/libump.git"

DESCRIPTION="Unified Memory Provider (UMP) user-space API"
HOMEPAGE="https://github.com/linux-sunxi/libump"

LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""

DOCS=( README )

src_prepare() {
	eautoreconf
}
