unit uiwindow.wndproc_key;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMKeyDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);   
  procedure UIFormWndWMKeyUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  procedure UIFormWndWMChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uidraw.windc,
  uidraw.text.windc;

procedure UIFormWndWMKeyDown(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

procedure UIFormWndWMKeyUp(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin
end;

procedure UIFormWndWMChar(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
begin     
end;

end.
