program pj_httpsys;

uses
  Forms,
  form_httpsys in 'form_httpsys.pas' {Form1},
  win.httpsys in '..\..\..\v0001\rec\win_net\win.httpsys.pas',
  WinSock2 in '..\..\..\common\WinSock2.pas',
  HttpApiServer in 'HttpApiServer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
