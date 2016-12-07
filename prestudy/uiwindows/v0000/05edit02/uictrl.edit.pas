unit uictrl.edit;

interface
                 
uses
  uictrl,
  uiedittext;
  
type           
  PUIControlEdit    = ^TUIControlEdit;
  TUIControlEdit    = record
    Base            : TUIBaseControl;    
    EditTextTest: TUIEditText;
  end;
        
  function CheckOutUIEdit: PUIControlEdit;
  
implementation

function CheckOutUIEdit: PUIControlEdit;
begin
  Result := System.New(PUIControlEdit);
  FillChar(Result^, SizeOf(TUIControlEdit), 0);  
  Result.Base.ControlType := Def_UIControl_Edit;
end;

end.
