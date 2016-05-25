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
install -m 755 -d $destdir/share/eqmodgui
install -m 755 -d $destdir/share/eqmodgui/sound
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
install -v -m 644 sound/custom.wav $destdir/share/eqmodgui/sound/custom.wav
install -v -m 644 sound/lunar.wav $destdir/share/eqmodgui/sound/lunar.wav
install -v -m 644 sound/parked.wav $destdir/share/eqmodgui/sound/parked.wav
install -v -m 644 sound/rate10.wav $destdir/share/eqmodgui/sound/rate10.wav
install -v -m 644 sound/rate1.wav $destdir/share/eqmodgui/sound/rate1.wav
install -v -m 644 sound/rate2.wav $destdir/share/eqmodgui/sound/rate2.wav
install -v -m 644 sound/rate3.wav $destdir/share/eqmodgui/sound/rate3.wav
install -v -m 644 sound/rate4.wav $destdir/share/eqmodgui/sound/rate4.wav
install -v -m 644 sound/rate5.wav $destdir/share/eqmodgui/sound/rate5.wav
install -v -m 644 sound/rate6.wav $destdir/share/eqmodgui/sound/rate6.wav
install -v -m 644 sound/rate7.wav $destdir/share/eqmodgui/sound/rate7.wav
install -v -m 644 sound/rate8.wav $destdir/share/eqmodgui/sound/rate8.wav
install -v -m 644 sound/rate9.wav $destdir/share/eqmodgui/sound/rate9.wav
install -v -m 644 sound/sidereal.wav $destdir/share/eqmodgui/sound/sidereal.wav
install -v -m 644 sound/solar.wav $destdir/share/eqmodgui/sound/solar.wav
install -v -m 644 sound/stop.wav $destdir/share/eqmodgui/sound/stop.wav
install -v -m 644 sound/sync.wav $destdir/share/eqmodgui/sound/sync.wav
install -v -m 644 sound/unparked.wav $destdir/share/eqmodgui/sound/unparked.wav
