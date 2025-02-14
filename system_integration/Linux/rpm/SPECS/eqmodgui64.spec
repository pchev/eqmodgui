Summary: Eqmodgui is a user interface for INDI Eqmod telescope driver
Name: eqmodgui
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv3
URL: http://eqmodgui.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: x86_64
Provides: eqmodgui
Requires: qt5pas glib2 libjpeg libpng SDL_mixer
AutoReqProv: no

%description
It allow to easily set the main parameters require to use this driver and manage the alignment data.

%files
%defattr(-,root,root)
/usr/bin/eqmodgui
/usr/share/appdata/eqmodgui.appdata.xml
/usr/share/applications/eqmodgui.desktop
/usr/share/pixmaps/eqmodgui.png
/usr/share/icons/hicolor/48x48/apps/eqmodgui.png
/usr/share/doc/eqmodgui
/usr/share/eqmodgui

