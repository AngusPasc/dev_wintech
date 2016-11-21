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
  PPlayCard   = ^TPlayCard;
  TPlayCard   = record
    Count     : Byte;
    Cards     : array of TPokerClassCard;
  end;
  
  function CheckCardPattern(APlayCard: PPlayCard; APatternCard: PPatternCard): Boolean;

implementation

function CheckCardPattern(APlayCard: PPlayCard; APatternCard: PPatternCard): Boolean;
begin
  Result := false;
  if nil = APlayCard then
    exit;
  if nil = APatternCard then
    exit;
  if 1 = APlayCard.Count then
  begin
    APatternCard.Pattern := patternSingle;
    APatternCard.MasterCount := 1;
    APatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    exit;
  end;              
  if 2 = APlayCard.Count then
  begin
    if (pokerClassKing = APlayCard.Cards[0].MainClass) or
       (pokerClassQueen = APlayCard.Cards[0].MainClass) then
    begin
      APatternCard.Pattern := patternBomb;
    end else
    begin
      APatternCard.Pattern := patternDouble; 
      APatternCard.MasterCount := 1;
      APatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    end;
    exit;
  end;   
  if 3 = APlayCard.Count then
  begin   
    APatternCard.Pattern := patternTriple; 
    APatternCard.MasterCount := 1;
    APatternCard.MasterStart := APlayCard.Cards[0].SubPoint;
    exit;
  end;
end;

end.
