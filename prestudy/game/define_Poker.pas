unit define_Poker;

interface

uses
  SysUtils;
  
{ 54 张牌
  4 * 13 = 52 + 2

  54 * 4 = 216
}

//type
//  TPokerCard = ();

type
  TPokerMainClass = (
    pokerClassNone,
    pokerClassUnknown,  
    pokerClassKing,     // 大王
    pokerClassQueen,    // 小王
    pokerClassSpades,   // 黑桃
    pokerClassHearts,   // 红桃
    pokerClassDiamonds, // 方块，
    pokerClassClubs     // 梅花
  );
  
  TPokerClassCard = packed record  // 2 字节
    MainClass     : TPokerMainClass;
    SubPoint      : Byte;
  end;

  TPokerPlayCard  = packed record  // 2 字节
    ClassCard     : TPokerClassCard;
    CardPoint     : Byte;
    // 
    CardStatus    : Byte;
  end;

const
  CardStatus_Unknown    = 0;
  CardStatus_UnAssigned = 1;
  CardStatus_Shuffle    = 2; // 洗牌
  CardStatus_Dealing    = 3; // 发牌 

  // card in some user hand
  CardStatus_UserHandBase = 60; // 在用户手中
  // play card by some user
  CardStatus_IndeskBase   = 80; // 在牌桌上

  function GetPokerClass(ACardPoker: Byte): TPokerClassCard;
  function GetPokerCaption(ACardPoker: Byte): string;
  
implementation

(*
  // 初始化的时候 建张表 免得每次查 费 CPU
*)

function GetPokerClass(ACardPoker: Byte): TPokerClassCard;  
var
  tmpCard: Integer;
begin
  Result.MainClass := pokerClassUnknown;
  Result.SubPoint := 0;
  tmpCard := (ACardPoker - 1) mod 54 + 1;
  Result.SubPoint := (tmpCard + 3) div 4;
  if (0 < Result.SubPoint) and (14 > Result.SubPoint) then
  begin
    case (tmpCard + 3) mod 4 of
      0: Result.MainClass := pokerClassClubs;// pokerClassClubs; // 梅花
      1: Result.MainClass := pokerClassDiamonds;//pokerClassDiamonds; // 方块
      2: Result.MainClass := pokerClassHearts;//pokerClassHearts; // 红桃
      3: Result.MainClass := pokerClassSpades;//pokerClassSpades; // 黑桃
    end;
  end else if 14 = Result.SubPoint then
  begin
    case (tmpCard + 3) mod 4 of
      0: Result.MainClass := pokerClassQueen;//pokerClassQueen; // 小王
      1: Result.MainClass := pokerClassKing;//pokerClassKing; // 大王
    end;
  end;
end;

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
      0: Result := IntToStr(tmpPoint) + 'C';// pokerClassClubs; // 梅花
      1: Result := IntToStr(tmpPoint) + 'D';//pokerClassDiamonds; // 方块
      2: Result := IntToStr(tmpPoint) + 'H';//pokerClassHearts; // 红桃
      3: Result := IntToStr(tmpPoint) + 'S';//pokerClassSpades; // 黑桃
    end;
  end else if 14 = tmpPoint then
  begin
    case tmpMainClass of
      0: Result := 'queen';//pokerClassQueen; // 小王
      1: Result := 'king';//pokerClassKing; // 大王
    end;
  end;
end;

end.
