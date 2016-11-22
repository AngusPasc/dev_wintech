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
  TPatternCard  = packed record  // 4
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
  PPlayCard         = ^TPlayCard; // 22 * 4 = 88 �ֽ�
  TPlayCard         = packed record
    UserId          : Byte;  // 1
    Count           : Byte;  // 1   -- 2
    CardWeightValue : Word;  // 2   -- 4
    PatternCard     : TPatternCard;  // 4
    // ����� 20 ��
    Cards           : array[0..20 - 1] of TPokerPlayCard; // 4 �ֽ�
  end;

  // ����Ϣ��ʱ�� �Ϳ����ź���

  function CheckCardPattern(APlayCard: PPlayCard): Boolean;

  // APrevPlayCard �ϼҳ�����
  function GetCardHint(APrevPlayCard: PPlayCard; AOutputCard: PPlayCard): Boolean;

implementation

function InternalCheckCardPattern_Card1(APlayCard: PPlayCard): Boolean; inline;
begin
  Result := true;
  APlayCard.PatternCard.Pattern := patternSingle;
  APlayCard.PatternCard.MasterCount := 1;
  APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].ClassCard.SubPoint;
end;

function InternalCheckCardPattern_Card2(APlayCard: PPlayCard): Boolean; inline;
begin           
  Result := false;
  if (pokerClassQueen = APlayCard.Cards[0].ClassCard.MainClass) and
     (pokerClassKing = APlayCard.Cards[1].ClassCard.MainClass) then
  begin        
    Result := true;
    APlayCard.PatternCard.Pattern := patternBomb;
    exit;
  end;
  if (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) then
  begin
    Result := true;
    APlayCard.PatternCard.Pattern := patternDouble;
    APlayCard.PatternCard.MasterCount := 1;
    APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].ClassCard.SubPoint;
  end;
end;
                
function InternalCheckCardPattern_Card3(APlayCard: PPlayCard): Boolean; inline;
begin
  Result := false;                       
  if (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) and
     (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[2].ClassCard.SubPoint) then
  begin
    APlayCard.PatternCard.Pattern := patternTriple;
    APlayCard.PatternCard.MasterCount := 1;
    APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].ClassCard.SubPoint;
  end;
end;
                             
function InternalCheckCardPattern_Card4(APlayCard: PPlayCard): Boolean; inline;
begin
  Result := false;                   
  if (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) and
     (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[2].ClassCard.SubPoint) and
     (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[3].ClassCard.SubPoint) then
  begin
    Result := true;
    APlayCard.PatternCard.Pattern := patternBomb;
    APlayCard.PatternCard.MasterCount := 1;
    APlayCard.PatternCard.MasterStart := APlayCard.Cards[0].ClassCard.SubPoint;
    exit;
  end;     
  if (APlayCard.Cards[1].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) then
  begin
    if (APlayCard.Cards[0].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) then
    begin
      APlayCard.PatternCard.Pattern := patternTriple;
      APlayCard.PatternCard.MasterCount := 1;
      APlayCard.PatternCard.MasterStart := APlayCard.Cards[1].ClassCard.SubPoint;
      APlayCard.PatternCard.SlaveCount := 1;     
      Result := true;
    end else if (APlayCard.Cards[3].ClassCard.SubPoint = APlayCard.Cards[1].ClassCard.SubPoint) then
    begin
      APlayCard.PatternCard.Pattern := patternTriple;
      APlayCard.PatternCard.MasterCount := 1;
      APlayCard.PatternCard.MasterStart := APlayCard.Cards[1].ClassCard.SubPoint;
      APlayCard.PatternCard.SlaveCount := 1;    
      Result := true;
    end;
  end;
end;

function CheckCardPattern(APlayCard: PPlayCard): Boolean;
begin
  Result := false;
  if nil = APlayCard then
    exit;                 
  if 1 > APlayCard.Count then
    exit;
  // APlayCard has be sorted   
  APlayCard.PatternCard.Pattern := patternUnknown;
  APlayCard.PatternCard.SlaveCount := 0;
  if 1 = APlayCard.Count then
  begin
    Result := InternalCheckCardPattern_Card1(APlayCard);
    exit;
  end;              
  if 2 = APlayCard.Count then
  begin
    Result := InternalCheckCardPattern_Card2(APlayCard);
    exit;
  end;
  if 3 = APlayCard.Count then
  begin
    Result := InternalCheckCardPattern_Card3(APlayCard);       
    exit;
  end;    
  if 4 = APlayCard.Count then
  begin
    Result := InternalCheckCardPattern_Card4(APlayCard);    
    exit;
  end;
  // ����4 ����ĳ����ʽ�� ˳��
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
