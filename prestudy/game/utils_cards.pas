unit utils_cards;

interface

type        
  PCardRecord   = ^TCardRecord;
  TCardRecord   = packed record
    CardId      : Byte;
    CardPos     : Byte;
  end;
  
  PCards        = ^TCards;
  TCards        = packed record
    CardCount   : Byte;
    Card        : array[1..1] of TCardRecord;
  end;      
           
  PCardsMax     = ^TCardsMax;
  TCardsMax     = packed record
    CardCount   : Byte;
    Card        : array[1..65565] of TCardRecord;
  end;      
             
  PCards_Mj     = ^TCards_Mj;
  TCards_Mj     = packed record
    CardCount   : Byte;
    Card        : array[1..152] of TCardRecord;
  end;
         
  PCards_Poker1 = ^TCards_Poker1;
  TCards_Poker1 = packed record
    CardCount   : Byte;
    Card        : array[1..54] of TCardRecord;
  end;
        
  PCards_Poker2 = ^TCards_Poker2;
  TCards_Poker2 = packed record
    CardCount   : Byte;
    Card        : array[1..54 * 2] of TCardRecord;
  end;
           
  PCards_Poker3 = ^TCards_Poker3;
  TCards_Poker3 = packed record
    CardCount   : Byte;
    Card        : array[1..54 * 3] of TCardRecord;
  end;

  PCards_Poker4 = ^TCards_Poker4;
  TCards_Poker4 = packed record
    CardCount   : Byte;
    Card        : array[1..54 * 4] of TCardRecord;
  end;
  
  function CheckOutCards_Mj: PCards_Mj;
  function CheckOutCards_Poker1: PCards_Poker1;
  function CheckOutCards_Poker2: PCards_Poker2;
  function CheckOutCards_Poker3: PCards_Poker3;
  function CheckOutCards_Poker4: PCards_Poker4;  
  procedure CheckInCards(var ACards: PCards);

  // Ï´ÅÆ  
  procedure ShuffleCards(ACards: PCards);
  
implementation
                                 
procedure InitCards(ACards: PCards);     
var
  i: integer;
begin
  for i := 1 to ACards.CardCount do
  begin
    ACards.Card[i].CardId := i;
    ACards.Card[i].CardPos := i;
  end;
end;

function CheckOutCards_Mj: PCards_Mj;
begin
  Result := System.New(PCards_Mj);
  FillChar(Result^, SizeOf(TCards_Mj), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;
  InitCards(PCards(Result));
end;

function CheckOutCards_Poker1: PCards_Poker1;
begin
  Result := System.New(PCards_Poker1);
  FillChar(Result^, SizeOf(TCards_Poker1), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;    
  InitCards(PCards(Result));
end;

function CheckOutCards_Poker2: PCards_Poker2;
begin
  Result := System.New(PCards_Poker2);
  FillChar(Result^, SizeOf(TCards_Poker2), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;  
  InitCards(PCards(Result));
end;

function CheckOutCards_Poker3: PCards_Poker3;
begin
  Result := System.New(PCards_Poker3);
  FillChar(Result^, SizeOf(TCards_Poker3), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1; 
  InitCards(PCards(Result));
end;

function CheckOutCards_Poker4: PCards_Poker4;
begin
  Result := System.New(PCards_Poker4);
  FillChar(Result^, SizeOf(TCards_Poker4), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;  
  InitCards(PCards(Result));
end;

procedure CheckInCards(var ACards: PCards);
begin

end;

procedure ShuffleCards(ACards: PCards);
var
  i: Word;
  tmpPos: Integer;
  tmpExchange: Word;
begin
  if 1 > ACards.CardCount then
    exit;
  for i := 1 to ACards.CardCount do
  begin
    tmpPos := Random(ACards.CardCount);
    if (tmpPos <= ACards.CardCount) and (0 <= tmpPos)then
    begin
      if 0 = tmpPos then
        tmpPos := tmpPos + 1;
      tmpExchange := ACards.Card[tmpPos].CardId;
      ACards.Card[tmpPos].CardId := ACards.Card[i].CardId;
      ACards.Card[ACards.Card[tmpPos].CardId].CardPos := tmpPos;
      
      ACards.Card[i].CardId := tmpExchange;
      ACards.Card[ACards.Card[i].CardId].CardPos := i;      
    end;
  end;
end;

end.
