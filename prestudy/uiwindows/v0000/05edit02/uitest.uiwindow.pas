unit uitest.uiwindow;

interface
              
uses
  Windows,
  Messages,
  uiwin.dc,
  uiwin.wnd,
  uictrl.edit,  
  uictrl.button,
  ui.form.windows;
                 
type
  PUIWinTest        = ^TUIWinTest;    
  TUIWinTest        = record
    FormWindow      : TUIFormWindow;
    //TestUIEdit      : TUIEdit;
    TestEdit        : PUIControlEdit;    
    TestButton        : PUIControlButton;
    
    CursorHandle: HCURSOR;
    //TestFocusUIView : PUIView;
    FocusMode: integer;  
  end;
  
var
  UIWindow_Test1: TUIWinTest; 
    
  procedure CreateUIWindow1(AUIWindow: PUIWinTest);

implementation

uses
  data.text,
  uictrl.form,
  uiwindow.wndproc;
                 
function UIWndProcW(AWnd: HWND; AMsg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  Result := UIFormWndProcW(@UIWindow_Test1.FormWindow, AWnd, AMsg, wParam, lParam);
end;

procedure CreateUIWindow1(AUIWindow: PUIWinTest);
var
  tmpRegWndClass: TWndClassW;
  tmpCheckWndClass: TWndClassW;
  tmpIsRegistered: Boolean;
begin                      
  AUIWindow.FormWindow.Form := CheckOutUIForm;
  
  AUIWindow.TestEdit := CheckOutUIEdit;
  AUIWindow.TestEdit.Base.BoundRect.Left := 30;
  AUIWindow.TestEdit.Base.BoundRect.Top := 55;

  AUIWindow.TestEdit.Base.BoundRect.Right := AUIWindow.TestEdit.Base.BoundRect.Left + 100;
  AUIWindow.TestEdit.Base.BoundRect.Bottom := AUIWindow.TestEdit.Base.BoundRect.Top + 23;

  UIControlAdd(@AUIWindow.TestEdit.Base, @AUIWindow.FormWindow.Form.Base);

  AUIWindow.TestButton := CheckOutUIButton;    
  AUIWindow.TestButton.Base.BoundRect.Left := 30;
  AUIWindow.TestButton.Base.BoundRect.Top := 95;

  AUIWindow.TestButton.Base.BoundRect.Right := AUIWindow.TestButton.Base.BoundRect.Left + 100;
  AUIWindow.TestButton.Base.BoundRect.Bottom := AUIWindow.TestButton.Base.BoundRect.Top + 23;

  UIControlAdd(@AUIWindow.TestButton.Base, @AUIWindow.FormWindow.Form.Base);

  
//  FillChar(EditTextTest, SizeOf(EditTextTest), 0);
//  EditTextTest.EditLine := CheckOutTextLine;
//
//  EditTextAdd(@EditTextTest, 'A');
//  EditTextAdd(@EditTextTest, 'B');
//  EditTextAdd(@EditTextTest, 'C');
//  EditTextAdd(@EditTextTest, 'D');
//
//  EditTextAdd(@EditTextTest, 'E');
//  EditTextAdd(@EditTextTest, 'F');
//  EditTextAdd(@EditTextTest, 'G');
//  EditTextAdd(@EditTextTest, 'H');
//  
//  EditTextAdd(@EditTextTest, 'I');
//  EditTextAdd(@EditTextTest, 'J');   
//  EditTextAdd(@EditTextTest, 'K');
//
//  if 0 = EditTextTest.EditPos.LinePos then
//  begin
//  end;

  FillChar(tmpRegWndClass, SizeOf(tmpRegWndClass), 0);
  tmpRegWndClass.lpfnWndProc := @UIWndProcW;
  tmpRegWndClass.lpszClassName := 'UIWnd1';                   
  tmpRegWndClass.hCursor := LoadCursorA(0, IDC_ARROW);
  tmpRegWndClass.hbrBackground := GetStockObject(GRAY_BRUSH);
  tmpRegWndClass.hInstance := HInstance;
  
  tmpIsRegistered := GetClassInfoW(HInstance, tmpRegWndClass.lpszClassName, tmpCheckWndClass);
  if not tmpIsRegistered or (tmpCheckWndClass.lpfnWndProc <> tmpRegWndClass.lpfnWndProc) then
  begin
    if tmpIsRegistered then
      Windows.UnregisterClassW(tmpRegWndClass.lpszClassName, HInstance);
    Windows.RegisterClassW(tmpRegWndClass);
  end;

  AUIWindow.FormWindow.BaseWnd.ClientRect.Right := 600;
  AUIWindow.FormWindow.BaseWnd.ClientRect.Bottom := 500;

  UpdateWinDC(@AUIWindow.FormWindow.MemDC,
      AUIWindow.FormWindow.BaseWnd.ClientRect.Right,
      AUIWindow.FormWindow.BaseWnd.ClientRect.Bottom);
                                   
  //InitUIEdit(@AUIWindow.TestUIEdit);
  //UpdateUISpaceLayout(@AUIWindow.TestUIEdit.Base.View.Space, 50, 50);   
  
  AUIWindow.FormWindow.BaseWnd.WndHandle := CreateWindowExW(
    //WS_EX_TOOLWINDOW
      //or WS_EX_TOPMOST
    WS_EX_OVERLAPPEDWINDOW
    ,
    tmpRegWndClass.lpszClassName,
    '',
    WS_POPUP {+ 0}
      or WS_OVERLAPPEDWINDOW
    ,
    AUIWindow.FormWindow.BaseWnd.WindowRect.Left,
    AUIWindow.FormWindow.BaseWnd.WindowRect.Top,
    AUIWindow.FormWindow.BaseWnd.ClientRect.Right,
    AUIWindow.FormWindow.BaseWnd.ClientRect.Bottom,
    0,
    0, HInstance, nil);
  if IsWindow(AUIWindow.FormWindow.BaseWnd.WndHandle) then
  begin
    ShowWindow(AUIWindow.FormWindow.BaseWnd.WndHandle, SW_SHOW);
    UpdateWindow(AUIWindow.FormWindow.BaseWnd.WndHandle);
    while GetMessage(AUIWindow.FormWindow.BaseWnd.WndMsg, 0, 0, 0) do
    begin
      TranslateMessage(AUIWindow.FormWindow.BaseWnd.WndMsg);
      DispatchMessage(AUIWindow.FormWindow.BaseWnd.WndMsg);
    end;
  end;
end;

end.
