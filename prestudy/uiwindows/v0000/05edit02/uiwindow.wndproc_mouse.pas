unit uiwindow.wndproc_mouse;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMLButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);  
  procedure UIFormWndWMLButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMMouseMove(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMMouseWheel(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uidraw.windc,
  uidraw.text.windc;

procedure UIFormWndWMLButtonDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

procedure UIFormWndWMLButtonUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin

end;

procedure UIFormWndWMMouseMove(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

procedure UIFormWndWMMouseWheel(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

end.
