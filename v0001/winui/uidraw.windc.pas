unit uidraw.windc;

interface

uses
  Windows,
  uiwin.dc;
  
  procedure DCFillRect(AWinDC: PWinDC; ARect: TRect);
  
implementation

var
  testBrush: HBRUSH = 0;

procedure DCFillRect(AWinDC: PWinDC; ARect: TRect);
var
  logbrush: TLogbrush;
begin
  if 0 = testBrush then
  begin
    logbrush.lbStyle := BS_SOLID;
    logbrush.lbColor := $F0F0F0;
    logbrush.lbHatch := 0;
    testBrush := Windows.CreateBrushIndirect(logbrush);
  end;
  Windows.FillRect(AWinDC.DCHandle, ARect, testBrush);
end;

end.
