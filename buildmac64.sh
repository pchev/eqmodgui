#!/bin/bash 

version=$(grep 'eq_version' eqmod_main.pas |head -1| cut -d\' -f2)

basedir=/tmp/eqmodgui   # Be sure this is set to a non existent directory, it is removed after the run!

builddir=$basedir/eqmodgui

if [[ -n $1 ]]; then
  configopt="fpc=$1"
fi
if [[ -n $2 ]]; then
  configopt=$configopt" lazarus=$2"
fi

wd=`pwd`

currentrev=$(git rev-list --count --first-parent HEAD)

# delete old files
  rm eqmodgui*.dmg
  rm -rf $basedir

# make x86_64  Mac version
  ./configure $configopt prefix=$builddir target=x86_64-darwin
  if [[ $? -ne 0 ]]; then exit 1;fi
  make CPU_TARGET=x86_64 clean
  make CPU_TARGET=x86_64
  if [[ $? -ne 0 ]]; then exit 1;fi
  make install CPU_TARGET=x86_64
  if [[ $? -ne 0 ]]; then exit 1;fi
  # pkg
  sed -i.bak "18s/1.0/$version/"  $builddir/EQmodGUI.app/Contents/Info.plist
  rm $builddir/EQmodGUI.app/Contents/Info.plist.bak
  cp system_integration/MacOSX/eqmodgui64.pkgproj $basedir
  cp system_integration/MacOSX/readme.txt $basedir
  cd $basedir
  sed -i.bak "s/eqmodgui_version/$version/g" eqmodgui64.pkgproj 
  rm eqmodgui64.pkgproj.bak
  sed -i.bak "s/eqmodgui_version/$version/" readme.txt
  rm readme.txt.bak
  packagesbuild -v eqmodgui64.pkgproj
  if [[ $? -ne 0 ]]; then exit 1;fi
  cp readme.txt build/
  hdiutil create -anyowners -volname eqmodgui-$version-$currentrev-x86_64-macosx -imagekey zlib-level=9 -format UDZO -srcfolder ./build eqmodgui-$version-$currentrev-x86_64-macosx.dmg
  if [[ $? -ne 0 ]]; then exit 1;fi
  mv eqmodgui*.dmg $wd
  if [[ $? -ne 0 ]]; then exit 1;fi

  cd $wd
  rm -rf $basedir

