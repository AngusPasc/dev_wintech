unit data.text;

interface

type
  PTextDataNodeW  = ^TTextDataNodeW;    
  PTextLine       = ^TTextLine;   
  PTextLineNode   = ^TTextLineNode;
  PTextLines      = ^TTextLines;
  
  TTextDataNodeW  = packed record
    PrevSibling   : PTextDataNodeW;
    NextSibling   : PTextDataNodeW;
    Size          : Byte;
    Length        : Byte;
    Data          : array[0..8 - 1] of WideChar;
  end;

  TTextLine       = packed record
    FirstDataNode : PTextDataNodeW;
    LastDataNode  : PTextDataNodeW;
    Size          : LongWord;
    Length        : LongWord;
  end;

  TTextLineNode   = packed record
    PrevSibling   : PTextLineNode;
    NextSibling   : PTextLineNode;
    TextLine      : PTextLine;
  end;

  TTextLines      = packed record
    FirstLineNode : PTextLineNode;
    LastLineNode  : PTextLineNode;
  end;
                 
  function CheckOutTextLine: PTextLine;
  function CheckOutTextDataNode: PTextDataNodeW;
                                
  procedure InsertTextDataNode(ATextLine: PTextLine; ADataNode, APositionDataNode: PTextDataNodeW);  
  procedure RemoveTextDataNode(ATextLine: PTextLine; ADataNode: PTextDataNodeW);

implementation

function CheckOutTextLine: PTextLine;
begin
  Result := System.New(PTextLine);
  FillChar(Result^, SizeOf(TTextLine), 0);
end;

function CheckOutTextDataNode: PTextDataNodeW;
begin
  Result := System.New(PTextDataNodeW);
  FillChar(Result^, SizeOf(TTextDataNodeW), 0);
  Result.Size := SizeOf(Result.Data) div SizeOf(WideChar);
end;

procedure InsertTextDataNode(ATextLine: PTextLine; ADataNode, APositionDataNode: PTextDataNodeW);
begin
  // insert before APositionDataNode
  if nil = ADataNode then
    exit;
  if nil = APositionDataNode then
  begin                         
    if nil = ATextLine.FirstDataNode then
      ATextLine.FirstDataNode := ADataNode;
    if nil <> ATextLine.LastDataNode then
    begin
      ADataNode.PrevSibling := ATextLine.LastDataNode;
      ATextLine.LastDataNode.NextSibling := ADataNode;
    end;
    ATextLine.LastDataNode := ADataNode;
  end else
  begin
    ADataNode.PrevSibling := APositionDataNode.PrevSibling;
    ADataNode.NextSibling := APositionDataNode;  
    APositionDataNode.PrevSibling := ADataNode;
    if nil = ADataNode.PrevSibling then
    begin
      ATextLine.FirstDataNode := ADataNode;
    end else
    begin
      ADataNode.PrevSibling.NextSibling := ADataNode;
    end;
  end;    
  ATextLine.Size := ATextLine.Size + ADataNode.Size;
end;
        
procedure RemoveTextDataNode(ATextLine: PTextLine; ADataNode: PTextDataNodeW);
begin
  if nil = ADataNode.PrevSibling then
    ATextLine.FirstDataNode := ADataNode.NextSibling
  else
    ADataNode.PrevSibling.NextSibling := ADataNode.NextSibling;
  if nil = ADataNode.NextSibling then
    ATextLine.LastDataNode := ADataNode.PrevSibling
  else
    ADataNode.NextSibling.PrevSibling := ADataNode.PrevSibling;
  ADataNode.PrevSibling := nil;
  ADataNode.NextSibling := nil;     
  ATextLine.Size := ATextLine.Size - ADataNode.Size;
end;
    
end.
