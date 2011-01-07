# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/vlock/vlock-2.2.2-r2.ebuild,v 1.8 2009/01/10 16:15:06 armin76 Exp $

inherit eutils pam toolchain-funcs multilib

DESCRIPTION="A console screen locker"
HOMEPAGE="http://cthulhu.c3d2.de/~toidinamai/vlock/vlock.html"
SRC_URI="http://cthulhu.c3d2.de/~toidinamai/vlock/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc ppc64 sparc x86"
#IUSE="pam test +plugins +plugin_caca +plugin_mplayer +plugin_hibernate
#+plugin_alsa +plugin_thinkpad plugin_powerbook"
IUSE="pam test plugins plugin_caca plugin_mplayer plugin_hibernate
plugin_alsa plugin_thinkpad plugin_powerbook"

DEPEND="
	pam? ( sys-libs/pam )
	test? ( dev-util/cunit )
	plugin_caca? ( media-libs/libcaca )"

RDEPEND="${DEPEND}
	plugin_mplayer? ( media-video/mplayer )
	plugin_hibernate? ( sys-power/hibernate-script )
	plugin_alsa? ( media-sound/alsa-utils )"

pkg_setup() {
	for p in caca mplayer hibernate alsa thinkpad powerbook; do
		if use plugin_${p} && ! use plugins; then
			eerror "ERROR: You enable use flag 'plugin_${p}', but not enable use flag 'plugins'"
			die "You enable use flag 'plugin_${p}', but not enable use flag 'plugins'"
		fi
	done
	enewgroup vlock
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-asneeded.patch"
	epatch "${FILESDIR}/${P}-test_process.patch"
	if use plugin_caca; then
		epatch "${FILESDIR}/${P}-fix_caca_and_add_cacafire.patch"
	fi
}

src_compile() {
	local modules="all.so new.so nosysrq.so ttyblank.so vesablank.so"
	use plugin_caca && modules="${modules} caca.so cacafire.so"
	local scripts
	use plugin_mplayer && scripts="${scripts} mplayer.sh"
	use plugin_hibernate && scripts="${scripts} hibernate.sh"
	use plugin_alsa && scripts="${scripts} alsa_mute.sh"
	use plugin_thinkpad && scripts="${scripts} thinkpad_light.sh"
	use plugin_powerbook && scripts="${scripts} powerbook_backlight.sh"

	if use pam; then
		myconf="--enable-pam"
	else
		myconf="--enable-shadow"
	fi
	einfo ${plugins}
	# this package has handmade configure system which fails with econf...
	./configure --prefix=/usr \
				--mandir=/usr/share/man \
				--libdir=/usr/$(get_libdir) \
				${myconf} \
				$(use_enable plugins) \
				--with-modules="${modules}" \
				--with-scripts="${scripts}" \
				CC="$(tc-getCC)" \
				LD="$(tc-getLD)" \
				CFLAGS="${CFLAGS} -pedantic -std=gnu99" \
				LDFLAGS="${LDFLAGS}" || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	use pam && pamd_mimic_system vlock auth
	dodoc ChangeLog PLUGINS README README.X11 SECURITY STYLE TODO
}
