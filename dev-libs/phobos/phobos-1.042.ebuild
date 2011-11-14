# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="The Phobos standard library for DMD"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/dmd.${PV}.zip"

LICENSE="DMD"
RESTRICT="mirror strip"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}"

DEPEND="=dev-lang/dmd-${PV}"
RDEPEND="${DEPEND}"

src_compile() {
	cd "${S}/dmd/src/phobos"
	chmod u+x "${S}/dmd/linux/bin/dmd"
	export "PATH=${S}/dmd/linux/bin:${PATH}"

	edos2unix linux.mak internal/gc/linux.mak
	# Not a typo
	make -flinux.mak
	make -flinux.mak || die "make failed"
	cp libphobos.a "${S}/dmd/lib/"

	# Clean up
	make -flinux.mak clean
	rm -vr etc/c
	cd "${S}/dmd"
	find . -name "*.mak" -print0 | xargs -0 rm -v
	find . -name "*.c" -print0 | xargs -0 rm -v
	find . -name "*.h" -print0 | xargs -0 rm -v
	find . -name "*.txt" -print0 | xargs -0 rm -v
	find . -name "*.obj" -print0 | xargs -0 rm -v
	find . -name "*.ddoc" -print0 | xargs -0 rm -v
	find . -name "*.asm" -print0 | xargs -0 rm -v
}

src_install() {
	# Includes
	dodir usr/include/phobos1
	mv dmd/src/phobos/* "${D}/usr/include/phobos1/" || die "install failed"

	# Lib
	dolib.a dmd/linux/lib/libphobos.a

	dobin "${FILESDIR}/dmd.dmd1-phobos"
}
