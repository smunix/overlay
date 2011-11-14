# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Phobos standard library for DMD"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/dmd.${PV}.zip"

LICENSE="DMD"
RESTRICT="mirror strip"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}"

DEPEND="=dev-lang/dmd-${PV}"
RDEPEND="${DEPEND}"

src_install() {
	# Includes
	dodir usr/include/phobos2/
	mv dmd/src/phobos/* "${D}/usr/include/phobos2/"

	# Lib
	dolib.a dmd/linux/lib/libphobos2.a

	# Config
	dobin "${FILESDIR}/dmd.dmd2-phobos"
}
