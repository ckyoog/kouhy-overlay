# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion
DESCRIPTION="OpenVanilla Module for Boshiamy"

HOMEPAGE="http://openvanilla.org/"
SRC_URI=""
ESVN_REPO_URI="http://svn.openfoundry.org/openvanilla/trunk/Modules"
LICENSE="bsd"
SLOT="0"
KEYWORDS="~x86"
DEPEND="app-i18n/openvanilla-framework dev-db/sqlite"

# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="${DEPEND}"

src_unpack() {

	local repo_uri=${ESVN_REPO_URI}

	subversion_fetch ${repo_uri}/OVIMBoshiamy
	subversion_fetch ${repo_uri}/Mk ../Mk
	subversion_fetch ${repo_uri}/SharedHeaders ../SharedHeaders
	subversion_fetch ${repo_uri}/SharedSource ../SharedSource
	cd "${S}"
	mkdir ../SharedData/
	#wget --continue --directory-prefix=../SharedData ${repo_uri}/SharedData/bpmf.cin 
	#wget --continue --directory-prefix=../SharedData ${repo_uri}/SharedData/bpmf-ext.cin 
	#wget --continue --directory-prefix=../SharedData ${repo_uri}/SharedData/punctuations.cin
}

src_compile() {
	if [ -f liu5.cin ]
	then
		emake || die
	else
		ewarn "\"liu5.cin\" file isn't in the soource directory"
		ewarn "Please copy the \"liu5.cin\" into ${S},"
		ewarn "and emerge  again."
		die
	fi
}

src_install() {
	make INSTALL_PREFIX="${D}/usr" INSTALL_LIBPREFIX="lib" install 
}
