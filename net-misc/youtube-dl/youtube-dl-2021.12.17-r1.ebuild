# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1 optfeature

DESCRIPTION="Download videos from YouTube.com (and more sites...)"
HOMEPAGE="https://youtube-dl.org/"
SRC_URI="https://youtube-dl.org/downloads/${PV}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="+yt-dlp"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	yt-dlp? ( >=net-misc/yt-dlp-2022.2.4-r1 )
	!yt-dlp? ( !net-misc/yt-dlp )"

distutils_enable_tests nose

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i '/flake8/d' Makefile || die
}

python_test() {
	emake offlinetest
}

python_install_all() {
	dodoc AUTHORS ChangeLog README.md docs/supportedsites.md
	doman youtube-dl.1

	newbashcomp youtube-dl.bash-completion youtube-dl

	insinto /usr/share/zsh/site-functions
	newins youtube-dl.zsh _youtube-dl

	insinto /usr/share/fish/vendor_completions.d
	doins youtube-dl.fish

	rm -r "${ED}"/usr/{etc,share/doc/youtube_dl} || die

	# keep man pages / completions either way given they are useful
	# for yt-dlp's compatibility wrapper which tries to mimic options
	use !yt-dlp || rm -r "${ED}"/usr/{lib/python-exec,bin} || die
}

pkg_postinst() {
	optfeature "converting and merging tracks on some sites" media-video/ffmpeg
	optfeature "embedding metadata thumbnails in MP4/M4A files" media-video/atomicparsley
	optfeature "downloading videos streamed via RTMP" media-video/rtmpdump
	optfeature "downloading videos streamed via MMS/RTSP" media-video/mplayer media-video/mpv

	ewarn "Note that it is preferable to use net-misc/yt-dlp over youtube-dl for"
	ewarn "latest features and site support. youtube-dl is only kept maintained for"
	ewarn "compatibility with older software (notably its python module, yt-dlp has"
	ewarn "a 'bin/youtube-dl' compatibility wrapper but not for the module)."
}
