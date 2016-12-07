unit uiwindow.wndproc_paint;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uidraw.windc,
  uidraw.text.windc;

procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
var
  tmpDC: HDC;
  tmpPaint: TPaintStruct;
begin
  if AUIFormWnd.ClientRect.Left = AUIFormWnd.ClientRect.Right then
  begin
    Windows.GetClientRect(AUIFormWnd.BaseWnd.WndHandle, AUIFormWnd.ClientRect);
  end;

  DCFillRect(@AUIFormWnd.MemDC, AUIFormWnd.ClientRect);
  DCTextOut(@AUIFormWnd.MemDC, AUIFormWnd.ClientRect);

  tmpDC := BeginPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
  Windows.BitBlt(tmpDC, 0, 0,
    AUIFormWnd.ClientRect.Right,
    AUIFormWnd.ClientRect.Bottom,
    AUIFormWnd.MemDC.DCHandle, 0, 0, SRCCopy);
  EndPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
end;

end.
