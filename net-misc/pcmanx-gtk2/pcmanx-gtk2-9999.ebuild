# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Current this ebuild is actually for svn rev 483.

inherit eutils subversion flag-o-matic autotools multilib

DESCRIPTION="PCMan is an easy-to-use telnet(ssh) client mainly targets BBS users formerly writen by gtk2, with patches from ng and myself(kouhy)."
ESVN_REPO_URI="https://svn.csie.net/pcmanx/trunk"
#SRC_URI="http://pcmanx.csie.net/release/${P}.tar.bz2"
HOMEPAGE="http://pcmanx.csie.net/"
RESTRICT="nomirror"

KEYWORDS="x86 ~ppc amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="firefox socks5 libnotify debug nls mmx mouse external iplookup imageview"

DEPEND=">=x11-libs/gtk+-2.4
	x11-libs/libXft
	dev-util/intltool
	net-misc/wget
	firefox? (
				net-libs/xulrunner
				www-client/mozilla-firefox
			 )
	libnotify? ( x11-libs/libnotify )
	!www-client/pcmanxplug-in
	!virtual/pcmanx"

PROVIDE="virtual/pcmanx"

src_unpack()
{
	subversion_src_unpack

	cd ${S}
	local PATCH_R464="-to-official-r464" PATCH_R483="-to-official-r483"
	# The patch for rev464 works with rev483 as well. Good!
	epatch ${FILESDIR}/imageview-from-ng-r10${PATCH_R464}.patch
	epatch ${FILESDIR}/imageview-from-me-based-on-ng-r10${PATCH_R464}.patch
	epatch ${FILESDIR}/multiurl-from-oasis${PATCH_R464}.patch
	epatch ${FILESDIR}/ssh-username-from-me${PATCH_R464}.patch
	epatch ${FILESDIR}/xulrunner-1.9.1.3-interface-from-me${PATCH_R483}.patch

	epatch ${FILESDIR}/gcc-4.5-from-me.patch

	#eautoreconf
	./autogen.sh
}

src_compile() {
	# this flag crashes CTermData::memset16()
	filter-flags -ftree-vectorize

	local myconf="$(use_enable firefox plugin) \
				  $(use_enable socks5 proxy) \
				  $(use_enable libnotify) \
				  --enable-wget \
				  $(use_enable debug) \
				  $(use_enable nls) \
				  $(use_enable mmx) \
				  $(use_enable mouse) \
				  $(use_enable external) \
				  $(use_enable iplookup) \
				  $(use_enable imageview) \
				  --enable-nancy \
				  --enable-docklet"
	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install()
{
	cd ${S}
	emake DESTDIR="${D}" install || die "emake failed"

	exeinto /usr/$(get_libdir)/nsbrowser/plugins
	doexe plugin/src/pcmanx-plugin.so
	insinto /usr/$(get_libdir)/nsbrowser/plugins
	doins plugin/src/pcmanx-plugin.so
}
resetplugin()
{
	use firefox && /usr/lib/mozilla-firefox/regxpcom
}

pkg_postinst()
{
	resetplugin
	if use firefox
	then
		web=firefox

		einfo "You must restart $web to take effect."
		einfo "if still not effect, please remove compreg.dat in ~/<$web working directory> ."
	fi
}

pkg_postrm()
{
	resetplugin
}

