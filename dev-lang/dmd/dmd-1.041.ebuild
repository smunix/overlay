# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Reference compiler for the D programming language"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/${PN}.${PV}.zip"

LICENSE="DMD"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE=""
EAPI="2"

RESTRICT="mirror"

DEPEND="sys-apps/findutils
	!dev-lang/dmd-bin:1"
RDEPEND="dev-util/dmd-common
	amd64? ( app-emulation/emul-linux-x86-compat )"
PDEPEND="app-admin/eselect-dmd
	|| ( dev-libs/tango =dev-libs/phobos-${PV} )"

S="${WORKDIR}/${PN}/src/dmd"

src_unpack() {
	unpack $A
	cd dmd
	rm -rf html osx windows linux samples README.TXT license.txt
	cd src/dmd
}

src_prepare() {
	cd "${S}"
	epatch "${FILESDIR}/${P}.patch"
}

src_compile() {
	make -f linux.mak || die "make failed"
}

src_install() {
	# Generate config file
	cat > dmd.conf << HERE

[Environment]

# Currently, flags are passed directly by dmd.dmdx family scripts in /usr/bin
# DFLAGS=-I/usr/include/phobos1 -L-L/lib
HERE

	insinto /etc
	doins dmd.conf

	newbin "${S}/dmd" dmd1.bin || die "Install failed"
}
