unit uiwindow.wndproc;

interface

uses
  Windows,
  Messages,
  ui.form.windows,
  uiwin.wnd;

  function UIFormWndProcW(AUIFormWnd: PUIFormWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;

implementation

uses                      
  uiwindow.wndproc_key,     
  uiwindow.wndproc_mouse,
  uiwindow.wndproc_paint;
  
function UIFormWndProcW(AUIFormWnd: PUIFormWindow; AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := 0;
  case AMsg of
    // message beginend
    WM_CLOSE: begin
      PostQuitMessage(0);
    end;
    WM_QUIT: begin
      Result := DefWindowProcW(AWnd, AMsg, wParam, lParam);
    end;
    // message paint
    WM_Paint: UIFormWndWMPaint(AUIFormWnd, wparam, lparam);
    WM_ERASEBKGND: Result := UIFormWndWMEraseBkGND(AUIFormWnd, wparam, lparam);
    // message keyboard
    WM_KEYDOWN: UIFormWndWMKeyDown(AUIFormWnd, wparam, lparam);
    WM_KEYUP: UIFormWndWMKeyUp(AUIFormWnd, wparam, lparam);
    WM_CHAR: UIFormWndWMChar(AUIFormWnd, wparam, lparam);  
    WM_DEADCHAR: UIFormWndWMDEADChar(AUIFormWnd, wparam, lparam);         //= $0103;
    WM_SYSKEYDOWN: UIFormWndWMSYSKEYDOWN(AUIFormWnd, wparam, lparam);       //= $0104;
    WM_SYSKEYUP: UIFormWndWMSYSKEYUP(AUIFormWnd, wparam, lparam);         //= $0105;
    WM_SYSCHAR: UIFormWndWMSysChar(AUIFormWnd, wparam, lparam);          //= $0106;
    WM_SYSDEADCHAR: UIFormWndWMSysDeadChar(AUIFormWnd, wparam, lparam);      //= $0107;
    WM_UNICHAR: UIFormWndWMUniChar(AUIFormWnd, wparam, lparam);          //= $0109;

    WM_IME_STARTCOMPOSITION: Result := UIFormWndWMIME_STARTCOMPOSITION(AUIFormWnd, AMsg, wparam, lparam);          //= $010D;
    WM_IME_ENDCOMPOSITION  : Result := UIFormWndWMIME_ENDCOMPOSITION(AUIFormWnd, AMsg, wparam, lparam);        //= $010E;
    WM_IME_COMPOSITION     : Result := UIFormWndWMIME_COMPOSITION(AUIFormWnd, AMsg, wparam, lparam);        //= $010F;
    WM_IME_SETCONTEXT      : Result := UIFormWndWMIME_SETCONTEXT(AUIFormWnd, AMsg, wparam, lparam);        //= $0281;
    WM_IME_NOTIFY          : Result := UIFormWndWMIME_NOTIFY(AUIFormWnd, AMsg, wparam, lparam);        //= $0282;
    WM_IME_CONTROL         : Result := UIFormWndWMIME_CONTROL(AUIFormWnd, AMsg, wparam, lparam);        //= $0283;
    WM_IME_COMPOSITIONFULL : Result := UIFormWndWMIME_COMPOSITIONFULL(AUIFormWnd, AMsg, wparam, lparam);        //= $0284;
    WM_IME_SELECT          : Result := UIFormWndWMIME_SELECT(AUIFormWnd, AMsg, wparam, lparam);        //= $0285;
    WM_IME_CHAR            : Result := UIFormWndWMIME_CHAR(AUIFormWnd, AMsg, wparam, lparam);        //= $0286;
    WM_IME_REQUEST         : Result := UIFormWndWMIME_REQUEST(AUIFormWnd, AMsg, wparam, lparam);        //= $0288;
    WM_IME_KEYDOWN         : Result := UIFormWndWMIME_KEYDOWN(AUIFormWnd, AMsg, wparam, lparam);        //= $0290;
    WM_IME_KEYUP           : Result := UIFormWndWMIME_KEYUP(AUIFormWnd, AMsg, wparam, lparam);        //= $0291;
    // message mouse
    WM_SETCURSOR: Result := UIFormWndWMSetCursor(AUIFormWnd, wparam, lparam);
    WM_LBUTTONDOWN: UIFormWndWMLButtonDown(AUIFormWnd, wparam, lparam);
    WM_LBUTTONUP: UIFormWndWMLButtonDown(AUIFormWnd, wparam, lparam);

    WM_RBUTTONDOWN: UIFormWndWMRButtonDown(AUIFormWnd, wparam, lparam);
    WM_RBUTTONUP: UIFormWndWMRButtonUp(AUIFormWnd, wparam, lparam);

    WM_MOUSEMOVE: UIFormWndWMMOUSEMOVE(AUIFormWnd, wparam, lparam);
    WM_MOUSEWHEEL: UIFormWndWMMOUSEWHEEL(AUIFormWnd, wparam, lparam);            
    else
    Result := DefWindowProcW(AWnd, AMsg, wParam, lParam);
  end;
end;

end.
