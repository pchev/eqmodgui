program eqmodgui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, sysutils, eqmod_main, eqmod_int, eqmod_setup, u_ccdconfig
  { you can add units after this };

{$R *.res}

begin
  {$ifdef USEHEAPTRC}
  DeleteFile('/tmp/eqmodgui_heap.trc');
  SetHeapTraceOutput('/tmp/eqmodgui_heap.trc');
  {$endif}

  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(Tf_eqmod, f_eqmod);
  Application.Run;
end.

