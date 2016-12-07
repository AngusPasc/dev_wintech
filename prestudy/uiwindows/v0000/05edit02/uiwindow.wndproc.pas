unit uiwindow.wndproc;

interface

uses
  Windows,
  Messages,
  ui.form.windows,
  uiwin.wnd;

  function UIFormWndProcW(AUIWnd: PUIFormWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;

implementation

uses
  uiwindow.wndproc_paint;
  
function UIFormWndProcW(AUIWnd: PUIFormWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    WM_Paint: begin
      UIFormWndWMPaint(AUIWnd, wparam, lparam);
    end;
    else
    Result := DefWindowProcW(AWnd, AMsg, wParam, lParam);
  end;
end;

end.
