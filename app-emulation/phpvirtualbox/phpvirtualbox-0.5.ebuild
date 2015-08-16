# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $$

EAPI="2"

inherit eutils webapp depend.php

DESCRIPTION="Web-based administration for VirtualBox in PHP"
HOMEPAGE="http://phpvirtualbox.googlecode.com"
SRC_URI="http://${PN}.googlecode.com/files/${P}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/php[session,unicode,pcre,soap,gd]
"

need_php_httpd

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	dodoc CHANGELOG.txt LICENSE.txt README.txt || die
	rm -f CHANGELOG.txt LICENSE.txt README.txt

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.php

	webapp_src_install
}

pkg_postinst() {
    webapp_pkg_postinst
	elog "You have to run vboxwebsrv to use this interface:"
	elog " vboxwebsrv -b --logfile ~/.vboxwebserv.log >/dev/null"
	elog ""
	elog "You may have to disable authentication whith this command:"
	elog " VBoxManage setproperty websrvauthlibrary null"
	elog ""
	elog "Please keep in mind that phpvirtualbox has no authentication"
	elog "You could use your webserver (.htaccess) to protect the UI"
}

