unit define_MaJiang;

interface

uses
  define_card;
  
{
  一副完整的麻将牌共152张

  风牌：东、南、西、北，各4张，共16张
  箭牌：中、发、白，各4张，共12张
  花牌  春、夏、秋、冬，梅、兰、竹、菊，各一张，共8张
  序数牌（合计108张）
      万子牌：从一万至九万，各4张，共36张
      筒子牌：从一筒至九筒，各4张，共36张
      索子牌：从一索至九索，各4张，共36张
  百搭牌（合计8张）
      财神、猫、老鼠、聚宝盆各一张，百搭牌4张，共8张
}

(*
  胡牌算法

  用二维数组检查位置
  先找有 个并排的  double 一对的 
  0 1 1 1 0 0 1 0 1 1
  0 0 1 0 0 0 0 0 0 0
  0 0 1 0 0 0 0 0 0 0
  0 0 1 0 0 0 0 0 0 0

  有精表示 可以 放置在任意位置
*)

(*//
  南昌麻将
  http://baike.baidu.com/link?url=7RqyXer_j1Ic-rz5FZsWxp8J1N6VDQLyQEsitSHa1ua8lJTrejvXz1IrhuTGAnSsyXtGx1aWarIfrUSh4vEfnLEtTBpfqe7o9SISub7Xx2ELvRYdwHRIFW_PpE0drSSu
  共计136张 108 + 16 + 12

  1.顺子 中发白 123 234     吃  只允许对上家刚打出的牌进行
  2.刻子 333 222 111        碰  比吃牌优先
  3.将牌 一对头
  4.杠子 四张               杠  明杠和暗杠，简称“杠” 比吃牌优先
  ---------------------------------------------------------
  胡牌   一对头”加“四副牌
  截胡   南昌麻将只允许一家胡牌，没有一炮多响。如有一人以上同时表示胡牌时
         从打牌者按逆时针方向，顺序在前者被定
  自摸
  放炮
  弃胡
  海底与流局
  抄庄：在开局第一圈，庄家出的第一张牌，三个闲家在第一圈每人都出一张
  诈胡： 没有胡牌而推倒手牌宣告胡牌者
  ---------------------------------------------------------
  精：精就是万能牌、百搭牌或者癞子
      翻开的牌为一万，即一、二万为精，其中一万为正精，二万为副精
      翻开的为九万，则九万是正，而一万为副

  坐庄  
  ---------------------------------------------------------
  01.自摸：X2
  02.庄家：X2
  03.点炮：点炮者X2
  04.抢杠：X2。可视作自摸，即他家加杠之牌（手上已碰出一刻子，摸进第四张相同的牌进行加杠）是我方所胡之牌，此时抢杠成立，原有的杠牌动作中止且不算分。抢杠只能发生在加杠动作中，暗杠明杠不算。
  05.杠开：X2。由于可视作自摸，所以实际上是X4。即开杠后在牌山末尾补进的牌恰好使自己胡牌，可与精钓、德国等重复计算。
  06.天胡：一家20子。 庄家起手14张满足胡牌条件，视为天和，并且不计算庄家、自摸等翻倍条件。精钓天胡计作40子。
  07.地胡：一家20子。庄家打出第一块牌使得闲家胡牌，视为地胡。地胡三家都需给付，并且不计算庄家、点炮等翻倍条件。 起手形成精钓的牌型的地胡为40子。
  08.精钓：X2。自摸翻倍另算，可与其他牌型重复计算。
  09.大七对：X2。碰碰胡，即胡牌时牌型为4副刻子/杠子+1对头。刻子/杠子没有门清要求，可随意碰、杠。可与其他牌型重复计算。
  10.小七对：X2。胡牌时手中凑齐7个对子，可以有2对相同的牌（若发生暗杠动作则七对子不成立）。七对子必须门清，不能吃碰杠。可与其他牌型重复计算。
  11.十三烂：X2。玩家手中的任意两张“万、筒、条”的序数牌之间都不能靠牌或重复（包括147、148、149、158、159、169、258、259、269、369），风牌、三元牌任意两两间不重复（此时东南西北、中发白不再视作顺子）。满足此要求的牌型成为十三烂。十三烂必须门清，不能有吃碰杠。可与其他牌型重复计算。
  12.七星十三烂：X4。在十三烂的胡牌时，凑齐东南西北中发白。如有精牌参与则只能做本身含义解释。
  13.德国：自摸时为每家X2+5；否则点炮者X2+5，非点炮者X2。精还原时算作德国，精牌分数依然计算。可与其他牌型重复计算。
  14.德中德：自摸时为每家X4+5；否则点炮者X4+5，非点炮者X4。可与其他牌型重复计算
  ---------------------------------------------------------
//*)
type
  TStatus_MaJiang = (
    mj_Unknown,
    mj_Shuffle,
    mj_Desk,
    mj_Hold
  );
  // P1 person1 hold
  // P2 person2 hold
  // P3 person3 hold
  // P4 person4 hold

  TMjMainClass = (
    mjClassUnknown,
    mjClassNone,
    mjClassWan,  // 36 张
    mjClassTong, // 36
    mjClassTiao, // 36 -- 108
    mjClassFeng, // 16 -- 124
    mjClassJian, // 12 -- 136
    mjClassHua,  // 8 -- 144
    mjClassJoker // 8 -- 152           
  );

  TMjClassCard  = packed record
    MainClass   : TMjMainClass;
    SubPoint    : Byte;
  end;
           
  PCards_Mj     = ^TCards_Mj;
  TCards_Mj     = packed record
    CardCount   : Byte;
    Card        : array[FirstCardIndex..FirstCardIndex + 151] of TCardRecord;
  end;
                         
  function CheckOutCards_Mj: PCards_Mj;
  function GetMJMainClass(ACardMj: Byte): TMjMainClass;
  function GetMJCaption(ACardMj: Byte): string;
  
implementation

uses
  SysUtils;

function CheckOutCards_Mj: PCards_Mj;
begin
  Result := System.New(PCards_Mj);
  FillChar(Result^, SizeOf(TCards_Mj), 0);  
  Result.CardCount := High(Result.Card) - Low(Result.Card) + 1;
  //**InitCards(PCards(Result));
end;
                
function GetMJMainClass(ACardMj: Byte): TMjMainClass;
var
  tmpClassIndex: integer;
  tmpIndex: integer;
  tmpPoint: integer;
begin
  Result := mjClassNone;
  tmpIndex := (ACardMj + 3) div 4;
  tmpClassIndex := (tmpIndex + 8) div 9;
  tmpPoint := (tmpIndex + 8) mod 9 + 1;
  case tmpClassIndex of
    1: begin
      Result := mjClassWan;
    end;
    2: begin
      Result := mjClassTong;
    end;
    3: begin
      Result := mjClassTiao;
    end;
    4: begin        
      tmpIndex := (ACardMj + 3) mod 4;
      case tmpPoint of
        1: Result := mjClassFeng;
        2: Result := mjClassFeng;
        3: Result := mjClassFeng;
        4: Result := mjClassFeng;
        5: Result := mjClassJian;
        6: Result := mjClassJian;
        7: Result := mjClassJian;
        // 春、夏、秋、冬，梅、兰、竹、菊
        8: Result := mjClassHua;
        9: Result := mjClassHua;
      end;
    end;
    5: begin
      // 百搭牌（合计8张）
      tmpIndex := (ACardMj + 3) mod 4;
      case tmpPoint of
        1: Result := mjClassJoker;
        2: Result := mjClassJoker;
      end;
    end;
  end;
end;

function GetMJCaption(ACardMj: Byte): string;
var
  tmpClassIndex: integer;
  tmpIndex: integer;
  tmpPoint: integer;
begin
  Result := '';
  tmpIndex := (ACardMj + 3) div 4;
  tmpClassIndex := (tmpIndex + 8) div 9;
  tmpPoint := (tmpIndex + 8) mod 9 + 1;
  case tmpClassIndex of
    1: begin
      Result := IntToStr(tmpPoint) + 'W';
    end;
    2: begin
      Result := IntToStr(tmpPoint) + 'O';
    end;
    3: begin
      Result := IntToStr(tmpPoint) + 'I';
    end;
    4: begin        
      tmpIndex := (ACardMj + 3) mod 4;
      case tmpPoint of
        1: Result := IntToStr(tmpIndex) + '东';
        2: Result := IntToStr(tmpIndex) + '南';
        3: Result := IntToStr(tmpIndex) + '西';
        4: Result := IntToStr(tmpIndex) + '北';
        5: Result := IntToStr(tmpIndex) + '中';
        6: Result := IntToStr(tmpIndex) + '发';
        7: Result := IntToStr(tmpIndex) + '白';
        // 春、夏、秋、冬，梅、兰、竹、菊
        8: Result := IntToStr(tmpIndex) + 'A';
        9: Result := IntToStr(tmpIndex) + 'B';
      end;
    end;
    5: begin
      // 百搭牌（合计8张）
      tmpIndex := (ACardMj + 3) mod 4;
      case tmpPoint of
        1: Result := IntToStr(tmpIndex) + 'C';
        2: Result := IntToStr(tmpIndex) + 'D';
      end;
    end;
  end;
end;

(*
  for i := 1 to 152 do
  begin
    tmpInt := (i + 3);
    tmpIntD4 := (i + 3) div 4;
    // tmpMainType:
    //   1万子
    //   2筒子
    //   3索子 条
    //   4:  tmpSubType:
    //         1:  东
    //         2:  南
    //         3:  西
    //         4:  北
    //         5:  中
    //         6:  发
    //         7:  白
    //         8:  春、夏、秋、冬，
    //         9:  梅、兰、竹、菊
    tmpMainType := (tmpIntD4 + 8) div 9;
    tmpSubType := (tmpIntD4 + 8) mod 9;

    Memo1.Lines.Add(IntToStr(i) + ':' + IntToStr(tmpIntD4) + ' -- ' +
      IntToStr(tmpInt mod 4) + ' -- ' +
      IntToStr(tmpMainType) + ' -- ' +
      IntToStr(tmpSubType + 1));
  end;
*)
end.
