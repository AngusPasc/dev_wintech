unit define_MaJiang;

interface

uses
  define_card;
  
{
  һ���������齫�ƹ�152��

  ���ƣ������ϡ�����������4�ţ���16��
  ���ƣ��С������ף���4�ţ���12��
  ����  �����ġ������÷�������񡢾գ���һ�ţ���8��
  �����ƣ��ϼ�108�ţ�
      �����ƣ���һ�������򣬸�4�ţ���36��
      Ͳ���ƣ���һͲ����Ͳ����4�ţ���36��
      �����ƣ���һ������������4�ţ���36��
  �ٴ��ƣ��ϼ�8�ţ�
      ����è�����󡢾۱����һ�ţ��ٴ���4�ţ���8��
}

(*
  �����㷨

  �ö�ά������λ��
  ������ �����ŵ�  double һ�Ե� 
  0 1 1 1 0 0 1 0 1 1
  0 0 1 0 0 0 0 0 0 0
  0 0 1 0 0 0 0 0 0 0
  0 0 1 0 0 0 0 0 0 0

  �о���ʾ ���� ����������λ��
*)

(*//
  �ϲ��齫
  http://baike.baidu.com/link?url=7RqyXer_j1Ic-rz5FZsWxp8J1N6VDQLyQEsitSHa1ua8lJTrejvXz1IrhuTGAnSsyXtGx1aWarIfrUSh4vEfnLEtTBpfqe7o9SISub7Xx2ELvRYdwHRIFW_PpE0drSSu
  ����136�� 108 + 16 + 12

  1.˳�� �з��� 123 234     ��  ֻ������ϼҸմ�����ƽ���
  2.���� 333 222 111        ��  �ȳ�������
  3.���� һ��ͷ
  4.���� ����               ��  ���ܺͰ��ܣ���ơ��ܡ� �ȳ�������
  ---------------------------------------------------------
  ����   һ��ͷ���ӡ��ĸ���
  �غ�   �ϲ��齫ֻ����һ�Һ��ƣ�û��һ�ڶ��졣����һ������ͬʱ��ʾ����ʱ
         �Ӵ����߰���ʱ�뷽��˳����ǰ�߱���
  ����
  ����
  ����
  ����������
  ��ׯ���ڿ��ֵ�һȦ��ׯ�ҳ��ĵ�һ���ƣ������м��ڵ�һȦÿ�˶���һ��
  թ���� û�к��ƶ��Ƶ��������������
  ---------------------------------------------------------
  ���������������ơ��ٴ��ƻ������
      ��������Ϊһ�򣬼�һ������Ϊ��������һ��Ϊ����������Ϊ����
      ������Ϊ�����������������һ��Ϊ��

  ��ׯ  
  ---------------------------------------------------------
  01.������X2
  02.ׯ�ң�X2
  03.���ڣ�������X2
  04.���ܣ�X2�������������������ҼӸ�֮�ƣ�����������һ���ӣ�������������ͬ���ƽ��мӸܣ����ҷ�����֮�ƣ���ʱ���ܳ�����ԭ�еĸ��ƶ�����ֹ�Ҳ���֡�����ֻ�ܷ����ڼӸܶ����У��������ܲ��㡣
  05.�ܿ���X2�����ڿ���������������ʵ������X4�������ܺ�����ɽĩβ��������ǡ��ʹ�Լ����ƣ����뾫�����¹����ظ����㡣
  06.�����һ��20�ӡ� ׯ������14�����������������Ϊ��ͣ����Ҳ�����ׯ�ҡ������ȷ��������������������40�ӡ�
  07.�غ���һ��20�ӡ�ׯ�Ҵ����һ����ʹ���мҺ��ƣ���Ϊ�غ����غ����Ҷ�����������Ҳ�����ׯ�ҡ����ڵȷ��������� �����γɾ��������͵ĵغ�Ϊ40�ӡ�
  08.������X2�������������㣬�������������ظ����㡣
  09.���߶ԣ�X2����������������ʱ����Ϊ4������/����+1��ͷ������/����û������Ҫ�󣬿����������ܡ��������������ظ����㡣
  10.С�߶ԣ�X2������ʱ���д���7�����ӣ�������2����ͬ���ƣ����������ܶ������߶��Ӳ����������߶��ӱ������壬���ܳ����ܡ��������������ظ����㡣
  11.ʮ���ã�X2��������е��������š���Ͳ��������������֮�䶼���ܿ��ƻ��ظ�������147��148��149��158��159��169��258��259��269��369�������ơ���Ԫ�����������䲻�ظ�����ʱ�����������з��ײ�������˳�ӣ��������Ҫ������ͳ�Ϊʮ���á�ʮ���ñ������壬�����г����ܡ��������������ظ����㡣
  12.����ʮ���ã�X4����ʮ���õĺ���ʱ�����붫�������з��ס����о��Ʋ�����ֻ������������͡�
  13.�¹�������ʱΪÿ��X2+5�����������X2+5���ǵ�����X2������ԭʱ�����¹������Ʒ�����Ȼ���㡣�������������ظ����㡣
  14.���е£�����ʱΪÿ��X4+5�����������X4+5���ǵ�����X4���������������ظ�����
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
    mjClassWan,  // 36 ��
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
        // �����ġ������÷�������񡢾�
        8: Result := mjClassHua;
        9: Result := mjClassHua;
      end;
    end;
    5: begin
      // �ٴ��ƣ��ϼ�8�ţ�
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
        1: Result := IntToStr(tmpIndex) + '��';
        2: Result := IntToStr(tmpIndex) + '��';
        3: Result := IntToStr(tmpIndex) + '��';
        4: Result := IntToStr(tmpIndex) + '��';
        5: Result := IntToStr(tmpIndex) + '��';
        6: Result := IntToStr(tmpIndex) + '��';
        7: Result := IntToStr(tmpIndex) + '��';
        // �����ġ������÷�������񡢾�
        8: Result := IntToStr(tmpIndex) + 'A';
        9: Result := IntToStr(tmpIndex) + 'B';
      end;
    end;
    5: begin
      // �ٴ��ƣ��ϼ�8�ţ�
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
    //   1����
    //   2Ͳ��
    //   3���� ��
    //   4:  tmpSubType:
    //         1:  ��
    //         2:  ��
    //         3:  ��
    //         4:  ��
    //         5:  ��
    //         6:  ��
    //         7:  ��
    //         8:  �����ġ������
    //         9:  ÷�������񡢾�
    tmpMainType := (tmpIntD4 + 8) div 9;
    tmpSubType := (tmpIntD4 + 8) mod 9;

    Memo1.Lines.Add(IntToStr(i) + ':' + IntToStr(tmpIntD4) + ' -- ' +
      IntToStr(tmpInt mod 4) + ' -- ' +
      IntToStr(tmpMainType) + ' -- ' +
      IntToStr(tmpSubType + 1));
  end;
*)
end.
