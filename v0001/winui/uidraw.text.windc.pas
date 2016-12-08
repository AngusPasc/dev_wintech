unit uidraw.text.windc;

interface
        
uses
  Windows,
  data.text,
  uiwin.dc;
         
  procedure DCTextOut(AWinDC: PWinDC; ARect: TRect; ATextData: PTextDataNodeW);

implementation

procedure DCTextOut(AWinDC: PWinDC; ARect: TRect; ATextData: PTextDataNodeW);
begin
  Windows.SetBkMode(AWinDC.DCHandle, TRANSPARENT);
  if nil <> ATextData then
  begin
    Windows.TextOutW(AWinDC.DCHandle, ARect.Left, ARect.Top,
        @ATextData.Data[0],
        ATextData.Length
        );
  end;
end;

end.
