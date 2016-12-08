unit uiwindow.wndproc_paint;

interface

uses
  Windows,
  ui.form.windows;
  
  procedure UIFormWndWMPaint(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam);
  function UIFormWndWMEraseBkGND(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam): LRESULT;

implementation

uses
  uiwin.dc,
  data.text,
  uictrl,
  uictrl.form,   
  uictrl.edit,
  uidraw.windc,
  uidraw.text.windc;

procedure UIPaintUIEdit(AWinDC: PWinDC; AUIEdit: PUIControlEdit);
var
  tmpTextDataNode: PTextDataNodeW;
  tmpPoint: TPoint;
  tmpLineNode: PTextLineNode;
begin
  DCFrameRect(AWinDC, AUIEdit.Base.BoundRect);

  if nil <> AUIEdit.EditText.TextLine then
  begin
    tmpTextDataNode := AUIEdit.EditText.TextLine.FirstDataNode;
    tmpPoint.X := AUIEdit.Base.BoundRect.Left;
    tmpPoint.Y := AUIEdit.Base.BoundRect.Top;
    while nil <> tmpTextDataNode do
    begin
      if 0 < tmpTextDataNode.Length then
      begin
        DCTextOut(AWinDC, tmpPoint, tmpTextDataNode);
        tmpPoint.X := tmpPoint.X + DCTextWidth(AWinDC, tmpTextDataNode);
      end;      
      tmpTextDataNode := tmpTextDataNode.NextSibling;
    end;
  end else
  begin             
    tmpPoint.X := AUIEdit.Base.BoundRect.Left;
    tmpPoint.Y := AUIEdit.Base.BoundRect.Top;
    
    tmpLineNode := AUIEdit.EditText.TextLines.FirstLineNode;
    while nil <> tmpLineNode do
    begin                    
      tmpTextDataNode := tmpLineNode.TextLine.FirstDataNode;  
      while nil <> tmpTextDataNode do
      begin
        if 0 < tmpTextDataNode.Length then
        begin
          DCTextOut(AWinDC, tmpPoint, tmpTextDataNode);
          tmpPoint.X := tmpPoint.X + DCTextWidth(AWinDC, tmpTextDataNode);
        end;
        tmpTextDataNode := tmpTextDataNode.NextSibling;
      end;                
      tmpPoint.X := AUIEdit.Base.BoundRect.Left;
      tmpPoint.Y := tmpPoint.Y + 20;
      
      tmpLineNode := tmpLineNode.NextSibling;
    end;
  end;
end;

procedure UIPaintUIControl(AWinDC: PWinDC; AControl: PUIBaseControl);
var
  tmpChild: PUIControlNode;
begin
  if Def_UIControl_Edit = AControl.ControlType then
  begin
    UIPaintUIEdit(AWinDC, PUIControlEdit(AControl));
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

function UIFormWndWMEraseBkGND(AUIFormWnd: PUIFormWindow; wparam: WParam; lparam: LParam): LRESULT;
begin
  Result := 1;
end;

end.
