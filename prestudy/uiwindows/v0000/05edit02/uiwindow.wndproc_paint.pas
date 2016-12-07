unit uiwindow.wndproc_paint;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);

implementation

uses
  uiwin.dc,
  uictrl,
  uictrl.form,
  uidraw.windc,
  uidraw.text.windc;

procedure UIPaintUIControl(AWinDC: PWinDC; AControl: PUIBaseControl);
var
  tmpChild: PUIControlNode;
begin
  if Def_UIControl_Edit = AControl.ControlType then
  begin
    DCFrameRect(AWinDC, AControl.BoundRect);
    exit;
  end;
  if Def_UIControl_Button = AControl.ControlType then
  begin
    DCFrameRect(AWinDC, AControl.BoundRect);
    exit;
  end;
  if (Def_UIControl_Form = AControl.ControlType) or
     (Def_UIControl_Panel = AControl.ControlType) then
  begin
    tmpChild := PUIContainerControl(AControl).Container.FirstChild;
    while nil <> tmpChild  do
    begin
      UIPaintUIControl(AWinDC, tmpChild.Control);
      tmpChild := tmpChild.NextSibling;
    end;
    exit;
  end;
end;

procedure UIFormPaint(AWinDC: PWinDC; AUIFormWnd: PUIFormWindow);
begin
  DCFillRect(AWinDC, AUIFormWnd.ClientRect);
  if nil <> AUIFormWnd.Form then
    UIPaintUIControl(AWinDC, @AUIFormWnd.Form.Base);
    
  //DCTextOut(AWinDC, AUIFormWnd.ClientRect);
end;

procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
var
  tmpDC: HDC;
  tmpPaint: TPaintStruct;
begin
  if AUIFormWnd.ClientRect.Left = AUIFormWnd.ClientRect.Right then
  begin
    Windows.GetClientRect(AUIFormWnd.BaseWnd.WndHandle, AUIFormWnd.ClientRect);
  end;
  UIFormPaint(@AUIFormWnd.MemDC, AUIFormWnd);
  
  tmpDC := BeginPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
  Windows.BitBlt(tmpDC, 0, 0,
    AUIFormWnd.ClientRect.Right,
    AUIFormWnd.ClientRect.Bottom,
    AUIFormWnd.MemDC.DCHandle, 0, 0, SRCCopy);
  EndPaint(AUIFormWnd.BaseWnd.WndHandle, tmpPaint);
end;

end.
