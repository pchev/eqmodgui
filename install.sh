#!/bin/bash

destdir=$1

cpu_target=$2

if [ -z "$destdir" ]; then
   export destdir=/tmp/eqmodgui
fi

echo Install eqmodgui to $destdir

install -m 755 -d $destdir
install -m 755 -d $destdir/bin
install -m 755 -d $destdir/share
install -m 755 -d $destdir/share/appdata
install -m 755 -d $destdir/share/applications
install -m 755 -d $destdir/share/doc
install -m 755 -d $destdir/share/doc/eqmodgui
install -m 755 -d $destdir/share/pixmaps
install -m 755 -d $destdir/share/icons
install -m 755 -d $destdir/share/icons/hicolor
install -m 755 -d $destdir/share/icons/hicolor/48x48
install -m 755 -d $destdir/share/icons/hicolor/48x48/apps

install -v -m 755 -s eqmodgui  $destdir/bin/eqmodgui
install -v -m 644 system_integration/Linux/share/applications/eqmodgui.desktop $destdir/share/applications/eqmodgui.desktop
install -v -m 644 system_integration/Linux/share/appdata/eqmodgui.appdata.xml $destdir/share/appdata/eqmodgui.appdata.xml
install -v -m 644 system_integration/Linux/share/doc/eqmodgui/changelog $destdir/share/doc/eqmodgui/changelog
install -v -m 644 system_integration/Linux/share/doc/eqmodgui/copyright $destdir/share/doc/eqmodgui/copyright
install -v -m 644 system_integration/Linux/share/pixmaps/eqmodgui.png $destdir/share/pixmaps/eqmodgui.png
install -v -m 644 system_integration/Linux/share/icons/hicolor/48x48/apps/eqmodgui.png $destdir/share/icons/hicolor/48x48/apps/eqmodgui.png
