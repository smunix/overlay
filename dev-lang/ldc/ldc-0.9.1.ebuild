# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils subversion eutils

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="http://www.dsource.org/projects/ldc"
SRC_URI="http://hg.dsource.org/projects/ldc/archive/a6dfd3cb5b99.tar.bz2 -> ldc-0.9.1.tar.bz2"
ESVN_REPO_URI="http://svn.dsource.org/projects/tango/tags/releases/0.99.8"
ESVN_OFFLINE="1"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE=""
EAPI="2"

RDEPEND="=sys-devel/llvm-2.5-r71386
		|| ( dev-libs/libelf dev-libs/elfutils )"
DEPEND=">=dev-util/cmake-2.6
		dev-libs/libconfig
		${RDEPEND}"
PDEPEND="dev-libs/tango[ldc]"

S="${WORKDIR}/ldc"

src_unpack() {
	unpack $A
	mv ldc-* ldc
	cd ldc
	subversion_fetch http://svn.dsource.org/projects/tango/tags/releases/0.99.8 tango
}

src_prepare() {
	cd "${S}/tango"
	epatch "../tango-0.99.8.patch"
}

src_compile() {
	if ! [ "${LLVM_REV}" ]; then
		source /etc/env.d/*llvm*
	fi

	cmake -D CMAKE_CXX_FLAGS:STRING="-DLLVM_REV=${LLVM_REV}" -D CMAKE_INSTALL_PREFIX="${ROOT}" ./ || die "cmake failed"
	emake || die "make failed"
	export PATH=`pwd`/bin:${PATH}

	cd "${WORKDIR}/ldc/runtime"
	ln -s "${WORKDIR}/ldc/bin/ldc.conf" ldc.conf
	make runtime || die "make runtime failed"
}

src_install() {
	# Compiler binary
	dobin bin/ldc
	dobin bin/ldmd

	# Config
	insinto /etc
	doins bin/ldc.conf

	# Runtime
	dolib.a lib/libtango-base-ldc.a

	# Runtime sources
	dodir /usr/include/tango/ldc
	cp -r "${S}/tango/ldc/"* "${D}/usr/include/tango/ldc" || die "install failed"

	# Fix include search directory
	sed -i "s#-I/.*/runtime/../tango#-I${ROOT}usr/include/tango#; s#%%ldcbinarypath.*\"#${ROOT}usr/lib\"#; s#tango-base-ldc#tango-user-ldc,tango-base-ldc#" "${D}/etc/ldc.conf" || die "install failed"

}
