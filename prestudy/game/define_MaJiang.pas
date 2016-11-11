unit define_MaJiang;

interface

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

  function GetMJMainClass(ACardMj: Byte): TMjMainClass;
  function GetMJCaption(ACardMj: Byte): string;
  
implementation

uses
  SysUtils;
                
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
