#!/bin/bash 

version=1.2.0

builddir=/tmp/eqmodgui  # Be sure this is set to a non existent directory, it is removed after the run!

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

unset extratarget

unset make_linux32
unset make_linux64

if [[ $arch == i686 ]]; then 
   make_linux32=1
fi
if [[ $arch == x86_64 ]]; then 
   make_linux64=1
   extratarget=",x86_64-linux"
fi

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

save_PATH=$PATH
wd=`pwd`

currentrev=$(git rev-list --count --first-parent HEAD)

echo $version - $currentrev


# delete old files
  rm eqmodgui*.xz
  rm eqmodgui*.deb
  rm eqmodgui*.rpm
  rm -rf $builddir

# make Linux i386 version
if [[ $make_linux32 ]]; then
  ./configure $configopt prefix=$builddir target=i386-linux$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=i386 OS_TARGET=linux clean
  make CPU_TARGET=i386 OS_TARGET=linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvJf eqmodgui-$version-$currentrev-linux_i386.tar.xz eqmodgui
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/eqmodgui/usr/
  mv bin debian/eqmodgui/usr/
  mv share debian/eqmodgui/usr/
  cd debian
  sz=$(du -s eqmodgui/usr | cut -f1)
  sed -i "s/%size%/$sz/" eqmodgui/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" eqmodgui/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build eqmodgui .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mkdir -p rpm/RPMS/x86_64
  mkdir -p rpm/RPMS/i386
  mkdir rpm/SRPMS
  mkdir rpm/tmp
  mkdir -p rpm/eqmodgui/usr/
  mv debian/eqmodgui/usr/* rpm/eqmodgui/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/eqmodgui.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/eqmodgui.spec
  setarch i386 fakeroot rpmbuild  --buildroot "$builddir/rpm/eqmodgui" --define "_topdir $builddir/rpm/" --define "_binary_payload w7.xzdio" -bb SPECS/eqmodgui.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/i386/eqmodgui*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

# make Linux x86_64 version
if [[ $make_linux64 ]]; then
  ./configure $configopt prefix=$builddir target=x86_64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 OS_TARGET=linux clean
  make CPU_TARGET=x86_64 OS_TARGET=linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvJf eqmodgui-$version-$currentrev-linux_x86_64.tar.xz eqmodgui
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.tar.xz $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/eqmodgui64/usr/
  mv bin debian/eqmodgui64/usr/
  mv share debian/eqmodgui64/usr/
  cd debian
  sz=$(du -s eqmodgui64/usr | cut -f1)
  sed -i "s/%size%/$sz/" eqmodgui64/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" eqmodgui64/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build eqmodgui64 .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # rpm
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/rpm $builddir
  cd $builddir
  mkdir -p rpm/RPMS/x86_64
  mkdir -p rpm/RPMS/i386
  mkdir rpm/SRPMS
  mkdir rpm/tmp
  mkdir -p rpm/eqmodgui/usr/
  mv debian/eqmodgui64/usr/* rpm/eqmodgui/usr/
  cd rpm
  sed -i "/Version:/ s/3/$version/"  SPECS/eqmodgui64.spec
  sed -i "/Release:/ s/1/$currentrev/" SPECS/eqmodgui64.spec
# rpm 4.7
  fakeroot rpmbuild  --buildroot "$builddir/rpm/eqmodgui" --define "_topdir $builddir/rpm/" --define "_binary_payload w7.xzdio"  -bb SPECS/eqmodgui64.spec
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv RPMS/x86_64/eqmodgui*.rpm $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

cd $wd
rm -rf $builddir

