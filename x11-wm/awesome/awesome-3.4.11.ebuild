# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/awesome/awesome-3.4.10.ebuild,v 1.1 2011/05/16 21:05:05 robbat2 Exp $

EAPI="3"
CMAKE_MIN_VERSION="2.8"
inherit cmake-utils eutils

DESCRIPTION="A dynamic floating and tiling window manager"
HOMEPAGE="http://awesome.naquadah.org/"
SRC_URI="http://awesome.naquadah.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="dbus doc elibc_FreeBSD"

COMMON_DEPEND=">=dev-lang/lua-5.1
	dev-libs/libev
	>=dev-libs/libxdg-basedir-1
	media-libs/imlib2[png]
	x11-libs/cairo[xcb]
	|| ( <x11-libs/libX11-1.3.99.901[xcb] >=x11-libs/libX11-1.3.99.901 )
	>=x11-libs/libxcb-1.6
	>=x11-libs/pango-1.19.3
	>=x11-libs/startup-notification-0.10_p20110426
	>=x11-libs/xcb-util-0.3.8
	dbus? ( >=sys-apps/dbus-1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )"

# graphicsmagick's 'convert -channel' has no Alpha support, bug #352282
DEPEND="${COMMON_DEPEND}
	>=app-text/asciidoc-8.4.5
	app-text/xmlto
	dev-util/gperf
	dev-util/pkgconfig
	media-gfx/imagemagick[png]
	>=x11-proto/xcb-proto-1.5
	>=x11-proto/xproto-7.0.15
	doc? (
		app-doc/doxygen
		dev-lua/luadoc
		media-gfx/graphviz
	)"

RDEPEND="${COMMON_DEPEND}
	|| (
		x11-misc/gxmessage
		x11-apps/xmessage
	)"

# bug #321433: Need one of these to for awsetbg.
# imagemagick provides 'display' and is further down the default list, but
# listed here for completeness.  'display' however is only usable with
# x11-apps/xwininfo also present.
RDEPEND="${RDEPEND}
	|| (
	( x11-apps/xwininfo
	  || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	)
	x11-misc/habak
	media-gfx/feh
	x11-misc/hsetroot
	media-gfx/qiv
	media-gfx/xv
	x11-misc/xsri
	media-gfx/xli
	x11-apps/xsetroot
	)"

DOCS="AUTHORS BUGS PATCHES README STYLE"

## src_prepare() {
## 	epatch \
## 		"${FILESDIR}/${PN}-3.4.2-backtrace.patch" \
## 		"${FILESDIR}/3.4-0001-Update-the-code-following-release-of-xcb-util-0.3.8.patch"
## 
## 	# kill handling of NET_CURRENT_DESKTOP
## 	# temp fix for openoffice bug #109550
## 	# doesn't seem to break anything else
## 	epatch "${FILESDIR}/${PN}-3.4.3-net-current-desktop-ooo.patch"
## }

src_configure() {
	mycmakeargs=(
		-DPREFIX="${EPREFIX}"/usr
		-DSYSCONFDIR="${EPREFIX}"/etc
		$(cmake-utils_use_with dbus DBUS)
		$(cmake-utils_use doc GENERATE_LUADOC)
		)

	cmake-utils_src_configure
}

src_compile() {
	local myargs="all"

	if use doc ; then
		myargs="${myargs} doc"
	fi
	cmake-utils_src_make ${myargs}
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		(
			cd "${CMAKE_BUILD_DIR}"/doc
			mv html doxygen
			dohtml -r doxygen || die
		)
		mv "${ED}"/usr/share/doc/${PN}/luadoc "${ED}"/usr/share/doc/${PF}/html/luadoc || die
	fi
	rm -rf "${ED}"/usr/share/doc/${PN} || die

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/${PN}-session ${PN} || die
}
