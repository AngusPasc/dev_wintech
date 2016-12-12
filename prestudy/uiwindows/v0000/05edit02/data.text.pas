unit data.text;

interface

type                               
  PTextData       = ^TTextData;
  PTextDataNodeW  = ^TTextDataNodeW; 
  PTextDataPtrNodeW = ^TTextDataPtrNodeW;
     
  PTextLine       = ^TTextLine;   
  PTextLineNode   = ^TTextLineNode;
  PTextLines      = ^TTextLines;
  
  TTextDataNodeW  = packed record
    PrevSibling   : PTextDataNodeW;
    NextSibling   : PTextDataNodeW;
    Size          : Word;
    Length        : Word;
    Data          : array[0..8 - 1] of WideChar;
  end;
                    
  TTextDataNodeW_64K  = packed record
    PrevSibling   : PTextDataNodeW;
    NextSibling   : PTextDataNodeW;
    Size          : Word;
    Length        : Word;
    Data          : array[0..65565 - 1] of WideChar;
  end;

  TTextData       = packed record
    Data          : array[0..255] of WideChar;
  end;

  TTextDataPtrNodeW = packed record
    PrevSibling   : PTextDataPtrNodeW;
    NextSibling   : PTextDataPtrNodeW;  
    Size          : Word;
    Length        : Word;    
    PData         : PTextData;
  end;
  
  TTextLine       = packed record
    FirstDataNode : PTextDataNodeW;
    LastDataNode  : PTextDataNodeW;
    //NodeCount     : Word;
    Size          : LongWord;
    Length        : LongWord;
  end;

  TTextLineNode   = packed record
    PrevSibling   : PTextLineNode;
    NextSibling   : PTextLineNode;
    TextLine      : PTextLine;
  end;

  TTextLines      = packed record   
    NodeCount     : LongWord;   
    FirstLineNode : PTextLineNode;
    LastLineNode  : PTextLineNode;
  end;

  function CheckOutTextDataNode: PTextDataNodeW;     
  procedure CheckInTextDataNode(ATextDataNode: PTextDataNodeW);
  
  function CheckOutTextLine(ATextLines: PTextLines = nil): PTextLine; overload;
  procedure PackTextLine(ATextLine: PTextLine);

  function CheckOutTextLineNode(ATextLines: PTextLines): PTextLineNode;
  procedure CheckInTextLineNode(ATextLines: PTextLines; ATextLineNode: PTextLineNode);


  procedure InsertTextDataNode(ATextLine: PTextLine; ADataNode, APositionDataNode: PTextDataNodeW);  
  procedure RemoveTextDataNode(ATextLine: PTextLine; ADataNode: PTextDataNodeW);

implementation

function CheckOutTextLineNode(ATextLines: PTextLines): PTextLineNode;
begin
  Result := System.New(PTextLineNode);
  FillChar(Result^, SizeOf(TTextLineNode), 0);
  if nil = ATextLines.FirstLineNode then
    ATextLines.FirstLineNode := Result;
  if nil <> ATextLines.LastLineNode then
  begin
    Result.PrevSibling := ATextLines.LastLineNode;
    ATextLines.LastLineNode.NextSibling := Result;
  end;
  ATextLines.LastLineNode := Result;
end;

procedure CheckInTextLineNode(ATextLines: PTextLines; ATextLineNode: PTextLineNode);
begin

end;

function CheckOutTextLine(ATextLines: PTextLines = nil): PTextLine;
begin                 
  Result := System.New(PTextLine);
  FillChar(Result^, SizeOf(TTextLine), 0);
  if nil <> ATextLines then
  begin
    if (nil = ATextLines.LastLineNode) then
    begin
      ATextLines.FirstLineNode := System.New(PTextLineNode);
      FillChar(ATextLines.FirstLineNode^, SizeOf(TTextLineNode), 0);
      ATextLines.LastLineNode := ATextLines.FirstLineNode;
      ATextLines.FirstLineNode.TextLine := Result;
    end else
    begin
      ATextLines.LastLineNode.NextSibling := System.New(PTextLineNode);
      ATextLines.LastLineNode.NextSibling.PrevSibling := ATextLines.LastLineNode;
      ATextLines.LastLineNode := ATextLines.LastLineNode.NextSibling;
      ATextLines.LastLineNode.NextSibling := nil;
    end;
    ATextLines.LastLineNode.TextLine := Result;  
    Inc(ATextLines.NodeCount);
  end;
end;

procedure PackTextLine(ATextLine: PTextLine);
var
  tmpDataNode: PTextDataNodeW;
  tmpNewDataNode: PTextDataNodeW;
  tmpPos: integer;  
begin
  //if 1 < ATextLine.NodeCount then
  begin
    //ATextLine.Size
    tmpPos := 0;
    tmpNewDataNode := nil;
    tmpDataNode := ATextLine.FirstDataNode;
    while nil <> tmpDataNode do
    begin
      Move(tmpDataNode.Data[0], tmpNewDataNode.Data[tmpPos], tmpDataNode.Length);
      tmpDataNode := tmpDataNode.NextSibling;
    end;
  end;
end;

function CheckOutTextDataNode: PTextDataNodeW;
begin
  Result := System.New(PTextDataNodeW);
  FillChar(Result^, SizeOf(TTextDataNodeW), 0);
  Result.Size := SizeOf(Result.Data) div SizeOf(WideChar);
end;

procedure CheckInTextDataNode(ATextDataNode: PTextDataNodeW);
begin
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
