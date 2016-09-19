#!/bin/bash 

version=0.5.3

builddir=/tmp/eqmodgui  # Be sure this is set to a non existent directory, it is removed after the run!

arch=$(arch)

# adjuste here the target you want to crossbuild
# You MUST crosscompile Freepascal and Lazarus for this targets! 

unset extratarget

make_linuxarm=1

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

save_PATH=$PATH
wd=`pwd`

currentrev=$(LC_ALL=C svn info . | grep Revision: | sed 's/Revision: //')

echo $version - $currentrev


# delete old files
  rm eqmodgui*.bz2
  rm eqmodgui*.deb
  rm -rf $builddir

# make Linux arm version
if [[ $make_linuxarm ]]; then
  ./configure $configopt prefix=$builddir target=arm-linux$extratarget
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=arm OS_TARGET=linux clean
  make CPU_TARGET=arm OS_TARGET=linux
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install
  if [[ $? -ne 0 ]]; then exit 1;fi
  # tar
  cd $builddir
  cd ..
  tar cvjf eqmodgui-$version-$currentrev-linux_arm.tar.bz2 eqmodgui
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.tar.bz2 $wd
  if [[ $? -ne 0 ]]; then exit 1;fi
  # deb
  cd $wd
  rsync -a --exclude=.svn system_integration/Linux/debian $builddir
  cd $builddir
  mv bin debian/eqmodguiarm/usr/
  mv share debian/eqmodguiarm/usr/
  cd debian
  sz=$(du -s eqmodguiarm/usr | cut -f1)
  sed -i "s/%size%/$sz/" eqmodguiarm/DEBIAN/control
  sed -i "/Version:/ s/3/$version-$currentrev/" eqmodguiarm/DEBIAN/control
  fakeroot dpkg-deb -Zxz --build eqmodguiarm .
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.deb $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $builddir
fi

