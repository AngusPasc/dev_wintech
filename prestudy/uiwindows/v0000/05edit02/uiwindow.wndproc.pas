unit uiwindow.wndproc;

interface

uses
  Windows,
  uiwin.wnd;

  function UIWindowProcW(AUIWnd: PWndUI; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;

implementation

function UIWindowProcW(AUIWnd: PWndUI; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AWnd, AMsg, wParam, lParam);
end;

end.
