unit uidraw.text.windc;

interface
        
uses
  Windows,
  data.text,
  uiwin.dc;
         
  procedure DCTextOut(AWinDC: PWinDC; APoint: TPoint; ATextData: PTextDataNodeW);
  function DCTextWidth(AWinDC: PWinDC; ATextData: PTextDataNodeW): integer;

implementation

procedure DCTextOut(AWinDC: PWinDC; APoint: TPoint; ATextData: PTextDataNodeW);
begin
  Windows.SetBkMode(AWinDC.DCHandle, TRANSPARENT);
  if nil <> ATextData then
  begin
    Windows.TextOutW(AWinDC.DCHandle, APoint.X, APoint.Y,
        @ATextData.Data[0],
        ATextData.Length
        );
  end;
end;

function DCTextWidth(AWinDC: PWinDC; ATextData: PTextDataNodeW): integer;
var
  tmpSize: Windows.TSize;
begin
  //RequiredState([csHandleValid, csFontValid]);
  tmpSize.cX := 0;
  tmpSize.cY := 0;
  Windows.GetTextExtentPoint32W(AWinDC.DCHandle, @ATextData.Data[0], ATextData.Length, tmpSize);
  Result := tmpSize.cx;
end;

end.
