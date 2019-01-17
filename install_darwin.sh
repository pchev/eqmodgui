#!/bin/bash

destdir=$1

if [ -z "$destdir" ]; then
   export destdir=/tmp/eqmodgui
fi

echo Install eqmodgui to $destdir

install -d -m 755 $destdir
install -d -m 755 $destdir/EQmodGUI.app
install -d -m 755 $destdir/EQmodGUI.app/Contents
install -d -m 755 $destdir/EQmodGUI.app/Contents/MacOS
install -d -m 755 $destdir/EQmodGUI.app/Contents/Resources
install -v -m 644 system_integration/MacOSX/pkg/EQmodGUI.app/Contents/Info.plist $destdir/EQmodGUI.app/Contents/
install -v -m 644 system_integration/MacOSX/pkg/EQmodGUI.app/Contents/PkgInfo $destdir/EQmodGUI.app/Contents/
install -v -m 755 -s eqmodgui  $destdir/EQmodGUI.app/Contents/MacOS/eqmodgui
install -v -m 644 system_integration/MacOSX/pkg/EQmodGUI.app/Contents/Resources/README.rtf $destdir/EQmodGUI.app/Contents/Resources/
install -v -m 644 system_integration/MacOSX/pkg/EQmodGUI.app/Contents/Resources/eqmodgui.icns $destdir/EQmodGUI.app/Contents/Resources/

#install -v -m 644 sound/custom.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/lunar.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/parked.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate10.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate1.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate2.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate3.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate4.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate5.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate6.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate7.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate8.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/rate9.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/sidereal.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/solar.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/stop.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/sync.wav $destdir/EQmodGUI.app/Contents/Resources/
#install -v -m 644 sound/unparked.wav $destdir/EQmodGUI.app/Contents/Resources/
