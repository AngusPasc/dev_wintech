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

implementation

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
