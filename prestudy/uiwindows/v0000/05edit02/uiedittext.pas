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
  
  TUIEditTextPos    = packed record
    EditLine        : PTextLine;
    EditLineNode    : PTextLineNode;         
    LinePos         : Integer;
    EditDataNode    : PTextDataNodeW;
    NodePos         : Byte;
  end;

  TUIEditText       = packed record
    LineCount       : LongWord;   
    // 0 == 只读
    // 1 == 单行 Edit
    // 65565 == 多行 Limit
    InputLineLimit  : Word;
    // 一行最大的字符限制
    // ?????
    LineCharLimit   : Word;
    TextLine        : PTextLine;
    TextLines       : TTextLines;
    EditPos         : TUIEditTextPos;
  end;

  function CheckOutEditTextLine(AEditText: PUIEditText): PTextLine;

  procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
  procedure EditTextDelete(AEditText: PUIEditText);
  procedure EditTextBackspace(AEditText: PUIEditText);
  
implementation

function CheckOutEditTextLine(AEditText: PUIEditText): PTextLine;
begin
  Result := CheckOutTextLine(@AEditText.TextLines);
  Inc(AEditText.LineCount);
  if 1 = AEditText.LineCount then
    AEditText.TextLine := Result
  else
    AEditText.TextLine := nil;
  AEditText.EditPos.EditLine := Result;
  AEditText.EditPos.EditLineNode := AEditText.TextLines.LastLineNode;
  AEditText.EditPos.EditDataNode := nil;    
end;

procedure EditTextAdd(AEditText: PUIEditText; AChar: WideChar);
var
  tmpNode: PTextDataNodeW;
begin    
  if nil = AEditText then
    exit;              
  if 0 = AEditText.LineCount then
    AEditText.TextLine := CheckOutEditTextLine(AEditText);
  if nil = AEditText.EditPos.EditLine then
    exit;
  if (nil = AEditText.EditPos.EditDataNode) then
  begin
    AEditText.EditPos.EditDataNode := CheckOutTextDataNode;
    InsertTextDataNode(AEditText.EditPos.EditLine, AEditText.EditPos.EditDataNode, nil);
    AEditText.EditPos.NodePos := 0;
  end;
  if AEditText.EditPos.EditDataNode.Size = AEditText.EditPos.EditDataNode.Length then
  begin
    tmpNode := CheckOutTextDataNode;
    if AEditText.EditPos.NodePos = AEditText.EditPos.EditDataNode.Size then
    begin
      // position is last
      InsertTextDataNode(AEditText.EditPos.EditLine, tmpNode, AEditText.EditPos.EditDataNode.NextSibling);
      AEditText.EditPos.EditDataNode := tmpNode;
      AEditText.EditPos.NodePos := 0;
    end else
    begin
      if 0 = AEditText.EditPos.NodePos then
      begin
        // position is head  
        InsertTextDataNode(AEditText.EditPos.EditLine, tmpNode, AEditText.EditPos.EditDataNode);
        AEditText.EditPos.EditDataNode := tmpNode;
        AEditText.EditPos.NodePos := 0;
      end else
      begin         
        // position is middle always insert after position
        // [ DataA Position DataB]
        //
        InsertTextDataNode(AEditText.EditPos.EditLine, tmpNode, AEditText.EditPos.EditDataNode.NextSibling);
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
    Inc(AEditText.EditPos.EditLine.Length); 
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
  if 1 > AEditText.LineCount then
    exit;
  // find edit line
  while (nil <> AEditText.EditPos.EditLine) and (1 > AEditText.EditPos.LinePos) do
  begin
    if (nil <> AEditText.EditPos.EditLineNode) then
    begin
      if nil = AEditText.EditPos.EditLineNode.PrevSibling then
      begin
        Break;
      end else
      begin
        AEditText.EditPos.EditLineNode := AEditText.EditPos.EditLineNode.PrevSibling;
        if nil <> AEditText.EditPos.EditLineNode then
        begin
          // delete one row ???
          AEditText.EditPos.EditLine := AEditText.EditPos.EditLineNode.TextLine;
          AEditText.EditPos.LinePos := AEditText.EditPos.EditLine.Length;
          AEditText.EditPos.EditDataNode := AEditText.EditPos.EditLine.LastDataNode;
          AEditText.EditPos.NodePos := AEditText.EditPos.EditDataNode.Length;

          AEditText.LineCount := AEditText.LineCount - 1;

          exit;
        end else
        begin
          AEditText.EditPos.EditLine := nil;
          AEditText.EditPos.LinePos := 0;
        end;
      end;
    end;
  end;             
  // find edit line node  
  if nil <> AEditText.EditPos.EditLine then
  begin
    if 0 <AEditText.EditPos.LinePos then
    begin      
      while (nil <> AEditText.EditPos.EditDataNode) and
            (1 > AEditText.EditPos.EditDataNode.Length) do
      begin
        if nil <> AEditText.EditPos.EditDataNode.PrevSibling then
        begin
          AEditText.EditPos.EditDataNode := AEditText.EditPos.EditDataNode.PrevSibling;
          AEditText.EditPos.NodePos := AEditText.EditPos.EditDataNode.Length;
        end;
      end;
      
      // move data
      if nil <> AEditText.EditPos.EditDataNode then
      begin
        if 0 < AEditText.EditPos.EditDataNode.Length then
        begin
          AEditText.EditPos.EditDataNode.Length := AEditText.EditPos.EditDataNode.Length - 1;
          AEditText.EditPos.NodePos := AEditText.EditPos.NodePos - 1;
          AEditText.EditPos.LinePos := AEditText.EditPos.LinePos - 1;
        end;
      end;
    end;    
  end;
end;

end.
