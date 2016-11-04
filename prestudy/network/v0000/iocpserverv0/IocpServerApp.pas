unit IocpServerApp;

interface

uses
  Windows, BaseApp, BaseWinApp, NetMgr;
  
type
  TIocpServerAppData = record
    NetMgr: TNetMgr;
  end;
  
  TIocpServerApp = Class(TBaseWinApp)
  protected
    fSrvAppData: TIocpServerAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;     
    property NetMgr: TNetMgr read fSrvAppData.NetMgr;
  end;

var
  GlobalApp: TIocpServerApp = nil;
    
implementation

uses
  Messages, windef_msg, win.wnd, Sysutils, IocpServerAppStart;
  
{ THttpApiSrvApp }

constructor TIocpServerApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fSrvAppData, SizeOf(fSrvAppData), 0);
end;

destructor TIocpServerApp.Destroy;
begin
  inherited;
end;

procedure TIocpServerApp.Finalize;
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

function TIocpServerApp.Initialize: Boolean;
begin
  fBaseWinAppData.WinAppRecord.AppCmdWnd := CreateCommandWndA(@WndProcA_DealAgentServerApp, 'dealAgentServerWindow');
  Result := IsWindow(fBaseWinAppData.WinAppRecord.AppCmdWnd);
  //Result := CreateCommandWindow(@fSrvAppData.AppWindow.CommandWindow, @AppWndProcA, 'dealAgentServerWindow');
  if not Result then
    exit;
  fSrvAppData.NetMgr := TNetMgr.Create(Self);
end;

procedure TIocpServerApp.Run;
begin
  //AppStartProc := DealAgentServerAppStart.WMAppStart;
  //PostMessage(fSrvAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  PostMessage(fBaseWinAppData.WinAppRecord.AppCmdWnd, WM_AppStart, 0, 0);
  RunAppMsgLoop;
end;

end.
