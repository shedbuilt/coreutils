#!/bin/bash
patch -Np1 -i ${SHED_PATCHDIR}/coreutils-8.27-i18n-1.patch
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
FORCE_UNSAFE_CONFIGURE=1 make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -v ${SHED_FAKEROOT}/bin
mv -v ${SHED_FAKEROOT}/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} ${SHED_FAKEROOT}/bin
mv -v ${SHED_FAKEROOT}/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} ${SHED_FAKEROOT}/bin
mv -v ${SHED_FAKEROOT}/usr/bin/{rmdir,stty,sync,true,uname} ${SHED_FAKEROOT}/bin
mkdir -pv ${SHED_FAKEROOT}/usr/sbin
mv -v ${SHED_FAKEROOT}/usr/bin/chroot ${SHED_FAKEROOT}/usr/sbin
mkdir -pv ${SHED_FAKEROOT}/usr/share/man/man8
mv -v ${SHED_FAKEROOT}/usr/share/man/man1/chroot.1 ${SHED_FAKEROOT}/usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 ${SHED_FAKEROOT}/usr/share/man/man8/chroot.8
mv -v ${SHED_FAKEROOT}/usr/bin/{head,sleep,nice,test,[} ${SHED_FAKEROOT}/bin
