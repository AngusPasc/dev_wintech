unit uictrl.button;

interface
                 
uses
  uictrl;
  
type           
  PUIControlButton    = ^TUIControlButton;
  TUIControlButton    = record
    Base            : TUIBaseControl;
  end;
        
  function CheckOutUIButton: PUIControlButton;
  
implementation

function CheckOutUIButton: PUIControlButton;
begin
  Result := System.New(PUIControlButton);
  FillChar(Result^, SizeOf(TUIControlButton), 0); 
  Result.Base.ControlType := Def_UIControl_Button;
end;

end.
