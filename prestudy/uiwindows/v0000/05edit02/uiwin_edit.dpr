program uiwin_edit;

uses
  Windows,
  sys.datatype in '..\..\..\..\v0001\sys.datatype.pas',
  base.run in '..\..\..\..\v0001\rec\app_base\base.run.pas',
  Base.Thread in '..\..\..\..\v0001\rec\app_base\Base.Thread.pas',
  win.thread in '..\..\..\..\v0001\rec\win_sys\win.thread.pas',
  ui.texcolor in '..\..\..\..\v0001\rec\ui_base\ui.texcolor.pas',
  ui.space in '..\..\..\..\v0001\rec\ui_base\ui.space.pas',
  uiwin.wnd in '..\..\..\..\v0001\rec\win_ui\uiwin.wnd.pas',
  uiwin.wndproc_key in '..\..\..\..\v0001\rec\win_ui\uiwin.wndproc_key.pas',
  uiwin.wndproc_mouse in '..\..\..\..\v0001\rec\win_ui\uiwin.wndproc_mouse.pas',
  uiwin.wndproc_paint in '..\..\..\..\v0001\rec\win_ui\uiwin.wndproc_paint.pas',
  uiwin.wndproc_uispace in '..\..\..\..\v0001\rec\win_ui\uiwin.wndproc_uispace.pas',
  uiwin.dc in '..\..\..\..\v0001\rec\win_ui\uiwin.dc.pas',
  uiwin.gdiobj in '..\..\..\..\v0001\rec\win_ui\uiwin.gdiobj.pas',
  win.datamove in '..\..\..\..\v0001\winproc\win.datamove.pas',
  uiview in '..\..\..\..\v0001\rec\ui_view\uiview.pas',
  uiview_texture in '..\..\..\..\v0001\rec\ui_view\uiview_texture.pas',
  uiview_space in '..\..\..\..\v0001\rec\ui_view\uiview_space.pas',
  uiview_shape in '..\..\..\..\v0001\rec\ui_view\uiview_shape.pas',
  UtilsLog in '..\..\..\..\v0000\win_utils\UtilsLog.pas',
  uiedittext in 'uiedittext.pas';

{$R *.res}

var
  EditTextTest: TUIEditText;
begin
  FillChar(EditTextTest, SizeOf(EditTextTest), 0);
  EditTextTest.EditLine := CheckOutTextLine;

  EditTextAdd(@EditTextTest, 'A');
  EditTextAdd(@EditTextTest, 'B');
  EditTextAdd(@EditTextTest, 'C');
  EditTextAdd(@EditTextTest, 'D');

  EditTextAdd(@EditTextTest, 'E');
  EditTextAdd(@EditTextTest, 'F');
  EditTextAdd(@EditTextTest, 'G');
  EditTextAdd(@EditTextTest, 'H');
  
  EditTextAdd(@EditTextTest, 'I');
  EditTextAdd(@EditTextTest, 'J');   
  EditTextAdd(@EditTextTest, 'K');

  if 0 = EditTextTest.EditPos.LinePos then
  begin
  end;
  //FillChar(UIWindow_Test1, SizeOf(UIWindow_Test1), 0);
  //CreateUIWindow1(@UIWindow_Test1);
end.
