# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils subversion eutils

ESVN_REPO_URI="http://svn.dsource.org/projects/qtd/trunk/"
ESVN_CO_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}"/svn-src/${P/-svn}/"${ESVN_REPO_URI##*/}"
ESVN_PROJECT="${P}"

DESCRIPTION="QtD is a D binding to the Qt application and UI framework"
HOMEPAGE="http://www.dsource.org/projects/qtd"
LICENSE="GPL-2 Boost-1.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="+core +X network opengl svg webkit xml"

RDEPEND="|| ( dev-lang/ldc dev-lang/dmd )
		core? ( x11-libs/qt-core )
		X? ( x11-libs/qt-gui )
		network? ( x11-libs/qt-core )
		opengl? ( x11-libs/qt-opengl )
		svg? ( x11-libs/qt-svg )
		webkit? ( x11-libs/qt-webkit )
		xml? ( x11-libs/qt-core )"

DEPEND="${RDEPEND}"


src_unpack() {

	subversion_src_unpack

}

src_compile() {

	declare -x D_COMPILER

	if [[ `which ldc 2> /dev/null` ]] ; then
		D_COMPILER=`which ldc`
	elif [[ `which dmd 2> /dev/null` ]]; then
		D_COMPILER=`which dmd`
	else
		eerror "No D compiler was found in path. Aborting"
	fi

	declare -x CMAKE_ARGS_STRING

	if use core; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_CORE:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_CORE:BOOL=OFF"
	fi

	if use X; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_GUI:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_GUI:BOOL=OFF"
	fi

	if use network; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_NETWORK:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_NETWORK:BOOL=OFF"
	fi

	if use opengl; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_OPENGL:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_OPENGL:BOOL=OFF"
	fi

	if use svg; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_SVG:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_SVG:BOOL=OFF"
	fi

	if use webkit; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_WEBKIT:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_WEBKIT:BOOL=OFF"
	fi

	if use xml; then
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_XML:BOOL=ON"
	else
		CMAKE_ARGS_STRING="${CMAKE_ARGS_STRING} -DBUILD_QT_XML:BOOL=OFF"
	fi

	cmake -DALLOW_IN_SOURCE_BUILDS=1 -DDC:STRING="${D_COMPILER}" -DCMAKE_INSTALL_PREFIX="${D}usr" ${CMAKE_ARGS_STRING}  ./ || die "CMake failed"
	make || die "Make failed"

}

src_install() {

	make install || die "Installation failed"

	einfo "Installing libraries"
	dolib.a lib/*.a

}

