unit BaseWinApp;

interface

uses
  Windows,
  win.app,
  BaseApp;
  
type        
  TBaseWinAppPath = class(TBaseAppPath)
  protected
  public
    function IsFileExists(AFileUrl: WideString): Boolean; override;
  end;
  
  PBaseWinAppData = ^TBaseWinAppData;
  TBaseWinAppData = record
    WinAppRecord  : TWinAppRecord;
    AppPath       : TBaseWinAppPath;
  end;

  TBaseWinApp = class(TBaseApp)
  protected
    fBaseWinAppData: TBaseWinAppData;  
    function GetBaseWinAppData: PBaseWinAppData;
  public
    constructor Create(AppClassId: AnsiString); override;
    procedure RunAppMsgLoop;
                                 
    procedure DestroyAppCommandWindow;
    function CheckSingleInstance(AppMutexName: AnsiString): Boolean;
    procedure Terminate; override;
    property BaseWinAppData: PBaseWinAppData read GetBaseWinAppData;
    property AppWindow: HWND read fBaseWinAppData.WinAppRecord.AppCmdWnd write fBaseWinAppData.WinAppRecord.AppCmdWnd;
  end;

  TBaseWinAppAgent = class(TBaseAppAgent)
  protected
  public
  end;
  
var
  GlobalBaseWinApp: TBaseWinApp = nil;
    
implementation

uses
  SysUtils,
  //UtilsLog,
  messages,
  windef_msg;
  
{ TBaseWinApp }

constructor TBaseWinApp.Create(AppClassId: AnsiString);
begin
  inherited;
  FillChar(fBaseWinAppData, SizeOf(fBaseWinAppData), 0);
  GlobalBaseWinApp := Self;
end;

procedure TBaseWinApp.DestroyAppCommandWindow;
begin
//
end;
          
procedure TBaseWinApp.Terminate;
begin
  if RunStatus_Active = Self.RunStatus then
  begin
    //Log('BaseWinApp.pas', 'Terminate');
    Self.RunStatus := RunStatus_RequestShutdown;
    if IsWIndow(fBaseWinAppData.WinAppRecord.AppCmdWnd) then
    begin
      PostMessage(fBaseWinAppData.WinAppRecord.AppCmdWnd, WM_AppRequestEnd, 0, 0);
    end;
    //Log('BaseWinApp.pas', 'Finalize');    
    Self.Finalize;       
    //PostMessage(fBaseWinAppData.WinAppRecord.AppCmdWnd, WM_Quit, 0, 0);
    //Log('BaseWinApp.pas', 'PostQuitMessage0');    
    //PostQuitMessage(0);
  end else
  begin
    //Windows.TerminateProcess(GetCurrentProcess, 0);
  end;
end;

function TBaseWinApp.GetBaseWinAppData: PBaseWinAppData;
begin
  Result := @fBaseWinAppData;
end;

procedure TBaseWinApp.RunAppMsgLoop;
begin
  while Windows.GetMessage(fBaseWinAppData.WinAppRecord.AppMsg, 0, 0, 0) do
  begin
    TranslateMessage(fBaseWinAppData.WinAppRecord.AppMsg);
    DispatchMessage(fBaseWinAppData.WinAppRecord.AppMsg);
  end;
end;

function TBaseWinApp.CheckSingleInstance(AppMutexName: AnsiString): Boolean;
begin                                           
  if AppMutexName = '' then
    AppMutexName := ExtractFileName(ParamStr(0));
  fBaseWinAppData.WinAppRecord.AppMutexHandle := CreateMutexA(nil, False, PAnsiChar(AppMutexName));
  Result := GetLastError <> ERROR_ALREADY_EXISTS;
end;

function TBaseWinAppPath.IsFileExists(AFileUrl: WideString): Boolean;
begin
  Result := SysUtils.FileExists(AFileUrl);
end;

end.
