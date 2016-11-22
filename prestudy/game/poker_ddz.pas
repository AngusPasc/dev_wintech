unit poker_ddz;

interface

{ doudizhu }

uses
  define_Poker;

(*
    // 1. shuffle
    // 2. Dealing, Deing, Licensing
    //    ϴ��Shuffle. ����Deing äעTheBlinds
    //    ��˫�� Double deal
    //    ������ Crooked deal
    // 3. ��ׯ hog [ ����+3 , ��ʼ����λ�� ]
    // 4. �غ� round
          ���� Suit patterns ���� Suit placing ��ɫ����
               1: [1]
               2: [2]  [��ը]
               3: [3*1]
               4: [3*1 + 1] [4*1 (ը)] 
               5: [3*1 + 2*1 ��һ��] [4*1 + 1] [1*5 (˳��)]
               6: [3*2 (�ɻ�)] [2*3 (������)]  [1*6 (˳��)]
               7: [1*7 (˳��)]
               8: [1*8 (˳��)] [3*2 + 1*1 + 1*1 �ɻ�]
               9: [1*9 (˳��)]               
               10:[1*10 (˳��)] [3*2 + 2*2 �ɻ�]
          ����� ����Ȩ�� + 1

          ��ը ���
          4 * 1

          A vs B
          n * v [number * value]
          Value =  ((n div 4) + 1)

          ����
          Value B > Value A ������Ȼ�С��

          1. �Ƿ���ը
             1.1 ը
             1.2 ����ը �Ƚ�����һ��
          
    // 5. ��� ���� Settlement balance

    ˳����� 11 �� �� 3 �� K �� 4 �� A
    
    (54 - 3) / 3 = 17
    17 + 17 + 20 = 54

*)

type
  TCardPattern = (
    patternNone,     
    patternUnknown,
    patternSingle,
    patternDouble,
    patternTriple,
    patternFour,
    patternBomb
  );

  PPatternCard  = ^TPatternCard;
  TPatternCard  = packed record
    Pattern     : TCardPattern;
    MasterCount : Byte;
    MasterStart : Byte;
    SlaveCount  : Byte;
  end;

(*
  normal
    patternSingle: 
        MasterCount = 1  ����
        MasterCount > 1  ˳��
    patternDouble
        MasterCount = 1  һ��
        MasterCount > 2  ����
            SlaveCount  = 0
    patternTriple         
        MasterCount = 1
            SlaveCount  = 0  ����
            SlaveCount  = 1  ����һ
            SlaveCount  = 2  ����һ��
        MasterCount > 1   n
            SlaveCount  = 0  �ɻ�
            SlaveCount  = n * 1  �ɻ�
            SlaveCount  = n * 2  �ɻ�
    patternFour     
        MasterCount = 1    
            SlaveCount  = 1  �Ĵ�һ    
            SlaveCount  = 2  �Ĵ���
        MasterCount = 2      ���� ??? �Ƿ�����            
    patternBomb ը   
        MasterCount : 1    
            SlaveCount  = 0  �Ĵ�һ  
*)
  // ����
  PPlayCard     = ^TPlayCard;
  TPlayCard     = packed record
    UserId      : Byte;
    Count       : Byte;
    CardWeightValue   : Word;
    PatternCard : TPatternCard;
    // ����� 20 ��
    Cards       : array[0..20 - 1] of TPokerClassCard;
  end;
  
  function CheckCardPattern(APlayCard: PPlayCard): Boolean;

  // APrevPlayCard �ϼҳ�����
  function GetCardHint(APrevPlayCard: PPlayCard; AOutputCard: PPlayCard): Boolean;

implementation

function CheckCardPattern(APlayCard: PPlayCard): Boolean;
begin
  Result := false;
  if nil = APlayCard then
    exit;
  // APlayCard has be sorted
  if 1 = APlayCard.Count then
  begin
    APlayCard.PatternCard.Pattern := patternSingle;
    APlayCard.PatternCard.MasterCount := 1;
    APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    exit;
  end;              
  if 2 = APlayCard.Count then
  begin
    if (pokerClassKing = APlayCard.Cards[0].MainClass) or
       (pokerClassQueen = APlayCard.Cards[0].MainClass) then
    begin
      APlayCard.PatternCard.Pattern := patternBomb;
    end else
    begin
      APlayCard.PatternCard.Pattern := patternDouble; 
      APlayCard.PatternCard.MasterCount := 1;
      APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    end;
    exit;
  end;   
  if 3 = APlayCard.Count then
  begin   
    APlayCard.PatternCard.Pattern := patternTriple; 
    APlayCard.PatternCard.MasterCount := 1;
    APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    exit;
  end;
end;

// APrevPlayCard play card by last player
function GetCardHint(APrevPlayCard: PPlayCard; AOutputCard: PPlayCard): Boolean;
begin
  Result := false;
  if nil = APrevPlayCard then
    exit;
  if nil = AOutputCard then
    exit;
end;

end.
