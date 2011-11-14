# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/-bin/}

DESCRIPTION="the D Shared Software System"
HOMEPAGE="http://www.dsource.org/projects/dsss"
SRC_URI="http://svn.dsource.org/projects/dsss/downloads/${PV}/${MY_P}-x86-gnuWlinux.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ldc dmd"

DEPEND=""
RDEPEND="net-misc/curl
		ldc? ( dev-lang/ldc )
		dmd? ( dev-lang/dmd )"

S=${WORKDIR}/${MY_P}-x86-gnuWlinux

pkg_setup() {
	if use ldc ; then
		export REBUILD_PROFILE="ldc-posix-tango"
	elif use dmd ; then
		export REBUILD_PROFILE="dmd-posix-tango"
	else
		eerror "                                                 "
		eerror "You have selected neither ldc or dmd in     "
		eerror "your USE flags! At least one compiler     "
		eerror "must be chosen.                                  "
		eerror "                                                 "
		die "No compiler selected"
	fi

}

src_install() {

	dodir opt/dsss
	cp -r "${S}"/* "${D}/opt/dsss/" || die "install failed"

	doenvd "${FILESDIR}/25dsss" || die "install failed"
	doman "${S}/share/man/man1/dsss.1"
	doman "${S}/share/man/man1/rebuild.1"

	if use ldc; then
		cp "${FILESDIR}/ldc-posix-tango" "${D}/opt/dsss/etc/rebuild/" || die "install failed"
	# Generate config file
	cat > ldc.rebuild.conf << HERE
[Environment] 
DFLAGS=-I${ROOT}usr/include/tango -I${ROOT}usr/include/tango/tango/core/rt/compiler/ldc -L-L${ROOT}lib -d-version=Tango -defaultlib=tango-ldc -debuglib=tango-ldc
HERE
		insinto /etc
		doins ldc.rebuild.conf
	fi

	echo "profile=${REBUILD_PROFILE}" > ${D}/opt/dsss/etc/rebuild/default || die "install failed"

}

