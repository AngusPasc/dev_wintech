unit define_card;

interface

const             
  FirstCardIndex = 1;

type         
  PCardRecord   = ^TCardRecord;
  TCardRecord   = packed record
    CardId      : Byte;
    CardPos     : Byte;
  end;
        
  PCards        = ^TCards;
  TCards        = packed record
    CardCount   : Byte;
    Card        : array[FirstCardIndex..FirstCardIndex] of TCardRecord;
  end;      
           
  PCardsMax     = ^TCardsMax;
  TCardsMax     = packed record
    CardCount   : Byte;
    Card        : array[FirstCardIndex..65565] of TCardRecord;
  end;      
                      
  procedure InitCards(ACards: PCards);

implementation

procedure InitCards(ACards: PCards);     
var
  i: integer;
begin
  for i := FirstCardIndex to FirstCardIndex + ACards.CardCount - 1 do
  begin
    ACards.Card[i].CardId := i;
    ACards.Card[i].CardPos := i;
  end;
end;

end.
