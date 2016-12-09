unit uiwindow.wndproc.edit;

interface

uses
  Windows,
  uictrl.edit;
               
  procedure UIEdit_WndProc_WMChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
  procedure UIEdit_WndProc_WMIMEChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);

  procedure UIEdit_WndProc_WMKeyDown(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
  procedure UIEdit_WndProc_WMKeyUp(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);       
  procedure UIEdit_WndProc_WMPaint(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
  
implementation

uses
  uiedittext,
  data.text;

(*//
  TWMKey = packed record
    Msg: Cardinal;
    CharCode: Word;
    Unused: Word;
    KeyData: Longint;
    Result: Longint;
  end;
//*)
procedure UIEdit_WndProc_WMIMEChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin
  // Äã 20320 4F60
  EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
end;

procedure UIEdit_WndProc_WMChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin
  // #13#10 it must be this mode
  // #13 mean keydown
  // #10 mean screen change row
  if VK_BACK = wParam then // #8
  begin
    EditTextBackspace(@AUIEdit.EditText);
    exit;
  end;
  if VK_RETURN = wParam then // #13
  begin
    if (1 = AUIEdit.EditText.InputLineLimit) then
    begin
      // single row limit
      exit;
    end;
    AUIEdit.EditText.EditPos.EditLine := CheckOutEditTextLine(@AUIEdit.EditText);
    AUIEdit.EditText.EditPos.EditDataNode := nil;
    AUIEdit.EditText.EditPos.LinePos := 0;
    AUIEdit.EditText.EditPos.NodePos := 0;
    exit;
  end;        
  if VK_TAB = wParam then // #9
  begin
    exit;
  end;                 
  EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
end;

procedure UIEdit_WndProc_WMKeyDown(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin
  if VK_DELETE = wParam then // #46
  begin          
    EditTextDelete(@AUIEdit.EditText);
    exit;
  end;
  if VK_INSERT = wParam then
  begin
    exit;
  end;
  if VK_LEFT = wParam then
  begin
    exit;
  end;
  if VK_Right = wParam then
  begin
    exit;
  end;
  if VK_Up = wParam then
  begin
    exit;
  end;
  if VK_Down = wParam then
  begin
    exit;
  end;   
  if VK_Home = wParam then
  begin
    exit;
  end;
  if VK_End = wParam then
  begin
    exit;
  end;        
  // page up    
  if VK_PRIOR = wParam then // 33
  begin
    exit;
  end;
  // page down
  if VK_NEXT = wParam then // 34
  begin
    exit;
  end;
  if VK_CAPITAL = wParam then
  begin
    // A - a switch
    exit;
  end;        
  if VK_SHIFT = wParam then
  begin
    exit;
  end;
  if VK_CONTROL = wParam then // 17
  begin
    exit;
  end;
  if VK_LWIN = wParam then
  begin
    exit;
  end;
  if VK_RWIN = wParam then
  begin
    exit;
  end;
  if VK_APPS = wParam then
  begin
    exit;
  end;
  if VK_F12 = wParam then
  begin
    exit;
  end;
end;

procedure UIEdit_WndProc_WMKeyUp(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin

end;

procedure UIEdit_WndProc_WMPaint(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin

end;

end.
