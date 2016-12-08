unit uiwindow.wndproc_key;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMKeyDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);   
  procedure UIFormWndWMKeyUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
                   
  procedure UIFormWndWMDEADChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);         //= $0103;
  procedure UIFormWndWMSYSKEYDOWN(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);       //= $0104;
  procedure UIFormWndWMSYSKEYUP(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);         //= $0105;
  procedure UIFormWndWMSysChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);          //= $0106;
  procedure UIFormWndWMSysDeadChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);      //= $0107;
  procedure UIFormWndWMUniChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);          //= $0109;
                        
  function UIFormWndWMIME_STARTCOMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;          //= $010D;
  function UIFormWndWMIME_ENDCOMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $010E;
  function UIFormWndWMIME_COMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $010F;
  function UIFormWndWMIME_SETCONTEXT(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0281;
  function UIFormWndWMIME_NOTIFY(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0282;
  function UIFormWndWMIME_CONTROL(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0283;
  function UIFormWndWMIME_COMPOSITIONFULL(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0284;
  function UIFormWndWMIME_SELECT(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0285;
  function UIFormWndWMIME_CHAR(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0286;
  function UIFormWndWMIME_REQUEST(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0288;
  function UIFormWndWMIME_KEYDOWN(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0290;
  function UIFormWndWMIME_KEYUP(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0291;
    
implementation

uses
  uictrl,
  uictrl.edit,
  uidraw.windc,
  uidraw.text.windc,
  uiwindow.wndproc.edit;

procedure UIFormWndWMKeyDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin          
  if nil <> AUIFormWnd.Form.WMKeyControl then
  begin
    if Def_UIControl_Edit = AUIFormWnd.Form.WMKeyControl.ControlType then
    begin
      UIEdit_WndProc_WMKeyDown(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
    end;
  end; 
end;

procedure UIFormWndWMKeyUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin                   
  if nil <> AUIFormWnd.Form.WMKeyControl then
  begin
    if Def_UIControl_Edit = AUIFormWnd.Form.WMKeyControl.ControlType then
    begin
      UIEdit_WndProc_WMKeyUp(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
    end;
  end; 
end;

procedure UIFormWndWMChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
  if nil <> AUIFormWnd.Form.WMKeyControl then
  begin
    if Def_UIControl_Edit = AUIFormWnd.Form.WMKeyControl.ControlType then
    begin             
      if IsWindowUnicode(AUIFormWnd.BaseWnd.WndHandle) then
      begin
        UIEdit_WndProc_WMChar(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
      end else
      begin
        UIEdit_WndProc_WMChar(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
      end;
      Windows.InvalidateRect(AUIFormWnd.BaseWnd.WndHandle, nil, false);
    end;
  end; 
end;

procedure UIFormWndWMDEADChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);         //= $0103;
begin
end;

procedure UIFormWndWMSYSKEYDOWN(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);       //= $0104;
begin
end;

procedure UIFormWndWMSYSKEYUP(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);         //= $0105;
begin
end;

procedure UIFormWndWMSysChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);          //= $0106;
begin
end;

procedure UIFormWndWMSysDeadChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);      //= $0107;
begin
end;

procedure UIFormWndWMUniChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);          //= $0109;
begin
end;

function UIFormWndWMIME_STARTCOMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;          //= $010D;
begin                           
  if IsWindowUnicode(AUIFormWnd.BaseWnd.WndHandle) then
  begin
    Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
  end else
  begin
    Result := DefWindowProcA(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
  end;
end;

function UIFormWndWMIME_ENDCOMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $010E;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_COMPOSITION(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $010F;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_SETCONTEXT(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0281;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_NOTIFY(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0282;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_CONTROL(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0283;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_COMPOSITIONFULL(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0284;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_SELECT(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0285;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

(*//
http://blog.csdn.net/shuilan0066/article/details/7679825
//*)
function UIFormWndWMIME_CHAR(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0286;
begin           
  //Result := 0;
  (*//         
  if nil <> AUIFormWnd.Form.WMKeyControl then
  begin
    if Def_UIControl_Edit = AUIFormWnd.Form.WMKeyControl.ControlType then
    begin
      if IsWindowUnicode(AUIFormWnd.BaseWnd.WndHandle) then
      begin
        UIEdit_WndProc_WMIMEChar(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
        Result := 0;
      end else
      begin
        UIEdit_WndProc_WMIMEChar(PUIControlEdit(AUIFormWnd.Form.WMKeyControl), wparam, lparam);
        Result := 0;
      end;
      Windows.InvalidateRect(AUIFormWnd.BaseWnd.WndHandle, nil, false);
    end;
  end;
  //*)
  //Result := DefWindowProcA(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);   
  if IsWindowUnicode(AUIFormWnd.BaseWnd.WndHandle) then
  begin
    Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
  end else
  begin
    Result := DefWindowProcA(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
  end;
end;

function UIFormWndWMIME_REQUEST(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0288;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_KEYDOWN(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0290;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

function UIFormWndWMIME_KEYUP(AUIFormWnd: PUIFormWindow; AMsg: UINT; wparam: WParam; lparam: LParam): LRESULT;        //= $0291;
begin
  Result := DefWindowProcW(AUIFormWnd.BaseWnd.WndHandle, AMsg, wParam, lparam);
end;

end.
