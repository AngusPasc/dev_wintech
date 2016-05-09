unit uiwindow_wndproc_mouse;

interface

uses
  Windows,
  Messages,
  uiwindow;

  function UIWndProcW_Mouse(AUIWindow: PUIWindow; AMsg: UINT; wParam: WPARAM; lParam: LPARAM; var AWndProcResult: LRESULT): Boolean;

implementation

uses
  uiview,
  uiview_space,
  uiwindow_wndproc_paint;
var
  Cursor_IBEAM: HCURSOR = 0;

function UpdateHitTestCursor(AUIWindow: PUIWindow; AHitTest: integer): Boolean;
begin                        
  Result := False;
  if HTCLIENT = AHitTest then
  begin
    if 0 = Cursor_IBEAM then
      Cursor_IBEAM := LoadCursor(0, IDC_IBEAM);
    if 0 <> Cursor_IBEAM then
    begin
      //if AUIWindow.CursorHandle <> Cursor_IBEAM then
      if Windows.GetCursor <> Cursor_IBEAM then      
      begin
        //AUIWindow.CursorHandle := Cursor_IBEAM;
        Windows.SetCursor(Cursor_IBEAM);
      end;
      Result := True;
    end;
  end;
end;

function WndProcW_WMLButtonDown(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  AUIWindow.WMLButtonDown_CursorPoint := TSmallPoint(lParam);
  if 20 > TSmallPoint(lParam).y then
  begin
    SendMessageW(AUIWindow.BaseWnd.UIWndHandle, WM_SYSCOMMAND, SC_MOVE or HTCaption, 0);   
    //SendMessageW(AUIWindow.BaseWnd.UIWndHandle, WM_NCLButtonDown, HTCaption, GetMessagePos);
  end;
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_LBUTTONDOWN, wParam, lParam);
end;
            
function WndProcW_WMLButtonUp(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  UIWindowPaint(AUIWindow);
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_LBUTTONUP, wParam, lParam);
end;

function WndProcW_WMLButtonDblClk(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_LBUTTONDBLCLK, wParam, lParam);
end;
              
function WndProcW_WMRButtonUp(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_RBUTTONUP, wParam, lParam);
end;

function WndProcW_WMRButtonDown(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_RBUTTONDOWN, wParam, lParam);
end;
            
function WndProcW_WMRButtonDblClk(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_RBUTTONDBLCLK, wParam, lParam);
end;
                    
function WndProcW_WMMButtonUp(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MBUTTONUP, wParam, lParam);
end;

function WndProcW_WMMButtonDown(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MBUTTONDOWN, wParam, lParam);
end;
            
function WndProcW_WMMButtonDblClk(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MBUTTONDBLCLK, wParam, lParam);
end;

function WndProcW_WMMouseMove(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
//var
//  tmpHitTest: integer;
begin
  AUIWindow.WMMouseMove_CursorPoint := TSmallPoint(lParam);
  if nil <> AUIWindow.TestFocusUIView then
  begin                                 
  end else
  begin
//    tmpHitTest := POINT_HITTEST(@AUIWindow.TestUIEdit.Space.Layout, AUIWindow.WMMouseMove_CursorPoint);
//    UpdateHitTestCursor(AUIWindow, tmpHitTest);
  end;
  UIWindowPaint(AUIWindow);
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MOUSEMOVE, wParam, lParam);
end;

function WndProcW_WMMouseWheel(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MOUSEWHEEL, wParam, lParam);
end;

function WndProcW_WMSetCursor(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;  
var
  tmpHitTest: integer;
begin
  Result := 0;
  if Windows.GetCursorPos(AUIWindow.WMSetCursor_CursorPoint) then
  begin
    if Windows.ScreenToClient(AUIWindow.BaseWnd.UIWndHandle, AUIWindow.WMSetCursor_CursorPoint) then
    begin
      tmpHitTest := POINT_HITTEST(AUIWindow.TestUIEdit.Base.Layout, AUIWindow.WMMouseMove_CursorPoint);
      if UpdateHitTestCursor(AUIWindow, tmpHitTest) then
      begin
        Exit;
      end;
    end;
  end; 
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_SETCURSOR, wParam, lParam);
end;

function WndProcW_WMNCHitTest(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  //Result := HTCLIENT;  
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCHITTEST, wParam, lParam);
end;

function WndProcW_WMMouseHover(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MOUSEHOVER, wParam, lParam);
end;

function WndProcW_WMMouseLeave(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_MOUSELEAVE, wParam, lParam);
end;
          
function WndProcW_WMNCMOUSEMOVE(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin            
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCMOUSEMOVE, wParam, lParam);
end;

function WndProcW_WMNCLBUTTONUP(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCLBUTTONUP, wParam, lParam);
end;
                      
function WndProcW_WMNCLBUTTONDOWN(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCLBUTTONDOWN, wParam, lParam);
end;
                                   
function WndProcW_WMNCLBUTTONDBLCLK(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCLBUTTONDBLCLK, wParam, lParam);
end;
                      
function WndProcW_WMNCRBUTTONUP(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCRBUTTONUP, wParam, lParam);
end;
                      
function WndProcW_WMNCRBUTTONDOWN(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCRBUTTONDOWN, wParam, lParam);
end;
                                   
function WndProcW_WMNCRBUTTONDBLCLK(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCRBUTTONDBLCLK, wParam, lParam);
end;

function WndProcW_WMNCMBUTTONUP(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCMBUTTONUP, wParam, lParam);
end;
                      
function WndProcW_WMNCMBUTTONDOWN(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCMBUTTONDOWN, wParam, lParam);
end;
                                   
function WndProcW_WMNCMBUTTONDBLCLK(AUIWindow: PUIWindow; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
  Result := DefWindowProcW(AUIWindow.BaseWnd.UIWndHandle, WM_NCMBUTTONDBLCLK, wParam, lParam);
end;

function UIWndProcW_Mouse(AUIWindow: PUIWindow; AMsg: UINT; wParam: WPARAM; lParam: LPARAM; var AWndProcResult: LRESULT): Boolean; 
begin
  Result := true;
  case AMsg of
    WM_LButtonUp: AWndProcResult := WndProcW_WMLButtonUp(AUIWindow, wParam, lParam);
    WM_LButtonDown: AWndProcResult := WndProcW_WMLButtonDown(AUIWindow, wParam, lParam);
    WM_LBUTTONDBLCLK: AWndProcResult := WndProcW_WMLButtonDblClk(AUIWindow, wParam, lParam);

    WM_RButtonUp: AWndProcResult := WndProcW_WMRButtonUp(AUIWindow, wParam, lParam);
    WM_RButtonDown: AWndProcResult := WndProcW_WMRButtonDown(AUIWindow, wParam, lParam);
    WM_RBUTTONDBLCLK: AWndProcResult := WndProcW_WMRButtonDblClk(AUIWindow, wParam, lParam);

    WM_MButtonUp: AWndProcResult := WndProcW_WMMButtonUp(AUIWindow, wParam, lParam);
    WM_MButtonDown: AWndProcResult := WndProcW_WMMButtonDown(AUIWindow, wParam, lParam);
    WM_MBUTTONDBLCLK: AWndProcResult := WndProcW_WMMButtonDblClk(AUIWindow, wParam, lParam);

    WM_MouseMove: AWndProcResult := WndProcW_WMMouseMove(AUIWindow, wParam, lParam);
    WM_MOUSEWHEEL: AWndProcResult := WndProcW_WMMouseWheel(AUIWindow, wParam, lParam);
    WM_SETCURSOR: begin
      //��������������ĳ���������ƶ����������û�б�����ʱ������Ϣ���ô���
      AWndProcResult := WndProcW_WMSetCursor(AUIWindow, wParam, lParam);
    end;
    WM_NCHITTEST: AWndProcResult := WndProcW_WMNCHitTest(AUIWindow, wParam, lParam);
    WM_MOUSEHOVER: AWndProcResult := WndProcW_WMMouseHover(AUIWindow, wParam, lParam);
    WM_MOUSELEAVE: AWndProcResult := WndProcW_WMMouseLeave(AUIWindow, wParam, lParam);

    WM_NCMOUSEMOVE: AWndProcResult := WndProcW_WMNCMOUSEMOVE(AUIWindow, wParam, lParam);
    WM_NCLBUTTONUP: AWndProcResult := WndProcW_WMNCLBUTTONUP(AUIWindow, wParam, lParam);
    WM_NCLBUTTONDOWN: AWndProcResult := WndProcW_WMNCLBUTTONDOWN(AUIWindow, wParam, lParam);
    WM_NCLBUTTONDBLCLK: AWndProcResult := WndProcW_WMNCLBUTTONDBLCLK(AUIWindow, wParam, lParam);    

    WM_NCRBUTTONUP: AWndProcResult := WndProcW_WMNCRBUTTONUP(AUIWindow, wParam, lParam);
    WM_NCRBUTTONDOWN: AWndProcResult := WndProcW_WMNCRBUTTONDOWN(AUIWindow, wParam, lParam);
    WM_NCRBUTTONDBLCLK: AWndProcResult := WndProcW_WMNCRBUTTONDBLCLK(AUIWindow, wParam, lParam);

    WM_NCMBUTTONUP: AWndProcResult := WndProcW_WMNCMBUTTONUP(AUIWindow, wParam, lParam);
    WM_NCMBUTTONDOWN: AWndProcResult := WndProcW_WMNCMBUTTONDOWN(AUIWindow, wParam, lParam);
    WM_NCMBUTTONDBLCLK: AWndProcResult := WndProcW_WMNCMBUTTONDBLCLK(AUIWindow, wParam, lParam);
    else
      Result := false;
  end;     
end;
       
end.
