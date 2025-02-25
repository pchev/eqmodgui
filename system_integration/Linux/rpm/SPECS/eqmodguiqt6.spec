Summary: Eqmodgui is a user interface for INDI Eqmod telescope driver
Name: eqmodgui-qt6
Version: 3
Release: 1
Group: Sciences/Astronomy
License: GPLv3
URL: http://eqmodgui.sourceforge.net
Packager: Patrick Chevalley
BuildRoot: %_topdir/%{name}
BuildArch: x86_64
Obsoletes: eqmodgui
Provides: eqmodgui
Conflicts: eqmodgui
Requires: libQt6Pas.so.6()(64bit) libglib-2.0.so.0 SDL_mixer
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

