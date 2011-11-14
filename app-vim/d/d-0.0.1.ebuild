# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin

EAPI="2"

DESCRIPTION="vim plugin: Filetype plugin for D"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2534"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=9896
		-> ${P}.tar.bz2"

S=${WORKDIR}

RDEPEND="${DEPEND}"
