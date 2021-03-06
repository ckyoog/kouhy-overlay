# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/zhcon/zhcon-0.2.6.ebuild,v 1.2 2006/10/24 08:49:30 flameeyes Exp $

WANT_AUTOMAKE="1.9"
WANT_AUTOCONF="latest"

inherit eutils autotools

MY_P=${P/6/5}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A Fast CJK (Chinese/Japanese/Korean) Console Environment"
HOMEPAGE="http://zhcon.sourceforge.net/"
SRC_URI="mirror://sourceforge/zhcon/${MY_P}.tar.gz
		mirror://sourceforge/zhcon/zhcon-0.2.5-to-0.2.6.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${DISTDIR}"/zhcon-0.2.5-to-0.2.6.diff.gz
	epatch "${FILESDIR}"/zhcon-0.2.5.make-fix.patch
	epatch "${FILESDIR}"/${P}.sysconfdir.patch
	epatch "${FILESDIR}"/${P}.configure.in.patch
	epatch "${FILESDIR}"/${P}.amd64.ime.patch
	epatch "${FILESDIR}"/${P}.gcc-4.3.patch
	eautoreconf
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README NEWS TODO THANKS
	dodoc ABOUT-NLS README.BSD README.gpm README.utf8
	
	tar xzf doc/html.tar.gz -C doc/ && dohtml -r doc/manual/
	dodoc doc/poem.big5 doc/poem.gb doc/poem.gb.utf8
	dodoc doc/bpsf.txt doc/README.html
}
