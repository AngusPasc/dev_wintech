unit win.wnd;

interface

uses
  Windows;

  function CreateCommandWndA(AWndProc: TFNWndProc; AWndClassName: AnsiString): HWND;
  function CreateCommandWndW(AWndProc: TFNWndProc; AWndClassName: WideString): HWND;

implementation

function CreateCommandWndA(AWndProc: TFNWndProc; AWndClassName: AnsiString): HWND;
var
  tmpIsRegistered: Boolean;
  tmpCheckWndClass: TWndClassA;     
  tmpRegWndClass: TWndClassA;
begin                    
  //SDLogutils.Log(logtag, 'InternalCreateInjectWindow begin');
  Result := 0;
  if nil = AWndProc then
    Exit;
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  tmpRegWndClass.hInstance := HInstance;
    //tmpRegWndClass.lpfnWndProc := @AppWndProcA;
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := PAnsiChar(AWndClassName);
  
  tmpIsRegistered := Windows.GetClassInfoA(HInstance, tmpRegWndClass.lpszClassName, tmpCheckWndClass);

  if tmpIsRegistered then
  begin
    if tmpCheckWndClass.lpfnWndProc <> AWndProc then
    begin
      Windows.UnregisterClass(tmpRegWndClass.lpszClassName, HInstance);
      tmpIsRegistered := false;
    end;
  end;
  if not tmpIsRegistered then
  begin
    Windows.RegisterClassA(tmpRegWndClass);
  end;
  Result := Windows.CreateWindowExA(
    WS_EX_TOOLWINDOW,
    tmpRegWndClass.lpszClassName,
    '',
    WS_POPUP {+ 0}, 0, 0, 0, 0, HWND_MESSAGE, 0, HInstance, nil);
  if IsWindow(Result) then
  begin
    SetParent(Result, HWND_MESSAGE);
  end else
    Result := 0;
end;

function CreateCommandWndW(AWndProc: TFNWndProc; AWndClassName: WideString): HWND;
var
  tmpIsRegistered: Boolean;
  tmpCheckWndClass: TWndClassW;
  tmpRegWndClass: TWndClassW;
begin                    
  //SDLogutils.Log(logtag, 'InternalCreateInjectWindow begin');
  Result := 0;
  if nil = AWndProc then
    Exit;
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  tmpRegWndClass.hInstance := HInstance;
    //tmpRegWndClass.lpfnWndProc := @AppWndProcA;
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.lpszClassName := PWideChar(AWndClassName);
  
  tmpIsRegistered := Windows.GetClassInfoW(HInstance, tmpRegWndClass.lpszClassName, tmpCheckWndClass);

  if tmpIsRegistered then
  begin
    if tmpCheckWndClass.lpfnWndProc <> AWndProc then
    begin
      Windows.UnregisterClassW(tmpRegWndClass.lpszClassName, HInstance);
      tmpIsRegistered := false;
    end;
  end;
  if not tmpIsRegistered then
  begin
    Windows.RegisterClassW(tmpRegWndClass);
  end;
  Result := Windows.CreateWindowExW(
    0,//WS_EX_TOOLWINDOW,
    tmpRegWndClass.lpszClassName,
    '',
    WS_POPUP {+ 0}, 0, 0, 0, 0, HWND_MESSAGE, 0, HInstance, nil);
  if Windows.IsWindow(Result) then
  begin
    Windows.SetParent(Result, HWND_MESSAGE);
  end else
    Result := 0;
end;

end.
