# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# This ebuild is copied from brother-overlay:net-print/brother-mfc-j985dw-bin-1.0.0-r1.ebuild.
# I put the source ebuild in files/ just for reference.

EAPI=7

inherit rpm

model="mfcj995dw"

DESCRIPTION="CUPS driver for the Brother MFC-J995DW"
HOMEPAGE="http://support.brother.com"
SRC_URI="https://download.brother.com/welcome/dlf103812/${model}pdrv-${PV}-0.i386.rpm"

LICENSE="brother-eula GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-print/cups"

S="${WORKDIR}"

QA_PRESTRIPPED="
	/opt/brother/Printers/${model}/lpd/br${model}filter
	/usr/bin/brprintconf_${model}
"

src_install() {
	# lpr
	dobin usr/bin/brprintconf_${model}
	insinto /opt/brother/Printers/${model}
	doins -r "${WORKDIR}"/opt/brother/Printers/${model}/.
	local exe
	for exe in br${model}filter filter_${model}; do
		fperms 0755 /opt/brother/Printers/${model}/lpd/${exe}
	done
	# wrapper
	local ppd=brother_${model}_printer_en.ppd
	dosym /opt/brother/Printers/${model}/cupswrapper/${ppd} /usr/share/cups/model/${ppd}
	# filter
	local lpdwrapper=brother_lpdwrapper_${model}
	fperms 0755 /opt/brother/Printers/${model}/cupswrapper/${lpdwrapper}
	dosym /opt/brother/Printers/${model}/cupswrapper/${lpdwrapper} /usr/libexec/cups/filter/${lpdwrapper}
}
