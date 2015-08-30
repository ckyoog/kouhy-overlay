# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

IUSE=""
DESCRIPTION="display a clock using ANSI escape sequences"
HOMEPAGE="http://members.lycos.nl/jupp/"
SRC_URI="http://dev.gentoo.org/~wschlich/src/app-misc/klock/klock-1.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
DEPEND="virtual/libc"

src_compile() {
	emake CC=$(tc-getCC) || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
