unit define_MaJiang;

interface

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
