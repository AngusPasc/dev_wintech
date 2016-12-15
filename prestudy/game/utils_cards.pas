unit utils_cards;

interface

uses
  define_card;
   
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
