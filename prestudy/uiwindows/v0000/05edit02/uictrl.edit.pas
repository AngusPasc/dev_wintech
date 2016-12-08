unit uictrl.edit;

interface
                 
uses
  uictrl,
  uiview_space,
  uiview_shape,
  uiview_texture,
  uiedittext;
  
type           
  PUIControlEdit    = ^TUIControlEdit;
  TUIControlEdit    = record
    Base            : TUIBaseControl;    
    EditText        : TUIEditText;
    
    // FMX firemonkey design
    // Background: FMX.Objects.TRectangle;
    // Content: Tlayout;
    // foreground: TBrushObject;
    // selection: TBrushObject;
    // font: TFontObject;
    // prompt: TLabel;
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
