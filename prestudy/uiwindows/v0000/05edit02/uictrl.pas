unit uictrl;

interface

uses
  Types;
  
type
  PUIBaseControl    = ^TUIBaseControl;
  TUIBaseControl    = packed record
    ControlType     : Word;
    // Layout: PUILayout;
    // UISpace: PUISpace
    // UITexture: PUITexture; 
    BoundRect       : TRect;
  end;
              
  PUIControlNode    = ^TUIControlNode;
  TUIControlNode    = packed record
    Parent          : PUIBaseControl;
    PrevSibling     : PUIControlNode;
    NextSibling     : PUIControlNode;
    //FirstChild      : PUIControlNode;
    //LastChild       : PUIControlNode;
    Control         : PUIBaseControl;
  end;

const
  Def_UIControl_Form    = 101;
  Def_UIControl_Panel   = 102;
  // combine several control as a whole 
  Def_UIControl_Group   = 103;

  // single control
  Def_UIControl_Edit    = 201;
  Def_UIControl_Button  = 202;

  function CheckOutControlNode: PUIControlNode;
  
implementation

function CheckOutControlNode: PUIControlNode;
begin
  Result := System.New(PUIControlNode);
  FillChar(Result^, SizeOf(TUIControlNode), 0);
end;

end.
