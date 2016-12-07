unit uiedittext;

interface

uses
  data.text;
  
(*
  // all this unit should not use any windows unit
  // it should be independence of platform 
*)
type
  // ======================================
  PUIEditTextPos    = ^TUIEditTextPos; 
  PUIEditText       = ^TUIEditText;     
  PUIEdit           = ^TUIEdit;     
  
  TUIEditTextPos    = packed record
    EditLine        : PTextLine;     
    LinePos         : Integer;
    EditDataNode    : PTextDataNodeW;
    NodePos         : Byte;
  end;

  TUIEditText       = packed record
    EditLine        : PTextLine;
    EditPos         : TUIEditTextPos;
  end;

  TUIEdit           = packed record
    EditText        : TUIEditText;
  end;
                                                   
  procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
  procedure EditTextDelete(AEditText: PUIEditText);
  procedure EditTextBackspace(AEditText: PUIEditText);
  
implementation
             
procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
var
  tmpNode: PTextDataNodeW;
begin    
  if nil = AEditText then
    exit;
  if nil = AEditText.EditLine then
    exit;
  if (nil = AEditText.EditPos.EditDataNode) then
  begin
    AEditText.EditPos.EditDataNode := CheckOutTextDataNode;
    InsertTextDataNode(AEditText.EditLine, AEditText.EditPos.EditDataNode, nil);
    AEditText.EditPos.NodePos := 0;
  end;
  if AEditText.EditPos.EditDataNode.Size = AEditText.EditPos.EditDataNode.Length then
  begin
    tmpNode := CheckOutTextDataNode;
    if AEditText.EditPos.NodePos = AEditText.EditPos.EditDataNode.Size then
    begin
      // position is last
      InsertTextDataNode(AEditText.EditLine, tmpNode, AEditText.EditPos.EditDataNode.NextSibling);
      AEditText.EditPos.EditDataNode := tmpNode;
      AEditText.EditPos.NodePos := 0;
    end else
    begin
      if 0 = AEditText.EditPos.NodePos then
      begin
        // position is head  
        InsertTextDataNode(AEditText.EditLine, tmpNode, AEditText.EditPos.EditDataNode);
        AEditText.EditPos.EditDataNode := tmpNode;
        AEditText.EditPos.NodePos := 0;
      end else
      begin         
        // position is middle always insert after position
        // [ DataA Position DataB]
        //
        InsertTextDataNode(AEditText.EditLine, tmpNode, AEditText.EditPos.EditDataNode.NextSibling);
        // move DataB to new data buffer
        //CopyMemory
        Move(
          AEditText.EditPos.EditDataNode.Data[AEditText.EditPos.NodePos],
          tmpNode.Data[0],
          (AEditText.EditPos.EditDataNode.Size - AEditText.EditPos.NodePos)
        );
        // relength DataA Buffer
        AEditText.EditPos.EditDataNode.Length := AEditText.EditPos.NodePos;
        // relength new data Node Buffer
        tmpNode.Length := AEditText.EditPos.EditDataNode.Length - AEditText.EditPos.NodePos;
      end;
    end;
  end;
  if nil <> AEditText.EditPos.EditDataNode then
  begin
    AEditText.EditPos.EditDataNode.Data[AEditText.EditPos.NodePos] := AChar;
    Inc(AEditText.EditPos.NodePos);
    Inc(AEditText.EditPos.EditDataNode.Length);    
    Inc(AEditText.EditPos.LinePos);        
    Inc(AEditText.EditLine.Length); 
  end;
end;

procedure EditTextDelete(AEditText: PUIEditText);
begin
  if 0 < AEditText.EditPos.NodePos  then
  begin
    AEditText.EditPos.EditDataNode.Length := AEditText.EditPos.EditDataNode.Length - 1;
  end;
end;

procedure EditTextBackspace(AEditText: PUIEditText);
begin 
  if 0 < AEditText.EditPos.NodePos  then
  begin
    // move data 
    AEditText.EditPos.EditDataNode.Length := AEditText.EditPos.EditDataNode.Length - 1;
  end;
end;

end.
