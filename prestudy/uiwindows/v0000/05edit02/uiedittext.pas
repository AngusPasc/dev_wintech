unit uiedittext;

interface

(*
  // all this unit should not use any windows unit
  // it should be independence of platform 
*)
type
  PUITextDataNodeW  = ^TUITextDataNodeW;    
  PUITextLine       = ^TUITextLine;   
  PUITextLineNode   = ^TUITextLineNode;  
  PUITextLines      = ^TUITextLines;
  
  TUITextDataNodeW = packed record
    PrevSibling     : PUITextDataNodeW;
    NextSibling     : PUITextDataNodeW;
    Size            : Byte;
    Length          : Byte;
    Data            : array[0..8 - 1] of WideChar;
  end;

  TUITextLine       = packed record 
    FirstBufferNode : PUITextDataNodeW;
    LastBufferNode  : PUITextDataNodeW;
    Size            : LongWord;
    Length          : LongWord;
  end;

  TUITextLineNode   = packed record
    PrevSibling     : PUITextLineNode;
    NextSibling     : PUITextLineNode;
    TextLine        : PUITextLine;
  end;

  TUITextLines      = packed record
    FirstLineNode   : PUITextLineNode;
    LastLineNode    : PUITextLineNode;
  end;

  // ======================================
  PUIEditTextPos    = ^TUIEditTextPos; 
  PUIEditText       = ^TUIEditText;     
  PUIEdit           = ^TUIEdit;     
  
  TUIEditTextPos    = packed record
    EditLine        : PUITextLine;     
    LinePos         : Integer;
    EditDataNode    : PUITextDataNodeW;
    NodePos         : Byte;
  end;

  TUIEditText       = packed record
    EditLine        : PUITextLine;
    EditPos         : TUIEditTextPos;
  end;

  TUIEdit           = packed record
    EditText        : TUIEditText;
  end;
                                                   
  function CheckOutTextLine: PUITextLine;
  function CheckOutTextDataNode: PUITextDataNodeW;
                                
  procedure InsertTextDataNode(ATextLine: PUITextLine; ADataNode, APositionDataNode: PUITextDataNodeW);  
  procedure RemoveTextDataNode(ATextLine: PUITextLine; ADataNode: PUITextDataNodeW);

  procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
  procedure EditTextDelete(AEditText: PUIEditText);
  procedure EditTextBackspace(AEditText: PUIEditText);
  
implementation
                
function CheckOutTextLine: PUITextLine;
begin
  Result := System.New(PUITextLine);
  FillChar(Result^, SizeOf(TUITextLine), 0);
end;

function CheckOutTextDataNode: PUITextDataNodeW;
begin
  Result := System.New(PUITextDataNodeW);
  FillChar(Result^, SizeOf(TUITextDataNodeW), 0);
  Result.Size := SizeOf(Result.Data) div SizeOf(WideChar);
end;
    
procedure InsertTextDataNode(ATextLine: PUITextLine; ADataNode, APositionDataNode: PUITextDataNodeW);
begin
  // insert before APositionDataNode
  if nil = ADataNode then
    exit;
  if nil = APositionDataNode then
  begin                         
    if nil = ATextLine.FirstBufferNode then
      ATextLine.FirstBufferNode := ADataNode;
    if nil <> ATextLine.LastBufferNode then
    begin
      ADataNode.PrevSibling := ATextLine.LastBufferNode;
      ATextLine.LastBufferNode.NextSibling := ADataNode;
    end;
    ATextLine.LastBufferNode := ADataNode;
  end else
  begin
    ADataNode.PrevSibling := APositionDataNode.PrevSibling;
    ADataNode.NextSibling := APositionDataNode;  
    APositionDataNode.PrevSibling := ADataNode;
    if nil = ADataNode.PrevSibling then
    begin
      ATextLine.FirstBufferNode := ADataNode;
    end else
    begin
      ADataNode.PrevSibling.NextSibling := ADataNode;
    end;
  end;    
  ATextLine.Size := ATextLine.Size + ADataNode.Size;
end;
        
procedure RemoveTextDataNode(ATextLine: PUITextLine; ADataNode: PUITextDataNodeW);
begin
  if nil = ADataNode.PrevSibling then
    ATextLine.FirstBufferNode := ADataNode.NextSibling
  else
    ADataNode.PrevSibling.NextSibling := ADataNode.NextSibling;
  if nil = ADataNode.NextSibling then
    ATextLine.LastBufferNode := ADataNode.PrevSibling
  else
    ADataNode.NextSibling.PrevSibling := ADataNode.PrevSibling;
  ADataNode.PrevSibling := nil;
  ADataNode.NextSibling := nil;     
  ATextLine.Size := ATextLine.Size - ADataNode.Size;
end;
             
procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
var
  tmpNode: PUITextDataNodeW;
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
