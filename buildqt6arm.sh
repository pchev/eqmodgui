#!/bin/bash 

version=$(grep 'eq_version' eqmod_main.pas |head -1| cut -d\' -f2)

builddir=/tmp/eqmodgui  # Be sure this is set to a non existent directory, it is removed after the run!

arch=$(arch)

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
  rm eqmodgui-qt6-*_armhf.tar.bz2
  rm eqmodgui-qt6_*_armhf.deb
  rm -rf $builddir

# make Linux arm version
  ./configure $configopt prefix=$builddir target=aarch64-linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=aarch64 OS_TARGET=linux LCL_PLATFORM=qt6 clean
  make CPU_TARGET=aarch64 OS_TARGET=linux LCL_PLATFORM=qt6 opt_target=-k--build-id
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install CPU_TARGET=aarch64
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvjf eqmodgui-qt6-$version-$currentrev-linux_arm64.tar.bz2 eqmodgui
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mkdir debian/eqmodguiarmqt6/usr/
  mv bin debian/eqmodguiarmqt6/usr/
  mv share debian/eqmodguiarmqt6/usr/
  cd debian
  sz=$(du -s eqmodguiarmqt6/usr | cut -f1)
  sed -i "s/%size%/$sz/" eqmodguiarmqt6/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" eqmodguiarmqt6/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build eqmodguiarmqt6 .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir

