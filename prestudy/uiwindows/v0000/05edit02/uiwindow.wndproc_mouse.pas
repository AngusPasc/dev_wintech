unit uiwindow.wndproc_mouse;

interface

uses
  Windows, Messages,
  ui.form.windows;

  function UIFormWndWMSetCursor(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam): LRESULT;
  procedure UIFormWndWMLButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMLButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMMouseMove(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMRButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMRButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMMouseWheel(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uidraw.windc,
  uidraw.text.windc;

var
  IBeamCursor: HCURSOR = 0;   
  HandCursor: HCURSOR = 0;
  ArrowCursor: HCURSOR = 0;
  
function UIFormWndWMSetCursor(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam): LRESULT;
begin
(*
  TWMSetCursor = packed record
    Msg: Cardinal;
    CursorWnd: HWND;
    HitTest: Word;
    MouseMsg: Word;
    Result: Longint;
  end;
*)

  if 0 = ArrowCursor then
    ArrowCursor := Windows.LoadCursor(0, MAKEINTRESOURCE(IDC_ARROW));
  if 0 = IBeamCursor then
    IBeamCursor := Windows.LoadCursor(0, MAKEINTRESOURCE(IDC_IBEAM));
  if 0 = HandCursor then
    HandCursor := Windows.LoadCursor(0, MAKEINTRESOURCE(IDC_HAND));

  Windows.SetCursor(IBeamCursor);
  Result := 1;
  exit;
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, WM_SetCursor, wParam, lParam);
end;

procedure UIFormWndWMLButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
  AUIFormWnd.BaseWnd.WMLBUTTONDOWN_LParam  := lparam;   
end;

procedure UIFormWndWMLButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
  AUIFormWnd.BaseWnd.WMLBUTTONUP_LParam    := lparam;
end;
                      
procedure UIFormWndWMMouseMove(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin                        
  AUIFormWnd.BaseWnd.WMMOUSEMOVE_LParam    := lparam;
end;
     
procedure UIFormWndWMRButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin                         
  AUIFormWnd.BaseWnd.WMRBUTTONDOWN_LParam  := lparam;
end;

procedure UIFormWndWMRButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
  AUIFormWnd.BaseWnd.WMRBUTTONUP_LParam    := lparam;
end;

procedure UIFormWndWMMouseWheel(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

end.
