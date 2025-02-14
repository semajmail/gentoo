# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python 3 runtime for ANTLR"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://github.com/antlr/antlr4/archive/${PV}.tar.gz -> antlr-${PV}.tar.gz"
S="${WORKDIR}/antlr4-${PV}/runtime/Python3"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

python_test() {
	"${EPYTHON}" tests/run.py -v || die "Tests failed with ${EPYTHON}"
}
