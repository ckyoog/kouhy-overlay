# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/recode/recode-3.6_p15.ebuild,v 1.1 2008/09/25 11:18:05 loki_val Exp $

WANT_AUTOMAKE="1.4"

inherit autotools eutils libtool toolchain-funcs

MY_P=${P%_*}
MY_PV=${PV%_*}
DEB_PATCH=${PV#*p}

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="http://recode.progiciels-bpi.ca/"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${MY_PV}-${DEB_PATCH}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${PN}_${MY_PV}-${DEB_PATCH}.diff
	sed -i '1i#include <stdlib.h>' src/argmatch.c || die

	# Needed under FreeBSD, too
	epatch "${FILESDIR}"/${MY_P}-ppc-macos.diff
	cp lib/error.c lib/xstrdup.c src/ || die "file copy failed"

	# Patched by KouYu
	cp i18n/zh_CN.po i18n/zh.po || die "file copy failed"

	elibtoolize
}

src_compile() {
	tc-export CC LD
	# --without-included-gettext means we always use system headers
	# and library
	econf --without-included-gettext $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BACKLOG ChangeLog NEWS README THANKS TODO
	rm -f "${D}"/usr/lib/charset.alias
}