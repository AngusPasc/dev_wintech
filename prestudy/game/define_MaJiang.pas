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

implementation

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
