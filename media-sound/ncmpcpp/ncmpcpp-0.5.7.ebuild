# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ncmpcpp/ncmpcpp-0.5.7.ebuild,v 1.6 2011/06/11 12:02:49 maekke Exp $

EAPI="2"
inherit bash-completion eutils

DESCRIPTION="An ncurses mpd client, ncmpc clone with some new features, written in C++"
HOMEPAGE="http://unkart.ovh.org/ncmpcpp"
SRC_URI="http://unkart.ovh.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
IUSE="bash-completion clock curl fftw iconv outputs taglib unicode visualizer"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ppc ~sparc x86"

RDEPEND="
	sys-libs/ncurses[unicode?]
	>=media-libs/libmpdclient-2.1
	curl? ( net-misc/curl )
	visualizer? ( fftw? ( sci-libs/fftw:3.0 ) )
	iconv? ( virtual/libiconv )
	taglib? ( media-libs/taglib )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_configure() {
	local myconf=""
	if use fftw; then
		myconf="$(use_with visualizer fftw)"
		if ! use visualizer; then
			ewarn "For the fftw USE flag to have any effect, you must also"
			ewarn "enable the visualizer USE flag."
		fi
	else
		myconf="--without-fftw"
	fi
	econf \
		${myconf} \
		$(use_enable clock) \
		$(use_enable outputs) \
		$(use_enable unicode) \
		$(use_enable visualizer) \
		$(use_with curl) \
		$(use_with iconv) \
		$(use_with taglib)
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-include-unistd.patch
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"

	# use dodoc instead of upstream's doc install which does not compress
	rm -rf "${D}"/usr/share/doc/${PN}
	dodoc AUTHORS NEWS doc/config doc/keys || die "dodoc failed"

	dobashcompletion doc/${PN}-completion.bash ${PN}
}

pkg_postinst() {
	echo
	elog "Example configuration files have been installed at"
	elog "${ROOT}usr/share/doc/${PF}"
	elog "${P} uses ~/.ncmpcpp/config and ~/.ncmpcpp/keys"
	elog "as user configuration files."
	echo
	if use visualizer; then
	elog "If you want to use the visualizer, you need mpd with fifo enabled."
	echo
	fi
	bash-completion_pkg_postinst
}
