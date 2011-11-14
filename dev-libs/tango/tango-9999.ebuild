# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

DESCRIPTION="Tango is a cross-platform open-source software library for D programmers."

HOMEPAGE="http://www.dsource.org/projects/tango/"
ESVN_REPO_URI="http://svn.dsource.org/projects/tango/trunk"

IUSE="dmd ldc"
EAPI="2"

RESTRICT="mirror strip binchecks"

KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
SLOT="0"
DEPEND="ldc? ( =dev-lang/ldc-9999 )
		dmd? ( >=dev-lang/dmd-1.055 )"
RDEPEND="${DEPEND}"
LICENSE="GPL-2"

pkg_setup() {
	if ! use dmd && ! use ldc ; then
		eerror ""
		eerror "I didn't find nor ldc nor dmd in USE."
		eerror "You must select at least one compiler"
		eerror "for which to build the library."
	fi
}

src_compile() {

	if use amd64; then
		BOB="build/bin/linux64/bob"
		chmod +x $BOB
	else
		BOB="build/bin/linux/bob"
	fi

	if use dmd ; then
		cd ${WORKDIR}/${P}
		mkdir dmd
		cd dmd
		../$BOB -vu -p=linux -r=dmd -c=dmd -l=libtango-dmd .. || die "Tango for DMD failed"
	fi

	if use ldc ; then
		cd ${WORKDIR}/${P}
		mkdir ldc
		cd ldc
		../$BOB -vu -p=linux -r=ldc -c=ldc -l=libtango-ldc .. || die "Tango for LDC failed"
	fi
}

src_install() {
	einfo "installing libraries"

	dodir /usr/include/tango

	cd ${WORKDIR}/${P}

	cp -r object.di tango "${D}/usr/include/tango" || die "install failed"

	if use dmd; then
		dolib.a dmd/libtango-dmd.a || die
		dobin "${FILESDIR}/dmd.dmd1-tango" || die
	fi

	if use ldc; then
		dolib.a ldc/libtango-ldc.a || die
	fi
}

