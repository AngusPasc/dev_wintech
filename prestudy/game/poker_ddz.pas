unit poker_ddz;

interface

{ doudizhu }

uses
  define_Poker;

(*
    // 1. shuffle
    // 2. Dealing, Deing, Licensing
    //    洗牌Shuffle. 发牌Deing 盲注TheBlinds
    //    发双牌 Double deal
    //    发假牌 Crooked deal
    // 3. 抢庄 hog [ 底牌+3 , 起始出牌位置 ]
    // 4. 回合 round
          牌型 Suit patterns 牌型 Suit placing 花色长度
               1: [1]
               2: [2]  [王炸]
               3: [3*1]
               4: [3*1 + 1] [4*1 (炸)] 
               5: [3*1 + 2*1 三一对] [4*1 + 1] [1*5 (顺子)]
               6: [3*2 (飞机)] [2*3 (三连对)]  [1*6 (顺子)]
               7: [1*7 (顺子)]
               8: [1*8 (顺子)] [3*2 + 1*1 + 1*1 飞机]
               9: [1*9 (顺子)]               
               10:[1*10 (顺子)] [3*2 + 2*2 飞机]
          后出者 出牌权重 + 1

          王炸 最大
          4 * 1

          A vs B
          n * v [number * value]
          Value =  ((n div 4) + 1)

          规则
          Value B > Value A 不能相等或小于

          1. 是否是炸
             1.1 炸
             1.2 不是炸 比较牌型一致
          
    // 5. 算分 结算 Settlement balance

    顺子最大 11 张 从 3 到 K 从 4 到 A
    
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
        MasterCount = 1  单张
        MasterCount > 1  顺子
    patternDouble
        MasterCount = 1  一对
        MasterCount > 2  连对
            SlaveCount  = 0
    patternTriple         
        MasterCount = 1
            SlaveCount  = 0  三张
            SlaveCount  = 1  三带一
            SlaveCount  = 2  三带一对
        MasterCount > 1   n
            SlaveCount  = 0  飞机
            SlaveCount  = n * 1  飞机
            SlaveCount  = n * 2  飞机
    patternFour     
        MasterCount = 1    
            SlaveCount  = 1  四带一    
            SlaveCount  = 2  四带二
        MasterCount = 2      连四 ??? 是否允许            
    patternBomb 炸   
        MasterCount : 1    
            SlaveCount  = 0  四带一  
*)
  // 出牌
  PPlayCard         = ^TPlayCard; // 22 * 4 = 88 字节
  TPlayCard         = packed record
    UserId          : Byte;  // 1
    Count           : Byte;  // 1   -- 2
    CardWeightValue : Word;  // 2   -- 4
    PatternCard     : TPatternCard;  // 4
    // 最大牌 20 张
    Cards           : array[0..20 - 1] of TPokerPlayCard; // 4 字节
  end;

  // 发消息的时候 就可以排好序发

  function CheckCardPattern(APlayCard: PPlayCard): Boolean;

  // APrevPlayCard 上家出的牌
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
  // 大于4 都是某种形式的 顺子
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
