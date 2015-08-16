# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

DESCRIPTION="The ng version of pcmanx-gtk2."
ESVN_REPO_URI="http://pcmanx-gtk2-ng.googlecode.com/svn/trunk"
#SRC_URI="http://pcmanx-gtk2-ng.googlecode.com/files/${P/-ng/}.tar.gz"
HOMEPAGE="http://code.google.com/p/pcmanx-gtk2-ng/"
RESTRICT="nomirror"

KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="firefox wget libnotify iplookup mouse proxy imageview"

DEPEND=">=x11-libs/gtk+-2.4
	x11-libs/libXft
	dev-util/intltool
	firefox? (
				net-libs/xulrunner
				www-client/mozilla-firefox
			 )
	wget? ( net-misc/wget )
	libnotify? ( x11-libs/libnotify )"
#	!www-client/pcmanxplug-in
#	!virtual/pcmanx"

#PROVIDE="virtual/pcmanx"

#S=${WORKDIR}/${P/-ng/}

pkg_setup()
{
	if use firefox; then
		if ! built_with_use www-client/mozilla-firefox xulrunner ; then
			einfo "You must build mozilla-firefox with the xulrunner USE flag"
			die "Please re-emerge www-client/mozilla-firefox " \
				"with the xulrunner USE flag"
		fi
	fi
}

src_unpack()
{
#	unpack ${A}
	subversion_src_unpack
	cd ${S}
	local PATCH_R423="${PF}-to-official_svn_r423"
	epatch ${FILESDIR}/${PATCH_R423}-configure.ac-fx3_xulrunner1.9.patch
	epatch ${FILESDIR}/${PATCH_R423}-plugin.patch
	epatch ${FILESDIR}/${PATCH_R423}-compile-fix.patch
	epatch ${FILESDIR}/${PATCH_R423}-amd64-fix.patch
	epatch ${FILESDIR}/${PATCH_R423}-imageview-fix-of-mine.patch
}

src_compile() {
	(cd ${S}; ./autogen.sh)

	econf \
		--enable-nancy \
		$(use_enable wget) \
		$(use_enable libnotify) \
		$(use_enable iplookup) \
		$(use_enable mouse) \
		$(use_enable proxy) \
		$(use_enable imageview) \
		$(use_enable firefox plugin) \
		${myconf} || die
	emake || die
}

src_install()
{
	cd $S
	emake DESTDIR=${D} install || die
}

resetplugin()
{
	use firefox && /usr/lib/mozilla-firefox/regxpcom
}

pkg_postinst()
{
	resetplugin
	if use firefox; then
		web=firefox

		einfo "You must restart $web to take effect."
		einfo "if still not effect, please remove compreg.dat in ~/<$web working directory> ."
	fi
}

pkg_postrm()
{
	resetplugin
}
