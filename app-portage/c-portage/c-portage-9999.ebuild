# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="C implementaion of the Gentoo package management Portage library."
HOMEPAGE="http://git.overlays.gentoo.org/gitweb/?p=proj/c-portage.git;a=summary"
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/${PN}"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="qt4 test"

DEPEND="
	|| (
		=sys-apps/portage-8888 
		=app-portage/portage-public-api-9999 )
	qt4? ( x11-libs/qt-core:4 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use qt4)
	)
	cmake-utils_src_configure
}
