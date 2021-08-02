# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic

DESCRIPTION="City simulation game for X"
HOMEPAGE="http://lincity.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/lincity/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:=
	virtual/libintl
	x11-libs/libXext"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc-10.patch
)

src_configure() {
	append-cflags -std=gnu89 # build with gcc5 (bug #570574)

	local econfargs=(
		--with-gzip
		--with-x
		--without-svga
		ac_cv_lib_ICE_IceConnectionNumber=no # not actually used
	)

	econf "${econfargs[@]}"
}

src_compile() {
	emake
	emake X_PROGS
}

src_install() {
	default

	dobin x${PN}

	newman {,x}${PN}.6
	rm "${ED}"/usr/share/man/man6/${PN}.6

	dodoc Acknowledgements

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry x${PN} ${PN^}
}
