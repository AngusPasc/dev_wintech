program HttpServerIocpTest1;

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
  DataChain in '..\commonserver\DataChain.pas',
  NetBase in '..\commonserver\NetBase.pas',
  NetMgr in '..\commonserver\NetMgr.pas',
  NetBaseObj in '..\commonserver\NetBaseObj.pas',
  NetServerClientConnectIocp in '..\commonserver\NetServerClientConnectIocp.pas',
  NetServerIocp in '..\commonserver\NetServerIocp.pas',
  BaseDataIO in '..\commonserver\BaseDataIO.pas',
  HttpServerIocpApp in 'HttpServerIocpApp.pas',
  HttpServerIocpAppStart in 'HttpServerIocpAppStart.pas';

{$R *.res}

begin
  Writeln('Server Run');
  GlobalApp := THttpServerIocpApp.Create('THttpServerIocpApp');
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
