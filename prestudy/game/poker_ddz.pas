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
  TPatternCard  = packed record
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
  PPlayCard     = ^TPlayCard;
  TPlayCard     = packed record
    UserId      : Byte;
    Count       : Byte;
    CardWeightValue   : Word;
    PatternCard : TPatternCard;
    // 最大牌 20 张
    Cards       : array[0..20 - 1] of TPokerClassCard;
  end;
  
  function CheckCardPattern(APlayCard: PPlayCard): Boolean;

  // APrevPlayCard 上家出的牌
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
