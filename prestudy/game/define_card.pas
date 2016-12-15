unit define_card;

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
             
implementation

end.
