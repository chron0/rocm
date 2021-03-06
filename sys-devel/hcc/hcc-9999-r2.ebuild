# Copyright
# 

EAPI=6

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"

LICENSE=""
SLOT="9999"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
#RDEPEND="=media-libs/ROCR-Runtime-1.8*
#         sys-libs/libunwind"

src_unpack() {

	git clone --recursive -b clang_tot_upgrade https://github.com/RadeonOpenCompute/hcc.git ${S}
}

src_configure() {

	mkdir "${WORKDIR}/build"
	cd "${WORKDIR}/build"
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/${SLOT}" -DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/${SLOT}/share/man"  ${S}
}

src_compile() {

	cd "${WORKDIR}/build"
	make VERBOSE=1 ${MAKEOPTS}
}

src_install() {

        cd "${WORKDIR}/build"
	emake DESTDIR="${D}" install
}
