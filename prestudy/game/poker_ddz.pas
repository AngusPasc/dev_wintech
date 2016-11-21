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

    // 5. 算分 结算 Settlement balance
*)
implementation

end.
