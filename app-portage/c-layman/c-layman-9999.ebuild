# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.5"

inherit git

DESCRIPTION="A C version of the python script for retrieving gentoo overlays."
HOMEPAGE=""
SRC_URI=""
EGIT_REPO_URI="git://git.overlays.gentoo.org/proj/layman.git"
EGIT_BRANCH="c-layman"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=app-portage/layman-2.0.0_rc1"
RDEPEND="${DEPEND}"


src_install() {
	cd c-layman/src/
	emake || die

}