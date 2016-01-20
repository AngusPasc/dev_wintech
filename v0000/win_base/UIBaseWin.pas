unit UIBaseWin;

interface

uses
  Windows,
  BaseWinThread;
                
type
  PUIBaseWnd        = ^TUIBaseWnd;
  TUIBaseWnd        = packed record
    UIWndHandle     : HWND;
    UIWndParent     : HWND;
    Style           : DWORD;
    ExStyle         : DWORD;
    WindowRect      : TRect;
    ClientRect      : TRect;
    WinThread       : PSysWinThread;
  end;

  function CreateUIWndA(AUIWnd: PUIBaseWnd; AWndProc: TFNWndProc): Boolean;

implementation

function CreateUIWndA(AUIWnd: PUIBaseWnd; AWndProc: TFNWndProc): Boolean;
var
  tmpRegWndClass: TWndClassA;
  tmpCheckWndClass: TWndClassA;
  tmpIsRegistered: Boolean;
  tmpRegAtom: ATOM;
begin
  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  
  tmpRegWndClass.lpszClassName := 'testwnd';
  tmpRegWndClass.lpfnWndProc := AWndProc;
  tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
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
    tmpRegAtom := Windows.RegisterClassA(tmpRegWndClass);
    if 0 = tmpRegAtom then
    begin
      exit;
    end;
  end;

  AUIWnd.UIWndHandle := Windows.CreateWindowExA(
    AUIWnd.ExStyle,
    tmpRegWndClass.lpszClassName,
    '',
    AUIWnd.Style {+ 0},
    AUIWnd.WindowRect.Left,
    AUIWnd.WindowRect.Top,
    AUIWnd.ClientRect.Right,
    AUIWnd.ClientRect.Bottom, 0, 0, HInstance, nil);
  Result := IsWindow(AUIWnd.UIWndHandle);  
end;

end.
