# Copyright
#

EAPI=6

#inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://codeload.github.com/ROCmSoftwarePlatform/rocBLAS/tar.gz/v${PV} -> ${P}.tar.gz
         https://codeload.github.com/ROCmSoftwarePlatform/Tensile/tar.gz/v4.6.0 -> Tensile-4.6.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=dev-lang/python-2.7*
	dev-python/pyyaml"
DEPEND="dev-util/cmake"
	${RDPEND}

src_prepare() {

	cd "${WORKDIR}/Tensile-4.6.0"

	# if the ISA is not set previous to the autodetection, /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
	if use gfx803; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx803.patch"
	fi
	if use gfx900; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx900.patch"
	fi
	if use gfx906; then
		eapply "${FILESDIR}/Tensile-setCurrentISA_gfx906.patch"
	fi

	cd ${S}
        eapply "${FILESDIR}/master-usePython27.patch"
        eapply "${FILESDIR}/master-addTensileIncludePath.patch"
        eapply "${FILESDIR}/master-CMake_report_library.patch"
        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/release"
        cd "${WORKDIR}/build/release"

	export PATH=$PATH:/usr/lib/hcc/1.9/bin
	export hcc_DIR=/usr/lib/hcc/1.9/lib/cmake/
	export hip_DIR=/usr/lib/hip/1.9/lib/cmake/
	export CXX=/usr/lib/hcc/1.9/bin/hcc

	if use debug; then
		buildtype="-DCMAKE_BUILD_TYPE=Debug"
	else
		buildtype="-DCMAKE_BUILD_TYPE=Release"
	fi

	cmake -DTensile_TEST_LOCAL_PATH="${WORKDIR}/Tensile-4.6.0" -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/" ${buildtype}  ${S}
}

src_compile() {
        cd "${WORKDIR}/build/release"
        make VERBOSE=1
}

src_install() {

	chrpath --delete "${WORKDIR}/build/release/library/src/librocblas.so.0.14.1.2"

        cd "${WORKDIR}/build/release"
	emake DESTDIR="${D}" install
}


