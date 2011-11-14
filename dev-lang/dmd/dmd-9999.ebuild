# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

DESCRIPTION="Reference compiler for the D programming language"

HOMEPAGE="http://www.digitalmars.com/d/"
ESVN_REPO_URI="http://svn.dsource.org/projects/dmd/trunk"

LICENSE="DMD"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE=""
EAPI="2"

RESTRICT="mirror"

DEPEND="sys-apps/findutils
	!dev-lang/dmd-bin:2
	app-arch/unzip"
RDEPEND="dev-util/dmd-common
	amd64? ( app-emulation/emul-linux-x86-compat )"
PDEPEND="app-admin/eselect-dmd
	=dev-libs/phobos-${PV}"

S="${WORKDIR}/${PN}2"

src_compile() {
# DMD
	cd "${S}/src"
	ln -s . mars
	make -f linux.mak || die "make failed"
# druntime
	svn co http://svn.dsource.org/projects/druntime/trunk druntime
	cd "druntime/"
	(
		export PATH="${S}/src:${PATH}"
		export HOME="$(pwd)"
		make -f posix.mak
	)
}

src_install() {
# Compiler
	newbin "${S}/src/dmd" dmd2.bin || die "Install failed"
# druntime
	dolib.a "${S}/src/druntime/lib/libdruntime.a" || die "Install failed"
	dodir /usr/include/druntime
	mv "${S}/src/druntime/import"/* "${D}/usr/include/druntime/" || die "Install failed"
}
