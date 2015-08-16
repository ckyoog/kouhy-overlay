# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="gphoto-fs allow you can mount your camera on Linux using FUSE"
HOMEPAGE="http://www.gphoto.org/"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.2
	>=media-libs/libgphoto2-2.1
	>=sys-libs/glibc-2.6"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README NEWS ChangeLog AUTHORS INSTALL COPYING
}

pkg_postinst() {
	# Check kernel configuration
	local CONFIG_CHECK="~FUSE_FS"
	check_extra_config
}
