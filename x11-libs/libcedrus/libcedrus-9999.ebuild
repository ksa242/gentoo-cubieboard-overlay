EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/libcedrus.git"

DESCRIPTION="Low-level access to the video engine of Allwinner sunxi SoCs"
HOMEPAGE="https://github.com/linux-sunxi/libcedrus"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DOCS=( README )

src_compile() {
	emake CC="${CHOST}-gcc" CFLAGS="${CFLAGS}"
}

src_install() {
	emake prefix=/usr DESTDIR="${D}" install
	dodoc ${DOCS}
}
