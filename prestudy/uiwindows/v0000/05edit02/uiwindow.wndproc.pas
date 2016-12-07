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
  uiwindow.wndproc_key,     
  uiwindow.wndproc_mouse,
  uiwindow.wndproc_paint;
  
function UIFormWndProcW(AUIWnd: PUIFormWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    // message paint
    WM_Paint: UIFormWndWMPaint(AUIWnd, wparam, lparam);
    // message keyboard
    WM_KEYDOWN: UIFormWndWMKeyDown(AUIWnd, wparam, lparam);
    WM_KEYUP: UIFormWndWMKeyUp(AUIWnd, wparam, lparam);
    WM_CHAR: UIFormWndWMChar(AUIWnd, wparam, lparam);
    // message mouse
    WM_LBUTTONDOWN: UIFormWndWMLButtonDown(AUIWnd, wparam, lparam);
    WM_LBUTTONUP: UIFormWndWMLButtonDown(AUIWnd, wparam, lparam);
    WM_MOUSEMOVE: UIFormWndWMMOUSEMOVE(AUIWnd, wparam, lparam);
    WM_MOUSEWHEEL: UIFormWndWMMOUSEWHEEL(AUIWnd, wparam, lparam);            
    else
    Result := DefWindowProcW(AWnd, AMsg, wParam, lParam);
  end;
end;

end.
