# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils mercurial

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="http://www.dsource.org/projects/ldc"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE=""
EAPI="2"

RDEPEND=">=sys-devel/llvm-2.6
		|| ( dev-libs/libelf dev-libs/elfutils )"
DEPEND=">=dev-util/cmake-2.6-r1
		dev-libs/libconfig
		${RDEPEND}"
PDEPEND="dev-libs/tango[ldc]"

S=${WORKDIR}/ldc

src_unpack() {
	mercurial_fetch http://hg.dsource.org/projects/ldc ldc
}

src_compile() {
	if ! [ "${LLVM_REV}" ]; then
		source /etc/env.d/*llvm*
	fi
	cmake -D CMAKE_CXX_FLAGS:STRING="-DLLVM_REV=999999" -D CMAKE_INSTALL_PREFIX="${D}usr" ./ || die "cmake failed"
	emake || die "make failed"
}


src_install() {
	# Compiler binary
	dobin bin/ldc
	dobin bin/ldmd

	# Generate config file
	cat > ldc.conf << HERE
// See http://www.hyperrealm.com/libconfig/ for syntax details.

// Special macros:                                                                                                        
// %%ldcbinarydir%%
//  - is replaced with the path to the directory holding the ldc executable

// The default group is required
default:
{
    // 'switches' holds array of string that are appends to the command line
    // arguments before they are parsed.
    switches = [ 
        "-I${ROOT}usr/include/tango",
        "-I${ROOT}usr/include/tango/tango/core/rt/compiler/ldc",
        "-L-L${ROOT}lib",
        "-d-version=Tango",
        "-defaultlib=tango-ldc",
        "-debuglib=tango-ldc"
    ];  
};
HERE

	insinto /etc
	doins ldc.conf
}
