unit uiwindow.wndproc_paint;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uidraw.windc;
  
procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
var
  tmpDC: HDC;
  tmpPaint: TPaintStruct;
begin
  if AUIFormWnd.ClientRect.Left = AUIFormWnd.ClientRect.Right then
  begin
    Windows.GetClientRect(AUIFormWnd.BaseWnd.WndHandle, AUIFormWnd.ClientRect);

    DCFillRect(@AUIFormWnd.MemDC, AUIFormWnd.ClientRect);
  end;
  
  tmpDC := BeginPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
  Windows.BitBlt(tmpDC, 0, 0,
    AUIFormWnd.ClientRect.Right,
    AUIFormWnd.ClientRect.Bottom,
    AUIFormWnd.MemDC.DCHandle, 0, 0, SRCCopy);
  EndPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
end;

end.
