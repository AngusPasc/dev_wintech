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
  data.move.windows in '..\..\..\..\v0001\winproc\data.move.windows.pas',
  uiview in '..\..\..\..\v0001\rec\ui_view\uiview.pas',
  uiview_texture in '..\..\..\..\v0001\rec\ui_view\uiview_texture.pas',
  uiview_space in '..\..\..\..\v0001\rec\ui_view\uiview_space.pas',
  uiview_shape in '..\..\..\..\v0001\rec\ui_view\uiview_shape.pas',
  UtilsLog in '..\..\..\..\v0000\win_utils\UtilsLog.pas',
  uiedittext in 'uiedittext.pas',
  uiwindow.wndproc in 'uiwindow.wndproc.pas',
  uiwindow.wndproc.edit in 'uiwindow.wndproc.edit.pas',
  uiwindow.wndproc.button in 'uiwindow.wndproc.button.pas',
  uitest.uiwindow in 'uitest.uiwindow.pas',
  ui.form.windows in 'ui.form.windows.pas';

{$R *.res}

begin         
  FillChar(UIWindow_Test1, SizeOf(UIWindow_Test1), 0);
  CreateUIWindow1(@UIWindow_Test1);
  //FillChar(UIWindow_Test1, SizeOf(UIWindow_Test1), 0);
  //CreateUIWindow1(@UIWindow_Test1);
end.
