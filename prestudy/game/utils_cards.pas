unit utils_cards;

interface

uses
  define_card;
   
  procedure CheckInCards(var ACards: PCards);
  // Ï´ÅÆ  
  procedure ShuffleCards(ACards: PCards);
  
implementation
                                 
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
  for i := FirstCardIndex to FirstCardIndex + ACards.CardCount - 1 do
  begin
    tmpPos := Random(ACards.CardCount);
    if (tmpPos < FirstCardIndex + ACards.CardCount) and (FirstCardIndex - 1 < tmpPos)then
    begin
      tmpExchange := ACards.Card[tmpPos].CardId;
      ACards.Card[tmpPos].CardId := ACards.Card[i].CardId;
      ACards.Card[ACards.Card[tmpPos].CardId].CardPos := tmpPos;
      
      ACards.Card[i].CardId := tmpExchange;
      ACards.Card[ACards.Card[i].CardId].CardPos := i;      
    end;
  end;
end;

end.
