unit define_Poker;

interface

uses
  SysUtils;
  
{ 54 ����
  4 * 13 = 52 + 2

  54 * 4 = 216
}

//type
//  TPokerCard = ();

type
  TPokerMainClass = (  
    pokerClassUnknown,
    pokerClassNone,
    pokerClassKing,     // ����
    pokerClassQueen,    // С��
    pokerClassSpades,   // ����
    pokerClassHearts,   // ����
    pokerClassDiamonds, // ���飬
    pokerClassClubs     // ÷��
  );
  
  TPokerClassCard  = packed record
    MainClass   : TPokerMainClass;
    SubPoint    : Byte;
  end;
           
  function GetPokerCaption(ACardPoker: Byte): string;

implementation

(*
  for i := 1 to 54 do
  begin
    tmpColor = (i + 3) div 4;
    tmpPoint = (i + 3) mod 4;
    Memo1.Lines.Add(IntToStr(tmpColor) + ' -- ' + IntToStr(tmpPoint));
  end;
*)
function GetPokerCaption(ACardPoker: Byte): string;
var
  tmpCard: Integer;
  tmpMainClass: integer;
  tmpPoint: integer;
begin
  Result := '';  
  tmpCard := (ACardPoker - 1) mod 54 + 1;
  tmpPoint := (tmpCard + 3) div 4;
  tmpMainClass := (tmpCard + 3) mod 4;
  if (0 < tmpPoint) and (14 > tmpPoint) then
  begin
    case tmpMainClass of
      0: Result := IntToStr(tmpPoint) + 'C';// pokerClassClubs; // ÷��
      1: Result := IntToStr(tmpPoint) + 'D';//pokerClassDiamonds; // ����
      2: Result := IntToStr(tmpPoint) + 'H';//pokerClassHearts; // ����
      3: Result := IntToStr(tmpPoint) + 'S';//pokerClassSpades; // ����
    end;
  end else if 14 = tmpPoint then
  begin
    case tmpMainClass of
      0: Result := 'queen';//pokerClassQueen; // С��
      1: Result := 'king';//pokerClassKing; // ����
    end;
  end;
end;

end.
