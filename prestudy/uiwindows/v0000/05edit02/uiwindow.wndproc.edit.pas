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
  if nil = AUIEdit.EditText.EditLine then
    AUIEdit.EditText.EditLine := CheckOutTextLine;
  EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
end;

procedure UIEdit_WndProc_WMChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
var
  tmpByte: Byte;
begin
  // #13#10 it must be this mode
  // #13 mean keydown
  // #10 mean screen change row
  if nil = AUIEdit.EditText.EditLine then
    AUIEdit.EditText.EditLine := CheckOutTextLine;
  if VK_BACK = wParam then // #8
  begin
    EditTextBackspace(@AUIEdit.EditText);
    exit;
  end;
  if VK_RETURN = wParam then // #13
  begin
    exit;
  end;        
  if VK_TAB = wParam then // #9
  begin
    exit;
  end;
  tmpByte := Byte(wparam);
  if (IsDBCSLeadByte(tmpByte)) then
  begin
    EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
  end else
  begin
    EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
  end;
end;

procedure UIEdit_WndProc_WMKeyDown(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin
  if VK_DELETE = wParam then // #46
  begin          
    EditTextDelete(@AUIEdit.EditText);
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
