# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI="2"

DESCRIPTION="The Phobos standard library for DMD"
HOMEPAGE="http://www.digitalmars.com/d/"

LICENSE="DMD"
RESTRICT="mirror strip binchecks"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE=""
EAPI="2"

DEPEND="=dev-lang/dmd-${PVR}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/dmd2"

src_compile() {
# DMD
	git clone git://github.com/D-Programming-Language/dmd.git dmd2
	# svn co http://svn.dsource.org/projects/dmd/trunk dmd2
	cd "${S}/src"
#	ln -s . mars
	make -j4 -f posix.mak || die "DMD compilation failed"
# druntime
#	svn co http://svn.dsource.org/projects/druntime/trunk druntime
	git clone git://github.com/D-Programming-Language/druntime.git druntime
	cd "druntime/"
	(
		export PATH="${S}/src:${PATH}"
		export HOME="$(pwd)"
		make -j4 -f posix.mak
		cp ./lib/libdruntime.a ..
	)
# Phobos
	#mkdir -p "${WORKDIR}/dmd2/src/lib"
	#cd "${S}/src/phobos"
	cd "${S}/src"
#	svn co http://svn.dsource.org/projects/phobos/trunk/phobos phobos
	git clone git://github.com/D-Programming-Language/phobos.git phobos
	cd "phobos"
	echo '#!/bin/sh' > dmd
	echo '/usr/bin/dmd2.bin -I/usr/include/druntime $*' >> dmd
	chmod u+x dmd
	export PATH=.:$PATH
	pwd
	make -j4 -f posix.mak || die "Phobos compilation failed"
# clean up
	find . -name "*.asm" -print0 | xargs -0 rm -v
	find . -name "*.mak" -print0 | xargs -0 rm -v
	find . -name "*.txt" -print0 | xargs -0 rm -v
	find . -name "*.ddoc" -print0 | xargs -0 rm -v
	find . -name "*.c" -print0 | xargs -0 rm -v
}

src_install() {
# lib
	dolib.a "${S}/src/phobos/generated/linux/release/32/libphobos2.a" || die "Install failed"

# includes
	rm -rf "${S}/src/phobos/generated"
	rm -rf "${S}/src/phobos/dmd"
	dodir /usr/include/phobos2
	mv "${S}/src/phobos"/* "${D}/usr/include/phobos2/"

# Config
	dobin "${FILESDIR}/dmd.dmd2-phobos"
}
