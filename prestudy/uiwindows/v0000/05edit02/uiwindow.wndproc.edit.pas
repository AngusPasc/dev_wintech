unit uiwindow.wndproc.edit;

interface

uses
  Windows,
  uictrl.edit;
               
  procedure UIEdit_WndProc_WMChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);   
  procedure UIEdit_WndProc_WMPaint(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
  
implementation

uses
  uiedittext,
  data.text;
                  
procedure UIEdit_WndProc_WMChar(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin
  if nil = AUIEdit.EditText.EditLine then
    AUIEdit.EditText.EditLine := CheckOutTextLine;
  EditTextAdd(@AUIEdit.EditText, WideChar(wparam));
end;

procedure UIEdit_WndProc_WMPaint(AUIEdit: PUIControlEdit; wparam: WPARAM; lparam: LPARAM);
begin

end;

end.
