program IOCPClientTest1;

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
  DataChain in 'DataChain.pas',
  NetBase in 'NetBase.pas',
  NetMgr in 'NetMgr.pas',
  NetObjClient in 'NetObjClient.pas',
  NetBaseObj in 'NetBaseObj.pas',
  NetClientIocp in 'NetClientIocp.pas',
  NetObjClientProc in 'NetObjClientProc.pas',
  BaseDataIO in 'BaseDataIO.pas',
  IocpClientApp in 'IocpClientApp.pas',
  IocpClientAppStart in 'IocpClientAppStart.pas',
  IocpClientForm in 'IocpClientForm.pas' {frmDealAgentClient};

{$R *.res}

begin
  GlobalApp := TIocpClientApp.Create('TIocpClientApp');
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
