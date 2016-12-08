unit uictrl.form;

interface

uses
  uictrl;
  
type
  TUIControlContainer = record
    FirstChild      : PUIControlNode;
    LastChild       : PUIControlNode;
  end;

  // abstract container control
  PUIContainerControl = ^TUIContainerControl;
  TUIContainerControl = record     
    Base            : TUIBaseControl;
    Container       : TUIControlContainer;  
  end;
  
  PUIControlForm    = ^TUIControlForm;
  TUIControlForm    = record
    Base            : TUIBaseControl;
    Container       : TUIControlContainer;

    WMKeyControl    : PUIBaseControl;
    // ???
    //WMCharControl   : PUIBaseControl;
  end;

  PUIControlPanel   = ^TUIControlPanel;
  TUIControlPanel   = record
    Base            : TUIBaseControl;
    Container       : TUIControlContainer;
  end;

  function CheckOutUIForm: PUIControlForm;
  
  procedure UIControlAdd(AChild, AParent: PUIBaseControl);
  
implementation

function CheckOutUIForm: PUIControlForm;
begin
  Result := System.New(PUIControlForm);
  FillChar(Result^, SizeOf(TUIControlForm), 0);
  Result.Base.ControlType := Def_UIControl_Form;
end;

procedure UIControlAdd(AChild, AParent: PUIBaseControl);
var
  tmpControlNode: PUIControlNode;
begin
  if (Def_UIControl_Form = AParent.ControlType) or
     (Def_UIControl_Panel = AParent.ControlType)  then
  begin
    tmpControlNode := CheckOutControlNode;
    tmpControlNode.Control := AChild;

    tmpControlNode.Parent := AParent;
    if nil = PUIContainerControl(AParent).Container.FirstChild then
      PUIContainerControl(AParent).Container.FirstChild := tmpControlNode;
    if nil <> PUIContainerControl(AParent).Container.LastChild then
    begin                                                                            
      tmpControlNode.PrevSibling := PUIContainerControl(AParent).Container.LastChild;
      PUIContainerControl(AParent).Container.LastChild.NextSibling := tmpControlNode;
    end;      
    PUIContainerControl(AParent).Container.LastChild := tmpControlNode;      
  end;
end;

end.
