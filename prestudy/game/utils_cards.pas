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
  
  function CheckOutCards_Mj(ACardCount: Byte = 0): PCards_Mj;
  procedure CheckInCards(var ACards: PCards);

  // Ï´ÅÆ  
  procedure ShuffleCards(ACards: PCards);
  
implementation
                                
function CheckOutCards_Mj(ACardCount: Byte = 0): PCards_Mj;
var
  i: integer;
  id: integer;
begin
  Result := System.New(PCards_Mj);
  FillChar(Result^, SizeOf(TCards_Mj), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;

  id := 1;
  for i := Low(Result.Card) to High(Result.Card) do
  begin
    Result.Card[i].CardId := id;
    Result.Card[i].CardPos := id;
    Inc(id);
  end;
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
