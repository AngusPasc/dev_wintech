unit uidraw.windc;

interface

uses
  Windows,
  uiwin.dc;
  
  procedure DCFillRect(AWinDC: PWinDC; ARect: TRect);
  procedure DCFrameRect(AWinDC: PWinDC; ARect: TRect);

implementation

var
  testFillBrush: HBRUSH = 0;
  testFrameBrush: HBRUSH = 0;
  
procedure DCFillRect(AWinDC: PWinDC; ARect: TRect);
var
  logbrush: TLogbrush;
begin
  if 0 = testFillBrush then
  begin
    logbrush.lbStyle := BS_SOLID;
    logbrush.lbColor := $F0F0F0;
    logbrush.lbHatch := 0;
    testFillBrush := Windows.CreateBrushIndirect(logbrush);
  end;
  Windows.FillRect(AWinDC.DCHandle, ARect, testFillBrush);
end;

procedure DCFrameRect(AWinDC: PWinDC; ARect: TRect);  
var
  logbrush: TLogbrush;
begin
  if 0 = testFrameBrush then
  begin
    logbrush.lbStyle := BS_SOLID;
    logbrush.lbColor := $F000FF;
    logbrush.lbHatch := 0;
    testFrameBrush := Windows.CreateBrushIndirect(logbrush);
  end;
  Windows.FrameRect(AWinDC.DCHandle, ARect, testFrameBrush);
end;

end.
