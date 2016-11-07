unit HttpServerIocpApp;

interface

uses
  Windows, BaseApp, BaseWinApp, NetMgrHttpServer;
  
type
  THttpServerIocpAppData = record
    NetMgr: TNetMgr;
  end;
  
  THttpServerIocpApp = Class(TBaseWinApp)
  protected
    fSrvAppData: THttpServerIocpAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;     
    property NetMgr: TNetMgr read fSrvAppData.NetMgr;
  end;

var
  GlobalApp: THttpServerIocpApp = nil;
    
implementation

uses
  Messages, windef_msg, win.wnd, Sysutils, HttpServerIocpAppStart;
  
{ THttpApiSrvApp }

constructor THttpServerIocpApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fSrvAppData, SizeOf(fSrvAppData), 0);
end;

destructor THttpServerIocpApp.Destroy;
begin
  inherited;
end;

procedure THttpServerIocpApp.Finalize;
begin
  //DestroyCommandWindow(@fSrvAppData.AppWindow.CommandWindow);
  FreeAndNIl(fSrvAppData.NetMgr);
end;
                      
function WndProcA_DealAgentServerApp(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := 0;
  case AMsg of
    WM_COPYDATA: begin

    end;
    WM_AppStart: begin
      WMAppStart;
    end
    else
      Result := DefWindowProcA(AWnd, AMsg, wParam, lParam);
  end;
end;

function THttpServerIocpApp.Initialize: Boolean;
begin
  fBaseWinAppData.WinAppRecord.AppCmdWnd := CreateCommandWndA(@WndProcA_DealAgentServerApp, 'dealAgentServerWindow');
  Result := IsWindow(fBaseWinAppData.WinAppRecord.AppCmdWnd);
  //Result := CreateCommandWindow(@fSrvAppData.AppWindow.CommandWindow, @AppWndProcA, 'dealAgentServerWindow');
  if not Result then
    exit;
  fSrvAppData.NetMgr := TNetMgr.Create(Self);
end;

procedure THttpServerIocpApp.Run;
begin
  //AppStartProc := DealAgentServerAppStart.WMAppStart;
  //PostMessage(fSrvAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  PostMessage(fBaseWinAppData.WinAppRecord.AppCmdWnd, WM_AppStart, 0, 0);
  RunAppMsgLoop;
end;

end.
