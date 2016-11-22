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
    pokerClassNone,
    pokerClassUnknown,  
    pokerClassKing,     // ����
    pokerClassQueen,    // С��
    pokerClassSpades,   // ����
    pokerClassHearts,   // ����
    pokerClassDiamonds, // ���飬
    pokerClassClubs     // ÷��
  );
  
  TPokerClassCard = packed record  // 2 �ֽ�
    MainClass     : TPokerMainClass;
    SubPoint      : Byte;
  end;

  TPokerPlayCard  = packed record  // 2 �ֽ�
    ClassCard     : TPokerClassCard;
    CardPoint     : Byte;
    // 
    CardStatus    : Byte;
  end;

const
  CardStatus_Unknown    = 0;
  CardStatus_UnAssigned = 1;
  CardStatus_Shuffle    = 2; // ϴ��
  CardStatus_Dealing    = 3; // ���� 

  // card in some user hand
  CardStatus_UserHandBase = 60; // ���û�����
  // play card by some user
  CardStatus_IndeskBase   = 80; // ��������

  function GetPokerClass(ACardPoker: Byte): TPokerClassCard;
  function GetPokerCaption(ACardPoker: Byte): string;
  
implementation

(*
  // ��ʼ����ʱ�� ���ű� ���ÿ�β� �� CPU
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
      0: Result.MainClass := pokerClassClubs;// pokerClassClubs; // ÷��
      1: Result.MainClass := pokerClassDiamonds;//pokerClassDiamonds; // ����
      2: Result.MainClass := pokerClassHearts;//pokerClassHearts; // ����
      3: Result.MainClass := pokerClassSpades;//pokerClassSpades; // ����
    end;
  end else if 14 = Result.SubPoint then
  begin
    case (tmpCard + 3) mod 4 of
      0: Result.MainClass := pokerClassQueen;//pokerClassQueen; // С��
      1: Result.MainClass := pokerClassKing;//pokerClassKing; // ����
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
