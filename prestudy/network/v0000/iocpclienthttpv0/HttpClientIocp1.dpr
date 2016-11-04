program HttpClientIocp1;

uses
  WinSock2 in '..\..\..\..\common\WinSock2.pas',
  windef_msg in '..\..\..\..\v0001\windef\windef_msg.pas',
  Base.Run in '..\..\..\..\v0001\rec\app_base\Base.Run.pas',
  Base.thread in '..\..\..\..\v0001\rec\app_base\Base.thread.pas',
  win.app in '..\..\..\..\v0001\rec\win_app\win.app.pas',
  win.diskfile in '..\..\..\..\v0001\rec\win_sys\win.diskfile.pas',
  win.cpu in '..\..\..\..\v0001\rec\win_sys\win.cpu.pas',
  win.error in '..\..\..\..\v0001\rec\win_sys\win.error.pas',
  win.iocp in '..\..\..\..\v0001\rec\win_sys\win.iocp.pas',
  win.thread in '..\..\..\..\v0001\rec\win_sys\win.thread.pas',
  BaseThread in '..\..\..\..\v0001\obj\app_base\BaseThread.pas',
  BaseApp in '..\..\..\..\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\..\v0001\obj\app_base\BasePath.pas',
  BaseWinFormApp in '..\..\..\..\v0001\obj\win_app\BaseWinFormApp.pas',
  BaseWinApp in '..\..\..\..\v0001\obj\win_app\BaseWinApp.pas',
  BaseForm in '..\..\..\..\v0001\obj\win_uiform\BaseForm.pas' {frmBase},
  win.wnd in '..\..\..\..\v0001\winproc\win.wnd.pas',
  DataChain in '..\commonclient\DataChain.pas',
  NetBase in '..\commonclient\NetBase.pas',
  NetMgr in '..\commonclient\NetMgr.pas',
  NetObjClient in '..\commonclient\NetObjClient.pas',
  NetBaseObj in '..\commonclient\NetBaseObj.pas',
  NetClientIocp in '..\commonclient\NetClientIocp.pas',
  NetObjClientProc in '..\commonclient\NetObjClientProc.pas',
  BaseDataIO in '..\commonclient\BaseDataIO.pas',
  HttpClientIocpApp in 'HttpClientIocpApp.pas',
  HttpClientIocpAppStart in 'HttpClientIocpAppStart.pas',
  HttpClientIocpForm in 'HttpClientIocpForm.pas' {frmHttpClientIocp};

{$R *.res}

begin
  GlobalApp := THttpClientIocpApp.Create('TIocpClientApp');
  try
    if GlobalApp.Initialize then
    begin
      GlobalApp.Run;
    end;
    GlobalApp.Finalize;
  finally
    GlobalApp.Free;
  end;
end.
