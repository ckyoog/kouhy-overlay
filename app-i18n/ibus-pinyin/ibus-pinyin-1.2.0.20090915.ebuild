# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-pinyin/ibus-pinyin-1.2.0.20090915.ebuild,v 1.5 2010/05/26 10:36:49 pacho Exp $

EAPI="4"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="sqlite"
inherit eutils python-utils-r1

PYDB_TAR="pinyin-database-0.1.10.6.tar.bz2"
DESCRIPTION="Chinese PinYin IMEngine for IBus Framework"
HOMEPAGE="http://code.google.com/p/ibus/"
SRC_URI="http://ibus.googlecode.com/files/${P}.tar.gz
	http://ibus.googlecode.com/files/${PYDB_TAR}
	https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${PYDB_TAR}
	https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=app-i18n/ibus-1.1.0
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( >=sys-devel/gettext-0.16.1 )"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	mv py-compile py-compile.orig || die
	ln -s "$(type -P true)" py-compile || die
	cp "${DISTDIR}/${PYDB_TAR}" "${S}"/engine
}

src_configure() {
	econf $(use_enable nls) || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
