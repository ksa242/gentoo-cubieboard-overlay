EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/libump.git"

DESCRIPTION="Unified Memory Provider (UMP) user-space API"
HOMEPAGE="https://github.com/linux-sunxi/libump"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""

DOCS=( README )

src_prepare() {
	autoreconf -i
}
