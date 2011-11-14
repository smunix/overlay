# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mercurial eutils

DESCRIPTION="xfBuild is a fast build tool for D"
HOMEPAGE="http://wiki.team0xf.com/index.php?n=Tools.XfBuild"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="|| ( dev-lang/ldc dev-lang/dmd:1 )
		dev-libs/tango"

RDEPEND="|| ( dev-lang/ldc dev-lang/dmd )
		|| ( dev-libs/tango dev-libs/phobos )"


src_unpack() {
	mercurial_fetch http://team0xf.com:1024/utils
	mercurial_fetch http://bitbucket.org/h3r3tic/xfbuild/
}


src_compile() {
	cd ${WORKDIR}/xfbuild
	sh ldcBuild.sh || dmd.dmd1-tango -g -I../.. -L-ltango-dmd -defaultlib=tango-dmd -L-ldl -ofxfbuild @modList.lst || die "Compilation failed"
}

src_install() {
	cd ${WORKDIR}/xfbuild
	dobin xfbuild || die "Installation failed"
}

