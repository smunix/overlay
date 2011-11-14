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

DEPEND=">=dev-util/cmake-2.6"
RDEPEND="=sys-devel/llvm-2.6-r79757"

src_unpack() {
	mercurial_fetch http://hg.octarineparrot.com/druntime-ldc/ druntime

	mercurial_fetch http://hg.dsource.org/projects/ldc ldc2
}

src_compile() {
	cd "${WORKDIR}/ldc2"
	cmake -DD_VERSION=2 -DRUNTIME_DIR:STRING="../druntime" -DCMAKE_CXX_FLAGS:STRING="-DLLVM_REV=$LLVM_REV" ./ || die "cmake failed"
	emake || die "make failed"
	
	export PATH=`pwd`/bin:$PATH
	cd "${WORKDIR}/druntime/src"
	./build-ldc.sh
}

src_install() {
	cd "${WORKDIR}/ldc2"
	# Compiler binary
	dobin bin/ldc2
	dobin bin/ldmd2

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
        "-I${ROOT}usr/include/druntime-ldc",
        "-L-L${ROOT}lib",
        "-defaultlib=druntime-ldc",
        "-debuglib=druntime-ldc"
    ];  
};
HERE
	insinto /etc
	doins bin/ldc2.conf

	cd "${WORKDIR}/druntime"
	# Runtime
	dolib.a src/libdruntime-ldc.a

	# Runtime sources
	dodir /usr/include/druntime-ldc
	cd "${WORKDIR}/druntime"
	cp -R "import/*" "${D}/usr/include/druntime-ldc"
}
