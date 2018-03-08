unit eqmod_setup;

{$mode objfpc}{$H+}

{
Copyright (C) 2015 Patrick Chevalley

http://www.ap-i.net
pch@ap-i.net

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>. 

}

interface

uses  UScaleDPI,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { Tf_eqmodsetup }

  Tf_eqmodsetup = class(TForm)
    Button1: TButton;
    AutoLoadConfig: TCheckBox;
    UseSysColor: TCheckBox;
    UnparkTrack: TCheckBox;
    JoystickDriver: TEdit;
    JoystickCheckBox: TCheckBox;
    Label4: TLabel;
    PanelJoystick: TPanel;
    SoundCheckBox: TCheckBox;
    Driver: TEdit;
    Label3: TLabel;
    PanelSound: TPanel;
    Server: TEdit;
    Serverport: TEdit;
    Label2: TLabel;
    Sim: TCheckBox;
    Port: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  f_eqmodsetup: Tf_eqmodsetup;

implementation

{$R *.lfm}

{ Tf_eqmodsetup }

procedure Tf_eqmodsetup.FormCreate(Sender: TObject);
begin
   ScaleDPI(Self);
end;

end.

