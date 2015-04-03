EAPI=5

inherit git-r3

EGIT_REPO_URI="git://github.com/linux-sunxi/sunxi-mali.git"

DESCRIPTION="Sunxi Mali-400 support libraries"
HOMEPAGE="https://github.com/linux-sunxi/sunxi-mali"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=app-eselect/eselect-opengl-1.2.6
	x11-libs/sunxi-libump
	x11-libs/libdri2"
RDEPEND="${DEPEND}
	media-libs/mesa[gles1,gles2]"

DOCS=( README ${FILESDIR}/99-sunxi-mali.rules )

src_prepare() {
	git submodule init
	git submodule update
}

src_configure() {
	# emerge sets ABI to arm, but Makefile.conf expects armhf or armle, or none,
	# and it breaks ABI autodetection making the build fail.
	ABI= emake config

	MALI_LIBS_ABI=`grep LIBS_ABI config.mk | awk '{ print $3 }'`
	MALI_VERSION=` grep VERSION  config.mk | awk '{ print $3 }'`
	MALI_EGL_TYPE=`grep EGL_TYPE config.mk | awk '{ print $3 }'`
}

src_compile() {
	einfo "Using '${MALI_LIBS_ABI}' system ABI."
	einfo "Using '${MALI_VERSION}' mali driver version."
	einfo "Using '${MALI_EGL_TYPE}' EGL implementation."

	MALI_DIR="lib/mali/${MALI_VERSION}/${MALI_LIBS_ABI}/${MALI_EGL_TYPE}"

	if [[ ! -f ${MALI_DIR}/Makefile ]] ; then
		eerror "Cannot stat '${MALI_DIR}'"
		die "Files for selected ABI/VERSION/EGL are missing!"
	fi

	touch .gles-only

	# Check which libraries are provided: all in one or splitted
	if grep --quiet Makefile.split ${MALI_DIR}/Makefile ; then
		MALI_INSTALL_TYPE=1
	elif grep --quiet Makefile.mashup ${MALI_DIR}/Makefile ; then
		MALI_INSTALL_TYPE=0
	else
		die "Cannot determine how to proceed with libraries installation!"
	fi

	if [ ${MALI_INSTALL_TYPE} -eq 0 ] ; then
		# HACK: build dummy library stubs with the right sonames
		# to satisfy eselect-opengl
		einfo "Building dummy library stubs to satisfy eselect-opengl."
		gcc -shared -Wl,-soname,libEGL.so.1 -o libEGLcore.so \
			-L${MALI_DIR} -lMali || die
		gcc -shared -Wl,-soname,libGLESv1_CM.so.1 -o libGLESv1_CM_core.so \
			-L${MALI_DIR} -lMali || die
		gcc -shared -Wl,-soname,libGLESv2.so.2 -o libGLESv2_core.so \
			-L${MALI_DIR} -lMali || die
	fi

	einfo "Compiling test binary"
	local x="-L../${MALI_DIR}"
	[ "e${MALI_EGL_TYPE}" == "ex11" ] && x="-lX11 ${x}"
	sed -i "s%\\(\\\$(CC).*\$\\)%\\1 ${x}%" test/Makefile
	make -C test
}

src_install() {
	local opengl_imp="mali"
	local opengl_dir="/usr/$(get_libdir)/opengl/${opengl_imp}"

	dodir "${opengl_dir}/lib" "${opengl_dir}/include" "${opengl_dir}/extensions"

	# Install header files using provided Makefile
	emake "DESTDIR=${D}" "prefix=${opengl_dir}/" -C include install

	# install libraris manually
	into $opengl_dir
	dolib.so "${MALI_DIR}/libMali.so"
	# symlinks
	dosym libEGL.so.1.4 "${opengl_dir}/lib/libEGL.so.1"
	dosym libEGL.so.1   "${opengl_dir}/lib/libEGL.so"
	dosym libGLESv1_CM.so.1.1 "${opengl_dir}/lib/libGLESv1_CM.so.1"
	dosym libGLESv1_CM.so.1   "${opengl_dir}/lib/libGLESv1_CM.so"
	dosym libGLESv2.so.2.0 "${opengl_dir}/lib/libGLESv2.so.2"
	dosym libGLESv2.so.2   "${opengl_dir}/lib/libGLESv2.so"

	# create symlink to libMali into /usr/lib
	dosym "opengl/${opengl_imp}/lib/libMali.so" "/usr/$(get_libdir)/libMali.so"

	if [ ${MALI_INSTALL_TYPE} -eq 0 ] ; then
		dolib.so libEGLcore.so
		dolib.so libGLESv1_CM_core.so
		dolib.so libGLESv2_core.so
		dosym libMali.so "${opengl_dir}/lib/libEGL.so.1.4"
		dosym libMali.so "${opengl_dir}/lib/libGLESv1_CM.so.1.1"
		dosym libMali.so "${opengl_dir}/lib/libGLESv2.so.2.0"
	else
		dolib.so "${MALI_DIR}/libEGL.so.1.4"
		dolib.so "${MALI_DIR}/libGLESv1_CM.so.1.1"
		dolib.so "${MALI_DIR}/libGLESv2.so.2.0"
	fi

	into /usr
	newbin test/test mali-test-example

	# udev rules to get the right ownership/permission for /dev/ump and /dev/mali
	insinto /lib/udev/rules.d
	doins "${FILESDIR}"/99-sunxi-mali.rules

	insinto "${opengl_dir}"
	doins .gles-only

	if [[ $(declare -p DOCS) == "declare -a "* ]] ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi
}

pkg_postinst() {
	elog "You must be in the video group to use the Mali 3D acceleration."
	elog
	elog "To use the Mali OpenGL ES libraries, run \"eselect opengl set mali\""
	elog
	elog "Some packages, for example x11-apps/mesa-progs and x11-libs/cairo, probably would not build due to missing libGL and/or GL headers."
}

pkg_prerm() {
	eselect opengl set --use-old --ignore-missing xorg-x11
}

pkg_postrm() {
	eselect opengl set --use-old --ignore-missing xorg-x11
}

