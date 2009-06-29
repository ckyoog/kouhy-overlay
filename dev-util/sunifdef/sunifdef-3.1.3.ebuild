# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/unifdef/unifdef-1.23.ebuild,v 1.1 2009/05/19 07:17:53 vapier Exp $

DESCRIPTION="Son and successor of unifdef"
HOMEPAGE="http://www.sunifdef.strudl.org"
SRC_URI="http://www.strudl.org/public_ftp/sunifdef/nix/stable/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 -sparc-fbsd -x86-fbsd"
IUSE=""

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog LICENSE.BSD README
}
