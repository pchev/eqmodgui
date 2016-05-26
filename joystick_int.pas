unit joystick_int;

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

uses indibaseclient, indibasedevice, indiapi, indicom,
     ExtCtrls, Forms, Classes, SysUtils;

type
  TNotifyMsg = procedure(msg:string) of object;
  TNotifyNum = procedure(d: double) of object;

type

T_indijoystick = class(TIndiBaseClient)
 private
   InitTimer: TTimer;
   JoystickDevice: Basedevice;
   Joystickport: ITextVectorProperty;
   configprop: ISwitchVectorProperty;
   configload,configsave,configdefault: ISwitch;
   Fready,Fconnected,FAutoloadConfig: boolean;
   Findiserver, Findiserverport, Findidevice, Findideviceport: string;
   FStatus: TDeviceStatus;
   FonDestroy: TNotifyEvent;
   FonMsg: TNotifyMsg;
   FonStatusChange: TNotifyEvent;
   procedure InitTimerTimer(Sender: TObject);
   procedure ClearStatus;
   procedure CheckStatus;
   procedure NewDevice(dp: Basedevice);
   procedure NewMessage(txt: string);
   procedure NewProperty(indiProp: IndiProperty);
   procedure NewNumber(nvp: INumberVectorProperty);
   procedure NewText(tvp: ITextVectorProperty);
   procedure NewSwitch(svp: ISwitchVectorProperty);
   procedure NewLight(lvp: ILightVectorProperty);
   procedure DeleteDevice(dp: Basedevice);
   procedure DeleteProperty(indiProp: IndiProperty);
   procedure ServerConnected(Sender: TObject);
   procedure ServerDisconnected(Sender: TObject);
   procedure msg(txt: string);
   function  GetStatusError: string;
 public
   constructor Create;
   destructor  Destroy; override;
   Procedure Connect;
   Procedure Disconnect;
   procedure SaveConfig;
   procedure LoadConfig;
   property indiserver: string read Findiserver write Findiserver;
   property indiserverport: string read Findiserverport write Findiserverport;
   property indidevice: string read Findidevice write Findidevice;
   property indideviceport: string read Findideviceport write Findideviceport;
   property AutoloadConfig: boolean read FAutoloadConfig write FAutoloadConfig;
   property Status: TDeviceStatus read FStatus;
   property StatusError: string read GetStatusError;
   property onDestroy: TNotifyEvent read FonDestroy write FonDestroy;
   property onMsg: TNotifyMsg read FonMsg write FonMsg;
   property onStatusChange: TNotifyEvent read FonStatusChange write FonStatusChange;
end;

implementation

constructor T_indijoystick.Create;
begin
 inherited Create;
 ClearStatus;
 Findiserver:='localhost';
 Findiserverport:='7624';
 Findidevice:='Joystick';
 Findideviceport:='';
 InitTimer:=TTimer.Create(nil);
 InitTimer.Enabled:=false;
 InitTimer.Interval:=3000;
 InitTimer.OnTimer:=@InitTimerTimer;
 onNewDevice:=@NewDevice;
 onNewMessage:=@NewMessage;
 onNewProperty:=@NewProperty;
 onNewNumber:=@NewNumber;
 onNewText:=@NewText;
 onNewSwitch:=@NewSwitch;
 onNewLight:=@NewLight;
 onDeleteDevice:=@DeleteDevice;
 onDeleteProperty:=@DeleteProperty;
 onServerConnected:=@ServerConnected;
 onServerDisconnected:=@ServerDisconnected;
end;

destructor  T_indijoystick.Destroy;
begin
 if assigned(FonDestroy) then FonDestroy(self);
 onNewDevice:=nil;
 onNewMessage:=nil;
 onNewProperty:=nil;
 onNewNumber:=nil;
 onNewText:=nil;
 onNewSwitch:=nil;
 onNewLight:=nil;
 onNewBlob:=nil;
 onServerConnected:=nil;
 onServerDisconnected:=nil;
 if InitTimer<>nil then FreeAndNil(InitTimer);
 inherited Destroy;
end;

procedure T_indijoystick.ClearStatus;
begin
    configprop:=nil;
    Fready:=false;
    Fconnected := false;
    FStatus := devDisconnected;
    if Assigned(FonStatusChange) then FonStatusChange(self);
end;

procedure T_indijoystick.CheckStatus;
begin
    if Fconnected and
       (configprop<>nil)
    then begin
       FStatus := devConnected;
       if (not Fready) and Assigned(FonStatusChange) then FonStatusChange(self);
       Fready:=true;
       if FAutoloadConfig then begin
         LoadConfig;
       end;
    end;
end;

function  T_indijoystick.GetStatusError: string;
begin
if Fconnected then begin
   Result:='Missing properties: ';
   if (configprop=nil) then Result:=Result+'CONFIG_PROCESS, ';
end else
  Result:='Not connected';
end;


procedure T_indijoystick.msg(txt: string);
begin
  if Assigned(FonMsg) then FonMsg(txt);
end;

Procedure T_indijoystick.Connect;
begin
if not Connected then begin
  FStatus := devDisconnected;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  SetServer(indiserver,indiserverport);
  watchDevice(indidevice);
  ConnectServer;
  FStatus := devConnecting;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  InitTimer.Enabled:=true;
end
else msg('Already connected');
end;

procedure T_indijoystick.InitTimerTimer(Sender: TObject);
begin
  InitTimer.Enabled:=false;
  if (JoystickDevice=nil)or(not Fready) then begin
     msg('Initialisation failed.');
     msg(GetStatusError);
     Disconnect;
  end;
end;

Procedure T_indijoystick.Disconnect;
begin
Terminate;
ClearStatus;
end;

procedure T_indijoystick.ServerConnected(Sender: TObject);
begin
   if (Joystickport<>nil)and(Findideviceport<>'') then begin
      Joystickport.tp[0].text:=Findideviceport;
      sendNewText(Joystickport);
   end;
   connectDevice(Findidevice);
end;

procedure T_indijoystick.ServerDisconnected(Sender: TObject);
begin
  FStatus := devDisconnected;
  if Assigned(FonStatusChange) then FonStatusChange(self);
  msg('Mount server disconnected');
end;

procedure T_indijoystick.NewDevice(dp: Basedevice);
begin
  //writeln('Newdev: '+dp.getDeviceName);
  if dp.getDeviceName=Findidevice then begin
     Fconnected:=true;
     JoystickDevice:=dp;
  end;
end;

procedure T_indijoystick.DeleteDevice(dp: Basedevice);
begin
  if dp.getDeviceName=Findidevice then begin
     Disconnect;
  end;
end;

procedure T_indijoystick.DeleteProperty(indiProp: IndiProperty);
begin
  { TODO :  check if a vital property is removed ? }
end;

procedure T_indijoystick.NewMessage(txt: string);
begin
  msg(txt);
end;

procedure T_indijoystick.NewProperty(indiProp: IndiProperty);
var propname: string;
    proptype: INDI_TYPE;
    i: integer;
begin
  propname:=indiProp.getName;
  proptype:=indiProp.getType;

  if (proptype=INDI_TEXT)and(propname='DEVICE_PORT') then begin
     Joystickport:=indiProp.getText;
  end
  else if (proptype=INDI_SWITCH)and(propname='CONFIG_PROCESS') then begin
     configprop:=indiProp.getSwitch;
     configload:=IUFindSwitch(configprop,'CONFIG_LOAD');
     configsave:=IUFindSwitch(configprop,'CONFIG_SAVE');
     configdefault:=IUFindSwitch(configprop,'CONFIG_DEFAULT');
     if (configload=nil)or(configsave=nil)or(configdefault=nil) then configprop:=nil;
  end
  ;
  CheckStatus;
end;

procedure T_indijoystick.NewNumber(nvp: INumberVectorProperty);
begin
end;

procedure T_indijoystick.NewText(tvp: ITextVectorProperty);
begin
//  writeln('NewText: '+tvp.name+' '+tvp.tp[0].text);
end;

procedure T_indijoystick.NewSwitch(svp: ISwitchVectorProperty);
begin
end;

procedure T_indijoystick.NewLight(lvp: ILightVectorProperty);
begin
//  writeln('NewLight: '+lvp.name);
end;

procedure T_indijoystick.SaveConfig;
begin
  if configprop<>nil then begin
    IUResetSwitch(configprop);
    configsave.s:=ISS_ON;
    sendNewSwitch(configprop);
  end;
end;

procedure T_indijoystick.LoadConfig;
begin
  if configprop<>nil then begin
    IUResetSwitch(configprop);
    configload.s:=ISS_ON;
    sendNewSwitch(configprop);
  end;
end;

end.

