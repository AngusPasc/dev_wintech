unit HttpClientIocpApp;

interface

uses
  Windows, BaseForm, BaseApp, BaseWinFormApp, NetMgr;
  
type
  THttpClientIocpAppData = record
    NetMgr: TNetMgr;
    ConsoleForm: TfrmBase;
  end;
  
  THttpClientIocpApp = Class(TBaseWinFormApp)
  protected
    fAppData: THttpClientIocpAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    destructor Destroy; override;        
    function Initialize: Boolean; override;
    procedure Finalize; override;
    procedure Run; override;     
    property NetMgr: TNetMgr read fAppData.NetMgr;
  end;

var
  GlobalApp: THttpClientIocpApp = nil;
    
implementation

uses
  Messages, Forms, Sysutils,
  windef_msg, win.wnd, HttpClientIocpAppStart, HttpClientIocpForm;
  
{ THttpApiSrvApp }

constructor THttpClientIocpApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fAppData, SizeOf(fAppData), 0);
end;

destructor THttpClientIocpApp.Destroy;
begin
  inherited;
end;

procedure THttpClientIocpApp.Finalize;
begin
  //DestroyCommandWindow(@fSrvAppData.AppWindow.CommandWindow);
  FreeAndNIl(fAppData.NetMgr);
end;
                      
function WndProcA_DealAgentClientApp(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
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

function THttpClientIocpApp.Initialize: Boolean;
begin
  Application.Initialize;
  fBaseWinAppData.WinAppRecord.AppCmdWnd := CreateCommandWndA(@WndProcA_DealAgentClientApp, 'DealAgentClientWindow');
  Result := IsWindow(fBaseWinAppData.WinAppRecord.AppCmdWnd);
  //Result := CreateCommandWindow(@fSrvAppData.AppWindow.CommandWindow, @AppWndProcA, 'DealAgentClientWindow');
  if not Result then
    exit;
  fAppData.NetMgr := TNetMgr.Create(Self);
end;

procedure THttpClientIocpApp.Run;
begin
  //AppStartProc := DealAgentClientAppStart.WMAppStart;
  //PostMessage(fSrvAppData.AppWindow.CommandWindow.WindowHandle, WM_AppStart, 0, 0);
  PostMessage(fBaseWinAppData.WinAppRecord.AppCmdWnd, WM_AppStart, 0, 0);
  //RunAppMsgLoop;
  Application.CreateForm(TfrmHttpClientIocp, fAppData.ConsoleForm);
  fAppData.ConsoleForm.Initialize(Self);         
  Application.Run;
end;

end.
