# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/pidgin-//}
DESCRIPTION="Fetion protocol plugin for libpurple"
HOMEPAGE="http://blog.donews.com/gradetwo/category/137031.aspx"
#SRC_URI="http://www.logvinov.ru/files/dist/fetion/${MY_P}.tar.bz2"
EGIT_REPO_URI="git://github.com/gradetwo/fetion.git"

inherit git-2

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-libs/glib
	>=net-im/pidgin-2.3.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	git_src_unpack

	# prepare build environment
	mkdir -p $S/src
	rm $S/Makefile*
	mv $S/* $S/src 2>/dev/null
	# This tarball just test until commit e8224ae911604229f6... .
	tar xjf ${FILESDIR}/fetion-build-env.tar.bz2 -C $S
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	einfo "This is not an official gentoo package, please report your"
	einfo "bugs to http://www.donews.net/gradetwo"
	einfo
	elog "Select the 'fetion' protocol to use this plugin"
	elog "Server IP 221.130.44.193"
	einfo
}
