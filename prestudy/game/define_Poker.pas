unit define_Poker;

interface

uses
  define_card,
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

  PPokerClassCard = ^TPokerClassCard;
  TPokerClassCard = packed record  // 2 �ֽ�
    MainClass     : TPokerMainClass;
    SubPoint      : Byte;
  end;

  PPokerPlayCard  = ^TPokerPlayCard;
  TPokerPlayCard  = packed record  // 2 �ֽ�
    ClassCard     : TPokerClassCard;
    CardPoint     : Byte;
    // 
    CardStatus    : Byte;
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
  
const
  CardStatus_Unknown    = 0;
  CardStatus_UnAssigned = 1;
  CardStatus_Shuffle    = 2; // ϴ��
  CardStatus_Dealing    = 3; // ���� 

  // card in some user hand
  CardStatus_UserHandBase = 60; // ���û�����
  // play card by some user
  CardStatus_IndeskBase   = 80; // ��������
                         
  function CheckOutCards_Poker1: PCards_Poker1;
  function CheckOutCards_Poker2: PCards_Poker2;
  function CheckOutCards_Poker3: PCards_Poker3;
  function CheckOutCards_Poker4: PCards_Poker4; 
  function GetPokerClass(ACardPoker: Byte): TPokerClassCard;
  function GetPokerCaption(ACardPoker: Byte): string;
  
implementation

(*
  // ��ʼ����ʱ�� ���ű� ���ÿ�β� �� CPU
*)

function CheckOutCards_Poker1: PCards_Poker1;
begin
  Result := System.New(PCards_Poker1);
  FillChar(Result^, SizeOf(TCards_Poker1), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;    
  //InitCards(PCards(Result));
end;

function CheckOutCards_Poker2: PCards_Poker2;
begin
  Result := System.New(PCards_Poker2);
  FillChar(Result^, SizeOf(TCards_Poker2), 0);
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;
  //InitCards(PCards(Result));
end;

function CheckOutCards_Poker3: PCards_Poker3;
begin
  Result := System.New(PCards_Poker3);
  FillChar(Result^, SizeOf(TCards_Poker3), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1; 
  //InitCards(PCards(Result));
end;

function CheckOutCards_Poker4: PCards_Poker4;
begin
  Result := System.New(PCards_Poker4);
  FillChar(Result^, SizeOf(TCards_Poker4), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;  
  //InitCards(PCards(Result));
end;

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
