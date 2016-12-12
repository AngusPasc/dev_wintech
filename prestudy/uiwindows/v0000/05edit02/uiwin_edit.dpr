program uiwin_edit;

uses
  Windows,
  sys.datatype in 'sys.datatype.pas',
  base.run in 'base.run.pas',
  base.thread in 'base.thread.pas',
  data.text in 'data.text.pas',
  win.thread in 'win.thread.pas',
  ui.texcolor in 'ui.texcolor.pas',
  ui.space in 'ui.space.pas',
  uiwin.wnd in 'uiwin.wnd.pas',
  uiwin.wndproc_key in 'uiwin.wndproc_key.pas',
  uiwin.wndproc_mouse in 'uiwin.wndproc_mouse.pas',
  uiwin.wndproc_paint in 'uiwin.wndproc_paint.pas',
  uiwin.wndproc_uispace in 'uiwin.wndproc_uispace.pas',
  uiwin.dc in 'uiwin.dc.pas',
  uiwin.gdiobj in 'uiwin.gdiobj.pas',
  data.move.windows in 'data.move.windows.pas',
  uiview in 'uiview.pas',
  uiview_texture in 'uiview_texture.pas',
  uiview_space in 'uiview_space.pas',
  uiview_shape in 'uiview_shape.pas',
  UtilsLog in '..\..\..\..\v0000\win_utils\UtilsLog.pas',
  uidraw.windc in 'uidraw.windc.pas',
  uidraw.text.windc in 'uidraw.text.windc.pas',
  uiedittext in 'uiedittext.pas',
  uiwindow.wndproc in 'uiwindow.wndproc.pas',
  uiwindow.wndproc.edit in 'uiwindow.wndproc.edit.pas',
  uiwindow.wndproc.button in 'uiwindow.wndproc.button.pas',
  uitest.uiwindow in 'uitest.uiwindow.pas',
  ui.form.windows in 'ui.form.windows.pas',
  uictrl.edit.text in 'uictrl.edit.text.pas',
  uiwindow.wndproc_mouse in 'uiwindow.wndproc_mouse.pas',
  uictrl.form in 'uictrl.form.pas',
  uictrl in 'uictrl.pas';

{$R *.res}

begin
  if 1 = GetSystemMetrics(SM_REMOTESESSION) then
  begin
    // 返回1表示在远程桌面会话中
  end;

  FillChar(UIWindow_Test1, SizeOf(UIWindow_Test1), 0);
  CreateUIWindow1(@UIWindow_Test1);
  //FillChar(UIWindow_Test1, SizeOf(UIWindow_Test1), 0);
  //CreateUIWindow1(@UIWindow_Test1);
end.
