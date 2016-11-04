program IocpServerTest1;

// {$APPTYPE CONSOLE}
{$APPTYPE CONSOLE}

uses
  WinSock2 in '..\..\..\..\common\WinSock2.pas',
  Base.Run in '..\..\..\..\v0001\rec\app_base\Base.Run.pas',
  Base.thread in '..\..\..\..\v0001\rec\app_base\Base.thread.pas',
  win.app in '..\..\..\..\v0001\rec\win_app\win.app.pas',
  win.diskfile in '..\..\..\..\v0001\rec\win_sys\win.diskfile.pas',
  win.cpu in '..\..\..\..\v0001\rec\win_sys\win.cpu.pas',
  win.iocp in '..\..\..\..\v0001\rec\win_sys\win.iocp.pas',
  win.thread in '..\..\..\..\v0001\rec\win_sys\win.thread.pas',
  win.error in '..\..\..\..\v0001\rec\win_sys\win.error.pas',
  BaseThread in '..\..\..\..\v0001\obj\app_base\BaseThread.pas',
  BaseApp in '..\..\..\..\v0001\obj\app_base\BaseApp.pas',
  BasePath in '..\..\..\..\v0001\obj\app_base\BasePath.pas',
  BaseWinApp in '..\..\..\..\v0001\obj\win_app\BaseWinApp.pas',
  windef_msg in '..\..\..\..\v0001\windef\windef_msg.pas',
  win.wnd in '..\..\..\..\v0001\winproc\win.wnd.pas',
  DataChain in 'DataChain.pas',
  NetBase in 'NetBase.pas',
  NetMgr in 'NetMgr.pas',
  NetBaseObj in 'NetBaseObj.pas',
  NetSrvClientIocp in 'NetSrvClientIocp.pas',
  NetServerIocp in 'NetServerIocp.pas',
  BaseDataIO in 'BaseDataIO.pas',
  IocpServerApp in 'IocpServerApp.pas',
  IocpServerAppStart in 'IocpServerAppStart.pas';

{$R *.res}

begin
  Writeln('Server Run');
  GlobalApp := TIocpServerApp.Create('TIocpServerApp');
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
