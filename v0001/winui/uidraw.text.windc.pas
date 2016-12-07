unit uidraw.text.windc;

interface
        
uses
  Windows,
  uiwin.dc;
         
  procedure DCTextOut(AWinDC: PWinDC; ARect: TRect);

implementation

procedure DCTextOut(AWinDC: PWinDC; ARect: TRect);
begin
  Windows.SetBkMode(AWinDC.DCHandle, TRANSPARENT);
  Windows.TextOutW(AWinDC.DCHandle, 10, 10,
        'GOOD',
        4
        );
end;

end.
