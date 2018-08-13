#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_PREFIX='/usr'
SHED_PKG_LOCAL_PROGRAM_INSTALL_OPTIONS='--enable-no-install-program=kill,uptime'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    SHED_PKG_LOCAL_PREFIX='/tools'
    SHED_PKG_LOCAL_PROGRAM_INSTALL_OPTIONS='--enable-install-program=hostname'
fi
# Patch
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/coreutils-8.30-i18n-1.patch" &&
autoreconf -fiv &&
# Configure
FORCE_UNSAFE_CONFIGURE=1 \
./configure --prefix=$SHED_PKG_LOCAL_PREFIX \
            $SHED_PKG_LOCAL_PROGRAM_INSTALL_OPTIONS &&
# Build and Install
FORCE_UNSAFE_CONFIGURE=1 make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
# Rearrange
if [ -z "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    mkdir -v "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/bin/{rmdir,stty,sync,true,uname} "${SHED_FAKE_ROOT}/bin" &&
    mkdir -pv "${SHED_FAKE_ROOT}/usr/sbin" &&
    mv -v "${SHED_FAKE_ROOT}/usr/bin/chroot" "${SHED_FAKE_ROOT}/usr/sbin" &&
    mkdir -pv "${SHED_FAKE_ROOT}/usr/share/man/man8" &&
    mv -v "${SHED_FAKE_ROOT}/usr/share/man/man1/chroot.1" "${SHED_FAKE_ROOT}/usr/share/man/man8/chroot.8" &&
    sed -i s/\"1\"/\"8\"/1 "${SHED_FAKE_ROOT}/usr/share/man/man8/chroot.8" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/bin/{head,sleep,nice} "${SHED_FAKE_ROOT}/bin" || exit 1
fi
