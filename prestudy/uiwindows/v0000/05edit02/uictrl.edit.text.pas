unit uictrl.edit.text;

interface

type
  PEditTextDataNodeW  = ^TEditTextDataNodeW;    
  PEditTextLine       = ^TEditTextLine;   
  PEditTextLineNode   = ^TEditTextLineNode;
  PEditTextLines      = ^TEditTextLines;
  
  TEditTextDataNodeW  = packed record
    PrevSibling       : PEditTextDataNodeW;
    NextSibling       : PEditTextDataNodeW;
    Size              : Byte;
    Length            : Byte;
    Data              : array[0..8 - 1] of WideChar;
  end;

  TEditTextLine       = packed record 
    FirstBufferNode   : PEditTextDataNodeW;
    LastBufferNode    : PEditTextDataNodeW;
    Size              : LongWord;
    Length            : LongWord;
  end;

  TEditTextLineNode   = packed record
    PrevSibling       : PEditTextLineNode;
    NextSibling       : PEditTextLineNode;
    TextLine          : PEditTextLine;
  end;

  TEditTextLines      = packed record
    FirstLineNode     : PEditTextLineNode;
    LastLineNode      : PEditTextLineNode;
  end;
                       
  function CheckOutTextLine: PEditTextLine;
  function CheckOutTextDataNode: PEditTextDataNodeW;
                                
  procedure InsertTextDataNode(ATextLine: PEditTextLine; ADataNode, APositionDataNode: PEditTextDataNodeW);  
  procedure RemoveTextDataNode(ATextLine: PEditTextLine; ADataNode: PEditTextDataNodeW);

implementation

function CheckOutTextLine: PEditTextLine;
begin
  Result := System.New(PEditTextLine);
  FillChar(Result^, SizeOf(TEditTextLine), 0);
end;

function CheckOutTextDataNode: PEditTextDataNodeW;
begin
  Result := System.New(PEditTextDataNodeW);
  FillChar(Result^, SizeOf(TEditTextDataNodeW), 0);
  Result.Size := SizeOf(Result.Data) div SizeOf(WideChar);
end;

procedure InsertTextDataNode(ATextLine: PEditTextLine; ADataNode, APositionDataNode: PEditTextDataNodeW);
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
        
procedure RemoveTextDataNode(ATextLine: PEditTextLine; ADataNode: PEditTextDataNodeW);
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
    
end.
